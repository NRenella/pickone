import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget{
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

// instance of auth
final FirebaseAuth _auth = FirebaseAuth.instance;

// instance of firestore
final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

String username = "placeholder";
String email = "place@gmail.com";
String profilepic = "lll";

_fetch() async {
  final firebaseUser = await _auth.currentUser;
  if(firebaseUser != null){
    await _fireStore
        .collection('user')
        .doc(firebaseUser.uid)
        .get()
        .then((ds){
      username=ds.data()!['username']!;
      email=ds.data()!['email']!;
      profilepic=ds.data()!['profilepic']!;
    }).catchError((e){
      throw Exception(e.toString());
    });
  }
}

// sign user out
Future<void> signOut() async {
  return await FirebaseAuth.instance.signOut();
}

class _ProfilePageState extends State<ProfilePage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'lib/assets/background.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: FutureBuilder(
            future: _fetch(),
            builder: (context,snapshot){
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              }
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0),
                        radius: 80,
                        backgroundImage: NetworkImage(profilepic),
                      ),
                      const SizedBox(height: 10,),
                      // welcome back message
                      Text(
                        username,
                        style: const TextStyle(
                          fontSize: 64,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Text(
                        email,
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 15,),
                      GestureDetector(
                        onTap: signOut,
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: const Center(
                            child: Text(
                              "Sign Out",
                              style: TextStyle(
                                color:Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}