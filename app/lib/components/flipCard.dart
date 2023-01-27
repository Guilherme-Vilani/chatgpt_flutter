import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:nb_utils/nb_utils.dart';

class FlipCard extends StatefulWidget {
  @override
  _FlipCardState createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flip Card'),
        centerTitle: true,
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(_controller.value * math.pi),
              alignment: Alignment.center,
              child: child,
            );
          },
          child: Center(
            child: InkWell(
              onTap: () {
                if (_controller.isCompleted) {
                  _controller.reverse();
                } else {
                  _controller.forward();
                }
              },
              child: Container(
                width: 250,
                height: 350,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.pix_sharp,
                          size: 100,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          'Pix Flip Card',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
