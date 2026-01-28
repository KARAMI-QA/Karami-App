import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:karami_app/core/constants/api_constants.dart';
import 'package:karami_app/core/services/api_service.dart';
import 'package:karami_app/features/chat/screens/chat_screen.dart';
import 'package:karami_app/models/user_model.dart';
import 'package:karami_app/graphql/queries/user_queries.dart';
import 'package:karami_app/shared/widgets/loading_indicator.dart';
import 'package:provider/provider.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/chat_service.dart';

class EmployeeBottomSheet extends StatefulWidget {
  final Function(String) onChatCreated;

  const EmployeeBottomSheet({
    super.key,
    required this.onChatCreated,
  });

  @override
  State<EmployeeBottomSheet> createState() => _EmployeeBottomSheetState();
}

class _EmployeeBottomSheetState extends State<EmployeeBottomSheet> {
  final ScrollController _scrollController = ScrollController();
  final List<User> _employees = [];
  final List<User> _searchResults = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _currentPage = 1;
  int _perPage = 20;
  String _searchQuery = '';
  int _totalEmployeesCount = 0;
  Timer? _searchDebounceTimer;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadEmployees();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchDebounceTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadEmployees({bool loadMore = false}) async {
    if (!loadMore) {
      setState(() {
        _isLoading = true;
      });
    } else {
      setState(() {
        _isLoadingMore = true;
      });
    }

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final token = authService.userToken;

      if (token == null) {
        throw Exception('No authentication token');
      }

      final client = await ApiService.createClient();

      final result = await client.query(
        QueryOptions(
          document: gql(UserQueries.userGetActiveEmployees),
          variables: {
            'userToken': token,
            'pagination': {
              'page': loadMore ? _currentPage + 1 : 1,
              'perPage': _perPage,
            },
          },
          fetchPolicy: FetchPolicy.noCache,
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception?.graphqlErrors.first.message ??
            'Failed to load employees');
      }

      final data = result.data?['userGetActiveEmployees'];
      if (data != null) {
        final pagination = data['pagination'];
        _totalEmployeesCount = pagination['totalItems'];
        final usersData = data['users'] as List<dynamic>;

        // Update pagination
        if (loadMore) {
          _currentPage++;
        } else {
          _currentPage = 1;
          _employees.clear();
        }

        _hasMore = pagination['hasNextPage'];

        // Add new employees
        final newEmployees =
            usersData.map((userJson) => User.fromJson(userJson)).toList();

        if (loadMore) {
          _employees.addAll(newEmployees);
        } else {
          _employees.addAll(newEmployees);
        }
      }

      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
    } catch (e) {
      print('❌ Error loading employees: $e');
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _searchEmployees(String searchTerm) async {
    if (searchTerm.trim().isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults.clear();
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final token = authService.userToken;

      if (token == null) {
        throw Exception('No authentication token');
      }

      final client = await ApiService.createClient();

      final result = await client.query(
        QueryOptions(
          document: gql(UserQueries.userSearch),
          variables: {
            'userToken': token,
            'searchTerm': searchTerm.trim(),
          },
          fetchPolicy: FetchPolicy.noCache,
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception?.graphqlErrors.first.message ??
            'Failed to search employees');
      }

      final usersData = result.data?['userSearch'] as List<dynamic>;

      setState(() {
        _searchResults.clear();
        if (usersData != null) {
          _searchResults.addAll(
              usersData.map((userJson) => User.fromJson(userJson)).toList());
        }
        _isSearching = false;
      });
    } catch (e) {
      print('❌ Error searching employees: $e');
      setState(() {
        _isSearching = false;
        _searchResults.clear();
      });
    }
  }

  void _onSearchChanged(String value) {
    _searchQuery = value;

    // Cancel previous debounce timer
    _searchDebounceTimer?.cancel();

    // If search query is empty, clear search results
    if (value.trim().isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults.clear();
      });
      return;
    }

    // Set a debounce timer to avoid too many API calls
    _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      _searchEmployees(value);
    });
  }

  void _onScroll() {
    if (_searchQuery.isEmpty &&
        _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoadingMore &&
        _hasMore) {
      _loadEmployees(loadMore: true);
    }
  }

  Future<void> _createChatWithEmployee(
      String employeeId, String employeeName, String? employeeImage) async {
    try {
      final chatService = Provider.of<ChatService>(context, listen: false);

      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min, // Add this
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 16),
              Expanded(
                // Wrap the text in Expanded
                child: Text(
                  'Creating chat with $employeeName...',
                  overflow:
                      TextOverflow.ellipsis, // Add ellipsis for long names
                  maxLines: 2, // Limit to 2 lines
                ),
              ),
            ],
          ),
        ),
      );

      // Create the chat
      final chat = await chatService.createDirectChat(employeeId);

      // Close the bottom sheet
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        Navigator.pop(context); // Close bottom sheet

        // Navigate to chat screen with actual employee details
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              chatId: chat.id,
              chatName: employeeName,
              otherParticipantName: employeeName,
              otherParticipantImage: employeeImage,
              isGroupChat: false,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog

        // Show error
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: SingleChildScrollView(
              // Allow scrolling for long errors
              child: Text('Failed to create chat: $e'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final currentList = _searchQuery.isNotEmpty ? _searchResults : _employees;
    final showLoading = _searchQuery.isNotEmpty ? _isSearching : _isLoading;
    final totalCount =
        _searchQuery.isNotEmpty ? _searchResults.length : _totalEmployeesCount;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF111B21) : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'New Chat',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF2A3942) : Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search employees...',
                  hintStyle: TextStyle(
                    color:
                        isDarkMode ? const Color(0xFF8696A0) : Colors.grey[600],
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color:
                        isDarkMode ? const Color(0xFF8696A0) : Colors.grey[600],
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),

          // Employee Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  _searchQuery.isNotEmpty
                      ? 'Found ${_searchResults.length} results'
                      : '$_totalEmployeesCount employees',
                  style: TextStyle(
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                if (showLoading)
                  const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
          ),

          // Employees List
          Expanded(
            child: showLoading && currentList.isEmpty
                ? const Center(child: LoadingIndicator())
                : currentList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 80,
                              color: isDarkMode
                                  ? Colors.grey[600]
                                  : Colors.grey[300],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchQuery.isNotEmpty
                                  ? 'No employees found for "${_searchQuery}"'
                                  : 'No employees available',
                              style: TextStyle(
                                color: isDarkMode
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : NotificationListener<ScrollNotification>(
                        onNotification: (notification) {
                          if (notification is ScrollEndNotification &&
                              _scrollController.position.pixels ==
                                  _scrollController.position.maxScrollExtent &&
                              _hasMore &&
                              !_isLoadingMore &&
                              _searchQuery.isEmpty) {
                            _loadEmployees(loadMore: true);
                            return true;
                          }
                          return false;
                        },
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: currentList.length +
                              (_searchQuery.isEmpty && _hasMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (_searchQuery.isEmpty &&
                                index >= currentList.length) {
                              return _isLoadingMore
                                  ? const Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  : const SizedBox();
                            }

                            final employee = currentList[index];
                            return _buildEmployeeTile(employee, isDarkMode);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeTile(User employee, bool isDarkMode) {
    return ListTile(
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: isDarkMode ? Colors.grey[700] : Colors.grey[300],
        backgroundImage: employee.image != null
            ? NetworkImage(
                '${ApiConstants.orginalBaseUrlForImage}${employee.image}',
              )
            : null,
        child: employee.image == null
            ? Text(
                employee.fullName.isNotEmpty
                    ? employee.fullName[0].toUpperCase()
                    : '?',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,
      ),
      title: Text(
        employee.fullName,
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (employee.email != null)
            Text(
              employee.email!,
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          // if (employee.phone != null)
          //   Text(
          //     employee.phone!,
          //     style: TextStyle(
          //       color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          //       fontSize: 12,
          //     ),
          //   ),
        ],
      ),
      trailing: Icon(
        Icons.chat_bubble_outline,
        color: Theme.of(context).hintColor,
      ),
      onTap: () {
        _createChatWithEmployee(employee.id, employee.fullName, employee.image);
      },
    );
  }
}
