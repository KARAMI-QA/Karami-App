import 'dart:convert';

class ChatParticipant {
  final String id;
  final String? name;
  final String? email;
  final String? image;
  final bool isOnline;

  ChatParticipant({
    required this.id,
    this.name,
    this.email,
    this.image,
    this.isOnline = false,
  });

  factory ChatParticipant.fromJson(Map<String, dynamic> json) {
    return ChatParticipant(
      id: json['id'].toString(),
      name: json['name'],
      email: json['email'],
      image: json['image'],
      isOnline: json['is_online'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'image': image,
      'is_online': isOnline,
    };
  }
}

class ChatLastMessage {
  final String id;
  final String? content;
  final String? mediaUrl;
  final String mediaType;
  final String senderId;
  final String? senderName;
  final DateTime createdAt;

  ChatLastMessage({
    required this.id,
    this.content,
    this.mediaUrl,
    required this.mediaType,
    required this.senderId,
    this.senderName,
    required this.createdAt,
  });

  factory ChatLastMessage.fromJson(Map<String, dynamic> json) {
    return ChatLastMessage(
      id: json['id'].toString(),
      content: json['content'],
      mediaUrl: json['media_url'],
      mediaType: json['media_type'] ?? 'NONE',
      senderId: json['sender_id'].toString(),
      senderName: json['sender_name'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'media_url': mediaUrl,
      'media_type': mediaType,
      'sender_id': senderId,
      'sender_name': senderName,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class Chat {
  final String id;
  final String? name;
  final String type;
  final bool isActive;
  final String? lastMessageId;
  final DateTime? lastMessageAt;
  final String? createdBy;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ChatParticipant> participants;
  final ChatLastMessage? lastMessage;
  final int? unreadCount;
  final ChatParticipant? otherParticipant;

  Chat({
    required this.id,
    this.name,
    required this.type,
    required this.isActive,
    this.lastMessageId,
    this.lastMessageAt,
    this.createdBy,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    this.participants = const [],
    this.lastMessage,
    this.unreadCount,
    this.otherParticipant,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    print('📱 Parsing Chat JSON:');
    print('  Raw JSON keys: ${json.keys.toList()}');
    print('  id: ${json['id']}');
    print('  name: ${json['name']}');
    print('  type: ${json['type']}');
    print('  has other_participant: ${json.containsKey('other_participant')}');

    if (json['other_participant'] != null) {
      print(
          '  other_participant type: ${json['other_participant'].runtimeType}');
      if (json['other_participant'] is String) {
        print('  other_participant string: ${json['other_participant']}');
      }
    }
    // Parse participants
    final participants = <ChatParticipant>[];
    if (json['participants'] != null) {
      if (json['participants'] is String) {
        try {
          final parsed = jsonDecode(json['participants']);
          if (parsed is List) {
            for (var p in parsed) {
              participants.add(ChatParticipant.fromJson(p));
            }
          }
        } catch (e) {
          print('Error parsing participants: $e');
        }
      } else if (json['participants'] is List) {
        for (var p in json['participants']) {
          participants.add(ChatParticipant.fromJson(p));
        }
      }
    }

    // Parse last message
    ChatLastMessage? lastMessage;
    if (json['last_message'] != null) {
      if (json['last_message'] is String) {
        try {
          final parsed = jsonDecode(json['last_message']);
          lastMessage = ChatLastMessage.fromJson(parsed);
        } catch (e) {
          print('Error parsing last_message: $e');
        }
      } else if (json['last_message'] is Map) {
        lastMessage = ChatLastMessage.fromJson(json['last_message']);
      }
    }

    // Parse other participant
    ChatParticipant? otherParticipant;
    if (json['other_participant'] != null) {
      if (json['other_participant'] is String) {
        try {
          final parsed = jsonDecode(json['other_participant']);
          otherParticipant = ChatParticipant.fromJson(parsed);
        } catch (e) {
          print('Error parsing other_participant: $e');
        }
      } else if (json['other_participant'] is Map) {
        otherParticipant = ChatParticipant.fromJson(json['other_participant']);
      }
    }

    return Chat(
      id: json['id'].toString(),
      name: json['name'],
      type: json['type'] ?? 'DIRECT',
      isActive: json['is_active'] ?? true,
      lastMessageId: json['last_message_id']?.toString(),
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.parse(json['last_message_at'])
          : null,
      createdBy: json['created_by']?.toString(),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      participants: participants,
      lastMessage: lastMessage,
      unreadCount: json['unread_count'],
      otherParticipant: otherParticipant,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'is_active': isActive,
      'last_message_id': lastMessageId,
      'last_message_at': lastMessageAt?.toIso8601String(),
      'created_by': createdBy,
      'deleted_at': deletedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'participants': participants.map((p) => p.toJson()).toList(),
      'last_message': lastMessage?.toJson(),
      'unread_count': unreadCount,
      'other_participant': otherParticipant?.toJson(),
    };
  }

  Chat copyWith({
    String? id,
    String? name,
    String? type,
    bool? isActive,
    String? lastMessageId,
    DateTime? lastMessageAt,
    String? createdBy,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<ChatParticipant>? participants,
    ChatLastMessage? lastMessage,
    int? unreadCount,
    ChatParticipant? otherParticipant,
  }) {
    return Chat(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      isActive: isActive ?? this.isActive,
      lastMessageId: lastMessageId ?? this.lastMessageId,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      createdBy: createdBy ?? this.createdBy,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      participants: participants ?? this.participants,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
      otherParticipant: otherParticipant ?? this.otherParticipant,
    );
  }
}
