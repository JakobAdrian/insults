import 'package:flutter/material.dart';

class Favorites extends StatefulWidget {
  final List favorites;
  const Favorites({Key? key, required this.favorites}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Favorite $index'),
            subtitle: Text(widget.favorites[index] as String), 
          );
        },
      ),
    );
  }
}