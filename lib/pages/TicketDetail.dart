import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart'; 

class TicketDetail extends StatelessWidget {
  final String ticketId;

  const TicketDetail({required this.ticketId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ticket ID: $ticketId',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 32),
            QrImageView(
              data: ticketId,
              version: QrVersions.auto,
              size: 200.0,
              gapless: false,
            ),
          ],
        ),
      ),
    );
  }
}
