import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AvatarPickerScreen(),
  ));
}

class AvatarPickerScreen extends StatefulWidget {
  @override
  _AvatarPickerScreenState createState() => _AvatarPickerScreenState();
}

class _AvatarPickerScreenState extends State<AvatarPickerScreen> {
  File? _imageFile;
  int? _selectedAvatarIndex;
  final ImagePicker _picker = ImagePicker();

  // List of default avatars (Replace with actual asset paths)
  final List<String> _avatars =
      List.generate(10, (index) => "assets/avatar_$index.png");

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _selectedAvatarIndex = null; // Reset avatar selection
      });
    }
  }

  void _selectAvatar(int index) {
    setState(() {
      _selectedAvatarIndex = index;
      _imageFile = null; // Reset user-uploaded image
    });
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 250, // Ensures it doesn't overflow
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Take Photo"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Choose from Gallery"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Choose Avatar"),
              onTap: () {
                Navigator.pop(context);
                _showAvatarSelection();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAvatarSelection() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(10),
        height: 250,
        child: GridView.builder(
          itemCount: _avatars.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                _selectAvatar(index);
                Navigator.pop(context);
              },
              child: CircleAvatar(
                backgroundImage: AssetImage(_avatars[index]),
                radius: 30,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Profile Picture")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _showImagePickerOptions,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[300],
                backgroundImage: _imageFile != null
                    ? FileImage(_imageFile!)
                    : _selectedAvatarIndex != null
                        ? AssetImage(_avatars[_selectedAvatarIndex!])
                            as ImageProvider
                        : null,
                child: _imageFile == null && _selectedAvatarIndex == null
                    ? const Icon(Icons.add_a_photo,
                        size: 40, color: Colors.black54)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle image submission
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Profile picture selected!")),
                );
              },
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
