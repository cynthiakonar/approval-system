import 'dart:async';

import 'package:approval_system/features/administrator/widgets/header.dart';
import 'package:approval_system/features/approver/widgets/pending_requests.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import '../../../utils/responsive.dart';

class ApproverScreen extends StatefulWidget {
  final String emailId;

  const ApproverScreen({super.key, required this.emailId});
  @override
  State<ApproverScreen> createState() => _ApproverScreenState();
}

class _ApproverScreenState extends State<ApproverScreen> {
  Timer? timer;

  List requests = [];

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(
      Duration(seconds: 2),
      (Timer t) => getMyRequests(),
    );
  }

  Future getMyRequests() async {
    requests.clear();
    await FirebaseFirestore.instance
        .collection('requests')
        .where('status', isEqualTo: 'Pending')
        .where('workflowApprovers', arrayContains: widget.emailId)
        .get()
        .then((querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                requests.add(doc.data());
              }),
            });
    setState(() {});
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
              Header(role: "Approver"),
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
                        PendingRequests(requests: requests),
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
