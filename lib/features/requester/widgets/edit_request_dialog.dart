import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_storage/firebase_storage.dart' as firabase_storage;
import 'package:file_picker/file_picker.dart';
import '../../../utils/constants.dart';

class EditRequestDialog extends StatefulWidget {
  const EditRequestDialog({Key? key, required this.request}) : super(key: key);
  final dynamic request;

  @override
  State<EditRequestDialog> createState() => _EditRequestDialogState();
}

class _EditRequestDialogState extends State<EditRequestDialog> {
  bool _isLoading = false;

  final ItemEditingController = TextEditingController();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? selectedWorkflow;
  List workflows = [];
  List<String> workflowNames = [];

  String? selectedFile;
  Uint8List? fileinBytes;

  bool _isFileAdded = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
      nameController.text = widget.request['name'];
      descriptionController.text = widget.request['description'];
      selectedWorkflow = widget.request['workflowType'];

      print(nameController.text);
    });

    getAvailableWorkflows();
    setState(() {
      _isLoading = false;
    });
  }

  Future selectFile(bool imageFrom) async {
    FilePickerResult? fileResult =
        await FilePicker.platform.pickFiles(allowMultiple: false);

    if (fileResult != null) {
      selectedFile = fileResult.files.first.name;
      fileinBytes = fileResult.files.first.bytes;
      _isFileAdded = true;
      setState(() {});
    }
    print(selectedFile);
  }

  Future<String> uploadFile() async {
    String imageUrl = '';
    try {
      firabase_storage.UploadTask uploadTask;

      firabase_storage.Reference ref = firabase_storage.FirebaseStorage.instance
          .ref()
          .child('files/${selectedFile!}');

      final metadata =
          firabase_storage.SettableMetadata(contentType: 'image/jpeg');

      //uploadTask = ref.putFile(File(file.path));
      uploadTask = ref.putData(fileinBytes!, metadata);

      await uploadTask.whenComplete(() => null);
      imageUrl = await ref.getDownloadURL();
    } catch (e) {
      print(e);
    }
    return imageUrl;
  }

  Future getAvailableWorkflows() async {
    workflows.clear();
    workflowNames.clear();
    await FirebaseFirestore.instance
        .collection('workflows')
        .where('status', isEqualTo: 'Pending')
        .get()
        .then((querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                workflows.add({"id": doc.id, "approvers": doc['approvers']});
                workflowNames.add(doc['name']);
              }),
            });
    workflows.add({
      'id': widget.request['workflowId'],
      'approvers': widget.request['workflowApprovers']
    });
    workflowNames.add(widget.request['workflowType']);
    setState(() {});
    print(workflows);
  }

  Future editRequest(context) async {
    setState(() {
      _isLoading = true;
    });
    String fileUrl = '';
    if (_isFileAdded) {
      fileUrl = await uploadFile();
    }

    await FirebaseFirestore.instance
        .collection('requests')
        .doc(widget.request['id'].toString().trim())
        .update({
      'name': nameController.text,
      'description': descriptionController.text,
      'workflowType': selectedWorkflow,
      'attachmentUrl': fileUrl,
      'status': 'Pending',
      'dateTime': DateTime.now(),
      'workflowApprovers': workflows[workflowNames.indexOf(selectedWorkflow!)]
          ['approvers'],
      'workflowId': workflows[workflowNames.indexOf(selectedWorkflow!)]['id'],
    });

    setState(() {
      _isLoading = false;
    });
    Navigator.pop(context);
  }

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
              constraints: const BoxConstraints(),
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
              iconSize: 18,
              color: const Color(0xFFC8C8C8),
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
                      color: Colors.white,
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
                    key: _formKey,
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
                          controller: nameController,
                          validator: (value) {
                            if ((value == null || value.isEmpty) &&
                                nameController.text.isEmpty) {
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
                          decoration: const InputDecoration(
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
                          value: selectedWorkflow,
                          isExpanded: true,
                          iconSize: 24,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white70,
                          ),
                          items: workflowNames.map(buildMenuItem).toList(),
                          onChanged: (Evalue) => setState(
                            () {
                              this.selectedWorkflow = Evalue;

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
                          controller: descriptionController,
                          validator: (value) {
                            if ((value == null || value.isEmpty) &&
                                descriptionController.text.isEmpty) {
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
                        const SizedBox(height: 8),
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
                                  selectedFile = null;
                                }),
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(6.0),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 2.0,
                                        spreadRadius: 1.0,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'File added',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Icon(
                                        Icons.close,
                                        size: 16,
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () async {
                                  try {
                                    selectFile(true);
                                  } on PlatformException {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
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
                                      color: Colors.transparent),
                                  child: const Center(
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
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Button
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: (nameController.text.isEmpty ||
                                  descriptionController.text.isEmpty ||
                                  selectedWorkflow == null)
                              ? null
                              : () {
                                  editRequest(context);
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
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
      value: item,
      child: Text(
        item,
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
      ));
}
