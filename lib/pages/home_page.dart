import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/home_controller.dart';
import '../widgets/bed_info_form.dart';
import '../widgets/update_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Instantiate the controller using GetX dependency injection.
  static final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cloud Krushinath",
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2E7D32),
      ),
      bottomNavigationBar: const UpdateButton(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade50, Colors.green.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(),
                  SizedBox(height: 20.h),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 3,
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: SingleChildScrollView(child: const BedInfoForm()),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  _buildStatusMessages(),
                  SizedBox(height: 16.h),
                  _buildSheetParameters(),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          Icons.agriculture,
          size: 28.sp,
          color: const Color(0xFF2E7D32),
        ),
        SizedBox(width: 12.w),
        Text(
          "Plan Your Field",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2E7D32),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusMessages() {
    return Obx(() {
      if (controller.errorMessage.isNotEmpty) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.red[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.red[200]!),
          ),
          child: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red[700], size: 24.sp),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  controller.errorMessage.value,
                  style: TextStyle(
                    color: Colors.red[800],
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
        );
      } else if (controller.isUpdateSuccessful.value) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green[200]!),
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green[700], size: 24.sp),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  "Data successfully updated to cloud!",
                  style: TextStyle(
                    color: Colors.green[800],
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return SizedBox.shrink();
      }
    });
  }

  Widget _buildSheetParameters() {
    return Obx(() {
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 3,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.analytics_outlined,
                      size: 24.sp, color: Colors.blue[700]),
                  SizedBox(width: 8.w),
                  Text(
                    "Field Parameters",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[700],
                    ),
                  ),
                ],
              ),
              Divider(height: 24, thickness: 1),
              ParameterCard(
                icon: Icons.speed_outlined,
                label: "Tractor speed",
                value: "${controller.cellB14.value} kmph",
              ),
              ParameterCard(
                icon: Icons.timer_outlined,
                label: "Time to complete task",
                value: "${controller.cellK14.value} sec",
              ),
              ParameterCard(
                icon: Icons.grass_outlined,
                label: "Time to sow 1 sapling",
                value: "${controller.cellN14.value} sec",
              ),
              ParameterCard(
                icon: Icons.grid_4x4_outlined,
                label: "Time to sow complete tray",
                value: "${controller.cellO14.value} sec",
              ),
              ParameterCard(
                icon: Icons.eco_outlined,
                label: "Saplings per acre",
                value: "${controller.cellP14.value}",
              ),
              ParameterCard(
                icon: Icons.access_time_filled_outlined,
                label: "Planting time per acre",
                value: "${controller.cellQ14.value} min",
                isLast: true,
              ),
            ],
          ),
        ),
      );
    });
  }
}

class ParameterCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLast;

  const ParameterCard({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.blue[700], size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
