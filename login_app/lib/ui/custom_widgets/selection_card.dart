import 'package:flutter/material.dart';
import 'package:login_app/constants.dart';

class SelectionCard extends StatelessWidget {
  final Color backgroundColor;
  final String backgroundHeroTag;
  final String image;
  final Text contentHeader;
  final Text contentText;
  final VoidCallback onTap;

  final double selectionCardHeight = 112.0;
  final double selectionCardBorderRadius = 10.0;

  const SelectionCard({
    @required this.backgroundColor,
    @required this.backgroundHeroTag,
    @required this.contentHeader,
    @required this.contentText,
    @required this.onTap,
    @required this.image,
    Key key,
  })  : assert(backgroundColor != null),
        assert(backgroundHeroTag != null),
        assert(contentHeader != null),
        assert(contentText != null),
        assert(onTap != null),
        assert(image != null),
        super(key: key);

  BorderRadiusGeometry get _selectionCardBorderRadius =>
      BorderRadius.circular(selectionCardBorderRadius);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Material(
          borderRadius: _selectionCardBorderRadius,
          elevation: 8.0,
          child: Hero(
            tag: backgroundHeroTag,
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: _selectionCardBorderRadius,
              ),
              height: selectionCardHeight,
            ),
          ),
        ),
        Material(
          borderRadius: _selectionCardBorderRadius,
          color: Colors.transparent,
          child: InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.black12,
            borderRadius: _selectionCardBorderRadius,
            child: Container(
              padding: const EdgeInsets.all(paddingL),
              child: Row(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      contentHeader,
                    ],
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(paddingS),
                      alignment: Alignment.centerRight,
                      child: Image.asset(
                        image,
                      ),
                    ),
                  ),
                ],
              ),
              height: selectionCardHeight,
              width: MediaQuery.of(context).size.width,
            ),
            onTap: onTap,
          ),
        ),
      ],
    );
  }
}
