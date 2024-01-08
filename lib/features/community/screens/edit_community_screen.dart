import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';

import '../../../core/common/error_text.dart';
import '../../../theme/pallet.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String name;

  const EditCommunityScreen({required this.name, super.key});

  @override
  ConsumerState createState() => _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(getCommunityByNameProvider(widget.name)).when(
        data: (data) => Scaffold(
              appBar: AppBar(
                title: Text('Edit community'),
                centerTitle: false,
                actions: [TextButton(onPressed: () {}, child: Text('Save'))],
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: Stack(
                        children: [
                          DottedBorder(
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
                                child: data.banner.isEmpty ||
                                        Constants.bannerDefault == data.banner
                                    ? const Center(
                                        child: Icon(
                                          Icons.camera_alt_rounded,
                                          size: 40,
                                        ),
                                      )
                                    : Image.network(data.banner),
                              )),
                          Positioned(
                            bottom: 20,
                            left: 20,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(data.avatar),
                              radius: 32,
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
