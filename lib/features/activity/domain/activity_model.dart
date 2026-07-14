class ActivityModel {
  final String type; 
  final Duration duration; 
  final DateTime timestamp; 
  final String photoPath; 
  final String? observations; 

  const ActivityModel({
    required this.type,
    required this.duration,
    required this.timestamp,
    required this.photoPath,
    this.observations,
  });

  bool get isValid => duration.inMinutes >= 30;
}
