import 'package:Openbook/models/theme.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/theme_value_parser.dart';
import 'package:flutter/material.dart';

class OBButton extends StatelessWidget {
  final Widget child;
  final Widget icon;
  final VoidCallback onPressed;
  final bool isDisabled;
  final bool isLoading;
  final OBButtonSize size;
  final double minWidth;
  final EdgeInsets padding;
  final OBButtonType type;
  final ShapeBorder shape;
  final double minHeight;
  final List<BoxShadow> boxShadow;

  const OBButton(
      {@required this.child,
      @required this.onPressed,
      this.minHeight,
      this.minWidth,
      this.type = OBButtonType.primary,
      this.icon,
      this.size = OBButtonSize.medium,
      this.shape,
      this.boxShadow,
      this.isDisabled = false,
      this.isLoading = false,
      this.padding});

  @override
  Widget build(BuildContext context) {
    var provider = OpenbookProvider.of(context);
    var themeService = provider.themeService;
    var themeValueParser = provider.themeValueParserService;
    EdgeInsets buttonPadding = _getButtonPaddingForSize(size);
    double buttonMinWidth = minWidth ?? _getButtonMinWidthForSize(size);
    double buttonMinHeight = minHeight ?? 20;
    var finalOnPressed = isLoading || isDisabled ? () {} : onPressed;
    return StreamBuilder(
        stream: themeService.themeChange,
        initialData: themeService.getActiveTheme(),
        builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
          var theme = snapshot.data;
          Color buttonTextColor = _getButtonTextColorForType(type,
              themeValueParser: themeValueParser, theme: theme);
          Gradient gradient = _getButtonGradientForType(type,
              themeValueParser: themeValueParser, theme: theme);

          var buttonChild =
              isLoading ? _getLoadingIndicator(buttonTextColor) : child;

          if (isDisabled)
            buttonChild = Opacity(opacity: 0.5, child: buttonChild);

          if (icon != null && !isLoading) {
            buttonChild = Row(
              children: <Widget>[
                icon,
                SizedBox(
                  width: 5,
                ),
                buttonChild
              ],
            );
          }

          return GestureDetector(
            child: Container(
                constraints: BoxConstraints(
                    minWidth: buttonMinWidth, minHeight: buttonMinHeight),
                decoration: BoxDecoration(
                    boxShadow: boxShadow ?? [],
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(50.0)),
                child: Material(
                  color: Colors.transparent,
                  textStyle: TextStyle(color: buttonTextColor),
                  child: Padding(
                    padding: buttonPadding,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[buttonChild],
                    ),
                  ),
                )),
            onTap: finalOnPressed,
          );
        });
  }

  Widget _getLoadingIndicator(Color color) {
    return SizedBox(
      height: 15.0,
      width: 15.0,
      child: CircularProgressIndicator(
          strokeWidth: 2.0, valueColor: AlwaysStoppedAnimation<Color>(color)),
    );
  }

  Gradient _getButtonGradientForType(OBButtonType type,
      {@required ThemeValueParserService themeValueParser,
      @required OBTheme theme}) {
    Gradient buttonGradient;

    switch (type) {
      case OBButtonType.danger:
        buttonGradient = themeValueParser.parseGradient(theme.dangerColor);
        break;
      case OBButtonType.primary:
        buttonGradient =
            themeValueParser.parseGradient(theme.primaryAccentColor);
        break;
      case OBButtonType.success:
        buttonGradient = themeValueParser.parseGradient(theme.successColor);
        break;
      default:
    }

    return buttonGradient;
  }

  Color _getButtonTextColorForType(OBButtonType type,
      {@required ThemeValueParserService themeValueParser,
      @required OBTheme theme}) {
    Color buttonTextColor;

    switch (type) {
      case OBButtonType.danger:
        buttonTextColor = themeValueParser.parseColor(theme.dangerColorAccent);
        break;
      case OBButtonType.primary:
        buttonTextColor = Colors.white;
        break;
      case OBButtonType.success:
        buttonTextColor = themeValueParser.parseColor(theme.successColorAccent);
        break;
      default:
    }

    return buttonTextColor;
  }

  EdgeInsets _getButtonPaddingForSize(OBButtonSize type) {
    if (padding != null) return padding;

    EdgeInsets buttonPadding;

    switch (size) {
      case OBButtonSize.large:
        buttonPadding = EdgeInsets.symmetric(vertical: 10, horizontal: 20.0);
        break;
      case OBButtonSize.medium:
        buttonPadding = EdgeInsets.symmetric(vertical: 8, horizontal: 12);
        break;
      case OBButtonSize.small:
        buttonPadding = EdgeInsets.symmetric(vertical: 6, horizontal: 2);
        break;
      default:
    }

    return buttonPadding;
  }

  double _getButtonMinWidthForSize(OBButtonSize type) {
    if (minWidth != null) return minWidth;

    double buttonMinWidth;

    switch (size) {
      case OBButtonSize.large:
      case OBButtonSize.medium:
        buttonMinWidth = 100;
        break;
      case OBButtonSize.small:
        buttonMinWidth = 70;
        break;
      default:
    }

    return buttonMinWidth;
  }
}

enum OBButtonType { primary, success, danger }

enum OBButtonSize { small, medium, large }