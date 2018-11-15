import 'package:Openbook/models/post.dart';
import 'package:Openbook/widgets/post/widgets/post-actions/widgets/post_action_comment.dart';
import 'package:Openbook/widgets/post/widgets/post-actions/widgets/post_action_react.dart';
import 'package:flutter/material.dart';

class OBPostActions extends StatelessWidget {
  final Post _post;

  OBPostActions(this._post);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 20.0, top: 10.0),
        height: 65.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            OBPostActionReact(_post),
            SizedBox(width: 20.0,),
            OBPostActionComment(_post)
          ],
        ));
  }
}
