const express = require('express');
const morgan = require('morgan');
const nocache = require('nocache');
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const { v4: uuidv4 } = require('uuid'); // Import uuid to generate unique identifiers

const app = express();
const port = 3000;

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/');
  },
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, file.fieldname + '-' + uniqueSuffix + path.extname(file.originalname));
  }
});

// Initialize multer with the defined storage
const upload = multer({ storage: storage });

// Use morgan to log requests to the console
app.use(morgan('combined'));

// Don't use cache
app.use(nocache());
app.use(express.json());

app.post('/v3/documents', upload.single('file'), (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).send('No file uploaded.');
    }
    const uniqueId = uuidv4();
    res.json({"id":uniqueId,"sdk_warnings":{},});
  } catch (err) {
    console.error(err);
    res.status(500).send('Server error.');
  }
});

app.post('/v3/live_photos', upload.single('file'), (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).send('No file uploaded.');
    }
    const uniqueId = uuidv4();
    res.json({"id":uniqueId,"sdk_warnings":{},});
  } catch (err) {
    console.error(err);
    res.status(500).send('Server error.');
  }
});

app.post('/v4/analytics', (req, res) => {
  const requestBody = req.body;

  const timestamp = Date.now();
  const uniqueId = uuidv4();
  const fileName = `request_${timestamp}_${uniqueId}.json`;
  const filePath = path.join(__dirname, 'uploads', fileName); // Save in 'uploads' directory

    fs.writeFile(filePath, JSON.stringify(requestBody, null, 2), (err) => {
      if (err) {
        console.error('Error writing file:', err);
        return res.status(500).send('Server error.');
      }

      console.log('File saved successfully:', filePath);
      res.status(200).send('Request body saved successfully.');
  });
});

app.post('/v4/sdk/logger', (req, res) => {
  const requestBody = req.body;

  const timestamp = Date.now();
  const uniqueId = uuidv4();
  const fileName = `request_${timestamp}_${uniqueId}.json`;
  const filePath = path.join(__dirname, 'uploads', fileName); // Save in 'uploads' directory

    fs.writeFile(filePath, JSON.stringify(requestBody, null, 2), (err) => {
      if (err) {
        console.error('Error writing file:', err);
        return res.status(500).send('Server error.');
      }

      console.log('File saved successfully:', filePath);
      res.status(200).send('Request body saved successfully.');
  });
});

app.post('/v4/sdk/logger', (req, res) => {
  const timestamp = Date.now();
  const uniqueId = uuidv4();
  const fileName = `request_${timestamp}_${uniqueId}.json`;
  const filePath = path.join(__dirname, 'uploads', fileName); // Save in 'uploads' directory

  console.log('Headers:', req.headers);
  if (req.body) {
    console.log('Body:', req.body);
  }
  res.status(200).send('OK');
});

app.patch('/v3.3/applicants/:id/location', (req, res) => {
  console.log('Updating applicants for App Id:', req.params.id);
  const response = {};
  res.json(response);
});

app.get('/v3.3/applicants/:id/consents', (req, res) => {
  console.log('Consent for App Id:', req.params.id);
  const response = [
    {
      'granted': true,
      'name': 'privacy_notices_read',
      'required': true
    }
  ]
  res.json(response);
});

app.post('/v3.5/sdk/configurations', (req, res) => {
  const response = {
    sdk_features: {
      disable_cross_device_sms: false,
      enable_in_house_analytics: false,
      enable_on_device_face_detection: true,
      enable_require_applicant_consents: true,
    },
  };
  res.json(response);
});


app.listen(port, () => {
  console.log(`Mock server is listening on port ${port}`);
});

