import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presence_app/app/routes/app_pages.dart';
import 'package:geolocator/geolocator.dart';

class PageIndexController extends GetxController {
  //TODO: Implement PageIndexController
  RxInt pageIndex = 0.obs;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void changPage(int i) async {
    switch (i) {
      case 1:
        print("absensi");
        Map<String, dynamic> dataResponse = await determinePosition();
        if (dataResponse["error"] != true) {
          Position position = dataResponse["location"];
          //jika terjadi permasalah pada miss plugin maka stop aplikasi lalu run ulang
          List<Placemark> placemarks = await placemarkFromCoordinates(
              position.latitude, position.longitude);
          String address =
              "${placemarks[0].name}, ${placemarks[0].subLocality}, ${placemarks[0].locality}";
          await updatePosition(position, address);

          //cek distance kantor dengan posisi pegawai
          double distance = Geolocator.distanceBetween(
              -6.3652214, 106.8295695, position.latitude, position.longitude);

          //ambil absen
          await presensi(position, address, distance);
        } else {
          Get.snackbar("Terjadi Kesalahan", "${dataResponse["message"]}");
        }
        //Get.offAllNamed(Routes.PROFILE);
        break;
      case 2:
        pageIndex.value = i;
        Get.offAllNamed(Routes.PROFILE);
        break;
      default:
        pageIndex.value = i;
        Get.offAllNamed(Routes.HOME);
    }
  }

  Future<void> presensi(
      Position position, String address, double distance) async {
    String uid = auth.currentUser!.uid;
    CollectionReference<Map<String, dynamic>> colPresence =
        await firestore.collection("pegawai").doc(uid).collection("presence");
    QuerySnapshot<Map<String, dynamic>> snapshotPresence =
        await colPresence.get();

    DateTime now = DateTime.now();
    String todayDocId = DateFormat.yMd().format(now).replaceAll("/", "-");

    String status = "Di luar area";
    if (distance <= 100) {
      status = "Di Dalam area";
    }

    if (snapshotPresence.docs.length == 0) {
      //belum pernah absen & set absen masuk

      await Get.defaultDialog(
        title: "Validasi Presensi",
        middleText:
            "Apakah kamu yakin akan mengisi daftar hadir (MASUK) sekarang?",
        actions: [
          OutlinedButton(
              onPressed: () {
                Get.back();
              },
              child: Text("Cancel")),
          ElevatedButton(
              onPressed: () async {
                await colPresence.doc(todayDocId).set({
                  "date": now.toIso8601String(),
                  "masuk": {
                    "date": now.toIso8601String(),
                    "lat": position.latitude,
                    "long": position.longitude,
                    "address": address,
                    "status": status,
                    "distance": distance,
                  }
                });
                Get.back();
                Get.snackbar("Berhasil", "Berhasil mengisi absen masuk");
              },
              child: Text("YES"))
        ],
      );
    } else {
      DocumentSnapshot<Map<String, dynamic>> todayDoc =
          await colPresence.doc(todayDocId).get();
      if (todayDoc.exists == true) {
        //tinggal absen keluar atau sudah absen masuk dan keluar
        Map<String, dynamic>? dataPresenceToday = todayDoc.data();
        if (dataPresenceToday?["keluar"] != null) {
          //sudah absen  keluar
          Get.snackbar(
              "pantek", "ang lah absen masuak dan kalua hari ko anjiang!!!!!!");
        } else {
          //absen keluar
          await Get.defaultDialog(
            title: "Validasi Presensi",
            middleText:
                "Apakah kamu yakin akan mengisi daftar hadir (KELUAR) sekarang?",
            actions: [
              OutlinedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text("Cancel")),
              ElevatedButton(
                  onPressed: () async {
                    await colPresence.doc(todayDocId).update({
                      "date": now.toIso8601String(),
                      "keluar": {
                        "date": now.toIso8601String(),
                        "lat": position.latitude,
                        "long": position.longitude,
                        "address": address,
                        "status": status,
                        "distance": distance,
                      }
                    });
                    Get.back();
                    Get.snackbar("Berhasil", "Berhasil mengisi absen keluar");
                  },
                  child: Text("YES"))
            ],
          );
        }
      } else {
        print("pantek dijalankan");
        //absen masuk
        await Get.defaultDialog(
          title: "Validasi Presensi",
          middleText:
              "Apakah kamu yakin akan mengisi daftar hadir (MASUK) sekarang?",
          actions: [
            OutlinedButton(
                onPressed: () {
                  Get.back();
                },
                child: Text("Cancel")),
            ElevatedButton(
                onPressed: () async {
                  await colPresence.doc(todayDocId).set({
                    "date": now.toIso8601String(),
                    "masuk": {
                      "date": now.toIso8601String(),
                      "lat": position.latitude,
                      "long": position.longitude,
                      "address": address,
                      "status": status,
                      "distance": distance,
                    }
                  });
                  Get.back();
                  Get.snackbar("Berhasil", "Berhasil mengisi absen masuk");
                },
                child: Text("YES"))
          ],
        );
      }
    }
  }

  Future<void> updatePosition(Position position, String address) async {
    String uid = auth.currentUser!.uid;
    await firestore.collection("pegawai").doc(uid).update({
      "position": {
        "lat": position.latitude,
        "long": position.longitude,
      },
      "address": address,
    });
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Map<String, dynamic>> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      //return Future.error('Location services are disabled.');
      return {
        "message": "Tidak dapat mengambil GPS dari device",
        "error": true,
      };
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        //return Future.error('Location permissions are denied');
        return {
          "message": "Settingan access gps ditolak.",
          "error": true,
        };
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return {
        "message":
            "Settingan access gps dimatikan, silakan hidupkan di pengaturan",
        "error": true,
      };
      //return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return {
      "location": position,
      "message": "Berhasil mendapatkan posisi device",
      "error": false,
    };
  }
}
