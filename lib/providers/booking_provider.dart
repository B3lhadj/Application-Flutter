import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import '../services/booking_service.dart';

class BookingProvider extends ChangeNotifier {
  final BookingService _bookingService = BookingService();
  List<Booking> _bookings = [];
  bool _isLoading = false;

  List<Booking> get bookings => _bookings;
  bool get isLoading => _isLoading;

  Future<void> loadUserBookings(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _bookings = await _bookingService.getUserBookings(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> loadAllBookings() async {
    _isLoading = true;
    notifyListeners();

    try {
      _bookings = await _bookingService.getAllBookings();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> checkAvailability(String carId, DateTime start, DateTime end) async {
    return await _bookingService.checkAvailability(carId, start, end);
  }

  Future<String?> createBooking(Booking booking) async {
    try {
      await _bookingService.createBooking(booking);
      await loadUserBookings(booking.userId);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> updateBookingStatus(
      String bookingId, BookingStatus status, String userId) async {
    await _bookingService.updateBookingStatus(bookingId, status);
    await loadUserBookings(userId);
  }

  Future<void> cancelBooking(String bookingId, String userId) async {
    await updateBookingStatus(bookingId, BookingStatus.cancelled, userId);
  }

  List<Booking> getActiveBookings() {
    return _bookings.where((booking) {
      return booking.status == BookingStatus.confirmed ||
          booking.status == BookingStatus.pending;
    }).toList();
  }

  List<Booking> getPastBookings() {
    return _bookings.where((booking) {
      return booking.status == BookingStatus.completed ||
          booking.status == BookingStatus.cancelled;
    }).toList();
  }
}
