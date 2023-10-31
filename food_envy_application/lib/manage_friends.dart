import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_envy_application/account_edit.dart';
import 'package:food_envy_application/auth_gate.dart';
import 'package:food_envy_application/manage_account.dart';
import 'package:food_envy_application/services/account_info.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

class FriendsManagePage extends StatefulWidget {
  const FriendsManagePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<FriendsManagePage> createState() => _FriendsManagePageState();
}

class _FriendsManagePageState extends State<FriendsManagePage> {
  final searchController = TextEditingController();
  UserProfile? providerUser;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    providerUser = Provider.of<UserProfile>(context);
    // This method is rerun every time setState is called
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leadingWidth: 300,
        leading: Image.asset("assets/images/noBkgTitle.png"),
        title: IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AccountManagePage()));
          },
          icon: const Icon(Icons.account_circle),
          color: Color(0xFF034D22),
          iconSize: 48,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      body: ListView(
        children: [
          getBar(),
          getTitleRow(),
          getSearchBar(
              "Search new or current friends", searchController, width),
          getFriendsText()
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
            "Manage Friends",
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

  Padding getSearchBar(
      String helperText, TextEditingController controller, double width) {
    //double height = MediaQuery.of(context).size.height;
    // used for padding for non-checkbox items
    var paddingForBox = EdgeInsets.only(top: 10, left: 30, right: 30);
    Padding toReturn = Padding(
      padding: paddingForBox,
      child: TextField(
        controller: controller,
        onSubmitted: (String value) {},
        decoration: InputDecoration(
            hintText: helperText,
            hintStyle: const TextStyle(
              color: Color(0xFF034D22),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 3, color: Color(0xFF034D22)),
              borderRadius: BorderRadius.circular(20), //<-- SEE HERE
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 3, color: Color(0xFF034D22)),
              borderRadius: BorderRadius.circular(20), //<-- SEE HERE
            ),
            prefixIcon: const Icon(Icons.search)),
      ),
    );
    return toReturn;
  }

  Padding getFriendsText() {
    return Padding(
      padding: EdgeInsets.only(top: 30, left: 30),
      child: Text(
        "Your Friends (${providerUser!.friends.length})",
        style: TextStyle(fontSize: 20, color: Color(0xFF034D22)),
      ),
    );
  }
}
