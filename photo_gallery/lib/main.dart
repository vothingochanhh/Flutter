import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io'; // 1. Cần thiết để dùng kiểu 'File'

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Gallery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: GalleryScreen(),
    );
  }
}

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  // Trạng thái (State): Lưu danh sách các file ảnh
  final List<File> _images = [];

  // Đối tượng ImagePicker
  final ImagePicker _picker = ImagePicker();

  // --- HÀM LOGIC CHÍNH ---

  // 1. Hàm xin quyền (dùng permission_handler)
  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true; // Nếu đã có quyền thì trả về true
    } else {
      // Nếu chưa có, hãy xin quyền
      final result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false; // Trả về false nếu người dùng từ chối
  }

  // 2. Hàm lấy ảnh (dùng image_picker)
  Future<void> _pickImage(ImageSource source) async {
    // Tùy vào nguồn (camera/gallery) mà xin quyền tương ứng
    Permission requiredPermission;
    if (source == ImageSource.camera) {
      requiredPermission = Permission.camera;
    } else {
      // Tùy HĐH mà xin quyền photo hoặc storage
      requiredPermission = Platform.isIOS
          ? Permission.photos
          : Permission.storage;
    }

    // Kiểm tra quyền trước
    bool hasPermission = await _requestPermission(requiredPermission);
    if (!hasPermission) {
      // Hiển thị thông báo nếu bị từ chối
      _showErrorDialog("Permission denied. Please enable it in settings.");
      return;
    }

    // Nếu đã có quyền, gọi image_picker
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        // Nếu người dùng chọn/chụp ảnh thành công
        setState(() {
          // Thêm file ảnh vào danh sách
          _images.add(File(pickedFile.path));
        });
      }
    } catch (e) {
      _showErrorDialog("Failed to pick image: $e");
    }
  }

  // 3. Hàm hiển thị hộp thoại chọn (Camera hay Gallery)
  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  Navigator.of(context).pop(); // Đóng bottom sheet
                  _pickImage(ImageSource.gallery); // Gọi hàm gallery
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop(); // Đóng bottom sheet
                  _pickImage(ImageSource.camera); // Gọi hàm camera
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Hàm phụ hiển thị lỗi
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  // --- GIAO DIỆN (UI) ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Photo Gallery')),
      body: _images.isEmpty
          // 1. Nếu danh sách rỗng
          ? const Center(child: Text('No photos added yet.'))
          // 2. Nếu có ảnh, dùng GridView
          : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              // Yêu cầu: GridView
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Hiển thị 3 cột
                crossAxisSpacing: 8.0, // Khoảng cách ngang
                mainAxisSpacing: 8.0, // Khoảng cách dọc
              ),
              itemCount: _images.length,
              itemBuilder: (context, index) {
                // Hiển thị ảnh từ file
                return Image.file(
                  _images[index],
                  fit: BoxFit.cover, // Lấp đầy khung
                );
              },
            ),

      // Nút (+) để thêm ảnh
      floatingActionButton: FloatingActionButton(
        onPressed: _showPickerOptions, // Gọi hàm hiển thị lựa chọn
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}
