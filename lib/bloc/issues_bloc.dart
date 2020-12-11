import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:infinite_list/model/issues.dart';

part 'issues_event.dart';
part 'issues_state.dart';

class IssuesBloc extends Bloc<IssuesEvent, IssuesState> {
  IssuesBloc() : super(IssuesStateEmpty());

  @override
  Stream<IssuesState> mapEventToState(
    IssuesEvent event,
  ) async* {
    List<Issues> issues;

    if (event is SearchIssues) {
      final String searchTerm = event.text;
      if (searchTerm.isEmpty) {
        yield IssuesStateEmpty();
      } else {
        try {
          if (event.lazyLoad) {
            IssuesStateSuccess issuesStateSuccess = state as IssuesStateSuccess;
            issues = await Issues.getApi(
                searchTerm, issuesStateSuccess.issues.length, 10);
            yield (issues.isEmpty)
                ? issuesStateSuccess.copyWith(hasReachedMax: true)
                : IssuesStateSuccess(
                    issues: issuesStateSuccess.issues + issues,
                    hasReachedMax: false);
          } else {
            yield IssuesStateLoading();
            await Future<void>.delayed(Duration(seconds: 2));
            issues = await Issues.getApi(searchTerm, 0, 10);
            yield IssuesStateSuccess(
                issues: issues, hasReachedMax: false);
          }
        } catch (e) {
          yield e is IssuesError
              ? IssuesStateError(message: e.message)
              : IssuesStateError(message: 'Something wrong');
        }
      }
    }
  }
}
