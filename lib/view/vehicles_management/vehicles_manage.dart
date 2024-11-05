import 'package:e_bill/api_model/vehicle_api.dart';
import 'package:e_bill/app_widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:e_bill/models/vehicles_type_data.dart';

class VehicleManage extends StatefulWidget {
  const VehicleManage({super.key});

  @override
  _VehicleManageState createState() => _VehicleManageState();
}

class _VehicleManageState extends State<VehicleManage> {
  final VehicleApi data = VehicleApi();

  @override
  void initState() {
    super.initState();
    data.fetchVehicles(); // Fetch data when the widget is initialized
  }

  // Method to show a dialog for adding or editing a vehicle
  Future<void> _showVehicleDialog({VehicleTypeData? vehicle}) async {
    final isEditing = vehicle != null;
    final nameController = TextEditingController(text: isEditing ? vehicle.name : '');
    String selectedVehicleType = isEditing ? vehicle.vehicleType : 'Car'; // Default to 'Car'

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners for a modern look
          ),
          title: Text(
            isEditing ? 'Edit Vehicle' : 'Add Vehicle',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent, // Accent color for title
            ),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start, // Align content to the left
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Vehicle Name',
                      labelStyle: TextStyle(color: Colors.blueAccent),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10), // Rounded border
                        borderSide: BorderSide(color: Colors.blueAccent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                      ),
                    ),
                  ),
                  SizedBox(height: 20), // Increased spacing
                  DropdownButtonFormField<String>(
                    value: selectedVehicleType,
                    decoration: InputDecoration(
                      labelText: 'Vehicle Type',
                      labelStyle: TextStyle(color: Colors.blueAccent),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blueAccent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                      ),
                    ),
                    items: <String>['Car', 'Bike']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedVehicleType = newValue!; // Update selected vehicle type
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (isEditing) {
                  // Edit existing vehicle
                  VehicleTypeData updatedVehicle = vehicle.copyWith(
                    name: nameController.text, // Update the name
                    vehicleType: selectedVehicleType, // Update vehicle type
                  );
                  data.editVehicle(updatedVehicle).then((_) {
                    if (mounted) { // Check if the widget is still mounted
                      setState(() {}); // Refresh the list
                    }
                    Navigator.of(context).pop(); // Close the dialog
                  });
                } else {
                  // Add new vehicle
                  VehicleTypeData newVehicle = VehicleTypeData(
                    id: 0, // Placeholder ID, assuming the server will assign a real one
                    name: nameController.text,
                    vehicleType: selectedVehicleType, // Use the selected vehicle type
                  );
                  data.addVehicle(newVehicle).then((_) {
                    if (mounted) { // Check if the widget is still mounted
                      setState(() {}); // Refresh the list
                    }
                    Navigator.of(context).pop(); // Close the dialog
                  });
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.blueAccent, // Button color
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                isEditing ? 'Edit' : 'Add',
                style: TextStyle(
                  color: Colors.white, // Button text color
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // If you have any timers or listeners, be sure to cancel them here
    super.dispose();
  }


  // Method to handle delete action
  void _deleteVehicle(int id) {
    data.deleteVehicle(id).then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        drawer: Drawers(),
        appBar: AppBar(
          title: Text('Vehicle Management', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.blueAccent,
            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            tabs: [
              Tab(child: Text("Bike")),
              Tab(child: Text("Car")),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TabBarView(
            children: [
              // Bike tab content
              FutureBuilder(
                future: data.fetchVehicles(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final bikeVehicles = data.vehicles.where((vehicle) => vehicle.vehicleType == 'Bike').toList();

                  return ListView.builder(
                    itemCount: bikeVehicles.length,
                    itemBuilder: (context, index) {
                      final bike = bikeVehicles[index];
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(bike.name, style: TextStyle(fontWeight: FontWeight.w500)),
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _showVehicleDialog(vehicle: bike),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete_outline, color: Colors.red),
                                  onPressed: () => _deleteVehicle(bike.id),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              // Car tab content
              FutureBuilder(
                future: data.fetchVehicles(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final carVehicles = data.vehicles.where((vehicle) => vehicle.vehicleType == 'Car').toList();

                  return ListView.builder(
                    itemCount: carVehicles.length,
                    itemBuilder: (context, index) {
                      final car = carVehicles[index];
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(car.name, style: TextStyle(fontWeight: FontWeight.w500)),
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _showVehicleDialog(vehicle: car),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete_outline, color: Colors.red),
                                  onPressed: () => _deleteVehicle(car.id),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showVehicleDialog(),
          child: Icon(Icons.add, size: 30),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }
}
