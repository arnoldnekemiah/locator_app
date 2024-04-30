import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locatorapp/get_user_location.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key});

  final CameraPosition _cameraPosition =
      const CameraPosition(target: LatLng(0.3338, 32.5514), zoom: 14.0);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    late Future<String?> _photoUrlFuture;

    // Fetch the user's photo URL from Firebase Storage using the user's UID
    firebase_storage.Reference storageRef = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('user_photos')
        .child('${user.uid}.jpg');
    _photoUrlFuture = storageRef.getDownloadURL();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: FutureBuilder<String?>(
          future: _photoUrlFuture,
          builder: (context, snapshot) {
            final userPhotoUrl = snapshot.data;
            return CustomAppBar(userPhotoUrl: userPhotoUrl);
          },
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(initialCameraPosition: _cameraPosition),
          Positioned(
            bottom: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    // Method getting current location for user
                    // This is just a placeholder. The actual implementation will be done in the GetUserLocation widget.
                  },
                  child: const Icon(Icons.radio_button_off),
                ),
                const SizedBox(
                    height:
                        16), // Adjust the space between the button and the bottom edge
              ],
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
      title: const Text('My Locator App'),
      actions: [
        CircleAvatar(
          // Load the user photo from the URL if available, otherwise use a placeholder
          backgroundImage: userPhotoUrl != null
              ? NetworkImage(userPhotoUrl!)
              : const NetworkImage(
                  'https://avatar.iran.liara.run/public/boy?username=Ash'),
        ),
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
