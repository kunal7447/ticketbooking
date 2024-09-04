import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Book extends StatefulWidget {
  final String userid;
  final String museumId;

  const Book({required this.userid, required this.museumId, super.key});

  @override
  State<Book> createState() => _BookState();
}

class _BookState extends State<Book> {
  final TextEditingController _dateController = TextEditingController();

  Future<void> _selectDate() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null && selectedDate != DateTime.now()) {
      setState(() {
        // Format the date as YYYY-MM-DD
        _dateController.text = "${selectedDate.toLocal().toIso8601String().split('T').first}";
      });
    }
  }

  void _bookAndPay() async {
    final date = _dateController.text.trim();
    if (date.isEmpty) {
      // Show an error if the date is not selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a date')),
      );
      return;
    }

    final ticketId = widget.userid + date + widget.museumId; // Generate a unique ticket ID

    // Create a map to store in Firestore
    final ticketData = {
      'userid': widget.userid,
      'museumId': widget.museumId,
      'date': date,
      'ticketId': ticketId,
    };

    // Store the booking details in Firestore
    await FirebaseFirestore.instance.collection('ticket').doc(ticketId).set(ticketData);

    // Navigate to confirmation screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingConfirmation(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Museum ${widget.museumId}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "User ID: ${widget.userid}",
            ),
            SizedBox(height: 16),
            Text(
              "Museum ID: ${widget.museumId}",
            ),
            SizedBox(height: 32),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Select Date',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: _selectDate,
                ),
              ),
              keyboardType: TextInputType.none, // Prevent manual typing
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _bookAndPay,
              child: const Text('Book and Pay'),
            ),
          ],
        ),
      ),
    );
  }
}

class BookingConfirmation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Confirmation'),
      ),
      body: Center(
        child: const Text(
          'Your ticket is booked!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
