const mongoose = require('mongoose');

const noteSchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  mainTopic: {
    type: String,
    required: [true, 'Please add a main topic']
  },
  subtopic: {
    type: String,
    required: [true, 'Please add a subtopic']
  },
  title: {
    type: String,
    required: [true, 'Please add a title']
  },
  author: {
    type: String,
    required: [true, 'Please add an author']
  },
  content: {
    type: String,
    required: [true, 'Please add content']
  },
  createdAt: {
    type: Date,
    default: Date.now
  },
  updatedAt: {
    type: Date
  }
});

module.exports = mongoose.model('Note', noteSchema);