import 'package:flutter/material.dart';

class Data{
  // Function to show a loading indicator dialog
  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                "Generating ticket, please wait...",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        );
      },
    );
  }


}

enum VehicleType { car, bike }
class CustomDropdown extends StatelessWidget {
  final String? value;
  final List<String> items;
  final String hint;
  final ValueChanged<String?> onChanged;
  final bool clearable;

  CustomDropdown({
    required this.value,
    required this.items,
    required this.hint,
    required this.onChanged,
    this.clearable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (textEditingValue) {
        return autocompleteSuggestions(textEditingValue.text);
      },
      onSelected: onChanged,
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
        return TextField(
          decoration: InputDecoration(
            labelText: hint,
            counterText: "",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF004EA3), width: 1.0),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF004EA3), width: 2.0),
              borderRadius: BorderRadius.circular(12),
            ),
            suffixIcon: clearable && textEditingController.text.isNotEmpty
                ? IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                textEditingController.clear();
                onChanged(null);
              },
            )
                : null,
          ),
          controller: textEditingController,
          focusNode: focusNode,
        );
      },
    );
  }

  Iterable<String> autocompleteSuggestions(String pattern) sync* {
    yield* items
        .where((item) => item.toLowerCase().contains(pattern.toLowerCase()));
  }
}

class CustomDropdowns extends StatelessWidget {
  final String? value;
  final List<String> items;
  final String hint;
  final ValueChanged<String?> onChanged;

  CustomDropdowns({
    required this.value,
    required this.items,
    required this.hint,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF004EA3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        hint: Text(hint, style: TextStyle(color: Colors.grey)),
        value: value,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item, style: TextStyle(fontSize: 16)),
          );
        }).toList(),
        onChanged: onChanged,
        underline: SizedBox(),
      ),
    );
  }
}