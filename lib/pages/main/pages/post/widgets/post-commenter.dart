import 'package:Openbook/models/post.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/avatars/logged_in_user_avatar.dart';
import 'package:Openbook/widgets/avatars/user_avatar.dart';
import 'package:Openbook/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:Openbook/services/httpie.dart';

class OBPostCommenter extends StatefulWidget {
  final Post post;
  final bool autofocus;
  final FocusNode commentTextFieldFocusNode;
  final VoidCallback onPostCommentCreated;

  OBPostCommenter(this.post,
      {this.autofocus = false,
      this.commentTextFieldFocusNode,
      this.onPostCommentCreated});

  @override
  State<StatefulWidget> createState() {
    return OBPostCommenterState();
  }
}

class OBPostCommenterState extends State<OBPostCommenter> {
  TextEditingController _textController;
  bool _commentInProgress;

  UserService _userService;
  ToastService _toastService;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _commentInProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    var provider = OpenbookProvider.of(context);
    _userService = provider.userService;
    _toastService = provider.toastService;

    EdgeInsetsGeometry inputContentPadding =
        EdgeInsets.symmetric(vertical: 8.0, horizontal: 20);

    bool autofocus = widget.autofocus;
    FocusNode focusNode = widget.commentTextFieldFocusNode ?? null;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Color.fromARGB(10, 0, 0, 0)))),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 20.0,
          ),
          OBLoggedInUserAvatar(
            size: OBUserAvatarSize.medium,
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Color.fromARGB(10, 0, 0, 0),
              ),
              child: TextField(
                controller: _textController,
                focusNode: focusNode,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: TextStyle(fontSize: 14.0, color: Colors.black87),
                decoration: InputDecoration(
                  hintText: 'Write something nice...',
                  contentPadding: inputContentPadding,
                  border: InputBorder.none,
                ),
                autofocus: autofocus,
                autocorrect: true,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0, left: 10.0),
            child: OBPrimaryButton(
              isLoading: _commentInProgress,
              isFullWidth: false,
              isSmall: true,
              onPressed: _commentPost,
              child: Text('Post'),
            ),
          )
        ],
      ),
    );
  }

  void _commentPost() async {
    _setCommentInProgress(true);
    try {
      String commentText = _textController.text;
      await _userService.commentPost(text: commentText, post: widget.post);
      _textController.clear();
      _setCommentInProgress(false);
      if (widget.onPostCommentCreated != null) widget.onPostCommentCreated();
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection');
      _setCommentInProgress(false);
    } catch (e) {
      _toastService.error(message: 'Unknown error.');
      _setCommentInProgress(false);
      rethrow;
    }
  }

  void _setCommentInProgress(bool commentInProgress) {
    setState(() {
      _commentInProgress = commentInProgress;
    });
  }
}
