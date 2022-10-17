import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
          const Text('please Verify your email address'),
          TextButton(
              onPressed: () async {
                print('sending email...');
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();

                print('Email sent');
              },
              child: const Text('Send Email'))
        ],
      ),
    );
  }
}
