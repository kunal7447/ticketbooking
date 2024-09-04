import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ticket/pages/TicketDetail.dart'; // Import the QR Flutter package

class Tickets extends StatelessWidget {
  final String userid;

  const Tickets({required this.userid, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Tickets'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
          .collection('ticket')
          .where('userid', isEqualTo: userid)
          .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); 
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); 
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No tickets found')); 
          }

         
          final List<DocumentSnapshot> documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final doc = documents[index];
              final ticketId = doc['ticketId']; 
              final museumId = doc['museumId']; 
              final date = doc['date']; 

              return ListTile(
                title: Text('Ticket ID: $ticketId'),
                subtitle: Text('Museum ID: $museumId\nDate: $date'),
                trailing: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TicketDetail(ticketId: ticketId),
                      ),
                    );
                  },
                  child: const Text('View Ticket'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
