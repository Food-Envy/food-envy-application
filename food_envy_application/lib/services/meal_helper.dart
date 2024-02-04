import 'dart:collection';
import 'dart:ffi';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<Map<String, List>?> getPosts(String meal, List friends) async {
  final DocumentSnapshot doc =
      await FirebaseFirestore.instance.collection('Photos').doc(meal).get();
  if (doc.exists) {
    Map<String, dynamic> posts = doc.data() as Map<String, dynamic>;
    Map<String, List> friendsPosts = {};
    friends.forEach((user) {
      String username = user as String;
      if (posts.containsKey(username)) {
        friendsPosts[username] = posts[username] as List;
      }
    });
    print(friendsPosts);
    return friendsPosts;
  } else {
    return null;
  }
}
