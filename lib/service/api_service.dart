import 'package:appmoodo/model/mood.dart';
import 'package:appmoodo/model/user.dart';
import 'package:appmoodo/res/app_constants.dart';
import 'package:appwrite/appwrite.dart';

class ApiService {
  final Client client = Client();
  late Account account;
  late Database db;
  static ApiService? _instance;

  ApiService._internal() {
    client
        .setEndpoint(AppConstants.endpoint)
        .setProject(AppConstants.projectId);
    account = Account(client);
    db = Database(client);
  }

  static ApiService? get instance {
    if (_instance == null) {
      _instance = ApiService._internal();
    }
    return _instance;
  }

  Future<bool> signup({required String name, required String email, required String password}) async {
    try {
      await account.create(name: name, email: email, password: password);
      return true;
    } on AppwriteException catch (e) {
      print(e.message);
      return false;
    }
  }

  Future<bool> login({required String email, required String password}) async {
    try {
      await account.createSession(email: email, password: password);
      return true;
    } on AppwriteException catch (e) {
      print(e.message);
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      await account.deleteSessions();
      return true;
    } on AppwriteException catch (e) {
      print(e.message);
      return false;
    }
  }

  Future<User?> getUser() async {
    try {
      final res = await account.get();
      return User.fromMap(res.data);
    } on AppwriteException catch (e) {
      print(e.message);
      return null;
    }
  }

  Future<Mood?> addMood({
    required Map<String, dynamic> data,
    required List<String> read,
    required List<String> write,
  }) async {
    try {
      final res = await db.createDocument(
        collectionId: AppConstants.entriesCollection,
        data: data,
        read: read,
        write: write,
      );
      return Mood.fromMap(res.data);
    } on AppwriteException catch (e) {
      print(e.message);
      return null;
    }
  }

  Future<List<Mood>> getMoods() async {
    try {
      final res = await db.listDocuments(
        collectionId: AppConstants.entriesCollection,
        orderField: 'date',
        orderType: OrderType.desc,
      );
      return List<Map<String, dynamic>>.from(res.data['documents'])
          .map((e) => Mood.fromMap(e))
          .toList();
    } on AppwriteException catch (e) {
      print(e.message);
      return [];
    }
  }

  Future<List<Mood>> getMoodsDay({DateTime? date}) async {
    date = date ?? DateTime.now();

    try {
      final res = await db.listDocuments(
        collectionId: AppConstants.entriesCollection,
        orderField: 'date',
        orderType: OrderType.desc,
        filters: [
          'date>=${DateTime(date.year, date.month, date.day, 0).millisecondsSinceEpoch}',
          'date<${DateTime(date.year, date.month, date.day + 1, 0).millisecondsSinceEpoch}',
        ],
      );
      return List<Map<String, dynamic>>.from(res.data['documents'])
          .map((e) => Mood.fromMap(e))
          .toList();
    } on AppwriteException catch (e) {
      print(e.message);
      return [];
    }
  }

  Future<List<Mood>> getMoodsMonth({DateTime? date}) async {
    date = date ?? DateTime.now();

    try {
      final res = await db.listDocuments(
        collectionId: AppConstants.entriesCollection,
        orderField: 'date',
        orderType: OrderType.desc,
        filters: [
          'date>=${DateTime(date.year, date.month, 1, 0).millisecondsSinceEpoch}',
          'date<${DateTime(date.year, date.month + 1, 1, 0).millisecondsSinceEpoch}',
        ],
      );
      return List<Map<String, dynamic>>.from(res.data['documents'])
          .map((e) => Mood.fromMap(e))
          .toList();
    } on AppwriteException catch (e) {
      print(e.message);
      return [];
    }
  }
}
