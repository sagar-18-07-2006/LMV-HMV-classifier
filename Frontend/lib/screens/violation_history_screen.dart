import 'package:flutter/material.dart';
import '../models/violation_model.dart';
import '../widgets/violation_card.dart';
import '../widgets/empty_state.dart';

class ViolationHistoryScreen extends StatefulWidget {
  const ViolationHistoryScreen({super.key});

  @override
  State<ViolationHistoryScreen> createState() => _ViolationHistoryScreenState();
}

class _ViolationHistoryScreenState extends State<ViolationHistoryScreen> {
  List<Violation> violations = [
    Violation(
      id: '1',
      vehicleNumber: 'ABC123',
      vehicleType: 'HMV',
      dateTime: DateTime(2024, 1, 15, 14, 30),
      location: 'Gate A',
      cameraId: 'cam1',
      confidence: 0.95,
    ),
    Violation(
      id: '2',
      vehicleNumber: 'XYZ789',
      vehicleType: 'HMV',
      dateTime: DateTime(2024, 1, 15, 10, 15),
      location: 'Parking Lot',
      cameraId: 'cam2',
      confidence: 0.87,
    ),
  ];

  void _viewViolationDetails(Violation violation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Violation Details'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Vehicle: ${violation.vehicleNumber}'),
            Text('Type: ${violation.vehicleType}'),
            Text('Location: ${violation.location}'),
            Text('Time: ${violation.dateTime.toString()}'),
            Text('Confidence: ${(violation.confidence * 100).toStringAsFixed(1)}%'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _exportViolation(Violation violation) {
    // Implement export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exported violation ${violation.vehicleNumber}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Violation History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshViolations,
          ),
        ],
      ),
      body: violations.isEmpty
          ? EmptyState(
              title: 'No Violations Found',
              description: 'No HMV violations have been detected yet. Violations will appear here when HMV vehicles are found in restricted zones.',
              icon: Icons.warning,
              buttonText: 'Check Again',
              onButtonPressed: _refreshViolations,
            )
          : ListView.builder(
              itemCount: violations.length,
              itemBuilder: (context, index) {
                final violation = violations[index];
                return ViolationCard(
                  violation: violation,
                  onViewDetails: () => _viewViolationDetails(violation),
                  onExport: () => _exportViolation(violation),
                );
              },
            ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Violations'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Add filter options here
            Text('Filter options will be implemented here'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _refreshViolations() {
    // Implement refresh logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Refreshing violations...'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}