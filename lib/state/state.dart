import 'package:appmoodo/model/mood.dart';
import 'package:appmoodo/model/user.dart';
import 'package:appmoodo/service/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthStatus {
  unauthenticated,
  authenticating,
  authenticated,
  uninitialized
}

final authStateProvider =
    StateProvider<AuthStatus>((ref) => AuthStatus.uninitialized);

final userProvider = StateProvider<User>((ref) => null);

final _dayMoodsFutureProvider = FutureProvider.family<List<Mood>, DateTime>(
    (ref, date) => ApiService.instance.getMoodsDay(date: date));
final dayMoodsProvider =
    StateProvider.family<List<Mood>, DateTime>((ref, date) {
  return ref
      .watch(_dayMoodsFutureProvider(date))
      .when(data: (moods) => moods, loading: () => [], error: (_, __) => []);
});

final _monthMoodsFutureProvider = FutureProvider.family<List<Mood>, DateTime>(
    (ref, date) => ApiService.instance.getMoodsMonth(date: date));
final monthMoodsProvider =
    StateProvider.family<List<Mood>, DateTime>((ref, date) {
  return ref
      .watch(_monthMoodsFutureProvider(date))
      .when(data: (moods) => moods, loading: () => [], error: (_, __) => []);
});

final moodsProvider = StateProvider<List<Mood>>((ref) => []);
final moodsFutureProvider = FutureProvider<List<Mood>>((ref) async {
  final ch = await ApiService.instance.getMoods();
  ref.read(moodsProvider).state = ch;
  return ch;
});
