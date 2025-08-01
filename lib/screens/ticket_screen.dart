import 'package:flutter/material.dart';
import '../models/ticket.dart';
import '../services/api_service.dart';

class TicketScreen extends StatefulWidget {
  final String eventId;

  TicketScreen({required this.eventId});

  @override
  _TicketScreenState createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  late Future<List<Ticket>> _ticketsFuture;

  @override
  void initState() {
    super.initState();
    _ticketsFuture = ApiService.fetchTickets(widget.eventId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Buy Tickets")),
      body: FutureBuilder<List<Ticket>>(
        future: _ticketsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (snapshot.hasError)
            return Center(child: Text("Error: ${snapshot.error}"));

          final tickets = snapshot.data!;
          return ListView.builder(
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              final ticket = tickets[index];
              return Card(
                child: ListTile(
                  title: Text(ticket.title),
                  subtitle: Text('\$${ticket.price.toStringAsFixed(2)}'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // You can navigate to a checkout screen here
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('Ticket Purchased!'),
                          content: Text('You bought a ticket for ${ticket.title}'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('OK'),
                            )
                          ],
                        ),
                      );
                    },
                    child: Text('Buy Ticket'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
