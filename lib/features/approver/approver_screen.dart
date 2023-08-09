import 'package:approval_system/features/administrator/widgets/header.dart';
import 'package:approval_system/features/approver/widgets/pending_requests.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../utils/constants.dart';
import '../../../utils/responsive.dart';

class ApproverScreen extends StatefulWidget {
  final String emailId;

  const ApproverScreen({super.key, required this.emailId});
  @override
  State<ApproverScreen> createState() => _ApproverScreenState();
}

class _ApproverScreenState extends State<ApproverScreen> {
  bool _isLoading = false;

  List requests = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    getMyRequests();
    setState(() {
      _isLoading = false;
    });
  }

  Future getMyRequests() async {
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
                        _isLoading
                            ? const Center(
                                child: SpinKitFadingCircle(
                                  color: Colors.white,
                                  size: 50,
                                ),
                              )
                            : PendingRequests(requests: requests),
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
