import 'dart:html';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import '../../../../utils/constants.dart';

class PendingRequests extends StatefulWidget {
  PendingRequests({
    Key? key,
    required this.requests,
  }) : super(key: key);
  final List requests;

  @override
  State<PendingRequests> createState() => _PendingRequestsState();
}

class _PendingRequestsState extends State<PendingRequests> {
  bool isLoading = false;
  TextEditingController commentController = TextEditingController();

  Future editRequest(String decision, request, context) async {
    setState(() {
      isLoading = true;
    });
    if (decision == 'Rejected' || decision == 'Approved') {
      await FirebaseFirestore.instance
          .collection('workflows')
          .doc(request['workflowId'].trim())
          .update({'status': decision});
      await FirebaseFirestore.instance
          .collection('requests')
          .doc(request['id'].toString().trim())
          .update({
        'status': decision,
        'comment': commentController.text,
        'dateTime': DateTime.now()
      });
    } else {
      await FirebaseFirestore.instance
          .collection('requests')
          .doc(request['id'].toString().trim())
          .update({
        'status': decision,
        'comment': commentController.text,
        'dateTime': DateTime.now()
      });
    }
    commentController.clear();
    setState(() {
      isLoading = false;
    });
    Navigator.pop(context);
  }


  void downloadTHEFile(request) {
    // Create a hidden anchor tag with the download URL.

    Uri uri = Uri.parse(request["attachmentUrl"]);

    // Get the path from the URL
    String path = uri.path;

    // Extract the filename from the path
    String filename = path.split('/').last;

    final anchor = AnchorElement(href: request["attachmentUrl"])
      ..target = 'download'
      ..download = filename
      ..click();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "History",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              columnSpacing: defaultPadding,
              // minWidth: 600,
              columns: const [
                DataColumn(
                  label: Text("Request Name"),
                ),
                DataColumn(
                  label: Text("Workflow"),
                ),
                DataColumn(
                  label: Text("Date-Time"),
                ),
                 DataColumn(
                  label: Text("Document"),
                ),
                DataColumn(
                  label: Text(""),
                ),
              ],

              rows: List.generate(
                widget.requests.length,
                (index) => recentFileDataRow(context, widget.requests[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  editRequestStatus(BuildContext context, request) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: secondaryColor,
          title: Text(
            'Request Detail',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          content: isLoading
              ? SizedBox(
                  height: 80,
                  child: Center(
                    child: SpinKitFadingCircle(
                      size: 50,
                    ),
                  ),
                )
              : SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name :',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        request["name"],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Workflow :',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        request["workflowType"],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Description :',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        request["description"],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Date & Time :',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        DateFormat('MM/dd/yyyy, hh:mm a')
                            .format(request["dateTime"].toDate())
                            .toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Add a comment :",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: commentController,
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
                            borderSide: const BorderSide(
                              color: Colors.white70,
                            ),
                          ),
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.fromLTRB(10, 20, 10, 0),
                        ),
                      ),
                    ],
                  ),
                ),
          actions: [
            isLoading
                ? const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Editing Request...",
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: SizedBox(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: defaultPadding * 1.5,
                                      vertical: defaultPadding / 2,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        4,
                                      ),
                                    ),
                                    side: BorderSide(
                                      width: 0.8,
                                      color: Colors.red[400]!,
                                    ),
                                  ),
                                  onPressed: () {
                                    editRequest("Rejected", request, context);
                                  },
                                  child: Text(
                                    'Reject',
                                    style: TextStyle(
                                      color: Colors.red[400],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: defaultPadding / 2),
                            Expanded(
                              child: SizedBox(
                                child: ElevatedButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.greenAccent[700],
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: defaultPadding * 1.5,
                                      vertical: defaultPadding / 2,
                                    ),
                                  ),
                                  onPressed: () {
                                    print("hi");
                                    editRequest("Approved", request, context);
                                  },
                                  child: const Text("Approve"),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: defaultPadding / 2),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: defaultPadding * 1.5,
                                      vertical: defaultPadding / 2,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        4,
                                      ),
                                    ),
                                    side: BorderSide(
                                      width: 0.8,
                                      color: Colors.blue[400]!,
                                    ),
                                  ),
                                  onPressed: () {
                                    editRequest("Justification Required",
                                        request, context);
                                  },
                                  child: Text(
                                    'Justification Required',
                                    style: TextStyle(
                                      color: Colors.blue[400],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: defaultPadding),
                      ],
                    ),
                  ),
          ],
        ),
      );

  DataRow recentFileDataRow(context, request) {
    return DataRow(
      cells: [
     DataCell(
          Row(
            children: [
              request["attachmentUrl"].isEmpty
                  ? SvgPicture.asset(
                      "assets/icons/xd_file.svg",
                      height: 30,
                      width: 30,
                    )
                  : SizedBox(
                      height: 30,
                      width: 30,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: CachedNetworkImage(
                          fit: BoxFit.fitHeight,
                          imageUrl: request["attachmentUrl"],
                          height: 30,
                          width: 30,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => const Center(
                            child: Icon(Icons.broken_image_outlined),
                          ),
                        ),
                      ),
                    ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Text(request["name"]),
                ),
              ),
            ],
          ),
        ),
           DataCell(Text(request["workflowType"])),
        DataCell(Text(DateFormat('MM/dd/yyyy, hh:mm a')
            .format(request["dateTime"].toDate())
            .toString())),
              request["attachmentUrl"].isNotEmpty
            ? DataCell(
                InkWell(
                    onTap: () async {
                      downloadTHEFile(request);
                    },
                    child: const Icon(Icons.downloading_rounded)),
              )
            : const DataCell(Text("")),
        DataCell(
          InkWell(
            onTap: () {
              editRequestStatus(context, request);
            },
            child: const Icon(Icons.edit, size: 20),
          ),
        ),
      ],
    );
  }
}
