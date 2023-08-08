import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class NewRequestDialog extends StatefulWidget {
  NewRequestDialog({Key? key}) : super(key: key);

  @override
  State<NewRequestDialog> createState() => _NewRequestDialogState();
}

class _NewRequestDialogState extends State<NewRequestDialog> {
  bool _isLoading = false;

  final reasonController = TextEditingController();

  final _reasonFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Stack(
        children: [
          Center(
            child: Text(
              "Apply for leave",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
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
            ? Center(
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
                        Text(
                          "Select dates :",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Reason :",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
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
                                color: Color(0xFF7B931B),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                5,
                              ),
                              borderSide: BorderSide(
                                color: Color(0xFF7B931B),
                              ),
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                          ),
                        ),
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
                            backgroundColor: const Color(0xFF7B931B),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: const Text(
                            'Apply for leave',
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
}
