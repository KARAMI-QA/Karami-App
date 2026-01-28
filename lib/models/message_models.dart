import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:karami_app/models/chat_model.dart';

class MessageSender {
  final String id;
  final String? name;
  final String? email;
  final String? image;

  MessageSender({
    required this.id,
    this.name,
    this.email,
    this.image,
  });

  factory MessageSender.fromJson(Map<String, dynamic> json) {
    return MessageSender(
      id: json['id'].toString(),
      name: json['name'],
      email: json['email'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'image': image,
    };
  }
}

class MessageRead {
  final String userId;
  final DateTime readAt;

  MessageRead({
    required this.userId,
    required this.readAt,
  });

  factory MessageRead.fromJson(Map<String, dynamic> json) {
    return MessageRead(
      userId: json['user_id'].toString(),
      readAt: DateTime.parse(json['read_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'read_at': readAt.toIso8601String(),
    };
  }
}

class Message {
  final String id;
  final String chatId;
  final String senderId;
  final String? content;
  final String? mediaUrl;
  final String mediaType;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final MessageSender? sender;
  final List<MessageRead>? readBy;
  final Chat? chat;

  Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    this.content,
    this.mediaUrl,
    required this.mediaType,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.sender,
    this.readBy,
    this.chat,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    // Parse sender
    MessageSender? sender;
    if (json['sender'] != null) {
      try {
        if (json['sender'] is Map<String, dynamic>) {
          // If sender is already a Map
          sender = MessageSender.fromJson(json['sender']);
        } else if (json['sender'] is String) {
          // If sender is a JSON string
          final parsed = jsonDecode(json['sender'] as String);
          sender = MessageSender.fromJson(parsed);
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error parsing sender: $e');
          print('Sender value: ${json['sender']}');
        }
      }
    }

    Chat? chat;
    if (json['chat'] != null) {
      try {
        if (json['chat'] is Map<String, dynamic>) {
          // You'll need to import your Chat model
          chat = Chat.fromJson(json['chat']);
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error parsing chat in message: $e');
        }
      }
    }

    // Parse readBy
    final readBy = <MessageRead>[];
    if (json['read_by'] != null) {
      try {
        if (json['read_by'] is List) {
          for (var r in json['read_by']) {
            if (r is Map<String, dynamic>) {
              readBy.add(MessageRead.fromJson(r));
            } else if (r is String) {
              final parsed = jsonDecode(r as String);
              readBy.add(MessageRead.fromJson(parsed));
            }
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error parsing read_by: $e');
          print('read_by value: ${json['read_by']}');
        }
      }
    }

    // Safely parse dates
    DateTime parseDate(dynamic dateValue) {
      try {
        if (dateValue is String) {
          return DateTime.parse(dateValue);
        } else if (dateValue is DateTime) {
          return dateValue;
        } else {
          return DateTime.now();
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error parsing date $dateValue: $e');
        }
        return DateTime.now();
      }
    }

    return Message(
        id: json['id']?.toString() ?? '',
        chatId: json['chat_id']?.toString() ?? '',
        senderId: json['sender_id']?.toString() ?? '',
        content: json['content'],
        mediaUrl: json['media_url'],
        mediaType: json['media_type'] ?? 'NONE',
        status: json['status'] ?? 'SENT',
        createdAt: parseDate(json['created_at']),
        updatedAt: parseDate(json['updated_at']),
        sender: sender,
        readBy: readBy.isEmpty ? null : readBy,
        chat: chat);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_id': chatId,
      'sender_id': senderId,
      'content': content,
      'media_url': mediaUrl,
      'media_type': mediaType,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'sender': sender?.toJson(),
      'read_by': readBy?.map((r) => r.toJson()).toList(),
    };
  }

  bool get hasMedia => mediaType != 'NONE' && mediaUrl != null;
  bool get isImage => mediaType == 'IMAGE';
  bool get isVideo => mediaType == 'VIDEO';
  bool get isAudio => mediaType == 'AUDIO';
  bool get isDocument => mediaType == 'DOCUMENT';
  bool get isSent => status == 'SENT';
  bool get isDelivered => status == 'DELIVERED';
  bool get isSeen => status == 'SEEN';
}
