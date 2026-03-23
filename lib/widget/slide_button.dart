import 'package:flutter/material.dart';

class SlideButton extends StatefulWidget {
  final String text;
  final Color outerColor;
  final Color innerColor;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onSubmit;

  const SlideButton({
    super.key,
    required this.text,
    required this.outerColor,
    required this.innerColor,
    required this.icon,
    required this.iconColor,
    required this.onSubmit,
  });

  @override
  State<SlideButton> createState() => _SlideButtonState();
}

class _SlideButtonState extends State<SlideButton>
    with SingleTickerProviderStateMixin {
  double _dragPosition = 0;
  double _maxDrag = 0;
  bool _submitted = false;
  late AnimationController _resetController;
  late Animation<double> _resetAnimation;

  @override
  void initState() {
    super.initState();
    _resetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _resetController.dispose();
    super.dispose();
  }

  void _onDragStart(DragStartDetails details) {
    if (_submitted) return;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_submitted) return;
    setState(() {
      _dragPosition += details.delta.dx;
      _dragPosition = _dragPosition.clamp(0.0, _maxDrag);
    });
  }

  void _onDragEnd(DragEndDetails details) {
    if (_submitted) return;
    if (_dragPosition >= _maxDrag * 0.85) {
      setState(() => _submitted = true);
      widget.onSubmit();
    } else {
      _resetAnimation = Tween<double>(
        begin: _dragPosition,
        end: 0,
      ).animate(CurvedAnimation(
        parent: _resetController,
        curve: Curves.easeOut,
      ))
        ..addListener(() {
          if (mounted) setState(() => _dragPosition = _resetAnimation.value);
        });
      _resetController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    const double height = 60;
    const double thumbSize = 52;
    const double padding = 4;

    return LayoutBuilder(
      builder: (context, constraints) {
        _maxDrag = constraints.maxWidth - thumbSize - (padding * 2);

        return Container(
          height: height,
          decoration: BoxDecoration(
            color: widget.outerColor,
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              // Text label centered
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: AnimatedOpacity(
                    opacity: 1.0 - (_dragPosition / (_maxDrag == 0 ? 1 : _maxDrag)),
                    duration: Duration.zero,
                    child: Text(
                      widget.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              // Draggable thumb
              Positioned(
                left: padding + _dragPosition,
                child: GestureDetector(
                  onHorizontalDragStart: _onDragStart,
                  onHorizontalDragUpdate: _onDragUpdate,
                  onHorizontalDragEnd: _onDragEnd,
                  child: Container(
                    width: thumbSize,
                    height: thumbSize,
                    decoration: BoxDecoration(
                      color: widget.innerColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.icon,
                      color: widget.iconColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
