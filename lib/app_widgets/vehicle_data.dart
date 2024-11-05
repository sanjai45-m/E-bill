import 'package:flutter/material.dart';

import 'widgets_and_data.dart';

class VehicleData {
  VehicleType _selectedVehicleType = VehicleType.bike; // Default value
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late AnimationController animationController;
  TextEditingController vehicleNameController = TextEditingController();
  TextEditingController vehicleNumberController = TextEditingController();
  TextEditingController vehicleColorController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  DateTime? selectedDate;
  String currentTime = '';
  int initialAmount = 30;
  bool isImageSaved = false; // Track image saving state
  String? savedImagePath; // Store saved image path
  String searchQuery = '';
  List<String> vehicleNames = [];
  String? selectedVehicleName;
  String? selectedFloor;
  String? selectedSection;
  String? selectedSpot;
  List<String> filledSpots = [];

  final List<String> floors = ['Ground', '1st Floor', '2nd Floor'];
  final List<String> groundSections = ['G1', 'G2', 'G3'];
  final List<String> firstAndSecondSections = ['A', 'B', 'C'];
  final List<String> initialSpots =
      List.generate(10, (index) => (index + 1).toString().padLeft(2, '0'));

  VehicleType get selectedVehicleType => _selectedVehicleType;

  void setSelectedVehicleType(VehicleType vehicleType) {
    _selectedVehicleType = vehicleType;
  }
}
