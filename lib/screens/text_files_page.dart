import 'package:flutter/material.dart';
import 'package:subject_library/screens/text_file_viewer_page.dart';
import 'package:subject_library/models/text_file.dart';
import 'package:subject_library/utils/add_file_dialog.dart';
import 'package:subject_library/services/api_service.dart';

class TextFilesPage extends StatefulWidget {
  final String mainTopic;
  final String subtopic;

  const TextFilesPage({
    super.key,
    required this.mainTopic,
    required this.subtopic,
  });

  @override
  State<TextFilesPage> createState() => _TextFilesPageState();
}

class _TextFilesPageState extends State<TextFilesPage> {
  late Future<List<TextFile>> _filesFuture;

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  void _loadFiles() {
    setState(() {
       
      _filesFuture = ApiService.getTextFilesByTopicAndSubtopic(
        widget.mainTopic,
        widget.subtopic,
      );
    });
  }

 void _showAddFileDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AddFileDialog(
      mainTopic: widget.mainTopic,
      subtopic: widget.subtopic,
      onFileAdded: (newFile) async {
        try {
          await ApiService.createTextFile(newFile);
          if (mounted) {
            _loadFiles();
            Navigator.pop(context); // Close the dialog after successful addition
          }
        } catch (e) {
          if (mounted) {
            _showErrorSnackbar(context, 'Failed to create note: $e');
          }
        }
      },
    ),
  );
}

  Future<void> _deleteFile(String id) async {
    try {
      await ApiService.deleteTextFile(id);
      _loadFiles();

      // Check if the widget is still mounted before using context
      if (!mounted) return;

      // Refresh the page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => TextFilesPage(
                mainTopic: widget.mainTopic,
                subtopic: widget.subtopic,
              ),
        ),
      );
    } catch (e) {
      // Check if the widget is still mounted before using context
      if (!mounted) return;

      _showErrorSnackbar(context, 'Failed to delete note: $e');
    }
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subtopic),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddFileDialog(context),
          ),
        ],
      ),
      body: FutureBuilder<List<TextFile>>(
        future: _filesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load notes',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(snapshot.error.toString(), textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadFiles,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final files = snapshot.data ?? [];

          if (files.isEmpty) {
            return const Center(child: Text("No files added yet"));
          }

          return ListView.builder(
            itemCount: files.length,
            itemBuilder: (context, index) {
              final file = files[index];

              return Card(
                child: ListTile(
                  title: Text(file.title),
                  subtitle: Text("By ${file.author}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _confirmDelete(context, file.id),
                  ),
                  onTap: () => _openFileViewer(context, file),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _openFileViewer(BuildContext context, TextFile file) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => TextFileViewerPage(
        file: file,
        onDelete: () => _deleteFile(file.id),
        onUpdate: (updatedFile) {
       
          if (mounted) {
            _loadFiles(); // Refresh the file list
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('File updated successfully')),
            );
          }
        },
      ),
    ),
  );
}

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Note'),
            content: const Text('Are you sure you want to delete this note?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  _deleteFile(id);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}
