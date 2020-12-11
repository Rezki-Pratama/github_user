part of 'repositories_bloc.dart';

@immutable
abstract class RepoEvent extends Equatable {
  const RepoEvent();
}

class RepositoriesEvent extends RepoEvent{
  
  @override
  List<Object> get props => [];
}

class TextSearch extends RepoEvent{
  final String text;
  final bool lazyLoad;

  const TextSearch({ this.text, this.lazyLoad });

  @override
  List<Object> get props => [];

  @override
  String toString() => 'TextSearch { text: $text }';

  String toBool() => 'TextSearch { lazyLoad: $lazyLoad }';
}
