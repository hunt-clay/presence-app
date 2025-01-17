import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presence_app/app/controllers/page_index_controller.dart';
import 'package:presence_app/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final pageC = Get.find<PageIndexController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('HOME'),
          centerTitle: true,
        ),
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: controller.streamUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData) {
                Map<String, dynamic> user = snapshot.data!.data()!;
                String defaultImage =
                    "https://ui-avatars.com/api/?name=${user['name']}?background=random";
                return ListView(
                  padding: EdgeInsets.all(20),
                  children: [
                    Row(
                      children: [
                        ClipOval(
                          child: Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey[200],
                            child: Image.network(
                              user['profile'] != null
                                  ? user['profile']
                                  : defaultImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              width: 200,
                              child: Text(user['address'] != null
                                  ? "${user['address']}"
                                  : "Belum ada lokasi."),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[350],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${user['job']}",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "${user['nip']}",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "${user['name']}",
                              style: TextStyle(fontSize: 18),
                            ),
                          ]),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.grey[350],
                          borderRadius: BorderRadius.circular(20)),
                      child: StreamBuilder(
                          stream: controller.streamTodayPresence(),
                          builder: (context, snapToday) {
                            if (snapToday.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            var dataToday = snapToday.data?.data();

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text("Masuk"),
                                    Text(dataToday?['masuk'] == null
                                        ? "-"
                                        : "${DateFormat.jms().format(DateTime.parse(dataToday?['masuk']['date']))}"),
                                  ],
                                ),
                                Container(
                                  width: 2,
                                  height: 40,
                                  color: Colors.grey,
                                ),
                                Column(
                                  children: [
                                    Text("Keluar"),
                                    Text(dataToday?['keluar'] == null
                                        ? "-"
                                        : "${DateFormat.jms().format(DateTime.parse(dataToday?['keluar']['date']))}"),
                                  ],
                                )
                              ],
                            );
                          }),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 2,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Last 5 day",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        TextButton(
                            onPressed: () {
                              Get.toNamed(Routes.ALL_PRESENSI);
                            },
                            child: Text("see more")),
                      ],
                    ),
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: controller.streamLastPresence(),
                        builder: (context, snapPresence) {
                          if (snapPresence.connectionState ==
                              ConnectionState.waiting) {
                            Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapPresence.data?.docs.length == 0 ||
                              snapPresence.data == null) {
                            return Container(
                                height: 150,
                                child: Center(
                                  child: Text("Belum ada history presensi"),
                                ));
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapPresence.data!.docs.length,
                            itemBuilder: ((context, index) {
                              Map<String, dynamic> data =
                                  snapPresence.data!.docs[index].data();

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Material(
                                  color: Colors.grey[200],
                                  child: InkWell(
                                    onTap: () {
                                      Get.toNamed(Routes.DETAIL_PRESENSI,
                                          arguments: data);
                                    },
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 20),
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Masuk",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                "${DateFormat.yMMMEd().format(DateTime.parse(data['date']))}",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Text(data['masuk']?['date'] == null
                                              ? "-"
                                              : "${DateFormat.jms().format(DateTime.parse(data['masuk']['date']))}"),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Keluar",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(data['keluar']?['date'] == null
                                              ? "-"
                                              : "${DateFormat.jms().format(DateTime.parse(data['keluar']['date']))}"),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          );
                        }),
                  ],
                );
              } else {
                return Center(
                  child: Text("Tidak dapat memuat informasi"),
                );
              }
            }),
        bottomNavigationBar: ConvexAppBar(
          style: TabStyle.fixedCircle,
          items: [
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.fingerprint, title: 'Absen'),
            TabItem(icon: Icons.people, title: 'Profile'),
          ],
          initialActiveIndex: pageC.pageIndex.value,
          onTap: (int i) => pageC.changPage(i),
        ));
  }
}
