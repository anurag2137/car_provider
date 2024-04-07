import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_provider.dart';
import 'function.dart';

class LikeDislikeWidget extends StatefulWidget {
  final int carId;

  const LikeDislikeWidget({Key? key, required this.carId}) : super(key: key);

  @override
  State<LikeDislikeWidget> createState() => _LikeDislikeWidgetState();
}

class _LikeDislikeWidgetState extends State<LikeDislikeWidget> {
  int _likeCount = 0; // Initial like count
  bool _isLiked = false;

  void _toggleLike() async {
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });

    if (_isLiked) {
      await postLikeData(like: _isLiked, id: widget.carId);
      // Navigate to LikedItemPage after liking the item
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LikedItemPage(carId: widget.carId)),
      );
    } else {
      await postDislikeData(id: widget.carId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return FloatingActionButton(
      onPressed: _toggleLike,
      child: Icon(
        _isLiked ? Icons.favorite : Icons.favorite_border,
        color: _isLiked ? Colors.red : null,
      ),

    );
  }
}

class LikedItemPage extends StatelessWidget {
  final int carId;

  const LikedItemPage({Key? key, required this.carId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fetch item details using carId and display them
    return Scaffold(
      appBar: AppBar(
        title: Text('Liked Item'),
      ),
      body: Center(
        child: Text('You liked car with ID: $carId'),
      ),
    );
  }
}
