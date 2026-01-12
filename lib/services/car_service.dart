import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/car_model.dart';

class CarService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'cars';

  // Read - Get all cars
  Future<List<Car>> getCars() async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .orderBy('createdAt', descending: true)
          .get();
      
      return snapshot.docs.map<Car>((doc) => Car.fromFirestore(doc)).toList();
    } catch (e) {
      throw 'Error loading cars: $e';
    }
  }

  // Read - Get car by ID
  Future<Car?> getCarById(String carId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(carId).get();
      if (doc.exists) {
        return Car.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw 'Error loading car: $e';
    }
  }

  // Create - Add new car
  Future<void> addCar(Car car) async {
    try {
      await _firestore.collection(_collection).add(car.toMap());
    } catch (e) {
      throw 'Error adding car: $e';
    }
  }

  // Update - Update car
  Future<void> updateCar(String carId, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection(_collection).doc(carId).update(updates);
    } catch (e) {
      throw 'Error updating car: $e';
    }
  }

  // Delete - Delete car
  Future<void> deleteCar(String carId) async {
    try {
      await _firestore.collection(_collection).doc(carId).delete();
    } catch (e) {
      throw 'Error deleting car: $e';
    }
  }

  // Get available cars
  Future<List<Car>> getAvailableCars() async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('isAvailable', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();
      
      return snapshot.docs.map<Car>((doc) => Car.fromFirestore(doc)).toList();
    } catch (e) {
      throw 'Error loading available cars: $e';
    }
  }
}
