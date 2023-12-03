import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_envy_application/services/account_info.dart';
import 'package:food_envy_application/services/photo_helper.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class FoodEnvyBottomAppBar extends StatelessWidget {
  FoodEnvyBottomAppBar({
    super.key,
  });
  FirebaseFirestore db = FirebaseFirestore.instance;
  UserProfile? providerUser;
  String meal = "";
  @override
  Widget build(BuildContext context) {
    providerUser = Provider.of<UserProfile>(context);
    return BottomAppBar(
      color: const Color(0xfffffff3),
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      child: Row(children: [
        IconButton(
          icon: const Icon(
            Icons.photo_camera,
            size: 40,
            color: Color(0xFF034D22),
          ),
          onPressed: () async {
            meal = "";
            await showMenu(context);
            if (meal != "") {
              await takeImage();
            }
          },
        )
      ]),
    );
  }

  Future<void> takeImage() async {
    final imgPicker = ImagePicker();
    try {
      final pickedFile = await imgPicker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        imageFile = await cropImage(imageFile);
        await storeImage(imageFile);
      } else {
        // User canceled image picking
        print("User canceled their image upload");
      }
    } catch (e) {
      print("Error picking and uploading image: $e");
    }
  }

  Future<File> cropImage(File image) async {
    CroppedFile? result = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        aspectRatioPresets: [CropAspectRatioPreset.square]);

    if (result != null) {
      return File(result.path);
    } else {
      return image;
    }
  }

  Future<void> storeImage(File image) async {
    final storageRef =
        FirebaseStorage.instance.ref().child(basename(image.path));
    final UploadTask uploadTask = storageRef.putFile(image);
    await uploadTask.whenComplete(() async {
      final String downloadURL = await storageRef.getDownloadURL();
      await addPost(db, providerUser!.username!, downloadURL,
          meal); // TODO: replace with actual meal
    });
  }

  Future<void> showMenu(BuildContext context) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Choose A Meal"),
            backgroundColor: const Color(0xFF94C668),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                    onPressed: () {
                      meal = "Breakfast";
                      Navigator.pop(context);
                    },
                    child: Text("Breakfast")),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                    onPressed: () {
                      meal = "Lunch";
                      Navigator.pop(context);
                    },
                    child: Text("Lunch")),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                    onPressed: () {
                      meal = "Dinner";
                      Navigator.pop(context);
                    },
                    child: Text("Dinner")),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                    onPressed: () {
                      meal = "Snack";
                      Navigator.pop(context);
                    },
                    child: Text("Snack")),
              ),
            ]),
          );
        });
  }
}
