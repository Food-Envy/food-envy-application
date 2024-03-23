import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_envy_application/auth_gate.dart';
import 'package:food_envy_application/home_page.dart';
import 'package:food_envy_application/services/account_info.dart';
import 'package:food_envy_application/services/user_searching.dart';
import 'package:food_envy_application/services/util.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

class AccountSetup extends StatefulWidget {
  const AccountSetup({super.key});
  @override
  State<AccountSetup> createState() => _AccountSetupState();
}

class _AccountSetupState extends State<AccountSetup> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final userNameController = TextEditingController();
  UserProfile? providerUser;
  FirebaseFirestore db = FirebaseFirestore.instance;
  String currentUser = getCurrentUserUuid();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    providerUser = Provider.of<UserProfile>(context);
    // This method is rerun every time setState is called
    return Scaffold(
      body: ListView(
        children: <Widget>[
          getSignUpRow(),
          getTextField(
              "First Name", "Your first name here", firstNameController, width),
          getTextField(
              "Last Name", "Your last name here", lastNameController, width),
          getTextField(
              "Phone Number", "Your number here", phoneNumberController, width),
          getTextField(
              "Username", "Your username here", userNameController, width),
          getEnterButton(width),
        ],
      ),
    );
  }

  Padding getTextField(String iconText, String helperText,
      TextEditingController controller, double width) {
    //double height = MediaQuery.of(context).size.height;
    // used for padding for non-checkbox items
    var paddingForBox = EdgeInsets.only(top: 10, left: 30, right: 30);
    Padding toReturn = Padding(
      padding: paddingForBox,
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                iconText,
                style: const TextStyle(
                    color: Color(0xFF034D22),
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: helperText,
              hintStyle: const TextStyle(
                color: Color(0xFF034D22),
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
            ),
          ),
        ],
      ),
    );
    return toReturn;
  }

  SizedBox getEnterButton(double width) {
    return SizedBox(
      width: width - 60,
      height: 80,
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: TextButton(
          onPressed: () {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              providerUser!.updateUser(
                  firstNameController.text,
                  lastNameController.text,
                  phoneNumberController.text,
                  FirebaseAuth.instance.currentUser!.email,
                  userNameController.text);
              providerUser!.toDocument(db, currentUser);
            });
            addUsername(db, currentUser, userNameController.text);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const MyHomePage(title: 'Flutter Demo Home Page')));
          },
          style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              backgroundColor: const Color(0xFF94C668)),
          child: const Text(
            "Enter",
            style: TextStyle(color: Color(0xFF034D22)),
          ),
        ),
      ),
    );
  }

  Container getSignUpRow() {
    return Container(
      height: 300,
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 100, left: 30),
            child: Text(
              "Sign Up",
              style: TextStyle(
                  fontSize: 50, color: Color(0xFF94C668), fontFamily: 'Sergio'),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(top: 100, left: 50, right: 10),
              child: Image.asset(
                "assets/images/noBkgSecondaryLogo.png",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
