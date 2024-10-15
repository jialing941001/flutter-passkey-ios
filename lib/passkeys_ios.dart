import 'package:flutter/foundation.dart';
import 'package:passkeys_ios/messages.g.dart' as messages;
import 'package:passkeys_platform_interface/passkeys_platform_interface.dart';
import 'package:passkeys_platform_interface/types/types.dart';

/// The iOS implementation of [PasskeysPlatform].
class PasskeysIOS extends PasskeysPlatform {
  /// Creates a new plugin implementation instance.
  PasskeysIOS({
    @visibleForTesting messages.PasskeysApi? api,
  }) : _api = api ?? messages.PasskeysApi();

  /// Registers this class as the default instance of [PasskeysIOS].
  static void registerWith() {
    PasskeysPlatform.instance = PasskeysIOS();
  }

  final messages.PasskeysApi _api;

  @override
  Future<bool> canAuthenticate() async => _api.canAuthenticate();

  @override
  Future<RegisterResponseType> register(RegisterRequestType request) async {
    final userArg = messages.User(name: request.user.name, id: request.user.id);
    final relyingPartyArg = messages.RelyingParty(
      name: request.relyingParty.name,
      id: request.relyingParty.id,
    );
    final authenticatorSelectionType = messages.AuthenticatorSelectionType(
        requireResidentKey: request.authSelectionType.requireResidentKey,
        residentKey: request.authSelectionType.residentKey,
        userVerification: request.authSelectionType.userVerification,
      authenticatorAttachment: request.authSelectionType.authenticatorAttachment,
    );


    final r = await _api.register(
      request.challenge,
      relyingPartyArg,
      userArg,
      request.excludeCredentials.map((e) => e.id).toList(),
      request.pubKeyCredParams?.map(
              (e) => messages.PubKeyCredParamType(type: e.type, alg: e.alg,),).toList(),
      authenticatorSelectionType,
    );

    return RegisterResponseType(
      id: r.id,
      rawId: r.rawId,
      clientDataJSON: r.clientDataJSON,
      attestationObject: r.attestationObject,
    );
  }

  @override
  Future<AuthenticateResponseType> authenticate(
    AuthenticateRequestType request,
  ) async {
    var conditionalUI = false;
    if (request.mediation == MediationType.Conditional) {
      conditionalUI = true;
    }

    final r = await _api.authenticate(
      request.relyingPartyId,
      request.challenge,
      conditionalUI,
      request.allowCredentials?.map((e) => e.id).toList() ?? [],
      request.preferImmediatelyAvailableCredentials,
    );

    return AuthenticateResponseType(
      id: r.id,
      rawId: r.rawId,
      clientDataJSON: r.clientDataJSON,
      authenticatorData: r.authenticatorData,
      signature: r.signature,
      userHandle: r.userHandle,
    );
  }

  @override
  Future<void> cancelCurrentAuthenticatorOperation() =>
      _api.cancelCurrentAuthenticatorOperation();
}
