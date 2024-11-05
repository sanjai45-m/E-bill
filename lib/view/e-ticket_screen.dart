import 'package:e_bill/api_model/vehicle_api.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:e_bill/app_widgets/widgets_and_data.dart';
import 'package:e_bill/app_widgets/drawer.dart';
import 'package:e_bill/app_widgets/vehicle_data.dart';
import 'package:e_bill/view/history.dart';
import 'package:e_bill/providers/vehicle_provider.dart';
import '../models/vehicle.dart'; 

class ETicketScreen extends StatefulWidget {
  @override
  _ETicketScreenState createState() => _ETicketScreenState();
}

class _ETicketScreenState extends State<ETicketScreen>
    with SingleTickerProviderStateMixin {
  VehicleData vehicleData = new VehicleData();
  String? selectedFloor;
  String? selectedSection;
  String? selectedRow;
  String? selectedSpot;
  String dropdownValue = 'Floor, Section, and Spot'; // Declare here
  final VehicleApi data = VehicleApi();

  String? selectedVehicleType;
  String? selectedModel;
  String vehicleTypeError = '';
  String modelError = '';
  String floorError = '';
  final List<String> floors = ['Ground', '1st Floor', '2nd Floor'];
  final List<String> groundSections = ['G1', 'G2', 'G3'];
  final List<String> firstAndSecondSections = ['A', 'B', 'C'];
  final List<String> initialSpots =
      List.generate(10, (index) => (index + 1).toString().padLeft(2, '0'));

  List<String> availableSpots = [];
  List<String> filledSpots = [];

  List<String> generatedTickets = [];
  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    vehicleData.currentTime = DateFormat('hh:mm a').format(now);
    vehicleData.animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    availableSpots = Provider.of<VehicleProvider>(context, listen: false)
        .availableSpots; // Get available spots
    _requestStoragePermission();
    data.fetchVehicles();
  }

  Future<void> _requestStoragePermission() async {
    PermissionStatus status = await Permission.storage.status;

    if (!status.isGranted) {
      await Permission.storage.request();
    }

    if (await Permission.manageExternalStorage.isPermanentlyDenied) {
      await Permission.manageExternalStorage.request();
    }
  }

  Future<void> _generateTicket() async {
    if (vehicleData.formKey.currentState!.validate()) {
      try {
        if (selectedSpot == null ||
            filledSpots.contains(selectedSpot) ||
            selectedSection == null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Selected spot is not available. Please choose a different spot.'),
          ));
          return;
        }

        final vehicleNumber = vehicleData.vehicleNumberController.text;
        final vehicleColor = vehicleData.vehicleColorController.text;
        final ownerName = vehicleData.phoneController.text;

        // Create vehicle object to pass
        Vehicle newVehicle = Vehicle(
          name: selectedModel!,
          number: vehicleNumber,
          phone: ownerName,
          vehicleType: selectedVehicleType!,
          floor: dropdownValue,
          startingTime: vehicleData.currentTime,
          vehicleColor: vehicleColor,
        );

        Provider.of<VehicleProvider>(context, listen: false).addVehicle(
          newVehicle.name,
          newVehicle.number,
          newVehicle.phone,
          newVehicle.vehicleType,
          newVehicle.floor,
          newVehicle.startingTime,
          newVehicle.vehicleColor,
        );

        // Navigate to StopwatchScreen with the new vehicle data
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => StopwatchScreen(
            vehicle: newVehicle,
            selectedSpot: '$selectedSection-$selectedSpot',
          ),
        ));

        Provider.of<VehicleProvider>(context, listen: false)
            .bookSpot('$selectedSection-$selectedSpot');

        _resetForm();
      } catch (e) {
        print("Error during ticket generation: $e");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error generating ticket: $e'),
        ));
      }
    }
  }

  @override
  void dispose() {
    vehicleData.animationController.dispose();
    super.dispose();
  }

  void _resetForm() {
    setState(() {

      vehicleData.vehicleNameController.clear();
      vehicleData.vehicleNumberController.clear();
      vehicleData.vehicleColorController.clear();
      vehicleData.phoneController.clear(); 
      selectedVehicleType = null;
      selectedModel=null;

      vehicleData.setSelectedVehicleType(VehicleType.bike); // Reset to default
      vehicleData.selectedVehicleName = null;
      vehicleData.selectedDate = null;
      vehicleData.isImageSaved = false;
       vehicleTypeError='';

      selectedFloor = null;
      selectedSection = null;
      selectedSpot = null;


      dropdownValue = 'Floor, Section, and Spot';
    });
  }

  void _showSectionsAndSpots() {
    if (selectedFloor == null) return;

    List<String> sections =
        selectedFloor == 'Ground' ? groundSections : firstAndSecondSections;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Section and Spot for $selectedFloor'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: sections.map((section) {
                return ExpansionTile(
                  title: Text(section),
                  children: List.generate(initialSpots.length, (index) {
                    String spot = initialSpots[index];
                    String uniqueSpotKey =
                        '$section-$spot';

                    return ListTile(
                      title: Text('Row 1 - Spot $spot'),
                      leading: Icon(
                        filledSpots.contains(uniqueSpotKey)
                            ? Icons.circle
                            : Icons.circle_outlined,
                        color: filledSpots.contains(uniqueSpotKey)
                            ? Colors.red
                            : Colors.green,
                      ),
                      onTap: () {
                        if (!filledSpots.contains(uniqueSpotKey)) {
                          setState(() {
                            selectedSection = section;
                            selectedRow = '1';
                            selectedSpot = spot;
                          });
                          Navigator.of(context).pop();


                          filledSpots.add(uniqueSpotKey);
                        }
                      },
                    );
                  }),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    dropdownValue = (selectedFloor != null &&
            selectedSection != null &&
            selectedSpot != null)
        ? '${selectedFloor!}-${selectedSection!}-${selectedSpot!}'
        : 'Floor, Section, and Spot';

    return Scaffold(
      drawer: Drawers(),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: _resetForm,
            icon: Icon(
              Icons.lock_reset_outlined,
              size: 30,
            ),
          )
        ],

        elevation: 0,

      ),
      body: Stack(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: MediaQuery.of(context).size.height * 0.02,
              ),
              child: Form(
                key: vehicleData.formKey,
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        // Title
                        Row(
                          children: [
                            Image.asset(
                              "assets/images/logos.png",
                              height: 50,
                              width: 50,
                            ),
                            Text(
                              ' -  Parking Bill Generator',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF004EA3),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),

                        // Vehicle Type Dropdown
                        Container(
                          height: 56,
                          child: CustomDropdowns(
                            value: selectedVehicleType,
                            items: ['Bike', 'Car'],
                            hint: 'Select Vehicle Type',
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedVehicleType = newValue;
                                vehicleTypeError = ''; // Clear error
                                selectedModel = null;
                              });
                            },
                          ),
                        ),

                        if (vehicleTypeError.isNotEmpty)
                          Text(vehicleTypeError,
                              style: TextStyle(color: Colors.red)),
                        SizedBox(height: 16),


                        Container(
                          height: 56,
                          child: FutureBuilder(
                            future: data.fetchVehicles(),
                            builder: (context, snapshot) {
                              return CustomDropdown(
                                value: selectedModel,
                                items: snapshot.connectionState ==
                                        ConnectionState.waiting
                                    ? []
                                    : data.vehicles
                                        .where((vehicle) =>
                                            vehicle.vehicleType ==
                                            selectedVehicleType)
                                        .map((vehicle) => vehicle.name)
                                        .toList(),
                                hint: snapshot.connectionState ==
                                        ConnectionState.waiting
                                    ? 'Loading...'
                                    : 'Select Model',
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedModel = newValue;
                                    modelError = ''; // Clear error
                                  });
                                },
                              );
                            },
                          ),
                        ),

                        if (modelError.isNotEmpty)
                          Text(modelError, style: TextStyle(color: Colors.red)),
                        SizedBox(height: 16),


                        Container(
                          height: 56,
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF004EA3)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: PopupMenuButton<String>(
                            onSelected: (value) {
                              setState(() {
                                selectedFloor = value;
                                selectedSection =
                                null;
                                selectedSpot = null;
                              });
                              _showSectionsAndSpots();
                            },
                            child: ListTile(
                              title: Text(dropdownValue.isEmpty
                                  ? 'Select Floor'
                                  : dropdownValue),
                              trailing: Icon(Icons.arrow_drop_down),
                            ),
                            itemBuilder: (BuildContext context) {
                              return vehicleData.floors.map((String floor) {
                                return PopupMenuItem<String>(
                                  value: floor,
                                  child: Text(floor),
                                );
                              }).toList();
                            },
                          ),
                        ),
                        // Error hint for floor
                        if (floorError.isNotEmpty)
                          Text(floorError, style: TextStyle(color: Colors.red)),
                        SizedBox(height: 16),

                        // Vehicle Number
                        TextFormField(
                          controller: vehicleData.vehicleNumberController,
                          decoration: InputDecoration(
                            labelText: 'Vehicle Number',
                            counterText: "",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFF004EA3), width: 1.0),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFF004EA3), width: 2.0),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter vehicle number';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),


                        TextFormField(
                          controller: vehicleData.vehicleColorController,
                          decoration: InputDecoration(
                            labelText: 'Vehicle Color',
                            counterText: "",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFF004EA3), width: 1.0),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFF004EA3), width: 2.0),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter vehicle color';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),

                        // Phone Number
                        TextFormField(
                          controller: vehicleData.phoneController,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            counterText: "",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFF004EA3), width: 1.0),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFF004EA3), width: 2.0),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length != 10) {
                              return 'Enter a valid 10-digit phone number';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),

                        ElevatedButton(
                          onPressed: () {
                            // Reset error messages
                            setState(() {
                              vehicleTypeError = '';
                              modelError = '';
                              floorError = '';
                            });


                            if (selectedVehicleType == null) {
                              setState(() {
                                vehicleTypeError = 'Please select vehicle type';
                              });
                            }
                            if (selectedModel == null) {
                              setState(() {
                                modelError = 'Please select vehicle model';
                              });
                            }
                            if (selectedFloor == null) {
                              setState(() {
                                floorError = 'Please select floor';
                              });
                            }


                            if (vehicleData.formKey.currentState!.validate() &&
                                selectedVehicleType != null &&
                                selectedModel != null &&
                                selectedFloor != null) {
                              _generateTicket();
                            }
                          },
                          child: Text(
                            'Generate Ticket',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF004EA3),
                            padding: EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 24,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5,
                          ),
                        ),

                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


