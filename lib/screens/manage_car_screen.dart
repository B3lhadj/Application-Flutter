import 'package:flutter/material.dart';
import '../../models/car_model.dart';
import '../../providers/car_provider.dart';
import 'package:provider/provider.dart';

class ManageCarScreen extends StatefulWidget {
  final Car? car;

  const ManageCarScreen({super.key, this.car});

  @override
  State<ManageCarScreen> createState() => _ManageCarScreenState();
}

class _ManageCarScreenState extends State<ManageCarScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _brandController;
  late TextEditingController _modelController;
  late TextEditingController _yearController;
  late TextEditingController _priceController;
  late TextEditingController _imageController;
  late TextEditingController _descriptionController;
  late TextEditingController _seatsController;
  
  String _transmission = 'Automatic';
  String _fuelType = 'Petrol';
  bool _isAvailable = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final car = widget.car;
    _nameController = TextEditingController(text: car?.name ?? '');
    _brandController = TextEditingController(text: car?.brand ?? '');
    _modelController = TextEditingController(text: car?.model ?? '');
    _yearController = TextEditingController(text: car?.year.toString() ?? '');
    _priceController = TextEditingController(text: car?.pricePerDay.toString() ?? '');
    _imageController = TextEditingController(text: car?.imageUrl ?? '');
    _descriptionController = TextEditingController(text: car?.description ?? '');
    _seatsController = TextEditingController(text: car?.seats.toString() ?? '5');
    
    if (car != null) {
      _transmission = car.transmission;
      _fuelType = car.fuelType;
      _isAvailable = car.isAvailable;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _priceController.dispose();
    _imageController.dispose();
    _descriptionController.dispose();
    _seatsController.dispose();
    super.dispose();
  }

  Future<void> _saveCar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final carProvider = context.read<CarProvider>();
      
      final carData = Car(
        id: widget.car?.id ?? '',
        name: _nameController.text,
        brand: _brandController.text,
        model: _modelController.text,
        year: int.parse(_yearController.text),
        pricePerDay: double.parse(_priceController.text),
        imageUrl: _imageController.text,
        description: _descriptionController.text,
        seats: int.parse(_seatsController.text),
        transmission: _transmission,
        fuelType: _fuelType,
        isAvailable: _isAvailable,
        createdAt: widget.car?.createdAt ?? DateTime.now(),
      );

      if (widget.car == null) {
        await carProvider.addCar(carData);
      } else {
        await carProvider.updateCar(widget.car!.id, carData.toMap());
      }

      if (!mounted) return;
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.car == null ? 'Car Added to Garage!' : 'Car Updated!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          widget.car == null ? 'Add to Garage' : 'Edit Vehicle',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_imageController.text.isNotEmpty) ...[
                      Container(
                        height: 200,
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            _imageController.text,
                            fit: BoxFit.cover,
                            errorBuilder: (_,__,___) => Container(
                              color: Colors.grey[200],
                              child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                            ),
                          ),
                        ),
                      ),
                    ],

                    _buildSectionTitle('Basic Information'),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildTextField(_nameController, 'Vehicle Name', 'e.g. Mercedes AMG GT', Icons.directions_car),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(child: _buildTextField(_brandController, 'Brand', 'Mercedes', Icons.branding_watermark)),
                              const SizedBox(width: 16),
                              Expanded(child: _buildTextField(_modelController, 'Model', 'AMG GT', Icons.style)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    _buildSectionTitle('Specifications'),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: _buildTextField(_yearController, 'Year', '2024', Icons.calendar_today, isNumber: true)),
                              const SizedBox(width: 16),
                              Expanded(child: _buildTextField(_priceController, 'Price/Day', '150', Icons.attach_money, isNumber: true)),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: _transmission,
                                  isExpanded: true,
                                  decoration: _inputDecoration('Transmission', Icons.settings),
                                  items: ['Automatic', 'Manual'].map((t) => DropdownMenuItem(value: t, child: Text(t, overflow: TextOverflow.ellipsis))).toList(),
                                  onChanged: (v) => setState(() => _transmission = v!),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: _fuelType,
                                  isExpanded: true,
                                  decoration: _inputDecoration('Fuel', Icons.local_gas_station),
                                  items: ['Petrol', 'Diesel', 'Electric', 'Hybrid'].map((f) => DropdownMenuItem(value: f, child: Text(f, overflow: TextOverflow.ellipsis))).toList(),
                                  onChanged: (v) => setState(() => _fuelType = v!),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(_seatsController, 'Seats', '5', Icons.event_seat, isNumber: true),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                    _buildSectionTitle('Visuals & Details'),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildTextField(_imageController, 'Image URL', 'https://...', Icons.image),
                          const SizedBox(height: 20),
                          _buildTextField(_descriptionController, 'Description', 'Describe the experience...', Icons.description, maxLines: 4),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: SwitchListTile(
                        title: const Text('Available for Booking', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(_isAvailable ? 'Visible to users' : 'Hidden from users'),
                        value: _isAvailable,
                        activeColor: Colors.black,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        onChanged: (v) => setState(() => _isAvailable = v),
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
          
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveCar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          widget.car == null ? 'Add Vehicle' : 'Save Changes',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String hint, IconData icon, {bool isNumber = false, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration(label, icon, hint: hint),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      onChanged: (val) {
        if (label == 'Image URL') setState(() {});
      },
      validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.grey, size: 20),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black, width: 1.5)),
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
