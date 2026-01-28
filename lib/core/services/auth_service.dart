import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:karami_app/core/services/api_service.dart';
import 'package:karami_app/models/user_model.dart';
import '../utils/storage.dart';
import '../../graphql/queries/auth_queries.dart';
import '../../graphql/mutations/auth_mutations.dart';

class AuthService with ChangeNotifier {
  User? _currentUser;
  bool _isLoggedIn = false;
  bool _isDarkMode = false;
  String? _userToken;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  bool get isDarkMode => _isDarkMode;
  String? get userToken => _userToken;

  AuthService() {
    _init();
  }

  Future<void> _init() async {
    _isDarkMode = await Storage.getDarkMode();
    _userToken = await Storage.getToken();
    _isLoggedIn = _userToken != null && _userToken!.isNotEmpty;

    if (_isLoggedIn) {
      await fetchCurrentUser();
    }

    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    try {
      final client = await ApiService.createClient();

      final result = await client.mutate(
        MutationOptions(
          document: gql(AuthMutations.userLogin),
          variables: {
            'loginInput': {
              'email': email.trim(),
              'password': password,
              'device_type': 'IOS',
            },
          },
          fetchPolicy: FetchPolicy.noCache,
        ),
      );

      if (result.hasException) {
        throw Exception(
          result.exception!.graphqlErrors.isNotEmpty
              ? result.exception!.graphqlErrors.first.message
              : result.exception!.toString(),
        );
      }

      final loginData = result.data?['userLogin'];
      if (loginData == null || loginData['success'] != true) {
        throw Exception(loginData?['message'] ?? 'Login failed');
      }

      _userToken = loginData['userToken'];
      if (_userToken == null || _userToken!.isEmpty) {
        throw Exception('No token received');
      }

      await Storage.setToken(_userToken!);
      _isLoggedIn = true;

      final userData = loginData['user'];
      if (userData != null) {
        _currentUser = User.fromJson(userData);
      } else {
        await fetchCurrentUser();
      }

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('❌ Login error: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    await Storage.clear();
    _currentUser = null;
    _isLoggedIn = false;
    _userToken = null;
    notifyListeners();
  }

  Future<void> fetchCurrentUser() async {
    if (_userToken == null) return;

    try {
      final client = await ApiService.createClient();

      final result = await client.query(
        QueryOptions(
          document: gql(AuthQueries.userGetOne),
          variables: {'userToken': _userToken},
          fetchPolicy: FetchPolicy.noCache,
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception!.graphqlErrors.first.message);
      }

      final userData = result.data?['userGetOne'];
      if (userData != null) {
        _currentUser = User.fromJson(userData);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('⚠️ fetchCurrentUser failed: $e');
      await logout();
    }
  }

  Future<bool> forgotPassword(String email) async {
    final client = await ApiService.createClient();

    final result = await client.mutate(
      MutationOptions(
        document: gql(AuthMutations.userForgotPassword),
        variables: {
          'forgotInput': {'email': email.trim()},
        },
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception!.graphqlErrors.first.message);
    }

    return result.data?['userForgotPassword'] == true;
  }

  Future<bool> resetPassword(
      String email, String otp, String newPassword) async {
    final client = await ApiService.createClient();

    final result = await client.mutate(
      MutationOptions(
        document: gql(AuthMutations.userResetPassword),
        variables: {
          'resetInput': {
            'email': email.trim(),
            'otp': otp,
            'new_password': newPassword,
          },
        },
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception!.graphqlErrors.first.message);
    }

    return result.data?['userResetPassword'] == true;
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    Storage.setDarkMode(_isDarkMode);
    notifyListeners();
  }

  Future<bool> validateToken() async {
    if (_userToken == null) return false;

    try {
      final client = await ApiService.createClient();

      final result = await client.query(
        QueryOptions(
          document: gql(AuthQueries.userValidateToken),
          variables: {'userToken': _userToken},
          fetchPolicy: FetchPolicy.noCache,
        ),
      );

      return result.data?['userValidateToken'] == true;
    } catch (_) {
      return false;
    }
  }
}
