import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const _kFavoritesKey = 'favorites';

  // Returns raw JSON strings stored as favorites.
  static Future<List<String>> getFavoritesRaw() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_kFavoritesKey) ?? <String>[];
  }

  static Future<void> addFavoriteRaw(String json) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_kFavoritesKey) ?? <String>[];
    if (!list.contains(json)) {
      list.add(json);
      await prefs.setStringList(_kFavoritesKey, list);
    }
  }

  // Remove favorites by country name (safe if names are unique in the dataset).
  static Future<void> removeFavoriteByName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_kFavoritesKey) ?? <String>[];
    final filtered = list.where((s) {
      try {
        final m = jsonDecode(s) as Map<String, dynamic>;
        return (m['name']?.toString() ?? '') != name;
      } catch (_) {
        return true;
      }
    }).toList();
    await prefs.setStringList(_kFavoritesKey, filtered);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kFavoritesKey);
  }
}
