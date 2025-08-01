class AppConstants {
  // API Configuration
  static const String baseUrl = 'http://10.0.0.125/event_api';
  static const String eventsEndpoint = '/get_events.php';
  static const String ticketsEndpoint = '/get_tickets.php';
  
  // App Configuration
  static const String appName = 'Eventeny';
  static const String appVersion = '1.0.0';
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 8.0;
  static const double cardElevation = 2.0;
  
  // Error Messages
  static const String networkError = 'Network error occurred. Please check your connection.';
  static const String serverError = 'Server error occurred. Please try again later.';
  static const String unknownError = 'An unknown error occurred.';
  static const String noEventsFound = 'No events found.';
  static const String noTicketsFound = 'No tickets available for this event.';
} 