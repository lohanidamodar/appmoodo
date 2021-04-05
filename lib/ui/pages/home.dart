import 'package:appmoodo/res/app_colors.dart';
import 'package:appmoodo/res/app_constants.dart';
import 'package:appmoodo/state/state.dart';
import 'package:appmoodo/ui/widgets/add_mood.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var today = DateTime.now();
    today = DateTime(
      today.year,
      today.month,
      today.day,
    );
    final moodEntries = watch(dayMoodsProvider(today)).state;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.appName),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          if (moodEntries.length < 1) ...[
            AddMood(),
          ],
          ...moodEntries.map(
            (mood) => ListTile(
              title: Text(mood.content ?? mood.mood.toString()),
              subtitle: Text(mood.date.toString()),
              leading: Text("${mood.mood}"),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home),
            activeIcon: Icon(
              Icons.home,
              color: AppColors.primaryColor,
            ),
          ),
          BottomNavigationBarItem(
            label: "History",
            icon: Icon(Icons.history),
            activeIcon: Icon(
              Icons.history,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        child: Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, 'add'),
      ),
    );
  }
}
