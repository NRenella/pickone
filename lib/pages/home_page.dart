import 'package:flutter/material.dart';
import 'package:pickone/components/movie_card.dart';
import 'package:pickone/models/movie.dart';
import 'package:pickone/services/chat/movie_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pickone/pages/other_profile_page.dart';
import 'package:pickone/pages/chat_page.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Movie> _movies = [];
  bool _isLoading = true;
  // instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState(){
    super.initState();
    getMovies();
  }

  Future<void> getMovies() async{
    _movies = await MovieApi.getMovie();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
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
    if(_auth.currentUser!.email != data['email']){
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
                                  builder: (context) => ChatPage(
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
                        builder: (context) => ChatPage(
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
