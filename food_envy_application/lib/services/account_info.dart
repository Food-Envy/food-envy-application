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
  List<dynamic> friends = [];
  List<dynamic> requestedFriends = [];
  List<dynamic> recipes = [];
  List<dynamic> locations = [];
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

  void addRecipe(FirebaseFirestore db, String url, String currentUser) {
    recipes.add(url);
    db.collection("Users").doc(currentUser).update({
      "recipes": FieldValue.arrayUnion([url])
    });
    notifyListeners();
  }

  void addLocation(FirebaseFirestore db, String url, String currentUser) {
    print(url);
    locations.add(url);
    db.collection("Users").doc(currentUser).update({
      "locations": FieldValue.arrayUnion([url])
    });
    notifyListeners();
  }

  void removeFriend(String username) {
    friends.remove(username);
    // need to remove it for the other person too
    notifyListeners();
  }

  void copyUser(UserProfile toCopy) {
    requestedFriends = toCopy.requestedFriends;
    friends = toCopy.friends;
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
      "username": username,
      "friends": friends,
      "requests": requestedFriends,
      "recipes": recipes,
      "locations": locations
    });
  }

  void fromDocument(DocumentSnapshot doc) {
    email = doc.get("email");
    firstName = doc.get("first_name");
    lastName = doc.get("last_name");
    phoneNumber = doc.get("phone_number");
    username = doc.get("username");
    requestedFriends = doc.get("requests");
    friends = doc.get("friends");
    recipes = doc.get("recipes");
    locations = doc.get("locations");
  }

  bool isInitialized() {
    return email != null &&
        firstName != null &&
        lastName != null &&
        phoneNumber != null &&
        username != null;
  }
}
