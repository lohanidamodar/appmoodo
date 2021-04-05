import 'package:appmoodo/res/app_colors.dart';
import 'package:appmoodo/res/app_constants.dart';
import 'package:appmoodo/res/assets.dart';
import 'package:appmoodo/service/api_service.dart';
import 'package:appmoodo/state/state.dart';
import 'package:appmoodo/ui/widgets/mood_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final moodProvider = StateProvider.autoDispose<int>((ref) => 0);
final contentControllerProvider =
    Provider.autoDispose((ref) => TextEditingController());

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var today = DateTime.now();
    today = DateTime(
      today.year,
      today.month,
      today.day,
    );
    final mood = watch(moodProvider).state;
    final moodEntries = watch(dayMoodsProvider(today)).state;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.appName),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          if (moodEntries.length < 5) ...[
            Text(
              "How are you feeling?",
              style: Theme.of(context).textTheme.headline3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MoodIcon(
                  isSelected: mood == 5,
                  icon: AppAssets.awesome,
                  emoji: "😄",
                  onTap: () {
                    watch(moodProvider).state = 5;
                  },
                ),
                MoodIcon(
                  isSelected: mood == 4,
                  icon: AppAssets.good,
                  emoji: "🙂",
                  onTap: () {
                    watch(moodProvider).state = 4;
                  },
                ),
                MoodIcon(
                  isSelected: mood == 3,
                  icon: AppAssets.meh,
                  emoji: "😐",
                  onTap: () {
                    watch(moodProvider).state = 3;
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MoodIcon(
                  isSelected: mood == 2,
                  icon: AppAssets.bad,
                  emoji: "🙁",
                  onTap: () {
                    watch(moodProvider).state = 2;
                  },
                ),
                MoodIcon(
                  isSelected: mood == 1,
                  icon: AppAssets.awful,
                  emoji: "😩",
                  onTap: () {
                    watch(moodProvider).state = 1;
                  },
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: watch(contentControllerProvider),
              decoration: InputDecoration(hintText: "Note"),
              maxLines: 3,
            ),
            const SizedBox(height: 10.0),
            Center(
              child: ElevatedButton(
                child: Text("Submit"),
                onPressed: () async {
                  String userid = context.read(userProvider).state.id;
                  final mood = await ApiService.instance.addMood(
                    data: {
                      "mood": context.read(moodProvider).state,
                      "date": DateTime.now().millisecondsSinceEpoch,
                      "content": context.read(contentControllerProvider).text,
                    },
                    read: ['user:$userid'],
                    write: ['user:$userid'],
                  );
                  if (mood != null) {
                    final cp = context.read(moodsProvider);
                    final moods = cp.state;
                    moods.add(mood);
                    cp.state = moods;
                  }
                  context.read(contentControllerProvider).clear();
                  context.read(moodProvider).state = 0;
                },
              ),
            ),
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
        onPressed: () {},
      ),
    );
  }
}
