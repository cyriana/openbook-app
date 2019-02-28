import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:flutter/material.dart';

class OBInviteUserToCommunityButton extends StatefulWidget {
  final User user;
  final Community community;

  OBInviteUserToCommunityButton(
      {@required this.user, @required this.community});

  @override
  OBInviteUserToCommunityButtonState createState() {
    return OBInviteUserToCommunityButtonState();
  }
}

class OBInviteUserToCommunityButtonState
    extends State<OBInviteUserToCommunityButton> {
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

    User loggedInUser = _userService.getLoggedInUser();

    return StreamBuilder(
      stream: loggedInUser.updateSubject,
      builder:
          (BuildContext context, AsyncSnapshot<User> loggedInUserSnapshot) {
        User latestLoggedInUser = loggedInUserSnapshot.data;
        if (latestLoggedInUser == null) return const SizedBox();

        return StreamBuilder(
          stream: widget.user.updateSubject,
          builder:
              (BuildContext context, AsyncSnapshot<User> latestUserSnapshot) {
            User latestUser = latestUserSnapshot.data;
            if (latestUser == null) return const SizedBox();

            bool loggedInUserInvitedUserToCommunity =
                latestLoggedInUser.hasInvitedUserToCommunity(
                    user: latestUser, community: widget.community);
            bool isCommunityMember =
                latestUser.isMemberOfCommunity(widget.community);
            bool isInvitedToCommunity =
                latestUser.isInvitedToCommunity(widget.community);

            if (isCommunityMember) {
              return _buildAlreadyMemberButton();
            }

            return loggedInUserInvitedUserToCommunity || isInvitedToCommunity
                ? _buildUninviteUserToCommunityButton()
                : _buildInviteUserToCommunityButton();
          },
        );
      },
    );
  }

  Widget _buildInviteUserToCommunityButton() {
    return OBButton(
      size: OBButtonSize.small,
      type: OBButtonType.primary,
      isLoading: _requestInProgress,
      onPressed: _inviteUser,
      child: Text('Invite'),
    );
  }

  Widget _buildUninviteUserToCommunityButton() {
    return OBButton(
      size: OBButtonSize.small,
      type: OBButtonType.highlight,
      isLoading: _requestInProgress,
      onPressed: _uninviteUser,
      child: Text('Uninvite'),
    );
  }

  Widget _buildAlreadyMemberButton() {
    return OBButton(
      size: OBButtonSize.small,
      type: OBButtonType.highlight,
      isDisabled: true,
      isLoading: _requestInProgress,
      onPressed: () {},
      child: Text('Member'),
    );
  }

  void _inviteUser() async {
    _setRequestInProgress(true);
    try {
      await _userService.inviteUserToCommunity(
          user: widget.user, community: widget.community);
    } catch (e) {
      _onRequestError(e);
    } finally {
      _setRequestInProgress(false);
    }
  }

  void _uninviteUser() async {
    _setRequestInProgress(true);
    try {
      await _userService.uninviteUserFromCommunity(
          user: widget.user, community: widget.community);
    } catch (e) {
      _onRequestError(e);
    } finally {
      _setRequestInProgress(false);
    }
  }

  void _onRequestError(error) {
    if (error is HttpieConnectionRefusedError) {
      _toastService.error(message: 'No internet connection', context: context);
    } else {
      _toastService.error(message: 'Unknown error', context: context);
    }
    throw error;
  }

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }
}