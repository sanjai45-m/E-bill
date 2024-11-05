import 'dart:async';
import 'package:android_path_provider/android_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:image/image.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share_whatsapp/share_whatsapp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:e_bill/providers/vehicle_provider.dart';
import 'dart:io';

import '../app_widgets/drawer.dart';
import '../models/vehicle.dart';

class StopwatchScreen extends StatefulWidget {
  final Vehicle vehicle;
  final String selectedSpot;
  StopwatchScreen({required this.vehicle, required this.selectedSpot});
  @override
  _StopwatchScreenState createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  List<String> filledSpots = [];
  List<String> availableSpots = [];
  List<Map<String, dynamic>> filteredVehicles = [];
  final int parkingRate = 5;
// Default value
  DateTime? selectedDate;
  bool _isImageSaved = false;
  String? savedImagePath;
  double _totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _loadTimerState();
    _loadTotalAmount();
    _requestStoragePermission();
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

  Future<void> _loadTotalAmount() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _totalAmount =
          prefs.getDouble('totalAmount') ?? 0.0;
    });
  }

  Future<void> _storeTotalAmount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('totalAmount', _totalAmount);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final vehiclesProvider = Provider.of<VehicleProvider>(context);

    setState(() {
      filteredVehicles = vehiclesProvider.vehicles.map((vehicle) {
        return {
          "name": vehicle.name,
          "number": vehicle.number,
          "phone": vehicle.phone,
          "vehicleType": vehicle.vehicleType,
          "floor": vehicle.floor,
          "isRunning": false,
          "secondsElapsed": 0,
          "value": 0.0,
          "timer": null,
          "startingTime": vehicle.startingTime,
          "vehicleColor": vehicle.vehicleColor,
          "billGenerated": false,
          "hasGeneratedBill": false,
        };
      }).toList();
    });

    _updateTotalAmount();
  }

  Future<void> startTimer(int index) async {
    setState(() {
      filteredVehicles[index]["isRunning"] = true;
      filteredVehicles[index]["billGenerated"] = false;
      filteredVehicles[index]["startTime"] = DateTime.now();

      filteredVehicles[index]["timer"] =
          Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          filteredVehicles[index]["secondsElapsed"]++;
          if (filteredVehicles[index]["secondsElapsed"] % 60 == 0) {
            filteredVehicles[index]["value"] =
                (filteredVehicles[index]["secondsElapsed"] / 60) * parkingRate;
          }
          _updateTotalAmount();
        });
      });
    });
    await _saveTimerState();
  }


  Future<void> _stopTimer(int index) async {
    setState(() {
      filteredVehicles[index]["isRunning"] = false;
      filteredVehicles[index]["timer"]?.cancel();
      filteredVehicles[index]["startTime"] = null;

      filteredVehicles[index]["value"] =
          (filteredVehicles[index]["secondsElapsed"] / 60) * parkingRate;
      filteredVehicles[index]["billGenerated"] = true;


      Provider.of<VehicleProvider>(context, listen: false)
          .releaseSpot(widget.selectedSpot);

      _updateTotalAmount();
    });

    _saveTimerState();
  }

  void _updateTotalAmount() {
    double total = 0.0;
    for (var vehicle in filteredVehicles) {
      total += vehicle["value"] ?? 0.0;
    }
    setState(() {
      _totalAmount = total;
    });

    _storeTotalAmount();
  }

  void restoreTimerState() {
    for (var vehicle in filteredVehicles) {
      if (vehicle["isRunning"] == true && vehicle["startTime"] != null) {
        vehicle["timer"] = Timer.periodic(Duration(seconds: 1), (timer) {
          setState(() {
            vehicle["secondsElapsed"]++;
            if (vehicle["secondsElapsed"] % 60 == 0) {
              vehicle["value"] = (vehicle["secondsElapsed"] / 60) * parkingRate;
            }
            _updateTotalAmount();
          });
        });
      }
    }
  }

  int approximateTextWidth(String text) {
    const int characterWidth = 12;
    return text.length * characterWidth;
  }

  Future<img.Image> _loadLogo() async {
    final ByteData data = await rootBundle.load('assets/images/logos.png');
    final List<int> bytes = data.buffer.asUint8List();
    return img.decodeImage(Uint8List.fromList(bytes))!;
  }

  Future<void> _generateTicket(int index) async {
    if (index < 0 || index >= filteredVehicles.length) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Invalid vehicle index: $index'),
      ));
      return;
    }

    final vehicleName = filteredVehicles[index]["name"];
    final vehicleNumber = filteredVehicles[index]["number"];
    final ownerName = filteredVehicles[index]["phone"];
    final cost = filteredVehicles[index]["value"];
    final vehicleType = filteredVehicles[index]["vehicleType"]; // Updated
    final floor = filteredVehicles[index]["floor"];
    final vehicleColor = filteredVehicles[index]["vehicleColor"];
    final startingTime = filteredVehicles[index]["startingTime"];

    String dateString = selectedDate != null
        ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
        : '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}';

    img.Image ticketImage = img.Image(width: 600, height: 1200);
    img.fill(ticketImage, color: img.ColorRgb8(255, 255, 255));

    // Load logo
    img.Image logo = await _loadLogo();
    int logoHeight = 100;
    int logoWidth = (logo.width * logoHeight) ~/ logo.height;
    img.compositeImage(
      ticketImage,
      logo,
      dstX: (ticketImage.width - logoWidth) ~/ 2,
      dstY: 20,
      dstH: logoHeight,
      dstW: logoWidth,
    );

    // Labels and Values
    int logoBottomY = 40 + logoHeight;
    int startY = logoBottomY + 90;
    int lineHeight = 70;
    int labelX = 80;
    int valueX = 350;

    List<String> labels = [
      'Vehicle Name',
      'Vehicle Number',
      'Phone Number',
      'Vehicle Type', // Updated label
      'Floor',
      'Date',
      "Vehicle Color",
      "Starting Time",
      'Cost',
    ];

    String titleText = "E-parking Bill";
    int titleYPosition =
        startY - lineHeight - 20;

    img.drawString(
      ticketImage,
      font: arial48,
      x: (ticketImage.width - approximateTextWidth(titleText)) ~/ 2.5,
      y: titleYPosition + 10,
      titleText,
      color: img.ColorRgb8(0, 0, 0),
    );

    int extraSpace = 30;
    startY += extraSpace;

    List<String> values = [
      vehicleName,
      vehicleNumber,
      ownerName,
      vehicleType, // Use the updated vehicleType
      floor,
      dateString,
      vehicleColor,
      startingTime,
      '${cost.toStringAsFixed(2)}', // Format cost as currency
    ];

    for (int i = 0; i < labels.length; i++) {
      img.drawString(
        ticketImage,
        font: arial24,
        x: labelX,
        y: startY + (i * lineHeight),
        labels[i],
        color: img.ColorRgb8(128, 128, 128),
      );

      img.drawString(
        ticketImage,
        font: arial24,
        x: valueX,
        y: startY + (i * lineHeight),
        values[i],
        color: img.ColorRgb8(0, 0, 0),
      );
    }

    img.Image vehicleImage;
    if (vehicleType == "Car") {
      vehicleImage = await _loadCarImage();
    } else {
      vehicleImage = await _loadBikeImage();
    }
    int vehicleImageHeight = 150;
    int vehicleImageWidth =
        (vehicleImage.width * vehicleImageHeight) ~/ vehicleImage.height;

    int imageYPosition = startY +
        (labels.length * lineHeight) +
        20;
    img.compositeImage(
      ticketImage,
      vehicleImage,
      dstX: (ticketImage.width - vehicleImageWidth) ~/ 2,
      dstY: imageYPosition,
      dstH: vehicleImageHeight,
      dstW: vehicleImageWidth,
    );

    String noteText =
        "Note: The initial parking charge is 50/-, and the fee doubles for each additional hour.";
    int noteYPosition =
        imageYPosition + vehicleImageHeight + 30;

    img.drawString(
      ticketImage,
      font: arial14,
      x: 20, // Left-aligned note
      y: noteYPosition,
      noteText,
      color: img.ColorRgb8(0, 0, 0),
    );

    await _saveImage(ticketImage, ownerName);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Ticket saved to ${ownerName}.png'),
    ));

    await Future.delayed(Duration(seconds: 2));

    setState(() {
      filteredVehicles[index]["billGenerated"] = true;
      filteredVehicles[index]["hasGeneratedBill"] =
          true;
    });
  }

  Future<img.Image> _loadCarImage() async {
    ByteData data = await rootBundle.load('assets/images/car.png');
    List<int> bytes = data.buffer.asUint8List();
    print('Car image loaded: ${bytes.length} bytes'); // Debug line
    return img.decodeImage(Uint8List.fromList(bytes))!;
  }

  Future<img.Image> _loadBikeImage() async {
    ByteData data = await rootBundle.load('assets/images/bike.png');
    List<int> bytes = data.buffer.asUint8List();
    print('Bike image loaded: ${bytes.length} bytes'); // Debug line
    return img.decodeImage(Uint8List.fromList(bytes))!;
  }

  Future<void> _saveImage(img.Image image, String ownerPhone) async {
    if (await Permission.storage.request().isGranted) {
      Uint8List pngBytes = Uint8List.fromList(img.encodePng(image));

      String? path = await AndroidPathProvider.picturesPath;


      String filePath = '$path/$ownerPhone.png';

      File imgFile = File(filePath);
      await imgFile.writeAsBytes(pngBytes);

      setState(() {
        _isImageSaved = true;
        savedImagePath = filePath;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Ticket saved to $filePath'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Storage permission denied'),
      ));
    }
  }

  Future<void> _shareBillViaWhatsApp(int index) async {
    final String phoneNumber = filteredVehicles[index]["phone"];
    final String message =
        "Parking Bill: \₹${filteredVehicles[index]["value"].toStringAsFixed(2)} for vehicle ${filteredVehicles[index]["number"]}";
    final url = "https://wa.me/$phoneNumber?text=$message";

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _shareTicket(int index) async {
    if (savedImagePath != null) {
      final phoneNumber = filteredVehicles[index]["phone"];
      XFile imageFile = XFile(savedImagePath!);

      await ShareWhatsapp().shareFile(
        imageFile,
        phone: phoneNumber,
        type: WhatsApp.standard,
      );
    }
  }

  Future<void> _saveTimerState() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < filteredVehicles.length; i++) {
      prefs.setBool('isRunning_$i', filteredVehicles[i]["isRunning"]);
      prefs.setInt('secondsElapsed_$i', filteredVehicles[i]["secondsElapsed"]);
      prefs.setDouble('value_$i', filteredVehicles[i]["value"]);
      prefs.setBool('billGenerated_$i',
          filteredVehicles[i]["billGenerated"]);
      prefs.setString('startTime_$i',
          filteredVehicles[i]["startTime"]?.toIso8601String() ?? '');
    }
  }

  Future<void> _loadTimerState() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < filteredVehicles.length; i++) {
      bool isRunning = prefs.getBool('isRunning_$i') ?? false;
      int secondsElapsed = prefs.getInt('secondsElapsed_$i') ?? 0;
      double value = prefs.getDouble('value_$i') ?? 0;
      bool billGenerated = prefs.getBool('billGenerated_$i') ??
          false;
      String startTimeString = prefs.getString('startTime_$i') ?? '';

      if (startTimeString.isNotEmpty && isRunning) {
        DateTime startTime = DateTime.parse(startTimeString);
        int elapsed = DateTime.now().difference(startTime).inSeconds;
        secondsElapsed += elapsed;
        value = (secondsElapsed / 60) * parkingRate;
      }

      setState(() {
        filteredVehicles[i]["isRunning"] = isRunning;
        filteredVehicles[i]["secondsElapsed"] = secondsElapsed;
        filteredVehicles[i]["value"] = value;
        filteredVehicles[i]["billGenerated"] =
            billGenerated; // Restore bill generated state
        if (isRunning) {
          startTimer(i);
        }
      });
    }
  }

  void _filterVehicles(String query) {
    final vehiclesProvider = Provider.of<VehicleProvider>(context, listen: false);

    final allVehicles = vehiclesProvider.vehicles.map((vehicle) {
      return {
        "name": vehicle.name,
        "number": vehicle.number,
        "phone": vehicle.phone,
        "vehicleType": vehicle.vehicleType,
        "floor": vehicle.floor,
        "isRunning": false,
        "secondsElapsed": 0,
        "value": 0.0,
        "timer": null,
      };
    }).toList();

    setState(() {
      if (query.isNotEmpty) {
        filteredVehicles = allVehicles.where((vehicle) {
          final number = vehicle["number"] as String?;
          final phone = vehicle["phone"] as String?;
          return (number != null && number.toLowerCase().contains(query.toLowerCase())) ||
              (phone != null && phone.toLowerCase().contains(query.toLowerCase()));
        }).toList();
      } else {
        filteredVehicles = allVehicles;
      }
    });
  }


  @override
  void dispose() {
    filteredVehicles.forEach((vehicle) {
      vehicle["timer"]?.cancel();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawers(),
      appBar: AppBar(
        title: const Text(
          'Parking Timer ',
        ),
          centerTitle: true
      ),
      body: Column(
        children: [
          // Display total amount at the top
          Container(
            margin: EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              color: Colors.blue.withOpacity(0.3),
            ),
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Total Amount: ₹${_totalAmount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          // Search Bar
          Container(
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.008,
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by phone number or vehicle number...',
                filled: true,
                fillColor: Colors.grey.withOpacity(0.3),
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: _filterVehicles,
            ),
          ),

          Expanded(
            child: filteredVehicles == null || filteredVehicles.isEmpty
                ? Center(
              child: Text(
                'List is empty',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey[700],
                ),
              ),
            )
                : ListView.builder(
              itemCount: filteredVehicles.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            filteredVehicles[index]["name"] ?? '',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Number: ${filteredVehicles[index]["number"] ?? ''}",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(
                            "Phone: ${filteredVehicles[index]["phone"] ?? ''}",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 10,
                                      offset: Offset(2, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  _formatTime(
                                    filteredVehicles[index]["secondsElapsed"] ?? 0,
                                  ),
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontFamily: 'Courier',
                                    color: Colors.greenAccent,
                                    letterSpacing: 4.0,
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    filteredVehicles[index]["floor"] ?? '',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Cost: ₹${filteredVehicles[index]["value"]?.toStringAsFixed(2) ?? "0.00"}',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  if (filteredVehicles[index]["hasGeneratedBill"])
                                    ElevatedButton(
                                      onPressed: () => _shareTicket(index),
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white, backgroundColor: Colors.blue ,
                                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),// Padding
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12), // Rounded corners
                                        ),
                                        elevation: 5, // Shadow effect
                                      ),
                                      child: Text(
                                        'Share E-Bill',
                                        style: TextStyle(
                                          fontSize: 16, // Text size
                                          fontWeight: FontWeight.bold, // Text weight
                                        ),
                                      ),
                                    ),
                                  SizedBox(height: 10),
                                  if (filteredVehicles[index]["hasGeneratedBill"])
                                  ElevatedButton(
                                    onPressed: () => _shareBillViaWhatsApp(index),
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white, backgroundColor: Colors.green, // Text color
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10), // Padding
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 5,
                                    ),
                                    child: Text(
                                      'Share via WhatsApp',
                                      style: TextStyle(
                                        fontSize: 14, // Text size
                                        fontWeight: FontWeight.bold, // Text weight
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 10),

                          if (filteredVehicles[index]["isRunning"] == true)
                            ElevatedButton(
                              onPressed: () => _stopTimer(index),
                              child: Text('Stop Timer'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 15),
                              ),
                            )
                          else if (!filteredVehicles[index]["isRunning"] && !filteredVehicles[index]["billGenerated"])
                            ElevatedButton(
                              onPressed: () => startTimer(index),
                              child: Text('Start Timer'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 15),
                              ),
                            )
                          else if (!filteredVehicles[index]["isRunning"] && filteredVehicles[index]["billGenerated"])
                              ElevatedButton(
                                onPressed: () => _generateTicket(index),
                                child: Text('Generate Bill'),
                              ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

        ],
      ),
    );
  }
}

String _formatTime(int seconds) {
  int minutes = seconds ~/ 60;
  int displaySeconds = seconds % 60;
  return '${minutes.toString().padLeft(2, '0')}:${displaySeconds.toString().padLeft(2, '0')}';
}
