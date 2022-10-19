import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';

import '../enums/menu_action.dart';
import '../utilities/show_logout_dialogue.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          PopupMenuButton<MenuOptions>(
            onSelected: (option) async {
              switch (option) {
                case MenuOptions.logout:
                  final shouldLogOut = await showLogOutDialog(context);
                  if (shouldLogOut) {
                    await AuthService.firebase().logout();
                    if (!mounted) return;
                    Navigator.pushNamedAndRemoveUntil(
                        context, loginRoute, (_) => false);
                  }
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: MenuOptions.logout,
                child: Text('Logout'),
              )
            ],
          )
        ],
      ),
      body: const Text('Notes'),
    );
  }
}
