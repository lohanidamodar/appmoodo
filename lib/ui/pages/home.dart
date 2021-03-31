import 'package:appmoodo/service/api_service.dart';
import 'package:appmoodo/state/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final moodProvider = StateProvider<double>((ref) => 1.0);
final contentControllerProvider = Provider((ref) => TextEditingController());

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final moodState = watch(moodProvider);
    watch(moodsFutureProvider);
    final moodEntries = watch(moodsProvider).state;
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          Text(
            "How are you feeling?",
            style: Theme.of(context).textTheme.headline3,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20.0),
          Slider(
            value: moodState.state,
            onChanged: (val) {
              moodState.state = val;
            },
            min: 1.0,
            max: 5.0,
            divisions: 4,
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
              },
            ),
          ),
          ...moodEntries.map((mood) => ListTile(
                title: Text(mood.content ?? mood.mood.toString()),
              ))
        ],
      ),
    );
  }
}
