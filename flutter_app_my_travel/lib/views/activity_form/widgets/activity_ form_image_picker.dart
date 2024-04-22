import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_travel/providers/city_provider.dart';
import 'package:provider/provider.dart';

class ActivityFormImagePicker extends StatefulWidget {
  final Function updateUrl;

  const ActivityFormImagePicker({
    super.key,
    required this.updateUrl,
  });

  @override
  State<ActivityFormImagePicker> createState() =>
      _ActivityFormImagePickerState();
}

class _ActivityFormImagePickerState extends State<ActivityFormImagePicker> {
  File? _deviceImage;
  final imagePicker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      XFile? pickedFile = await imagePicker.pickImage(source: source);
      if (pickedFile != null && mounted) {
        _deviceImage = File(pickedFile.path);
        final url = await Provider.of<CityProvider>(context, listen: false)
            .uploadImage(_deviceImage!);
        print('Url final:  $url');
        widget.updateUrl(url);

        setState(() {});
        print("image ok");
      } else {
        print('no image');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: () => _pickImage(ImageSource.gallery),
              icon: const Icon(Icons.photo),
              label: const Text('Galerie'),
            ),
            TextButton.icon(
              onPressed: () => _pickImage(ImageSource.camera),
              icon: const Icon(Icons.camera),
              label: const Text('camera'),
            ),
          ],
        ),
        SizedBox(
          width: double.infinity,
          child: _deviceImage != null
              ? Image.file(
                  _deviceImage!,
                  fit: BoxFit.cover,
                )
              : const Text("Aucune image"),
        )
      ],
    );
  }
}
