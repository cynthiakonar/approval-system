import 'package:flutter/material.dart';

import '../../../../utils/constants.dart';
import 'chart.dart';
import 'storage_info_card.dart';

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
          Text(
            "Approved Requests",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: defaultPadding),
          Chart(
            color1: primaryColor,
            color2: Color(0xFF26E5FF),
            color3: Color(0xFFFFCF26),
            totalRequests: 2305,
            totalCompletedRequests: 1356,
            todayRequests: 56,
            weekRequests: 300,
            monthRequests: 1000,
          ),
          StorageInfoCard(
            svgSrc: "assets/icons/Documents.svg",
            title: "Approved today",
            numOfRequests: 1328,
          ),
          StorageInfoCard(
            svgSrc: "assets/icons/media.svg",
            title: "Approved this week",
            numOfRequests: 1328,
          ),
          StorageInfoCard(
            svgSrc: "assets/icons/folder.svg",
            title: "Approved this month",
            numOfRequests: 1328,
          ),
        ],
      ),
    );
  }
}
