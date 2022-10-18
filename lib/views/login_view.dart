// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotes/constants/routes.dart';

import '../utilities/show_error_alert.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: true,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Email',
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'Password',
            ),
          ),
          TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  final userCredential = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: email, password: password);
                  devtools.log(userCredential.toString());

                  final user = FirebaseAuth.instance.currentUser;

                  if (user?.emailVerified ?? false) {
                    if (!mounted) return;
                    Navigator.pushNamedAndRemoveUntil(
                        context, mynotesRoute, (route) => false);
                  } else {
                    if (!mounted) return;
                    Navigator.pushNamedAndRemoveUntil(
                        context, verifyEmailRoute, (route) => false);
                  }
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    devtools.log(e.code.toString());
                    return await showErrorDialog(context, 'User not found');
                  }
                  if (e.code == 'wrong-password' || e.code == 'invalid-email') {
                    return await showErrorDialog(
                        context, 'Wrong password or email.');
                  } else {
                    return await showErrorDialog(
                        context, 'Error: ${e.code}. Please try again.');
                  }
                } catch (e) {
                  devtools.log(e.runtimeType.toString());
                  return await showErrorDialog(
                      context, 'Error: ${e.toString()}. Please try again.');
                }
              },
              child: const Text('Login')),
          TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, registerRoute, (route) => false);
              },
              child: const Text('Not Registered yet? Register here!'))
        ],
      ),
    );
  }
}
