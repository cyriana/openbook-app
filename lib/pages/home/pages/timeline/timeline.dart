import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/home.dart';
import 'package:Openbook/pages/home/lib/base_state.dart';
import 'package:Openbook/pages/home/pages/profile/profile.dart';
import 'package:Openbook/pages/home/pages/timeline//widgets/timeline-posts.dart';
import 'package:Openbook/pages/home/pages/post/post.dart';
import 'package:Openbook/widgets/buttons/floating_action_button.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/nav_bar.dart';
import 'package:Openbook/widgets/post/widgets/post-actions/widgets/post_action_react.dart';
import 'package:Openbook/widgets/routes/slide_right_route.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBTimelinePage extends StatefulWidget {
  final OnWantsToReactToPost onWantsToReactToPost;
  final OnWantsToEditUserProfile onWantsToEditUserProfile;
  final OnWantsToCreatePost onWantsToCreatePost;
  final OnWantsToPickCircles onWantsToPickCircles;
  final OBTimelinePageController controller;

  OBTimelinePage(
      {this.onWantsToReactToPost,
      this.onWantsToCreatePost,
      this.controller,
      this.onWantsToEditUserProfile,
      this.onWantsToPickCircles});

  @override
  OBTimelinePageState createState() {
    return OBTimelinePageState();
  }
}

class OBTimelinePageState extends OBBasePageState<OBTimelinePage> {
  OBTimelinePostsController _timelinePostsController;

  @override
  void initState() {
    super.initState();
    _timelinePostsController = OBTimelinePostsController();
    if (widget.controller != null) widget.controller.attach(this);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: OBNavigationBar(
          title: 'Home',
        ),
        child: OBPrimaryColorContainer(
          child: Stack(
            children: <Widget>[
              OBTimelinePosts(
                  controller: _timelinePostsController,
                  onWantsToReactToPost: widget.onWantsToReactToPost,
                  onWantsToSeeUserProfile: _onWantsToSeeUserProfile,
                  onWantsToCommentPost: _onWantsToCommentPost,
                  onWantsToSeePostComments: _onWantsToSeePostComments),
              Positioned(
                  bottom: 20.0,
                  right: 20.0,
                  child: OBFloatingActionButton(
                      onPressed: () async {
                        Post createdPost = await widget.onWantsToCreatePost();
                        if (createdPost != null) {
                          _timelinePostsController.addPostToTop(createdPost);
                          _timelinePostsController.scrollToTop();
                        }
                      },
                      child: OBIcon(OBIcons.createPost,
                          size: OBIconSize.large, color: Colors.white)))
            ],
          ),
        ));
  }

  void scrollToTop() {
    _timelinePostsController.scrollToTop();
  }

  void _onWantsToSeeUserProfile(User user) async {
    incrementPushedRoutes();
    await Navigator.push(
        context,
        OBSlideRightRoute(
            key: Key('obSlideProfileView'),
            widget: OBProfilePage(
              user,
              onWantsToSeeUserProfile: _onWantsToSeeUserProfile,
              onWantsToSeePostComments: _onWantsToSeePostComments,
              onWantsToCommentPost: _onWantsToCommentPost,
              onWantsToPickCircles: widget.onWantsToPickCircles,
              onWantsToReactToPost: widget.onWantsToReactToPost,
              onWantsToEditUserProfile: widget.onWantsToEditUserProfile,
            )));
    decrementPushedRoutes();
  }

  void _onWantsToCommentPost(Post post) async {
    incrementPushedRoutes();
    await Navigator.push(
        context,
        OBSlideRightRoute(
            key: Key('obSlidePostComments'),
            widget: OBPostPage(post,
                autofocusCommentInput: true,
                onWantsToSeeUserProfile: _onWantsToSeeUserProfile,
                onWantsToReactToPost: widget.onWantsToReactToPost)));
    decrementPushedRoutes();
  }

  void _onWantsToSeePostComments(Post post) async {
    incrementPushedRoutes();
    await Navigator.push(
        context,
        OBSlideRightRoute(
            key: Key('obSlideViewComments'),
            widget: OBPostPage(post,
                onWantsToSeeUserProfile: _onWantsToSeeUserProfile,
                autofocusCommentInput: false,
                onWantsToReactToPost: widget.onWantsToReactToPost)));
    decrementPushedRoutes();
  }
}

class OBTimelinePageController
    extends OBBasePageStateController<OBTimelinePageState> {
  void scrollToTop() {
    state.scrollToTop();
  }
}

typedef Future<Post> OnWantsToCreatePost();