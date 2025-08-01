import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/api_service.dart'; // <-- import your ApiService here
import 'ticket_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Event Tickets')),
      body: FutureBuilder<List<Event>>(
        future: ApiService.fetchEvents(),  // fetch from backend
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No events found.'));
          } else {
            final events = snapshot.data!;
            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return ListTile(
                  title: Text(event.title),
                  subtitle: Text('${event.location} • ${event.date.toLocal().toShortDateString()}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TicketScreen(
                          eventId: event.id.toString(), // pass event ID as string
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

extension DateFormatting on DateTime {
  String toShortDateString() {
    return "${this.month}/${this.day}/${this.year}";
  }
}