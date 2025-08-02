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
      final url = '${AppConstants.baseUrl}${AppConstants.eventsEndpoint}';
      print('ApiService: Fetching events from: $url');
      
      final response = await _client
          .get(Uri.parse(url))
          .timeout(_timeout);

      print('ApiService: Events response status: ${response.statusCode}');
      print('ApiService: Events response body: ${response.body}');

      return _handleResponse<List<Event>>(
        response,
        (data) {
          // Debug logging to see the actual response format
          print('ApiService: Parsed events data: $data');
          return (data as List).map((e) => Event.fromJson(e)).toList();
        },
      );
    } on http.ClientException catch (e) {
      print('ApiService: Client exception: $e');
      throw NetworkException('Failed to connect to server: ${e.message}');
    } catch (e) {
      print('ApiService: Unexpected error in fetchEvents: $e');
      if (e is AppException) rethrow;
      throw AppException('Failed to fetch events: $e');
    }
  }

  static Future<List<Ticket>> fetchTickets(String eventId) async {
    try {
      final url = '${AppConstants.baseUrl}${AppConstants.ticketsEndpoint}?event_id=$eventId';
      print('ApiService: Fetching tickets from: $url');
      
      final response = await _client
          .get(Uri.parse(url))
          .timeout(_timeout);

      print('ApiService: Tickets response status: ${response.statusCode}');
      print('ApiService: Tickets response body: ${response.body}');

      return _handleResponse<List<Ticket>>(
        response,
        (data) {
          // Debug logging to see the actual response format
          print('ApiService: Parsed tickets data: $data');
          return (data as List).map((e) => Ticket.fromJson(e)).toList();
        },
      );
    } on http.ClientException catch (e) {
      print('ApiService: Client exception: $e');
      throw NetworkException('Failed to connect to server: ${e.message}');
    } catch (e) {
      print('ApiService: Unexpected error in fetchTickets: $e');
      if (e is AppException) rethrow;
      throw AppException('Failed to fetch tickets: $e');
    }
  }

  static T _handleResponse<T>(http.Response response, T Function(dynamic) parser) {
    print('ApiService: Handling response with status: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        print('ApiService: Successfully decoded JSON: $data');
        return parser(data);
      } catch (e) {
        print('ApiService: JSON decode error: $e');
        throw ValidationException('Invalid response format: $e');
      }
    } else if (response.statusCode >= 500) {
      print('ApiService: Server error: ${response.statusCode}');
      throw ServerException('Server error: ${response.statusCode}');
    } else if (response.statusCode >= 400) {
      print('ApiService: Client error: ${response.statusCode}');
      throw ValidationException('Client error: ${response.statusCode}');
    } else {
      print('ApiService: Unexpected response: ${response.statusCode}');
      throw AppException('Unexpected response: ${response.statusCode}');
    }
  }

  static void dispose() {
    _client.close();
  }
}
