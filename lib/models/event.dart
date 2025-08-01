import '../core/errors/app_exceptions.dart';

class Event {
  final int id;
  final String title;
  final String description;
  final String location;
  final DateTime date;
  final String? imageUrl;
  final String? organizer;
  final bool isActive;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    this.imageUrl,
    this.organizer,
    this.isActive = true,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    try {
      return Event(
        id: int.parse(json['id'].toString()),
        title: json['title']?.toString() ?? '',
        description: json['description']?.toString() ?? '',
        location: json['location']?.toString() ?? '',
        date: DateTime.parse(json['date']),
        imageUrl: json['image_url']?.toString(),
        organizer: json['organizer']?.toString(),
        isActive: json['is_active'] ?? true,
      );
    } catch (e) {
      throw ValidationException('Invalid event data format: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'date': date.toIso8601String(),
      'image_url': imageUrl,
      'organizer': organizer,
      'is_active': isActive,
    };
  }

  Event copyWith({
    int? id,
    String? title,
    String? description,
    String? location,
    DateTime? date,
    String? imageUrl,
    String? organizer,
    bool? isActive,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      date: date ?? this.date,
      imageUrl: imageUrl ?? this.imageUrl,
      organizer: organizer ?? this.organizer,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Event &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Event(id: $id, title: $title, location: $location, date: $date)';
  }
}
