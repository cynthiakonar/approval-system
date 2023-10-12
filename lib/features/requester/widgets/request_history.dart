// ignore_for_file: avoid_print, no_leading_underscores_for_local_identifiers

import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../utils/constants.dart';
import 'edit_request_dialog.dart';

class RequestHistory extends StatefulWidget {
  RequestHistory({
    Key? key,
    required this.requests,
  }) : super(key: key);
  final List requests;

  @override
  State<RequestHistory> createState() => _RequestHistoryState();
}

class _RequestHistoryState extends State<RequestHistory> {
  Future openDialog(request) async {
    await showDialog(
      context: this.context,
      builder: (context) => EditRequestDialog(request: request),
    );
  }

  // Future<void> downloadFile(request) async {
  //   var dir = (await DownloadsPath.downloadsDirectory())?.path;
  //   try {
  //     // Extract the file extension from the URL
  //     String fileExtension = request["attachmentUrl"].split('.').last;

  //     if (fileExtension == "pdf") {
  //       print("The file is a PDF.");
  //     }

  //     await Dio().download(request["attachmentUrl"], dir,
  //         onReceiveProgress: (received, total) {
  //       if (total != -1) {}
  //     });
  //     print("File is saved to download folder.");
  //     // ignore: deprecated_member_use
  //   } on DioError catch (e) {
  //     print(e.message);
  //   }
  // }

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
              columns: const [
                DataColumn(
                  label: Text("Req Name"),
                ),
                DataColumn(
                  label: Text("Workflow"),
                ),
                DataColumn(
                  label: Text("Date-Time"),
                ),
                DataColumn(
                  label: Text("Status"),
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
                (index) => recentFileDataRow(widget.requests[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DataRow recentFileDataRow(request) {
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
        DataCell(Text(request["status"])),
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
          request["status"] == "Justification Required"
              ? InkWell(
                  onTap: () {
                    openDialog(request);
                  },
                  child: const Icon(Icons.edit, size: 20),
                )
              : const SizedBox(),
        ),
      ],
    );
  }
}
