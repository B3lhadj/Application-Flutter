import 'package:cloud_firestore/cloud_firestore.dart';

class Car {
  final String id;
  final String name;
  final String brand;
  final String model;
  final int year;
  final double pricePerDay;
  final String imageUrl;
  final String description;
  final int seats;
  final String transmission;
  final String fuelType;
  final bool isAvailable;
  final DateTime createdAt;

  Car({
    required this.id,
    required this.name,
    required this.brand,
    required this.model,
    required this.year,
    required this.pricePerDay,
    required this.imageUrl,
    required this.description,
    required this.seats,
    required this.transmission,
    required this.fuelType,
    required this.isAvailable,
    required this.createdAt,
  });

  factory Car.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Car(
      id: doc.id,
      name: data['name'] ?? '',
      brand: data['brand'] ?? '',
      model: data['model'] ?? '',
      year: data['year'] ?? 2024,
      pricePerDay: (data['pricePerDay'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      description: data['description'] ?? '',
      seats: data['seats'] ?? 5,
      transmission: data['transmission'] ?? 'Automatic',
      fuelType: data['fuelType'] ?? 'Petrol',
      isAvailable: data['isAvailable'] ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'brand': brand,
      'model': model,
      'year': year,
      'pricePerDay': pricePerDay,
      'imageUrl': imageUrl,
      'description': description,
      'seats': seats,
      'transmission': transmission,
      'fuelType': fuelType,
      'isAvailable': isAvailable,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
