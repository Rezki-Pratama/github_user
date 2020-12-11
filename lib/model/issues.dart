import 'dart:convert';
import 'package:http/http.dart' as http;

class Issues {
  final String title;
  final String state;
  final Users user;
  final DateTime updatedAt;

  const Issues({this.title, this.user, this.state, this.updatedAt});

  factory Issues.createPost(Map<String, dynamic> json) {
    return Issues(
        title: json['title'],
        user: Users.fromJson(json['user']),
        state: json['state'],
        updatedAt: DateTime.parse(json["updated_at"]));
  }

  static Future<List<Issues>> getApi(String term, int start, int limit) async {
    String apiUrl =
        "https://api.github.com/search/issues?q=$term&order=desc&page=$start&per_page=$limit";
    var response = await http.get(apiUrl);
    var jsonObject = json.decode(response.body);
    var listObject = jsonObject['items'] as List;
    if (response.statusCode == 200) {
      return listObject
          .map<Issues>((item) =>
              Issues(
                title: item['title'],
                user: Users.fromJson(item['user']),
                state: item['state'],
                updatedAt: DateTime.parse(item["updated_at"])
              ))
          .toList();
    } else {
      throw IssuesError.fromJson(jsonObject);
    }
  }
}

class Users {
  final String login;
  final String avatarUrl;

  const Users({this.login, this.avatarUrl});

  factory Users.fromJson(Map<String, dynamic> item) {
    return Users(
      avatarUrl: item['avatar_url'],
    );
  }
}

class IssuesError {
  final String message;

  const IssuesError({this.message});

  static IssuesError fromJson(dynamic json) {
    return IssuesError(
      message: json['message'] as String,
    );
  }
}
