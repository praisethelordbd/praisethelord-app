import 'package:flutter/material.dart';
import 'package:praisethelord/screens/about_page.dart';
import 'package:praisethelord/screens/favorite_list_page.dart';
import 'package:praisethelord/screens/settings_page.dart';
import 'package:url_launcher/url_launcher.dart';

class AppNavigationDrawer extends StatelessWidget {
  const AppNavigationDrawer({super.key});

  void _launchFeedbackEmail(BuildContext context) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'praisethelordbd.17@gmail.com',
      queryParameters: {'subject': 'Feedback for Praise the LORD BD App'},
    );
    if (!await launchUrl(emailLaunchUri)) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open email app.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const UserAccountsDrawerHeader(
            accountName: Text("App Creator: Prosenjit Roy",
                style: TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: Text("praisethelordbd.17@gmail.com"),
            currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/images/image.png')),
          ),
          ListTile(
            leading: const Icon(Icons.favorite, color: Colors.red),
            title: const Text('Favorite List'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FavoriteListPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AboutPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.feedback),
            title: const Text('Feedback'),
            onTap: () {
              Navigator.pop(context);
              _launchFeedbackEmail(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsPage()));
            },
          ),
        ],
      ),
    );
  }
}
