import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/theme/pallet.dart';

import '../../../core/common/loader.dart';
import '../../../core/constants/constants.dart';
import '../../../core/utils.dart';
import '../../../models/community_model.dart';

class AddPostScreen extends ConsumerStatefulWidget {
  AddPostScreen({super.key});

  @override
  ConsumerState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends ConsumerState<AddPostScreen> {
  String? widgetChoice;
  File? bannerFile;

  void changeChoice(choice) {
    setState(() {
      widgetChoice = choice;
    });
  }

  List<Community> communities = [];
  final titlecontroller = TextEditingController();
  final descriptioncontroller = TextEditingController();
  final linkcontroller = TextEditingController();
  Community? selectedCommunity;

  @override
  void dispose() {
    titlecontroller.dispose();
    descriptioncontroller.dispose();
    linkcontroller.dispose();
    super.dispose();
  }

  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    print(widgetChoice ?? 'null');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a post'),
        centerTitle: false,
        actions: [TextButton(onPressed: () {}, child: const Text('Post'))],
      ),
      body: Column(
        children: [
          TextField(
            controller: titlecontroller,
            decoration: const InputDecoration(
                filled: true,
                hintText: 'Title',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(18)),
            maxLength: 30,
          ),
          if (widgetChoice == null) const Text('Choose the type of post'),
          if (widgetChoice == null)
            ListTile(
              title: const Text('Text'),
              leading: Radio(
                  value: 'text',
                  groupValue: widgetChoice,
                  onChanged: (value) {
                    changeChoice(value);
                  }),
            ),
          if (widgetChoice == null)
            ListTile(
              title: const Text('Image'),
              leading: Radio(
                value: 'image',
                groupValue: widgetChoice,
                onChanged: (value) {
                  changeChoice(value);
                },
              ),
            ),
          if (widgetChoice == null)
            ListTile(
              title: const Text('Link'),
              leading: Radio(
                value: 'link',
                groupValue: widgetChoice,
                onChanged: (value) {
                  changeChoice(value);
                },
              ),
            ),
          if (widgetChoice == 'text')
            Column(
              children: [
                TextField(
                  controller: descriptioncontroller,
                  decoration: const InputDecoration(
                      filled: true,
                      hintText: 'Title',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(18)),
                  maxLines: 5,
                )
              ],
            ),
          if (widgetChoice == 'image')
            Column(
              children: [
                GestureDetector(
                  onTap: selectBannerImage,
                  child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(10),
                      dashPattern: const [10, 4],
                      strokeCap: StrokeCap.round,
                      color: currentTheme.textTheme.bodyMedium!.color!,
                      child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: bannerFile != null
                              ? Image.file(bannerFile!)
                              : const Center(
                                  child: Icon(
                                    Icons.camera_alt_rounded,
                                    size: 40,
                                  ),
                                ))),
                ),
              ],
            ),
          if (widgetChoice == 'link')
            Column(
              children: [
                TextField(
                  controller: linkcontroller,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.link),
                      filled: true,
                      hintText: 'Link',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(18)),
                ),
              ],
            ),
          const SizedBox(
            height: 20,
          ),
          const Text('Select community'),
          ref.watch(userCommunitiesProvider).when(
              data: (data) {
                communities = data;
                if (data.isEmpty) {
                  return const SizedBox();
                }

                return DropdownButton(
                    value: selectedCommunity ?? data[0],
                    items: data
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.name),
                            ))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedCommunity = val;
                      });
                    });
              },
              error: (error, stacktrace) => ErrorText(error: error.toString()),
              loading: () => const Loader())
        ],
      ),
    );
  }
}
