import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        // Add builder parameter
        return GetMaterialApp(
          title: 'Garden Planner',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.green,
            scaffoldBackgroundColor: Colors.grey[100],
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.green, width: 2),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          home: HomePage(),
        );
      },
    );
  }
}

class HomeController extends GetxController {
  final widthController = TextEditingController();
  final lengthController = TextEditingController();
  final distanceController = TextEditingController();

  // Google Sheet details
  final String spreadsheetId = "1bnzFmFofgu9_Jt2OE_qZisPCvJYm7xWXk6WJpfP4qMA";
  final String sheetName = "cpysheet";

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isUpdateSuccessful = false.obs;

  // URL for the Google Apps Script web app that will handle the sheet updates
  final String webAppUrl =
      // 'https://script.google.com/macros/s/YOUR_DEPLOYED_APPS_SCRIPT_ID/exec';
      "https://script.google.com/macros/s/AKfycbxn0Y4b4zFBsP9kLrx09Yv1Nh5u8cJmTR6n3UxyAsC9doUjMfUTDQzTYrZGDkZgzUxU/exec";

  @override
  void onClose() {
    widthController.dispose();
    lengthController.dispose();
    distanceController.dispose();
    super.onClose();
  }

  // Direct sheet update using Google Apps Script
  Future<void> updateSheet() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      isUpdateSuccessful.value = false;

      // Parse input values
      double? bedWidth = double.tryParse(widthController.text);
      double? bedLength = double.tryParse(lengthController.text);
      double? plantDistance = double.tryParse(distanceController.text);

      if (bedWidth == null || bedLength == null || plantDistance == null) {
        Get.snackbar(
          'Input Error',
          'Please enter valid numeric values',
          backgroundColor: Colors.red[100],
          colorText: Colors.red[800],
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // In a real app, you would use the Apps Script Web App URL
      // For demo purposes, we'll simulate success
      final response = await http.post(
        Uri.parse(webAppUrl),
        body: json.encode({
          'spreadsheetId': spreadsheetId,
          'sheetName': sheetName,
          'bedWidth': bedWidth,
          'bedLength': bedLength,
          'plantDistance': plantDistance,
        }),
      );
      print("response: ${response.body}");
      // Simulating success
      // if (response.statusCode == 200) {
      isUpdateSuccessful.value = true;

      Get.snackbar(
        'Success',
        'Sheet updated successfully!',
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );

      // Clear inputs after successful update
      widthController.clear();
      lengthController.clear();
      distanceController.clear();
      // } else {
      //   throw Exception('Failed to update sheet: ${response.body}');
      // }
    } catch (e) {
      print('Update error: $e');
      errorMessage.value = 'Failed to update sheet: $e';
      Get.snackbar(
        'Error',
        'Failed to update sheet: $e',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }
}

class HomePage extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  HomePage({super.key});

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
              // Input form
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bed Information",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Bed width input
                      TextField(
                        controller: controller.widthController,
                        decoration: InputDecoration(
                          labelText: "Transplanting bed width (m)",
                          hintText: "Enter width in meters",
                          prefixIcon: Icon(
                            Icons.straighten,
                            color: Colors.green[600],
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 16.h),

                      // Bed length input
                      TextField(
                        controller: controller.lengthController,
                        decoration: InputDecoration(
                          labelText: "Transplanting bed length (m)",
                          hintText: "Enter length in meters",
                          prefixIcon: Icon(
                            Icons.straighten,
                            color: Colors.green[600],
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 16.h),

                      // Plant distance input
                      TextField(
                        controller: controller.distanceController,
                        decoration: InputDecoration(
                          labelText: "Plant to plant distance (mm)",
                          hintText: "Enter distance in millimeters",
                          prefixIcon: Icon(
                            Icons.space_bar,
                            color: Colors.green[600],
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 24.h),

                      // Calculate the area and show estimated plants

                      SizedBox(height: 16.h),

                      // Success message
                      Obx(() => controller.isUpdateSuccessful.value
                          ? Container(
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
                            )
                          : const SizedBox()),
                    ],
                  ),
                ),
              ),

              // Error message display
              Obx(() => controller.errorMessage.isNotEmpty
                  ? Container(
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
                    )
                  : const SizedBox()),

              // Update button
              SizedBox(
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
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
