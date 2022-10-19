import 'package:flutter/material.dart';

Future<bool> showLogOutDialog(BuildContext context) async {
  return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Logout'))
            ],
          )).then((option) => option ?? false);
}
