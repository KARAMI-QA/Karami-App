import 'package:hive_flutter/hive_flutter.dart';

class Storage {
  static late Box _box;

  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox('chat_app');
  }

  // Token management
  static Future<void> setToken(String token) async {
    await _box.put('token', token);
  }

  static Future<String?> getToken() async {
    return _box.get('token');
  }

  static Future<void> clearToken() async {
    await _box.delete('token');
  }

  // Dark mode
  static Future<void> setDarkMode(bool isDarkMode) async {
    await _box.put('dark_mode', isDarkMode);
  }

  static Future<bool> getDarkMode() async {
    return _box.get('dark_mode', defaultValue: false);
  }

  // User data
  static Future<void> setUserData(Map<String, dynamic> data) async {
    await _box.put('user_data', data);
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    return _box.get('user_data');
  }

  // Clear all data
  static Future<void> clear() async {
    await _box.clear();
  }

  // Chat cache
  static Future<void> cacheChats(List<Map<String, dynamic>> chats) async {
    await _box.put('cached_chats', chats);
  }

  static Future<List<Map<String, dynamic>>?> getCachedChats() async {
    return _box.get('cached_chats');
  }

  // Message cache - ADD THESE METHODS
  static Future<void> cacheMessages(
      String chatId, List<Map<String, dynamic>> messages) async {
    await _box.put('messages_$chatId', messages);
  }

  static Future<List<Map<String, dynamic>>?> getCachedMessages(
      String chatId) async {
    return _box.get('messages_$chatId');
  }

  // Generic string storage - ADD THESE METHODS
  static Future<void> setString(String key, String value) async {
    await _box.put(key, value);
  }

  static Future<String?> getString(String key) async {
    return _box.get(key);
  }

  static Future<void> remove(String key) async {
    await _box.delete(key);
  }

  // Generic list storage
  static Future<void> setList(String key, List<dynamic> value) async {
    await _box.put(key, value);
  }

  static Future<List<dynamic>?> getList(String key) async {
    return _box.get(key);
  }

  // Generic map storage
  static Future<void> setMap(String key, Map<String, dynamic> value) async {
    await _box.put(key, value);
  }

  static Future<Map<String, dynamic>?> getMap(String key) async {
    return _box.get(key);
  }
}
