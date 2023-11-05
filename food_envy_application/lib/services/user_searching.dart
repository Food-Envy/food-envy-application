import 'dart:collection';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<void> addUsername(
    FirebaseFirestore db, String uuid, String username) async {
  //Future.delayed(const Duration(milliseconds: 100), () {});
  db.collection("UUIDs").doc("usernames").update(({username: uuid}));
}

Future<Map<String, dynamic>?> getUsers() async {
  final DocumentSnapshot doc = await FirebaseFirestore.instance
      .collection('UUIDs')
      .doc("usernames")
      .get();
  if (doc.exists) {
    Map<String, dynamic> users = doc.data() as Map<String, dynamic>;
    print(users);
    return users;
  } else {
    return null;
  }
}

Future<void> requestFriend(FirebaseFirestore db, String currentUserUuid,
    String uuidToRequest, String username) async {
  String toAdd = currentUserUuid + "," + username;
  db.collection("Users").doc(uuidToRequest).update({
    "requests": FieldValue.arrayUnion([toAdd])
  });
}

Future<void> addFriend(FirebaseFirestore db, String currentUserUuid,
    String uuidToAdd, String usernameToAdd, String currentUsername) async {
  String toAdd = uuidToAdd + "," + usernameToAdd;
  db.collection("Users").doc(uuidToAdd).update({
    "friends": FieldValue.arrayUnion([currentUsername])
  });
  db.collection("Users").doc(currentUserUuid).update({
    "friends": FieldValue.arrayUnion([usernameToAdd])
  });
  db.collection("Users").doc(currentUserUuid).update({
    "requests": FieldValue.arrayRemove([toAdd])
  });
}
