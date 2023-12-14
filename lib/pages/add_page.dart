import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pickone/pages/other_profile_page.dart';

class AddPage extends StatefulWidget{
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage>{


  // instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // instance of firestore
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0),
      ),
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
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child:_buildUserList(),
            ),
          ),
        ),
      ),
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
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
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
    if(_auth.currentUser!.uid != data['uid']){
      return Column(
        children: [
          const SizedBox(height: 10,),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(.4),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),

            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0),
                        radius: 20,
                        backgroundImage: NetworkImage(data['profilepic']),
                      ),
                      const SizedBox(width: 20,),
                      Text(
                        data['username'],
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ]
                  ),
                  IconButton(
                      alignment:Alignment.centerRight,
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OtherProfilePage(
                              receiveUserEmail:data['email'],
                              receiveUserID:data['uid'],
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add, color: Colors.white,)
                  ),
                ]
              ),
              onTap: (){
                // pass the clicked user UID to the chatpage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OtherProfilePage(
                      receiveUserEmail:data['email'],
                      receiveUserID:data['uid'],
                    ),
                  ),
                );
              },
            )
          )
        ]
      );
    }
    else {
      return Container();
    }
  }
}