import 'dart:io';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:food_envy_application/account_edit.dart';
import 'package:food_envy_application/auth_gate.dart';
import 'package:food_envy_application/bottom_app_bar.dart';
import 'package:food_envy_application/home_page.dart';
import 'package:food_envy_application/manage_account.dart';
import 'package:food_envy_application/services/account_info.dart';
import 'package:food_envy_application/services/photo_helper.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';

class PostUpload extends StatefulWidget {
  PostUpload({super.key, required this.image, required this.meal});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  File image;
  String meal;

  @override
  State<PostUpload> createState() => _PostUploadState(this.image, this.meal);
}

class _PostUploadState extends State<PostUpload> {
  _PostUploadState(this.url, this.meal);
  final File url;
  final String meal;
  TextEditingController commentController = TextEditingController();
  TextEditingController recipeController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  UserProfile? providerUser;
  FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
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
        ),
        backgroundColor: const Color(
            0xfffffff3), // This trailing comma makes auto-formatting nicer for build methods.
        // body: Column(children: [
        //   Padding(
        //     padding: const EdgeInsets.only(top: 0),
        //     child: Image.file(url, width: MediaQuery.of(context).size.width),
        //   ),
        // ]),
        body: Center(
          child: ListView(children: [
            const Divider(
              color: Color(0xFF034D22),
              thickness: 5.0,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 35, left: 15, right: 15),
              child: Container(
                height: (MediaQuery.of(context).size.height - 225),
                width: MediaQuery.of(context).size.width - 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF79C),
                  borderRadius: BorderRadius.circular(18.0),
                ),
                child: Column(children: [
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text("Add your final details to your post",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xFF034D22),
                            fontSize: 25,
                            fontFamily: 'Sergio')),
                  ),
                  getTextField("Caption here", commentController,
                      MediaQuery.of(context).size.width - 48),
                  getTextFieldWithIcon(
                      const Icon(Icons.menu_book,
                          color: Color(0xFF94C668), size: 60),
                      "Recipe link here",
                      recipeController,
                      MediaQuery.of(context).size.width - 48),
                  getTextFieldWithIcon(
                      const Icon(Icons.location_on,
                          color: Color(0xFF94C668), size: 60),
                      "Location here",
                      locationController,
                      MediaQuery.of(context).size.width - 48),
                  getLastRow(context),
                ]),
              ),
            ),
          ]),
        ));
  }

  Padding getTextField(
      String helperText, TextEditingController controller, double width) {
    //double height = MediaQuery.of(context).size.height;
    // used for padding for non-checkbox items
    var paddingForBox = EdgeInsets.only(top: 10, left: 30, right: 30);
    Padding toReturn = Padding(
      padding: paddingForBox,
      child: TextField(
        textAlign: TextAlign.center,
        style: const TextStyle(color: Color(0xfffffff3)),
        controller: controller,
        decoration: InputDecoration(
            hintText: helperText,
            hintStyle: const TextStyle(
              color: Color(0xfffffff3),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 3, color: Color(0xFF034D22)),
              borderRadius: BorderRadius.circular(20), //<-- SEE HERE
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 3, color: Color(0xFF034D22)),
              borderRadius: BorderRadius.circular(20), //<-- SEE HERE
            ),
            filled: true,
            fillColor: const Color(0xFF034D22)),
        cursorColor: const Color(0xFFFFF79C),
      ),
    );
    return toReturn;
  }

  Padding getTextFieldWithIcon(Icon icon, String helperText,
      TextEditingController controller, double width) {
    //double height = MediaQuery.of(context).size.height;
    // used for padding for non-checkbox items
    var paddingForBox = const EdgeInsets.only(top: 60, left: 30, right: 30);
    Padding toReturn = Padding(
      padding: paddingForBox,
      child: Row(
        children: [
          icon,
          Expanded(
            child: TextField(
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xfffffff3)),
              controller: controller,
              decoration: InputDecoration(
                  hintText: helperText,
                  hintStyle: const TextStyle(
                    color: Color(0xfffffff3),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 3, color: Color(0xFF034D22)),
                    borderRadius: BorderRadius.circular(20), //<-- SEE HERE
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 3, color: Color(0xFF034D22)),
                    borderRadius: BorderRadius.circular(20), //<-- SEE HERE
                  ),
                  filled: true,
                  fillColor: const Color(0xFF034D22)),
              cursorColor: const Color(0xFFFFF79C),
            ),
          ),
        ],
      ),
    );
    return toReturn;
  }

  Padding getLastRow(BuildContext context) {
    //double height = MediaQuery.of(context).size.height;
    // used for padding for non-checkbox items
    var paddingForBox = const EdgeInsets.only(top: 120, left: 10, right: 30);
    Padding toReturn = Padding(
      padding: paddingForBox,
      child: Row(
        children: [
          IconButton(
              iconSize: 48,
              onPressed: () {
                // Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => const MyHomePage(
                //               title: "",
                //             )));
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Color(0xFF94C668),
              )),
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width - 216),
            child: IconButton(
                iconSize: 48,
                onPressed: () {
                  storeImage(context);
                },
                icon: const Icon(
                  Icons.send,
                  color: Color(0xFF94C668),
                )),
          ),
        ],
      ),
    );
    return toReturn;
  }

  Future<void> storeImage(BuildContext context) async {
    final storageRef = FirebaseStorage.instance.ref().child(basename(url.path));
    final UploadTask uploadTask = storageRef.putFile(url);
    await uploadTask.whenComplete(() async {
      final String downloadURL = await storageRef.getDownloadURL();
      await addPost(
          db,
          providerUser!.username!,
          downloadURL,
          meal,
          commentController.text,
          recipeController.text,
          locationController.text);
      // Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => const MyHomePage(
      //               title: "",
      //             )));
      Navigator.pop(context);
    });
  }
}
