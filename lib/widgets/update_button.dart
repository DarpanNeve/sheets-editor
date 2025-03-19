import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../pages/home_page.dart';

class UpdateButton extends StatelessWidget {
  const UpdateButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = HomePage.controller;
    return SizedBox(
      height: 50.h,
      child: Obx(() => ElevatedButton(
        onPressed: controller.isLoading.value
            ? null
            : controller.updateSheet,
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: Colors.grey[300],
        ),
        child: controller.isLoading.value
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 24.w,
              height: 24.h,
              child: CircularProgressIndicator(
                valueColor:
                const AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3.w,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              "Updating...",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_upload, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              "Update to cloud",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      )),
    );
  }
}
