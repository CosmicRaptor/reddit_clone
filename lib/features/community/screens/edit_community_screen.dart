import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'dart:io';
import '../../../core/common/error_text.dart';
import '../../../theme/pallet.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String name;

  const EditCommunityScreen({required this.name, super.key});

  @override
  ConsumerState createState() => _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
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

  void save(Community community){
    ref.read(communityControllerProvider.notifier).editCommunity(profileFile: profileFile, bannerFile: bannerFile, context: context, community: community);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    return ref.watch(getCommunityByNameProvider(widget.name)).when(
        data: (data) => Scaffold(
              appBar: AppBar(
                title: Text('Edit community'),
                centerTitle: false,
                actions: [TextButton(onPressed: () => save(data), child: Text('Save'))],
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
                                color: Pallete.darkModeAppTheme.textTheme.bodyText2!.color!,
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
                                backgroundImage: NetworkImage(data.avatar),
                                radius: 32,
                              ),
                            ),
                          )
                        ],
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
