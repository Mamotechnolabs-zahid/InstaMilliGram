import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instamilligram/providers/user_provider.dart';
import 'package:instamilligram/resources/firestore_methods.dart';
import 'package:instamilligram/responsive/mobile_screen_layout.dart';
import 'package:instamilligram/responsive/responsive_layout.dart';
import 'package:instamilligram/responsive/web_screen_layout.dart';
import 'package:instamilligram/utils/colors.dart';
import 'package:instamilligram/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();

  _selectImage(BuildContext parentContext) async {
    return showCupertinoModalPopup(
      context: parentContext,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: const Text('Create a Post'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(context);
                Uint8List file = await pickImage(ImageSource.camera);
                setState(() {
                  _file = file;
                });
              },
              child: const Text('Take a photo'),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(context);
                Uint8List file = await pickImage(ImageSource.gallery);
                setState(() {
                  _file = file;
                });
              },
              child: const Text('Choose from Gallery'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        );
      },
    );
  }

  void postImage(String uid, String username, String profImage) async {
    setState(() {
      isLoading = true;
    });
    // start the loading
    try {
      // upload to storage and db
      String res = await FireStoreMethods().uploadPost(
        _descriptionController.text,
        _file!,
        uid,
        username,
        profImage,
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        if (context.mounted) {
          showSnackBar(
            context,
            'Posted!',
          );
        }
        clearImage();
        Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ResponsiveLayout(mobileScreenLayout: MobileScreenLayout(),webScreenLayout: WebScreenLayout(),),
                      ),
                    );
      } else {
        if (context.mounted) {
          showSnackBar(context, res);
        }
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return _file == null
        ? Center(
            child: IconButton(
              icon: const Icon(
                Icons.upload,
              ),
              onPressed: () => _selectImage(context),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: clearImage,
              ),
              title: const Text(
                'New Post',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: false,
              actions: <Widget>[
                TextButton(
                  onPressed: () => postImage(
                    userProvider.getUser.uid,
                    userProvider.getUser.username,
                    userProvider.getUser.photoUrl,
                  ),
                  child: const Text(
                    "Share",
                    style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  isLoading ? const LinearProgressIndicator() : const Padding(padding: EdgeInsets.only(top: 0.0)),
                  const Divider(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 100.0,
                        width: 100.0,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: MemoryImage(_file!),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            hintText: "Write a caption...",
                            border: InputBorder.none,
                          ),
                          maxLines: 3,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  // Buttons for additional features
                  ListTile(
                    leading: const Icon(Icons.person_add),
                    title: const Text('Tag People'),
                    onTap: () {
                      // Add functionality for tagging people
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.music_note),
                    title: const Text('Add Music'),
                    onTap: () {
                      // Add functionality for adding music
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.location_on),
                    title: const Text('Add Location'),
                    onTap: () {
                      // Add functionality for adding location
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Advanced Settings'),
                    onTap: () {
                      // Add functionality for advanced settings
                    },
                  ),
                ],
              ),
            ),
          );
  }
}
