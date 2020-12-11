part of 'user_bloc.dart';

abstract class UserState {}

class UserStateEmpty extends UserState {}

class UserStateLoading extends UserState {}

class UserStateSuccess extends UserState {
  final List<User> user;
  final bool hasReachedMax;

  UserStateSuccess({ this.user, this.hasReachedMax});

  UserStateSuccess copyWith({List<User> user, bool hasReachedMax}){
    return UserStateSuccess(
      user: user ?? this.user,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax
    );
  }
}

class UserStateError extends UserState {
  final String message;

  UserStateError({ this.message });
}
