library sidebar_bigeagle;

export 'side_bar_button.dart';
export 'side_bar_button_flat.dart';

import 'package:flutter/material.dart';

import 'side_bar_button.dart';
import 'side_bar_button_flat.dart';

// ignore: prefer_generic_function_type_aliases
typedef IntCallback(int);

// ignore: must_be_immutable
class SideBar extends StatefulWidget {
  /// List of buttons of the Side Bar
  final List<SideBarButtonFlat> children;

  /// Tab callback, index are tab index which is being clicked.
  final IntCallback onChange;

  /// Logo of the app
  final Widget logo;

  /// Should the buttons expand when mouse hover? How much?, 1 is default
  final double onHoverScale;

  /// Background color of the Side Bar
  final Color color;

  final Color backgroundColor;

  /// Accent color of the Side Bar (Text and icons color), white is default.
  final Color accentColor;

  /// The app color, white is default.
  final Color appColor;

  const SideBar(
      {required Key key,
      required this.children,
      required this.logo,
      required this.color,
        required this.backgroundColor,
      this.accentColor = Colors.white,
      this.appColor = Colors.white,
      this.onHoverScale = 1.0,
      required this.onChange})
      : super(key: key);

  @override
  _SideBarState createState() =>
      // ignore: no_logic_in_create_state
      _SideBarState(children: children, logo: logo, color: color, backgroundColor: backgroundColor);
}

class _SideBarState extends State<SideBar> with TickerProviderStateMixin {
  _SideBarState({required this.children, required this.logo, required this.color, required this.backgroundColor});

  Widget logo;
  Color color, backgroundColor;

  static int _selectedIndex = 0;

  List<SideBarButtonFlat> children;

  final List<Widget> _selectedButtonOpen = [];
  final List<Widget> _selectedButtonClosed = [];

  updateButton(int x) {
    setState(() {
      _selectedIndex = x;
      widget.onChange(x);
    });
  }

  void initializeWidgets() {
    for (var element in children) {
      SideBarButton sideBarButtonOpen = SideBarButton(
        title: element.title,
        icon: element.icon,
        onHoverScale: widget.onHoverScale,
        color: widget.color,
        accentColor: widget.accentColor,
        appColor: widget.appColor,
        pressed: true,
        index: children.indexOf(element), updateValue: updateButton,
      );

      SideBarButton sideBarButtonClose = SideBarButton(
        title: element.title,
        icon: element.icon,
        onHoverScale: widget.onHoverScale,
        color: widget.color,
        accentColor: widget.accentColor,
        appColor: widget.appColor,
        pressed: false,
        index: children.indexOf(element),
        updateValue: updateButton,
      );

      _selectedButtonOpen.add(sideBarButtonOpen);
      _selectedButtonClosed.add(sideBarButtonClose);
    }
  }

  @override
  void initState() {
    super.initState();
    initializeWidgets();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
        width: MediaQuery.of(context).size.width/6,
        height: MediaQuery.of(context).size.height,
        //padding: EdgeInsets.zero,
        child: Stack(
          children: [
            Positioned.fill(
              left: -5,
              top: -5,
              bottom: -5,
              child: SizedBox(
                //padding: EdgeInsets.zero,
                width: MediaQuery.of(context).size.width / 6,
                height: MediaQuery.of(context).size.height,
                child: Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(35),
                          bottomRight: Radius.circular(35)
                      )
                  ),
                  elevation: 0.0,
                  color: color,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top:10.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 7,
                          child: logo,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: ListView.builder(
                              itemCount: _selectedButtonOpen.length,
                              shrinkWrap: true,
                              controller: ScrollController(),
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, i)
                              {
                                return _selectedIndex == i
                                      ? _selectedButtonOpen[i]
                                      : _selectedButtonClosed[i];
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
