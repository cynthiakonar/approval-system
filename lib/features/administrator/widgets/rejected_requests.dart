import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import 'chart.dart';
import 'request_info_card.dart';

class RejectedRequests extends StatelessWidget {
  const RejectedRequests({
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
            totalRequests: 2305,
            totalCompletedRequests: 43,
            todayRequests: 3,
            weekRequests: 10,
            monthRequests: 30,
          ),
          const RequestInfoCard(
            svgSrc: "assets/icons/media.svg",
            title: "Rejected today",
            numOfRequests: 1328,
          ),
          const RequestInfoCard(
            svgSrc: "assets/icons/folder.svg",
            title: "Rejected this week",
            numOfRequests: 1328,
          ),
          const RequestInfoCard(
            svgSrc: "assets/icons/unknown.svg",
            title: "Rejected this month",
            numOfRequests: 1328,
          ),
        ],
      ),
    );
  }
}
