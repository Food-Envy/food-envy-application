import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

String getCurrentUserUuid() {
  FirebaseAuth auth = FirebaseAuth.instance;
  final User user = auth.currentUser!;
  final uid = user.uid;
  return uid;
}
