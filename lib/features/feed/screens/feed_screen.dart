import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/common/post_card.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/features/post/controller/add_post_controller.dart';

class FeedScreen extends ConsumerWidget {
  final sortChoice;
  const FeedScreen(this.sortChoice, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userCommunitiesProvider).when(
        data: (data) => ref.watch(sortChoice == 'top' ? userTopPostsProvider(data) : userPostsProvider(data)).when(
            data: (data) {
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    final post = data[index];
                    return PostCard(post: post);
                  });
            },
            error: (error, stacktrace) => ErrorText(error: error.toString()),
            loading: () => const Loader()),
        error: (error, stacktrace) {
          print(error.toString());
          return ErrorText(error: error.toString());
        },
        loading: () => const Loader());
  }
}
