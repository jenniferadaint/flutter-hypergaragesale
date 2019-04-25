import 'package:flutter/material.dart';

// used to generate delay animation when uploading images
class ProgressDialog extends StatelessWidget {
  final Widget child;
  final bool loading;
  final String msg;
  final Widget progress;
  final double alpha;
  final Color textColor;

  ProgressDialog(
      {Key key,
        @required this.loading,
        this.msg,
        this.progress = const CircularProgressIndicator(),
        this.alpha = 0.6,
        this.textColor = Colors.white,
        @required this.child})
      : assert(child != null),
        assert(loading != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    widgetList.add(child);
    if (loading) {
      Widget layoutProgress;
      if (msg == null) {
        layoutProgress = Center(
          child: progress,
        );
      } else {
        layoutProgress = Center(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(4.0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                progress,
                Container(
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                  child: Text(
                    msg,
                    style: TextStyle(color: textColor, fontSize: 16.0),
                  ),
                )
              ],
            ),
          ),
        );
      }
      widgetList.add(Opacity(
        opacity: alpha,
        child: new ModalBarrier(color: Colors.black87),
      ));
      widgetList.add(layoutProgress);
    }
    return Stack(
      children: widgetList,
    );
  }
}
