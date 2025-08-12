# Flutter QR Code Generator

A Flutter web application for generating QR codes from text or URLs. The QR code's background and foreground colors are customizable.

![QR Code Generator in action](screenshots/qr-code-ext-demo.gif)

## Usage

To run this project as a Flutter web application, follow the steps below:

1. Clone this project using:
   
    ```sh
    git clone https://github.com/sbis04/flutter_qr_extension.git
    ```

2. Navigate to the project directory:
   
   ```sh
   cd flutter_qr_extension
   ```

3. From the project directory, run:
   
   ```sh
   flutter build web
   ```
   
   Or to run in development mode:
   
   ```sh
   flutter run -d chrome
   ```

4. Open the generated web application by serving the `build/web` folder or accessing it via your local development server.

## Development

For development and testing, you can run the Flutter app directly in Chrome:

```sh
flutter run -d chrome
```

This allows you to test the functionality in real-time with hot reload.

## Deployment

After building for web, you can deploy the contents of the `build/web` folder to any web hosting service such as:

- GitHub Pages
- Netlify
- Vercel
- Firebase Hosting
- Or any static hosting provider

## Requirements

- Flutter SDK (latest stable version recommended)
- Chrome browser (or any modern web browser)

## Features

- Generate QR codes from text or URLs
- Customizable foreground and background colors
- Responsive design for web
- Clean and intuitive user interface

## License

Copyright (c) 2022 Souvik Biswas

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
