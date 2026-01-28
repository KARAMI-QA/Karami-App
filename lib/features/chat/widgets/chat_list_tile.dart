import 'package:flutter/material.dart';
import 'package:karami_app/core/constants/api_constants.dart';
import 'package:karami_app/models/chat_model.dart';

class ChatListTile extends StatelessWidget {
  final Chat chat;
  final String currentUserId;
  final VoidCallback onTap;

  const ChatListTile({
    super.key,
    required this.chat,
    required this.currentUserId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final hasUnread = chat.unreadCount != null && chat.unreadCount! > 0;

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF111B21) : Colors.white,
          border: Border(
            bottom: BorderSide(
              color: isDarkMode
                  ? const Color(0xFF1F2C34)
                  : const Color(0xFFE9EDEF),
              width: 0.5,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              // Avatar
              Stack(
                children: [
                  _buildAvatar(context),
                  // Online indicator (optional - uncomment if you have online status)
                  // Positioned(
                  //   bottom: 0,
                  //   right: 0,
                  //   child: Container(
                  //     width: 15,
                  //     height: 15,
                  //     decoration: BoxDecoration(
                  //       color: const Color(0xFF25D366),
                  //       shape: BoxShape.circle,
                  //       border: Border.all(
                  //         color: isDarkMode ? const Color(0xFF111B21) : Colors.white,
                  //         width: 2.5,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(width: 14),

              // Chat info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildTitle(context, hasUnread, isDarkMode),
                        ),
                        const SizedBox(width: 8),
                        _buildTimestamp(context, isDarkMode, hasUnread),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Expanded(
                          child: _buildSubtitle(context, hasUnread, isDarkMode),
                        ),
                        if (hasUnread) ...[
                          const SizedBox(width: 8),
                          _buildUnreadBadge(context),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    if (chat.type == 'GROUP') {
      return Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          color: Theme.of(context).hintColor,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.group,
          color: Colors.white,
          size: 28,
        ),
      );
    }

    final otherParticipant = chat.otherParticipant;
    if (otherParticipant != null && otherParticipant.image != null) {
      return Container(
        width: 54,
        height: 54,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: ClipOval(
          child: Image.network(
            '${ApiConstants.orginalBaseUrlForImage}${otherParticipant.image!}',
            width: 54,
            height: 54,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildDefaultAvatar(context);
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return _buildDefaultAvatar(context);
            },
          ),
        ),
      );
    }

    return _buildDefaultAvatar(context);
  }

  Widget _buildDefaultAvatar(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: Theme.of(context).hintColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          _getInitials(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context, bool hasUnread, bool isDarkMode) {
    String title = chat.name ?? '';

    // For direct chats, ensure we show the other participant's name
    if (chat.type == 'DIRECT') {
      if (title.isEmpty) {
        // Try to get from otherParticipant
        final otherParticipant = chat.otherParticipant;
        if (otherParticipant != null && otherParticipant.name != null) {
          title = otherParticipant.name!;
        } else if (chat.participants.isNotEmpty) {
          // Find the participant who is NOT the current user
          for (final participant in chat.participants) {
            if (participant.id != currentUserId) {
              title = participant.name ?? 'Unknown User';
              break;
            }
          }
        }

        // If still empty, use generic name
        if (title.isEmpty) {
          title = 'Direct Chat';
        }
      }
    }

    // Debug logging
    print('ChatListTile - Building title:');
    print('  Chat ID: ${chat.id}');
    print('  Chat type: ${chat.type}');
    print('  Chat name: ${chat.name}');
    print(
        '  Other participant: ${chat.otherParticipant?.name} (ID: ${chat.otherParticipant?.id})');
    print('  Current user ID: $currentUserId');
    print(
        '  Participants: ${chat.participants.map((p) => '${p.name} (${p.id})').join(', ')}');
    print('  Final title: $title');

    return Text(
      title,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: 16.5,
            fontWeight: hasUnread ? FontWeight.w600 : FontWeight.w500,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildSubtitle(BuildContext context, bool hasUnread, bool isDarkMode) {
    final lastMessage = chat.lastMessage;
    String subtitle = '';
    IconData? prefixIcon;

    if (lastMessage != null) {
      // Handle media types
      if (lastMessage.mediaType != 'NONE') {
        final mediaTypes = {
          'IMAGE': (Icons.camera_alt, 'Photo'),
          'VIDEO': (Icons.videocam, 'Video'),
          'AUDIO': (Icons.mic, 'Audio'),
          'DOCUMENT': (Icons.insert_drive_file, 'Document'),
        };
        final mediaInfo = mediaTypes[lastMessage.mediaType];
        if (mediaInfo != null) {
          prefixIcon = mediaInfo.$1;
          subtitle = mediaInfo.$2;
        }
      } else {
        subtitle = lastMessage.content ?? '';
      }

      // Add sender name for group chats
      if (chat.type == 'GROUP' && lastMessage.senderId != currentUserId) {
        final senderName = lastMessage.senderName;
        if (senderName != null) {
          subtitle = '$senderName: $subtitle';
        }
      }

      // Add "You: " prefix for current user's messages
      if (lastMessage.senderId == currentUserId) {
        subtitle = 'You: $subtitle';
      }
    }

    return Row(
      children: [
        // Delivery status for sender
        if (lastMessage?.senderId == currentUserId)
          // Padding(
          //   padding: const EdgeInsets.only(right: 4),
          //   child: Icon(
          //     lastMessage?.status == 'SEEN'
          //         ? Icons.done_all
          //         : lastMessage?.status == 'DELIVERED'
          //             ? Icons.done_all
          //             : Icons.done,
          //     size: 16,
          //     color: lastMessage?.status == 'SEEN'
          //         ? const Color(0xFF53BDEB)
          //         : (isDarkMode
          //             ? const Color(0xFF8696A0)
          //             : const Color(0xFF667781)),
          //   ),
          // ),
          // Media icon
          if (prefixIcon != null)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Icon(
                prefixIcon,
                size: 16,
                color: isDarkMode
                    ? const Color(0xFF8696A0)
                    : const Color(0xFF667781),
              ),
            ),
        // Subtitle text
        Expanded(
          child: Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14.5,
                  fontWeight: hasUnread ? FontWeight.w500 : FontWeight.normal,
                  color: hasUnread
                      ? (isDarkMode
                          ? const Color(0xFFD1D7DB)
                          : const Color(0xFF111B21))
                      : (isDarkMode
                          ? const Color(0xFF8696A0)
                          : const Color(0xFF667781)),
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildTimestamp(
      BuildContext context, bool isDarkMode, bool hasUnread) {
    if (chat.lastMessageAt == null) return const SizedBox.shrink();

    return Text(
      _formatTime(chat.lastMessageAt!),
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: 12,
            color: hasUnread
                ? Theme.of(context).hintColor
                : (isDarkMode
                    ? const Color(0xFF8696A0)
                    : const Color(0xFF667781)),
            fontWeight: hasUnread ? FontWeight.w500 : FontWeight.normal,
          ),
    );
  }

  Widget _buildUnreadBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      constraints: const BoxConstraints(
        minWidth: 20,
        minHeight: 20,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).hintColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          chat.unreadCount! > 999 ? '999+' : chat.unreadCount!.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  String _getInitials() {
    String name = '';

    if (chat.type == 'GROUP') {
      name = chat.name ?? 'G';
    } else {
      final otherParticipant = chat.otherParticipant;
      name = otherParticipant?.name ?? 'U';
    }

    final parts = name.trim().split(' ');
    if (parts.length > 1) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (date == today) {
      // Show time for today's messages
      final hour = dateTime.hour;
      final minute = dateTime.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$displayHour:$minute $period';
    } else if (date == yesterday) {
      return 'Yesterday';
    } else if (now.difference(date).inDays < 7) {
      // Show day name for last week
      final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return weekdays[dateTime.weekday - 1];
    } else {
      // Show date for older messages
      return '${dateTime.day}/${dateTime.month}${dateTime.year != now.year ? '/${dateTime.year.toString().substring(2)}' : ''}';
    }
  }
}
