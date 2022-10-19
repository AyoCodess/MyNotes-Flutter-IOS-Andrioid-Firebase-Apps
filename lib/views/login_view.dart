// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';

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
                  await AuthService.firebase().login(
                    email: email,
                    password: password,
                  );

                  final user = AuthService.firebase().currentUser;

                  if (user?.isEmailVerified ?? false) {
                    if (!mounted) return;
                    Navigator.pushNamedAndRemoveUntil(
                        context, mynotesRoute, (route) => false);
                  } else {
                    if (!mounted) return;
                    Navigator.pushNamedAndRemoveUntil(
                        context, verifyEmailRoute, (route) => false);
                  }
                } on UserNotFoundAuthException {
                  return await showErrorDialog(
                    context,
                    'User not found',
                  );
                } on UserWrongPasswordAuthException {
                  return await showErrorDialog(
                    context,
                    'Wrong password or email.',
                  );
                } on UserInvalidEmailAuthException {
                  return await showErrorDialog(
                    context,
                    'Wrong password or email.',
                  );
                } on GenericAuthException {
                  return await showErrorDialog(
                    context,
                    'Authentication error, please try again.',
                  );
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
