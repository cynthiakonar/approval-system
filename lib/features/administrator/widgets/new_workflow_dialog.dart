import 'dart:async';

import 'package:approval_system/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class NewWorkflowDialog extends StatefulWidget {
  NewWorkflowDialog({Key? key}) : super(key: key);

  @override
  State<NewWorkflowDialog> createState() => _NewWorkflowDialogState();
}

class _NewWorkflowDialogState extends State<NewWorkflowDialog> {
  bool isLoading = false;

  final ItemEditingController = TextEditingController();
  final nameController = TextEditingController();
  final _reasonFormKey = GlobalKey<FormState>();

  List selectedApprovers = [];
  List approvers = [];
  List selectedApprovalTypes = [];
  List approvalTypes = [
    "Everyone should approve",
    "At least two should approve",
    "Anyone can approve"
  ];

  @override
  void initState() {
    super.initState();

    getApprovers();
  }

  Future getApprovers() async {
    setState(() {
      isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'Approver')
        .get()
        .then((querySnapshot) => {
              querySnapshot.docs
                  .forEach((doc) => approvers.add(doc.data()['email'])),
            });
    setState(() {});
    print(approvers);
    setState(() {
      isLoading = false;
    });
  }

  Future createWorkflow() async {
    setState(() {
      isLoading = true;
    });

    DocumentReference documentReference =
        await FirebaseFirestore.instance.collection('workflows').add({
      'name': nameController.text,
      'approvers': selectedApprovers,
      'approvalTypes': selectedApprovalTypes,
      'status': 'Pending',
    });

    documentReference.update({'id': documentReference.id});

    setState(() {
      isLoading = false;
      nameController.clear();
      selectedApprovers.clear();
      selectedApprovalTypes.clear();
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        backgroundColor: secondaryColor,
        title: Stack(
          children: [
            const Center(
              child: Text(
                "Add new workflow",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close),
                iconSize: 18,
                color: Color(0xFFC8C8C8),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: isLoading
              ? const Center(
                  child: Column(
                    children: [
                      SpinKitFadingCircle(
                        color: Color(0xFFD7EB8B),
                        size: 50,
                      ),
                    ],
                  ),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: _reasonFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Workflow Name :",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            onChanged: (value) {
                              setState(() {
                                nameController.text = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "*Required";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.text,
                            minLines: 1,
                            maxLines: 5,
                            textCapitalization: TextCapitalization.sentences,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  5,
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white70,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  5,
                                ),
                                borderSide: BorderSide(
                                  color: Colors.white70,
                                ),
                              ),
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.fromLTRB(10, 20, 10, 0),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Select Approver(s) :",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: MediaQuery.of(context).size.height * 0.5,
                            child: ListView(
                              physics: const BouncingScrollPhysics(),
                              children: [
                                Wrap(
                                  children: approvers.map((tag) {
                                    return GestureDetector(
                                      onTap: () {
                                        if (selectedApprovers.contains(tag)) {
                                          setState(() {
                                            selectedApprovers.remove(tag);
                                          });
                                        } else {
                                          setState(() {
                                            selectedApprovers.add(tag);
                                          });
                                        }
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            right: 4, top: 8),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 3),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color:
                                                selectedApprovers.contains(tag)
                                                    ? Colors.blue[100]
                                                    : Colors.white,
                                            border: Border.all(
                                              width: selectedApprovers
                                                      .contains(tag)
                                                  ? 2
                                                  : 1,
                                              color: selectedApprovers
                                                      .contains(tag)
                                                  ? Colors.blue
                                                  : const Color(0xFFD9D9D9),
                                            )),
                                        child: Text(
                                          tag,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight:
                                                selectedApprovers.contains(tag)
                                                    ? FontWeight.w600
                                                    : FontWeight.w400,
                                            color:
                                                selectedApprovers.contains(tag)
                                                    ? Colors.blue
                                                    : const Color(0xFF737373),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Approval Type(s) :",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: MediaQuery.of(context).size.height * 0.5,
                            child: ListView(
                              physics: const BouncingScrollPhysics(),
                              children: [
                                Wrap(
                                  children: approvalTypes.map((tag) {
                                    return GestureDetector(
                                      onTap: () {
                                        if (selectedApprovalTypes
                                            .contains(tag)) {
                                          setState(() {
                                            selectedApprovalTypes.remove(tag);
                                          });
                                        } else {
                                          setState(() {
                                            selectedApprovalTypes.add(tag);
                                          });
                                        }
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            right: 4, top: 8),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 3),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: selectedApprovalTypes
                                                    .contains(tag)
                                                ? Colors.blue[100]
                                                : Colors.white,
                                            border: Border.all(
                                              width: selectedApprovalTypes
                                                      .contains(tag)
                                                  ? 2
                                                  : 1,
                                              color: selectedApprovalTypes
                                                      .contains(tag)
                                                  ? Colors.blue
                                                  : const Color(0xFFD9D9D9),
                                            )),
                                        child: Text(
                                          tag,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: selectedApprovalTypes
                                                    .contains(tag)
                                                ? FontWeight.w600
                                                : FontWeight.w400,
                                            color: selectedApprovalTypes
                                                    .contains(tag)
                                                ? Colors.blue
                                                : const Color(0xFF737373),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                    SizedBox(height: 18),

                    // Button
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: nameController.text.isEmpty ||
                                    selectedApprovers.isEmpty ||
                                    selectedApprovalTypes.isEmpty
                                ? null
                                : () {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    createWorkflow();
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: const Text(
                              'Submit',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      );
    });
  }
}
