import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import 'chart.dart';
import 'request_info_card.dart';

class RejectedRequests extends StatelessWidget {
  const RejectedRequests({
    Key? key,
    required this.totalRequests,
    required this.rejectedToday,
    required this.rejectedThisWeek,
    required this.rejectedThisMonth,
  }) : super(key: key);
  final int totalRequests;
  final int rejectedToday;
  final int rejectedThisWeek;
  final int rejectedThisMonth;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Rejected Requests",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: defaultPadding),
          Chart(
            color1: const Color(0xFF26E5FF),
            color2: const Color(0xFFFFCF26),
            color3: const Color(0xFFEE2727),
            totalRequests: totalRequests,
            totalCompletedRequests:
                rejectedToday + rejectedThisWeek + rejectedThisMonth,
            todayRequests: rejectedToday,
            weekRequests: rejectedThisWeek,
            monthRequests: rejectedThisMonth,
          ),
          RequestInfoCard(
            svgSrc: "assets/icons/media.svg",
            title: "Rejected today",
            numOfRequests: rejectedToday,
          ),
          RequestInfoCard(
            svgSrc: "assets/icons/folder.svg",
            title: "Rejected this week",
            numOfRequests: rejectedThisWeek,
          ),
          RequestInfoCard(
            svgSrc: "assets/icons/unknown.svg",
            title: "Rejected this month",
            numOfRequests: rejectedThisMonth,
          ),
        ],
      ),
    );
  }
}
