import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/common/loader.dart';
import '../../../models/community_model.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});

  void navigateToCreateCommunity(BuildContext context){
    Routemaster.of(context).push('/create-community');
  }

  void navigateToCommunity(BuildContext context, Community community){
    Routemaster.of(context).push('/r/${community.name}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
      child: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              ListTile(
                title: const Text('Create community'),
                leading: const Icon(Icons.add),
                onTap: () => navigateToCreateCommunity(context),
              ),
              
              ref.watch(userCommunitiesProvider).when(data: (communities) => Expanded(
                child: ListView.builder(
                  itemCount: communities.length,
                  itemBuilder: (BuildContext context, int index) {
                    final community = communities[index];
                    return ListTile(
                      title: Text('c/${community.name}'),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(community.avatar),
                      ),
                      onTap: (){navigateToCommunity(context, community);},
                    );
                  },
                ),
              ), error: (error, stacktrace) => ErrorText(error: error.toString()), loading: () => const Loader())
            ],
          ),
        ),
      ),
    );
  }
}
