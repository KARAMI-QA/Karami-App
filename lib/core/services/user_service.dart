import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:karami_app/core/services/api_service.dart';
import 'package:karami_app/models/user_model.dart';
import '../../graphql/queries/user_queries.dart';

class UserService with ChangeNotifier {
  List<User> _employees = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  int _perPage = 20; // Load 20 at a time for better performance
  int _totalItems = 0;

  List<User> get employees => _employees;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  int get totalItems => _totalItems;

  Future<void> loadEmployees(String userToken, {bool reset = false}) async {
    if (_isLoading) return;

    if (reset) {
      _employees = [];
      _currentPage = 1;
      _hasMore = true;
      notifyListeners();
    }

    _isLoading = true;
    notifyListeners();

    try {
      final client = await ApiService.createClient();

      final result = await client.query(
        QueryOptions(
          document: gql(UserQueries.userGetActiveEmployees),
          variables: {
            'userToken': userToken,
            'pagination': {
              'page': _currentPage,
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
        final usersData = data['users'] as List<dynamic>;

        // Update pagination info
        _currentPage = pagination['currentPage'];
        _totalItems = pagination['totalItems'];
        _hasMore = pagination['hasNextPage'];

        // Add new users to the list
        final newUsers =
            usersData.map((userJson) => User.fromJson(userJson)).toList();
        _employees.addAll(newUsers);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      debugPrint('❌ Error loading employees: $e');
      notifyListeners();
      rethrow;
    }
  }

  Future<void> loadMore(String userToken) async {
    if (!_hasMore || _isLoading) return;

    _currentPage++;
    await loadEmployees(userToken);
  }

  void clear() {
    _employees = [];
    _currentPage = 1;
    _hasMore = true;
    _totalItems = 0;
    notifyListeners();
  }
}
