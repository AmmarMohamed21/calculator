import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    Key? key,
    required this.controller,
    required this.label,
    this.isSecond = false,
  }) : super(key: key);

  final TextEditingController controller;
  final String label;
  final bool isSecond;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        controller: controller,
        inputFormatters: [
          FilteringTextInputFormatter.allow(
              RegExp(r'-?\d*$')) //allow positive or negative integers only
        ],
        keyboardType:
            const TextInputType.numberWithOptions(signed: true, decimal: false),
        //style: kNormalTextStyle,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!.enterValue;
          }
          if (!RegExp(r'^-?\d+$').hasMatch(value)) {
            //only integers
            return AppLocalizations.of(context)!.integersOnly;
          }
          if (isSecond && value == '0') {
            return AppLocalizations.of(context)!.zeroDivision;
          }
          if (value.length > 14 ||
              int.parse(value) > 1000000000000 ||
              int.parse(value) < -1000000000000) {
            return AppLocalizations.of(context)!.outOfRange;
          }

          return null;
        },
        onChanged: (value) {
          //remove zeros at the beginning
          if (value.length > 1 && value.startsWith('0')) {
            controller.text = value.substring(1);
            controller.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.text.length));
          } else if (value.length > 2 && value.startsWith('-0')) {
            controller.text = '-${value.substring(2)}';
            controller.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.text.length));
          } else if (value == '-0') {
            controller.text = '0';
            controller.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.text.length));
          }
        },
        decoration: InputDecoration(
          labelText: label,
          hintText: label,
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue,
            ),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
