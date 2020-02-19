import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:login_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:login_app/data/repository/user_repository.dart';
import 'package:login_app/bloc_delegate.dart';
import 'package:login_app/ui/home_screen.dart';
import 'package:login_app/ui/login/login_screen.dart';
import 'package:login_app/ui/splash_screen.dart';
import 'package:login_app/utils/firebase_notifications.dart';
import 'package:login_app/utils/themes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  FirebaseNotifications().setUpFireBase();
  final UserRepository userRepostory = UserRepository();
  
  runApp(
    BlocProvider(
      create: (context) => AuthenticationBloc(userRepository: userRepostory)..add(AppStarted()),
      child: App(userRepository: userRepostory),
    ),
  );
}

class App extends StatelessWidget {

  final UserRepository _userRepository;

  App({Key key, @required UserRepository userRepository})
    : assert(userRepository != null),
      _userRepository = userRepository,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state){
          if (state is Uninitialized){
            return SplashScreen();
          }
          if (state is Authenticated) {
            return HomeScreen(name: state.displayName);
          }
          if (state is Unauthenticated) {
            return LoginScreen(userRepository: _userRepository);
          }
        },
      ),
    );
  }
}