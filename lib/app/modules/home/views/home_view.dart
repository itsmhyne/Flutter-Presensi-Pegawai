import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mhygetcli/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomeView'),
        actions: [
          IconButton(
              onPressed: () => Get.toNamed(Routes.ADD_PEGAWAI),
              icon: Icon(Icons.person_add))
        ],
      ),
      body: Center(
        child: Text(
          'Hello Hamdan Welcome in Flutter',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
