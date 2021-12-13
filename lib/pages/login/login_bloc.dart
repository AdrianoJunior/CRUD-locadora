import 'dart:async';
import 'dart:convert' as convert;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:locadora/firebase/firebase_service.dart';
import 'package:locadora/imports.dart';


class LoginInput {
  String? login;
  String? senha;

  String toJson() {
    return convert.json.encode({
      "username": login,
      "password": senha,
    });
  }
}

class LoginBloc {
  final progress = BooleanBloc();

  Future<ApiResponse<User>> login(LoginInput loginInput) async {
    progress.set(true);

    ApiResponse<User> response = await FirebaseService().login(loginInput);


    progress.set(false);

    return response;
  }

  void dispose() {
    progress.dispose();
  }
}
