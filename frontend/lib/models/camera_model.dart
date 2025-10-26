class Camera {
  final String id;
  final String name;
  final String location;
  final bool isConnected;
  final String? restrictedZone;

  Camera({
    required this.id,
    required this.name,
    required this.location,
    required this.isConnected,
    this.restrictedZone,
  });
}