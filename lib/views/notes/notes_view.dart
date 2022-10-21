import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/crud/mynotes_service.dart';

import '../../enums/menu_action.dart';
import '../../utilities/show_logout_dialogue.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  String get userEmail => AuthService.firebase().currentUser!.email!;

  late final NotesService _notesService;

  @override
  void initState() {
    _notesService = NotesService();
    super.initState();
  }

  @override
  void dispose() {
    _notesService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Notes'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, newNoteRoute);
                },
                icon: const Icon(Icons.add)),
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
        body: FutureBuilder(
            future: _notesService.getOrCreateUser(email: userEmail),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return StreamBuilder(
                    stream: _notesService.allNotes,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          // child: CircularProgressIndicator());
                          return const Text('waiting for notes...');
                        default:
                          return const Text('default');
                      }
                    },
                  );
                default:
                  return const Center(child: CircularProgressIndicator());
              }
            }));
  }
}
