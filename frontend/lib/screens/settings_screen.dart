import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Account Settings
          const Text(
            'Account Settings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Reset Password'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: _resetPassword,
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.email),
                  title: const Text('Change Email'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: _changeEmail,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // App Settings
          const Text(
            'App Settings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.dark_mode),
                  title: const Text('Dark Mode'),
                  trailing: Switch(
                    value: userModel.darkMode,
                    onChanged: (value) => userModel.toggleDarkMode(),
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text('Push Notifications'),
                  trailing: Switch(
                    value: userModel.notificationsEnabled,
                    onChanged: (value) => userModel.toggleNotifications(),
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.vibration),
                  title: const Text('Vibration on Violation'),
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {},
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.volume_up),
                  title: const Text('Sound Alerts'),
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // About
          const Text(
            'About',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('App Version'),
                  subtitle: const Text('1.0.0'),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.privacy_tip),
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: _showPrivacyPolicy,
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.help),
                  title: const Text('Help & Support'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: _showHelp,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Logout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                userModel.logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('LOGOUT'),
            ),
          ),
        ],
      ),
    );
  }

  void _resetPassword() {
    // Implement password reset logic
  }

  void _changeEmail() {
    // Implement email change logic
  }

  void _showPrivacyPolicy() {
    // Show privacy policy
  }

  void _showHelp() {
    // Show help and support
  }
}