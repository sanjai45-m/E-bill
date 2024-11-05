class Vehicle {
  String name;
  String number;
  String phone;
  Duration elapsedTime; // Duration instead of seconds for easier time handling
  double value;
  bool isRunning;
  String startingTime;
  String vehicleColor;
  DateTime? startTime; // Nullable to indicate that it may not be set
  String vehicleType;
  String floor;

  Vehicle({
    required this.name,
    required this.number,
    required this.phone,
    this.elapsedTime = Duration.zero,
    this.value = 0.0,
    this.isRunning = false,
    this.startTime,
    required this.vehicleType,
    required this.floor,required this.vehicleColor,required this.startingTime
  });

  // Method to start the timer
  void startTimer() {
    isRunning = true;
    startTime = DateTime.now();
  }

  // Method to stop the timer
  void stopTimer() {
    isRunning = false;
    if (startTime != null) {
      elapsedTime += DateTime.now().difference(startTime!);
      startTime = null;
    }
  }


  int getTotalElapsedSeconds() {
    return elapsedTime.inSeconds + (isRunning ? DateTime.now().difference(startTime!).inSeconds : 0);
  }

  // Method to calculate cost
  double calculateCost(int parkingRate) {
    return (getTotalElapsedSeconds() / 60) * parkingRate;
  }
}
