import 'package:flutter/material.dart';
import 'dart:math';
import '../models/booking_model.dart';
import '../services/booking_service.dart';

class PaymentScreen extends StatefulWidget {
  final Booking booking;

  const PaymentScreen({super.key, required this.booking});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  
  final FocusNode _cvvFocusNode = FocusNode();
  bool _isBackSide = false;

  @override
  void initState() {
    super.initState();
    _cvvFocusNode.addListener(() {
      setState(() {
        _isBackSide = _cvvFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _cvvFocusNode.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _processPayment() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 3));
    
    try {
      final service = BookingService();
      await service.updateBookingStatus(widget.booking.id, BookingStatus.confirmed);
      
      if (!mounted) return;
      
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 64),
              const SizedBox(height: 16),
              const Text('Payment Successful!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 8),
              const Text('Your booking has been confirmed.', textAlign: TextAlign.center),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context, true);
              },
              child: const Text('Great'),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment Failed: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Checkout', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Animated Credit Card
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: _isBackSide ? 180 : 0),
              duration: const Duration(milliseconds: 600),
              builder: (context, double value, child) {
                // 3D Flip Logic
                bool showBack = value >= 90;
                return Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001) // Perspective
                    ..rotateY((value * pi) / 180),
                  alignment: Alignment.center,
                  child: showBack
                      ? Transform(
                          transform: Matrix4.identity()..rotateY(pi), // Correct text for back
                          alignment: Alignment.center,
                          child: _buildCardBack(),
                        )
                      : _buildCardFront(),
                );
              },
            ),

            const SizedBox(height: 32),

            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Card Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _cardNumberController,
                    decoration: _inputDecoration('Card Number', Icons.credit_card),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => setState(() {}),
                    validator: (v) => v!.length < 16 ? 'Invalid Card Number' : null,
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _expiryController,
                          decoration: _inputDecoration('Expiry (MM/YY)', Icons.calendar_today),
                          onChanged: (v) => setState(() {}),
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _cvvController,
                          focusNode: _cvvFocusNode,
                          decoration: _inputDecoration('CVV', Icons.lock_outline),
                          obscureText: true,
                          keyboardType: TextInputType.number,
                          onChanged: (v) => setState(() {}),
                          validator: (v) => v!.length < 3 ? 'Invalid' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    decoration: _inputDecoration('Cardholder Name', Icons.person_outline),
                    onChanged: (v) => setState(() {}),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  
                  const SizedBox(height: 40),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _processPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 5,
                        shadowColor: Colors.black26,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.lock, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  'Pay \$${widget.booking.totalPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardFront() {
    return Container(
      height: 200,
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Colors.black, Colors.grey.shade900],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.nfc, color: Colors.white54, size: 32),
              // Visa Logo Mockup
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                child: const Text('VISA', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.blue, fontSize: 18, fontStyle: FontStyle.italic)),
              ),
            ],
          ),
          
          Text(
            _cardNumberController.text.isEmpty ? '**** **** **** ****' : _cardNumberController.text,
            style: const TextStyle(color: Colors.white, fontSize: 22, fontFamily: 'monospace', letterSpacing: 2),
          ),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Card Holder', style: TextStyle(color: Colors.grey, fontSize: 10)),
                  Text(_nameController.text.isEmpty ? 'YOUR NAME' : _nameController.text.toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Expires', style: TextStyle(color: Colors.grey, fontSize: 10)),
                  Text(_expiryController.text.isEmpty ? 'MM/YY' : _expiryController.text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCardBack() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Colors.grey.shade800, Colors.black],
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
        ),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 10))],
      ),
      child: Column(
        children: [
          const SizedBox(height: 30),
          Container(height: 40, color: Colors.black), // Magnetic strip
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Container(height: 30, width: 200, color: Colors.grey[300]), // Signature strip
                const SizedBox(width: 10),
                Text(
                  _cvvController.text.isEmpty ? '***' : _cvvController.text,
                  style: const TextStyle(color: Colors.white, fontFamily: 'monospace', fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Customer Service: +1 800 VISA', style: TextStyle(color: Colors.grey, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.grey),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black, width: 1)),
    );
  }
}
