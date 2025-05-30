{
  lib,
  fetchFromGitHub,
  buildGoModule,
  testers,
  boulder,
  nix-update-script,
}:

buildGoModule rec {
  pname = "boulder";
  version = "2025-04-17";

  src = fetchFromGitHub {
    owner = "letsencrypt";
    repo = "boulder";
    tag = "release-${version}";
    leaveDotGit = true;
    postFetch = ''
      pushd $out
      git rev-parse --short=8 HEAD 2>/dev/null >$out/COMMIT
      find $out -name .git -print0 | xargs -0 rm -rf
      popd
    '';
    hash = "sha256-FXk+JZJ1azpgN6IQ9aYmpUEO1CGs9/3sog1NjrfB4d8=";
  };

  vendorHash = null;

  subPackages = [ "cmd/boulder" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/letsencrypt/boulder/core.BuildHost=nixbld@localhost"
  ];

  preBuild = ''
    ldflags+=" -X \"github.com/letsencrypt/boulder/core.BuildID=${version} +$(cat COMMIT)\""
    ldflags+=" -X \"github.com/letsencrypt/boulder/core.BuildTime=$(date -u -d @0)\""
  '';

  preCheck = ''
    # Test all targets.
    unset subPackages
  '';

  # Tests that fail or require additional services.
  disabledTests = [
    "TestARI"
    "TestAccount"
    "TestAddBlockedKeyUnknownSource"
    "TestAddCertificate"
    "TestAddCertificateDuplicate"
    "TestAddCertificateRenewalBit"
    "TestAddPreCertificateDuplicate"
    "TestAddPrecertificate"
    "TestAddPrecertificateIncomplete"
    "TestAddPrecertificateKeyHash"
    "TestAddPrecertificateNoOCSP"
    "TestAddRegistration"
    "TestAddReplacementOrder"
    "TestAddSerial"
    "TestAdministrativelyRevokeCertificate"
    "TestAuthorization500"
    "TestAuthorizationChallengeNamespace"
    "TestAuthzFailedRateLimitingNewOrder"
    "TestAutoIncrementSchema"
    "TestBadNonce"
    "TestBlockedKey"
    "TestBlockedKeyRevokedBy"
    "TestBuildID"
    "TestCTPolicyMeasurements"
    "TestCertIsRenewed"
    "TestCertificateAbsent"
    "TestCertificateKeyNotEqualAccountKey"
    "TestCertificatesTableContainsDuplicateSerials"
    "TestCertsPerNameRateLimitTable"
    "TestChallenge"
    "TestCheckCert"
    "TestCheckCert"
    "TestCheckCertReturnsDNSNames"
    "TestCheckCertReturnsDNSNames"
    "TestCheckExactCertificateLimit"
    "TestCheckFQDNSetRateLimitOverride"
    "TestCheckIdentifiersPaused"
    "TestCheckWildcardCert"
    "TestCheckWildcardCert"
    "TestClientTransportCredentials"
    "TestContactAuditor"
    "TestCountCertificatesByNamesParallel"
    "TestCountCertificatesByNamesTimeRange"
    "TestCountCertificatesRenewalBit"
    "TestCountInvalidAuthorizations2"
    "TestCountNewOrderWithReplaces"
    "TestCountOrders"
    "TestCountPendingAuthorizations2"
    "TestCountRegistrationsByIP"
    "TestCountRegistrationsByIPRange"
    "TestDbSettings"
    "TestDeactivateAccount"
    "TestDeactivateAuthorization"
    "TestDeactivateRegistration"
    "TestDedupOnRegistration"
    "TestDialerTimeout"
    "TestDirectory"
    "TestDontFindRevokedCert"
    "TestEarlyOrderRateLimiting"
    "TestEmptyAccount"
    "TestEnforceJWSAuthType"
    "TestExactPublicSuffixCertLimit"
    "TestExtractJWK"
    "TestFQDNSetExists"
    "TestFQDNSetTimestampsForWindow"
    "TestFQDNSets"
    "TestFQDNSetsExists"
    "TestFQDNSetsExists"
    "TestFailExit"
    "TestFasterGetOrderForNames"
    "TestFinalizeAuthorization2"
    "TestFinalizeOrder"
    "TestFinalizeOrderWildcard"
    "TestFinalizeOrderWithMixedSANAndCN"
    "TestFinalizeSCTError"
    "TestFinalizeWithMustStaple"
    "TestFindCertsAtCapacity"
    "TestFindExpiringCertificates"
    "TestFindIDs"
    "TestFindIDsForHostnames"
    "TestFindIDsWithExampleHostnames"
    "TestFindUnrevoked"
    "TestFindUnrevokedNoRows"
    "TestGETAPIAuthz"
    "TestGETAPIChallenge"
    "TestGenerateOCSP"
    "TestGenerateOCSPLongExpiredSerial"
    "TestGenerateOCSPUnknownSerial"
    "TestGetAndProcessCerts"
    "TestGetAndProcessCerts"
    "TestGetAuthorization"
    "TestGetAuthorization2NoRows"
    "TestGetAuthorizations2"
    "TestGetCertificate"
    "TestGetCertificateHEADHasCorrectBodyLength"
    "TestGetCertificateNew"
    "TestGetCertificateServerError"
    "TestGetCertsEmptyResults"
    "TestGetCertsEmptyResults"
    "TestGetChallenge"
    "TestGetChallengeUpRel"
    "TestGetMaxExpiration"
    "TestGetOrder"
    "TestGetOrderExpired"
    "TestGetOrderForNames"
    "TestGetPausedIdentifiers"
    "TestGetPausedIdentifiersOnlyUnpausesOneAccount"
    "TestGetPendingAuthorization2"
    "TestGetRevokedCerts"
    "TestGetSerialMetadata"
    "TestGetSerialsByAccount"
    "TestGetSerialsByKey"
    "TestGetStartingID"
    "TestGetValidAuthorizations2"
    "TestGetValidOrderAuthorizations2"
    "TestHTTPDialTimeout"
    "TestHTTPMethods"
    "TestHandleFunc"
    "TestHeaderBoulderRequester"
    "TestIgnoredLint"
    "TestIgnoredLint"
    "TestIncidentARI"
    "TestIncidentSerialModel"
    "TestIncidentsForSerial"
    "TestIndex"
    "TestIndexGet404"
    "TestInvoke"
    "TestInvokeRevokerHasNoExtantCerts"
    "TestIssueCertificateAuditLog"
    "TestIssueCertificateCAACheckLog"
    "TestIssueCertificateInnerErrs"
    "TestIssueCertificateInnerWithProfile"
    "TestIssueCertificateOuter"
    "TestKeyRollover"
    "TestKeyRolloverMismatchedJWSURLs"
    "TestLeaseOldestCRLShard"
    "TestLeaseSpecificCRLShard"
    "TestLifetimeOfACert"
    "TestLimiter_CheckWithLimitOverrides"
    "TestLimiter_DefaultLimits"
    "TestLimiter_InitializationViaCheckAndSpend"
    "TestLimiter_RefundAndReset"
    "TestLoadFromDB"
    "TestLookupJWK"
    "TestMatchJWSURLs"
    "TestNewAccount"
    "TestNewAccountNoID"
    "TestNewAccountWhenAccountHasBeenDeactivated"
    "TestNewAccountWhenGetRegByKeyFails"
    "TestNewAccountWhenGetRegByKeyNotFound"
    "TestNewECDSAAccount"
    "TestNewLookup"
    "TestNewLookupWithAllFailingSRV"
    "TestNewLookupWithOneFailingSRV"
    "TestNewOrder"
    "TestNewOrderAuthzReuseSafety"
    "TestNewOrderCheckFailedAuthorizationsFirst"
    "TestNewOrderExpiry"
    "TestNewOrderFailedAuthzRateLimitingExempt"
    "TestNewOrderMaxNames"
    "TestNewOrderRateLimiting"
    "TestNewOrderRateLimitingExempt"
    "TestNewOrderReplacesSerialCarriesThroughToSA"
    "TestNewOrderReuse"
    "TestNewOrderReuseInvalidAuthz"
    "TestNewOrderWildcard"
    "TestNewRegistration"
    "TestNewRegistrationBadKey"
    "TestNewRegistrationContactsPresent"
    "TestNewRegistrationNoFieldOverwrite"
    "TestNewRegistrationRateLimit"
    "TestNewRegistrationSAFailure"
    "TestNoContactCertIsNotRenewed"
    "TestNoContactCertIsRenewed"
    "TestNoSuchRegistrationErrors"
    "TestNonceEndpoint"
    "TestOldTLSInbound"
    "TestOrderMatchesReplacement"
    "TestOrderToOrderJSONV2Authorizations"
    "TestOrderWithOrderModelv1"
    "TestPOST404"
    "TestPanicStackTrace"
    "TestParseJWSRequest"
    "TestPauseIdentifiers"
    "TestPendingAuthorizationsUnlimited"
    "TestPerformValidationAlreadyValid"
    "TestPerformValidationBadChallengeType"
    "TestPerformValidationExpired"
    "TestPerformValidationSuccess"
    "TestPerformValidationVAError"
    "TestPerformValidation_FailedThenSuccessfulValidationResetsPauseIdentifiersRatelimit"
    "TestPerformValidation_FailedValidationsTriggerPauseIdentifiersRatelimit"
    "TestPrepAuthzForDisplay"
    "TestPreresolvedDialerTimeout"
    "TestProcessCerts"
    "TestProcessCertsConnectError"
    "TestProcessCertsParallel"
    "TestRecheckCAADates"
    "TestRecheckCAAEmpty"
    "TestRecheckCAAFail"
    "TestRecheckCAAInternalServerError"
    "TestRecheckCAASuccess"
    "TestRedisSource_BatchSetAndGet"
    "TestRedisSource_Ping"
    "TestRegistrationsPerIPOverrideUsage"
    "TestRehydrateHostPort"
    "TestRelativeDirectory"
    "TestReplacementOrderExists"
    "TestReplicationLagRetries"
    "TestResolveContacts"
    "TestRevokeCertByApplicant_Controller"
    "TestRevokeCertByApplicant_Subscriber"
    "TestRevokeCertByKey"
    "TestRevokeCertificate"
    "TestRevokeCerts"
    "TestRollback"
    "TestSPKIHashFromPrivateKey"
    "TestSPKIHashesFromFile"
    "TestSelectRegistration"
    "TestSelectUncheckedRows"
    "TestSendEarliestCertInfo"
    "TestSerialsForIncident"
    "TestSerialsFromFile"
    "TestSerialsFromPrivateKey"
    "TestSetAndGet"
    "TestSetOrderProcessing"
    "TestSetReplacementOrderFinalized"
    "TestSingleton"
    "TestStart"
    "TestStatusForOrder"
    "TestStoreResponse"
    "TestStrictness"
    "TestTLSALPN01DialTimeout"
    "TestTLSConfigLoad"
    "TestTimeouts"
    "TestUnpauseAccount"
    "TestUpdateCRLShard"
    "TestUpdateChallengeFinalizedAuthz"
    "TestUpdateChallengeRAError"
    "TestUpdateChallengesDeleteUnused"
    "TestUpdateMissingAuthorization"
    "TestUpdateNowWithAllFailingSRV"
    "TestUpdateNowWithOneFailingSRV"
    "TestUpdateRegistrationContact"
    "TestUpdateRegistrationKey"
    "TestUpdateRegistrationSame"
    "TestUpdateRevokedCertificate"
    "TestValidJWSForKey"
    "TestValidNonce"
    "TestValidNonce_NoMatchingBackendFound"
    "TestValidPOSTAsGETForAccount"
    "TestValidPOSTForAccount"
    "TestValidPOSTForAccountSwappedKey"
    "TestValidPOSTRequest"
    "TestValidPOSTURL"
    "TestValidSelfAuthenticatedPOST"
    "TestValidSelfAuthenticatedPOSTGoodKeyErrors"
    "TestValidateContacts"
    "TestWrappedMap"
    "Test_sendError"
  ];

  checkFlags = [
    "-skip ${lib.strings.concatStringsSep "|" disabledTests}"
  ];

  postInstall = ''
    for i in $($out/bin/boulder --list); do
      ln -s $out/bin/boulder $out/bin/$i
    done
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = boulder;
      inherit version;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/letsencrypt/boulder";
    description = "ACME-based certificate authority, written in Go";
    longDescription = ''
      This is an implementation of an ACME-based CA. The ACME protocol allows
      the CA to automatically verify that an applicant for a certificate
      actually controls an identifier, and allows domain holders to issue and
      revoke certificates for their domains. Boulder is the software that runs
      Let's Encrypt.
    '';
    license = lib.licenses.mpl20;
    mainProgram = "boulder";
    maintainers = [ ];
  };
}
