import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';

class LSBottomNavigationBar extends StatelessWidget {
    final int index;
    final Function onTap;
    final List<IconData> icons;
    final List<String> titles;
    final List<Widget> leadingOnGButton;

    LSBottomNavigationBar({
        @required this.index,
        @required this.onTap,
        @required this.icons,
        @required this.titles,
        this.leadingOnGButton,
    });

    @override
    Widget build(BuildContext context) => Container(
        child: SafeArea(
            top: false,
            child: Padding(
                child: GNav(
                    gap: 8.0,
                    iconSize: 24.0,
                    padding: EdgeInsets.fromLTRB(18.0, 10.0, 12.0, 10.0),
                    duration: Duration(milliseconds: LunaUI.ANIMATION_SPEED),
                    tabBackgroundColor: Theme.of(context).canvasColor,
                    activeColor: LunaColours.accent,
                    tabs: List.generate(
                        icons.length,
                        (index) => GButton(
                            icon: icons[index],
                            text: titles[index],
                            iconSize: 22.0,
                            haptic: true,
                            iconColor: Colors.white,
                            textStyle: TextStyle(
                                fontWeight: LunaUI.FONT_WEIGHT_BOLD,
                                fontSize: Constants.UI_FONT_SIZE_SUBTITLE,
                                color: LunaColours.accent,
                            ),
                            leading: leadingOnGButton == null ? null : leadingOnGButton[index],
                        )
                    ).toList(),
                    tabActiveBorder: LunaDatabaseValue.THEME_AMOLED.data && LunaDatabaseValue.THEME_AMOLED_BORDER.data ? Border.all(color: Colors.white12) : null,
                    selectedIndex: index,
                    onTabChange: onTap,
                ),
                padding: EdgeInsets.all(12.0),
            ),
        ),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
        ),
    );
}