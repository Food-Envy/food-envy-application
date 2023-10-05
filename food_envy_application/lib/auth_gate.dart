import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'main.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
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
            providerConfigs: [
              EmailProviderConfiguration(),
            ],
          );
        }

        return const MyHomePage(title: 'Flutter Demo Home Page');
      },
    );
  }
}
