import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return ListView(
            children: [
              SwitchListTile(
                title: const Text('Dark Mode'),
                value: settings.isDarkMode,
                onChanged: (value) => settings.toggleDarkMode(value),
              ),
              SwitchListTile(
                title: const Text('Screen Always On'),
                subtitle: const Text('গান দেখার সময় স্ক্রিন বন্ধ হবে না'),
                value: settings.isScreenAwake,
                onChanged: (value) => settings.toggleScreenAwake(value),
              ),
            ],
          );
        },
      ),
    );
  }
}
