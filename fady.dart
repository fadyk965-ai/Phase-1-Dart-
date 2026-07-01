import 'dart:io';
import 'dart:async';
class Book {
  final String title;
  final String author;
  final String isbn;
  Book({
    required this.title,
    required this.author,
    required this.isbn,
  });
}

mixin PremiumAssetRenter {
  void rentPremiumAsset({required String assetName, int durationInDays = 7}) {
    print("-> System: Premium asset '$assetName' allocated for $durationInDays days.");
  }
}
class User {
  final String name;
  final int id;
  User({required this.name, required this.id});

  void borrowBook(Book book, {int days = 14}) {
    print("-> System: Book '${book.title}' successfully checked out to $name (ID: $id) for $days days.");
  }
}
class PremiumUser extends User with PremiumAssetRenter {
  PremiumUser({required String name, required int id}) : super(name: name, id: id);
}
Future<List<Book>> fetchOnlineBooksCatalog() async {
  print("\n⏳ Loading library catalog from cloud server...");
  await Future.delayed(Duration(seconds: 3));
  print("✅ Catalog loaded successfully!\n");
  return [
    Book(title: "Dart Programming Guide", author: "Google Developers", isbn: "111-ABC"),
    Book(title: "Flutter UI Deep Dive", author: "Remi Rousselet", isbn: "222-DEF"),
    Book(title: "Clean Code", author: "Robert C. Martin", isbn: "333-XYZ"),
  ];
}

String promptForTextInput(String promptText, {bool allowNumbers = false}) {
  final RegExp nameRegex = RegExp(r'^[a-zA-Z\s\u0600-\u06FF]+$');
  while (true) {
    stdout.write(promptText);
    String? input = stdin.readLineSync();
    String cleaned = input?.trim() ?? "";
    if (cleaned.isNotEmpty) {
      if (!allowNumbers && !nameRegex.hasMatch(cleaned)) {
        print(" [Error] Invalid format. Numbers/special characters not allowed.");
        continue;
      }
      return cleaned;
    }
    print(" [Error] Field cannot be empty.");
  }
}
int promptForIntInput(String promptText) {
  while (true) {
    stdout.write(promptText);
    String? input = stdin.readLineSync();
    int? parsed = int.tryParse(input ?? "");

    if (parsed != null && parsed > 0) {
      return parsed;
    }
    print(" [Error] Please enter a valid positive integer.");
  }
}
int promptForOptionalInt(String promptText) {
  stdout.write(promptText);
  String? input = stdin.readLineSync();
  String cleaned = input?.trim() ?? "";
  if (cleaned.isEmpty) return 0;
  return int.tryParse(cleaned) ?? 0;
}
double promptForDoubleInput(String promptText) {
  while (true) {
    stdout.write(promptText);
    String? input = stdin.readLineSync();
    double? parsed = double.tryParse(input ?? "");

    if (parsed != null && parsed > 0) {
      return parsed;
    }
    print(" [Error] Please enter a valid decimal value.");
  }
}
void main() async {
  final String separator = "-" * 50;
  print(separator);
  print("   DART CORE ARCHITECTURE - VERIFICATION SYSTEM   ");
  print(separator);
  List<Book> libraryCatalog = await fetchOnlineBooksCatalog();
  print("[Section 1: User Identity & Profile Environment]");
  String profileName = promptForTextInput("Enter full name: ");
  int profileAge = promptForIntInput("Enter age: ");
  double profileHeight = promptForDoubleInput("Enter height (meters): ");
  stdout.write("Employment status? (y/n): ");
  String? rawEmp = stdin.readLineSync()?.toLowerCase().trim();
  bool isEmployed = (rawEmp == 'y' || rawEmp == 'yes');
  late final String receiptHeader;
  receiptHeader = "\n$separator\n                 PROFILE SUMMARY\n$separator";
  print(receiptHeader);
  print(" Name       : $profileName");
  print(" Age        : $profileAge yrs");
  print(" Height     : ${profileHeight.toStringAsFixed(2)} m");
  print(" Employment : ${isEmployed ? 'Active' : 'Inactive'}");
  print(separator);
  print("\n[Section 2: Library Resource Management Simulation]");
  print("\n>> Available Catalog:");
  for (int i = 0; i < libraryCatalog.length; i++) {
    print(" [${i + 1}] '${libraryCatalog[i].title}' by ${libraryCatalog[i].author}");
  }
  int bookChoiceIndex = 0;
  while (true) {
    int userSelection = promptForIntInput("\nSelect a book number to borrow: ");
    if (userSelection > 0 && userSelection <= libraryCatalog.length) {
      bookChoiceIndex = userSelection - 1;
      break;
    }
    print(" [Error] Book number doesn't exist. Choose from the list above.");
  }
  final selectedBook = libraryCatalog[bookChoiceIndex];
  print("\n>> Client Authentication:");
  print(" 1. Standard Client");
  print(" 2. Premium Client");
  int choice = 0;
  while (true) {
    choice = promptForIntInput("Select profile type (1-2): ");
    if (choice == 1 || choice == 2) break;
    print(" [Error] Selection out of bounds.");
  }
  if (choice == 1) {
    print("\n>> Executing Standard Client Operations:");
    String stdName = promptForTextInput("Client Name: ");
    int stdId = promptForIntInput("Client ID: ");
    final standardUser = User(name: stdName, id: stdId);
    int borrowDays = promptForOptionalInt("Loan duration in days [Enter for default 14]: ");
    if (borrowDays > 0) {
      standardUser.borrowBook(selectedBook, days: borrowDays);
    } else {
      standardUser.borrowBook(selectedBook);
    }
  } else {
    print("\n>> Executing Premium Client Operations:");
    String premiumName = promptForTextInput("Client Name: ");
    int premiumId = promptForIntInput("Client ID: ");
    final premiumUser = PremiumUser(name: premiumName, id: premiumId);
    int borrowDays = promptForOptionalInt("Loan duration in days [Enter for default 14]: ");
    if (borrowDays > 0) {
      premiumUser.borrowBook(selectedBook, days: borrowDays);
    } else {
      premiumUser.borrowBook(selectedBook);
    }
    print("\n>> Requesting Premium Sub-System Asset Allocation:");
    String assetName = promptForTextInput("Hardware/Asset Name: ", allowNumbers: true);
    int rentDays = promptForIntInput("Rental duration (days): ");
    premiumUser.rentPremiumAsset(assetName: assetName, durationInDays: rentDays);
  }
  libraryCatalog.removeAt(bookChoiceIndex);
  print("\n System Update: Storage sync complete. Active collection count: ${libraryCatalog.length} remaining.");
  print("\n$separator");
  print("        PROCESS COMPLETED - STATUS CODE 0       ");
  print(separator);
}
