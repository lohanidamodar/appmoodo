import 'package:appmoodo/res/app_colors.dart';
import 'package:appmoodo/res/app_constants.dart';
import 'package:appmoodo/state/state.dart';
import 'package:appmoodo/ui/widgets/add_mood.dart';
import 'package:appmoodo/ui/widgets/chart.dart';
import 'package:appmoodo/ui/widgets/mood_list_item.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../res/app_constants.dart';
import '../../res/app_constants.dart';

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
          if (moodEntries.length > 2) ...[
            Container(
              height: 300,
              child: MoodsChart.withData(moodEntries),
            ),
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
