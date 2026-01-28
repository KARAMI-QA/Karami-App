import 'package:flutter/material.dart';
import 'package:karami_app/features/dashboard/widgets/dashboard_card.dart';
import 'package:provider/provider.dart';
import '../../../core/services/auth_service.dart';
import '../../chat/screens/chat_list_screen.dart';
import '../../../core/constants/api_constants.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // Custom App Bar with gradient
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: Theme.of(context).primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColorLight,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome back,',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  user?.name ?? 'User',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                            // Profile Avatar
                            GestureDetector(
                              onTap: () {
                                // TODO: Navigate to profile
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.white,
                                  backgroundImage: user?.image != null &&
                                          user!.image!.isNotEmpty
                                      ? NetworkImage(
                                          '${ApiConstants.orginalBaseUrlForImage}${user.image}')
                                      : null,
                                  child: user?.image == null ||
                                          user!.image!.isEmpty
                                      ? Text(
                                          user?.name?.substring(0, 1) ?? 'U',
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        )
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              title: Text(
                'Dashboard',
                style: Theme.of(context).appBarTheme.titleTextStyle,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                color: Colors.white,
                onPressed: () {
                  // TODO: Navigate to notifications
                },
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                color: isDarkMode ? const Color(0xFF2A3942) : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'profile',
                    child: Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          color: isDarkMode ? Colors.white70 : Colors.black87,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Profile',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color:
                                    isDarkMode ? Colors.white : Colors.black87,
                              ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'settings',
                    child: Row(
                      children: [
                        Icon(
                          Icons.settings_outlined,
                          color: isDarkMode ? Colors.white70 : Colors.black87,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Settings',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color:
                                    isDarkMode ? Colors.white : Colors.black87,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        const Icon(
                          Icons.logout,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Logout',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.red,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) async {
                  if (value == 'logout') {
                    await authService.logout();
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, '/login');
                    }
                  }
                  // Handle other menu items
                },
              ),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick Stats Cards
                  _buildQuickStats(context, isDarkMode),

                  const SizedBox(height: 24),

                  // Main Feature Cards
                  Text(
                    'Quick Actions',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),

                  _buildFeatureCards(context, isDarkMode),

                  const SizedBox(height: 24),

                  // Recent Activity Section
                  Text(
                    'Recent Activity',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),

                  _buildRecentActivity(context, isDarkMode),

                  const SizedBox(height: 24),

                  // Account Info Card
                  _buildAccountInfoCard(context, user, isDarkMode),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ChatListScreen(),
            ),
          );
        },
        backgroundColor: Theme.of(context).hintColor,
        icon: const Icon(Icons.chat, color: Colors.white),
        label: const Text(
          'New Chat',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context, bool isDarkMode) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            icon: Icons.chat_bubble,
            label: 'Messages',
            value: '0',
            color: const Color(0xFF00A884),
            isDarkMode: isDarkMode,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            icon: Icons.people,
            label: 'Contacts',
            value: '0',
            color: const Color(0xFF7F66FF),
            isDarkMode: isDarkMode,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            icon: Icons.group,
            label: 'Groups',
            value: '0',
            color: const Color(0xFF2196F3),
            isDarkMode: isDarkMode,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required bool isDarkMode,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF202C33) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCards(BuildContext context, bool isDarkMode) {
    final features = [
      {
        'title': 'Chats',
        'subtitle': 'View all conversations',
        'icon': Icons.chat_bubble_outline,
        'color': const Color(0xFF00A884),
        'route': () => const ChatListScreen(),
      },
      {
        'title': 'Contacts',
        'subtitle': 'Manage your contacts',
        'icon': Icons.contacts_outlined,
        'color': const Color(0xFF7F66FF),
        'route': null,
      },
      {
        'title': 'Groups',
        'subtitle': 'Create and manage groups',
        'icon': Icons.group_outlined,
        'color': const Color(0xFF2196F3),
        'route': null,
      },
      {
        'title': 'Settings',
        'subtitle': 'Account preferences',
        'icon': Icons.settings_outlined,
        'color': const Color(0xFFFF9800),
        'route': null,
      },
    ];

    return Column(
      children: features
          .map(
            (feature) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // if (feature['route'] != null) {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) =>
                    //           feature['route'] as Widget Function(),
                    //     ),
                    //   );
                    // }
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:
                          isDarkMode ? const Color(0xFF202C33) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Colors.black.withOpacity(isDarkMode ? 0.3 : 0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: (feature['color'] as Color).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            feature['icon'] as IconData,
                            color: feature['color'] as Color,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                feature['title'] as String,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                feature['subtitle'] as String,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontSize: 13,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: isDarkMode
                              ? Colors.grey.shade600
                              : Colors.grey.shade400,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildRecentActivity(BuildContext context, bool isDarkMode) {
    final activities = [
      {
        'icon': Icons.login,
        'title': 'Logged in',
        'subtitle': 'Just now',
        'color': const Color(0xFF4CAF50),
      },
      {
        'icon': Icons.chat,
        'title': 'New message',
        'subtitle': '5 minutes ago',
        'color': const Color(0xFF00A884),
      },
      {
        'icon': Icons.group_add,
        'title': 'Added to group',
        'subtitle': '1 hour ago',
        'color': const Color(0xFF2196F3),
      },
      {
        'icon': Icons.notifications,
        'title': 'Push notification enabled',
        'subtitle': '2 hours ago',
        'color': const Color(0xFFFF9800),
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF202C33) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(8),
        itemCount: activities.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: isDarkMode ? const Color(0xFF2A3942) : const Color(0xFFE9EDEF),
        ),
        itemBuilder: (context, index) {
          final activity = activities[index];
          return ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (activity['color'] as Color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                activity['icon'] as IconData,
                color: activity['color'] as Color,
                size: 22,
              ),
            ),
            title: Text(
              activity['title'] as String,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            subtitle: Text(
              activity['subtitle'] as String,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 13,
                  ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAccountInfoCard(
      BuildContext context, dynamic user, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [
                  const Color(0xFF00A884),
                  const Color(0xFF008069),
                ]
              : [
                  const Color(0xFF00A884),
                  const Color(0xFF25D366),
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00A884).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.account_circle,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Account Information',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? 'No email',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  icon: Icons.phone,
                  label: 'Phone',
                  value: user?.phone ?? 'Not set',
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withOpacity(0.2),
              ),
              Expanded(
                child: _buildInfoItem(
                  icon: Icons.verified_user,
                  label: 'Status',
                  value: 'Active',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
