import 'package:flutter/material.dart';
import 'package:login_app/constants.dart';


class CustomDialog extends StatelessWidget {
  final String title;
  final Image image;
  final Widget description;
  final List<Widget> actions;

  CustomDialog({
    @required this.title,
    @required this.description,
    this.actions,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(paddingS),
      ),      
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
  return Stack(
    children: <Widget>[
      Container(
        padding: EdgeInsets.only(
          top: Consts.avatarRadius + Consts.padding,
          bottom: Consts.padding,
          left: Consts.padding,
          right: Consts.padding,
        ),
        margin: EdgeInsets.only(top: Consts.avatarRadius),
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(Consts.padding),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: const Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // To make the card compact
          children: <Widget>[
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline.copyWith(
                color: darkestBlueColor,
              )
            ),
            SizedBox(height: 16.0),
            description,
            SizedBox(height: 24.0),
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: actions,
              ),
            ),
          ],
        ),
      ),

      Positioned(
        left: Consts.padding,
        right: Consts.padding,
        child: Container(
          height: 150.0,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5.0,
                offset: const Offset(0.0, 6.0),
              ),
            ],
            shape: BoxShape.circle,
            color: lightBlueColor,
          ),
          padding: EdgeInsets.all(26.0),
          child: Image.asset(
            'assets/images/report_icon.png',
          ),
        ),
      ),

    ],
  );
}
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 75.0;
}