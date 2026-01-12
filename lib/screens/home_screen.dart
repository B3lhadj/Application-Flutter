import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/car_provider.dart';
import '../models/car_model.dart';
import '../widgets/car_grid_item.dart';
import 'manage_car_screen.dart';
import 'chatbot_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _searchQuery = '';
  String _selectedBrand = 'All';

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<CarProvider>().loadCars());
  }

  void _onItemTapped(int index) {
      if (index == 2) {
      // Chat Tab - Navigate to ChatBotScreen
      Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatBotScreen()));
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
    
    switch (index) {
      case 0:
        // Already on Home
        break;
      case 1:
        Navigator.pushNamed(context, '/my-bookings');
        break;
      case 3:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Consumer<CarProvider>(
        builder: (context, carProvider, child) {
          if (carProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          List<Car> displayedCars = carProvider.searchCars(_searchQuery);
          
          if (_selectedBrand != 'All') {
            displayedCars = displayedCars.where((car) => car.brand == _selectedBrand).toList();
          }

          Set<String> brands = {'All', ...carProvider.cars.map((e) => e.brand)};

          return CustomScrollView(
            slivers: [
              // 1. Floating App Bar
              SliverAppBar(
                floating: true,
                snap: true,
                title: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Discover',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                actions: [
                   if (context.watch<AuthProvider>().isAdmin)
                     IconButton(
                       icon: const Icon(Icons.playlist_add, color: Colors.blue),
                       onPressed: () => context.read<CarProvider>().addDemoCars(),
                       tooltip: 'add auto car',
                     ),
                   IconButton(icon: const Icon(Icons.search, color: Colors.black87), onPressed: () {}),
                   IconButton(icon: const Icon(Icons.notifications_outlined, color: Colors.black87), onPressed: () {}),
                   const SizedBox(width: 8),
                ],
                backgroundColor: Colors.white,
                elevation: 0,
                pinned: false,
              ),

              // 2. Promotional Banners (50% OFF & Black Friday)
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 220,
                  child: PageView(
                    padEnds: false,
                    controller: PageController(viewportFraction: 0.9),
                    children: [
                      _buildPromoBanner(
                        context,
                        'BLACK FRIDAY',
                        'Exclusive Deals\nUp to 70% OFF',
                        Colors.black,
                        Colors.yellow,
                        'https://images.unsplash.com/photo-1605559424843-9e4c228bf1c2?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
                      ),
                      _buildPromoBanner(
                        context,
                        '50% OFF',
                        'Limited Time\nFlash Sale',
                        Colors.blue.shade700,
                        Colors.white,
                        'https://images.unsplash.com/photo-1544602551-34509883816a?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
                      ),
                      _buildPromoBanner(
                        context,
                        'HOLIDAY SPECIAL',
                        'Ride in Style\nThis Season',
                        Colors.red.shade800,
                        Colors.white,
                        'https://images.unsplash.com/photo-1485291571150-772bcfc10da5?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
                      ),
                      _buildPromoBanner(
                        context,
                        'LUXURY COLLECTION',
                        'Premium Cars\nFor Elite Drivers',
                        Colors.deepPurple.shade900,
                        Colors.amber,
                        'https://images.unsplash.com/photo-1563720223185-11003d516935?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
                      ),
                    ],
                  ),
                ),
              ),

              // 3. Search Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search dream car...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                    onChanged: (value) => setState(() => _searchQuery = value),
                  ),
                ),
              ),

              // 4. Sticky Brand Filters
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  minHeight: 60.0,
                  maxHeight: 60.0,
                  child: Container(
                    color: Colors.grey[50],
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      children: brands.map((brand) {
                        final isSelected = _selectedBrand == brand;
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedBrand = brand),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.black : Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade300),
                              ),
                              child: Text(
                                brand,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),

              // 5. Grid Content
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: displayedCars.isEmpty
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 50),
                              Icon(Icons.commute, size: 64, color: Colors.grey[300]),
                              const SizedBox(height: 16),
                              Text('No cars found', style: TextStyle(color: Colors.grey[500])),
                            ],
                          ),
                        ),
                      )
                    : SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.72, // Slightly taller to prevent 3px overflow
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context, 
                                  '/car-details',
                                  arguments: displayedCars[index],
                                );
                              },
                              child: CarGridItem(car: displayedCars[index]),
                            );
                          },
                          childCount: displayedCars.length,
                        ),
                      ),
              ),
              
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          );
        },
      ),
      floatingActionButton: context.watch<AuthProvider>().isAdmin
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ManageCarScreen()),
                );
              },
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      // Curved Navigation Bar
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 60,
        backgroundColor: Colors.transparent,
        color: Colors.blue,
        buttonBackgroundColor: Colors.blue.shade700,
        animationDuration: const Duration(milliseconds: 300),
        items: const [
          Icon(Icons.home, size: 26, color: Colors.white),
          Icon(Icons.calendar_today, size: 26, color: Colors.white),
          Icon(Icons.smart_toy, size: 26, color: Colors.white),
          Icon(Icons.person, size: 26, color: Colors.white),
        ],
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildPromoBanner(BuildContext context, String tag, String title, Color bgColor, Color textColor, String imageUrl) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.black.withOpacity(0.8),
              Colors.black.withOpacity(0.3),
              Colors.transparent,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                tag,
                style: TextStyle(
                  color: textColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                height: 1.2,
                shadows: [Shadow(color: Colors.black54, blurRadius: 4, offset: Offset(1, 1))],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    final isActive = _selectedIndex == index && index == 0;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isActive ? [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))] : [],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : (isSelected ? Colors.blue : Colors.grey),
              size: 24,
            ),
            if (isActive) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => maxHeight;
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }
  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
