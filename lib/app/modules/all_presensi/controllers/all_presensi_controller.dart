import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AllPresensiController extends GetxController {
  //TODO: Implement AllPresensiController

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DateTime? start;
  DateTime end = DateTime.now();

  Future<QuerySnapshot<Map<String, dynamic>>> getPresence() async {
    String uid = auth.currentUser!.uid;
    if (start == null) {
      return await firestore
          .collection("pegawai")
          .doc(uid)
          .collection("presence")
          .where("date", isLessThan: end.toIso8601String())
          .orderBy("date", descending: true)
          .get();
    } else {
      return await firestore
          .collection("pegawai")
          .doc(uid)
          .collection("presence")
          .where("date",
              isGreaterThan: start!.toIso8601String(),
              isLessThan: end.add(Duration(days: 1)).toIso8601String())
          .orderBy("date", descending: true)
          .get();
    }
  }

  void pickDate(DateTime pickStart, DateTime Pickend) {
    start = pickStart;
    end = Pickend;
    update();
    Get.back();
  }
}
