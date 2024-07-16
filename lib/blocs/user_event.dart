part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class FetchUsers extends UserEvent {
  final int page;

  FetchUsers(this.page);

  @override
  List<Object> get props => [page];
}

class FetchUserDetail extends UserEvent {
  final int userId;

  FetchUserDetail(this.userId);

  @override
  List<Object> get props => [userId];
}
