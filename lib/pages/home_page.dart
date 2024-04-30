import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../get_user_location.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key? key});

  final CameraPosition _cameraPosition =
  const CameraPosition(target: LatLng(0.3338, 32.5514), zoom: 14.0);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final String? photoUrl = user.photoURL;

    return Scaffold(
      appBar: CustomAppBar(userPhotoUrl: photoUrl),
      body: Stack(
        children: [
          GoogleMap(initialCameraPosition: _cameraPosition),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () {
                // Method getting current location for user
                // This is just a placeholder. The actual implementation will be done in the GetUserLocation widget.
              },
              child: const Icon(Icons.radio_button_off),
            ),
          ),
          GetUserLocation(
            onLocationUpdate: () {
              // Callback function to be executed when the location is updated
              // You can call packData() here or any other logic you want to execute
            },
          ),
        ],
      ),
    );
  }
}


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? userPhotoUrl;

  const CustomAppBar({Key? key, required this.userPhotoUrl});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          const Text('My Locator App'),
          const Spacer(), // Add Spacer widget to push the user photo to the right
          if (userPhotoUrl != null)
            CircleAvatar(
              backgroundImage: NetworkImage(userPhotoUrl!),
            ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
          },
          icon: const Icon(Icons.logout),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

