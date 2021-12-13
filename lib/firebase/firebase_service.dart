import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:locadora/imports.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<ApiResponse<User>> login(LoginInput input) async {
    try {
      // Usuario do Firebase
      final authResult = await _auth.signInWithEmailAndPassword(
          email: input.login!, password: input.senha!);
      final User? fUser = authResult.user;
      print("signed in ${authResult.user!.displayName}");

      // Resposta genérica

      if (fUser != null) {
        return ApiResponse.ok(
            result: fUser /*result: true, msg: "Login efetuado com sucesso"*/);
      } else {
        return ApiResponse.error(
            msg: "Não foi possível fazer o login, tente novamente!");
      }
    } on FirebaseAuthException catch (e) {
      print(" >>> CODE : ${e.code}\n>>> ERRO : $e");
      return ApiResponse.error(
          msg: "Não foi possível fazer o login, tente novamente!");
    }
  }


  static Future<ApiResponse<bool>> saveCarro(Map<String, dynamic> mapCarro) async {
    try {
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('carros').add(mapCarro).then((docReference) {
        Carro c = Carro.fromMap(mapCarro);
        c.id = docReference.id;
        docReference.update(c.toMap());
      });
      return ApiResponse.ok();
    } catch (e) {
      print("ERRO FIRESTORE SAVE >>>>> $e");

      return ApiResponse.error();
    }
  }

  static Future<ApiResponse<bool>> updateCarro(Carro carro) async {
    try {
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('carros').doc(carro.id).update(carro.toMap());
      return ApiResponse.ok();
    } catch (e) {
      print("ERRO FIRESTORE SAVE >>>>> $e");

      return ApiResponse.error();
    }
  }

  static Future<ApiResponse<bool>> delete(Carro? carro) async {
    try {
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('carros').doc(carro!.id).delete();
      return ApiResponse.ok();
    } catch (e) {
      print("ERRO FIRESTORE SAVE >>>>> $e");

      return ApiResponse.error(msg: "Não foi possível excluir o carro ${carro!.modelo} - ${carro.placa}");
    }
  }
}