import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Toast
{
  static const int short = 1;
  static const int long = 2;
  static const int bottom = 0;
  static const int center = 1;
  static const int top = 2;

  static void show(String msg, BuildContext context, { int duration = 1, int gravity = 0, Color backgroundColor = const Color(0xAA000000), Color textColor = Colors.white, double backgroundRadius = 20, required Border border,})
  {
    ToastView.dismiss();
    ToastView.createView(msg, context, duration, gravity, backgroundColor, textColor, backgroundRadius, border);
  }
}

class ToastView
{
  factory ToastView()
  {
    return _singleton;
  }

  ToastView._internal();

  static final ToastView _singleton = ToastView._internal();

  static OverlayState overlayState = OverlayState();
  static OverlayEntry _overlayEntry = OverlayEntry(builder: (BuildContext context) { return const Center(); });
  static bool _isVisible = false;

  static void createView(String msg, BuildContext context, int duration, int gravity, Color background, Color textColor, double backgroundRadius, Border border) async
  {
    overlayState = Overlay.of(context)!;

    final Paint paint = Paint();
    paint.strokeCap = StrokeCap.square;
    paint.color = background;

    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => ToastWidget(
        widget: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            child: Container(
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(backgroundRadius),
                border: border,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Text(msg,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(fontSize: 15, color: textColor)),
            ),
          ),
        ),
        gravity: gravity, key: const Key(""),),
    );
    _isVisible = true;
    overlayState.insert(_overlayEntry);
    await Future<dynamic>.delayed(
        Duration(seconds: duration)
    );
    dismiss();
  }

  static dynamic dismiss() async
  {
    if (!_isVisible)
    {
      return;
    }
    _isVisible = false;
    _overlayEntry.remove();
  }
}

class ToastWidget extends StatelessWidget
{
  const ToastWidget({required Key key, required this.widget, required this.gravity,}) : super(key: key);

  final Widget widget;
  final int gravity;

  @override
  Widget build(BuildContext context)
  {
    return Positioned(
      top: gravity == 2 ? 50 : null,
      bottom: gravity == 0 ? 50 : null,
      child: Material(
        color: Colors.transparent,
        child: widget,
      ),
    );
  }
}
