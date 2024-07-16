import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/user_bloc.dart';
import 'repositories/user_repository.dart';
import 'splash_screen.dart';


void main() {
  final userRepository = UserRepository(baseUrl: 'https://reqres.in');

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserBloc(userRepository: userRepository),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SF-Pro', // Assuming you have defined this in your pubspec.yaml
      ),
      home: SplashScreen(), // Start with the splash screen
    );
  }
}
