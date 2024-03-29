import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pickone/models/message.dart';
class ChatService extends ChangeNotifier {
  // get instance of auth and fire store

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  // send message
  Future<void> sendMessage(String receiverId, String message) async {
    // get current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    // create a new message
    Message newMessage = Message(
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        receiverId: receiverId,
        message: message,
        timestamp: timestamp
    );

    // construct a chat room id from current user id and receiver id (sorted to ensure uniqueness)
    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    // add new message to database
    await _fireStore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }


  //REFACTOR THIS TO HAVE TWO DIFFERENT NOTIFICATIONS CURRENTLY THERE IS ONE
  // get message
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId){
    // construct a chat room id using the user ids
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _fireStore
        .collection('rooms')
        .doc(chatRoomId)
        .collection('likes')
        .orderBy('timestamp',descending: false)
        .snapshots();
  }

}