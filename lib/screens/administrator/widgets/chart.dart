import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants.dart';

class Chart extends StatelessWidget {
  Chart({
    Key? key,
    required this.color1,
    required this.color2,
    required this.color3,
    required this.totalRequests,
    required this.totalCompletedRequests,
    required this.todayRequests,
    required this.weekRequests,
    required this.monthRequests,
  }) : super(key: key);
  final Color color1;
  final Color color2;
  final Color color3;
  final int totalRequests;
  final int totalCompletedRequests;
  final int todayRequests;
  final int weekRequests;
  final int monthRequests;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 70,
              startDegreeOffset: -90,
              sections: [
                PieChartSectionData(
                  color: color1,
                  value: todayRequests.toDouble(),
                  showTitle: false,
                  radius: 25,
                ),
                PieChartSectionData(
                  color: color2,
                  value: weekRequests.toDouble(),
                  showTitle: false,
                  radius: 22,
                ),
                PieChartSectionData(
                  color: color3,
                  value: monthRequests.toDouble(),
                  showTitle: false,
                  radius: 19,
                ),
                PieChartSectionData(
                  color: primaryColor.withOpacity(0.1),
                  value: (totalRequests - totalCompletedRequests).toDouble(),
                  showTitle: false,
                  radius: 13,
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: defaultPadding),
                Text(
                  totalCompletedRequests.toString(),
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        height: 0.5,
                      ),
                ),
                Text("of $totalRequests")
              ],
            ),
          ),
        ],
      ),
    );
  }
}
