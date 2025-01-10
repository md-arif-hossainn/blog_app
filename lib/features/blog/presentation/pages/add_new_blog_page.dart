import 'package:flutter/material.dart';

import 'dart:io';

import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/widgets.dart';

class AddNewBlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(
    builder: (context) => const AddNewBlogPage(),
  );
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<String> selectedTopics = [];
  File? image;
  bool isLoading = false;

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  // void uploadBlog() {
  //   if (formKey.currentState!.validate() &&
  //       selectedTopics.isNotEmpty &&
  //       image != null) {
  //     setState(() {
  //       isLoading = true;
  //     });
  //
  //     // Simulate a network request for uploading the blog
  //     Future.delayed(const Duration(seconds: 2), () {
  //       setState(() {
  //         isLoading = false;
  //       });
  //       // Navigate to the BlogPage (Replace this with your navigation logic)
  //       Navigator.pushAndRemoveUntil(
  //         context,
  //         BlogPage.route(),
  //             (route) => false,
  //       );
  //     });
  //   } else {
  //     showSnackBar(context, 'Please fill all fields and select an image.');
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              //uploadBlog();
            },
            icon: const Icon(Icons.done_rounded),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                image != null
                    ? GestureDetector(
                  onTap: selectImage,
                  child: SizedBox(
                    width: double.infinity,
                    height: 150,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        image!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
                    : GestureDetector(
                  onTap: selectImage,
                  child: DottedBorder(
                    color: AppPallete.borderColor,
                    dashPattern: const [10, 4],
                    radius: const Radius.circular(10),
                    borderType: BorderType.RRect,
                    strokeCap: StrokeCap.round,
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.folder_open,
                            size: 40,
                          ),
                          SizedBox(height: 15),
                          Text(
                            'Select your image',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: Constants.topics
                        .map(
                          (e) => Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: GestureDetector(
                          onTap: () {
                            if (selectedTopics.contains(e)) {
                              selectedTopics.remove(e);
                            } else {
                              selectedTopics.add(e);
                            }
                            setState(() {});
                          },
                          child: Chip(
                            label: Text(e),
                            backgroundColor: selectedTopics.contains(e)
                                ? AppPallete.gradient1
                                : null,
                            side: selectedTopics.contains(e)
                                ? null
                                : const BorderSide(
                              color: AppPallete.borderColor,
                            ),
                          ),
                        ),
                      ),
                    )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 10),
                BlogEditor(
                  controller: titleController,
                  hintText: 'Blog title',
                ),
                const SizedBox(height: 10),
                BlogEditor(
                  controller: contentController,
                  hintText: 'Blog content',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

