import 'package:flutter/material.dart';

class RealTimeDetectionScreen extends StatefulWidget {
  const RealTimeDetectionScreen({super.key});

  @override
  State<RealTimeDetectionScreen> createState() => _RealTimeDetectionScreenState();
}

class _RealTimeDetectionScreenState extends State<RealTimeDetectionScreen> {
  bool _isDetecting = false;
  String _selectedCamera = 'Camera 1';

  // Mock detection results
  final List<Map<String, dynamic>> _detections = [
    {
      'vehicleType': 'HMV',
      'confidence': 0.95,
      'numberPlate': 'ABC123',
      'timestamp': '14:30:25',
      'inRestrictedZone': true,
    },
    {
      'vehicleType': 'LMV',
      'confidence': 0.88,
      'numberPlate': 'XYZ789',
      'timestamp': '14:30:30',
      'inRestrictedZone': false,
    },
    {
      'vehicleType': 'HMV',
      'confidence': 0.92,
      'numberPlate': 'DEF456',
      'timestamp': '14:30:35',
      'inRestrictedZone': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real-time Detection'),
      ),
      body: Column(
        children: [
          // Camera Selection and Controls
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text('Select Camera:'),
                      const SizedBox(width: 16),
                      DropdownButton<String>(
                        value: _selectedCamera,
                        items: ['Camera 1', 'Camera 2', 'Camera 3']
                            .map((camera) => DropdownMenuItem(
                                  value: camera,
                                  child: Text(camera),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() => _selectedCamera = value!);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() => _isDetecting = !_isDetecting);
                        if (_isDetecting) {
                          // Start receiving video stream from backend/AI model
                          _showDetectionStarted();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isDetecting ? Colors.red : Colors.green,
                      ),
                      child: Text(
                        _isDetecting ? 'STOP DETECTION' : 'START DETECTION',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Video Feed Placeholder
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _isDetecting
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.videocam, size: 60, color: Colors.blue),
                        const SizedBox(height: 16),
                        const Text(
                          'Live Detection Feed',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Camera: $_selectedCamera',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        // AI model output would be displayed here
                        const Text(
                          'AI Model Output: Vehicles detected with bounding boxes\nHMV/LMV classification + Number plate recognition',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.blue),
                        ),
                      ],
                    )
                  : const Center(
                      child: Text(
                        'Detection not started\nPress START DETECTION to begin',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
            ),
          ),

          // Detection Results
          if (_isDetecting) ...[
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Recent Detections:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 1,
              child: ListView.builder(
                itemCount: _detections.length,
                itemBuilder: (context, index) {
                  final detection = _detections[index];
                  return ListTile(
                    leading: Icon(
                      detection['inRestrictedZone'] ? Icons.warning : Icons.check_circle,
                      color: detection['inRestrictedZone'] ? Colors.red : Colors.green,
                    ),
                    title: Text('${detection['vehicleType']} - ${detection['numberPlate']}'),
                    subtitle: Text('Confidence: ${(detection['confidence'] * 100).toStringAsFixed(1)}%'),
                    trailing: Text(detection['timestamp']),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showDetectionStarted() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('AI detection started. Processing video feed...'),
        backgroundColor: Colors.green,
      ),
    );
  }
}