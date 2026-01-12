import 'package:flutter/material.dart';

class FavoritesProvider extends ChangeNotifier {
  final Set<String> _favoriteIds = {};

  bool isFavorite(String carId) => _favoriteIds.contains(carId);

  void toggleFavorite(String carId) {
    if (_favoriteIds.contains(carId)) {
      _favoriteIds.remove(carId);
    } else {
      _favoriteIds.add(carId);
    }
    notifyListeners();
  }
}
