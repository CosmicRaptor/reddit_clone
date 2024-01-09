import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/user_profile/controller/user_profile_controller.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../core/constants/constants.dart';
import '../../../core/utils.dart';
import '../../../theme/pallet.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final String uid;
  const EditProfileScreen({super.key, required this.uid});

  @override
  ConsumerState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {

  late TextEditingController nameController;

  @override
  void initState() {
    nameController = TextEditingController(text: ref.read(userProvider)!.name);
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
  File? bannerFile;
  File? profileFile;
  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null){
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();
    if (res != null){
      setState(() {
        profileFile = File(res.files.first.path!);
      });
    }
  }

  void save(){
    ref.read(userProfileControllerProvider.notifier).editCommunity(profileFile: profileFile, bannerFile: bannerFile, profileWebFile: null, bannerWebFile: null, context: context, name: nameController.text.trim());
  }
  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProfileControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);

    return ref.watch(getUserDataProvider(widget.uid)).when(
        data: (data) => Scaffold(
          backgroundColor: currentTheme.colorScheme.background,
          appBar: AppBar(
            title: const Text('Edit profile'),
            centerTitle: false,
            actions: [TextButton(onPressed: save, child: const Text('Save'))],
          ),
          body: isLoading ? const Loader() : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: selectBannerImage,
                        child: DottedBorder(
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(10),
                            dashPattern: const [10,4],
                            strokeCap: StrokeCap.round,
                            color: currentTheme.textTheme.bodyMedium!.color!,
                            child: Container(
                              width: double.infinity,
                              height: 150,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              child: bannerFile!=null ? Image.file(bannerFile!) :  data.banner.isEmpty ||
                                  Constants.bannerDefault == data.banner
                                  ? const Center(
                                    child: Icon(
                                    Icons.camera_alt_rounded,
                                    size: 40,
                                ),
                              )
                                  : Image.network(data.banner),
                            )),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: GestureDetector(
                          onTap: selectProfileImage,
                          child: profileFile != null ?CircleAvatar(
                            backgroundImage: FileImage(profileFile!),
                            radius: 32,
                          )
                              : CircleAvatar(
                            backgroundImage: NetworkImage(data.profilePic),
                            radius: 32,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: data.name,
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.blue,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(15),
                  ),
                )
              ],
            ),
          ),
        ),
        error: (error, stacktrace) => ErrorText(error: error.toString()),
        loading: () => const Loader());
  }
}
