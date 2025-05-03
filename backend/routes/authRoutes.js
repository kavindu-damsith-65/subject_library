const express = require('express');
const { protect } = require('../middlewares/auth');
const {
  signup,
  login,
  getMe
} = require('../controllers/authController');

const router = express.Router();

router.post('/signup', signup);
router.post('/login', login);
router.get('/me', protect, getMe);

module.exports = router;