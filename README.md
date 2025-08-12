# Flutter QR code generator - Chrome extension

Chrome extension created using Flutter for generating QR code from either a text or URL. The QR code's background and foreground colors are also customizable.

![Chrome extension in action](screenshots/qr-code-ext-demo.gif)

## Usage

To use this project as a Chrome extension, follow the steps below:

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
   flutter build web --csp
   ```
   
   **Note:** The `--web-renderer html` flag is no longer needed in newer Flutter versions as HTML renderer is now the default for web builds.

4. Go to the following URL from Chrome browser:
   
   ```url
   chrome://extensions
   ```

5. Enable the **Developer mode** (toggle in the top right corner).

6. Click **Load unpacked**. Select the `<project_dir>/build/web` folder.

This will install the extension to your Chrome browser and then you will be able to access the extension by clicking on the **extension icon**.

## Development

For development and testing, you can run the Flutter app directly in Chrome:

```sh
flutter run -d chrome
```

This allows you to test the functionality before building the extension.

## Requirements

- Flutter SDK (latest stable version recommended)
- Chrome browser
- Developer mode enabled in Chrome extensions

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
