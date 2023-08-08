import 'package:approval_system/screens/administrator/dashboard/components/header.dart';
import 'package:approval_system/screens/administrator/dashboard/components/rejected_requests.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import '../../../utils/responsive.dart';
import 'components/approved_requests.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(hasDashboard: true),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total pending requests:  20",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          ElevatedButton.icon(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: defaultPadding * 1.5,
                                vertical: defaultPadding /
                                    (Responsive.isMobile(context) ? 2 : 1),
                              ),
                            ),
                            onPressed: () {},
                            icon: Icon(Icons.add),
                            label: Text("New Workflow"),
                          ),
                        ],
                      ),
                      SizedBox(height: defaultPadding),
                      if (!Responsive.isMobile(context))
                        Row(
                          children: [
                            Expanded(child: ApprovedRequests()),
                            SizedBox(width: defaultPadding),
                            Expanded(child: RejectedRequests()),
                          ],
                        ),
                      if (Responsive.isMobile(context)) ApprovedRequests(),
                      if (Responsive.isMobile(context))
                        SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context)) RejectedRequests(),
                    ],
                  ),
                ),
                SizedBox(width: defaultPadding),
              ],
            )
          ],
        ),
      ),
    );
  }
}
