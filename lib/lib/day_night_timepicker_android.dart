import 'package:day_night_time_picker/lib/ampm.dart';
import 'package:day_night_time_picker/lib/common/action_buttons.dart';
import 'package:day_night_time_picker/lib/common/display_value.dart';
import 'package:day_night_time_picker/lib/common/wrapper_container.dart';
import 'package:day_night_time_picker/lib/common/wrapper_dialog.dart';
import 'package:day_night_time_picker/lib/daynight_banner.dart';
import 'package:day_night_time_picker/lib/common/filter_wrapper.dart';
import 'package:day_night_time_picker/lib/state/state_container.dart';
import 'package:day_night_time_picker/lib/utils.dart';
import 'package:flutter/material.dart';

/// Private class. [StatefulWidget] that renders the content of the picker.
// ignore: must_be_immutable
class DayNightTimePickerAndroid extends StatefulWidget {
  final TextStyle? myStyle;

  const DayNightTimePickerAndroid({Key? key, this.myStyle}) : super(key: key);

  @override
  DayNightTimePickerAndroidState createState() => DayNightTimePickerAndroidState();
}

/// Picker state class
class DayNightTimePickerAndroidState extends State<DayNightTimePickerAndroid> {
  double myHourValue = DateTime.now().hour.toDouble() + 1;

  @override
  Widget build(BuildContext context) {
    final timeState = TimeModelBinding.of(context);

    double min = getMinMinute(timeState.widget.minMinute, timeState.widget.minuteInterval);
    double max = getMaxMinute(timeState.widget.maxMinute, timeState.widget.minuteInterval);

    int minDiff = (max - min).round();
    int divisions = getMinuteDivisions(minDiff, timeState.widget.minuteInterval);

    if (timeState.hourIsSelected) {
      min = timeState.widget.minHour!;
      max = timeState.widget.maxHour!;
      divisions = (max - min).round();
    }

    final color = timeState.widget.accentColor ?? Theme.of(context).colorScheme.secondary;

    final hourValue = timeState.widget.is24HrFormat ? timeState.time.hour : timeState.time.hourOfPeriod;

    final ltrMode = timeState.widget.ltrMode ? TextDirection.ltr : TextDirection.rtl;

    final hideButtons = timeState.widget.hideButtons;

    Orientation currentOrientation = MediaQuery.of(context).orientation;

    return Center(
      child: SingleChildScrollView(
        physics: currentOrientation == Orientation.portrait ? const NeverScrollableScrollPhysics() : const AlwaysScrollableScrollPhysics(),
        child: FilterWrapper(
          child: WrapperDialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const DayNightBanner(),
                WrapperContainer(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const AmPm(),
                      Expanded(
                        child: Row(
                          textDirection: ltrMode,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            DisplayValue(
                              myStyle: widget.myStyle,
                              onTap: timeState.widget.disableHour!
                                  ? null
                                  : () {
                                      timeState.onHourIsSelectedChange(true);
                                    },
                              value: hourValue.toString().padLeft(2, '0'),
                              isSelected: timeState.hourIsSelected,
                            ),
                            DisplayValue(
                              value: ":",
                              myStyle: widget.myStyle,
                            ),
                            DisplayValue(
                              myStyle: widget.myStyle,
                              onTap: timeState.widget.disableMinute!
                                  ? null
                                  : () {
                                      timeState.onHourIsSelectedChange(false);
                                    },
                              value: timeState.time.minute.toString().padLeft(2, '0'),
                              isSelected: !timeState.hourIsSelected,
                            ),
                          ],
                        ),
                      ),
                      Slider(
                        onChangeEnd: (value) {
                          if (timeState.widget.isOnValueChangeMode) {
                            timeState.onOk();
                          }
                        },
                        value: timeState.hourIsSelected ? timeState.time.hour.roundToDouble() : DateTime.now().hour.toDouble() + 1 == myHourValue && min > timeState.time.minute.roundToDouble()
                                ? DateTime.now().minute.roundToDouble()
                                : timeState.time.minute.roundToDouble(),
                        onChanged: (value) {
                          if (timeState.hourIsSelected) {
                            myHourValue = value;
                            setState(() {});
                          }
                          timeState.onTimeChange(value);
                        },
                        min: timeState.hourIsSelected
                            ? min
                            : DateTime.now().hour.toDouble() + 1 == myHourValue
                                ? DateTime.now().minute.toDouble()
                                : 0.0,
                        max: max,
                        divisions: divisions,
                        activeColor: color,
                        inactiveColor: color.withAlpha(55),
                      ),
                      if (!hideButtons) const ActionButtons(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
