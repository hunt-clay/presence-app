import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser() async* {
    String uid = await auth.currentUser!.uid;
    yield* firestore.collection("pegawai").doc(uid).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamLastPresence() async* {
    String uid = await auth.currentUser!.uid;
    yield* firestore
        .collection("pegawai")
        .doc(uid)
        .collection("presence")
        .orderBy("date", descending: true)
        .limitToLast(5)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamTodayPresence() async* {
    String uid = await auth.currentUser!.uid;
    String todayId =
        DateFormat.yMd().format(DateTime.now()).replaceAll("/", "-");
    yield* firestore
        .collection("pegawai")
        .doc(uid)
        .collection("presence")
        .doc(todayId)
        .snapshots();
  }
}
