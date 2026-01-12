import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking_model.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'bookings';

  // Create - Create new booking
  Future<void> createBooking(Booking booking) async {
    try {
      await _firestore.collection(_collection).add(booking.toMap());
    } catch (e) {
      throw 'Error creating booking: $e';
    }
  }

  // Read - Get user bookings
  Future<List<Booking>> getUserBookings(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .get();
      
      final bookings = snapshot.docs.map<Booking>((doc) => Booking.fromFirestore(doc)).toList();
      // Sort client-side to avoid Firestore Index requirement
      bookings.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return bookings;
    } catch (e) {
      throw 'Error loading bookings: $e';
    }
  }

  // Read - Get booking by ID
  Future<Booking?> getBookingById(String bookingId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(bookingId).get();
      if (doc.exists) {
        return Booking.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw 'Error loading booking: $e';
    }
  }

  // Update - Update booking status
  Future<void> updateBookingStatus(
      String bookingId, BookingStatus status) async {
    try {
      await _firestore.collection(_collection).doc(bookingId).update({
        'status': status.toString().split('.').last,
      });
    } catch (e) {
      throw 'Error updating booking: $e';
    }
  }

  // Delete - Cancel booking
  Future<void> cancelBooking(String bookingId) async {
    try {
      await updateBookingStatus(bookingId, BookingStatus.cancelled);
    } catch (e) {
      throw 'Error cancelling booking: $e';
    }
  }

  // Get bookings for a specific car
  Future<List<Booking>> getCarBookings(String carId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('carId', isEqualTo: carId)
          .where('status', whereIn: ['pending', 'confirmed'])
          .get();
      
      return snapshot.docs.map<Booking>((doc) => Booking.fromFirestore(doc)).toList();
    } catch (e) {
      throw 'Error loading car bookings: $e';
    }
  }

  Future<bool> checkAvailability(String carId, DateTime start, DateTime end) async {
    try {
      final existingBookings = await getCarBookings(carId);
      
      for (final booking in existingBookings) {
        // Check overlap
        // Overlap if (StartDate1 <= EndDate2) and (EndDate1 >= StartDate2)
        if (booking.startDate.isBefore(end.add(const Duration(seconds: 1))) && 
            booking.endDate.isAfter(start.subtract(const Duration(seconds: 1)))) {
          return false; // Not available
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Booking>> getAllBookings() async {
    try {
      final snapshot = await _firestore.collection(_collection).get();
      final bookings = snapshot.docs.map((doc) => Booking.fromFirestore(doc)).toList();
      bookings.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return bookings;
    } catch (e) {
      throw 'Error loading all bookings: $e';
    }
  }
}
