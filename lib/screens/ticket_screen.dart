import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_constants.dart';
import '../models/ticket.dart';
import '../providers/event_provider.dart';
import '../providers/ticket_provider.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/ticket_card.dart';

class TicketScreen extends StatefulWidget {
  final String eventId;

  const TicketScreen({super.key, required this.eventId});

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch tickets when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TicketProvider>().fetchTickets(widget.eventId);
    });
  }

  @override
  void dispose() {
    // Clear tickets when leaving the screen
    context.read<TicketProvider>().clearTickets();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Tickets'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<TicketProvider>().refreshTickets();
            },
          ),
        ],
      ),
      body: Consumer2<EventProvider, TicketProvider>(
        builder: (context, eventProvider, ticketProvider, child) {
          // Get event details
          final event = eventProvider.getEventById(int.parse(widget.eventId));
          
          return Column(
            children: [
              // Event header
              if (event != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        event.location,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              
              // Tickets list
              Expanded(
                child: _buildTicketsList(ticketProvider),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTicketsList(TicketProvider ticketProvider) {
    switch (ticketProvider.state) {
      case TicketState.initial:
      case TicketState.loading:
        return const AppLoadingWidget(
          message: 'Loading tickets...',
        );

      case TicketState.error:
        return AppErrorWidget(
          message: ticketProvider.errorMessage ?? AppConstants.unknownError,
          onRetry: () => ticketProvider.refreshTickets(),
        );

      case TicketState.loaded:
        if (!ticketProvider.hasTickets) {
          return AppErrorWidget(
            message: AppConstants.noTicketsFound,
            icon: Icons.confirmation_number_outlined,
            onRetry: () => ticketProvider.refreshTickets(),
          );
        }

        final availableTickets = ticketProvider.getAvailableTickets();
        final soldOutTickets = ticketProvider.getSoldOutTickets();

        return RefreshIndicator(
          onRefresh: () async {
            await ticketProvider.fetchTickets(widget.eventId);
          },
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              // Available tickets section
              if (availableTickets.isNotEmpty) ...[
                _buildSectionHeader('Available Tickets'),
                ...availableTickets.map((ticket) => TicketCard(
                  ticket: ticket,
                  onPurchase: () => _showPurchaseDialog(ticket),
                )),
              ],
              
              // Sold out tickets section
              if (soldOutTickets.isNotEmpty) ...[
                _buildSectionHeader('Sold Out'),
                ...soldOutTickets.map((ticket) => TicketCard(
                  ticket: ticket,
                )),
              ],
            ],
          ),
        );
    }
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: 8,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  void _showPurchaseDialog(Ticket ticket) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Purchase ${ticket.title}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price: \$${ticket.price.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            Text('Available: ${ticket.availableQuantity}'),
            if (ticket.hasLimitedAvailability) ...[
              const SizedBox(height: 8),
              Text(
                '⚠️ Limited availability',
                style: TextStyle(
                  color: Colors.orange[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessMessage(ticket);
            },
            child: const Text('Purchase'),
          ),
        ],
      ),
    );
  }

  void _showSuccessMessage(Ticket ticket) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Successfully purchased ${ticket.title}!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
