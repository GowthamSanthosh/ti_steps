import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../blocs/user_bloc.dart';
import '../repositories/user_repository.dart';
import '../models/user_model.dart';

class UserDetailScreen extends StatelessWidget {
  final int userId;

  UserDetailScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc(userRepository: UserRepository(baseUrl: 'https://reqres.in'))
        ..add(FetchUserDetail(userId)),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text(
            'User Detail',
            style: TextStyle(
              fontFamily: 'SF-PRO',
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is UserDetailLoaded) {
              final user = state.user;
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: 'avatar-${user.id}', // Ensure unique tag for Hero animation
                      child: CircleAvatar(
                        radius: 80.0,
                        backgroundImage: CachedNetworkImageProvider(user.avatar),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    FadeTransition(
                      opacity: _buildFadeAnimation(context),
                      child: Column(
                        children: [
                          Text(
                            '${user.firstName} ${user.lastName}',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontFamily: 'SF-PRO',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            user.email,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: 'SF-PRO',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is UserError) {
              return Center(
                child: Text(
                  state.message,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'SF-PRO',
                  ),
                ),
              );
            }
            return Container(); // Placeholder widget when state is not yet defined
          },
        ),
      ),
    );
  }

  // Helper method to build fade transition animation
  Animation<double> _buildFadeAnimation(BuildContext context) {
    final animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: Scaffold.of(context),
    );
    final animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
    );
    animationController.forward();
    return animation;
  }
}
