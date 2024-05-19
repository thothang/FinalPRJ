import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/change_password_screen.dart';

class UserInformationPage extends StatefulWidget {
  final User user;

  const UserInformationPage({Key? key, required this.user}) : super(key: key);

  @override
  _UserInformationPageState createState() => _UserInformationPageState();
}

class _UserInformationPageState extends State<UserInformationPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  String? _displayName;

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.user.displayName ?? '';
    _displayName = widget.user.displayName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[300],
      appBar: AppBar(
        title: Text('User Information'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      widget.user.photoURL ?? 'http://placekitten.com/200/200'
                  ), // Placeholder image
                ),
                SizedBox(height: 10),
                Text(_displayName ?? 'User Name',
                    style: TextStyle(color: Colors.white, fontSize: 24)),
                Text(
                  widget.user.email ?? 'User email is not available',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          hintText: 'Enter your username',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              await widget.user.updateDisplayName(_usernameController.text);
                              await widget.user.reload();
                              User updatedUser = FirebaseAuth.instance.currentUser!;
                              setState(() {
                                _displayName = updatedUser.displayName;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Username updated successfully')));
                              Navigator.pop(context, true); // Pass true to indicate success
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating username: $e')));
                            }
                          }
                        },
                        child: Text('Update'),
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
                          );
                        },
                        child: const Text(
                          "Change Password",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }
}
