import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../widgets/feature_card.dart';
import 'camera_connection_screen.dart';
import 'violation_history_screen.dart';
import 'settings_screen.dart';
import 'restricted_zones_screen.dart';
import 'real_time_detection_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context);

    // Mock notification counts
    const int violationCount = 3;
    const int cameraAlertCount = 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Classification System'),
        backgroundColor: const Color(0xFF667eea),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              userModel.logout();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            FeatureCard(
              title: 'Connect Camera',
              description: 'Add and manage surveillance cameras',
              icon: Icons.videocam,
              iconColor: Colors.blue,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CameraConnectionScreen()),
              ),
            ),
            FeatureCard(
              title: 'Violation History',
              description: 'View HMV violation records',
              icon: Icons.history,
              iconColor: Colors.orange,
              notificationCount: violationCount,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ViolationHistoryScreen()),
              ),
            ),
            FeatureCard(
              title: 'Real-time Detection',
              description: 'Live vehicle detection feed',
              icon: Icons.play_arrow,
              iconColor: Colors.green,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RealTimeDetectionScreen()),
              ),
            ),
            FeatureCard(
              title: 'Restricted Zones',
              description: 'Manage restricted areas',
              icon: Icons.dangerous,
              iconColor: Colors.red,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RestrictedZonesScreen()),
              ),
            ),
            FeatureCard(
              title: 'Camera Status',
              description: 'View connected cameras',
              icon: Icons.camera_alt,
              iconColor: Colors.purple,
              notificationCount: cameraAlertCount,
              onTap: () => _showConnectedCameras(context),
            ),
            FeatureCard(
              title: 'Settings',
              description: 'App configuration',
              icon: Icons.settings,
              iconColor: Colors.grey,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConnectedCameras(BuildContext context) {
    // This would navigate to a camera status screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Navigate to camera status screen'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}