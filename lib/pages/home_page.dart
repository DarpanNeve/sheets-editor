import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/home_controller.dart';
import '../widgets/bed_info_form.dart';
import '../widgets/update_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Instantiate the controllers using GetX dependency injection.
  static final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Field Planner",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Expanded(
                child: SingleChildScrollView(child: BedInfoForm()),
              ),
              _buildStatusMessages(),
              const UpdateButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusMessages() {
    return Obx(() {
      if (controller.errorMessage.isNotEmpty) {
        return Container(
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.red[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red[200]!),
          ),
          child: Text(
            controller.errorMessage.value,
            style: TextStyle(
              color: Colors.red[800],
              fontSize: 14.sp,
            ),
          ),
        );
      } else if (controller.isUpdateSuccessful.value) {
        return Container(
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green[200]!),
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8.w),
              Text(
                "Data successfully updated to cloud!",
                style: TextStyle(
                  color: Colors.green[800],
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        );
      } else {
        return const SizedBox();
      }
    });
  }
}
