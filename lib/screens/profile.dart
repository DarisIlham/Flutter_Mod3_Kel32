
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  final VoidCallback? onHomeTap;

  const ProfilePage({
    super.key,
    this.onHomeTap,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final List<Map<String, String>> teamMembers = [
    {
      'Nama': 'Daris Muhammad Ilham',
      'NIM': '21120122120018',
      'GitHub': 'https://github.com/DarisIlham',
      'LinkedIn': 'https://linkedin.com/in/sanggul-rotua-pakpahan',
      'AvatarUrl': 'https://avatars.githubusercontent.com/u/162071187?v=4'
    },
    {
      'Nama': 'Darren Nathanael',
      'NIM': '21120122120019',
      'GitHub': 'https://github.com/melakhaa',
      'LinkedIn': 'https://linkedin.com/in/johndoe',
      'AvatarUrl': 'https://avatars.githubusercontent.com/u/151757741?v=4'
    },
    {
      'Nama': 'Denzel Chandra',
      'NIM': '21120122120020',
      'GitHub': 'https://github.com/dengd3ng',
      'LinkedIn': 'https://linkedin.com/in/janesmith',
      'AvatarUrl': 'https://avatars.githubusercontent.com/u/188978976?v=4'
    },
  ];

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if(!await launchUrl(uri, mode: LaunchMode.externalApplication)) {throw 'Could not launch $url';
  }}

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: isDarkMode
            ? const Color(0xFF1E1E1E)
            : const Color.fromARGB(255, 13, 105, 225),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: widget.onHomeTap,
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Background Image
          _buildBackgroundImage(isDarkMode),

          // Profile Content
          _buildProfileContent(textColor, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage(bool isDarkMode) {
    return Positioned.fill(
      child: FractionallySizedBox(
        alignment: Alignment.topCenter,
        heightFactor: 0.5,
        child: Container(
          decoration: BoxDecoration(
            image: const DecorationImage(
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              image: NetworkImage(
                'https://cdn.myanimelist.net/s/common/uploaded_files/1444014275-106dee95104209bb9436d6df2b6d5145.jpeg',
              ),
            ),
      color: isDarkMode
        ? Colors.black.withOpacity(0.7)
        : Color.fromARGB(255, 255, 252, 252).withOpacity(0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileContent(Color textColor, bool isDarkMode) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20.0),

            // Team Members Info with Cards
            ..._buildTeamMembersCards(textColor, isDarkMode),

            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTeamMembersCards(Color textColor, bool isDarkMode) {
    return teamMembers.map((member) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Card(
          elevation: 6,
          color: isDarkMode ? Colors.grey[800] : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Profile Picture
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: _buildProfilePicture(member),
                ),

                const SizedBox(height: 16.0),

                // Name
                Text(
                  member['Nama'] ?? 'No Name',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8.0),

                // NIM
                Text(
                  member['NIM'] ?? 'No NIM',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: textColor.withOpacity(0.8),
                  ),
                ),

                const SizedBox(height: 16.0),

                // Social Media Links
                _buildSocialMediaLinks(member, textColor),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildProfilePicture(Map<String, String> member) {
    return Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(member['AvatarUrl'] ?? ''),
        ),
      ),
    );
  }

  Widget _buildSocialMediaLinks(Map<String, String> member, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // GitHub Link
        IconButton(
          icon: Image.asset(
            'assets/github.png',
            width: 32,
            height: 32,
            color: textColor,
          ),
          onPressed: () {
            _launchURL(member['GitHub']!);
          },
        ),

        const SizedBox(width: 20),

        // LinkedIn Link
        IconButton(
          icon: Image.asset(
            'assets/linkedin.png',
            width: 32,
            height: 32,
            color: textColor,
          ),
          onPressed: () {
            _launchURL(member['LinkedIn']!);
          },
        ),
      ],
    );
  }

  
}
