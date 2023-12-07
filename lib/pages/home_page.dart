import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pickone/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pickone/pages/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_nav_bar/google_nav_bar.dart';



class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> screens = [
    HomePage(),

  ];

  // instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // instance of firestore
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  String currUserName = "";


  void signOut(){
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }

  _fetch() async {
    final firebaseUser = await _auth.currentUser;
    if(firebaseUser != null){
      await _fireStore
        .collection('user')
        .doc(firebaseUser.uid)
        .get()
        .then((ds){
          currUserName=ds.data()!['username'];
      }).catchError((e){
        throw Exception(e.toString());
      });
    }

  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: _fetch(),
          builder: (context,snapshot){
            if (snapshot.connectionState != ConnectionState.done) {
              return const Text("Loading...");
            }
            return Text(currUserName);
          },
        ),
        actions: [
          // sign out button
          IconButton(
              onPressed: signOut,
              icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList(){
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('user').snapshots(),
      builder: (context, snapshot){
        if(snapshot.hasError){
          return const Text('error');
        }
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Text('loading...');
        }
        return ListView(
          children: snapshot.data!.docs
            .map<Widget>((doc) => _buildUserListItem(doc))
            .toList(),
        );
      },
    );
  }
  // build individual user list item
  Widget _buildUserListItem(DocumentSnapshot document){
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    // display all users except current
    if(_auth.currentUser!.email != data['email']){
      return ListTile(
        title: Text(data['email']),
        onTap: (){
          // pass the clicked user UID to the chatpage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiveUserEmail:data['email'],
                receiveUserID:data['uid'],
              ),
            ),
          );
        },
      );
    }
    else {
      return Container();
    }
  }
}
