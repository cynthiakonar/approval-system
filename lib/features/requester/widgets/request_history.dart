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
                  : CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: request["attachmentUrl"],
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                          gradient: const LinearGradient(colors: [
                            Colors.transparent,
                            Colors.black,
                            Colors.black,
                            Colors.black,
                          ]),
                        ),
                      ),
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Center(
                          child: const Icon(Icons.broken_image_outlined)),
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
