import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';

class ModToolsScreen extends ConsumerWidget {
  final String name;
  const ModToolsScreen({super.key, required this.name});

  void navigateToEditCommunity(BuildContext context){
    Routemaster.of(context).push('/edit-community/$name');
  }

  void navigateToAddMods(BuildContext context){
    Routemaster.of(context).push('/add-moderator/$name');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref.watch(getCommunityByNameProvider(name)).when(
          data: (community) => NestedScrollView(headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 150,
                floating: true,
                snap: true,
                flexibleSpace: Stack(
                  children: [
                    Positioned.fill(
                        child: Image.network(
                          community.banner,
                          fit: BoxFit.cover,
                        )),
                  ],
                ),
              )
            ];
          },
        body: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.add_moderator),
              title: const Text('Add moderator'),
              onTap: () => navigateToAddMods(context),
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit community'),
              onTap: () => navigateToEditCommunity(context),
            )
          ],
        ),
          ),
        error: (error, stacktrace) => ErrorText(error: error.toString())
          , loading: () => const Loader(),
      )
    );
  }
}
