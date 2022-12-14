import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Your Email')),
      body: Column(
        children: [
          const Text(
              'we\'ve sent you an email verification link. Please open it to verify your account.'),
          const Text(
              'if you haven\'t received an email, please click the button below to resend it.'),
          TextButton(
              onPressed: () async {
                devtools.log('sending verification email...');
                await AuthService.firebase().sendEmailVerification();
                devtools.log('Email sent');
              },
              child: const Text('Send Email')),
          TextButton(
              onPressed: () async {
                await AuthService.firebase().logout();
                if (!mounted) return;
                Navigator.pushNamedAndRemoveUntil(
                    context, registerRoute, (route) => false);
              },
              child: const Text('Restart')),
        ],
      ),
    );
  }
}
