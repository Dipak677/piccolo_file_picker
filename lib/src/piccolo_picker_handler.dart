import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:piccolo_file_picker/src/piccolo_picker_listener.dart';

/// A handler class for picking media and files.
/// Provides methods to pick images, videos, and files with various options.
class PiccoloPickerHandler {
  /// Listener to handle callbacks when a file is picked.
  final PiccoloPickerListener _listener;

  /// Creates an instance of [PiccoloPickerHandler] with the provided [listener].
  PiccoloPickerHandler(this._listener);

  /// Instance of [ImagePicker] for picking media.
  final ImagePicker _imagePicker = ImagePicker();

  /// Picks an image from the device's gallery.
  Future<void> pickImageFromGallery({int? imageQuality}) async =>
      await _pickMedia(source: ImageSource.gallery, isImage: true, imageQuality: imageQuality);

  /// Captures an image using the device's camera.
  Future<void> pickImageFromCamera({int? imageQuality}) async =>
      await _pickMedia(source: ImageSource.camera, isImage: true, imageQuality: imageQuality);

  /// Picks a video from the device's gallery.
  Future<void> pickVideoFromGallery() async => await _pickMedia(source: ImageSource.gallery, isImage: false);

  /// Captures a video using the device's camera.
  Future<void> pickVideoFromCamera() async => await _pickMedia(source: ImageSource.camera, isImage: false);

  /// Picks a file from the device's storage.
  ///
  /// - [allowedExtensions]: A list of file extensions to filter the files (e.g., `['pdf', 'jpg']`).
  /// - [allowMultiple]: If `true`, allows selecting multiple files. Defaults to `false`.
  /// - [allowCompression]: If `true`, allows compression for selected files. Defaults to `true`.
  Future<void> pickFileFromStorage({
    List<String>? allowedExtensions,
    bool allowMultiple = false,
    bool allowCompression = true,
    int compressionQuality = 30,
  }) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: allowMultiple,
        type: allowedExtensions == null ? FileType.any : FileType.custom,
        allowedExtensions: allowedExtensions,
        allowCompression: allowCompression,
        compressionQuality: compressionQuality,
      );

      // Check if files were picked
      if (result != null) {
        if (result.files.length > 1) {
          // If multiple files picked, send a list to the listener
          _listener.onFilePicked(result.files.map((file) => file.path!).toList(), isList: true);
        } else {
          // If a single file picked, send the single path to the listener
          _listener.onFilePicked(result.files.single.path);
        }
      } else {
        // Null if no file was picked
        _listener.onFilePicked(null);
      }
    } catch (e) {
      log("PiccoloPickerHandler Error picking file: $e");
    }
  }

  /// Internal method to pick media (images/videos) from the specified [source].
  ///
  /// - [source]: The source to pick media from (e.g., gallery or camera).
  /// - [isImage]: If `true`, picks an image; otherwise, picks a video.
  Future<void> _pickMedia({
    required ImageSource source,
    required bool isImage,
    int? imageQuality,
  }) async {
    try {
      XFile? pickedFile = isImage
          ? await _imagePicker.pickImage(source: source, imageQuality: imageQuality)
          : await _imagePicker.pickVideo(source: source);

      // Notify the listener with the picked file path or null if no file was picked
      if (pickedFile != null) {
        _listener.onFilePicked(File(pickedFile.path).path);
      } else {
        _listener.onFilePicked(null);
      }
    } catch (e) {
      log("PiccoloPickerHandler Error picking media: $e");
    }
  }
}
