import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../utils/constants.dart';

class PendingRequests extends StatelessWidget {
  PendingRequests({
    Key? key,
    required this.requests,
  }) : super(key: key);
  final List requests;

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
                  label: Text(""),
                ),
              ],

              rows: List.generate(
                requests.length,
                (index) => recentFileDataRow(context, requests[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

DataRow recentFileDataRow(context, request) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            SvgPicture.asset(
              "assets/icons/xd_file.svg",
              height: 30,
              width: 30,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Text(request),
              ),
            ),
          ],
        ),
      ),
      const DataCell(Text("Leave Request")),
      const DataCell(Text("01/03/2023 - 10:00PM")),
      DataCell(
        InkWell(
          onTap: () {
            editRequestStatus(context, false);
          },
          child: const Icon(Icons.edit, size: 20),
        ),
      ),
    ],
  );
}

editRequestStatus(BuildContext context, bool isLoading) => showDialog(
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
                    const Text(
                      'Leave Request',
                      style: TextStyle(
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
                    const Text(
                      'Leave Request',
                      style: TextStyle(
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
                    const Text(
                      'Leave Request',
                      style: TextStyle(
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
                    const Text(
                      'Leave Request',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(height: 10),
                    Text(
                      "Add a comment :",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      onChanged: (value) {
                        // setState(() {
                        //   reasonController.text = value;
                        // });
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
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
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
                        contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 0),
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
                                onPressed: () {},
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
                                onPressed: () {},
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
                                onPressed: () {},
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
