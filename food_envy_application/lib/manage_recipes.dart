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

class RecipeManagePage extends StatefulWidget {
  const RecipeManagePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<RecipeManagePage> createState() => _RecipeManagePageState();
}

class _RecipeManagePageState extends State<RecipeManagePage> {
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
    List<Widget> chidrenList = [
      getBar(),
      getTitleRow(),
    ];
    for (String recipe in providerUser!.recipes) {
      Text recipeText = Text(
        recipe,
        style: TextStyle(fontSize: 30, color: Color(0xFF034D22)),
      );
      Padding widget = Padding(
          padding: EdgeInsets.only(top: 20, left: 15), child: recipeText);
      chidrenList.add(widget);
    }
    return ListView(
      children: chidrenList,
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
        const Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 20, left: 15),
            child: Text(
              "Saved Recipes",
              style: TextStyle(
                  fontSize: 35, color: Color(0xFF034D22), fontFamily: 'Sergio'),
            ),
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
}
