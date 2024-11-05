class VehicleTypeData {
  final int id;
  final String name;
  final String vehicleType;

  VehicleTypeData({required this.id, required this.name, required this.vehicleType});

  factory VehicleTypeData.fromJson(Map<String, dynamic> json) {
    return VehicleTypeData(
      id: json['id'],
      name: json['name'],
      vehicleType: json['vehicleType'],
    ); 
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'vehicleType': vehicleType,
    };
  }
  // Copy method
  VehicleTypeData copyWith({int? id, String? name, String? vehicleType}) {
    return VehicleTypeData(
      id: id ?? this.id,
      name: name ?? this.name,
      vehicleType: vehicleType ?? this.vehicleType,
    );
  }
}
