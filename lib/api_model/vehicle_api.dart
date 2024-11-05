import 'dart:convert';
import 'package:e_bill/models/vehicles_type_data.dart';
import 'package:http/http.dart' as http;

class VehicleApi {
  final String baseUrl = 'https://parking-bill-50022835740.development.catalystappsail.in/vehicles'; // Update with your IP address

  List<VehicleTypeData> vehicles = [];

  Future<void> fetchVehicles() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      vehicles = jsonResponse.map((vehicle) => VehicleTypeData.fromJson(vehicle)).toList();
    } else {
      throw Exception('Failed to load vehicles');
    }
  }

  Future<void> addVehicle(VehicleTypeData vehicle) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(vehicle.toJson()), // Ensure to use the correct method
    );

    print('Response status: ${response.statusCode}'); // Debugging line
    print('Response body: ${response.body}'); // Debugging line

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add vehicle: ${response.body}'); // Include body for more context
    }
    await fetchVehicles(); // Refresh the vehicle list
  }



  Future<void> editVehicle(VehicleTypeData vehicle) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${vehicle.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(vehicle.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to edit vehicle');
    }
    await fetchVehicles(); // Refresh the vehicle list
  }

  Future<void> deleteVehicle(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete vehicle');
    }
    await fetchVehicles(); // Refresh the vehicle list
  }
}
