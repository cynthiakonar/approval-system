import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

int calculateDifference(DateTime date) {
  DateTime now = DateTime.now();
  return DateTime(date.year, date.month, date.day)
      .difference(DateTime(now.year, now.month, now.day))
      .inDays;
}

// Function to enable sending email notifications
// Currently non-functional due to security issues as we are not using real email Ids
Future sendEmail(String source, List<String> destination, String subject,
    String body) async {
  final smtpServer = gmail(source, "123456");

  final message = Message()
    ..from = Address(source)
    ..subject = subject
    ..text = body
    ..recipients = destination;
  try {
    await send(message, smtpServer);
  } catch (e) {
    print(e);
  }
}
