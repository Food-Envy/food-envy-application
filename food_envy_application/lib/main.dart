import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_envy_application/auth_gate.dart';
import 'package:food_envy_application/services/account_info.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => UserProfile(),
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF034D22)),
            scaffoldBackgroundColor: const Color(0xfffffff3),
            useMaterial3: true,
          ),
          home: const AuthGate(),
        ));
  }
}
