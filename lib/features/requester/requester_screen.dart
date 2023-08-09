import 'dart:async';

import 'package:approval_system/features/administrator/widgets/header.dart';
import 'package:approval_system/features/requester/widgets/new_request_dialog.dart';
import 'package:approval_system/features/requester/widgets/request_history.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import '../../../utils/responsive.dart';

class RequesterScreen extends StatefulWidget {
  const RequesterScreen({super.key, required this.emailId});
  final String emailId;

  @override
  State<RequesterScreen> createState() => _RequesterScreenState();
}

class _RequesterScreenState extends State<RequesterScreen> {
  List requests = [];

  Timer? timer;

  @override
  void initState() {
    super.initState();

    getMyRequests();

    timer = Timer.periodic(
      Duration(seconds: 2),
      (Timer t) => getMyRequests(),
    );
  }

  Future getMyRequests() async {
    requests.clear();
    await FirebaseFirestore.instance
        .collection('requests')
        .where('userEmail', isEqualTo: widget.emailId)
        .get()
        .then((querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                requests.add(doc.data());
              }),
            });
    setState(() {});
  }

  Future openDialog() async {
    await showDialog(
      context: this.context,
      builder: (context) => NewRequestDialog(emailId: widget.emailId),
    );
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
              Header(role: "Requester"),
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
                        RequestHistory(requests: requests),
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
