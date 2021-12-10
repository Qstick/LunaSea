import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';

class LunaListTile extends Card {
  static const BASE_HEIGHT = 43.0;
  static const PER_LINE_HEIGHT = 17.0;
  static const TITLE_SPACER_HEIGHT = LunaUI.DEFAULT_MARGIN_SIZE / 4;
  static final double itemExtent = BASE_HEIGHT + LunaUI.MARGIN_CARD.vertical;

  static double heightFromSubtitleLines(int subtitleLines) {
    if (subtitleLines == 0) return BASE_HEIGHT;
    return BASE_HEIGHT +
        TITLE_SPACER_HEIGHT +
        (subtitleLines * PER_LINE_HEIGHT);
  }

  static double extentFromSubtitleLines(int subtitleLines) {
    return heightFromSubtitleLines(subtitleLines) + LunaUI.MARGIN_CARD.vertical;
  }

  LunaListTile({
    Key key,
    @required BuildContext context,
    @required Widget title,
    Widget subtitle,
    Widget trailing,
    Widget leading,
    Color color,
    Decoration decoration,
    Function onTap,
    Function onLongPress,
    bool contentPadding = false,
    bool drawBorder = true,
    double height,
    EdgeInsets margin = LunaUI.MARGIN_CARD,
  }) : super(
          key: key,
          child: Container(
            height: height ??
                (subtitle == null
                    ? heightFromSubtitleLines(0)
                    : heightFromSubtitleLines(1)),
            child: InkWell(
              mouseCursor: onTap != null || onLongPress != null
                  ? SystemMouseCursors.click
                  : null,
              child: Row(
                children: [
                  if (leading != null)
                    SizedBox(
                      width: LunaUI.DEFAULT_MARGIN_SIZE * 4 +
                          LunaUI.DEFAULT_MARGIN_SIZE / 2,
                      child: leading,
                    ),
                  Expanded(
                    child: Padding(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          title,
                          if (subtitle != null)
                            const SizedBox(height: TITLE_SPACER_HEIGHT),
                          if (subtitle != null) subtitle,
                        ],
                      ),
                      padding: EdgeInsets.only(
                        top: LunaUI.DEFAULT_MARGIN_SIZE,
                        bottom: LunaUI.DEFAULT_MARGIN_SIZE,
                        left: leading != null ? 0 : LunaUI.DEFAULT_MARGIN_SIZE,
                        right:
                            trailing != null ? 0 : LunaUI.DEFAULT_MARGIN_SIZE,
                      ),
                    ),
                  ),
                  if (trailing != null)
                    Padding(
                      padding: const EdgeInsets.only(
                        right: LunaUI.DEFAULT_MARGIN_SIZE / 2,
                      ),
                      child: SizedBox(
                        width: LunaUI.DEFAULT_MARGIN_SIZE * 4,
                        child: trailing,
                      ),
                    ),
                ],
              ),
              borderRadius: BorderRadius.circular(LunaUI.BORDER_RADIUS),
              onTap: onTap,
              onLongPress: onLongPress,
            ),
            decoration: decoration,
          ),
          margin: margin,
          elevation: LunaUI.ELEVATION,
          shape: drawBorder ? LunaUI.shapeBorder : LunaShapeBorder.rounded(),
          color: color ?? Theme.of(context).primaryColor,
        );
}
