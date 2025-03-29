# Alcholater

A Flutter app that helps you determine the best value when purchasing alcohol products.

## Features

- Calculate and compare value ratios for different alcohol products
- Display price per liter, standard drinks, and price per standard drink
- Sort products by best value
- Easy-to-use interface for adding new products
- Works on both Android and iOS devices

## Getting Started

### Prerequisites

- Flutter SDK
- Android Studio or Xcode (for deploying to devices)

### Installation

1. Clone this repository
```
git clone git@github.com:exit328/Alcholater.git
```

2. Navigate to the project directory
```
cd Alcholater
```

3. Get dependencies
```
flutter pub get
```

4. Run the app
```
flutter run
```

## How It Works

The app calculates the "value ratio" of alcohol products based on:
- Price
- Volume (in ml)
- Alcohol percentage

The value ratio represents milliliters of pure alcohol per dollar spent. Higher values indicate better value for money.

## Building for Production

### Android
```
flutter build apk --release
```

### iOS
```
flutter build ios --release
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.
