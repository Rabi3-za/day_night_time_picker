import 'package:flutter/material.dart';
import './utils.dart';

class SunMoon extends StatelessWidget {
  final bool isSun;

  final Image sunAsset;
  final Image moonAsset;

  SunMoon({
    this.isSun,
    this.sunAsset,
    this.moonAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SUN_MOON_WIDTH,
      child: AnimatedSwitcher(
        switchInCurve: Curves.ease,
        switchOutCurve: Curves.ease,
        duration: Duration(milliseconds: 250),
        child: isSun
            ? Container(
                key: ValueKey(1),
                child: sunAsset ??
                    AssetImage(
                      "assets/sun.png",
                      package: 'day_night_time_picker',
                    ),
              )
            : Container(
                key: ValueKey(2),
                child: moonAsset ??
                    AssetImage(
                      "assets/moon.png",
                      package: 'day_night_time_picker',
                    ),
              ),
        transitionBuilder: (child, anim) {
          return ScaleTransition(
            scale: anim,
            child: FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: anim.drive(
                  Tween(
                    begin: Offset(0, 4),
                    end: Offset(0, 0),
                  ),
                ),
                child: child,
              ),
            ),
          );
        },
      ),
    );
  }
}