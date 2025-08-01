class Event {
  final int id;
  final String title;
  final String description;
  final String location;
  final DateTime date;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.date,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: int.parse(json['id']),
      title: json['title'],
      description: json['description'],
      location: json['location'],
      date: DateTime.parse(json['date']),
    );
  }
}
