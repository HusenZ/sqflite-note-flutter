import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
  const CustomTextInput({
    Key? key,
    required this.titleController,
    required this.hintText,
    required this.onChanged,
  }) : super(key: key);

  final TextEditingController titleController;
  final String hintText;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 15.0,
        bottom: 15.0,
      ),
      child: TextField(
        controller: titleController,
        onChanged: (value) {
          onChanged;
        },
        decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            )),
      ),
    );
  }
}
