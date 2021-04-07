import 'package:appmoodo/model/mood.dart';
import 'package:appmoodo/res/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MoodListItem extends StatelessWidget {
  final Mood mood;

  const MoodListItem({Key key, this.mood}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.grey.shade200,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text(
              AppConstants.moodMojis[mood.mood - 1],
              style: TextStyle(
                fontSize: 45.0,
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(DateFormat.yMMMd().format(mood.date)),
                  Text.rich(
                    TextSpan(children: [
                      TextSpan(
                        text:
                            AppConstants.moodNames[mood.mood - 1].toUpperCase(),
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      TextSpan(
                          text: " " + DateFormat.jm().format(mood.date),
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          )),
                    ]),
                  ),
                  if (mood.content.isNotEmpty) ...[
                    const SizedBox(height: 5.0),
                    Text(
                      mood.content,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
