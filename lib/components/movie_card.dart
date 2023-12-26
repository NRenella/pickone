import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pickone/services/auth/card_provider.dart';
import 'dart:math';

class MovieCard extends StatefulWidget {
  final String name;
  final String image;
  final String overview;
  final double rating;
  final int id;
  final bool isFront;

  const MovieCard({
    super.key,
    required this.name,
    required this.image,
    required this.overview,
    required this.rating,
    required this.id,
    required this.isFront,
  });

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard>{

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;

      final provider = Provider.of<CardProvider>(context, listen: false);
      provider.setScreenSize(size);
    });
  }

  @override
  Widget build(BuildContext context) => SizedBox.expand(
    child: widget.isFront ? buildFrontCard() : buildCard(),
  );
  Widget buildFrontCard() => GestureDetector(
    child: LayoutBuilder(
      builder: (context, constraints) {
        final provider = Provider.of<CardProvider>(context, listen: true);
        final position = provider.position;
        final milliseconds = provider.isDragging ? 0 : 400;

        final center = constraints.smallest.center(Offset.zero);
        final angle = provider.angle * pi / 180;
        final rotatedMatrix = Matrix4.identity()
          ..translate(center.dx, center.dy)
          ..rotateZ(angle)
          ..translate(-center.dx, -center.dy);

        return AnimatedContainer(
          duration: Duration(milliseconds: milliseconds),
          child: buildCard(),
          transform: rotatedMatrix..translate(position.dx,position.dy),
          curve: Curves.easeInOut,
        );
      },
    ),
    onPanStart:(details){
      final provider = Provider.of<CardProvider>(context,listen: false);
      provider.startPosition(details);
    }, onPanUpdate: (details){
      final provider = Provider.of<CardProvider>(context,listen: false);
      provider.updatePosition(details);
    }, onPanEnd: (details){
      final provider = Provider.of<CardProvider>(context,listen: false);
      provider.endPosition();
    },
  );

  Widget buildCard() => ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(widget.image),
          fit: BoxFit.fill,
          alignment: const Alignment(-0.3,0)
        ),
      ),
    ),
  );
}




