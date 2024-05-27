import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Password {
  String value;

  static const int minimalLength = 8;
  static const int maxConsecutiveSpaces = 1;

  static String specialCases =
      "${maxConsecutiveSpaces + 1} espaces consécutifs";

  bool get hasAGoodLength => value.length >= minimalLength;

  bool get hasASmallLetter => RegExp('[a-z]').hasMatch(value);

  bool get hasACapitalLetter => RegExp('[A-Z]').hasMatch(value);

  bool get hasANumber => RegExp(r'\d').hasMatch(value);

  bool get hasASpecialCharacter =>
      RegExp(r'[!@#\\$%^&*(),.?":{}|<>]').hasMatch(value);

  bool get doesNotHaveASpecialCase =>
      !RegExp('\\s{${maxConsecutiveSpaces + 1},}').hasMatch(value);

  bool get isValid =>
      hasAGoodLength &&
      hasASmallLetter &&
      hasACapitalLetter &&
      hasANumber &&
      hasASpecialCharacter &&
      doesNotHaveASpecialCase;

  Password([this.value = ""]); // Valeur par défaut pour le paramètre value
}

class MyPasswordAnalyzerBox extends StatelessWidget {
  final Password password;
  const MyPasswordAnalyzerBox({super.key, required this.password});
  Color okOrKoColor(bool state) => state ? Colors.green : Colors.red;

  Row buildPasswordAnalyzerRow(
      {required bool condition, required String description}) {
    Icon okOrKoIcon(bool state) => Icon(
          state ? Icons.check : Icons.close,
          color: okOrKoColor(state),
        );

    Text okOrKoText(bool state, String text) => Text(
          text,
          style: TextStyle(
            color: okOrKoColor(state),
          ),
        );

    return Row(
      children: [okOrKoIcon(condition), okOrKoText(condition, description)],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: okOrKoColor(password.isValid),
        ),
      ),
      child: Column(
        children: [
          buildPasswordAnalyzerRow(
              condition: password.hasAGoodLength,
              description: "Au moins ${Password.minimalLength} caractères"),
          buildPasswordAnalyzerRow(
              condition: password.hasASmallLetter,
              description: "Au moins 1 lettre minuscule"),
          buildPasswordAnalyzerRow(
              condition: password.hasACapitalLetter,
              description: "Au moins 1 lettre majuscule"),
          buildPasswordAnalyzerRow(
              condition: password.hasANumber,
              description: "Au moins 1 chiffre"),
          buildPasswordAnalyzerRow(
              condition: password.hasASpecialCharacter,
              description: "Au moins 1 caractère spécial"),
          buildPasswordAnalyzerRow(
              condition: password.doesNotHaveASpecialCase,
              description: "Pas de cas spéciaux (${Password.specialCases})"),
        ],
      ),
    );
  }
}

class MyPasswordInputDecoration extends InputDecoration {
  const MyPasswordInputDecoration({
    required String labelText,
    required IconButton suffixIcon,
  }) : super(
          labelText: labelText,
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: suffixIcon,
          border: const OutlineInputBorder(),
        );
}

class MyPasswordFormField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;

  const MyPasswordFormField({
    super.key,
    required this.controller,
    required this.textInputAction,
    this.validator,
  });

  @override
  State<MyPasswordFormField> createState() => _MyPasswordFormFieldState();
}

class _MyPasswordFormFieldState extends State<MyPasswordFormField> {
  bool obscureText = true;

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofillHints: const [AutofillHints.password],
      controller: widget.controller,
      keyboardType: TextInputType.visiblePassword,
      obscureText: obscureText,
      decoration: MyPasswordInputDecoration(
        labelText: "Mot de passe",
        suffixIcon: IconButton(
          tooltip: obscureText?"Afficher le texte":"Cacher le texte",
          icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              obscureText = !obscureText;
            });
          },
        ),
      ),
      validator: widget.validator ??
          (value) {
            return Password(value!).isValid
                ? null
                : "Le mot de passe ne répond pas aux exigences de sécurité";
          },
      textInputAction: widget.textInputAction,
    );
  }
}

class MyPasswordFormFieldWithAnalyzerBox extends StatefulWidget {
  final TextEditingController controller;
  final TextInputAction textInputAction;
  const MyPasswordFormFieldWithAnalyzerBox(
      {super.key, required this.controller, required this.textInputAction});

  @override
  State<MyPasswordFormFieldWithAnalyzerBox> createState() =>
      _MyPasswordFormFieldWithAnalyzerBoxState();
}

class _MyPasswordFormFieldWithAnalyzerBoxState
    extends State<MyPasswordFormFieldWithAnalyzerBox> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyPasswordFormField(
            controller: widget.controller,
            textInputAction: widget.textInputAction),
        MyPasswordAnalyzerBox(
            password: Password(widget.controller.text.trim())),
      ],
    );
  }
}

class MyConfirmPasswordFormField extends StatefulWidget {
  final TextEditingController controller;
  final TextEditingController passwordController;
  final TextInputAction textInputAction;
  const MyConfirmPasswordFormField(
      {super.key,
      required this.controller,
      required this.passwordController,
      required this.textInputAction});

  @override
  State<MyConfirmPasswordFormField> createState() =>
      _MyConfirmPasswordFormFieldState();
}

class _MyConfirmPasswordFormFieldState
    extends State<MyConfirmPasswordFormField> {
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofillHints: const [AutofillHints.password],
      controller: widget.controller,
      keyboardType: TextInputType.visiblePassword,
      obscureText: obscureText,
      decoration: MyPasswordInputDecoration(
        labelText: "Confirmation du mot de passe",
        suffixIcon: IconButton(
          tooltip: obscureText?"Afficher le texte":"Cacher le texte",
          icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              obscureText = !obscureText;
            });
          },
        ),
      ),
      validator: (value) {
        return value?.trim() == widget.passwordController.text.trim()
            ? null
            : "Le mot de passe et la confirmation de mot de passe ne sont pas identiques";
      },
      textInputAction: widget.textInputAction,
    );
  }
}

class MyEmailFormField extends TextFormField {
  MyEmailFormField({
    super.key,
    required TextEditingController controller,
    required TextInputAction textInputAction,
  }) : super(
          autofillHints: [AutofillHints.email],
          keyboardType: TextInputType.emailAddress,
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Email",
            prefixIcon: Icon(Icons.mail),
          ),
          validator: (value) => EmailValidator.validate(value!)
              ? null
              : "Saisissez une adresse mail valide",
          textInputAction: textInputAction,
        );
}

class MyFirstAndLastNamesFormField extends StatefulWidget {
  final TextEditingController firstName;
  final TextEditingController lastName;
  final TextInputAction textInputAction;
  const MyFirstAndLastNamesFormField(
      {super.key,
      required this.firstName,
      required this.lastName,
      required this.textInputAction});

  @override
  State<MyFirstAndLastNamesFormField> createState() =>
      _MyFirstAndLastNamesFormFieldState();
}

class _MyFirstAndLastNamesFormFieldState
    extends State<MyFirstAndLastNamesFormField> {
   final int minimumLength = 3;

  @override
  Widget build(BuildContext context) {
    String errorMessage = "La combinaison Prénom + Nom doit comporter au moins $minimumLength caractères";
    return FormField<String>(
      initialValue: errorMessage,
      validator: (value) {
        if (kDebugMode) {
          print(value);
        }
        return value;
      },
      builder: (state) {
        setValidatorValue() {

          if ((widget.firstName.text.trim().length +
                  widget.lastName.text.trim().length) >=
              minimumLength) {
            state.didChange(null);
          } else {
            state.didChange(
                errorMessage);
          }
        }


        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    onChanged: (value) => setValidatorValue(),
                    autofillHints: const [AutofillHints.givenName],
                    controller: widget.firstName,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                        labelText: "Prénom", border: OutlineInputBorder()),
                    validator: (value) => value?.trim().isNotEmpty ?? false
                          ? null
                          : "Prénom vide",
                    textInputAction: TextInputAction.next,
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    onChanged: (value) => setValidatorValue(),
                    autofillHints: const [AutofillHints.familyName],
                    controller: widget.lastName,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(
                        labelText: "Nom", border: OutlineInputBorder()),
                    validator: (value) => value?.trim().isNotEmpty ?? false
                          ? null
                          : "Nom vide",
                    textInputAction: widget.textInputAction,
                  ),
                ),
              ],
            ),
            if (state.hasError)
              Text(state.errorText ?? "",
                  style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 13)),
          ],
        );
      },
    );
  }
}
