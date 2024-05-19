import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserInformationPage extends StatelessWidget {
  final String? userEmail;
  final String? userName;
  final String? userPhotoUrl;

  const UserInformationPage({Key? key, this.userEmail, this.userName, this.userPhotoUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[300],
      appBar: AppBar(
        title: Text('User Information'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
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
                      'http://placekitten.com/200/200'), // Placeholder image
                  ),
                SizedBox(height: 10),
                Text(userName ?? 'User Name',
                    style: TextStyle(color: Colors.white, fontSize: 24)),
                Text(
                  userEmail ?? 'User email is not available',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}