import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/user_model.dart';
import '../repositories/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(UserInitial()) {
    on<FetchUsers>(_onFetchUsers);
    on<FetchUserDetail>(_onFetchUserDetail);
  }

  void _onFetchUsers(FetchUsers event, Emitter<UserState> emit) async {
    try {
      final users = await userRepository.fetchUsers(event.page);
      final hasReachedMax = users.length < userRepository.pageSize;
      emit(UserLoaded(users: users, hasReachedMax: hasReachedMax));
    } catch (error) {
      emit(UserError(message: error.toString()));
    }
  }

  void _onFetchUserDetail(FetchUserDetail event, Emitter<UserState> emit) async {
    try {
      final user = await userRepository.fetchUserDetail(event.userId);
      emit(UserDetailLoaded(user: user));
    } catch (error) {
      emit(UserError(message: error.toString()));
    }
  }
}
