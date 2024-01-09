import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pickone/models/friend.dart';

class FriendService extends ChangeNotifier{
  // get instance of auth and fire store
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<void> sendFriendRequest(String receiverId) async {
    // get current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final Timestamp timestamp = Timestamp.now();
    bool request = true;

    QuerySnapshot <Map<String, dynamic>> document = await _fireStore
        .collection('friends')
        .where('senderId', isEqualTo: receiverId)
        .where('receiverId', isEqualTo: currentUserId)
        .get();

    if(document.size > 0){
      request = false;
      String docID = document.docs.first.id;
      Friend updateFriend = Friend(
        senderId: receiverId,
        receiverId: currentUserId,
        request: request,
        timestamp: timestamp,
      );
      await _fireStore
          .collection('friends')
          .doc(docID)
          .update(updateFriend.toMap());
    }

    Friend newFriend = Friend(
      senderId: currentUserId,
      receiverId: receiverId,
      request: request,
      timestamp: timestamp,
    );

    await _fireStore
        .collection('friends')
        .add(newFriend.toMap());
  }

  Future<QuerySnapshot> getFriendsList() async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    QuerySnapshot <Map<String, dynamic>> stream1 = await _fireStore
        .collection('friends')
        .where('senderId', isEqualTo: currentUserId)
        .where('request', isEqualTo: false)
        .get();

    return stream1;
  }
  Future<QuerySnapshot> getFriendsRequestSentList() async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    QuerySnapshot <Map<String, dynamic>> stream1 = await _fireStore
        .collection('friends')
        .where('senderId', isEqualTo: currentUserId)
        .where('request',isEqualTo: true)
        .get();

    return stream1;
  }
  Future<QuerySnapshot> getFriendsRequestList() async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    QuerySnapshot <Map<String, dynamic>> stream1 = await _fireStore
        .collection('friends')
        .where('receiverId', isEqualTo: currentUserId)
        .where('request', isEqualTo: true)
        .get();

    return stream1;
  }
  Future<QuerySnapshot> getPossibleFriendsList() async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    QuerySnapshot <Map<String, dynamic>> stream1 = await _fireStore
        .collection('friends')
        .where('senderId', isEqualTo: currentUserId)
        .get();

    return stream1;
  }


  // this method checks if a user had already sent a friend request
  Future<bool> friendExist(String senderId, String receiverId) async {
    QuerySnapshot <Map<String, dynamic>> document = await _fireStore
        .collection('friends')
        .where('senderId', isEqualTo: senderId)
        .where('receiverId', isEqualTo: receiverId)
        .get();
    if(document.size > 0){
      return true;
    }
    return false;
  }

  // this method lets us know if the other user had already sent the friend request first
  Future<bool> otherFriendSent(String senderId, String receiverId) async{
    QuerySnapshot <Map<String, dynamic>> document = await _fireStore
        .collection('friends')
        .where('senderId', isEqualTo: receiverId)
        .where('receiverId', isEqualTo: senderId)
        .get();
    if(document.size > 0){
      return true;
    }
    return false;
  }

  Future<bool> areFriends(String receiverId) async{
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    QuerySnapshot <Map<String, dynamic>> stream1 = await _fireStore
        .collection('friends')
        .where('senderId', isEqualTo: currentUserId)
        .where('receiverId', isEqualTo: receiverId)
        .where('request', isEqualTo: false)
        .get();

    QuerySnapshot <Map<String, dynamic>> stream2 = await _fireStore
        .collection('friends')
        .where('senderId', isEqualTo: receiverId)
        .where('receiverId', isEqualTo: currentUserId)
        .where('request', isEqualTo: false)
        .get();

    if(stream1.size > 0 || stream2.size > 0){
      return true;
    }
    return false;

  }
}