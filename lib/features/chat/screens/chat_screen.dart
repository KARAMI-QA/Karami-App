import 'dart:async';

import 'package:flutter/material.dart';
import 'package:karami_app/models/chat_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:karami_app/core/constants/api_constants.dart';
import 'package:karami_app/core/services/chat_service.dart';
import 'package:karami_app/core/services/auth_service.dart';
import 'package:karami_app/shared/widgets/loading_indicator.dart';
import 'package:karami_app/models/message_models.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String? chatName;
  final String? otherParticipantName;
  final String? otherParticipantImage;
  final bool isGroupChat;

  const ChatScreen({
    super.key,
    required this.chatId,
    this.chatName,
    this.otherParticipantName,
    this.otherParticipantImage,
    this.isGroupChat = false,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSending = false;
  bool _initialized = false;
  late ChatService _chatService;
  int _lastMessageCount = 0;
  bool _shouldAutoScroll = true;
  bool _isUserScrolling = false;
  Timer? _userScrollTimer;
  Timer? _autoScrollCheckTimer;

  @override
  void initState() {
    super.initState();
    print('🚀 ChatScreen initialized for chat: ${widget.chatId}');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeChat();
    });
  }

  Future<void> _initializeChat() async {
    if (_initialized) return;

    try {
      final chatService = Provider.of<ChatService>(context, listen: false);
      _chatService = chatService;

      _chatService.selectChat(widget.chatId);
      await _loadMessages();

      // Setup auto-scroll detection
      _setupAutoScrollDetection();

      _initialized = true;
    } catch (e) {
      print('❌ Error initializing chat screen: $e');
    }
  }

  void _setupAutoScrollDetection() {
    // Listen for scroll events to detect user interaction
    _scrollController.addListener(() {
      if (_scrollController.hasClients) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentScroll = _scrollController.position.pixels;

        // Check if user is near the bottom (within 100 pixels)
        final isNearBottom = (maxScroll - currentScroll) <= 100;

        if (!isNearBottom) {
          // User is scrolling up (not near bottom)
          _isUserScrolling = true;
          _shouldAutoScroll = false;

          // Reset timer when user scrolls
          if (_userScrollTimer != null && _userScrollTimer!.isActive) {
            _userScrollTimer!.cancel();
          }

          // After 2 seconds of no scrolling near bottom, allow auto-scroll again
          _userScrollTimer = Timer(const Duration(seconds: 2), () {
            _isUserScrolling = false;
          });
        } else {
          // User is at or near bottom
          _isUserScrolling = false;
          _shouldAutoScroll = true;
        }
      }
    });

    // Periodically check for new messages and auto-scroll if needed
    _autoScrollCheckTimer =
        Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (_shouldAutoScroll && !_isUserScrolling && mounted) {
        final currentMessages = _chatService.getMessages(widget.chatId);
        if (currentMessages.length > _lastMessageCount) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom(animated: true);
          });
          _lastMessageCount = currentMessages.length;
        }
      }
    });
  }

  @override
  void dispose() {
    print('🛑 ChatScreen disposing for chat: ${widget.chatId}');

    _messageController.dispose();
    _scrollController.dispose();
    _chatService.markAsDelivered(widget.chatId);

    _userScrollTimer?.cancel();
    _autoScrollCheckTimer?.cancel();

    super.dispose();
  }

  void _scrollToBottom({bool animated = true}) {
    if (_scrollController.hasClients && mounted) {
      final maxScroll = _scrollController.position.maxScrollExtent;

      if (animated) {
        _scrollController.animateTo(
          maxScroll,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else {
        _scrollController.jumpTo(maxScroll);
      }
    }
  }

  Future<void> _loadMessages() async {
    try {
      print('📨 Loading messages for chat: ${widget.chatId}');

      final currentMessages = _chatService.getMessages(widget.chatId);
      _lastMessageCount = currentMessages.length;
      print('📊 Current cached messages count: ${currentMessages.length}');

      await _chatService.loadMessages(widget.chatId);

      final updatedMessages = _chatService.getMessages(widget.chatId);
      _lastMessageCount = updatedMessages.length;
      print('📊 Updated messages count: ${updatedMessages.length}');

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom(animated: false);
      });
    } catch (e) {
      print('❌ Error loading messages: $e');
    }
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty || _isSending) return;

    setState(() {
      _isSending = true;
    });

    try {
      await _chatService.sendMessage(
        chatId: widget.chatId,
        content: message,
      );

      _messageController.clear();

      // Force focus to keep keyboard open
      FocusScope.of(context).requestFocus(FocusNode());
      Future.delayed(const Duration(milliseconds: 50), () {
        _scrollToBottom();
      });
    } catch (e) {
      print('❌ ChatScreen send error: $e');
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to send message: $e'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  String _formatMessageTime(DateTime dateTime) {
    return DateFormat('h:mm a').format(dateTime);
  }

  // In ChatScreen, create helper methods:
  String _getChatName() {
    // If chat name is provided, use it
    if (widget.chatName != null && widget.chatName!.isNotEmpty) {
      return widget.chatName!;
    }

    // If otherParticipantName is provided, use it
    if (widget.otherParticipantName != null &&
        widget.otherParticipantName!.isNotEmpty) {
      return widget.otherParticipantName!;
    }

    // Try to get from chat service
    try {
      final chatService = Provider.of<ChatService>(context, listen: false);
      final chat = chatService.chats.firstWhere(
        (c) => c.id == widget.chatId,
        orElse: () => Chat(
          id: widget.chatId,
          name: 'Chat',
          type: widget.isGroupChat ? 'GROUP' : 'DIRECT',
          participants: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isActive: true,
        ),
      );

      // For direct chats, find other participant's name
      if (chat.type == 'DIRECT' && chat.name == null) {
        final authService = Provider.of<AuthService>(context, listen: false);
        final currentUserId = authService.currentUser?.id ?? '';

        // Try otherParticipant field first
        if (chat.otherParticipant != null &&
            chat.otherParticipant!.name != null) {
          return chat.otherParticipant!.name!;
        }

        // Try to find in participants
        for (final participant in chat.participants) {
          if (participant.id != currentUserId) {
            return participant.name ?? 'Unknown User';
          }
        }
      }

      return chat.name ?? (widget.isGroupChat ? 'Group Chat' : 'Chat');
    } catch (e) {
      print('Error getting chat name: $e');
      return widget.isGroupChat ? 'Group Chat' : 'Chat';
    }
  }

  String? _getParticipantImage() {
    // If image is provided, use it
    if (widget.otherParticipantImage != null &&
        widget.otherParticipantImage!.isNotEmpty) {
      return widget.otherParticipantImage;
    }

    // For direct chats, try to get from chat service
    if (!widget.isGroupChat) {
      try {
        final chatService = Provider.of<ChatService>(context, listen: false);
        final chat = chatService.chats.firstWhere(
          (c) => c.id == widget.chatId,
          orElse: () => Chat(
            id: widget.chatId,
            name: 'Chat',
            type: 'DIRECT',
            participants: [],
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            isActive: true,
          ),
        );

        // Try otherParticipant field first
        if (chat.otherParticipant != null &&
            chat.otherParticipant!.image != null) {
          return chat.otherParticipant!.image;
        }

        // Try to find in participants
        final authService = Provider.of<AuthService>(context, listen: false);
        final currentUserId = authService.currentUser?.id ?? '';

        for (final participant in chat.participants) {
          if (participant.id != currentUserId) {
            return participant.image;
          }
        }
      } catch (e) {
        print('Error getting participant image: $e');
      }
    }

    return null;
  }

  String _getDayHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) return 'Today';
    if (messageDate == yesterday) return 'Yesterday';
    return DateFormat('MMMM d, yyyy').format(date);
  }

  Widget _buildMessageBubble(
      Message message, bool isCurrentUser, bool isDarkMode) {
    final messageTime = _formatMessageTime(message.createdAt);

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 2,
          top: 2,
          left: isCurrentUser ? 64 : 8,
          right: isCurrentUser ? 8 : 64,
        ),
        child: Column(
          crossAxisAlignment:
              isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Sender name for group chats (non-current user messages)
            if (widget.isGroupChat && !isCurrentUser)
              Container(
                margin: const EdgeInsets.only(bottom: 4, left: 12, top: 4),
                child: Text(
                  message.sender?.name ?? 'Unknown',
                  style: TextStyle(
                    color: _getColorForSender(message.senderId ?? ''),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

            // Message bubble
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              decoration: BoxDecoration(
                color: isCurrentUser
                    ? (isDarkMode
                        ? const Color(0xFF005C4B)
                        : const Color(0xFFD9FDD3))
                    : (isDarkMode ? const Color(0xFF202C33) : Colors.white),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(8),
                  topRight: const Radius.circular(8),
                  bottomLeft: isCurrentUser
                      ? const Radius.circular(8)
                      : const Radius.circular(0),
                  bottomRight: isCurrentUser
                      ? const Radius.circular(0)
                      : const Radius.circular(8),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 1,
                    spreadRadius: 0.5,
                    offset: const Offset(0, 0.5),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 6,
              ),
              child: IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Message content
                    Text(
                      message.content ?? '',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: isCurrentUser
                                ? (isDarkMode ? Colors.white : Colors.black87)
                                : (isDarkMode ? Colors.white : Colors.black87),
                            fontSize: 14.5,
                            height: 1.35,
                          ),
                    ),
                    const SizedBox(height: 2),

                    // Time and status row
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(width: 4),
                        Text(
                          messageTime,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: isCurrentUser
                                        ? (isDarkMode
                                            ? const Color(0xFFAFB8BA)
                                            : const Color(0xFF667781))
                                        : (isDarkMode
                                            ? const Color(0xFFAFB8BA)
                                            : const Color(0xFF667781)),
                                    fontSize: 11,
                                  ),
                        ),
                        if (isCurrentUser) ...[
                          const SizedBox(width: 4),
                          Icon(
                            message.status == 'SEEN'
                                ? Icons.done_all
                                : message.status == 'DELIVERED'
                                    ? Icons.done_all
                                    : Icons.done,
                            size: 16,
                            color: message.status == 'SEEN'
                                ? const Color(0xFF53BDEB)
                                : (isDarkMode
                                    ? const Color(0xFFAFB8BA)
                                    : const Color(0xFF667781)),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForSender(String senderId) {
    final colors = [
      const Color(0xFFE91E63),
      const Color(0xFF9C27B0),
      const Color(0xFF673AB7),
      const Color(0xFF3F51B5),
      const Color(0xFF2196F3),
      const Color(0xFF00BCD4),
      const Color(0xFF009688),
      const Color(0xFF4CAF50),
      const Color(0xFFFF9800),
      const Color(0xFFFF5722),
    ];

    final hash = senderId.hashCode;
    return colors[hash.abs() % colors.length];
  }

  Widget _buildMessageInput(bool isDarkMode) {
    final hasText = _messageController.text.trim().isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode
            ? Theme.of(context).appBarTheme.backgroundColor
            : const Color(0xFFF0F2F5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      padding: const EdgeInsets.only(
        left: 2,
        right: 2,
        top: 6,
        bottom: 30,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: Theme.of(context).iconTheme.color?.withOpacity(0.6) ??
                  (isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600),
              size: 30,
            ),
            onPressed: _showAttachmentMenu,
          ),
          // Message input field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF2A3942) : Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  // Text field
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 16,
                          ),
                      decoration: InputDecoration(
                        hintText: 'Message',
                        hintStyle:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey.shade500,
                                  fontSize: 16,
                                ),
                        filled: true,
                        fillColor: isDarkMode
                            ? Colors.grey.shade800
                            : Colors.grey.shade200,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      maxLines: 6,
                      minLines: 1,
                      onChanged: (text) {
                        setState(() {});
                      },
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // const SizedBox(width: 6),

          // Camera and Mic/Send buttons - tighter spacing when both visible
          if (!hasText)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    Icons.camera_alt,
                    color:
                        Theme.of(context).iconTheme.color?.withOpacity(0.6) ??
                            (isDarkMode
                                ? Colors.grey.shade400
                                : Colors.grey.shade600),
                    size: 24,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    Icons.mic,
                    color:
                        Theme.of(context).iconTheme.color?.withOpacity(0.6) ??
                            (isDarkMode
                                ? Colors.grey.shade400
                                : Colors.grey.shade600),
                    size: 24,
                  ),
                  onPressed: null,
                  onLongPress: () {},
                ),
              ],
            )

          // Row(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     GestureDetector(
          //       onTap: () {
          //         // camera action
          //       },
          //       child: Icon(
          //         Icons.camera_alt,
          //         color:
          //             Theme.of(context).iconTheme.color?.withOpacity(0.6) ??
          //                 (isDarkMode
          //                     ? Colors.grey.shade400
          //                     : Colors.grey.shade600),
          //         size: 24,
          //       ),
          //     ),
          //     SizedBox(width: 8), // exact spacing
          //     GestureDetector(
          //       onLongPress: () {
          //         // voice recording
          //       },
          //       child: Icon(
          //         Icons.mic,
          //         color:
          //             Theme.of(context).iconTheme.color?.withOpacity(0.6) ??
          //                 (isDarkMode
          //                     ? Colors.grey.shade400
          //                     : Colors.grey.shade600),
          //         size: 24,
          //       ),
          //     ),
          //   ],
          // )
          else
            _isSending
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : IconButton(
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      Icons.send,
                      color:
                          Theme.of(context).iconTheme.color?.withOpacity(0.6) ??
                              (isDarkMode
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade600),
                      size: 24,
                    ),
                    onPressed: _sendMessage,
                  ),
        ],
      ),
    );
  }

  void _showAttachmentMenu() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildAttachmentBottomSheet(isDarkMode),
    );
  }

  Widget _buildAttachmentBottomSheet(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E2B33) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color:
                      isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const SizedBox(height: 24),

              // First row of options
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildAttachmentOption(
                      icon: Icons.insert_drive_file,
                      label: 'Document',
                      color: const Color(0xFF7F66FF),
                      isDarkMode: isDarkMode,
                    ),
                    _buildAttachmentOption(
                      icon: Icons.camera_alt,
                      label: 'Camera',
                      color: const Color(0xFFFF1744),
                      isDarkMode: isDarkMode,
                    ),
                    _buildAttachmentOption(
                      icon: Icons.photo_library,
                      label: 'Gallery',
                      color: const Color(0xFF7B1FA2),
                      isDarkMode: isDarkMode,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Second row of options
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildAttachmentOption(
                      icon: Icons.headset,
                      label: 'Audio',
                      color: const Color(0xFFF50057),
                      isDarkMode: isDarkMode,
                    ),
                    _buildAttachmentOption(
                      icon: Icons.location_on,
                      label: 'Location',
                      color: const Color(0xFF00BFA5),
                      isDarkMode: isDarkMode,
                    ),
                    _buildAttachmentOption(
                      icon: Icons.person,
                      label: 'Contact',
                      color: const Color(0xFF2979FF),
                      isDarkMode: isDarkMode,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required Color color,
    required bool isDarkMode,
  }) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        // TODO: Implement attachment action
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 90,
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 26),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDarkMode ? Colors.white : Colors.black87,
                    fontSize: 13,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.translucent,
      child: Consumer<ChatService>(
        builder: (context, chatService, child) {
          return Consumer<AuthService>(
            builder: (context, authService, child) {
              final currentUserId = authService.currentUser?.id ?? '';
              final messages = chatService.getMessages(widget.chatId);
              final isLoading = chatService.isLoadingMessages(widget.chatId);
              final isDarkMode =
                  Theme.of(context).brightness == Brightness.dark;

              // Check for new messages and auto-scroll if needed
              // This runs on every rebuild when messages change
              if (messages.length > _lastMessageCount && _shouldAutoScroll) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom(animated: true);
                });
                _lastMessageCount = messages.length;
              }

              return Scaffold(
                backgroundColor: isDarkMode
                    ? const Color(0xFF0B141A)
                    : const Color(0xFFEFE7DD),
                appBar: _buildAppBar(isDarkMode),
                body: Column(
                  children: [
                    // Messages list
                    Expanded(
                      child: isLoading && messages.isEmpty
                          ? const Center(child: LoadingIndicator())
                          : messages.isEmpty
                              ? _buildEmptyState(isDarkMode)
                              : _buildMessagesList(
                                  messages, currentUserId, isDarkMode),
                    ),

                    // Message input
                    _buildMessageInput(isDarkMode),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isDarkMode) {
    final chatName = _getChatName();
    final participantImage = _getParticipantImage();
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      elevation: 0,
      leadingWidth: 96,
      titleSpacing: 0,
      leading: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          GestureDetector(
            onTap: () {
              // TODO: Show profile picture or group info
            },
            child: !widget.isGroupChat && participantImage != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(
                      '${ApiConstants.orginalBaseUrlForImage}$participantImage',
                    ),
                    radius: 18,
                  )
                : CircleAvatar(
                    backgroundColor: Theme.of(context).hintColor,
                    radius: 18,
                    child: Icon(
                      widget.isGroupChat ? Icons.group : Icons.person,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
          ),
        ],
      ),
      title: InkWell(
        onTap: () {
          // TODO: Show chat info
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              chatName,
              style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
                    fontSize: 18,
                  ),
            ),
            Text(
              widget.isGroupChat
                  ? 'Tap for group info'
                  : 'tap here for contact info',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFFD1D7DB),
                    fontSize: 13,
                  ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.videocam, color: Colors.white, size: 26),
          onPressed: () {
            // TODO: Implement video call
          },
        ),
        IconButton(
          icon: const Icon(Icons.call, color: Colors.white, size: 22),
          onPressed: () {
            // TODO: Implement voice call
          },
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          color: isDarkMode ? const Color(0xFF2A3942) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          itemBuilder: (context) => <PopupMenuEntry<String>>[
            _buildPopupMenuItem(
                'View contact', Icons.person_outline, isDarkMode),
            _buildPopupMenuItem(
                'Media, links, and docs', Icons.image_outlined, isDarkMode),
            _buildPopupMenuItem('Search', Icons.search, isDarkMode),
            _buildPopupMenuItem(
                'Mute notifications', Icons.volume_off_outlined, isDarkMode),
            _buildPopupMenuItem(
                'Wallpaper', Icons.wallpaper_outlined, isDarkMode),
            const PopupMenuDivider(),
            _buildPopupMenuItem('Clear chat', Icons.delete_outline, isDarkMode),
            _buildPopupMenuItem(
                'Export chat', Icons.upload_outlined, isDarkMode),
            _buildPopupMenuItem('Block', Icons.block, isDarkMode),
            _buildPopupMenuItem(
                'Report', Icons.thumb_down_outlined, isDarkMode),
          ],
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(
    String text,
    IconData icon,
    bool isDarkMode,
  ) {
    return PopupMenuItem<String>(
      value: text,
      child: Row(
        children: [
          Icon(
            icon,
            color: isDarkMode ? Colors.white70 : Colors.black87,
            size: 20,
          ),
          const SizedBox(width: 16),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDarkMode ? Colors.white : Colors.black87,
                  fontSize: 15,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 100,
            color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade400,
          ),
          const SizedBox(height: 24),
          Text(
            'No messages yet',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color:
                      isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                  fontSize: 20,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.isGroupChat
                ? 'Send a message to start the conversation'
                : 'Say hi to ${widget.otherParticipantName ?? 'start chatting'}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color:
                      isDarkMode ? Colors.grey.shade500 : Colors.grey.shade500,
                  fontSize: 14,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList(
      List<Message> messages, String currentUserId, bool isDarkMode) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isCurrentUser = message.senderId == currentUserId;

        DateTime messageDate = message.createdAt;
        DateTime? previousMessageDate;

        if (index > 0) {
          previousMessageDate = messages[index - 1].createdAt;
        }

        final showDayHeader = previousMessageDate == null ||
            _getDayHeader(previousMessageDate) != _getDayHeader(messageDate);

        return Column(
          children: [
            if (showDayHeader)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? const Color(0xFF182229)
                      : const Color(0xFFFFFFFF).withOpacity(0.95),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Text(
                  _getDayHeader(messageDate),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDarkMode
                            ? const Color(0xFF8696A0)
                            : const Color(0xFF667781),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            _buildMessageBubble(message, isCurrentUser, isDarkMode),
          ],
        );
      },
    );
  }
}
