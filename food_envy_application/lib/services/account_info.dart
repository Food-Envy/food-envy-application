import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserProfile extends ChangeNotifier {
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? email;
  String? username;
  List<String> friends = [];

  UserProfile();
  void updateUser(String? first, String? last, String? phone,
      String? emailParam, String? usernameParam) {
    firstName = first;
    lastName = last;
    phoneNumber = phone;
    email = emailParam;
    username = usernameParam;
    notifyListeners();
  }

  void addFriend(String username) {
    friends.add(username);
    // add it for other person too
    notifyListeners();
  }

  void removeFriend(String username) {
    friends.remove(username);
    // need to remove it for the other person too
    notifyListeners();
  }

  void copyUser(UserProfile toCopy) {
    updateUser(toCopy.firstName, toCopy.lastName, toCopy.phoneNumber,
        toCopy.email, toCopy.username);
  }

  Future<void> toDocument(FirebaseFirestore db, String currentUser) async {
    Future.delayed(const Duration(milliseconds: 100), () {});
    db.collection("Users").doc(currentUser).set({
      "email": email,
      "first_name": firstName,
      "last_name": lastName,
      "phone_number": phoneNumber,
      "username": username
    });
  }

  void fromDocument(DocumentSnapshot doc) {
    email = doc.get("email");
    firstName = doc.get("first_name");
    lastName = doc.get("last_name");
    phoneNumber = doc.get("phone_number");
    username = doc.get("username");
  }

  bool isInitialized() {
    return email != null &&
        firstName != null &&
        lastName != null &&
        phoneNumber != null &&
        username != null;
  }
}
