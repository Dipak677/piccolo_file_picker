## piccolo_file_picker - A versatile media and file picker for images, videos, and documents with customizable options for filtering and multi-selection

[![pub package](https://img.shields.io/pub/v/piccolo_file_picker.svg)](https://pub.dev/packages/piccolo_file_picker)


<p align="center" style="display: flex; flex-direction: column; align-items: center;">
    <table>
        <tr>
            <td align="center">
                <img src="https://raw.githubusercontent.com/Dipak677/piccolo_file_picker/refs/heads/main/piccolo_file_picker.jpg?raw=true" alt="Piccolo File Picker" width="300px">
            </td>
        </tr>
    </table>
</p>

---

The ```piccolo_file_picker``` package allows developers to easily integrate media and file selection capabilities into their Flutter applications. It supports picking images, videos, and files with additional options for file filtering, multiple selection, and source-based media selection.

## Features ✨

- Pick images from the gallery or camera.
- Pick videos from the gallery or camera.
- Pick files from the device storage with support for filtering by file extensions.
- Handle both single and multiple file selections.
- A listener-based approach for receiving file pick results.

## Installation 🚀

First, we need to add ```piccolo_file_picker``` to our ```pubspec.yaml``` file.

Install the package by running the following command from the project root:

```bash
flutter pub add piccolo_file_picker
```

## Usage 🧑‍💻

#### 1. Import the Package

```dart
import 'package:piccolo_file_picker/piccolo_file_picker.dart';
```

#### 2. Create a Listener Class

Implement the ```PiccoloPickerListener``` interface in your class to handle file pick results:

#### 3. Initialize the PiccoloPickerHandler

Create an instance of ```PiccoloPickerHandler``` and pass the listener:

```dart
final pickerHandler = PiccoloPickerHandler(MyPickerListener());
```

#### 4. Use the API

Call the appropriate method to pick media or files:

- Pick Image from Gallery
```dart
await pickerHandler.pickImageFromGallery();
```
- Pick Image from Camera
```dart
await pickerHandler.pickImageFromCamera();
```
- Pick Video from Gallery
```dart
await pickerHandler.pickVideoFromGallery();
```
- Pick Video from Camera
```dart
await pickerHandler.pickVideoFromCamera();
```
- Pick Files from Storage

To pick files from storage, specify allowed extensions and whether multiple files are allowed:
```dart
await pickerHandler.pickFileFromStorage(
  allowedExtensions: ['pdf', 'docx', 'jpg'], // Optional
  allowMultiple: true, // Optional, defaults to false
  allowCompression: true, // Optional, defaults to true
);

```
## Example
Here’s an example implementation in a Flutter app:

```dart
import 'package:flutter/material.dart';
import 'package:piccolo_file_picker/piccolo_file_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FilePickerDemo(),
    );
  }
}

class FilePickerDemo extends StatelessWidget implements PiccoloPickerListener {
  late PiccoloPickerHandler _pickerHandler;

  FilePickerDemo() {
    _pickerHandler = PiccoloPickerHandler(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Piccolo File Picker')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await _pickerHandler.pickImageFromGallery();
              },
              child: Text('Pick Image from Gallery'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _pickerHandler.pickFileFromStorage(
                  allowedExtensions: ['pdf', 'jpg', 'png'],
                  allowMultiple: true,
                );
              },
              child: Text('Pick Files from Storage'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onFilePicked(result, {bool isList = false}) {
    if (isList) {
      print("Picked files: $result");
    } else {
      print("Picked file: $result");
    }
  }
}
```
## API Reference

#### PiccoloPickerHandler
Main class for file picking operations.

##### Methods:

- ```pickImageFromGallery```: Picks an image from the gallery.

- ```pickImageFromCamera```: Picks an image using the camera.

- ```pickVideoFromGallery```: Picks a video from the gallery.

- ```pickVideoFromCamera```: Picks a video using the camera.

- ```pickFileFromStorage```: Picks a file from storage with optional extension filtering and multiple selection.



#### PiccoloPickerListener
An abstract interface to handle file pick results.

##### Method
-  ```onFilePicked(dynamic result, {bool isList = false})```

- Handles the result of file picking.

- ```result```: Can be a single file path (```String```) or a list of file paths (```List<String>```).

- ```isList```: Indicates whether the result is a list of files.

## Dependencies
The package uses the following Flutter plugins:

- [file_picker](https://pub.dev/packages/file_picker)
- [image_picker](https://pub.dev/packages/image_picker)

## License

This package is licensed under the MIT License. See the [LICENSE](https://opensource.org/license/mit) file for more information.


# piccolo_file_picker
