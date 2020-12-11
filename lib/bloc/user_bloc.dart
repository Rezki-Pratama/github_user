import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:infinite_list/model/users.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserStateEmpty());

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    List<User> user;

    if (event is SearchUsers) {
      final String searchTerm = event.text;
      if (searchTerm.isEmpty) {
        yield UserStateEmpty();
      } else {
        try {
          if (event.lazyLoad) {
            UserStateSuccess repoStateSuccess = state as UserStateSuccess;
            user = await User.getApi(
                searchTerm, repoStateSuccess.user.length, 10);
            yield (user.isEmpty)
                ? repoStateSuccess.copyWith(hasReachedMax: true)
                : UserStateSuccess(
                    user: repoStateSuccess.user + user,
                    hasReachedMax: false);
          } else {
            yield UserStateLoading();
            await Future<void>.delayed(Duration(seconds: 2));
            user = await User.getApi(searchTerm, 0, 10);
            yield UserStateSuccess(
                user: user, hasReachedMax: false);
          }
        } catch (e) {
          yield e is UserError
              ? UserStateError(message: e.message)
              : UserStateError(message: 'Something wrong');
        }
      }
    }
  }
}
