import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import 'chart.dart';
import 'request_info_card.dart';

class ApprovedRequests extends StatelessWidget {
  const ApprovedRequests({
    Key? key,
    required this.totalRequests,
    required this.approvedToday,
    required this.approvedThisWeek,
    required this.approvedThisMonth,
  }) : super(key: key);
  final int totalRequests;
  final int approvedToday;
  final int approvedThisWeek;
  final int approvedThisMonth;

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
            "Approved Requests",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: defaultPadding),
          Chart(
            color1: primaryColor,
            color2: const Color(0xFF26E5FF),
            color3: const Color(0xFFFFCF26),
            totalRequests: totalRequests,
            totalCompletedRequests:
                approvedToday + approvedThisWeek + approvedThisMonth,
            todayRequests: approvedToday,
            weekRequests: approvedThisWeek,
            monthRequests: approvedThisMonth,
          ),
          RequestInfoCard(
            svgSrc: "assets/icons/Documents.svg",
            title: "Approved today",
            numOfRequests: approvedToday,
          ),
          RequestInfoCard(
            svgSrc: "assets/icons/media.svg",
            title: "Approved this week",
            numOfRequests: approvedThisWeek,
          ),
          RequestInfoCard(
            svgSrc: "assets/icons/folder.svg",
            title: "Approved this month",
            numOfRequests: approvedThisMonth,
          ),
        ],
      ),
    );
  }
}
