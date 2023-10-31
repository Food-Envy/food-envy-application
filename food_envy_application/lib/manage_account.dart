import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_envy_application/account_edit.dart';
import 'package:food_envy_application/auth_gate.dart';
import 'package:food_envy_application/manage_friends.dart';

import 'firebase_options.dart';

class AccountManagePage extends StatefulWidget {
  const AccountManagePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<AccountManagePage> createState() => _AccountManagePageState();
}

class _AccountManagePageState extends State<AccountManagePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leadingWidth: 300,
        leading: Image.asset("assets/images/noBkgTitle.png"),
        title: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.account_circle),
          color: Color(0xFF034D22),
          iconSize: 48,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      body: ListView(
        children: [
          getBar(),
          getTitleRow(),
          getSavedRecipesButton(),
          getSavedRestaurantsButton(),
          getProfileSettingsButton(),
          getManageFriendsButton(),
        ],
      ),
    );
  }

  Divider getBar() {
    return const Divider(
      color: Color(0xFF034D22),
      thickness: 5.0,
    );
  }

  Row getTitleRow() {
    return Row(
      children: [
        getBackButton(),
        const Padding(
          padding: EdgeInsets.only(top: 20, left: 15),
          child: Text(
            "Manage Account",
            style: TextStyle(
                fontSize: 35, color: Color(0xFF034D22), fontFamily: 'Sergio'),
          ),
        ),
      ],
    );
  }

  IconButton getBackButton() {
    return IconButton(
      highlightColor: Colors.transparent,
      iconSize: 36,
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.only(top: 20, left: 15),
      onPressed: () {
        Navigator.pop(context);
      },
      icon: const Icon(Icons.arrow_back_ios_new),
      color: Color(0xFF034D22),
    );
  }

  Padding getSavedRecipesButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 50, right: 50),
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: const Color(0xFF94C668)),
        child: const Text("Saved Recipes",
            style: TextStyle(color: Color(0xFF034D22), fontSize: 25)),
      ),
    );
  }

  Padding getSavedRestaurantsButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 50, right: 50),
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: const Color(0xFF94C668)),
        child: const Text("Saved Restaurants",
            style: TextStyle(color: Color(0xFF034D22), fontSize: 25)),
      ),
    );
  }

  Padding getProfileSettingsButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 50, right: 50),
      child: TextButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AccountEdit()));
        },
        style: TextButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: const Color(0xFF94C668)),
        child: const Text("Profile Settings",
            style: TextStyle(color: Color(0xFF034D22), fontSize: 25)),
      ),
    );
  }

  Padding getManageFriendsButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 50, right: 50),
      child: TextButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const FriendsManagePage()));
        },
        style: TextButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: const Color(0xFF94C668)),
        child: const Text("Manage Friends",
            style: TextStyle(color: Color(0xFF034D22), fontSize: 25)),
      ),
    );
  }
}
