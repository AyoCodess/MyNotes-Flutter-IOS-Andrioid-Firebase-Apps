import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
      appBar: AppBar(title: const Text('Register')),
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
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: email, password: password);
                } on FirebaseAuthException catch (e) {
                  switch (e.code) {
                    case 'weak-password':
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('The password provided is too weak.')));
                      break;
                    case 'email-already-in-use':
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              'The account already exists for that email.')));
                      break;
                    case 'invalid-email':
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content:
                              Text('The email address is badly formatted.')));
                      break;
                    default:
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Something went wrong, try again.')));
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          'An unknown error occurred. Please try again later.')));
                }
              },
              child: const Text('Register')),
          TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login/', (route) => false);
              },
              child: const Text('Already registered? Login here!'))
        ],
      ),
    );
  }
}
