import 'package:flutter/material.dart';
import 'package:pickone/models/movie.dart';
import 'package:pickone/services/chat/like_service.dart';


enum CardStatus {like, dislike, superLike}

class CardProvider extends ChangeNotifier{
  final LikeService _likeService = LikeService();
  bool _isDragging = false;
  Offset _position = Offset.zero;
  Size _screenSize = Size.zero;
  double _angle = 0;
  List<Movie> _movies = [];
  String _senderId = "";
  String _senderEmail = "";
  String _receiverId = "";



  bool get isDragging => _isDragging;
  Offset get position => _position;
  double get angle => _angle;
  List<Movie> get movs => _movies;

  void setMovies(List<Movie> movies) => _movies = movies;
  void setScreenSize(Size screenSize) => _screenSize = screenSize;
  void setSenderId(String senderId) =>  _senderId = senderId;
  void setSenderEmail(String senderEmail) =>  _senderEmail = senderEmail;
  void setReceiverId(String receiverId) =>  _receiverId = receiverId;

  void startPosition(DragStartDetails details){
    _isDragging = true;

    notifyListeners();
  }
  void updatePosition(DragUpdateDetails details){
    _position += details.delta;

    final x = _position.dx;
    _angle = 45 * x / _screenSize.width;

    notifyListeners();
  }
  void endPosition(){
    _isDragging = false;
    notifyListeners();

    final status = getStatus();

    switch (status) {
      case CardStatus.like:
        like();
        break;
      case CardStatus.dislike:
        dislike();
        break;
      case CardStatus.superLike:
        superLike();
        break;
      default:
        resetPosition();
    }
  }

  void sendLike(bool superLike) async {
    await _likeService.sendLike(_receiverId, _movies.last, superLike);
  }

  void resetPosition(){
    _isDragging = false;
    _position = Offset.zero;
    _angle = 0;

    notifyListeners();
  }

  CardStatus? getStatus(){
    final x = _position.dx;
    final y = _position.dy;
    final forceSuperLike = x.abs() < 20;

    const delta = 100;

    if (x >= delta){
      return CardStatus.like;
    } else if (x <= -delta){
      return CardStatus.dislike;
    } else if (y <= -delta / 2 && forceSuperLike){
      return CardStatus.superLike;
    }

  }

  void like(){
    _angle = 20;
    _position += Offset(_screenSize.width * 2, 0);
    sendLike(false);
    _nextCard();

    notifyListeners();
  }
  void dislike(){
    _angle = -20;
    _position -= Offset(_screenSize.width * 2, 0);
    _nextCard();

    notifyListeners();
  }
  void superLike(){
    _angle = 0;
    _position -= Offset(0,_screenSize.height);
    sendLike(true);
    _nextCard();

    notifyListeners();
  }



  Future _nextCard() async {
    if(_movies.isEmpty) return;

    await Future.delayed(const Duration(milliseconds: 200));
    _movies.removeLast();
    resetPosition();
  }
}