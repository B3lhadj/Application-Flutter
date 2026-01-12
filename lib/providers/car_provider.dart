import 'package:flutter/material.dart';
import '../models/car_model.dart';
import '../services/car_service.dart';

class CarProvider extends ChangeNotifier {
  final CarService _carService = CarService();
  List<Car> _cars = [];
  bool _isLoading = false;

  List<Car> get cars => _cars;
  bool get isLoading => _isLoading;

  Future<void> loadCars() async {
    _isLoading = true;
    notifyListeners();

    try {
      _cars = await _carService.getCars();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<Car?> getCarById(String carId) async {
    return await _carService.getCarById(carId);
  }

  Future<void> addCar(Car car) async {
    await _carService.addCar(car);
    await loadCars();
  }

  Future<void> updateCar(String carId, Map<String, dynamic> updates) async {
    await _carService.updateCar(carId, updates);
    await loadCars();
  }

  Future<void> deleteCar(String carId) async {
    await _carService.deleteCar(carId);
    await loadCars();
  }

  List<Car> searchCars(String query) {
    if (query.isEmpty) return _cars;
    
    final lowercaseQuery = query.toLowerCase();
    return _cars.where((car) {
      return car.name.toLowerCase().contains(lowercaseQuery) ||
          car.brand.toLowerCase().contains(lowercaseQuery) ||
          car.model.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  List<Car> getAvailableCars() {
    return _cars.where((car) => car.isAvailable).toList();
  }

  Future<void> addDemoCars() async {
    final demoCars = [
      Car(
        id: '',
        name: 'Model S Plaid',
        brand: 'Tesla',
        model: 'Plaid',
        year: 2024,
        pricePerDay: 299,
        imageUrl: 'https://images.unsplash.com/photo-1617788138017-80ad40651399?auto=format&fit=crop&w=800&q=80',
        description: 'Experience the fastest electric sedan with Autopilot.',
        seats: 5,
        transmission: 'Automatic',
        fuelType: 'Electric',
        isAvailable: true,
        createdAt: DateTime.now(),
      ),
      Car(
        id: '',
        name: 'GT-R Nismo',
        brand: 'Nissan',
        model: 'GT-R',
        year: 2023,
        pricePerDay: 350,
        imageUrl: 'https://images.unsplash.com/photo-1635783674256-d66a61a20833?auto=format&fit=crop&w=800&q=80',
        description: 'The legendary Godzilla. Pure performance.',
        seats: 4,
        transmission: 'Automatic',
        fuelType: 'Petrol',
        isAvailable: true,
        createdAt: DateTime.now(),
      ),
      Car(
        id: '',
        name: 'Polo GTI',
        brand: 'Volkswagen',
        model: 'Polo',
        year: 2022,
        pricePerDay: 80,
        imageUrl: 'https://images.unsplash.com/photo-1541899481282-d53bffe3c35d?auto=format&fit=crop&w=800&q=80',
        description: 'Compact, sporty, and perfect for the city.',
        seats: 5,
        transmission: 'Automatic',
        fuelType: 'Petrol',
        isAvailable: true,
        createdAt: DateTime.now(),
      ),
      Car(
        id: '',
        name: '208 GT',
        brand: 'Peugeot',
        model: '208',
        year: 2024,
        pricePerDay: 75,
        imageUrl: 'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?auto=format&fit=crop&w=800&q=80',
        description: 'French design with modern tech and efficiency.',
        seats: 5,
        transmission: 'Manual',
        fuelType: 'Petrol',
        isAvailable: true,
        createdAt: DateTime.now(),
      ),
      Car(
        id: '',
        name: 'G63 AMG',
        brand: 'Mercedes-Benz',
        model: 'G-Class',
        year: 2023,
        pricePerDay: 500,
        imageUrl: 'https://images.unsplash.com/photo-1606664515524-ed2f786a0bd6?auto=format&fit=crop&w=800&q=80',
        description: 'The ultimate luxury off-roader.',
        seats: 5,
        transmission: 'Automatic',
        fuelType: 'Petrol',
        isAvailable: true,
        createdAt: DateTime.now(),
      ),
      Car(
        id: '',
        name: '911 Carrera',
        brand: 'Porsche',
        model: '911',
        year: 2023,
        pricePerDay: 450,
        imageUrl: 'https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?auto=format&fit=crop&w=800&q=80',
        description: 'Timeless design and engineering perfection.',
        seats: 2,
        transmission: 'Automatic',
        fuelType: 'Petrol',
        isAvailable: true,
        createdAt: DateTime.now(),
      ),
      Car(
        id: '',
        name: 'Mustang GT',
        brand: 'Ford',
        model: 'GT',
        year: 2023,
        pricePerDay: 180,
        imageUrl: 'https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?auto=format&fit=crop&w=800&q=80',
        description: 'American muscle with a V8 roar.',
        seats: 4,
        transmission: 'Manual',
        fuelType: 'Petrol',
        isAvailable: true,
        createdAt: DateTime.now(),
      ),
       Car(
        id: '',
        name: 'RS E-tron GT',
        brand: 'Audi',
        model: 'RS',
        year: 2024,
        pricePerDay: 320,
        imageUrl: 'https://images.unsplash.com/photo-1620891549027-942fdc95d3f5?auto=format&fit=crop&w=800&q=80',
        description: 'Electric performance redefined.',
        seats: 4,
        transmission: 'Automatic',
        fuelType: 'Electric',
        isAvailable: true,
        createdAt: DateTime.now(),
      ),
    ];

    for (var car in demoCars) {
      await _carService.addCar(car);
    }
    await loadCars();
  }
}
