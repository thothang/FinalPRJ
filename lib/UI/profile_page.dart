import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../User/UserInformationPage.dart';
import '../screens/signin_screen.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  void _getUser() {
    user = FirebaseAuth.instance.currentUser;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[300],
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
                Text(user?.displayName ?? 'User Name',
                    style: TextStyle(color: Colors.white, fontSize: 24)),
                Text(user?.email ?? 'user@example.com',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                SizedBox(height: 10),
                MaterialButton(
                  onPressed: () {},
                  color: Colors.white,
                  child: Text('Edit Profile'),
                )
              ],
            ),
          ),
          _buildTile(Icons.settings, 'Settings'),
          _buildTile(Icons.school, 'Instructor'),
          _buildTile(Icons.language, 'IELTS/TOEFL'),

          ListTile(
            leading: Icon(Icons.info_outline, color: Colors.white),
            title: Text('Information', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserInformationPage(userEmail: user?.email),
                ),
              );
            },
          ),
          Container(
            padding: EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {
                _showLogoutDialog();
              },
              child: Text('Logout'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInScreen()));
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  ListTile _buildTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: TextStyle(color: Colors.white)),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
      onTap: () {},
    );
  }
}