import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ticket/pages/Tickets.dart';
import 'package:ticket/pages/book.dart';
import 'package:ticket/service/dbops.dart'; 

class Home extends StatefulWidget {
  final String userid;

  const Home(this.userid, {super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final databaseops _dbOps = databaseops(); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Museum List"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _dbOps.museumlist(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); 
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); 
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No museums found')); 
          }

          
          final List<DocumentSnapshot> documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final doc = documents[index];
              final museumId = doc.id; 
              final museumName = doc['Name']; 

              return ListTile(
                title: Text(museumName), 
                trailing: ElevatedButton(
                  onPressed: () {
                    
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Book(
                          userid: widget.userid,
                          museumId: museumId,
                        ),
                      ),
                    );
                  },
                  child: const Text('Explore'), 
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Tickets(userid: widget.userid),
            ),
          );
        },
        child: const Icon(Icons.visibility), 
        tooltip: 'View Tickets',
      ),
    );
  }
}
