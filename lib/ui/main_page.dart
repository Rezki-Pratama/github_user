import 'package:flutter/material.dart';
import 'package:infinite_list/ui/page/ui_issues.dart';
import 'package:infinite_list/ui/page/ui_repositories.dart';
import 'package:infinite_list/ui/page/ui_users.dart';
import 'package:infinite_list/utiilities/app_style.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int changed = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: LiquidSwipe(
        pages: [
          Container(color: AppStyle.colorGrey, child: UiUser()),
          Container(color: AppStyle.colorWhite, child: UiIssues()),
          Container(color: AppStyle.colorDark, child: UiRepositories()),
        ],
        enableLoop: true,
        fullTransitionValue: 300,
        enableSlideIcon: true,
        slideIconWidget: Icon(Icons.keyboard_arrow_left,
            color: (changed == 2) ? Colors.grey : AppStyle.colorDark, size: 50),
        onPageChangeCallback: (change) {
          setState(() {
            changed = change;
          });
        },
        waveType: WaveType.liquidReveal,
        positionSlideIcon: 0.5,
      ),
    ));
  }
}
