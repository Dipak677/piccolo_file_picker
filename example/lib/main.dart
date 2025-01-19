import 'package:flutter/material.dart';
import 'package:piccolo_file_picker/piccolo_file_picker.dart';
import 'package:path/path.dart' as p;

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PiccoloFilePickerExample(),
    ),
  );
}

class PiccoloFilePickerExample extends StatefulWidget {
  const PiccoloFilePickerExample({super.key});

  @override
  State<PiccoloFilePickerExample> createState() =>
      _PiccoloFilePickerExampleState();
}

class _PiccoloFilePickerExampleState extends State<PiccoloFilePickerExample>
    implements PiccoloPickerListener {
  final Map<FileType, String> _selectedFiles = {};
  late final PiccoloPickerHandler _pickerHandler;

  @override
  void initState() {
    super.initState();
    _pickerHandler = PiccoloPickerHandler(this);
  }

  @override
  void onFilePicked(dynamic result, {bool isList = false}) {
    if (result == null) return;

    setState(() {
      if (isList) {
        _selectedFiles[FileType.multiple] =
            (result as List<String>).map(p.basename).join(', ');
      } else {
        _selectedFiles[_currentType] = result.toString();
      }
    });
  }

  FileType _currentType = FileType.camera;

  void _pickFile(FileType type) {
    _currentType = type;
    switch (type) {
      case FileType.camera:
        _pickerHandler.pickImageFromCamera();
      case FileType.gallery:
        _pickerHandler.pickImageFromGallery();
      case FileType.videoCamera:
        _pickerHandler.pickVideoFromCamera();
      case FileType.videoGallery:
        _pickerHandler.pickVideoFromGallery();
      case FileType.single:
        _pickerHandler.pickFileFromStorage();
      case FileType.multiple:
        _pickerHandler.pickFileFromStorage(allowMultiple: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF159e0e),
        title: const Text(
          'Piccolo File Picker Example',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Files:\n(Supported platform: Android, iOS)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final type = FileType.values[index];
                  return PickerCard(
                    type: type,
                    onTap: () => _pickFile(type),
                  );
                },
                childCount: FileType.values.length,
              ),
            ),
          ),
          if (_selectedFiles.isNotEmpty)
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(top: 24),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Selected Files',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._selectedFiles.entries.map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: FileCard(
                          type: e.key,
                          path: e.value,
                          onRemove: () =>
                              setState(() => _selectedFiles.remove(e.key)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

enum FileType {
  camera('Camera\nImage', Icons.camera_alt),
  gallery('Gallery\nImage', Icons.photo_library),
  videoCamera('Camera\nVideo', Icons.videocam),
  videoGallery('Gallery\nVideo', Icons.video_library),
  single('Single\nFile', Icons.file_present),
  multiple('Multiple\nFiles', Icons.folder);

  const FileType(this.label, this.icon);
  final String label;
  final IconData icon;
}

class PickerCard extends StatelessWidget {
  const PickerCard({super.key, required this.type, required this.onTap});

  final FileType type;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFF159e0e).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    type.icon,
                    size: 28,
                    color: Color(0xFF159e0e),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  type.label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class FileCard extends StatelessWidget {
  const FileCard(
      {super.key,
      required this.type,
      required this.path,
      required this.onRemove});

  final FileType type;
  final String path;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF159e0e).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              type.icon,
              color: Color(0xFF159e0e),
            ),
          ),
          title: Text(
            type.label.replaceAll('\n', ' '),
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            p.basename(path),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.close),
            onPressed: onRemove,
            color: Colors.grey[600],
          ),
        ),
      );
}
