import 'package:pigeon/pigeon.dart';

/// Represents a relying party
@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/messages.g.dart',
    swiftOut: 'ios/Classes/messages.swift',
  ),
)
class RelyingParty {
  /// Constructor
  const RelyingParty(this.name, this.id);

  /// Name of the relying party
  final String name;

  /// ID of the relying party
  final String id;
}

/// Represents a user
class User {
  /// Constructor
  const User(this.name, this.id);

  /// The name
  final String name;

  /// The ID
  final String id;
}

class PubKeyCredParamType {
  /// Constructs a new instance.
  PubKeyCredParamType({
    required this.type,
    required this.alg,
  });

  ///
  final String type;

  ///
  final int alg;

}

/// Represents a register response
class RegisterResponse {
  /// Constructor
  const RegisterResponse({
    required this.id,
    required this.rawId,
    required this.clientDataJSON,
    required this.attestationObject,
  });

  /// The ID
  final String id;

  /// The raw ID
  final String rawId;

  /// The client data JSON
  final String clientDataJSON;

  /// The attestation object
  final String attestationObject;
}

/// Represents an authenticate response
class AuthenticateResponse {
  /// Constructor
  const AuthenticateResponse({
    required this.id,
    required this.rawId,
    required this.clientDataJSON,
    required this.authenticatorData,
    required this.signature,
    required this.userHandle,
  });

  /// The ID
  final String id;

  /// The raw ID
  final String rawId;

  /// The client data JSON
  final String clientDataJSON;

  /// The authenticator data
  final String authenticatorData;

  /// Signed challenge
  final String signature;

  final String userHandle;
}

class AuthenticatorSelectionType {

  /// Constructs a new instance.
  const AuthenticatorSelectionType(
  {
    required this.requireResidentKey,
    required this.residentKey,
    required this.userVerification,
    this.authenticatorAttachment,
}
      );

  final bool requireResidentKey;
  final String residentKey;
  final String userVerification;
  final String? authenticatorAttachment;

}


@HostApi()
abstract class PasskeysApi {
  bool canAuthenticate();

  @async
  RegisterResponse register(
      String challenge,
      RelyingParty relyingParty,
      User user,
      List<String> excludeCredentialIDs,
      List<PubKeyCredParamType>? pubKeyCredParams,
      AuthenticatorSelectionType authenticatorSelectionType,
      );

  @async
  AuthenticateResponse authenticate(
      String relyingPartyId,
      String challenge,
      bool conditionalUI,
      List<String> allowedCredentialIDs,
      bool preferImmediatelyAvailableCredentials,
      );

  @async
  void cancelCurrentAuthenticatorOperation();
}
