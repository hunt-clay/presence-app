import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presence_app/app/controllers/page_index_controller.dart';
import 'package:presence_app/app/routes/app_pages.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final pageC = Get.find<PageIndexController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ProfileView'),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: controller.streamRole(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              Map<String, dynamic> user = snapshot.data!.data()!;
              return ListView(
                padding: EdgeInsets.all(15),
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: Container(
                          width: 100,
                          height: 100,
                          child: snapshot.connectionState ==
                                  ConnectionState.waiting
                              ? CircularProgressIndicator()
                              : Image.network(
                                  user["profile"] != null
                                      ? user["profile"] != ""
                                          ? user["profile"]
                                          : "https://ui-avatars.com/api/?name=${user['name']}?background=random"
                                      : "https://ui-avatars.com/api/?name=${user['name']}?background=random",
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${user['name'].toString().toUpperCase()}",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "${user['email']}",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    onTap: () {
                      Get.toNamed(Routes.UPDATE_PROFILE, arguments: user);
                    },
                    leading: Icon(Icons.person),
                    title: Text("Update Profile"),
                  ),
                  ListTile(
                    onTap: () {
                      Get.toNamed(Routes.UPDATE_PASSWORD);
                    },
                    leading: Icon(Icons.vpn_key),
                    title: Text("Update Password"),
                  ),
                  if (user["role"] == "admin")
                    ListTile(
                      onTap: () {
                        Get.toNamed(Routes.ADD_PEGAWAI);
                      },
                      leading: Icon(Icons.person_add),
                      title: Text("Add Pegawai"),
                    ),
                  ListTile(
                    onTap: () {
                      controller.logout();
                    },
                    leading: Icon(Icons.logout),
                    title: Text("Logout"),
                  )
                ],
              );
            } else {
              return Center(
                child: Text("Tidak dapat menampilkan informasi"),
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
      ),
    );
  }
}
