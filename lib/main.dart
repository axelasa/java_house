import 'package:firebase_core/firebase_core.dart';
import 'package:java_shop/models/signed_in_user.dart';
import 'package:java_shop/services/auth.dart';
import 'package:java_shop/wrapper.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

Future main() async{
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
    return StreamProvider<SignedInUser?>.value(
      value: AuthService().user,
      initialData: SignedInUser(uid:AuthService().user.toString()),
      child: const MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}

