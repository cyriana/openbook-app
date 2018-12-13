import 'package:Openbook/models/post.dart';
import 'package:Openbook/pages/home/pages/post/widgets/post_comment/post_comment.dart';
import 'package:Openbook/widgets/post/widgets/post-actions/post_actions.dart';
import 'package:Openbook/widgets/post/widgets/post-actions/widgets/post_action_comment.dart';
import 'package:Openbook/widgets/post/widgets/post-actions/widgets/post_action_react.dart';
import 'package:Openbook/widgets/post/widgets/post-body/post_body.dart';
import 'package:Openbook/widgets/post/widgets/post_comments/post_comments.dart';
import 'package:Openbook/widgets/post/widgets/post_header.dart';
import 'package:Openbook/widgets/post/widgets/post_reactions/post_reactions.dart';
import 'package:Openbook/widgets/theming/divider.dart';
import 'package:flutter/material.dart';

class OBPost extends StatelessWidget {
  final Post _post;
  final OnWantsToCommentPost onWantsToCommentPost;
  final OnWantsToReactToPost onWantsToReactToPost;
  final OnWantsToSeePostComments onWantsToSeePostComments;
  final OnWantsToSeeUserProfile onWantsToSeeUserProfile;

  OBPost(this._post,
      {this.onWantsToReactToPost,
      this.onWantsToCommentPost,
      this.onWantsToSeePostComments,
      this.onWantsToSeeUserProfile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        OBPostHeader(_post, onWantsToSeeUserProfile: onWantsToSeeUserProfile),
        OBPostBody(_post),
        OBPostReactions(_post),
        OBPostComments(
          _post,
          onWantsToSeePostComments: onWantsToSeePostComments,
        ),
        OBPostActions(
          _post,
          onWantsToCommentPost: onWantsToCommentPost,
          onWantsToReactToPost: onWantsToReactToPost,
        ),
        SizedBox(
          height: 16,
        )
      ],
    );
  }
}