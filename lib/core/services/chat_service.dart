import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:karami_app/core/services/api_service.dart';
import 'package:karami_app/models/chat_model.dart';
import 'package:karami_app/models/message_models.dart';
import '../utils/storage.dart';
import '../../graphql/queries/chat_queries.dart';
import '../../graphql/mutations/chat_mutations.dart';

class ChatService with ChangeNotifier {
  StreamSubscription<QueryResult>? _messageSubscription;
  final List<Chat> _chats = [];
  final Map<String, List<Message>> _chatMessages = {};
  final Map<String, DateTime> _lastMessageSync = {};
  final Map<String, bool> _isLoadingMessages = {};
  bool _isLoading = false;
  String? _selectedChatId;
  bool _disposed = false;
  GraphQLClient? _client;
  bool _initialized = false;

  static const String _messagesStorageKey = 'cached_messages';
  static const String _lastSyncStorageKey = 'last_message_sync';

  List<Chat> get chats => _chats;
  bool get isLoading => _isLoading;
  String? get selectedChatId => _selectedChatId;
  bool get isInitialized => _initialized;

  Future<GraphQLClient> getClient() async {
    _client ??= await ApiService.createClient();
    return _client!;
  }

  List<Message> getMessages(String chatId) {
    return _chatMessages[chatId]?.toList() ?? [];
  }

  bool isLoadingMessages(String chatId) {
    return _isLoadingMessages[chatId] ?? false;
  }

  Future<void> initialize() async {
    if (_initialized) return;

    print('🚀 ChatService: Initializing...');
    await _loadCachedMessages();
    await loadUserChats();
    await setupMessageSubscription();

    _initialized = true;
    notifyListeners();
  }

  Future<void> _loadCachedMessages() async {
    try {
      final cachedMessagesJson = await Storage.getString(_messagesStorageKey);
      if (cachedMessagesJson != null) {
        final Map<String, dynamic> cachedData = json.decode(cachedMessagesJson);

        for (final entry in cachedData.entries) {
          final chatId = entry.key;
          final messagesJson = entry.value as List;
          final messages =
              messagesJson.map((msg) => Message.fromJson(msg)).toList();
          _chatMessages[chatId] = messages;
        }
        print('📦 Loaded cached messages for ${cachedData.length} chats');
      }

      final lastSyncJson = await Storage.getString(_lastSyncStorageKey);
      if (lastSyncJson != null) {
        final Map<String, dynamic> syncData = json.decode(lastSyncJson);
        for (final entry in syncData.entries) {
          _lastMessageSync[entry.key] = DateTime.parse(entry.value);
        }
      }
    } catch (e) {
      print('❌ Error loading cached messages: $e');
    }
  }

  Future<void> _saveMessagesToCache() async {
    try {
      final Map<String, dynamic> messagesToCache = {};

      for (final entry in _chatMessages.entries) {
        final chatId = entry.key;
        final messages = entry.value;
        messagesToCache[chatId] = messages.map((msg) => msg.toJson()).toList();
      }

      await Storage.setString(
          _messagesStorageKey, json.encode(messagesToCache));

      final Map<String, dynamic> syncToCache = {};
      for (final entry in _lastMessageSync.entries) {
        syncToCache[entry.key] = entry.value.toIso8601String();
      }

      await Storage.setString(_lastSyncStorageKey, json.encode(syncToCache));
    } catch (e) {
      print('❌ Error saving messages to cache: $e');
    }
  }

  // Setup only message subscription
  Future<void> setupMessageSubscription() async {
    print('🔌 Setting up message subscription...');

    try {
      final token = await Storage.getToken();
      if (token == null) {
        print('❌ No token available for subscription');
        return;
      }

      _client ??= await ApiService.createClient();
      print('✅ GraphQL client created');

      await _setupMessageSubscription(token);

      print('✅ Message subscription active');
    } catch (e) {
      print('❌ Error setting up message subscription: $e');
    }
  }

  Future<void> _setupMessageSubscription(String token) async {
    print('🔌 Setting up message subscription');

    try {
      final subscription = gql('''
      subscription MessageReceived(\$userToken: String!) {
        messageReceived(userToken: \$userToken) {
          id
          chat_id
          sender_id
          content
          media_url
          media_type
          status
          created_at
          updated_at
          sender {
            id
            name
            email
            image
          }
          chat {
            id
            name
            type
            last_message_id
            last_message_at
            participants {
              id
              name
              email
              image
              is_online
            }
            other_participant {
              id
              name
              email
              image
              is_online
            }
          }
        }
      }
    ''');

      final stream = _client!.subscribe(
        SubscriptionOptions(
          document: subscription,
          variables: {'userToken': token},
        ),
      );

      _messageSubscription = stream.listen(
        (result) {
          print(
              '📡 Message subscription received data: ${result.data != null}');

          if (result.hasException) {
            print('❌ Message subscription error: ${result.exception}');
            _resubscribeMessage(token);
            return;
          }

          final messageData = result.data?['messageReceived'];
          if (messageData != null) {
            print('✅✅✅ NEW MESSAGE VIA SUBSCRIPTION!');
            try {
              final message = Message.fromJson(messageData);
              _handleNewMessage(message);
            } catch (e) {
              print('❌ Error parsing message: $e');
            }
          }
        },
        onError: (error) {
          print('❌ Message subscription stream error: $error');
          _resubscribeMessage(token);
        },
        onDone: () {
          print('✅ Message subscription stream done - resubscribing...');
          _resubscribeMessage(token);
        },
      );

      print('✅ Message subscription setup complete');
    } catch (e) {
      print('❌ Error setting up message subscription: $e');
      Future.delayed(const Duration(seconds: 3), () {
        _setupMessageSubscription(token);
      });
    }
  }

  void _resubscribeMessage(String token) {
    print('🔄 Attempting to resubscribe to messages...');
    _messageSubscription?.cancel();
    Future.delayed(const Duration(seconds: 1), () {
      _setupMessageSubscription(token);
    });
  }

  Future<List<Message>> loadMessages(String chatId, {int limit = 50}) async {
    try {
      _isLoadingMessages[chatId] = true;
      notifyListeners();

      final token = await Storage.getToken();
      final client = await getClient();

      final result = await client.query(
        QueryOptions(
          document: gql(ChatQueries.chatGetMessages),
          variables: {
            'userToken': token,
            'chatId': chatId,
            'limit': limit,
            'offset': 0,
          },
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception!.graphqlErrors.first.message);
      }

      final messagesData = result.data?['chatGetMessages']['messages'] as List?;
      final serverMessages = <Message>[];

      if (messagesData != null) {
        for (var messageData in messagesData) {
          serverMessages.add(Message.fromJson(messageData));
        }
      }

      final cachedMessages = _chatMessages[chatId] ?? [];
      final allMessages = _mergeMessages(cachedMessages, serverMessages);

      allMessages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

      _chatMessages[chatId] = allMessages;
      _lastMessageSync[chatId] = DateTime.now();
      _isLoadingMessages[chatId] = false;

      await _saveMessagesToCache();

      notifyListeners();
      return allMessages;
    } catch (e) {
      _isLoadingMessages[chatId] = false;
      notifyListeners();
      rethrow;
    }
  }

  List<Message> _mergeMessages(List<Message> cached, List<Message> server) {
    final Map<String, Message> merged = {};

    for (final message in cached) {
      merged[message.id] = message;
    }

    for (final message in server) {
      merged[message.id] = message;
    }

    return merged.values.toList();
  }

  void _handleNewMessage(Message message) {
    print('🔄 ChatService: Handling new message for chat: ${message.chatId}');

    // Add message to chat messages list
    if (!_chatMessages.containsKey(message.chatId)) {
      _chatMessages[message.chatId] = [];
    }

    final existingIndex =
        _chatMessages[message.chatId]!.indexWhere((m) => m.id == message.id);

    if (existingIndex == -1) {
      _chatMessages[message.chatId]!.add(message);
      print('✅ Message added to chat ${message.chatId}');
    } else {
      _chatMessages[message.chatId]![existingIndex] = message;
      print('✅ Message updated in chat ${message.chatId}');
    }

    // Sort messages chronologically
    _chatMessages[message.chatId]!
        .sort((a, b) => a.createdAt.compareTo(b.createdAt));

    // Save to cache
    _saveMessagesToCache();

    // Update or add chat in chat list
    _updateChatListWithMessage(message);

    // Notify listeners
    notifyListeners();
  }

  void _updateChatListWithMessage(Message message) {
    print('🔄 Updating chat list with new message for chat: ${message.chatId}');

    final chatIndex = _chats.indexWhere((chat) => chat.id == message.chatId);

    if (chatIndex != -1) {
      // Update existing chat
      final existingChat = _chats[chatIndex];

      // IMPORTANT: Ensure we have the correct otherParticipant data
      // If message contains chat data with participants, use it
      Chat updatedChat;
      if (message.chat != null) {
        // Use the updated chat data from the message
        updatedChat = message.chat!;

        // Update last message info
        final chatLastMessage = ChatLastMessage(
          id: message.id,
          content: message.content,
          mediaUrl: message.mediaUrl,
          mediaType: message.mediaType,
          senderId: message.senderId,
          senderName: message.sender?.name,
          createdAt: message.createdAt,
        );

        updatedChat = updatedChat.copyWith(
          lastMessage: chatLastMessage,
          lastMessageAt: message.createdAt,
          updatedAt: DateTime.now(),
          // Increment unread count if this chat is not selected
          unreadCount: message.chatId != _selectedChatId
              ? (existingChat.unreadCount ?? 0) + 1
              : 0,
        );
      } else {
        // Keep existing chat but update last message
        final chatLastMessage = ChatLastMessage(
          id: message.id,
          content: message.content,
          mediaUrl: message.mediaUrl,
          mediaType: message.mediaType,
          senderId: message.senderId,
          senderName: message.sender?.name,
          createdAt: message.createdAt,
        );

        updatedChat = existingChat.copyWith(
          lastMessage: chatLastMessage,
          lastMessageAt: message.createdAt,
          updatedAt: DateTime.now(),
          // Increment unread count if this chat is not selected
          unreadCount: message.chatId != _selectedChatId
              ? (existingChat.unreadCount ?? 0) + 1
              : 0,
        );
      }

      _chats[chatIndex] = updatedChat;

      // Move chat to top if not current chat
      if (message.chatId != _selectedChatId) {
        final chat = _chats.removeAt(chatIndex);
        _chats.insert(0, chat);
        print('✅ Moved chat ${message.chatId} to top of list');
      }
    } else {
      // If chat not in list and message contains chat data, add it
      if (message.chat != null) {
        final newChat = message.chat!.copyWith(
          lastMessage: ChatLastMessage(
            id: message.id,
            content: message.content,
            mediaUrl: message.mediaUrl,
            mediaType: message.mediaType,
            senderId: message.senderId,
            senderName: message.sender?.name,
            createdAt: message.createdAt,
          ),
          lastMessageAt: message.createdAt,
          unreadCount: 1,
        );

        _chats.insert(0, newChat);
        print('✅ Added new chat ${message.chatId} to list from message');
      } else {
        // Otherwise refresh from server
        print(
            '⚠️ Chat ${message.chatId} not found in chat list - refreshing...');
        loadUserChats();
      }
    }
  }

  Future<void> loadUserChats() async {
    try {
      _isLoading = true;
      notifyListeners();

      final token = await Storage.getToken();
      final client = await getClient();

      final result = await client.query(
        QueryOptions(
          document: gql(ChatQueries.chatGetUserChats),
          variables: {'userToken': token},
        ),
      );

      if (result.hasException) {
        if (result.exception!.graphqlErrors.isNotEmpty) {
          throw Exception(result.exception!.graphqlErrors.first.message);
        } else {
          throw Exception(result.exception.toString());
        }
      }

      final chatsData = result.data?['chatGetUserChats'] as List?;
      _chats.clear();

      if (chatsData != null) {
        for (var chatData in chatsData) {
          final chat = Chat.fromJson(chatData);

          // Debug logging
          print('Loaded chat: ${chat.id}');
          print('  Name: ${chat.name}');
          print('  Type: ${chat.type}');
          print('  Other participant: ${chat.otherParticipant?.name}');
          print('  Participants: ${chat.participants.length}');

          _chats.add(chat);
        }
      }

      _chats.sort((a, b) {
        final aTime = a.lastMessageAt ?? a.updatedAt;
        final bTime = b.lastMessageAt ?? b.updatedAt;
        return bTime.compareTo(aTime);
      });

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<Message> sendMessage({
    required String chatId,
    required String content,
    String? receiverId,
    String? mediaUrl,
    String mediaType = 'NONE',
  }) async {
    try {
      final token = await Storage.getToken();
      final client = await getClient();

      print('📤 ChatService: Sending message: $content to chat: $chatId');

      final variables = {
        'userToken': token,
        'input': {
          'chat_id': chatId,
          'content': content,
          'media_url': mediaUrl ?? 'null',
          'media_type': mediaType,
          if (receiverId != null) 'receiver_id': receiverId,
        },
      };

      final result = await client.mutate(
        MutationOptions(
          document: gql(ChatMutations.chatSendMessage),
          variables: variables,
        ),
      );

      if (result.hasException) {
        for (var error in result.exception!.graphqlErrors) {
          print('   - ${error.message}');
        }
        throw Exception(result.exception!.graphqlErrors.first.message);
      }

      final messageData = result.data?['chatSendMessage'];
      if (messageData == null) {
        throw Exception('No message data received from server');
      }

      final message = Message.fromJson(messageData);
      print('✅ ChatService: Message sent: ${message.id}');

      // Add message to UI immediately
      _handleNewMessage(message);

      return message;
    } catch (e) {
      print('❌ ChatService: Error in sendMessage: $e');
      rethrow;
    }
  }

  void disposeSubscriptions() {
    _messageSubscription?.cancel();
    _messageSubscription = null;
    print('🛑 ChatService message subscription disposed');
  }

  @override
  void dispose() {
    _disposed = true;
    disposeSubscriptions();
    super.dispose();
  }

  Future<Chat> createDirectChat(String otherUserId) async {
    try {
      final token = await Storage.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final client = await getClient();

      print('🆕 Creating direct chat with user: $otherUserId');

      final result = await client.mutate(
        MutationOptions(
          document: gql(ChatMutations.chatCreateDirectChat),
          variables: {
            'userToken': token,
            'otherUserId': otherUserId,
          },
          fetchPolicy: FetchPolicy.noCache,
        ),
      );

      if (result.hasException) {
        if (result.exception!.graphqlErrors.isNotEmpty) {
          print(
              '❌ GraphQL error: ${result.exception!.graphqlErrors.first.message}');
          throw Exception(result.exception!.graphqlErrors.first.message);
        } else {
          print('❌ Network error: ${result.exception}');
          throw Exception('Network error: ${result.exception}');
        }
      }

      final chatData = result.data?['chatCreateDirectChat'];
      if (chatData == null) {
        throw Exception('No chat data received from server');
      }

      print('✅ Chat created successfully: ${chatData['id']}');

      // Parse the response
      final chat = Chat.fromJson(chatData);

      // Check if chat already exists in the list
      final existingIndex = _chats.indexWhere((c) => c.id == chat.id);

      if (existingIndex != -1) {
        // Update existing chat
        _chats[existingIndex] = chat;
        print('🔄 Updated existing chat in list');
      } else {
        // Add new chat to the beginning of the chats list
        _chats.insert(0, chat);
        print('✅ Added new chat to list');
      }

      // Sort chats by last message date
      _chats.sort((a, b) {
        final aTime = a.lastMessageAt ?? a.updatedAt;
        final bTime = b.lastMessageAt ?? b.updatedAt;
        return bTime.compareTo(aTime);
      });

      // Notify listeners
      notifyListeners();

      // Save to cache
      await _saveMessagesToCache();

      return chat;
    } catch (e) {
      print('❌ Error creating direct chat: $e');
      rethrow;
    }
  }

  Future<void> markAsDelivered(String chatId) async {
    try {
      final token = await Storage.getToken();
      final client = await getClient();

      await client.mutate(
        MutationOptions(
          document: gql(ChatMutations.chatMarkAsDelivered),
          variables: {
            'userToken': token,
            'chatId': chatId,
          },
        ),
      );

      // Update local unread count
      final index = _chats.indexWhere((c) => c.id == chatId);
      if (index != -1 && index < _chats.length) {
        final chat = _chats[index];
        _chats[index] = chat.copyWith(unreadCount: 0);
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('ChatService: Error marking as delivered: $e');
      }
    }
  }

  Future<void> markAsSeen(String messageId) async {
    try {
      final token = await Storage.getToken();
      final client = await getClient();

      await client.mutate(
        MutationOptions(
          document: gql(ChatMutations.chatMarkAsSeen),
          variables: {
            'userToken': token,
            'messageId': messageId,
          },
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('ChatService: Error marking as seen: $e');
      }
    }
  }

  void selectChat(String? chatId) {
    _selectedChatId = chatId;

    if (chatId != null) {
      markAsDelivered(chatId);
    }

    notifyListeners();
  }

  void clearCache() {
    _chats.clear();
    _chatMessages.clear();
    _isLoadingMessages.clear();
    _lastMessageSync.clear();

    Storage.remove(_messagesStorageKey);
    Storage.remove(_lastSyncStorageKey);

    notifyListeners();
  }

  void clearChatCache(String chatId) {
    _chatMessages.remove(chatId);
    _lastMessageSync.remove(chatId);
    _isLoadingMessages.remove(chatId);

    _saveMessagesToCache();
    notifyListeners();
  }
}
