part of 'user_bloc.dart';


abstract class UserEvent extends Equatable {
  const UserEvent();
}

class UsersEvent extends UserEvent{
  
  @override
  List<Object> get props => [];
}

class SearchUsers extends UserEvent{
  final String text;
  final bool lazyLoad;

  const SearchUsers({ this.text, this.lazyLoad });

  @override
  List<Object> get props => [];

  @override
  String toString() => 'TextSearch { text: $text }';

  String toBool() => 'TextSearch { lazyLoad: $lazyLoad }';
}