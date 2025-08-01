import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/app_constants.dart';
import '../core/errors/app_exceptions.dart';
import '../models/event.dart';
import '../models/ticket.dart';

class ApiService {
  static const Duration _timeout = Duration(seconds: 30);
  static final http.Client _client = http.Client();

  static Future<List<Event>> fetchEvents() async {
    try {
      final response = await _client
          .get(Uri.parse('${AppConstants.baseUrl}${AppConstants.eventsEndpoint}'))
          .timeout(_timeout);

      return _handleResponse<List<Event>>(
        response,
        (data) => (data as List).map((e) => Event.fromJson(e)).toList(),
      );
    } on http.ClientException catch (e) {
      throw NetworkException('Failed to connect to server: ${e.message}');
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException('Failed to fetch events: $e');
    }
  }

  static Future<List<Ticket>> fetchTickets(String eventId) async {
    try {
      final response = await _client
          .get(Uri.parse('${AppConstants.baseUrl}${AppConstants.ticketsEndpoint}?event_id=$eventId'))
          .timeout(_timeout);

      return _handleResponse<List<Ticket>>(
        response,
        (data) => (data as List).map((e) => Ticket.fromJson(e)).toList(),
      );
    } on http.ClientException catch (e) {
      throw NetworkException('Failed to connect to server: ${e.message}');
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException('Failed to fetch tickets: $e');
    }
  }

  static T _handleResponse<T>(http.Response response, T Function(dynamic) parser) {
    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        return parser(data);
      } catch (e) {
        throw ValidationException('Invalid response format: $e');
      }
    } else if (response.statusCode >= 500) {
      throw ServerException('Server error: ${response.statusCode}');
    } else if (response.statusCode >= 400) {
      throw ValidationException('Client error: ${response.statusCode}');
    } else {
      throw AppException('Unexpected response: ${response.statusCode}');
    }
  }

  static void dispose() {
    _client.close();
  }
}
