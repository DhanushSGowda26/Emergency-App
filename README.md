# Emergency Ambulance

A Flutter MVP that demonstrates an emergency ambulance booking flow: enter a
mobile number, request the patient's location, choose the nearest available
sample ambulance, select a nearby sample emergency hospital, and display trip
details.

> **Prototype only:** This project does not contact emergency services. It has
> no real authentication, ambulance dispatch, hospital availability feed, live
> map, or working phone call integration. In an emergency, contact your local
> emergency number directly.

## How the app works

1. **Login** — The user enters a mobile number. The app only checks that the
   trimmed input has at least 10 characters; it does not verify the number or
   create an account.
2. **Home** — The user can start the ambulance booking flow or view a reminder
   to call local emergency services.
3. **Booking** — The app checks that location services are enabled, requests
   location permission if necessary, and obtains the device's current position.
4. **Selection** — The app finds the closest available ambulance and the
   closest hospital marked open with emergency services available.
5. **Tracking** — The app displays the selected ambulance, driver, destination,
   straight-line distances, and a rough ETA.

## Code map

The primary Flutter entry point is [`lib/main.dart`](lib/main.dart).

- `AmbulanceApp` configures the Material app and opens `LoginScreen`.
- `Ambulance` and `Hospital` hold the sample vehicle and hospital data.
- `LoginScreen` validates the mobile-number input and navigates to `HomeScreen`.
- `HomeScreen` starts the booking flow.
- `BookingScreen` requests the device location, filters and selects the nearest
  available sample records, and handles loading, success, and retry states.
- `TrackingScreen` displays the selected trip information.
- `calculateDistance` uses the Haversine formula to estimate the great-circle
  distance between two latitude/longitude coordinates.

The root-level [`main.dart`](main.dart) is a duplicate copy kept from the
original project; Flutter uses `lib/main.dart` as its application entry point.

## Sample data and limitations

Ambulances and hospitals are hardcoded in `lib/main.dart` with example
Bengaluru-area coordinates. Availability and hospital emergency capacity are
fixed values, not fetched from a server. Selection uses straight-line distance,
not road routes or traffic. The displayed ETA is a simple estimate based on
that distance, not a live dispatch prediction. The tracking illustration is
not a real map, and **CALL DRIVER** only displays an in-app message.

The mobile-number screen is not secure authentication. Do not use this prototype
as a real emergency-response or dispatch system without a backend, verified
dispatch data, security review, and appropriate operational safeguards.

## Requirements

- Flutter SDK (Dart SDK `>=3.3.0 <4.0.0`)
- A supported Flutter device or browser
- Location services and permission for the booking flow

The location dependency is [`geolocator`](pubspec.yaml). On Android, add the
appropriate location permissions to
`android/app/src/main/AndroidManifest.xml` when generating or adding the Android
platform. On the web, allow location access in the browser; browser geolocation
generally requires HTTPS or a local development origin such as `localhost`.

## Run and verify

From the project root:

```sh
flutter pub get
flutter run
```

Run the widget test and static analysis with:

```sh
flutter test
flutter analyze
```

The smoke test in [`test/widget_test.dart`](test/widget_test.dart) verifies
that the login screen renders with its title, mobile-number field, and login
button. It does not test real location access, ambulance dispatch, or hospital
selection.
