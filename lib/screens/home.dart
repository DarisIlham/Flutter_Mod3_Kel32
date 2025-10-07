import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'detail.dart';
import 'favorite.dart';
import '../services/favorites_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Country>> countries;
  Set<String> _favoriteNames = {};
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Country>? _allCountries;
  bool _sortAscending = true;

  void _applySort() {
    if (_allCountries == null) return;
    _allCountries!.sort((a, b) {
      final cmp = a.name.toLowerCase().compareTo(b.name.toLowerCase());
      return _sortAscending ? cmp : -cmp;
    });
  }

  @override
  void initState() {
    super.initState();
    countries = fetchCountries();
    _loadFavorites();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFavorites() async {
    final raw = await FavoritesService.getFavoritesRaw();
    final names = raw.map((s) {
      try {
        final m = jsonDecode(s) as Map<String, dynamic>;
        return m['name']?.toString() ?? '';
      } catch (_) {
        return '';
      }
    }).where((s) => s.isNotEmpty).toSet();
    setState(() {
      _favoriteNames = names;
    });
  }

  Future<List<Country>> fetchCountries() async {
    const url = 'https://www.apicountries.com/countries';
    final uri = Uri.parse(url);
    
    final request = await HttpClient().getUrl(uri);
    final response = await request.close();

    if (response.statusCode == 200) {
      final respBody = await response.transform(utf8.decoder).join();
      final List<dynamic> jsonData = jsonDecode(respBody);
      return jsonData.map((j) => Country.fromJson(j)).toList();
    } else {
      throw Exception('Failed to load countries: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Countries'),
        actions: [
          IconButton(
            icon: Icon(_sortAscending ? Icons.sort_by_alpha : Icons.sort_by_alpha_outlined),
            tooltip: _sortAscending ? 'Sort A → Z' : 'Sort Z → A',
            onPressed: () {
              setState(() {
                _sortAscending = !_sortAscending;
                _applySort();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritePage()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Country>>(
        future: countries,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No countries found'),
            );
          }

          final list = snapshot.data!;
          // cache fetched list so filtering doesn't depend on snapshot data identity
          _allCountries ??= list;
          // ensure cached list is sorted according to current preference
          _applySort();
          final source = _allCountries!;
          final filtered = source.where((c) {
            final q = _searchQuery.toLowerCase();
            if (q.isEmpty) return true;
            final name = c.name.toLowerCase();
            final region = c.region.toLowerCase();
            return name.contains(q) || region.contains(q);
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search countries by name or region',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final country = filtered[index];
              return Card(
                child: ListTile(
                  leading: country.flagsPng != null
                      ? Image.network(
                          country.flagsPng!,
                          width: 50,
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox(
                              width: 50,
                              child: Icon(Icons.error_outline),
                            );
                          },
                        )
                      : const SizedBox(width: 50),
                  title: Text(country.name),
                  subtitle: Text(country.region),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(country: country),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: _favoriteNames.contains(country.name)
                        ? const Icon(Icons.favorite, color: Colors.black)
                        : const Icon(Icons.favorite_border),
                    onPressed: () {
                      final encoded = jsonEncode({
                        'name': country.name,
                        'region': country.region,
                        'population': country.population,
                        'capital': country.capital,
                        'flags': {'png': country.flagsPng},
                        'languages': country.languages,
                        'currencies': country.currencies,
                      });
                      if (_favoriteNames.contains(country.name)) {
                        // remove favorite (do not await UI update)
                        FavoritesService.removeFavoriteByName(country.name).then((_) {
                          if (mounted) {
                            setState(() {
                              _favoriteNames.remove(country.name);
                            });
                          }
                        });
                      } else {
                        final messenger = ScaffoldMessenger.of(context);
                        FavoritesService.addFavoriteRaw(encoded).then((_) {
                          if (mounted) {
                            setState(() {
                              _favoriteNames.add(country.name);
                            });
                            messenger.showSnackBar(
                              SnackBar(content: Text('${country.name} added to favorites')),
                            );
                          }
                        });
                      }
                    },
                  ),
                ),
              );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Country {
  final String name;
  final String region;
  final String? capital;
  final int population;
  final String? flagsPng;
  final List<String>? languages;
  final List<String>? currencies;

  Country({
    required this.name,
    required this.region,
    required this.population,
    this.capital,
    this.flagsPng,
    this.languages,
    this.currencies,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    List<String>? parseLanguages(dynamic languagesJson) {
      if (languagesJson == null) return null;
      
      return (languagesJson as List)
          .map((l) => l['name']?.toString() ?? 'Unknown')
          .toList();
    }

    List<String>? parseCurrencies(dynamic currenciesJson) {
      if (currenciesJson == null) return null;
      
      return (currenciesJson as List)
          .map((c) => c['name']?.toString() ?? 'Unknown')
          .toList();
    }

    return Country(
      name: json['name']?.toString() ?? 'N/A',
      region: json['region']?.toString() ?? 'N/A',
      population: json['population'] as int? ?? 0,
      capital: json['capital']?.toString(),
      flagsPng: json['flags']?['png']?.toString(),
      languages: parseLanguages(json['languages']),
      currencies: parseCurrencies(json['currencies']),
    );
  }
}


