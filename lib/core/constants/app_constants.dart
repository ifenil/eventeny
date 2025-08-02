class AppConstants {
  // API Endpoints
  static const String baseUrl = 'http://10.0.0.125/event_api';
  static const String eventsEndpoint = '/get_events.php';
  static const String ticketsEndpoint = '/get_tickets.php';
  static const String purchaseEndpoint = '/purchase_ticket.php';
  
  // App Configuration
  static const String appName = 'Eventeny';
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 12.0;
  static const double cardElevation = 2.0;
  
  // Error Messages
  static const String noEventsFound = 'No events found.';
  static const String noTicketsFound = 'No tickets available for this event.';
  static const String unknownError = 'An unknown error occurred.';
  static const String networkError = 'Network error. Please check your connection.';
  static const String serverError = 'Server error. Please try again later.';
  
  // Success Messages
  static const String purchaseSuccess = 'Ticket purchased successfully!';
  static const String refreshSuccess = 'Data refreshed successfully!';
  
  // Loading Messages
  static const String loadingEvents = 'Loading events...';
  static const String loadingTickets = 'Loading tickets...';
  static const String processingPurchase = 'Processing purchase...';
} 