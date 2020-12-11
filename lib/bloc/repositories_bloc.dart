import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:infinite_list/model/repositories.dart';
import 'package:meta/meta.dart';

part 'repositories_event.dart';
part 'repositories_state.dart';

class RepositoriesBloc extends Bloc<RepoEvent, RepoState> {
  RepositoriesBloc() : super(RepoStateEmpty());

  @override
  Stream<RepoState> mapEventToState(
    RepoEvent event,
  ) async* {
    List<Repositories> repositories;

    if (event is TextSearch) {
      final String searchTerm = event.text;
      if (searchTerm.isEmpty) {
        yield RepoStateEmpty();
      } else {
        try {
          if (event.lazyLoad) {
            RepoStateSuccess repoStateSuccess = state as RepoStateSuccess;
            repositories = await Repositories.getApi(
                searchTerm, repoStateSuccess.repositories.length, 10);
            yield (repositories.isEmpty)
                ? repoStateSuccess.copyWith(hasReachedMax: true)
                : RepoStateSuccess(
                    repositories: repoStateSuccess.repositories + repositories,
                    hasReachedMax: false);
          } else {
            yield RepoStateLoading();
            await Future<void>.delayed(Duration(seconds: 2));
            repositories = await Repositories.getApi(searchTerm, 0, 10);
            yield RepoStateSuccess(
                repositories: repositories, hasReachedMax: false);
          }
        } catch (e) {
          yield e is RepositoriesError
              ? RepoStateError(message: e.message)
              : RepoStateError(message: 'Something wrong');
        }
      }
    }
  }
}
