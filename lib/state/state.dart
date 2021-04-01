import 'package:appmoodo/model/mood.dart';
import 'package:appmoodo/model/user.dart';
import 'package:appmoodo/service/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isLoggedInProvider = StateProvider<bool>((ref) => false);
final userProvider = StateProvider<User>((ref) => null);

final _dayMoodsFutureProvider = FutureProvider.family<List<Mood>, DateTime>(
    (ref, date) => ApiService.instance.getMoodsDay(date: date));
final dayMoodsProvider =
    StateProvider.family<List<Mood>, DateTime>((ref, date) {
  return ref
      .watch(_dayMoodsFutureProvider(date))
      .when(data: (moods) => moods, loading: () => [], error: (_, __) => []);
});

final moodsProvider = StateProvider<List<Mood>>((ref) => []);
final moodsFutureProvider = FutureProvider<List<Mood>>((ref) async {
  final ch = await ApiService.instance.getMoods();
  ref.read(moodsProvider).state = ch;
  return ch;
});
