# AnuScript Mobile 📱

A beautiful, feature-rich mobile application for typing and creating documents in Indian languages. Inspired by [Anu Script Manager](https://www.anuscriptmanager.com/), this Android app brings multilingual typing capabilities to your mobile device.

![AnuScript Mobile](https://img.shields.io/badge/Platform-Android-brightgreen)
![Flutter](https://img.shields.io/badge/Built%20with-Flutter-blue)
![Languages](https://img.shields.io/badge/Languages-11+-orange)

## ✨ Features

### 🔤 Multilingual Support
- **Hindi** (हिन्दी) - Devanagari script
- **Telugu** (తెలుగు) - Telugu script
- **Tamil** (தமிழ்) - Tamil script
- **Malayalam** (മലയാളം) - Malayalam script
- **Kannada** (ಕನ್ನಡ) - Kannada script
- **Bengali** (বাংলা) - Bengali script
- **Marathi** (मराठी) - Devanagari script
- **Gujarati** (ગુજરાતી) - Gujarati script
- **Punjabi** (ਪੰਜਾਬੀ) - Gurmukhi script
- **Odia** (ଓଡ଼ିଆ) - Oriya script
- **English** - Latin script

### ⌨️ Custom Keyboard
- Dedicated keyboard layouts for each language
- Easy switching between vowels, consonants, matras, and numbers
- Special characters including Indian numerals (१२३, ౧౨౩, etc.)
- Haptic feedback for better typing experience
- Space, backspace, and enter keys

### 📝 Document Editor
- Create and edit documents in any supported language
- Text formatting (Bold, Italic, Underline)
- Text alignment (Left, Center, Right, Justify)
- Adjustable font size
- Language-specific fonts for accurate rendering

### 📤 Export & Share
- Share documents as text
- Export to PDF
- Copy to clipboard
- Local document storage

### 🎨 Beautiful Design
- Modern, dark theme with Indian-inspired colors
- Saffron and navy blue accent colors
- Animated background with mandala patterns
- Smooth animations and transitions
- Language-specific color themes

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

1. **Flutter SDK** (3.0.0 or higher)
   - Download from: https://flutter.dev/docs/get-started/install

2. **Android Studio** or **VS Code** with Flutter extension
   - Android Studio: https://developer.android.com/studio
   - VS Code: https://code.visualstudio.com/

3. **Android SDK** (API level 21 or higher)

4. **Java Development Kit (JDK)** 11 or higher

## 🚀 Installation

### Step 1: Clone/Download the Project

The project is located at:
```
C:\Users\thank\Desktop\anu_script_mobile
```

### Step 2: Download Required Fonts

Create the `assets/fonts/` directory and download the Noto Sans fonts for Indian languages:

```powershell
# Create directories
mkdir assets\fonts
mkdir assets\images
```

Download fonts from Google Fonts:
- [Noto Sans Devanagari](https://fonts.google.com/noto/specimen/Noto+Sans+Devanagari) (for Hindi, Marathi)
- [Noto Sans Telugu](https://fonts.google.com/noto/specimen/Noto+Sans+Telugu)
- [Noto Sans Tamil](https://fonts.google.com/noto/specimen/Noto+Sans+Tamil)
- [Noto Sans Malayalam](https://fonts.google.com/noto/specimen/Noto+Sans+Malayalam)
- [Noto Sans Kannada](https://fonts.google.com/noto/specimen/Noto+Sans+Kannada)
- [Noto Sans Bengali](https://fonts.google.com/noto/specimen/Noto+Sans+Bengali)
- [Noto Sans Gujarati](https://fonts.google.com/noto/specimen/Noto+Sans+Gujarati)
- [Noto Sans Gurmukhi](https://fonts.google.com/noto/specimen/Noto+Sans+Gurmukhi)
- [Noto Sans Oriya](https://fonts.google.com/noto/specimen/Noto+Sans+Oriya)

Place the `.ttf` files in `assets/fonts/` with these names:
- `NotoSansDevanagari-Regular.ttf`
- `NotoSansDevanagari-Bold.ttf`
- `NotoSansTelugu-Regular.ttf`
- `NotoSansTelugu-Bold.ttf`
- (and so on for other scripts...)

### Step 3: Install Dependencies

Open terminal in the project directory and run:

```powershell
cd C:\Users\thank\Desktop\anu_script_mobile
flutter pub get
```

### Step 4: Create local.properties

Create `android/local.properties` file with your SDK path:

```properties
sdk.dir=C:\\Users\\thank\\AppData\\Local\\Android\\Sdk
flutter.sdk=C:\\flutter
```

(Adjust paths according to your installation)

### Step 5: Run the App

Connect an Android device or start an emulator, then run:

```powershell
flutter run
```

## 🏗️ Building APK

### Debug APK
```powershell
flutter build apk --debug
```

### Release APK
```powershell
flutter build apk --release
```

The APK will be generated at:
`build/app/outputs/flutter-apk/app-release.apk`

### App Bundle (for Play Store)
```powershell
flutter build appbundle --release
```

## 📁 Project Structure

```
anu_script_mobile/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── theme/
│   │   └── app_theme.dart        # Theme configuration
│   ├── models/
│   │   ├── language_model.dart   # Language & keyboard data
│   │   └── document_model.dart   # Document model
│   ├── providers/
│   │   ├── language_provider.dart    # Language state
│   │   └── document_provider.dart    # Document state
│   ├── screens/
│   │   ├── home_screen.dart      # Home page
│   │   └── editor_screen.dart    # Document editor
│   └── widgets/
│       ├── custom_keyboard.dart      # Indian language keyboard
│       ├── formatting_toolbar.dart   # Text formatting tools
│       ├── language_card.dart        # Language selection card
│       ├── document_card.dart        # Document list item
│       └── animated_background.dart  # Background animation
├── android/                      # Android configuration
├── assets/
│   ├── fonts/                    # Indian language fonts
│   └── images/                   # App images
├── pubspec.yaml                  # Dependencies
└── README.md                     # This file
```

## 🎯 Usage Guide

### Creating a New Document
1. Open the app
2. Select your preferred language from the language selector
3. Tap the **"+ New"** button or **"New Document"** card
4. Start typing using the custom keyboard

### Switching Languages
1. In the editor, tap the language indicator (shows current language)
2. Select a new language from the grid
3. The keyboard will update to show the new language's characters

### Using the Custom Keyboard
- **Vowels (स्वर)**: Basic vowel characters
- **Consonants (व्यंजन)**: Consonant characters
- **Matras (मात्रा)**: Vowel marks/matras
- **Numbers (१२३)**: Native numerals
- **Special (@#₹)**: Special characters, punctuation

### Formatting Text
1. Tap the **"A"** icon in the toolbar to show formatting options
2. Use Bold, Italic, Underline buttons
3. Adjust text alignment
4. Change font size with +/- buttons

### Exporting Documents
1. Tap the **"..."** (more) button in the editor
2. Choose:
   - **Share**: Share as text
   - **Export PDF**: Create a PDF file
   - **Copy All**: Copy to clipboard

## 🔧 Customization

### Adding a New Language
1. Open `lib/models/language_model.dart`
2. Add a new `IndianLanguage` entry with:
   - Language code
   - Names (English and native)
   - Font family
   - Keyboard layout
   - Theme color

### Changing Theme Colors
Edit `lib/theme/app_theme.dart` to customize:
- Primary colors
- Background colors
- Text colors
- Gradients

## 📱 System Requirements

- **Android**: 5.0 (API 21) or higher
- **RAM**: 2GB minimum, 4GB recommended
- **Storage**: 100MB for app installation

## 🤝 Contributing

Contributions are welcome! Feel free to:
- Report bugs
- Suggest new features
- Add support for more languages
- Improve keyboard layouts

## 📄 License

This project is open source and available under the MIT License.

## 🙏 Acknowledgments

- Inspired by [Anu Script Manager](https://www.anuscriptmanager.com/)
- Fonts provided by [Google Noto Fonts](https://fonts.google.com/noto)
- Built with [Flutter](https://flutter.dev/)

---

Made with ❤️ for Indian language users

