import 'package:cloud_firestore/cloud_firestore.dart';
class Like {
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final bool superlike;
  final Timestamp timestamp;
  final String moviename;
  final String movieimage;
  final String movieoverview;
  final double movierating;
  final int movieid;
  final bool match;

  Like({
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.superlike,
    required this.timestamp,
    required this.moviename,
    required this.movieimage,
    required this.movieoverview,
    required this.movierating,
    required this.movieid,
    required this.match,
  });

  // convert to map (how it is stored in firebase)
  Map<String, dynamic> toMap(){
    return{
      'senderId':senderId,
      'senderEmail':senderEmail,
      'receiverId':receiverId,
      'superlike': superlike,
      'timestamp':timestamp,
      'moviename':moviename,
      'movieimage':movieimage,
      'movieoverview': movieoverview,
      'movierating': movierating,
      'movieid': movieid,
      'match': match

    };
  }
  @override
  String toString(){
    return 'Movie {name: $moviename}, image: {$movieimage}';
  }
}