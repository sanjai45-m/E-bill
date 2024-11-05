import 'package:flutter/material.dart';

import '../models/vehicle.dart';
import '../view/e-ticket_screen.dart';
import '../view/history.dart';
import '../view/settings.dart';
import '../view/vehicles_management/vehicles_manage.dart';

class Drawers extends StatelessWidget {
  const Drawers({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage("assets/images/logos.png"),
                    radius: 40,
                  ),
                  SizedBox(height: 15),
                  Text(
                    "E-Bill Generator",
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: "Times New Roman",
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(
              icon: Icons.home,
              text: 'Home',
              onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => ETicketScreen()),
              ),
            ),
            _buildDrawerItem(
              icon: Icons.history,
              text: 'History',
              onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => StopwatchScreen(
                    vehicle: Vehicle(
                      name: '',
                      number: '',
                      phone: '',
                      vehicleType: '',
                      floor: '',
                      vehicleColor: '',
                      startingTime: '',
                    ),
                    selectedSpot: '',
                  ),
                ),
              ),
            ),
            _buildDrawerItem(
              icon: Icons.directions_car,
              text: 'Manage Vehicles',
              onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => VehicleManage()),
              ),
            ),
            _buildDrawerItem(
              icon: Icons.settings,
              text: 'Settings',
              onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Settings()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required GestureTapCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0), // Spacing adjustments for a balanced layout
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12), // Slightly larger radius for smoother corners
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15), // Softer shadow for a floating effect
              spreadRadius: 1,
              blurRadius: 6, // Increased blur for a subtle depth
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0), // Well-balanced padding
          leading: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blueAccent.withOpacity(0.1), // Light blue background for the icon container
            ),
            padding: EdgeInsets.all(8.0), // Icon container padding for consistency
            child: Icon(icon, size: 22, color: Colors.blueAccent), // Slightly reduced icon size
          ),
          title: Text(
            text,
            style: TextStyle(
              fontSize: 18, // Adjusted to a more readable size
              fontWeight: FontWeight.w600, // Medium weight for a modern appearance
              color: Colors.black87,
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey), // Added trailing arrow for better UX
        ),
      ),
    );
  }
}