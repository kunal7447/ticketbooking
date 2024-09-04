import 'package:cloud_firestore/cloud_firestore.dart';

class databaseops {

  Future<String?> user(Map<String, dynamic> usermap, String id) async {
    
    final existingUserId = await _checkUserExists(usermap['name'], usermap['password']);
    
    if (existingUserId == null) {
     
      await FirebaseFirestore.instance
        .collection("user")
        .doc(id)
        .set(usermap);
      return id; // Return the new user's ID
    } else {
     
      return existingUserId;
    }
  }

  Stream<QuerySnapshot> museumlist() {
    return FirebaseFirestore.instance.collection("museum").snapshots();
  }

  Future<String?> _checkUserExists(String name, String password) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
      .collection("user")
      .where('name', isEqualTo: name)
      .where('password', isEqualTo: password)
      .get();

    if (result.docs.isNotEmpty) {
      
      return result.docs.first.id;
    }
    return null; 
  }
}
