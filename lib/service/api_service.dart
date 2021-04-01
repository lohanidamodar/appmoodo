import 'package:appmoodo/model/mood.dart';
import 'package:appmoodo/model/user.dart';
import 'package:appmoodo/res/app_constants.dart';
import 'package:appwrite/appwrite.dart';

class ApiService {
  final Client client = Client();
  Account account;
  Database db;
  static ApiService _instance;

  ApiService._internal() {
    client
        .setEndpoint(AppConstants.endpoint)
        .setProject(AppConstants.projectId);
    account = Account(client);
    db = Database(client);
  }

  static ApiService get instance {
    if (_instance == null) {
      _instance = ApiService._internal();
    }
    return _instance;
  }

  Future<bool> signup({String name, String email, String password}) async {
    try {
      await account.create(name: name, email: email, password: password);
      return true;
    } on AppwriteException catch (e) {
      print(e.message);
      return false;
    }
  }

  Future<bool> login({String email, String password}) async {
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

  Future<User> getUser() async {
    try {
      final res = await account.get();
      return User.fromMap(res.data);
    } on AppwriteException catch (e) {
      print(e.message);
      return null;
    }
  }

  Future<Mood> addMood({
    Map<String, dynamic> data,
    List<String> read,
    List<String> write,
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
}
