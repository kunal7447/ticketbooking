import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:ticket/pages/home.dart';
import 'package:ticket/service/dbops.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController tname = new TextEditingController();
  TextEditingController tpassword = new TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text("signup"),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Name",
             
            ),
            
            TextField(
             controller: tname,
            ),
            
            Text(
              "Password",
              
            ),
           
            TextField(
             controller: tpassword,
            ),
            ElevatedButton(onPressed: () async {
               
              String Id = randomAlphaNumeric(5);
                 Map<String,dynamic> usermap={
                  "name":tname.text,
                  "password":tpassword.text,
                  "Id":Id,
                 };
               
               final uid = await  databaseops().user(usermap, Id);
               Navigator.push(context,MaterialPageRoute(builder: (context)=>Home(uid!)));
            }, child: Text("signup"))
          ],
        ),
      ),
    );
  }
}