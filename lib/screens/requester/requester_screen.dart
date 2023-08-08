import 'package:approval_system/screens/administrator/dashboard/components/header.dart';
import 'package:approval_system/screens/requester/widgets/new_request_dialog.dart';
import 'package:approval_system/screens/requester/widgets/request_history.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import '../../../utils/responsive.dart';

class RequesterScreen extends StatefulWidget {
  const RequesterScreen({super.key});

  @override
  State<RequesterScreen> createState() => _RequesterScreenState();
}

class _RequesterScreenState extends State<RequesterScreen> {
  Future openDialog() async {
    await showDialog(
      context: this.context,
      builder: (context) => NewRequestDialog(),
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
                              "My Requests",
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
                              icon: Icon(Icons.add),
                              label: Text("Add New"),
                            ),
                          ],
                        ),
                        SizedBox(height: defaultPadding),
                        RequestHistory(
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
