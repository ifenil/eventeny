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
    _setState(TicketState.loading);
    _clearError();
    _currentEventId = eventId;

    try {
      final tickets = await ApiService.fetchTickets(eventId);
      _tickets = tickets;
      _setState(TicketState.loaded);
    } catch (e) {
      _handleError(e);
    }
  }

  void refreshTickets() {
    if (_currentEventId != null) {
      fetchTickets(_currentEventId!);
    }
  }

  List<Ticket> getAvailableTickets() {
    return _tickets.where((ticket) => !ticket.isSoldOut && ticket.isActive).toList();
  }

  List<Ticket> getSoldOutTickets() {
    return _tickets.where((ticket) => ticket.isSoldOut).toList();
  }

  Ticket? getTicketById(int id) {
    try {
      return _tickets.firstWhere((ticket) => ticket.id == id);
    } catch (e) {
      return null;
    }
  }

  void clearTickets() {
    _tickets = [];
    _currentEventId = null;
    _setState(TicketState.initial);
  }

  void _setState(TicketState newState) {
    _state = newState;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  void _handleError(dynamic error) {
    if (error is AppException) {
      _errorMessage = error.message;
    } else {
      _errorMessage = 'An unexpected error occurred';
    }
    _setState(TicketState.error);
  }
} 