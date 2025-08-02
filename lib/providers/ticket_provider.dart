import 'package:flutter/foundation.dart';
import '../core/errors/app_exceptions.dart';
import '../models/ticket.dart';
import '../services/api_service.dart';

enum TicketState { initial, loading, loaded, error }

class TicketProvider with ChangeNotifier {
  TicketState _state = TicketState.initial;
  List<Ticket> _tickets = [];
  String? _errorMessage;
  String? _currentEventId;

  TicketState get state => _state;
  List<Ticket> get tickets => _tickets;
  String? get errorMessage => _errorMessage;
  String? get currentEventId => _currentEventId;

  bool get isLoading => _state == TicketState.loading;
  bool get hasError => _state == TicketState.error;
  bool get hasTickets => _tickets.isNotEmpty;

  Future<void> fetchTickets(String eventId) async {
    print('TicketProvider: Starting to fetch tickets for eventId: $eventId');
    _setState(TicketState.loading);
    _clearError();
    _currentEventId = eventId;

    try {
      print('TicketProvider: Calling API service...');
      final tickets = await ApiService.fetchTickets(eventId);
      print('TicketProvider: Received ${tickets.length} tickets from API');
      
      // Debug: Print each ticket's details
      for (int i = 0; i < tickets.length; i++) {
        final ticket = tickets[i];
        print('TicketProvider: Ticket $i - ID: ${ticket.id}, Title: ${ticket.title}, IsActive: ${ticket.isActive}, Available: ${ticket.availableQuantity}, IsSoldOut: ${ticket.isSoldOut}');
      }
      
      _tickets = tickets;
      _setState(TicketState.loaded);
    } catch (e) {
      print('TicketProvider: Error occurred: $e');
      _handleError(e);
    }
  }

  void refreshTickets() {
    if (_currentEventId != null) {
      print('TicketProvider: Refreshing tickets for eventId: $_currentEventId');
      fetchTickets(_currentEventId!);
    } else {
      print('TicketProvider: Cannot refresh - no current event ID');
    }
  }

  List<Ticket> getAvailableTickets() {
    final available = _tickets.where((ticket) {
      final isAvailable = !ticket.isSoldOut && ticket.isActive;
      print('TicketProvider: Checking ticket ${ticket.id} - IsSoldOut: ${ticket.isSoldOut}, IsActive: ${ticket.isActive}, IsAvailable: $isAvailable');
      return isAvailable;
    }).toList();
    print('TicketProvider: Found ${available.length} available tickets');
    return available;
  }

  List<Ticket> getSoldOutTickets() {
    final soldOut = _tickets.where((ticket) => ticket.isSoldOut).toList();
    print('TicketProvider: Found ${soldOut.length} sold out tickets');
    return soldOut;
  }

  Ticket? getTicketById(int id) {
    try {
      return _tickets.firstWhere((ticket) => ticket.id == id);
    } catch (e) {
      print('TicketProvider: Ticket with id $id not found');
      return null;
    }
  }

  void clearTickets() {
    print('TicketProvider: Clearing tickets');
    _tickets = [];
    _currentEventId = null;
    _setState(TicketState.initial);
  }

  void _setState(TicketState newState) {
    print('TicketProvider: State changing from $_state to $newState');
    _state = newState;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  void _handleError(dynamic error) {
    print('TicketProvider: Handling error: $error');
    if (error is AppException) {
      _errorMessage = error.message;
    } else {
      _errorMessage = 'An unexpected error occurred: $error';
    }
    _setState(TicketState.error);
  }
} 