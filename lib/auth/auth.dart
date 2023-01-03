import 'package:flutter/material.dart';
import 'signin.dart';
import 'signup.dart';

class Auth extends StatefulWidget {
  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final List<Widget> tabs = [SignIn(), SignUp()];
  int index = 0;

  @override
  Widget build(BuildContext context) {
    print('builing here');
    return Scaffold(
      appBar: AppBar(
        title: Text(index == 0 ? 'Sign In' : 'Create Account'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.lock_open),
            label: 'Sign In',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: 'Create Account',
          ),
        ],
        currentIndex: index,
        selectedItemColor: Colors.amber[800],
        onTap: (num) {
          setState(() {
            index = num;
          });
        },
      ),
      body: tabs[index],
    );
  }
}
