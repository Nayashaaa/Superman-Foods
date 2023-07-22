import 'package:flutter/material.dart';

class NotificationButton extends StatefulWidget {
  final double height, width;
  const NotificationButton({super.key,required this.height,required this.width});

  @override
  State<NotificationButton> createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<NotificationButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Icon(
        Icons.notifications_none,
        size: 28,
      ),
    );
  }
}
