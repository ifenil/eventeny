class Ticket {
  final int id;
  final int eventId;
  final String title;
  final String type;
  final double price;
  final int quantity;

  Ticket({
    required this.id,
    required this.eventId,
    required this.title,
    required this.type,
    required this.price,
    required this.quantity,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: int.parse(json['id']),
      eventId: int.parse(json['event_id']),
      title: json['title'],
      type: json['type'],
      price: double.parse(json['price']),
      quantity: int.parse(json['quantity']),
    );
  }
}
