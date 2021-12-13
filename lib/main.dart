import 'package:flutter/material.dart';
import 'package:locadora/imports.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:locadora/pages/default_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(fb.apps.isEmpty) {
    await _initFirebase();
  }

  runApp(const MyApp());
}

_initFirebase() {
  fb.initializeApp(
    apiKey: 'AIzaSyCQrQx2NDCFkqOtsffe8LoGWayvRvW4dew',
    projectId: 'locadora-veiculos-404ca',
    authDomain: 'locadora-veiculos-404ca.firebaseapp.com',
    appId: '1:582796742599:web:a71795f351eb392f8d53e2',
    storageBucket: 'locadora-veiculos-404ca.appspot.com',
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Locadora de veículos - Fatec Taubaté',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: DefaultPage(),
    );
  }
}