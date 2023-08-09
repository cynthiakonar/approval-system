import 'dart:async';

import 'package:approval_system/features/administrator/widgets/header.dart';
import 'package:approval_system/features/administrator/widgets/new_workflow_dialog.dart';
import 'package:approval_system/features/administrator/widgets/rejected_requests.dart';
import 'package:approval_system/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/responsive.dart';
import '../requester/widgets/request_history.dart';
import 'widgets/approved_requests.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int totalPendingRequests = 0;
  int approvedToday = 0;
  int approvedThisWeek = 0;
  int approvedThisMonth = 0;
  int rejectedToday = 0;
  int rejectedThisWeek = 0;
  int rejectedThisMonth = 0;

  int totalRequests = 0;

  List requests = [];
  Timer? timer;

  @override
  void initState() {
    super.initState();

    getAllRequests();

    timer = Timer.periodic(
      Duration(seconds: 2),
      (Timer t) => getAllRequests(),
    );
  }

  Future getAllRequests() async {
    requests.clear();
    approvedToday = 0;
    approvedThisWeek = 0;
    approvedThisMonth = 0;
    rejectedToday = 0;
    rejectedThisWeek = 0;
    rejectedThisMonth = 0;

    totalPendingRequests = await FirebaseFirestore.instance
        .collection('requests')
        .where('status', isEqualTo: 'Pending')
        .get()
        .then((querySnapshot) => querySnapshot.size);
    totalRequests = await FirebaseFirestore.instance
        .collection('requests')
        .get()
        .then((querySnapshot) => querySnapshot.size);
    await FirebaseFirestore.instance
        .collection('requests')
        .where('status', whereIn: ['Approved', 'Rejected'])
        .get()
        .then((querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                requests.add(doc.data());

                // seperate analytics
                DateTime date = doc.data()["dateTime"].toDate();
                int diff = calculateDifference(date);
                if (diff == 0) {
                  if (doc.data()["status"] == "Approved") {
                    approvedToday++;
                  } else {
                    rejectedToday++;
                  }
                } else if (diff > -7 && diff < 0) {
                  if (doc.data()["status"] == "Approved") {
                    approvedThisWeek++;
                  } else {
                    rejectedThisWeek++;
                  }
                } else if (diff > -30 && diff < -7) {
                  if (doc.data()["status"] == "Approved") {
                    approvedThisMonth++;
                  } else {
                    rejectedThisMonth++;
                  }
                }
              }),
            });

    setState(() {});
  }

  Future openDialog() async {
    await showDialog(
      context: this.context,
      builder: (context) => NewWorkflowDialog(),
    );
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
                              "Total pending requests:  $totalPendingRequests",
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
                          Row(
                            children: [
                              Expanded(
                                  child: ApprovedRequests(
                                totalRequests: totalRequests,
                                approvedToday: approvedToday,
                                approvedThisWeek: approvedThisWeek,
                                approvedThisMonth: approvedThisMonth,
                              )),
                              SizedBox(width: defaultPadding),
                              Expanded(
                                  child: RejectedRequests(
                                totalRequests: totalRequests,
                                rejectedToday: rejectedToday,
                                rejectedThisWeek: rejectedThisWeek,
                                rejectedThisMonth: rejectedThisMonth,
                              )),
                            ],
                          ),
                        if (Responsive.isMobile(context))
                          ApprovedRequests(
                            totalRequests: totalRequests,
                            approvedToday: approvedToday,
                            approvedThisWeek: approvedThisWeek,
                            approvedThisMonth: approvedThisMonth,
                          ),
                        if (Responsive.isMobile(context))
                          const SizedBox(height: defaultPadding),
                        if (Responsive.isMobile(context))
                          RejectedRequests(
                            totalRequests: totalRequests,
                            rejectedToday: rejectedToday,
                            rejectedThisWeek: rejectedThisWeek,
                            rejectedThisMonth: rejectedThisMonth,
                          ),
                        const SizedBox(height: defaultPadding),
                        RequestHistory(requests: requests),
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
