import 'package:cloud_firestore/cloud_firestore.dart';

class Friend {
  final String senderId;
  final String receiverId;
  final bool request;
  final Timestamp timestamp;

  Friend({
    required this.senderId,
    required this.receiverId,
    required this.request,
    required this.timestamp,
  });

  // convert to map (how it is stored in firebase)
  Map<String, dynamic> toMap(){
    return{
      'senderId':senderId,
      'receiverId':receiverId,
      'request':request,
      'timestamp':timestamp,
    };
  }
  @override
  String toString(){
    return 'Movie {name: $senderId}, image: {$receiverId}';
  }
}