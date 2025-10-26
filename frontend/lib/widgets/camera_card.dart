import 'package:flutter/material.dart';
import '../models/camera_model.dart';

class CameraCard extends StatelessWidget {
  final Camera camera;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggle;

  const CameraCard({
    super.key,
    required this.camera,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.videocam,
                      color: camera.isConnected ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      camera.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Chip(
                  label: Text(
                    camera.isConnected ? 'Connected' : 'Disconnected',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  backgroundColor: camera.isConnected ? Colors.green : Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Location: ${camera.location}',
              style: const TextStyle(color: Colors.grey),
            ),
            if (camera.restrictedZone != null) ...[
              const SizedBox(height: 4),
              Text(
                'Restricted Zone: ${camera.restrictedZone}',
                style: TextStyle(
                  color: Colors.orange[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
                Switch(
                  value: camera.isConnected,
                  onChanged: (value) => onToggle(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}