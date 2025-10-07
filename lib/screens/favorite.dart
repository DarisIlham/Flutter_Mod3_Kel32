import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/favorites_service.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late Future<List<Map<String, dynamic>>> favorites;

  @override
  void initState() {
    super.initState();
    favorites = _loadFavorites();
  }

  Future<List<Map<String, dynamic>>> _loadFavorites() async {
    final raw = await FavoritesService.getFavoritesRaw();
    return raw.map((s) {
      try {
        return jsonDecode(s) as Map<String, dynamic>;
      } catch (_) {
        return <String, dynamic>{};
      }
    }).toList();
  }

  Future<void> _remove(String name) async {
    await FavoritesService.removeFavoriteByName(name);
    setState(() {
      favorites = _loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: favorites,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final list = snapshot.data ?? [];
          if (list.isEmpty) {
            return const Center(child: Text('No favorites yet'));
          }
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              final name = item['name']?.toString() ?? 'Unknown';
              final region = item['region']?.toString() ?? '';
              final flag = item['flags']?['png']?.toString();
              return Card(
                child: ListTile(
                  leading: flag != null
                      ? Image.network(flag, width: 50)
                      : const SizedBox(width: 50),
                  title: Text(name),
                  subtitle: Text(region),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Filled dark heart to indicate this is a favorite
                      const Icon(Icons.favorite, color: Colors.black),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _remove(name),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
