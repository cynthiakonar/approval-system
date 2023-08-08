import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:file_picker/file_picker.dart';
import '../../../utils/constants.dart';

class NewRequestDialog extends StatefulWidget {
  NewRequestDialog({Key? key}) : super(key: key);

  @override
  State<NewRequestDialog> createState() => _NewRequestDialogState();
}

class _NewRequestDialogState extends State<NewRequestDialog> {
  bool _isLoading = false;

  final ItemEditingController = TextEditingController();
  final reasonController = TextEditingController();
  String? siteValue;
  final _reasonFormKey = GlobalKey<FormState>();
  List<String> siteItems = ["x", "y"];
  String? imageFilePath;
  List<Map<String, String?>> material_quantity = [];

  bool _isFileAdded = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: secondaryColor,
      title: Stack(
        children: [
          const Center(
            child: Text(
              "Request for workflow",
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
        child: _isLoading
            ? const Center(
                child: Column(
                  children: [
                    SpinKitFadingCircle(
                      color: Color(0xFFD7EB8B),
                      size: 50,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Uploading data",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    )
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
                          "Request Name :",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              reasonController.text = value;
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
                        const SizedBox(height: 8),
                        const Text(
                          "Workflow Type :",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          itemHeight: null,
                          decoration: InputDecoration(
                            // isDense: true,
                            isCollapsed: true,
                            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white70,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white70,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white70,
                              ),
                            ),
                          ),
                          autofocus: false,
                          value: siteValue,
                          isExpanded: true,
                          iconSize: 24,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white70,
                          ),
                          items: siteItems.map(buildMenuItem).toList(),
                          onChanged: (Evalue) => setState(
                            () {
                              this.siteValue = Evalue;
                              ItemEditingController.text = Evalue!;
                            },
                          ),
                          onSaved: (Evalue) {
                            ItemEditingController.text = Evalue!;
                          },
                          validator: (value) {
                            if (ItemEditingController.text.isEmpty) {
                              return "*Required";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Description :",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              reasonController.text = value;
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
                        SizedBox(height: 8),
                        const Text(
                          "Add Attachment (if any) :",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _isFileAdded
                            ? GestureDetector(
                                onTap: () => setState(() {
                                  _isFileAdded = false;
                                  imageFilePath = null;
                                }),
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white70,
                                    borderRadius: BorderRadius.circular(6.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 2.0,
                                        spreadRadius: 1.0,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'File added',
                                        // style: TT.f13w600
                                        //     .copyWith(color: ColorTheme.iconColor),
                                      ),
                                      Icon(
                                        Icons.close,
                                        size: 20,
                                        // color: ColorTheme.iconColor,
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: material_quantity.isNotEmpty
                                    ? null
                                    : () async {
                                        try {
                                          FilePickerResult? result =
                                              await FilePicker.platform
                                                  .pickFiles(
                                                      type: FileType.custom,
                                                      allowedExtensions: [
                                                'pdf',
                                                'jpg',
                                                'png',
                                                'webp'
                                              ]);
                                          if (result != null) {
                                            setState(() {
                                              _isFileAdded = true;
                                              imageFilePath =
                                                  result.files.first.path;
                                            });

                                            print('File path: ' +
                                                result.files.single.path!);
                                          } else {
                                            print('User cancelled file pick');
                                          }
                                        } on PlatformException {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'File access permission denied'),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        }
                                      },
                                child: Container(
                                  width: double.infinity,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white70,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(7),
                                    color: material_quantity.isEmpty
                                        ? Colors.transparent
                                        : Colors.white70,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Choose file",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        // color: (material_quantity.isEmpty)
                                        //     ? ColorTheme.iconColor
                                        //     : Colors.black26
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                  SizedBox(height: 18),

                  // Button
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed:
                              (reasonController.text.isEmpty) ? null : () {},
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
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
      value: item,
      child: Text(
        item,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
      ));
}
