import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart';

class CarrosService {
  CollectionReference getCarros() => fb.firestore().collection("carros");




  Stream<List<DocumentSnapshot>> getStreamCarros() => getCarros().onSnapshot.map
    ((QuerySnapshot query) => query.docs.map((DocumentSnapshot doc) => doc).toList());

  /*CollectionReference get _reservas =>
      FirebaseFirestore.instance.collection('carros').withConverter<Carro>(
        fromFirestore: (snapshots, _) => Carro.fromMap(snapshots.data()!),
        toFirestore: (carro, _) => carro.toMap(),
      );

   get stream => _reservas.orderBy('dataReserva');*/

}