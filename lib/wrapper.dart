import 'package:flutter/material.dart';
//import 'package:java_shop/authenticate/authenticate.dart';
import 'package:java_shop/home/home.dart';
import 'package:java_shop/models/signed_in_user.dart';
import 'package:java_shop/screens/authenticate/authenticate.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<SignedInUser?>(context);
    debugPrint('$user');
    //return either Home or Authentication
    return user == null ?  const Authenticate() :  Home();
  }
}
