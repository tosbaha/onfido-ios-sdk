const express = require('express');
const morgan = require('morgan');

const app = express();
const port = 3000;

// Use morgan to log requests to the console
app.use(morgan('combined'));

// Middleware to parse JSON bodies
app.use(express.json());

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

// Handle all routes and methods
app.all('*', (req, res) => {
    console.log('Headers:', req.headers);
    if (req.body) {
        console.log('Body:', req.body);
    }
    res.status(200).send('OK');
});

app.listen(port, () => {
    console.log(`Mock server is listening on port ${port}`);
});

