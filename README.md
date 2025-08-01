# Eventeny - Event Management App

A modern Flutter application for event discovery and ticket purchasing, built with clean architecture principles and best practices.

## 🚀 Features

- **Event Discovery**: Browse through multiple events with detailed information
- **Ticket Management**: Purchase multiple types of tickets for each event
- **Real-time Availability**: See ticket availability and sold-out status
- **Modern UI**: Beautiful, responsive design with Material Design 3
- **Error Handling**: Comprehensive error handling with user-friendly messages
- **State Management**: Efficient state management using Provider pattern
- **Pull-to-Refresh**: Refresh data with intuitive gestures

## 🏗️ Architecture

The app follows clean architecture principles with the following structure:

```
lib/
├── core/
│   ├── constants/          # App-wide constants
│   ├── errors/            # Custom exception classes
│   └── utils/             # Utility functions
├── models/                # Data models
├── providers/             # State management
├── screens/               # UI screens
├── services/              # API services
└── widgets/               # Reusable UI components
```

### Key Architectural Decisions

1. **Separation of Concerns**: Clear separation between data, business logic, and UI
2. **Dependency Injection**: Using Provider for state management
3. **Error Handling**: Custom exception classes with proper error propagation
4. **Constants Management**: Centralized configuration and constants
5. **Reusable Components**: Modular widget design for maintainability

## 🛠️ Technology Stack

- **Framework**: Flutter 3.8.1+
- **State Management**: Provider 6.1.1
- **HTTP Client**: http 0.13.6
- **Date Formatting**: intl 0.18.1
- **UI**: Material Design 3

## 📱 Core Functionality

### Event Selection
- Users can browse through multiple events
- Each event displays:
  - Title and description
  - Location and date
  - Organizer information
  - Event image (if available)

### Ticket Purchasing
- Multiple ticket types per event
- Real-time availability tracking
- Price display and total calculation
- Sold-out status indication
- Limited availability warnings

## 🎨 UI/UX Features

### Design System
- Consistent color scheme and typography
- Material Design 3 components
- Responsive layout design
- Accessibility considerations

### User Experience
- Loading states with informative messages
- Error states with retry functionality
- Pull-to-refresh for data updates
- Smooth navigation between screens
- Success feedback for user actions

## 🔧 Setup and Installation

1. **Prerequisites**
   - Flutter SDK 3.8.1 or higher
   - Dart SDK 3.8.1 or higher
   - Android Studio / VS Code

2. **Installation**
   ```bash
   # Clone the repository
   git clone <repository-url>
   cd eventeny

   # Install dependencies
   flutter pub get

   # Run the app
   flutter run
   ```

3. **API Configuration**
   - Update the API base URL in `lib/core/constants/app_constants.dart`
   - Ensure your backend endpoints match the expected format

## 📊 State Management

The app uses Provider pattern for state management:

### EventProvider
- Manages event data and loading states
- Handles event fetching and error states
- Provides event filtering and search capabilities

### TicketProvider
- Manages ticket data for selected events
- Handles ticket availability and purchase states
- Provides ticket filtering and categorization

## 🛡️ Error Handling

### Custom Exceptions
- `AppException`: Base exception class
- `NetworkException`: Network-related errors
- `ServerException`: Server-side errors
- `ValidationException`: Data validation errors

### Error Recovery
- Automatic retry mechanisms
- User-friendly error messages
- Graceful degradation for network issues

## 🧪 Testing

The app includes comprehensive testing:

```bash
# Run unit tests
flutter test

# Run widget tests
flutter test test/widget_test.dart
```

## 📦 Dependencies

### Production Dependencies
- `flutter`: Core Flutter framework
- `provider`: State management
- `http`: HTTP client for API calls
- `intl`: Internationalization and date formatting

### Development Dependencies
- `flutter_test`: Testing framework
- `flutter_lints`: Code quality and linting

## 🚀 Performance Optimizations

1. **Efficient State Management**: Minimal rebuilds with Provider
2. **Image Loading**: Error handling for network images
3. **Memory Management**: Proper disposal of resources
4. **Lazy Loading**: Load data only when needed

## 🔒 Security Considerations

1. **Input Validation**: All user inputs are validated
2. **Error Sanitization**: Error messages don't expose sensitive information
3. **Network Security**: HTTPS for API communications (recommended)

## 📈 Future Enhancements

- [ ] User authentication and profiles
- [ ] Payment integration
- [ ] Push notifications
- [ ] Offline support
- [ ] Multi-language support
- [ ] Dark theme
- [ ] Event search and filtering
- [ ] Ticket QR codes
- [ ] Event sharing

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the documentation

---

**Built with ❤️ using Flutter**
