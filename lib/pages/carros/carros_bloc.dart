import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locadora/imports.dart';

class CarrosBloc {

  CollectionReference get _carros =>
      FirebaseFirestore.instance.collection('carros').withConverter<Carro>(
        fromFirestore: (snapshots, _) => Carro.fromMap(snapshots.data()),
        toFirestore: (carro, _) => carro.toMap(),
      );

  Stream<QuerySnapshot> get stream => _carros.orderBy('fabricante').snapshots();
}
