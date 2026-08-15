const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const userSchema = mongoose.Schema(
  {
    username: {
      type: String,
      required: [true, 'Lütfen bir kullanıcı adı girin'],
      unique: true,
      trim: true,
    },
    email: {
      type: String,
      required: [true, 'Lütfen bir e-posta adresi girin'],
      unique: true,
      trim: true,
      lowercase: true,
      match: [
        /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/,
        'Lütfen geçerli bir e-posta adresi girin',
      ],
    },
    password: {
      type: String,
      required: [true, 'Lütfen bir şifre girin'],
      minlength: [6, 'Şifre en az 6 karakter uzunluğunda olmalıdır'],
    },
  },
  {
    timestamps: true,
  }
);

// Şifreyi kaydetmeden önce hash'le
userSchema.pre('save', async function (next) {
  if (!this.isModified('password')) {
    next();
  }
  const salt = await bcrypt.genSalt(10);
  this.password = await bcrypt.hash(this.password, salt);
});

// Şifreleri karşılaştırma metodu
userSchema.methods.matchPassword = async function (enteredPassword) {
  return await bcrypt.compare(enteredPassword, this.password);
};

const User = mongoose.model('User', userSchema);

module.exports = User;
