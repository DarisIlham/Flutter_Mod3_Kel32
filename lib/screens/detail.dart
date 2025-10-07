// import 'package:flutter/material.dart';
// import 'home.dart';

// class DetailPage extends StatelessWidget {
//   final Country country;
//   const DetailPage({super.key, required this.country});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(country.name)),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (country.flagsPng != null)
//               Center(child: Image.network(country.flagsPng!, width: 200)),
//             const SizedBox(height: 16),
//             Text('Name: ${country.name}', style: const TextStyle(fontSize: 18)),
//             Text(
//               'Capital: ${country.capital ?? 'N/A'}',
//               style: const TextStyle(fontSize: 16),
//             ),
//             Text(
//               'Region: ${country.region}',
//               style: const TextStyle(fontSize: 16),
//             ),
//             Text(
//               'Population: ${country.population}',
//               style: const TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Languages: ${country.languages?.join(', ') ?? 'N/A'}',
//               style: const TextStyle(fontSize: 16),
//             ),
//             Text(
//               'Currencies: ${country.currencies?.join(', ') ?? 'N/A'}',
//               style: const TextStyle(fontSize: 16),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'home.dart';

class DetailPage extends StatelessWidget {
  final Country country;
  const DetailPage({super.key, required this.country});
  
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final subtitleColor = isDarkMode ? Colors.white70 : Colors.black54;
    
    return Scaffold(
      appBar: AppBar(title: Text(country.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (country.flagsPng != null)
              Center(
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      country.flagsPng!, 
                      width: 200,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 200,
                          height: 120,
                          color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                          child: Icon(
                            Icons.flag,
                            color: isDarkMode ? Colors.white54 : Colors.grey,
                            size: 40,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            _buildInfoRow('Name', country.name, textColor, subtitleColor),
            _buildInfoRow('Capital', country.capital ?? 'N/A', textColor, subtitleColor),
            _buildInfoRow('Region', country.region, textColor, subtitleColor),
            _buildInfoRow('Population', country.population.toString(), textColor, subtitleColor),
            const SizedBox(height: 16),
            _buildInfoRow('Languages', country.languages?.join(', ') ?? 'N/A', textColor, subtitleColor),
            _buildInfoRow('Currencies', country.currencies?.join(', ') ?? 'N/A', textColor, subtitleColor),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, Color textColor, Color subtitleColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: subtitleColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Divider(
            color: subtitleColor.withOpacity(0.3),
            height: 1,
          ),
        ],
      ),
    );
  }
}