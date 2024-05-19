import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class FavoriteWord extends StatefulWidget {
  @override
  _FavoriteWordState createState() => _FavoriteWordState();
}

class _FavoriteWordState extends State<FavoriteWord> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Word'),
      ),
      body: Center(
        child: Text('Favorite Word Screen'),
      ),
    );
  }
}