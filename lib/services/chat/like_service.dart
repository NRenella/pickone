import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pickone/models/like.dart';
import 'package:pickone/models/movie.dart';

class LikeService extends ChangeNotifier {

  // get instance of auth and fire store
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  // send message
  Future<void> sendLike(String receiverId, Movie movie, bool superlike) async {

    // get current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final Timestamp timestamp = Timestamp.now();

    // construct a chat room id from current user id and receiver id (sorted to ensure uniqueness)
    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    // Check to see if this user has liked this document before
    QuerySnapshot <Map<String, dynamic>> stream1 = await _fireStore
        .collection('rooms')
        .doc(chatRoomId)
        .collection('likes')
        .where('movieid', isEqualTo: movie.id)
        .where('senderId', isEqualTo: currentUserId)
        .get();

    if(stream1.size > 0){
      // If they have then update it with the superlike value
      updateLike(currentUserId, receiverId, movie, superlike, false);
      return;
    }

    // Check to see if other user liked it already
    QuerySnapshot <Map<String, dynamic>> stream2 = await _fireStore
        .collection('rooms')
        .doc(chatRoomId)
        .collection('likes')
        .where('movieid', isEqualTo: movie.id)
        .where('receiverId', isEqualTo: currentUserId)
        .get();

    // if they have create a new like with current user as sender while updating their like
    if(stream2.size > 0){
      updateLike(receiverId, currentUserId, movie, superlike, true);
      // create a new like with current user as sender
      Like newLike = Like(
        senderId: currentUserId,
        receiverId: receiverId,
        superlike: superlike,
        timestamp: timestamp,
        moviename: movie.name,
        movieimage: movie.image,
        movieoverview: movie.overview,
        movierating: movie.rating,
        movieid: movie.id,
        match: true,
      );

      // add new message to database
      await _fireStore
          .collection('rooms')
          .doc(chatRoomId)
          .collection('likes')
          .add(newLike.toMap());
      return;
    }
    // if both checks fail then create a new document
    Like newLike = Like(
      senderId: currentUserId,
      receiverId: receiverId,
      superlike: superlike,
      timestamp: timestamp,
      moviename: movie.name,
      movieimage: movie.image,
      movieoverview: movie.overview,
      movierating: movie.rating,
      movieid: movie.id,
      match: false,
    );

    // add new message to database
    await _fireStore
        .collection('rooms')
        .doc(chatRoomId)
        .collection('likes')
        .add(newLike.toMap());



    //
    // if(await likeExist(currentUserId, receiverId, movie.id, false)) {
    //   print("other user liked it, its a match");
    //   updateLike(receiverId, movie, superlike);
    // }else if(await likeExist(currentUserId, receiverId, movie.id, true)){
    //   print("lke already exist");
    // } else {
    //   print("Creating new like");
    //   // create a new message
    //   Like newLike = Like(
    //     senderId: currentUserId,
    //     receiverId: receiverId,
    //     superlike: superlike,
    //     timestamp: timestamp,
    //     moviename: movie.name,
    //     movieimage: movie.image,
    //     movieoverview: movie.overview,
    //     movierating: movie.rating,
    //     movieid: movie.id,
    //     match: false,
    //   );
    //
    //   // add new message to database
    //   await _fireStore
    //       .collection('rooms')
    //       .doc(chatRoomId)
    //       .collection('likes')
    //       .add(newLike.toMap());
    // }
  }
  Future<void> deleteLike(String receiverId, Movie movie) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    String docID = await getDocID(currentUserId, receiverId, movie.id);
    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    await _fireStore
        .collection('rooms')
        .doc(chatRoomId)
        .collection('likes')
        .doc(docID)
        .delete();
  }

  Future<void> updateLike(String senderId, String receiverId, Movie movie, bool superlike, bool match) async {
    String docID = await getDocID(senderId, receiverId, movie.id);

    final Timestamp timestamp = Timestamp.now();
    Like newLike = Like(senderId: senderId, receiverId: receiverId, superlike: superlike,
      timestamp: timestamp, moviename: movie.name, movieimage: movie.image, movieoverview: movie.overview,
      movierating: movie.rating, movieid: movie.id, match: match,
    );
    List<String> ids = [senderId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    // update the match parameter to true
    await _fireStore
        .collection('rooms')
        .doc(chatRoomId)
        .collection('likes')
        .doc(docID)
        .update(newLike.toMap());
  }

  // get message
  Stream<QuerySnapshot> getLikes(String userId, String otherUserId){
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

  Future<String> getDocID(String userId, String otherUserId, int movieID) async {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    QuerySnapshot <Map<String, dynamic>> document = await _fireStore
        .collection('rooms')
        .doc(chatRoomId)
        .collection('likes')
        .where('movieid', isEqualTo: movieID)
        .where('senderId', isEqualTo: userId)
        .get();

    return document.docs.first.id;
  }

}