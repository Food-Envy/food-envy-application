import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:food_envy_application/account_setup.dart';
import 'package:food_envy_application/services/account_info.dart';
import 'package:food_envy_application/services/util.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Future<UserProfile> userCreated() async {
    final String uuid = getCurrentUserUuid();
    final DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('Users').doc(uuid).get();
    if (doc.exists) {
      UserProfile currentUser = UserProfile();
      currentUser.fromDocument(doc);
      return currentUser;
    } else {
      return (UserProfile());
    }
  }

  @override
  Widget build(BuildContext context) {
    final providerUser = Provider.of<UserProfile>(context);
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            headerBuilder: (context, constraints, _) {
              return Transform.scale(
                scale: 1.0,
                child: Image.asset("assets/images/noBkgPrimaryLogo.png"),
              );
            },
            providers: [
              EmailAuthProvider(),
            ],
          );
        }

        // return const MyHomePage(title: 'Flutter Demo Home Page');
        //return const AccountSetup();

        return Center(
            child: FutureBuilder<UserProfile>(
                future: userCreated(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    UserProfile? tempUser = snapshot.data;
                    if (!tempUser!.isInitialized()) {
                      return const AccountSetup();
                    } else {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        providerUser.copyUser(tempUser);
                      });
                      return const MyHomePage(
                        title: "",
                      );
                      //return MyHomePage(userObject: tempUser);
                    }
                  } else {
                    return const CircularProgressIndicator();
                  }
                }));
      },
    );
  }
}
