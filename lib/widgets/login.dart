import 'package:car_provider/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart'as http;
import '../API/function.dart';
import '../main.dart';

class LoginSignUpPage extends StatefulWidget {
  const LoginSignUpPage({super.key});

  @override
  _LoginSignUpPageState createState() => _LoginSignUpPageState();
}

class _LoginSignUpPageState extends State<LoginSignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  late final _navigator = Navigator.of(context);
  bool _isLogin = true; // Default to login mode

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(
          _isLogin ? 'Login' : 'Sign Up',
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/download1.jpeg'),
                fit: BoxFit.cover)),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                    labelText: 'Username', iconColor: Colors.brown),
              ),
              SizedBox(height: 10.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
              ),
              if (!_isLogin) // Show email field only for sign up
                SizedBox(height: 10.0),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async{
                  await authProvider.loginOrSignUp(
                    username: _usernameController.text,
                    password: _passwordController.text,
                    email: _emailController.text,
                    isLogin: _isLogin);
                      _navigator.pushReplacement(MaterialPageRoute(builder: (context)=>const CarGridScreen()));
                  // if (_isLogin == true) {
                  //   await loginOrSignUp(
                  //       username: _usernameController.text,
                  //       password: _passwordController.text,
                  //       email: _emailController.text,
                  //       isLogin: _isLogin);
                  //   _navigator.pushReplacement(MaterialPageRoute(builder: (context)=>const CarGridScreen()));
                  //
                  // }
                },
                child: Text(
                  _isLogin ? 'Login' : 'Sign Up',
                  style: TextStyle(color: Colors.brown),
                ),
              ),
              SizedBox(height: 10.0),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLogin = !_isLogin;
                    // Toggle between login and sign up mode
                  });
                },
                child: Text(
                  _isLogin
                      ? 'Don\'t have an account? Sign Up'
                      : 'Already have an account? Login',
                  style: TextStyle(color: Colors.brown),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


