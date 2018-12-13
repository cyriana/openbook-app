import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:flutter/material.dart';

class OBProfileActionFollow extends StatefulWidget {
  final User user;

  OBProfileActionFollow(this.user);

  @override
  OBProfileActionFollowState createState() {
    return OBProfileActionFollowState();
  }
}

class OBProfileActionFollowState extends State<OBProfileActionFollow> {
  UserService _userService;
  ToastService _toastService;
  bool _requestInProgress;

  @override
  void initState() {
    super.initState();
    _requestInProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;

    return StreamBuilder(
      stream: widget.user.updateSubject,
      initialData: widget.user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        var user = snapshot.data;

        if (user?.isFollowing == null) return SizedBox();

        return user.isFollowing ? _buildUnfollowButton() : _buildFollowButton();
      },
    );
  }

  Widget _buildFollowButton() {
    return OBButton(
      child: Text(
        'Follow',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      isLoading: _requestInProgress,
      onPressed: _followUser,
    );
  }

  Widget _buildUnfollowButton() {
    return OBButton(
      child: Text(
        'Unfollow',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      isLoading: _requestInProgress,
      onPressed: _unFollowUser,
    );
  }

  void _followUser() async {
    _setRequestInProgress(true);
    try {
      await _userService.followUserWithUsername(widget.user.username);
      widget.user.incrementFollowersCount();
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection', context: context);
    } catch (e) {
      _toastService.error(message: 'Unknown error', context: context);
      rethrow;
    } finally {
      _setRequestInProgress(false);
    }
  }

  void _unFollowUser() async {
    _setRequestInProgress(true);
    try {
      await _userService.unFollowUserWithUsername(widget.user.username);
      widget.user.decrementFollowersCount();
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection', context: context);
    } catch (e) {
      _toastService.error(message: 'Unknown error', context: context);
    } finally {
      _setRequestInProgress(false);
    }
  }

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }
}