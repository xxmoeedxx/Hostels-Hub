import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:db_project/services/database_service.dart';
import 'package:flutter/material.dart';

final DatabaseService _db = DatabaseService();
Booking? bk;

class BookingButton extends StatefulWidget {
  @override
  _BookingButtonState createState() => _BookingButtonState();
  final String userId;
  final String hostelId;
  final Timestamp timestamp;
  BookingButton(
      {Key? key,
      required this.hostelId,
      required this.timestamp,
      required this.userId})
      : super(key: key);
}

class _BookingButtonState extends State<BookingButton>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _rotationAnimation;

  Future<void> initB() async {
    bk = await _db.getBookingInfo(widget.userId, widget.hostelId);
    setState(() {
      if (bk != null) {
        _isButtonDisabled = true;
      }
    });
  }

  bool _isButtonDisabled = false;
  bool _isButtonTapped = false;
  @override
  void initState() {
    initB();
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 360.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
        reverseCurve: Curves.easeInOut,
      ),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
        reverseCurve: Curves.easeInOut,
      ),
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
        reverseCurve: Curves.easeInOut,
      ),
    );

    _controller.addListener(() {
      if (_controller.status == AnimationStatus.completed) {
        setState(() {
          _isButtonDisabled = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onButtonPressed() {
    if (_isButtonDisabled) return;

    setState(() {
      _isButtonTapped = true;
      if (bk == null) {
        _db.createBooking(
            hostelId: widget.hostelId,
            userId: widget.userId,
            timestamp: widget.timestamp);
      }
    });

    _controller.forward().then((_) {
      _controller.reset();
      setState(() {
        _isButtonTapped = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isButtonDisabled ? null : _onButtonPressed,
      // ignore: sort_child_properties_last
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: _isButtonTapped
            ? Stack(
                children: [
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _rotationAnimation.value * (3.14 / 180),
                        child: Opacity(
                          opacity: _opacityAnimation.value,
                          child: const Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 32.0,
                          ),
                        ),
                      );
                    },
                  ),
                  Center(
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: const Text(
                        'Booking Approved',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Text(
                (bk == null) ? 'Book Now' : 'Booked',
                style: TextStyle(fontSize: 20.0),
              ),
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.green,
        minimumSize: Size(MediaQuery.of(context).size.width, 70),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 2.0,
      ),
    );
  }
}
