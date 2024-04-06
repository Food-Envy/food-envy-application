import 'dart:io';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:food_envy_application/account_edit.dart';
import 'package:food_envy_application/auth_gate.dart';
import 'package:food_envy_application/bottom_app_bar.dart';
import 'package:food_envy_application/manage_account.dart';
import 'package:food_envy_application/services/account_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_envy_application/services/comment_upload.dart';
import 'package:food_envy_application/services/meal_helper.dart';
import 'package:food_envy_application/services/util.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:food_envy_application/post_upload.dart';
import 'package:food_envy_application/services/account_info.dart';
import 'package:food_envy_application/services/photo_helper.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String mealToPost = "";
  UserProfile? providerUser;
  FirebaseFirestore db = FirebaseFirestore.instance;
  String currentMeal = "Breakfast";
  Color breakfastColor = const Color(0xFFFFF79C);
  Color lunchColor = const Color(0xFF034D22);
  Color dinnerColor = const Color(0xFF034D22);
  Color snackColor = const Color(0xFF034D22);
  Map<String, List>? posts;
  List<bool> showComments = [];
  bool hasLoadedPosts = false;
  List<TextEditingController> controllers = [];
  List<Padding> commentRows = [];
  bool updateComments = false;
  int indexToUpdate = 0;
  void initRowsAndControllers() {
    showComments.clear();
    controllers.clear();
    commentRows.clear();
    int index = 0;
    posts!.forEach((key, value) {
      showComments.add(false);
      controllers.add(TextEditingController());
      commentRows.add(getTextField(
          "Add a comment",
          controllers[controllers.length - 1],
          MediaQuery.of(context).size.width,
          key,
          providerUser!.username!,
          value,
          index));
      index += 1;
    });
  }

  void updateCommentsForPost() {
    int index = 0;
    posts!.forEach((key, value) {
      commentRows[index] = (getTextField(
          "Add a comment",
          controllers[controllers.length - 1],
          MediaQuery.of(context).size.width,
          key,
          providerUser!.username!,
          value,
          index));
      index += 1;
    });
  }

  void loadPosts() async {
    posts = await getPosts(currentMeal, providerUser!.friends);
    initRowsAndControllers();
  }

  @override
  Widget build(BuildContext context) {
    providerUser = Provider.of<UserProfile>(context);
    if (!hasLoadedPosts && providerUser!.isInitialized()) {
      hasLoadedPosts = true;
      loadPosts();
    }

    if (updateComments) {
      updateComments = false;
      updateCommentsForPost();
    }
    // This method is rerun every time setState is called
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leadingWidth: 300,
        leading: Image.asset("assets/images/noBkgTitle.png"),
        title: IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AccountManagePage()));
          },
          icon: const Icon(Icons.account_circle),
          color: Color(0xFF034D22),
          iconSize: 48,
        ),
      ),
      backgroundColor: const Color(
          0xfffffff3), // This trailing comma makes auto-formatting nicer for build methods.
      //bottomNavigationBar: FoodEnvyBottomAppBar(),
      body: ListView(children: [getMealSelectionRow(), getFriendsPosts()]),
    );
  }

  Widget getFriendsPosts() {
    List<Widget> postWidgets = [];
    int index = 0;
    if (providerUser!.isInitialized() && hasLoadedPosts && posts != null) {
      posts!.forEach((key, value) {
        postWidgets.add(generatePost(key, index));
        index = index + 1;
      });
    }
    return Column(
      children: postWidgets,
    );
  }

  Widget generatePost(String username, int index) {
    List<Widget> columnBody = [];
    Image commentImage = Image.asset("assets/images/Comment.png");
    Image recipeImage = Image.asset("assets/images/Recipe.png");
    if (posts != null) {
      String url = posts![username]![0];
      String recipe = posts![username]![2];
      columnBody = [
        Image.network(url, width: MediaQuery.of(context).size.width),
        Container(
          height: 100,
          color: const Color(0xfffffff3),
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      showComments[index] = !showComments[index];
                    });
                  },
                  icon: commentImage),
              IconButton(
                  onPressed: () {
                    providerUser!.addRecipe(db, recipe, getCurrentUserUuid());
                  },
                  icon: recipeImage),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.place,
                    color: Color(0xFF94C668),
                    size: 50,
                  )),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  "@$username",
                  style:
                      const TextStyle(color: Color(0xFF034D22), fontSize: 25),
                ),
              ),
            ],
          ),
        ),
      ];
      if (showComments[index]) {
        columnBody.add(commentRows[index]);
      }
    }
    return Column(
      children: columnBody,
    );
  }

  Container getMealSelectionRow() {
    Image lunchPhoto = Image.asset("assets/images/LNormal.png");
    if (currentMeal == "Lunch") {
      lunchPhoto = Image.asset("assets/images/LSelected.png");
    }

    Image breakfastPhoto = Image.asset("assets/images/BNormal.png");
    if (currentMeal == "Breakfast") {
      breakfastPhoto = Image.asset("assets/images/BSelected.png");
    }

    Image dinnerPhoto = Image.asset("assets/images/DNormal.png");
    if (currentMeal == "Dinner") {
      dinnerPhoto = Image.asset("assets/images/DSelected.png");
    }

    Image snackPhoto = Image.asset("assets/images/SNormal.png");
    if (currentMeal == "Snack") {
      snackPhoto = Image.asset("assets/images/SSelected.png");
    }

    //lunchImage =
    return Container(
      color: const Color(0xfffffff3),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        IconButton(
          icon: const Icon(
            Icons.photo_camera,
            size: 48,
            color: Color(0xFF034D22),
          ),
          onPressed: () async {
            mealToPost = "";
            await showMenu(context);
            if (mealToPost != "") {
              File? imageFile = await takeImage(context);
              if (imageFile != null) {
                // ignore: use_build_context_synchronously
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PostUpload(
                              image: imageFile,
                              meal: mealToPost,
                            )));
              }
            }
          },
        ),
        IconButton(
            onPressed: () async {
              print("reached");
              currentMeal = "Breakfast";
              breakfastColor = const Color(0xFFFFF79C);
              lunchColor = const Color(0xFF034D22);
              dinnerColor = const Color(0xFF034D22);
              snackColor = const Color(0xFF034D22);
              posts = await getPosts(currentMeal, providerUser!.friends);
              print("length: ${posts!.length}");
              initRowsAndControllers();
            },
            icon: breakfastPhoto),
        IconButton(
            onPressed: () async {
              currentMeal = "Lunch";
              lunchColor = const Color(0xFFFFF79C);
              breakfastColor = const Color(0xFF034D22);
              dinnerColor = const Color(0xFF034D22);
              snackColor = const Color(0xFF034D22);
              posts = await getPosts(currentMeal, providerUser!.friends);
              initRowsAndControllers();
            },
            icon: lunchPhoto),
        IconButton(
            onPressed: () async {
              currentMeal = "Dinner";
              dinnerColor = const Color(0xFFFFF79C);
              lunchColor = const Color(0xFF034D22);
              breakfastColor = const Color(0xFF034D22);
              snackColor = const Color(0xFF034D22);
              posts = await getPosts(currentMeal, providerUser!.friends);
              initRowsAndControllers();
            },
            icon: dinnerPhoto),
        IconButton(
            onPressed: () async {
              currentMeal = "Snack";
              snackColor = const Color(0xFFFFF79C);
              lunchColor = const Color(0xFF034D22);
              dinnerColor = const Color(0xFF034D22);
              breakfastColor = const Color(0xFF034D22);
              posts = await getPosts(currentMeal, providerUser!.friends);
              initRowsAndControllers();
            },
            icon: snackPhoto),
      ]),
    );
  }

  Padding getTextField(
      String helperText,
      TextEditingController controller,
      double width,
      String posterUsername,
      String commenterUsername,
      List post,
      int index) {
    //double height = MediaQuery.of(context).size.height;
    List<Widget> columnBody = [];
    if (post.length > 4) {
      columnBody.add(const Divider(
        thickness: 2,
        color: Color(0xFF034D22),
      ));
    }
    for (int i = 4; i < post.length; i++) {
      String comment = post[i];
      int splitIndex = comment.indexOf(",");
      String username = "@${comment.substring(0, splitIndex)}:   ";
      String commentText = comment.substring(splitIndex + 1);
      Padding commentWidget = Padding(
        padding: EdgeInsets.only(bottom: 3.0),
        child: Row(children: [
          Text(
            username,
            style: const TextStyle(color: Color(0xFF034D22), fontSize: 24),
          ),
          Text(commentText,
              style: const TextStyle(color: Color(0xFF034D22), fontSize: 24))
        ]),
      );
      columnBody.add(commentWidget);
    }
    columnBody.add(const Divider(
      thickness: 2,
      color: Color(0xFF034D22),
    ));
    columnBody.add(
      Row(
        children: [
          Expanded(
            child: TextField(
              style: const TextStyle(color: Color(0xFF034D22)),
              controller: controller,
              decoration: InputDecoration(
                hintText: helperText,
                hintStyle: const TextStyle(
                  color: Color(0xFF034D22),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(width: 3, color: Color(0xFF034D22)),
                  borderRadius: BorderRadius.circular(20), //<-- SEE HERE
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(width: 3, color: Color(0xFF034D22)),
                  borderRadius: BorderRadius.circular(20), //<-- SEE HERE
                ),
              ),
              cursorColor: const Color(0xFF034D22),
            ),
          ),
          IconButton(
              iconSize: 48,
              onPressed: () async {
                String toAdd = await addComment(db, posterUsername,
                    commenterUsername, controller.text, currentMeal);
                controller.clear();
                setState(() {
                  posts![posterUsername]!.add(toAdd);
                });
                updateComments = true;
                indexToUpdate = index;
              },
              icon: const Icon(
                Icons.send,
                color: Color(0xFF94C668),
              )),
        ],
      ),
    );
    // used for padding for non-checkbox items
    var paddingForBox = const EdgeInsets.all(10);
    Padding toReturn = Padding(
      padding: paddingForBox,
      child: Column(
        children: columnBody,
      ),
    );
    return toReturn;
  }

  Future<File?> takeImage(BuildContext context) async {
    final imgPicker = ImagePicker();
    try {
      final pickedFile = await imgPicker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        imageFile = await cropImage(imageFile);
        return imageFile;
        //await storeImage(imageFile);
      } else {
        // User canceled image picking
        print("User canceled their image upload");
      }
    } catch (e) {
      print("Error picking and uploading image: $e");
    }
    return null;
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
                child: IconButton(
                    onPressed: () {
                      mealToPost = "Breakfast";
                      Navigator.pop(context);
                    },
                    icon: Text("Breakfast")),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                    onPressed: () {
                      mealToPost = "Lunch";
                      Navigator.pop(context);
                    },
                    child: Text("Lunch")),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                    onPressed: () {
                      mealToPost = "Dinner";
                      Navigator.pop(context);
                    },
                    child: Text("Dinner")),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                    onPressed: () {
                      mealToPost = "Snack";
                      Navigator.pop(context);
                    },
                    child: Text("Snack")),
              ),
            ]),
          );
        });
  }
}
