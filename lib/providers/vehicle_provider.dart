import 'package:flutter/material.dart';

import '../models/vehicle.dart';


class VehicleProvider with ChangeNotifier {
  List<Vehicle> _vehicles = [];
  List<String> availableSpots = [];
  List<String> filledSpots = [];
  List<Vehicle> get vehicles => _vehicles;

  void addVehicle(String name, String number, String phone, String vehicleType,
      String floor, String startingTime, String vehicleColor) {
    _vehicles.add(Vehicle(
        name: name,
        number: number,
        phone: phone,
        vehicleType: vehicleType,
        floor: floor,
        startingTime: startingTime,
        vehicleColor: vehicleColor));
    notifyListeners(); // Notify listeners to update the UI
  }

  VehicleProvider() {
    // Initialize with all available spots
    availableSpots = List.generate(10, (index) => 'Spot ${index + 1}');
  }

  void bookSpot(String spot) {
    if (availableSpots.contains(spot)) {
      filledSpots.add(spot);
      availableSpots.remove(spot);
      notifyListeners(); // Notify UI to update
    }
  }

  void releaseSpot(String spot) {
    if (filledSpots.contains(spot)) {
      availableSpots.add(spot);
      filledSpots.remove(spot);
      notifyListeners(); // Notify UI to update
    }
  }

  bool isSpotAvailable(String spot) {
    return availableSpots.contains(spot);
  }

  void removeVehicle(int index) {
    if (index >= 0 && index < _vehicles.length) {
      _vehicles.removeAt(index);
      notifyListeners();  // Notify the UI about the vehicle removal
    }
  }

}


