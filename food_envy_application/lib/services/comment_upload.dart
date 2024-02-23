import 'dart:collection';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<String> addComment(FirebaseFirestore db, String postUsername,
    String commenterUsername, String comment, String currentMeal) async {
  String toAdd = "$commenterUsername,$comment";
  db.collection("Photos").doc(currentMeal).update({
    postUsername: FieldValue.arrayUnion([toAdd])
  });
  return toAdd;
}
