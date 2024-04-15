import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  const ChartBar({
    super.key,
    required this.fill,
    required this.amount,
  });

  final String amount;
  final double fill;

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Stack(children: [
          Container(width: double.infinity,
            child: FractionallySizedBox(
              heightFactor: fill,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(8)),
                  color: isDarkMode
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.primary.withOpacity(0.65),
                ),
              ),
            ),
          ),
          Positioned.fill(child: Center(child: Text(amount,style: TextStyle(fontSize: 17,color: Colors.black,fontWeight: FontWeight.w500),),))
        ]),
      ),
    );
  }
}
