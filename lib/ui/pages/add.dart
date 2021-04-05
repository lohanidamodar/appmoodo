import 'package:appmoodo/ui/widgets/add_mood.dart';
import 'package:flutter/material.dart';

class AddMoodPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          AddMood(),
        ],
      ),
    );
  }
}
