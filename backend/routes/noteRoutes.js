const express = require('express');
const router = express.Router();
const { protect } = require('../middlewares/auth');
const {
  getNotes,
  createNote,
  updateNote,
  deleteNote
} = require('../controllers/noteController');

router.route('/').get(protect, getNotes).post(protect, createNote);

router.route('/:id')
  .put(protect, updateNote)
  .delete(protect, deleteNote);

module.exports = router;