import 'package:flutter/material.dart';
import '../models/zone_model.dart';
import '../widgets/zone_card.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/empty_state.dart';

class RestrictedZonesScreen extends StatefulWidget {
  const RestrictedZonesScreen({super.key});

  @override
  State<RestrictedZonesScreen> createState() => _RestrictedZonesScreenState();
}

class _RestrictedZonesScreenState extends State<RestrictedZonesScreen> {
  final TextEditingController _zoneNameController = TextEditingController();
  final TextEditingController _zoneLocationController = TextEditingController();
  final TextEditingController _zoneDescriptionController = TextEditingController();

  List<RestrictedZone> zones = [
    RestrictedZone(
      id: '1',
      name: 'Main Gate Area',
      location: 'Gate A',
      description: 'No HMV vehicles allowed in this area during business hours',
      isActive: true,
    ),
    RestrictedZone(
      id: '2',
      name: 'Parking Zone A',
      location: 'North Parking',
      description: 'Restricted for heavy vehicles - LMV only',
      isActive: true,
    ),
    RestrictedZone(
      id: '3',
      name: 'Administrative Block',
      location: 'Building A',
      description: 'Only authorized LMV vehicles permitted',
      isActive: false,
    ),
  ];

  void _addZone() {
    if (_zoneNameController.text.isEmpty || _zoneLocationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill zone name and location'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final newZone = RestrictedZone(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _zoneNameController.text,
      location: _zoneLocationController.text,
      description: _zoneDescriptionController.text,
      isActive: true,
    );

    setState(() {
      zones.add(newZone);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Restricted zone added successfully'),
        backgroundColor: Colors.green,
      ),
    );

    _zoneNameController.clear();
    _zoneLocationController.clear();
    _zoneDescriptionController.clear();
  }

  void _editZone(RestrictedZone zone) {
    // Pre-fill the form with zone data
    _zoneNameController.text = zone.name;
    _zoneLocationController.text = zone.location;
    _zoneDescriptionController.text = zone.description;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Restricted Zone'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: _zoneNameController,
                labelText: 'Zone Name',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _zoneLocationController,
                labelText: 'Location',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _zoneDescriptionController,
                labelText: 'Description',
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Update zone logic
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Zone updated successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteZone(String zoneId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Zone'),
        content: const Text('Are you sure you want to delete this restricted zone?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                zones.removeWhere((zone) => zone.id == zoneId);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Zone deleted successfully'),
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

  void _toggleZone(String zoneId, bool isActive) {
    setState(() {
      final index = zones.indexWhere((zone) => zone.id == zoneId);
      zones[index] = RestrictedZone(
        id: zones[index].id,
        name: zones[index].name,
        location: zones[index].location,
        description: zones[index].description,
        isActive: isActive,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restricted Zones'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Add Zone Form
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add New Restricted Zone',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _zoneNameController,
                      labelText: 'Zone Name',
                      prefixIcon: Icons.dangerous,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _zoneLocationController,
                      labelText: 'Location',
                      prefixIcon: Icons.location_on,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _zoneDescriptionController,
                      labelText: 'Description',
                      prefixIcon: Icons.description,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      text: 'ADD RESTRICTED ZONE',
                      onPressed: _addZone,
                      backgroundColor: Colors.red,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Zones List
            const Text(
              'Restricted Zones',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            zones.isEmpty
                ? EmptyState(
                    title: 'No Restricted Zones',
                    description: 'Add restricted zones to monitor HMV vehicle violations in specific areas.',
                    icon: Icons.dangerous,
                    buttonText: 'Add Zone',
                    onButtonPressed: _addZone,
                  )
                : Column(
                    children: zones.map((zone) => ZoneCard(
                      zone: zone,
                      onEdit: () => _editZone(zone),
                      onDelete: () => _deleteZone(zone.id),
                      onToggle: (value) => _toggleZone(zone.id, value),
                    )).toList(),
                  ),
          ],
        ),
      ),
    );
  }
}