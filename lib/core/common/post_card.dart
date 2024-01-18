import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../features/auth/controller/auth_controller.dart';
import '../../features/community/controller/community_controller.dart';
import '../../features/post/controller/add_post_controller.dart';
import '../../models/post_model.dart';
import '../../theme/pallet.dart';
import '../constants/constants.dart';
import 'error_text.dart';
import 'loader.dart';

class PostCard extends ConsumerStatefulWidget {
  final Post post;
  const PostCard({
    super.key,
    required this.post,
  });

  @override
  ConsumerState<PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {
  void deletePost(WidgetRef ref, BuildContext context) async {
    ref.read(postControllerProvider.notifier).deletePost(widget.post, context);
  }

  void upvotePost(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).upvote(widget.post);
  }

  void downvotePost(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).downvote(widget.post);
  }

  void awardPost(WidgetRef ref, String award, BuildContext context) async {
    //ref.read(postControllerProvider.notifier).awardPost(post: post, award: award, context: context);
  }

  void navigateToUser(BuildContext context) {
    Routemaster.of(context).push('/u/${widget.post.uid}');
  }

  void navigateToCommunity(BuildContext context) {
    Routemaster.of(context).push('/r/${widget.post.communityName}');
  }

  void navigateToComments(BuildContext context) {
    Routemaster.of(context).push('/post/${widget.post.id}/comments');
  }

  @override
  Widget build(BuildContext context) {
    final isTypeImage = widget.post.type == 'image';
    final isTypeText = widget.post.type == 'text';
    final isTypeLink = widget.post.type == 'link';
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    final currentTheme = ref.watch(themeNotifierProvider);

    return Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: currentTheme.drawerTheme.backgroundColor,
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        color: currentTheme.cardTheme.color ,
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 16,
                        ).copyWith(right: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => navigateToCommunity(context),
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          widget.post.communityProfilePic,
                                        ),
                                        radius: 16,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'c/${widget.post.communityName}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () => navigateToUser(context),
                                            child: Text(
                                              'u/${widget.post.username}',
                                              style: const TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                if (widget.post.uid == user.uid)
                                  IconButton(
                                    onPressed: () => deletePost(ref, context),
                                    icon: Icon(
                                      Icons.delete,
                                      color: Pallete.redColor,
                                    ),
                                  ),
                              ],
                            ),
                            if (widget.post.awards.isNotEmpty) ...[
                              const SizedBox(height: 5),
                              SizedBox(
                                height: 25,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: widget.post.awards.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    final award = widget.post.awards[index];
                                    return Image.asset(
                                      Constants.awards[award]!,
                                      height: 23,
                                    );
                                  },
                                ),
                              ),
                            ],
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                widget.post.title,
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (isTypeImage)
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.35,
                                width: double.infinity,
                                child: Image.network(
                                  widget.post.link!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            if (isTypeLink)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 18),
                                child: AnyLinkPreview(
                                  displayDirection: UIDirection.uiDirectionHorizontal,
                                  link: widget.post.link!,
                                ),
                              ),
                            if (isTypeText)
                              Container(
                                alignment: Alignment.bottomLeft,
                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                child: Text(
                                  widget.post.description!,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (!kIsWeb)
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: isGuest ? () {} : () => upvotePost(ref),
                                        icon: Icon(
                                          Constants.up,
                                          size: 30,
                                          color: widget.post.upvotes.contains(user.uid) ? Pallete.redColor : null,
                                        ),
                                      ),
                                      Text(
                                        '${widget.post.upvotes.length - widget.post.downvotes.length == 0 ? 'Vote' : widget.post.upvotes.length - widget.post.downvotes.length}',
                                        style: const TextStyle(fontSize: 17),
                                      ),
                                      IconButton(
                                        onPressed: isGuest ? () {} : () => downvotePost(ref),
                                        icon: Icon(
                                          Constants.down,
                                          size: 30,
                                          color: widget.post.downvotes.contains(user.uid) ? Pallete.blueColor : null,
                                        ),
                                      ),
                                    ],
                                  ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () => navigateToComments(context),
                                      icon: const Icon(
                                        Icons.comment,
                                      ),
                                    ),
                                    Text(
                                      '${widget.post.commentCount == 0 ? 'Comment' : widget.post.commentCount}',
                                      style: const TextStyle(fontSize: 17),
                                    ),
                                  ],
                                ),
                                ref.watch(getCommunityByNameProvider(widget.post.communityName)).when(
                                  data: (data) {
                                    if (data.mods.contains(user.uid)) {
                                      return IconButton(
                                        onPressed: () => deletePost(ref, context),
                                        icon: const Icon(
                                          Icons.admin_panel_settings,
                                        ),
                                      );
                                    }
                                    return const SizedBox();
                                  },
                                  error: (error, stackTrace) => ErrorText(
                                    error: error.toString(),
                                  ),
                                  loading: () => const Loader(),
                                ),
                                IconButton(
                                  onPressed: isGuest
                                      ? () {}
                                      : () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => Dialog(
                                        child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: GridView.builder(
                                            shrinkWrap: true,
                                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 4,
                                            ),
                                            itemCount: user.awards.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              final award = user.awards[index];

                                              return GestureDetector(
                                                onTap: () => awardPost(ref, award, context),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Image.asset(Constants.awards[award]!),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.card_giftcard_outlined),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      );
  }
}