import 'package:flutter/material.dart';
import 'package:karami_app/features/chat/widgets/chat_list_tile.dart';
import 'package:karami_app/features/chat/screens/chat_screen.dart';
import 'package:karami_app/features/chat/widgets/employee_bottom_sheet.dart';
import 'package:provider/provider.dart';
import '../../../core/services/chat_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../shared/widgets/loading_indicator.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initializeServices();
      _loadChats();
    });
  }

  Future<void> _initializeServices() async {
    final chatService = Provider.of<ChatService>(context, listen: false);
    if (!chatService.isInitialized) {
      await chatService.initialize();
    }
  }

  Future<void> _loadChats() async {
    final chatService = Provider.of<ChatService>(context, listen: false);
    await chatService.loadUserChats();
  }

  // In _ChatListScreenState class
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Refresh when screen becomes active
    final route = ModalRoute.of(context);
    if (route != null && route.isCurrent) {
      // Screen is visible
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _refreshOnResume();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _refreshOnResume() async {
    final chatService = Provider.of<ChatService>(context, listen: false);

    // Only refresh if chats are empty or it's been a while
    if (chatService.chats.isEmpty) {
      await chatService.loadUserChats();
    }
  }

  void _showNewChatBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EmployeeBottomSheet(
        onChatCreated: (chatId) {
          // Navigate to the newly created chat
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                chatId: chatId,
                chatName: 'New Chat', // This will be updated with actual data
                otherParticipantName: '',
                otherParticipantImage: null,
                isGroupChat: false,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatService = Provider.of<ChatService>(context);
    final authService = Provider.of<AuthService>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          'Chats',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.camera_alt_outlined,
              color: Theme.of(context).appBarTheme.iconTheme?.color ??
                  Colors.white,
            ),
            onPressed: () {
              // TODO: Implement camera
            },
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              color: Theme.of(context).appBarTheme.iconTheme?.color ??
                  Colors.white,
            ),
            onPressed: () {
              // TODO: Implement search
            },
          ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).appBarTheme.iconTheme?.color ??
                  Colors.white,
            ),
            color: isDarkMode ? const Color(0xFF2A3942) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'new_group',
                child: Text(
                  'New group',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                ),
              ),
              PopupMenuItem(
                value: 'new_broadcast',
                child: Text(
                  'New broadcast',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                ),
              ),
              PopupMenuItem(
                value: 'linked_devices',
                child: Text(
                  'Linked devices',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                ),
              ),
              PopupMenuItem(
                value: 'starred',
                child: Text(
                  'Starred messages',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                ),
              ),
              PopupMenuItem(
                value: 'settings',
                child: Text(
                  'Settings',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: Theme.of(context).appBarTheme.backgroundColor,
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
            child: Container(
              decoration: BoxDecoration(
                color: isDarkMode
                    ? const Color(0xFF2A3942)
                    : Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: isDarkMode ? Colors.white : Colors.white,
                    ),
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDarkMode
                            ? const Color(0xFF8696A0)
                            : Colors.white70,
                      ),
                  prefixIcon: Icon(
                    Icons.search,
                    color:
                        isDarkMode ? const Color(0xFF8696A0) : Colors.white70,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onChanged: (value) {
                  // TODO: Implement search
                },
              ),
            ),
          ),

          // Chats List
          Expanded(
            child: Container(
              color: isDarkMode
                  ? const Color(0xFF111B21)
                  : const Color(0xFFFFFFFF),
              child: chatService.isLoading
                  ? const Center(child: LoadingIndicator())
                  : chatService.chats.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: 100,
                                color: isDarkMode
                                    ? Colors.grey.shade700
                                    : Colors.grey.shade300,
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'No chats yet',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(
                                      color: isDarkMode
                                          ? Colors.grey.shade400
                                          : Colors.grey.shade600,
                                      fontSize: 20,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Start a new conversation',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: isDarkMode
                                          ? Colors.grey.shade500
                                          : Colors.grey.shade500,
                                    ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          color: Theme.of(context).hintColor,
                          onRefresh: _loadChats,
                          child: ListView.builder(
                            itemCount: chatService.chats.length,
                            itemBuilder: (context, index) {
                              final chat = chatService.chats[index];
                              print(
                                  'Rendering chat: ${chat.otherParticipant?.name}');
                              return ChatListTile(
                                chat: chat,
                                currentUserId:
                                    authService.currentUser?.id ?? '',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                        chatId: chat.id,
                                        chatName: chat.name,
                                        otherParticipantName:
                                            chat.otherParticipant?.name,
                                        otherParticipantImage:
                                            chat.otherParticipant?.image,
                                        isGroupChat: chat.type == 'group',
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNewChatBottomSheet, // Use the new function
        backgroundColor: Theme.of(context).hintColor,
        child: const Icon(Icons.chat, color: Colors.white),
      ),
    );
  }
}
