import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;
  final double strokeWidth;
  final String? message;

  const LoadingIndicator({
    super.key,
    this.size = 40,
    this.color,
    this.strokeWidth = 3,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: strokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? Theme.of(context).primaryColor,
            ),
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
        ],
      ],
    );
  }
}

class LinearLoadingIndicator extends StatelessWidget {
  final Color? color;
  final double height;

  const LinearLoadingIndicator({
    super.key,
    this.color,
    this.height = 2,
  });

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      minHeight: height,
      backgroundColor: Colors.transparent,
      valueColor: AlwaysStoppedAnimation<Color>(
        color ?? Theme.of(context).primaryColor,
      ),
    );
  }
}

class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerLoading({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

class FullScreenLoader extends StatelessWidget {
  final String? message;
  final Color? backgroundColor;
  final bool barrierDismissible;

  const FullScreenLoader({
    super.key,
    this.message,
    this.backgroundColor,
    this.barrierDismissible = false,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => barrierDismissible,
      child: Container(
        color: backgroundColor ?? Colors.black.withOpacity(0.5),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const LoadingIndicator(size: 48),
                if (message != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    message!,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ListLoadingIndicator extends StatelessWidget {
  final int itemCount;
  final EdgeInsets padding;

  const ListLoadingIndicator({
    super.key,
    this.itemCount = 6,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        children: List.generate(
          itemCount,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                const ShimmerLoading(width: 50, height: 50, borderRadius: 25),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerLoading(
                        width: double.infinity,
                        height: 16,
                        borderRadius: 4,
                      ),
                      const SizedBox(height: 8),
                      ShimmerLoading(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 12,
                        borderRadius: 4,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
