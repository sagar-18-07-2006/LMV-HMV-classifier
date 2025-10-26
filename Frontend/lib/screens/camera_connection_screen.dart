import 'package:flutter/material.dart';
import '../models/camera_model.dart';
import '../widgets/camera_card.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/empty_state.dart';

class CameraConnectionScreen extends StatefulWidget {
  const CameraConnectionScreen({super.key});

  @override
  State<CameraConnectionScreen> createState() => _CameraConnectionScreenState();
}

class _CameraConnectionScreenState extends State<CameraConnectionScreen> {
  final TextEditingController _cameraNameController = TextEditingController();
  final TextEditingController _cameraUrlController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _restrictedZoneController = TextEditingController();

  List<Camera> cameras = [
    Camera(
      id: '1',
      name: 'Main Gate Camera',
      location: 'Gate A',
      isConnected: true,
      restrictedZone: 'Main Entrance',
    ),
    Camera(
      id: '2',
      name: 'Parking Lot Camera',
      location: 'North Parking',
      isConnected: false,
      restrictedZone: null,
    ),
  ];

  void _connectCamera() {
    if (_cameraNameController.text.isEmpty ||
        _cameraUrlController.text.isEmpty ||
        _locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final newCamera = Camera(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _cameraNameController.text,
      location: _locationController.text,
      isConnected: true,
      restrictedZone: _restrictedZoneController.text.isEmpty 
          ? null 
          : _restrictedZoneController.text,
    );

    setState(() {
      cameras.add(newCamera);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Camera connected successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    // Clear form
    _cameraNameController.clear();
    _cameraUrlController.clear();
    _locationController.clear();
    _restrictedZoneController.clear();
  }

  void _editCamera(Camera camera) {
    // Implement edit functionality
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Camera'),
        content: const Text('Edit camera functionality will be implemented here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _deleteCamera(Camera camera) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Camera'),
        content: Text('Are you sure you want to delete ${camera.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                cameras.removeWhere((c) => c.id == camera.id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${camera.name} deleted successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _toggleCamera(Camera camera) {
    setState(() {
      final index = cameras.indexWhere((c) => c.id == camera.id);
      cameras[index] = Camera(
        id: camera.id,
        name: camera.name,
        location: camera.location,
        isConnected: !camera.isConnected,
        restrictedZone: camera.restrictedZone,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect Camera'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add Camera Form
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add New Camera',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _cameraNameController,
                      labelText: 'Camera Name',
                      prefixIcon: Icons.videocam,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _cameraUrlController,
                      labelText: 'Camera URL/IP Address',
                      prefixIcon: Icons.link,
                      keyboardType: TextInputType.url,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _locationController,
                      labelText: 'Camera Location',
                      prefixIcon: Icons.location_on,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _restrictedZoneController,
                      labelText: 'Restricted Zone (Optional)',
                      prefixIcon: Icons.dangerous,
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      text: 'CONNECT CAMERA',
                      onPressed: _connectCamera,
                      backgroundColor: const Color(0xFF667eea),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Connected Cameras List
            const Text(
              'Connected Cameras',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            cameras.isEmpty
                ? EmptyState(
                    title: 'No Cameras Connected',
                    description: 'Connect your first camera to start vehicle detection and monitoring.',
                    icon: Icons.videocam,
                    buttonText: 'Add Camera',
                    onButtonPressed: _connectCamera,
                  )
                : Column(
                    children: cameras.map((camera) => CameraCard(
                      camera: camera,
                      onEdit: () => _editCamera(camera),
                      onDelete: () => _deleteCamera(camera),
                      onToggle: () => _toggleCamera(camera),
                    )).toList(),
                  ),
          ],
        ),
      ),
    );
  }
}