import 'dart:ffi';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_envy_application/account_edit.dart';
import 'package:food_envy_application/auth_gate.dart';
import 'package:food_envy_application/manage_account.dart';
import 'package:food_envy_application/services/account_info.dart';
import 'package:food_envy_application/services/user_searching.dart';
import 'package:food_envy_application/services/util.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  // if this is false then show the user's current friends, if it is true then show search results
  bool searching = false;
  Map<String, dynamic>? userMap;
  List<Widget> usersToDisplay = [];
  List<Widget> requestsToDisplay = [];
  List<Widget> friendsToDisplay = [];
  FirebaseFirestore db = FirebaseFirestore.instance;

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
        body: getListView(width));
  }

  ListView getListView(double width) {
    if (!searching) {
      getRequestsUsers();
      getFriendsUsers();
      return ListView(
        children: [
          getBar(),
          getTitleRow(),
          getSearchBar(
              "Search new or current friends", searchController, width),
          getRequestsText(),
          Column(
            children: requestsToDisplay,
          ),
          getFriendsText(),
          Column(
            children: friendsToDisplay,
          ),
        ],
      );
    } else {
      return ListView(
        children: [
          getBar(),
          getTitleRow(),
          getSearchBar(
              "Search new or current friends", searchController, width),
          Column(
            children: usersToDisplay,
          )
        ],
      );
    }
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
        onSubmitted: (String value) async {
          userMap ??= await getUsers(); // doesn't run if it is not null
          searching = true;
          getDisplayUsers(searchController.text);
        },
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
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  searching = false;
                })),
      ),
    );
    return toReturn;
  }

  Padding getFriendsText() {
    return Padding(
      padding: EdgeInsets.only(top: 30, left: 30),
      child: Text(
        "Your Friends (${providerUser!.friends!.length})",
        style: TextStyle(fontSize: 20, color: Color(0xFF034D22)),
      ),
    );
  }

  Padding getRequestsText() {
    return Padding(
      padding: EdgeInsets.only(top: 30, left: 30),
      child: Text(
        "Your Friend Requests (${providerUser!.requestedFriends.length})",
        style: TextStyle(fontSize: 20, color: Color(0xFF034D22)),
      ),
    );
  }

  void getDisplayUsers(String searchTerm) {
    usersToDisplay.clear();
    userMap!.forEach(
      (key, value) {
        if (key.contains(searchTerm.toLowerCase())) {
          usersToDisplay.add(getUserDisplay(key, value));
        }
      },
    );
    setState(() {});
  }

  void getRequestsUsers() {
    if (requestsToDisplay.length == providerUser!.requestedFriends.length) {
      return;
    } else {
      requestsToDisplay = [];
    }
    //print("reached");
    //print(providerUser!.requestedFriends);
    for (var element in providerUser!.requestedFriends) {
      //print(element.runtimeType);
      //print(element.length());
      int commaIndex = -1;
      for (var i = 0; i < element.length; i++) {
        if (element[i] == ",") {
          commaIndex = i;
          break;
        }
      }
      if (commaIndex != -1) {
        String uuid = element.substring(0, commaIndex);
        String username = element.substring(commaIndex + 1);
        requestsToDisplay.add(getRequestsDisplay(username, uuid));
      }
    }
  }

  void getFriendsUsers() {
    if (friendsToDisplay.length == providerUser!.friends.length) {
      return;
    } else {
      friendsToDisplay = [];
    }
    //print("reached");
    //print(providerUser!.requestedFriends);
    for (var element in providerUser!.friends) {
      //print(element.runtimeType);
      //print(element.length());
      friendsToDisplay.add(getFriendsDisplay(element));
    }
  }

  Padding getFriendsDisplay(String username) {
    String usernameDisplay = "@" + username;
    return Padding(
      padding: EdgeInsets.only(left: 30, top: 30),
      child: Column(children: [
        Row(
          children: [
            const Icon(
              Icons.account_circle,
              color: Color(0xFF034D22),
              size: 40,
            ),
            Text(
              usernameDisplay,
              style: TextStyle(color: Color(0xFF034D22), fontSize: 30),
            ),
          ],
        )
      ]),
    );
  }

  Padding getRequestsDisplay(String username, String uuid) {
    String usernameDisplay = "@" + username;
    return Padding(
      padding: EdgeInsets.only(left: 30, top: 30),
      child: Column(children: [
        Row(
          children: [
            const Icon(
              Icons.account_circle,
              color: Color(0xFF034D22),
              size: 40,
            ),
            Text(
              usernameDisplay,
              style: TextStyle(color: Color(0xFF034D22), fontSize: 30),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: IconButton(
                  alignment: Alignment.centerRight,
                  onPressed: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      providerUser!.addFriend(username);
                      addFriend(db, getCurrentUserUuid(), uuid, username,
                          providerUser!.username!);
                    });
                  },
                  icon: const Icon(
                    Icons.person_add_alt_1,
                    color: Color(0xFF034D22),
                    size: 40,
                  )),
            )
          ],
        )
      ]),
    );
  }

  Padding getUserDisplay(String username, String uuid) {
    String usernameDisplay = "@" + username;
    return Padding(
      padding: EdgeInsets.only(left: 30, top: 30),
      child: Column(children: [
        Row(
          children: [
            const Icon(
              Icons.account_circle,
              color: Color(0xFF034D22),
              size: 40,
            ),
            Text(
              usernameDisplay,
              style: TextStyle(color: Color(0xFF034D22), fontSize: 30),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: IconButton(
                  alignment: Alignment.centerRight,
                  onPressed: () {
                    requestFriend(db, getCurrentUserUuid(), uuid,
                        providerUser!.username!);
                  },
                  icon: const Icon(
                    Icons.person_add_alt_1,
                    color: Color(0xFF034D22),
                    size: 40,
                  )),
            )
          ],
        )
      ]),
    );
  }
}
