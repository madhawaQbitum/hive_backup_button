import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';
class HiveBackupButton extends StatefulWidget {
  const HiveBackupButton({
    super.key,
    required this.permission,
    required this.hiveBox,
  });
  final Future<bool> permission;
  final List<Box> hiveBox;

  @override
  State<HiveBackupButton> createState() => _HiveBackupButtonState();
}

class _HiveBackupButtonState extends State<HiveBackupButton> {
  Future<void> backupDatabase() async {
    if (await widget.permission) {

      const String backupDirectoryPath = '/storage/emulated/0/hive';
      final Directory backupDirectory = Directory(backupDirectoryPath);


      if (!await backupDirectory.exists()) {
        await backupDirectory.create(recursive: true);
      }


      for (Box box in widget.hiveBox) {
        final String boxFilePath = '${box.path}';
        final String boxBackupPath = '$backupDirectoryPath/${box.name}.hive';


        final File originalBoxFile = File(boxFilePath);
        if (await originalBoxFile.exists()) {
          await originalBoxFile.copy(boxBackupPath);
        }
      }

      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(content: Text('Backup completed successfully!')),
      );
    } else {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(content: Text('Permission denied for backup!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        await backupDatabase();
      },
      child: const Text("Backup Hive Data"),
    );
  }
}
