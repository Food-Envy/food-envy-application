import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_envy_application/auth_gate.dart';

import 'firebase_options.dart';

class AccountSetup extends StatefulWidget {
  const AccountSetup({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<AccountSetup> createState() => _AccountSetupState();
}

class _AccountSetupState extends State<AccountSetup> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // This method is rerun every time setState is called
    return Scaffold(
      body: Column(
        children: <Widget>[
          const getSignUpRow(),
          getTextField(
              "First Name", "Your first name here", firstNameController, width),
          getTextField(
              "Last Name", "Your last name here", firstNameController, width),
          getTextField(
              "Phone Number", "Your number here", firstNameController, width),
          getTextField(
              "Username", "Your username here", firstNameController, width),
          getEnterButton(width: width),
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
}

class getSignUpRow extends StatelessWidget {
  const getSignUpRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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

class getEnterButton extends StatelessWidget {
  const getEnterButton({
    super.key,
    required this.width,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width - 60,
      height: 80,
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: TextButton(
          onPressed: () => {},
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
}
