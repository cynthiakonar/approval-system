import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../utils/constants.dart';

class RequestHistory extends StatelessWidget {
  RequestHistory({
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
                  label: Text("Status"),
                ),
              ],
              rows: List.generate(
                requests.length,
                (index) => recentFileDataRow(requests[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

DataRow recentFileDataRow(request) {
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
      DataCell(Text("Leave Request")),
      DataCell(Text("01/03/2023 - 10:00PM")),
      DataCell(Text("Approved")),
    ],
  );
}
