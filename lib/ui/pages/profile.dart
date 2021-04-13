import 'package:appmoodo/service/api_service.dart';
import 'package:appmoodo/state/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final user = watch(userProvider).state;
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          if(user != null)
            ListTile(
              title: Text(user.name),
              subtitle: Text(user.email),
            ),
          ListTile(
            title: Text("Logout"),
            leading: Icon(Icons.exit_to_app),
            onTap: () async {
              await ApiService.instance!.logout();
              context.read(authStateProvider).state =
                  AuthStatus.unauthenticated;
              context.read(userProvider).state = null;
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
