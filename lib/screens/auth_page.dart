// ignore_for_file: avoid_print

import 'package:expense_tracker/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLogin = true;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> signIn() async {
    try {
      await Auth().signInWithEmailAndPassword(
          email: _email.text, password: _password.text);
    } on FirebaseAuthException catch (error) {
      print(error);
    }
  }

  Future<void> createUser() async {
    try {
      await Auth().createUserWithEmailAndPassword(
          email: _email.text, password: _password.text);
    } on FirebaseAuthException catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses Tracker App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                controller: _email,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'email'),
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid password';
                  }
                  return null;
                },
                controller: _password,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'password'),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Processing'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                  isLogin ? signIn() : createUser();
                },
                child: Text(isLogin ? 'Login' : 'SignUp'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    isLogin = !isLogin;
                  });
                },
                child: Text(
                  isLogin
                      ? 'Not a user? SignUp now!'
                      : 'Already a user? LogIn!',
                  style: const TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
