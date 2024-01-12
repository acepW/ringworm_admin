import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constraints.dart';

class DefaultTextFild extends StatefulWidget {
  final dynamic focusNode,
      compliteFocusNode,
      controller,
      hintText,
      validator,
      keyboardType,
      label;
  const DefaultTextFild(
      {super.key,
      this.focusNode,
      this.compliteFocusNode,
      this.controller,
      this.hintText,
      this.validator,
      this.keyboardType,
      required this.label});

  @override
  State<DefaultTextFild> createState() => _DefaultTextFildState();
}

class _DefaultTextFildState extends State<DefaultTextFild> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      minLines: 1,
      maxLines: 3,
      // validator: (value) {
      //   if (value!.isEmpty) {
      //     return "Please enter a valid Value";
      //   } else {
      //     return null;
      //   }
      // },
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      style: GoogleFonts.rubik(
          textStyle: const TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500)),
      focusNode: widget.focusNode,
      onEditingComplete: () =>
          FocusScope.of(context).requestFocus(widget.compliteFocusNode),
      textInputAction: TextInputAction.next,
      controller: widget.controller,
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: kPrimaryColor),
            borderRadius: BorderRadius.circular(15),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: kPrimaryColor),
            borderRadius: BorderRadius.circular(15),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: kPrimaryColor),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: kPrimaryColor),
            borderRadius: BorderRadius.circular(15),
          ),
          hintText: widget.hintText,
          labelText: widget.label,
          hintStyle: GoogleFonts.rubik(
              textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w500))),
    );
  }
}
