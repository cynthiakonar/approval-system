import 'package:approval_system/features/administrator/widgets/header.dart';
import 'package:approval_system/features/administrator/widgets/new_workflow_dialog.dart';
import 'package:approval_system/features/administrator/widgets/rejected_requests.dart';
import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import '../../utils/responsive.dart';
import '../requester/widgets/request_history.dart';
import 'widgets/approved_requests.dart';

class AdminScreen extends StatefulWidget {
  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  Future openDialog() async {
    await showDialog(
      context: this.context,
      builder: (context) => NewWorkflowDialog(),
    );
    // setState(() {
    //   dataFuture = LeaveRequestAPI().getMyLeaveRequests();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          primary: false,
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Header(role: "Administrator"),
              const SizedBox(height: defaultPadding),
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
                              onPressed: () {
                                openDialog();
                              },
                              icon: const Icon(Icons.add),
                              label: const Text("New Workflow"),
                            ),
                          ],
                        ),
                        const SizedBox(height: defaultPadding),
                        if (!Responsive.isMobile(context))
                          const Row(
                            children: [
                              Expanded(child: ApprovedRequests()),
                              SizedBox(width: defaultPadding),
                              Expanded(child: RejectedRequests()),
                            ],
                          ),
                        if (Responsive.isMobile(context))
                          const ApprovedRequests(),
                        if (Responsive.isMobile(context))
                          const SizedBox(height: defaultPadding),
                        if (Responsive.isMobile(context))
                          const RejectedRequests(),
                        const SizedBox(height: defaultPadding),
                        RequestHistory(
                          requests: ['Leave', 'Overtime', 'Business Trip'],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: defaultPadding),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
