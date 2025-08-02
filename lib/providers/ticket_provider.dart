import 'package:flutter/foundation.dart';
import '../core/errors/app_exceptions.dart';
import '../models/ticket.dart';
import '../services/api_service.dart';

enum TicketState { initial, loading, loaded, error, purchasing }

class TicketProvider with ChangeNotifier {
  TicketState _state = TicketState.initial;
  List<Ticket> _tickets = [];
  String? _errorMessage;
  String? _currentEventId;
  bool _isPurchasing = false;

  // Getters
  TicketState get state => _state;
  List<Ticket> get tickets => _tickets;
  String? get errorMessage => _errorMessage;
  bool get hasTickets => _tickets.isNotEmpty;
  bool get isPurchasing => _isPurchasing;

  Future<void> fetchTickets(String eventId) async {
    try {
      print('TicketProvider: Starting to fetch tickets for eventId: $eventId');
      _state = TicketState.loading;
      _errorMessage = null;
      _currentEventId = eventId;
      notifyListeners();

      print('TicketProvider: Calling API service...');
      final tickets = await ApiService.fetchTickets(eventId);
      
      print('TicketProvider: Received ${tickets.length} tickets from API');
      _tickets = tickets;
      
      // Debug logging for each ticket
      for (int i = 0; i < _tickets.length; i++) {
        final ticket = _tickets[i];
        print('TicketProvider: Ticket $i - ID: ${ticket.id}, Title: ${ticket.title}, IsActive: ${ticket.isActive}, Available: ${ticket.availableQuantity}, IsSoldOut: ${ticket.isSoldOut}');
      }
      
      _state = TicketState.loaded;
      notifyListeners();
    } catch (e) {
      print('TicketProvider: Error fetching tickets: $e');
      _errorMessage = e.toString();
      _state = TicketState.error;
      notifyListeners();
    }
  }

  Future<void> refreshTickets() async {
    if (_currentEventId != null) {
      await fetchTickets(_currentEventId!);
    }
  }

  Future<bool> purchaseTicket(Ticket ticket, int quantity) async {
    try {
      print('TicketProvider: Starting purchase for ticket ${ticket.id}, quantity: $quantity');
      _isPurchasing = true;
      notifyListeners();

      final result = await ApiService.purchaseTicket(ticket.id, quantity);
      
      // Check if the response indicates success
      if (result['success'] == true) {
        print('TicketProvider: Purchase successful, updating ticket quantity');
        
        // Update the ticket quantity locally
        final updatedTicket = ticket.copyWith(
          availableQuantity: result['available_quantity'] ?? ticket.availableQuantity - quantity,
        );
        
        // Find and update the ticket in the list
        final index = _tickets.indexWhere((t) => t.id == ticket.id);
        if (index != -1) {
          _tickets[index] = updatedTicket;
          print('TicketProvider: Updated ticket ${ticket.id} quantity to ${updatedTicket.availableQuantity}');
        }
        
        notifyListeners();
        return true;
      } else {
        print('TicketProvider: Purchase failed - no success flag in response');
        _errorMessage = 'Purchase failed - unexpected response';
        return false;
      }
    } catch (e) {
      print('TicketProvider: Error purchasing ticket: $e');
      _errorMessage = e.toString();
      return false;
    } finally {
      _isPurchasing = false;
      notifyListeners();
    }
  }

  List<Ticket> getAvailableTickets() {
    final availableTickets = _tickets.where((ticket) => 
      ticket.isActive && !ticket.isSoldOut
    ).toList();
    
    print('TicketProvider: Found ${availableTickets.length} available tickets');
    for (final ticket in availableTickets) {
      print('TicketProvider: Checking ticket ${ticket.id} - IsSoldOut: ${ticket.isSoldOut}, IsActive: ${ticket.isActive}, IsAvailable: ${!ticket.isSoldOut}');
    }
    
    return availableTickets;
  }

  List<Ticket> getSoldOutTickets() {
    final soldOutTickets = _tickets.where((ticket) => 
      ticket.isActive && ticket.isSoldOut
    ).toList();
    
    print('TicketProvider: Found ${soldOutTickets.length} sold out tickets');
    return soldOutTickets;
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
    _state = TicketState.initial;
    _errorMessage = null;
    _currentEventId = null;
    _isPurchasing = false;
    notifyListeners();
  }
} 