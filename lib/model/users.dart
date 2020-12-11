import 'dart:convert';
import 'package:http/http.dart' as http;

class User {
  final String login;
  final String avatarUrl;

  const User({this.login, this.avatarUrl});

  factory User.createPost(Map<String, dynamic> json) {
    return User(
      login: json['login'],
      avatarUrl: json['avatar_url'],
    );
  }

  static Future<List<User>> getApi(String term, int start, int limit) async {
    String apiUrl =
        "https://api.github.com/search/users?q=$term&order=desc&page=$start&per_page=$limit";
    var response = await http.get(apiUrl);
    var jsonObject = json.decode(response.body);
    var listObject = jsonObject['items'] as List;
    print(response.statusCode);
    if (response.statusCode == 200) {
      return listObject
          .map<User>((item) =>
              User(login: item['login'], avatarUrl: item['avatar_url']))
          .toList();
    } else {
      throw UserError.fromJson(jsonObject);
    }
  }
}

class UserError {
  final String message;

  const UserError({this.message});

  static UserError fromJson(dynamic json) {
    print(json);
    return UserError(
      message: json['message'] as String,
    );
  }
}
