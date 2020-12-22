import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';

class LSDivider extends StatelessWidget {
    @override
    Widget build(BuildContext context) => Divider(
        thickness: 1.0,
        color: LunaColours.splash,
        indent: 60.0,
        endIndent: 60.0,
    );
}
