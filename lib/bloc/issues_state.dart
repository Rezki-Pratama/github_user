part of 'issues_bloc.dart';

abstract class IssuesState {}

class IssuesStateEmpty extends IssuesState {}

class IssuesStateLoading extends IssuesState {}

class IssuesStateSuccess extends IssuesState {
  final List<Issues> issues;
  final bool hasReachedMax;

  IssuesStateSuccess({ this.issues, this.hasReachedMax});

  IssuesStateSuccess copyWith({List<Issues> issues, bool hasReachedMax}){
    return IssuesStateSuccess(
      issues: issues ?? this.issues,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax
    );
  }
}

class IssuesStateError extends IssuesState {
  final String message;

  IssuesStateError({ this.message });
}

