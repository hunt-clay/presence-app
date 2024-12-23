import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presence_app/app/routes/app_pages.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../controllers/all_presensi_controller.dart';

class AllPresensiView extends GetView<AllPresensiController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ALL PRESENSI'),
        centerTitle: true,
      ),
      body: GetBuilder<AllPresensiController>(
          builder: ((c) => FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
              future: controller.getPresence(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data?.docs.length == 0 || snapshot.data == null) {
                  return Center(
                    child: Text("Belum ada informasi"),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.all(20),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: ((context, index) {
                    Map<String, dynamic> data =
                        snapshot.data!.docs[index].data();
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
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Masuk",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "${DateFormat.yMMMEd().format(DateTime.parse(data['date']))}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
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
              }))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //syncfusion datepicker
          Get.dialog(Dialog(
            child: Container(
              padding: EdgeInsets.all(20),
              height: 400,
              child: SfDateRangePicker(
                monthViewSettings:
                    DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
                selectionMode: DateRangePickerSelectionMode.range,
                showActionButtons: true,
                onCancel: () => Get.back(),
                onSubmit: (p0) {
                  if (p0 != null) {
                    if ((p0 as PickerDateRange).endDate != null) {
                      controller.pickDate(p0.startDate!, p0.endDate!);
                    }
                  }
                },
              ),
            ),
          ));
        },
        child: Icon(Icons.format_list_bulleted_rounded),
      ),
    );
  }
}
