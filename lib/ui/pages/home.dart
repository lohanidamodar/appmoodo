import 'package:appmoodo/res/app_constants.dart';
import 'package:appmoodo/state/state.dart';
import 'package:appmoodo/ui/widgets/add_mood.dart';
import 'package:appmoodo/ui/widgets/mood_list_item.dart';
import 'package:appmoodo/ui/widgets/moods_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../res/app_constants.dart';

final selectedDateProvider = StateProvider<DateTime>((ref) {
  var date = DateTime.now();
  date = DateTime(
    date.year,
    date.month,
    0,
    0,
  );
  return date;
});

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final selectedDate = watch(selectedDateProvider);
    final moodEntries = watch(monthMoodsProvider!(selectedDate.state)).state;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.appName),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, 'profile');
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 70.0),
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                IconButton(
                    icon: Icon(Icons.keyboard_arrow_left),
                    onPressed: () {
                      selectedDate.state = DateTime(selectedDate.state.year,
                          selectedDate.state.month - 1, 1, 0);
                    }),
                Expanded(
                  child: Center(
                    child: Text(
                      DateFormat.MMMM().format(selectedDate.state),
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                ),
                IconButton(
                    icon: Icon(Icons.keyboard_arrow_right),
                    onPressed: () {
                      selectedDate.state = DateTime(selectedDate.state.year,
                          selectedDate.state.month + 1, 1, 0);
                    }),
              ],
            ),
          ),
          if (moodEntries.length < 1) ...[
            AddMood(),
          ],
          if (moodEntries.length > 2) ...[
            Container(
              height: 300,
              child: MoodsChart(
                moods: moodEntries,
              ),
            ),
            const SizedBox(height: 20.0),
          ],
          ...moodEntries.map(
            (mood) => MoodListItem(
              mood: mood,
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        child: Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, 'add'),
      ),
    );
  }
}
