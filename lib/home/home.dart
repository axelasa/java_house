import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:java_shop/home/settings_form.dart';
import 'package:java_shop/services/auth.dart';
import 'package:java_shop/services/database.dart';
import 'package:provider/provider.dart';

import '../models/brew.dart';
import 'brew_list.dart';

class Home extends StatelessWidget {
   Home({super.key});
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    //final brews = Provider.of<QuerySnapshot>(context);
    void _showSettingsPanel(){
      showModalBottomSheet(
          context: context,
          builder: (context){
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: const SettingsForm(),
            );
          });
    }
    return  StreamProvider<List<Brew>>.value(
      value: DatabaseService(uid: '${_auth.user}').brews,
      initialData:[],
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: const Text('Java Shop'),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: [
            TextButton.icon(
                onPressed: () async{
                  await _auth.signOut();
                }, 
                icon: const Icon(Icons.person,color: Colors.black45,),
                label: const Text('Log out',style: TextStyle(color: Colors.black45),),
            ),
            TextButton.icon(
                onPressed: () => _showSettingsPanel(),
              icon: const Icon(Icons.settings,color: Colors.black45,),
              label: const Text('settings',style: TextStyle(color: Colors.black45),),

                )
          ],
        ),
        body:  Container(
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/coffee_bg.png'),
                fit: BoxFit.cover
              )
            ),
            child: BrewList()
        ),
      ),
    );
  }
}
