import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import 'chart.dart';
import 'request_info_card.dart';

class ApprovedRequests extends StatelessWidget {
  const ApprovedRequests({
    Key? key,
  }) : super(key: key);

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
            totalRequests: 2305,
            totalCompletedRequests: 1356,
            todayRequests: 56,
            weekRequests: 300,
            monthRequests: 1000,
          ),
          const RequestInfoCard(
            svgSrc: "assets/icons/Documents.svg",
            title: "Approved today",
            numOfRequests: 1328,
          ),
          const RequestInfoCard(
            svgSrc: "assets/icons/media.svg",
            title: "Approved this week",
            numOfRequests: 1328,
          ),
          const RequestInfoCard(
            svgSrc: "assets/icons/folder.svg",
            title: "Approved this month",
            numOfRequests: 1328,
          ),
        ],
      ),
    );
  }
}
