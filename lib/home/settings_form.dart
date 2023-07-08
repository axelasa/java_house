import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:java_shop/constants/constants.dart';
import 'package:java_shop/constants/loading.dart';
import 'package:java_shop/models/signed_in_user.dart';
import 'package:java_shop/services/database.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({super.key});

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0','1','2','3','4'];

  //form values
  String? _currentName ;
   String? _currentSugars ;
    int? _currentStrength ;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SignedInUser>(context);
    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (
          BuildContext context,
          AsyncSnapshot<UserData> snapshot) {
        if(snapshot.hasData){
          UserData? userData = snapshot.data;
          return Form(
            key: _formKey,
            child: Column(
              children: [
                const Text('Update your brew settings',
                  style: TextStyle(fontSize: 18.0),
                ),
                const SizedBox(height: 20,),
                TextFormField(
                  initialValue: _currentName ?? userData!.name ,
                  decoration: textInputDecoration,
                  validator: (val) => val!.isEmpty ? 'please enter a name' : null,
                  onChanged: (val) => setState(() => _currentName = val),
                ),
                const SizedBox(height: 20,),
                //dropDown
                DropdownButtonFormField(
                  value: _currentSugars ?? userData!.sugars ,
                  decoration: textInputDecoration,
                  items: sugars.map((sugar)  {
                    return DropdownMenuItem(
                      value: sugar,
                      child: Text('$sugar sugars'),
                    );
                  }).toList(),

                  onChanged: (val) => setState(() => _currentSugars = val!),
                ),
                //slider
                Slider(
                  value: (_currentStrength ?? userData!.strength).toDouble(),
                  activeColor: Colors.brown[_currentStrength?? userData!.strength],
                  inactiveColor: Colors.brown[_currentStrength?? userData!.strength],
                  min: 100.0,
                  max: 900.0,
                  divisions: 8,
                  onChanged: (val) => setState(() => _currentStrength = val.round()),
                ),
                //button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:Colors.pink[400] ,
                  ),
                  onPressed: () async {
                    if(_formKey.currentState!.validate()) {
                      await DatabaseService(uid: user.uid).updateUserData(
                          _currentSugars ?? userData!.sugars,
                          _currentName ?? userData!.name,
                          _currentStrength ?? userData!.strength,
                          );
                    }
                    Navigator.pop(context);
                    print(_currentName);
                    print(_currentSugars);
                    print(_currentStrength);
                  },
                  child: const Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }else{
          return const Loading();
        }
      },
      // child:
    );
  }
}
