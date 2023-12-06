import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage (ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(
      source: source,
      requestFullMetadata: false
  );

  if(_file != null){
    return await _file.readAsBytes();
  }
  print('No Images Selected');
}