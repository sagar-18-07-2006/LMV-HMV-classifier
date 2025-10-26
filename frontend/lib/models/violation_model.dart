class Violation {
  final String id;
  final String vehicleNumber;
  final String vehicleType;
  final DateTime dateTime;
  final String location;
  final String cameraId;
  final double confidence;

  Violation({
    required this.id,
    required this.vehicleNumber,
    required this.vehicleType,
    required this.dateTime,
    required this.location,
    required this.cameraId,
    required this.confidence,
  });
}