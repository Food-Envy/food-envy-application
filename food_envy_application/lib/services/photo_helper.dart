import 'dart:collection';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<void> addPost(FirebaseFirestore db, String currentUsername,
    String photoUrl, String meal) async {
  db.collection("Photos").doc(meal).update({currentUsername: photoUrl});
}
