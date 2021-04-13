import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../service/api_service.dart';
import '../../state/state.dart';
import 'mood_icon.dart';

final AutoDisposeStateProvider<int>? moodProvider = StateProvider.autoDispose<int>((ref) => 0);
final AutoDisposeProvider<TextEditingController>? contentControllerProvider =
    Provider.autoDispose((ref) => TextEditingController());

class AddMood extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final mood = watch(moodProvider!).state;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
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
              emoji: "😄",
              onTap: () {
                watch(moodProvider!).state = 5;
              },
            ),
            MoodIcon(
              isSelected: mood == 4,
              emoji: "🙂",
              onTap: () {
                watch(moodProvider!).state = 4;
              },
            ),
            MoodIcon(
              isSelected: mood == 3,
              emoji: "😐",
              onTap: () {
                watch(moodProvider!).state = 3;
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MoodIcon(
              isSelected: mood == 2,
              emoji: "🙁",
              onTap: () {
                watch(moodProvider!).state = 2;
              },
            ),
            MoodIcon(
              isSelected: mood == 1,
              emoji: "😩",
              onTap: () {
                watch(moodProvider!).state = 1;
              },
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        TextField(
          controller: watch(contentControllerProvider!),
          decoration: InputDecoration(hintText: "Note"),
          maxLines: 3,
        ),
        const SizedBox(height: 10.0),
        Center(
          child: ElevatedButton(
            child: Text("Submit"),
            onPressed: () async {
              String? userid = context.read(userProvider).state!.id;
              final mood = await ApiService.instance!.addMood(
                data: {
                  "mood": context.read(moodProvider!).state,
                  "date": DateTime.now().millisecondsSinceEpoch,
                  "content": context.read(contentControllerProvider!).text,
                },
                read: ['user:$userid'],
                write: ['user:$userid'],
              );
              if (mood != null) {
                var today = DateTime.now();
                final cp = context.read(monthMoodsProvider!(today));
                final moods = cp.state;
                moods.insert(0, mood);
                cp.state = moods;
              }
              context.read(contentControllerProvider!).clear();
              context.read(moodProvider!).state = 0;
              Navigator.of(context).maybePop();
            },
          ),
        ),
      ],
    );
  }
}
