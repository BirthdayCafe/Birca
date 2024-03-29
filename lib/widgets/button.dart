import 'package:flutter/material.dart';

class BircaElevatedButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final int fontSize;
  final FontWeight fontWeight;
  final VoidCallback? onPressed;
  final Color color;

  const BircaElevatedButton(
      {super.key,
        this.onPressed,
        required this.text,
        required this.color,
        required this.fontSize,
        required this.textColor,
        required this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style:
      ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(color)),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: fontSize.toDouble(),
            fontWeight: fontWeight,
            color: textColor),
      ),
    );
  }
}

class BircaIconButton extends StatelessWidget {
  final Icon icon;
  final VoidCallback? onPressed;
  final Color? color;
  final String? label;
  final int width;
  final int height;

  const BircaIconButton(
      {super.key,
        required this.icon,
        required this.width,
        required this.height,
        this.onPressed,
        this.color,
        this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width.toDouble(),
        height: height.toDouble(),
        child: IconButton(
          onPressed: onPressed,
          icon: icon,
        ));
  }
}

class BircaFilledButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final Color color;
  final int width;
  final int height;

  const BircaFilledButton({
    super.key,
    required this.text,
    required this.color,
    required this.width,
    required this.height,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width.toDouble(),
      height: height.toDouble(),
      child: FilledButton(
          onPressed: onPressed,
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(color)),
          child: Text(text)),
    );
  }
}

class BircaOutLinedButton extends StatelessWidget{
  final String text;
  final VoidCallback? onPressed;
  final Color radiusColor;
  final Color textColor;
  final int width;
  final int height;
  final int radius;
  final int textSize;
  final FontWeight fontWeight;
  final Color backgroundColor;

  const BircaOutLinedButton({super.key,
    required this.text,
    required this.radiusColor,
    required this.backgroundColor,
    required this.width,
    required this.height,
    required this.radius,
    required this.textColor,
    required this.textSize,
    this.fontWeight = FontWeight.w500,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width.toDouble(),
      height: height.toDouble(),
      child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
              side: BorderSide(color: radiusColor),
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius.toDouble())
              ),
            backgroundColor: backgroundColor
          ),
          child:Text(text,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: TextStyle(
              color: textColor,
              fontSize: textSize.toDouble(),
              fontWeight: fontWeight
            ),)
      ),
    );
  }
}