import 'package:flutter/material.dart';

class DetectionStatus extends StatelessWidget {
  final String vehicleType;
  final String numberPlate;
  final double confidence;
  final bool isRestricted;
  final DateTime timestamp;

  const DetectionStatus({
    super.key,
    required this.vehicleType,
    required this.numberPlate,
    required this.confidence,
    required this.isRestricted,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isRestricted ? Colors.red.shade50 : Colors.green.shade50,
        border: Border.all(
          color: isRestricted ? Colors.red.shade200 : Colors.green.shade200,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            isRestricted ? Icons.warning : Icons.check_circle,
            color: isRestricted ? Colors.red : Colors.green,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$vehicleType - $numberPlate',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Confidence: ${(confidence * 100).toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                Text(
                  'Time: ${_formatTime(timestamp)}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (isRestricted)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'VIOLATION',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}:${timestamp.second.toString().padLeft(2, '0')}';
  }
}