import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';

class LunaExpandableListTile extends StatefulWidget {
  final String title;
  final List<TextSpan> collapsedSubtitles;
  final Widget collapsedTrailing;
  final Widget collapsedLeading;
  final double collapsedHeight;
  final Color backgroundColor;
  final Function onLongPress;
  final List<LunaHighlightedNode> expandedHighlightedNodes;
  final List<LunaTableContent> expandedTableContent;
  final List<LunaButton> expandedTableButtons;
  final bool initialExpanded;

  /// Create a [LunaExpandableListTile] which is a list tile that expands into a table-style card.
  ///
  /// If [expandedWidget] is supplied, that widget is used as the body within the expanded card.
  /// Any
  LunaExpandableListTile({
    Key key,
    @required this.title,
    @required this.collapsedSubtitles,
    @required this.expandedTableContent,
    this.collapsedTrailing,
    this.collapsedLeading,
    this.collapsedHeight,
    this.onLongPress,
    this.expandedHighlightedNodes,
    this.expandedTableButtons,
    this.backgroundColor,
    this.initialExpanded = false,
  }) : super(key: key) {
    assert(title != null);
    assert(collapsedSubtitles != null);
    assert(expandedTableContent != null);
  }

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<LunaExpandableListTile> {
  ExpandableController controller;

  @override
  void initState() {
    super.initState();
    controller = ExpandableController(initialExpanded: widget.initialExpanded);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      controller: controller,
      child: Expandable(
        collapsed: collapsed(),
        expanded: expanded(),
      ),
    );
  }

  List<TextSpan> _parseSubtitles() {
    if (widget.collapsedSubtitles.isEmpty) return [];
    List<TextSpan> _result = [];
    for (int i = 0; i < widget.collapsedSubtitles.length; i++) {
      _result.add(widget.collapsedSubtitles[i]);
      if (i != widget.collapsedSubtitles.length - 1) {
        _result.add(const TextSpan(text: '\n'));
      }
    }
    return _result;
  }

  Widget collapsed() {
    return LunaListTile(
      context: context,
      title: LunaText.title(text: widget.title ?? LunaUI.TEXT_EMDASH),
      subtitle: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: LunaUI.FONT_SIZE_H3,
            color: Colors.white70,
          ),
          children: _parseSubtitles(),
        ),
        overflow: TextOverflow.fade,
        softWrap: false,
        maxLines: widget.collapsedSubtitles.length,
      ),
      height: widget.collapsedHeight,
      onTap: controller.toggle,
      onLongPress: widget.onLongPress,
      contentPadding: widget.collapsedSubtitles.length > 1,
      trailing: widget.collapsedTrailing,
      leading: widget.collapsedLeading,
      color: widget.backgroundColor,
    );
  }

  Widget expanded() {
    return LunaCard(
      context: context,
      child: InkWell(
        child: Padding(
          padding: EdgeInsets.only(
            top: LunaUI.DEFAULT_MARGIN_SIZE,
            bottom: widget.expandedTableButtons?.isEmpty ?? true
                ? (LunaUI.DEFAULT_MARGIN_SIZE / 4 * 3)
                : LunaUI.DEFAULT_MARGIN_SIZE / 2,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      child: LunaText.title(
                        text: widget.title ?? LunaUI.TEXT_EMDASH,
                        softWrap: true,
                        maxLines: 8,
                      ),
                      padding: const EdgeInsets.only(
                        left: LunaUI.DEFAULT_MARGIN_SIZE,
                        right: LunaUI.DEFAULT_MARGIN_SIZE,
                        bottom: LunaUI.DEFAULT_MARGIN_SIZE / 2,
                      ),
                    ),
                    if (widget.expandedHighlightedNodes != null)
                      Padding(
                        child: Wrap(
                          direction: Axis.horizontal,
                          spacing: LunaUI.DEFAULT_MARGIN_SIZE / 2,
                          runSpacing: LunaUI.DEFAULT_MARGIN_SIZE / 2,
                          children: widget.expandedHighlightedNodes,
                        ),
                        padding: const EdgeInsets.only(
                          left: LunaUI.DEFAULT_MARGIN_SIZE,
                          right: LunaUI.DEFAULT_MARGIN_SIZE,
                          bottom: LunaUI.DEFAULT_MARGIN_SIZE / 2,
                        ),
                      ),
                    ...widget.expandedTableContent
                        .map((child) => Padding(
                              child: child,
                              padding: const EdgeInsets.symmetric(
                                horizontal: LunaUI.DEFAULT_MARGIN_SIZE,
                              ),
                            ))
                        .toList(),
                    if (widget.expandedTableButtons != null)
                      Padding(
                        child: Wrap(
                          children: [
                            ...List.generate(
                              widget.expandedTableButtons.length,
                              (index) {
                                int bCount = widget.expandedTableButtons.length;
                                double widthFactor = 0.5;

                                if (index == (bCount - 1) && bCount.isOdd) {
                                  widthFactor = 1;
                                }

                                return FractionallySizedBox(
                                  child: widget.expandedTableButtons[index],
                                  widthFactor: widthFactor,
                                );
                              },
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: LunaUI.DEFAULT_MARGIN_SIZE / 2,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        borderRadius: BorderRadius.circular(LunaUI.BORDER_RADIUS),
        onTap: controller.toggle,
        onLongPress: widget.onLongPress,
      ),
      color: widget.backgroundColor,
    );
  }
}
