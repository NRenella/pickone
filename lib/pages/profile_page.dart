import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pickone/pages/other_profile_page.dart';
import 'package:pickone/services/chat/friend_service.dart';
import 'dart:async';

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

_fetchProfile() async {
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
  final FriendService _friendService = FriendService();
  Set<String> friends = Set();
  bool _doneLoading = false;

  // instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState(){
    super.initState();
    getFriends();
  }

  Future<void> getFriends() async {
    friends = Set();
    QuerySnapshot <Object?> docu = await _friendService.getFriendsRequestList();
    for (var x in docu.docs){
      friends.add(x['senderId'] == _auth.currentUser!.uid ? x['receiverId'] : x['senderId']);
    }
    setState(() {
      _doneLoading = true;
    });
  }

  FutureOr<void> refreshAndGoBack() async {
    getFriends();
    setState(() {});
  }

  Future<void> addAndRefresh(String id) async {
    await _friendService.sendFriendRequest(id);
    getFriends();
    setState(() {});
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'lib/assets/background.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
          child:Column(
            children: [
              FutureBuilder(
                future: _fetchProfile(),
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
             const SizedBox(height: 15,),
              SafeArea(
                child: Center(
                  child:Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child:Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "Friend Request: ",
                        style: TextStyle(
                          color:Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
             const SizedBox(height: 10,),
              Visibility(
                 visible: _doneLoading,
                 child:SafeArea(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child:_buildUserList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),),
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
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
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
    if(friends.contains(data['uid'])){
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
                            onPressed: () => addAndRefresh(data['uid']),
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
                    ).then((_) => refreshAndGoBack());
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