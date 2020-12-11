import 'dart:convert';
import 'package:http/http.dart' as http;

class Repositories {
  final String fullName;
  final String htmlUrl;
  final int stargazersCount;
  final int watchersCount;
  final int forks;
  final DateTime createdAt;
  final Owner owner;

  Repositories({this.fullName, this.htmlUrl, this.owner, this.createdAt, this.stargazersCount, this.watchersCount, this.forks});

  factory Repositories.createPost(Map<String, dynamic> json) {
    return Repositories(
      fullName: json['full_name'] as String,
      htmlUrl: json['html_url'] as String,
      owner: Owner.fromJson(json['owner']),
      createdAt: DateTime.parse(json["created_at"]),
      stargazersCount: json['stargazers_count'] as int,
      watchersCount: json['watchers_count'] as int,
      forks: json['forks'] as int
    );
  }

  static Future<List<Repositories>> getApi(
      String term, int start, int limit) async {
    String apiUrl =
        "https://api.github.com/search/repositories?q=$term&order=desc&page=$start&per_page=$limit";
    var response = await http.get(apiUrl);
    var jsonObject = json.decode(response.body);
    var listObject = jsonObject['items'] as List;
    if (response.statusCode == 200) {
      return listObject
          .map<Repositories>((item) => Repositories(
              fullName: item['full_name'],
              htmlUrl: item['html_url'],
              owner: Owner.fromJson(item['owner']),
              createdAt: DateTime.parse(item["created_at"]),
              stargazersCount: item['stargazers_count'],
              watchersCount: item['watchers_count'],
              forks: item['forks']
              ))
          .toList();
    } else {
      throw RepositoriesError.fromJson(jsonObject);
    }
  }
}

class Owner {
  final String login;
  final String avatarUrl;

  const Owner({this.login, this.avatarUrl});

  factory Owner.fromJson(Map<String, dynamic> item) {
    return Owner(
      login: item['login'],
      avatarUrl: item['avatar_url'],
    );
  }
}

class RepositoriesError {
  final String message;

  const RepositoriesError({this.message});

  static RepositoriesError fromJson(dynamic json) {
    print(json);
    return RepositoriesError(
      message: json['message'] as String,
    );
  }
}
