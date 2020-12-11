part of 'issues_bloc.dart';

abstract class IssuesEvent extends Equatable {
  const IssuesEvent();
}

class IssueEvent extends IssuesEvent{
  
  @override
  List<Object> get props => [];
}

class SearchIssues extends IssuesEvent{
  final String text;
  final bool lazyLoad;

  const SearchIssues({ this.text, this.lazyLoad });

  @override
  List<Object> get props => [];

  @override
  String toString() => 'SearchIssues { text: $text }';

  String toBool() => 'SearchIssues { lazyLoad: $lazyLoad }';
}
