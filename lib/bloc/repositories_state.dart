part of 'repositories_bloc.dart';

@immutable
abstract class RepoState {}

class RepoStateEmpty extends RepoState {}

class RepoStateLoading extends RepoState {}

class RepoStateSuccess extends RepoState {
  final List<Repositories> repositories;
  final bool hasReachedMax;

  RepoStateSuccess({ this.repositories, this.hasReachedMax});

  RepoStateSuccess copyWith({List<Repositories> repositories, bool hasReachedMax}){
    return RepoStateSuccess(
      repositories: repositories ?? this.repositories,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax
    );
  }
}

class RepoStateError extends RepoState {
  final String message;

  RepoStateError({ this.message });
  
}