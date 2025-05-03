import 'package:flutter/material.dart';
import '../models/text_file.dart';
import '../services/api_service.dart';

class TextFileViewerPage extends StatefulWidget {
  final TextFile file;
  final VoidCallback onDelete;
  final Function(TextFile) onUpdate;

  const TextFileViewerPage({
    super.key,
    required this.file,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  State<TextFileViewerPage> createState() => _TextFileViewerPageState();
}

class _TextFileViewerPageState extends State<TextFileViewerPage> {
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _contentController;
  bool _isEditing = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.file.title);
    _authorController = TextEditingController(text: widget.file.author);
    _contentController = TextEditingController(text: widget.file.content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_isEditing) return;

    // Validate required fields
    if (_titleController.text.isEmpty || 
        _authorController.text.isEmpty || 
        _contentController.text.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Title, author and content are required')),
        );
      }
      return;
    }

    setState(() => _isSaving = true);

    try {
      final updatedFile = TextFile(
        id: widget.file.id,
        mainTopic: widget.file.mainTopic,
        subtopic: widget.file.subtopic,
        title: _titleController.text,
        author: _authorController.text,
        content: _contentController.text,
        createdAt: widget.file.createdAt,
        updatedAt: DateTime.now(),
      );

      final savedFile = await ApiService.updateTextFile(updatedFile);
      if (mounted) {
        widget.onUpdate(savedFile);
        setState(() => _isEditing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Changes saved successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save changes: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isEditing 
            ? TextField(
                controller: _titleController,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Title',
                  hintStyle: TextStyle(color: Colors.white70),
                ),
              )
            : Text(widget.file.title),
        actions: [
          if (_isEditing)
            IconButton(
              icon: _isSaving 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Icon(Icons.save),
              onPressed: _isSaving ? null : _saveChanges,
            )
          else
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _isEditing ? null : _confirmDelete,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Read-only topic information
            Text("Main Topic: ${widget.file.mainTopic}"),
            Text("Subtopic: ${widget.file.subtopic}"),
            const SizedBox(height: 8),
            
            // Editable author field (only when editing)
            _isEditing
                ? TextField(
                    controller: _authorController,
                    decoration: const InputDecoration(labelText: 'Author'),
                  )
                : Text("By ${widget.file.author}", 
                    style: TextStyle(color: Colors.grey.shade600)),
            
            const Divider(height: 20),
            
            // Content field
            Expanded(
              child: _isEditing
                  ? TextField(
                      controller: _contentController,
                      maxLines: null,
                      expands: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter your note content...',
                      ),
                    )
                  : SingleChildScrollView(
                      child: Text(widget.file.content),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: _isEditing
          ? FloatingActionButton(
              onPressed: _saveChanges,
              child: _isSaving
                  ? const CircularProgressIndicator()
                  : const Icon(Icons.save),
            )
          : null,
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete File"),
        content: const Text("Are you sure?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              widget.onDelete();
              Navigator.pop(context);
              if (mounted) Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}