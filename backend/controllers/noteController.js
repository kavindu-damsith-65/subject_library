const Note = require('../models/Note');

exports.createNote = async (req, res) => {
  try {
    const { mainTopic, subtopic, title, author, content } = req.body;
    
    const note = await Note.create({
      user: req.user.id,
      mainTopic,
      subtopic,
      title,
      author,
      content
    });

    res.status(201).json({
      success: true,
      data: note
    });
  } catch (err) {
    res.status(400).json({
      success: false,
      error: err.message
    });
  }
};

exports.getNotes = async (req, res) => {
  try {
    const { mainTopic, subtopic } = req.query;
   
    const notes = await Note.find({
      user: req.user.id,
      mainTopic,
      subtopic
    }).sort('-createdAt');

    const transformedNotes = notes.map(note => {
        const noteObject = note.toObject();
        noteObject.id = noteObject._id; // Add id field
        delete noteObject._id; // Remove _id field
        return noteObject;
      });

    res.status(200).json(transformedNotes);

  } catch (err) {
    res.status(400).json({
      success: false,
      error: err.message
    });
  }
};

exports.updateNote = async (req, res) => {
  try {
    let note = await Note.findById(req.params.id);

    if (!note) {
      return res.status(404).json({
        success: false,
        error: 'Note not found'
      });
    }

    // Verify user ownership
    if (note.user.toString() !== req.user.id) {
      return res.status(401).json({
        success: false,
        error: 'Not authorized to update this note'
      });
    }

    note = await Note.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true
    });

    res.status(200).json({
      success: true,
      data: note
    });
  } catch (err) {
    res.status(400).json({
      success: false,
      error: err.message
    });
  }
};

exports.deleteNote = async (req, res) => {
  try {
    const note = await Note.findById(req.params.id);
     
    if (!note) {
      return res.status(404).json({
        success: false,
        error: 'Note not found'
      });
    }

    // Verify user ownership
    if (note.user.toString() !== req.user.id) {
      return res.status(401).json({
        success: false,
        error: 'Not authorized to delete this note'
      });
    }

    await note.deleteOne();

    res.status(200).json({
      success: true,
      data: {}
    });
  } catch (err) {
    console.log(err)
    res.status(400).json({
      success: false,
      error: err.message
    });
  }
};





