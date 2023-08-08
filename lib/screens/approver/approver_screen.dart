import 'package:approval_system/screens/administrator/dashboard/components/header.dart';
import 'package:approval_system/screens/approver/widgets/pending_requests.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import '../../../utils/responsive.dart';

class ApproverScreen extends StatefulWidget {
  @override
  State<ApproverScreen> createState() => _ApproverScreenState();
}

class _ApproverScreenState extends State<ApproverScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          primary: false,
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Header(hasDashboard: false),
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
                              "Pending Requests",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        SizedBox(height: defaultPadding),
                        PendingRequests(
                          requests: ['Leave', 'Overtime', 'Business Trip'],
                        ),
                        if (Responsive.isMobile(context))
                          SizedBox(height: defaultPadding),
                      ],
                    ),
                  ),
                  if (!Responsive.isMobile(context))
                    SizedBox(width: defaultPadding),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
