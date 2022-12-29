import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/category_screen.dart';

class CategoryTile extends StatelessWidget {
  final DocumentSnapshot snapshot;
  const CategoryTile({super.key, required this.snapshot});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage(snapshot.get("icon")),
          ),
          title: Text(snapshot.get("title")),
          trailing: const Icon(Icons.keyboard_arrow_right),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CategoryScreen(snapshot: snapshot)));
          },
        ),
        Divider(
          color: Colors.grey[500],
        ),
      ],
    );
  }
}
