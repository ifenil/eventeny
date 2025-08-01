import 'package:flutter/foundation.dart';
import '../core/errors/app_exceptions.dart';
import '../models/event.dart';
import '../services/api_service.dart';

enum EventState { initial, loading, loaded, error }

class EventProvider with ChangeNotifier {
  EventState _state = EventState.initial;
  List<Event> _events = [];
  String? _errorMessage;

  EventState get state => _state;
  List<Event> get events => _events;
  String? get errorMessage => _errorMessage;

  bool get isLoading => _state == EventState.loading;
  bool get hasError => _state == EventState.error;
  bool get hasEvents => _events.isNotEmpty;

  Future<void> fetchEvents() async {
    _setState(EventState.loading);
    _clearError();

    try {
      final events = await ApiService.fetchEvents();
      _events = events;
      _setState(EventState.loaded);
    } catch (e) {
      _handleError(e);
    }
  }

  void refreshEvents() {
    fetchEvents();
  }

  Event? getEventById(int id) {
    try {
      return _events.firstWhere((event) => event.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Event> getActiveEvents() {
    return _events.where((event) => event.isActive).toList();
  }

  void _setState(EventState newState) {
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
    _setState(EventState.error);
  }
} 