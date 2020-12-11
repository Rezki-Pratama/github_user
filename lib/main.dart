import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_list/bloc/issues_bloc.dart';
import 'package:infinite_list/bloc/repositories_bloc.dart';
import 'package:infinite_list/bloc/user_bloc.dart';
import 'package:infinite_list/ui/main_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
    .then((_) {
      runApp(new MyApp());
    });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MultiBlocProvider(providers: [
          BlocProvider<RepositoriesBloc>(
              create: (context) =>
                  RepositoriesBloc()..add(RepositoriesEvent())),
          BlocProvider<UserBloc>(
              create: (context) => UserBloc()..add(UsersEvent())),
          BlocProvider<IssuesBloc>(
              create: (context) => IssuesBloc()..add(IssueEvent())),
        ], child: MainPage()));
  }
}
