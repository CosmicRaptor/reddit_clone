import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/common/post_card.dart';
import '../../../models/community_model.dart';

class CommunityScreen extends ConsumerWidget {
  final String name;
  const CommunityScreen({super.key, required this.name});

  void navigateTOModTools(BuildContext context) {
    Routemaster.of(context).push('/mod-tools/$name');
  }

  void joinCommunity(WidgetRef ref, Community community, BuildContext context) {
    ref
        .read(communityControllerProvider.notifier)
        .joinCommunity(community, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      body: ref.watch(getCommunityByNameProvider(name)).when(
          data: (data) => NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 150,
                    floating: true,
                    snap: true,
                    flexibleSpace: Stack(
                      children: [
                        Positioned.fill(
                            child: Image.network(
                          data.banner,
                          fit: BoxFit.cover,
                        ))
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Align(
                              alignment: Alignment.topLeft,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(data.avatar),
                                radius: 35,
                              )),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'r/${data.name}',
                                style: const TextStyle(
                                    fontSize: 19, fontWeight: FontWeight.bold),
                              ),
                              data.mods.contains(user.uid)
                                  ? OutlinedButton(
                                      onPressed: () {
                                        navigateTOModTools(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20))),
                                      child: const Text('Mod Tools'))
                                  : OutlinedButton(
                                      onPressed: () =>
                                          joinCommunity(ref, data, context),
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20))),
                                      child: Text(
                                          data.members.contains(user.uid)
                                              ? 'Joined'
                                              : 'Join'))
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text('${data.members.length} members'),
                          )
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: ref.watch(getCommunityPostsProvider(name)).when(data: (data){
        return ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              final post = data[index];
              return PostCard(post: post);
            });
      }, error: (error, stacktrace)
      { print(error.toString());
      return ErrorText(error: error.toString());
      }, loading: ()=>const Loader())),
          error: (error, stacktrace) => ErrorText(error: error.toString()),
          loading: () => const Loader()),
    );
  }
}
