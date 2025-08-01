import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/event.dart';
import '../models/ticket.dart';

class ApiService {
  static const baseUrl = 'http://10.0.0.125/event_api';

  static Future<List<Event>> fetchEvents() async {
    final response = await http.get(Uri.parse('$baseUrl/get_events.php'));
    final List data = jsonDecode(response.body);
    return data.map((e) => Event.fromJson(e)).toList();
  }

  static Future<List<Ticket>> fetchTickets(String eventId) async {
    final response = await http.get(Uri.parse('$baseUrl/get_tickets.php?event_id=$eventId'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Ticket.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load tickets');
    }
  }
}
