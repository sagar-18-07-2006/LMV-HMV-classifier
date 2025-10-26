class RestrictedZone {
  final String id;
  final String name;
  final String location;
  final String description;
  final bool isActive;

  RestrictedZone({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    required this.isActive,
  });
}