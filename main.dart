// ============================================================
// EMERGENCY AMBULANCE BOOKING APP - SINGLE FILE MVP
// Flutter: lib/main.dart
//
// Flow:
// Login
//   ↓
// Patient Home
//   ↓
// Get Current Location
//   ↓
// Find Nearest Available Ambulance
//   ↓
// Book Ambulance
//   ↓
// Automatically Select Nearest OPEN Hospital
//   ↓
// Show Ambulance + Hospital + Trip Details
//
// Add to pubspec.yaml:
//
// dependencies:
//   flutter:
//     sdk: flutter
//   geolocator: ^13.0.2
//
// Android permission required in:
// android/app/src/main/AndroidManifest.xml
//
// <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
// <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
//
// ============================================================

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const AmbulanceApp());
}

// ============================================================
// APP
// ============================================================

class AmbulanceApp extends StatelessWidget {
  const AmbulanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Emergency Ambulance',
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

// ============================================================
// MODELS
// ============================================================

class Ambulance {
  final String id;
  final String number;
  final String driver;
  final double latitude;
  final double longitude;
  final String type;
  final bool available;

  Ambulance({
    required this.id,
    required this.number,
    required this.driver,
    required this.latitude,
    required this.longitude,
    required this.type,
    required this.available,
  });
}

class Hospital {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final bool open;
  final bool emergencyAvailable;

  Hospital({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.open,
    required this.emergencyAvailable,
  });
}

// ============================================================
// MOCK DATA
// Replace this with Firebase/API data later.
// ============================================================

final List<Ambulance> ambulances = [
  Ambulance(
    id: 'AMB001',
    number: 'KA-01-AB-1001',
    driver: 'Rahul Kumar',
    latitude: 12.9718,
    longitude: 77.5948,
    type: 'Basic Ambulance',
    available: true,
  ),
  Ambulance(
    id: 'AMB002',
    number: 'KA-01-AB-1002',
    driver: 'Arun Kumar',
    latitude: 12.9750,
    longitude: 77.6000,
    type: 'Advanced Ambulance',
    available: true,
  ),
  Ambulance(
    id: 'AMB003',
    number: 'KA-01-AB-1003',
    driver: 'Vijay Kumar',
    latitude: 12.9650,
    longitude: 77.5900,
    type: 'ICU Ambulance',
    available: true,
  ),
];

final List<Hospital> hospitals = [
  Hospital(
    id: 'H001',
    name: 'City Emergency Hospital',
    latitude: 12.9720,
    longitude: 77.5950,
    open: true,
    emergencyAvailable: true,
  ),
  Hospital(
    id: 'H002',
    name: 'Metro Hospital',
    latitude: 12.9800,
    longitude: 77.6000,
    open: true,
    emergencyAvailable: true,
  ),
  Hospital(
    id: 'H003',
    name: 'General Hospital',
    latitude: 12.9600,
    longitude: 77.5850,
    open: false,
    emergencyAvailable: false,
  ),
];

// ============================================================
// LOGIN SCREEN
// ============================================================

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneController = TextEditingController();
  bool loading = false;

  void login() async {
    if (phoneController.text.trim().length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a valid mobile number'),
        ),
      );
      return;
    }

    setState(() {
      loading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.local_hospital,
                size: 90,
                color: Colors.red,
              ),

              const SizedBox(height: 20),

              const Text(
                'Emergency Ambulance',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Fast ambulance booking near you',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 40),

              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.phone),
                  labelText: 'Mobile Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: loading ? null : login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: loading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// HOME SCREEN
// ============================================================

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void startEmergency(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const BookingScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Ambulance'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            const SizedBox(height: 30),

            const Icon(
              Icons.location_on,
              size: 70,
              color: Colors.red,
            ),

            const SizedBox(height: 15),

            const Text(
              'Emergency Ambulance',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'We will find the nearest available ambulance and automatically select a nearby open hospital.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 70,
              child: ElevatedButton(
                onPressed: () => startEmergency(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  '🚨  BOOK EMERGENCY AMBULANCE',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Emergency services: Call your local emergency number.',
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.phone),
                label: const Text('Emergency Call'),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// BOOKING SCREEN
// ============================================================

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  Position? patientPosition;

  Ambulance? selectedAmbulance;
  Hospital? selectedHospital;

  bool loading = true;
  String status = 'Getting your location...';

  @override
  void initState() {
    super.initState();

    startBooking();
  }

  // ==========================================================
  // START BOOKING
  // ==========================================================

  Future<void> startBooking() async {
    try {
      setState(() {
        status = 'Getting your current location...';
      });

      final position = await getCurrentLocation();

      patientPosition = position;

      setState(() {
        status = 'Finding nearest ambulance...';
      });

      await Future.delayed(
        const Duration(seconds: 1),
      );

      selectedAmbulance =
          findNearestAmbulance(position);

      if (selectedAmbulance == null) {
        setState(() {
          loading = false;
          status = 'No ambulance available nearby.';
        });
        return;
      }

      setState(() {
        status = 'Finding nearby open hospital...';
      });

      await Future.delayed(
        const Duration(seconds: 1),
      );

      selectedHospital =
          findNearestOpenHospital(position);

      if (selectedHospital == null) {
        setState(() {
          loading = false;
          status = 'No nearby open hospital found.';
        });
        return;
      }

      setState(() {
        loading = false;
        status = 'Ambulance booked successfully!';
      });

    } catch (e) {
      setState(() {
        loading = false;
        status = 'Unable to get location.';
      });
    }
  }

  // ==========================================================
  // LOCATION
  // ==========================================================

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;

    LocationPermission permission;

    serviceEnabled =
        await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception('Location service disabled');
    }

    permission =
        await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission =
          await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }
    }

    if (permission ==
        LocationPermission.deniedForever) {
      throw Exception(
        'Location permission permanently denied',
      );
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }

  // ==========================================================
  // FIND NEAREST AMBULANCE
  // ==========================================================

  Ambulance? findNearestAmbulance(
    Position patient,
  ) {
    Ambulance? nearest;

    double smallestDistance =
        double.infinity;

    for (final ambulance in ambulances) {
      if (!ambulance.available) {
        continue;
      }

      final distance =
          calculateDistance(
        patient.latitude,
        patient.longitude,
        ambulance.latitude,
        ambulance.longitude,
      );

      if (distance < smallestDistance) {
        smallestDistance = distance;
        nearest = ambulance;
      }
    }

    return nearest;
  }

  // ==========================================================
  // FIND NEAREST OPEN HOSPITAL
  // ==========================================================

  Hospital? findNearestOpenHospital(
    Position patient,
  ) {
    Hospital? nearest;

    double smallestDistance =
        double.infinity;

    for (final hospital in hospitals) {
      // Only hospitals that are currently open
      // and accepting emergency patients.
      if (!hospital.open ||
          !hospital.emergencyAvailable) {
        continue;
      }

      final distance =
          calculateDistance(
        patient.latitude,
        patient.longitude,
        hospital.latitude,
        hospital.longitude,
      );

      if (distance < smallestDistance) {
        smallestDistance = distance;
        nearest = hospital;
      }
    }

    return nearest;
  }

  // ==========================================================
  // DISTANCE CALCULATION
  // ==========================================================

  double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const earthRadius = 6371;

    final dLat =
        _degreesToRadians(lat2 - lat1);

    final dLon =
        _degreesToRadians(lon2 - lon1);

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c =
        2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  // ==========================================================
  // CONFIRM BOOKING
  // ==========================================================

  void confirmBooking() {
    if (selectedAmbulance == null ||
        selectedHospital == null) {
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => TrackingScreen(
          ambulance: selectedAmbulance!,
          hospital: selectedHospital!,
          patientPosition: patientPosition!,
        ),
      ),
    );
  }

  // ==========================================================
  // UI
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Booking'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: loading
            ? Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: Colors.red,
                  ),

                  const SizedBox(height: 25),

                  Text(
                    status,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            : selectedAmbulance == null ||
                    selectedHospital == null
                ? Center(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 70,
                          color: Colors.red,
                        ),

                        const SizedBox(height: 20),

                        Text(
                          status,
                          textAlign:
                              TextAlign.center,
                          style:
                              const TextStyle(
                            fontSize: 18,
                          ),
                        ),

                        const SizedBox(height: 20),

                        ElevatedButton(
                          onPressed:
                              startBooking,
                          child:
                              const Text('TRY AGAIN'),
                        ),
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ambulance Found 🚑',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Ambulance Card
                      Card(
                        child: Padding(
                          padding:
                              const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Icons
                                        .local_hospital,
                                    color:
                                        Colors.red,
                                    size: 35,
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Text(
                                    'Nearest Ambulance',
                                    style:
                                        TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                  height: 15),

                              Text(
                                selectedAmbulance!
                                    .type,
                              ),

                              Text(
                                selectedAmbulance!
                                    .number,
                              ),

                              Text(
                                'Driver: ${selectedAmbulance!.driver}',
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // Hospital Card
                      Card(
                        child: Padding(
                          padding:
                              const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Icons
                                        .location_city,
                                    color:
                                        Colors.green,
                                    size: 35,
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Text(
                                    'Hospital Automatically Selected',
                                    style:
                                        TextStyle(
                                      fontSize: 17,
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                  height: 15),

                              Text(
                                selectedHospital!
                                    .name,
                                style:
                                    const TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              const SizedBox(
                                  height: 5),

                              const Text(
                                'OPEN • Emergency Available',
                                style:
                                    TextStyle(
                                  color:
                                      Colors.green,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const Spacer(),

                      SizedBox(
                        width:
                            double.infinity,
                        height: 60,
                        child:
                            ElevatedButton(
                          onPressed:
                              confirmBooking,
                          style:
                              ElevatedButton
                                  .styleFrom(
                            backgroundColor:
                                Colors.red,
                            foregroundColor:
                                Colors.white,
                          ),
                          child: const Text(
                            'CONFIRM BOOKING',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}

// ============================================================
// TRACKING SCREEN
// ============================================================

class TrackingScreen extends StatelessWidget {
  final Ambulance ambulance;
  final Hospital hospital;
  final Position patientPosition;

  const TrackingScreen({
    super.key,
    required this.ambulance,
    required this.hospital,
    required this.patientPosition,
  });

  @override
  Widget build(BuildContext context) {
    final distance = calculateDistance(
      patientPosition.latitude,
      patientPosition.longitude,
      ambulance.latitude,
      ambulance.longitude,
    );

    final hospitalDistance =
        calculateDistance(
      patientPosition.latitude,
      patientPosition.longitude,
      hospital.latitude,
      hospital.longitude,
    );

    final eta = max(
      2,
      (distance * 4).round(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ambulance Tracking'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            // Simulated map area
            Container(
              height: 260,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius:
                    BorderRadius.circular(15),
              ),

              child: const Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.map,
                    size: 100,
                    color: Colors.grey,
                  ),

                  Positioned(
                    left: 40,
                    top: 70,
                    child: Column(
                      children: [
                        Icon(
                          Icons.local_hospital,
                          color: Colors.red,
                          size: 40,
                        ),
                        Text(
                          'Ambulance',
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    right: 40,
                    bottom: 60,
                    child: Column(
                      children: [
                        Icon(
                          Icons.person_pin_circle,
                          color: Colors.blue,
                          size: 40,
                        ),
                        Text(
                          'You',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Ambulance arriving in about $eta min',
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.local_hospital,
                  color: Colors.red,
                ),

                title: Text(
                  ambulance.number,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                subtitle: Text(
                  'Driver: ${ambulance.driver}\n'
                  '${ambulance.type}',
                ),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.location_city,
                  color: Colors.green,
                ),

                title: const Text(
                  'Destination Hospital',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                subtitle: Text(
                  '${hospital.name}\n'
                  '${hospitalDistance.toStringAsFixed(1)} km away',
                ),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Calling ambulance driver...',
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.phone),
                label: const Text(
                  'CALL DRIVER',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Destination is automatically selected based on nearby open emergency hospitals.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// DISTANCE FUNCTION
// ============================================================

double calculateDistance(
  double lat1,
  double lon1,
  double lat2,
  double lon2,
) {
  const earthRadius = 6371;

  final dLat =
      _degreesToRadians(lat2 - lat1);

  final dLon =
      _degreesToRadians(lon2 - lon1);

  final a =
      sin(dLat / 2) * sin(dLat / 2) +
      cos(_degreesToRadians(lat1)) *
          cos(_degreesToRadians(lat2)) *
          sin(dLon / 2) *
          sin(dLon / 2);

  final c =
      2 * atan2(sqrt(a), sqrt(1 - a));

  return earthRadius * c;
}

double _degreesToRadians(double degrees) {
  return degrees * pi / 180;
}