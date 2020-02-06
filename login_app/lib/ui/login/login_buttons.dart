import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:login_app/bloc/login_bloc/login_bloc.dart';
import 'package:login_app/data/repository/user_repository.dart';
import 'package:login_app/ui/register/register_screen.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback _onPressed;

  const LoginButton({Key key, VoidCallback onPressed}) 
  : _onPressed = onPressed,
    super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: _onPressed,
      child: Text('Login'),
    );
  }
}

class GoogleLoginButton extends StatelessWidget {
  const GoogleLoginButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
      icon: Icon(FontAwesomeIcons.google, color: Colors.white,),
      label: Text("Sign in with Google", style: TextStyle(color: Colors.white)),
      color: Colors.redAccent,
      onPressed: (){
        BlocProvider.of<LoginBloc>(context).add(
          LoginWithGooglePressed(),
        );
      },
    );
  }
}

class CreateAccountButton extends StatelessWidget {
  final UserRepository _userRepository;

  const CreateAccountButton({Key key, @required UserRepository userRepository}) 
  : assert(userRepository != null),
    _userRepository = userRepository,
    super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context){
              return RegisterScreen(userRepository: _userRepository);
            },
          ),
        );
      }, 
      child: Text("Create an Account"),
    );
  }
}