{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  gitMinimal,
  pytestCheckHook,
  pythonOlder,
  ruamel-yaml,
  tomli,
}:

buildPythonPackage rec {
  pname = "pre-commit-hooks";
  version = "5.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pre-commit";
    repo = "pre-commit-hooks";
    tag = "v${version}";
    hash = "sha256-BYNi/xtdichqsn55hqr1MSFwWpH+7cCbLfqmpn9cxto=";
  };

  propagatedBuildInputs = [ ruamel-yaml ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  nativeCheckInputs = [
    gitMinimal
    pytestCheckHook
  ];

  # Note: this is not likely to ever work on Darwin
  # https://github.com/pre-commit/pre-commit-hooks/pull/655
  doCheck = !stdenv.hostPlatform.isDarwin;

  # the tests require a functional git installation which requires a valid HOME
  # directory.
  preCheck = ''
    export HOME="$(mktemp -d)"

    git config --global user.name "Nix Builder"
    git config --global user.email "nix-builder@nixos.org"
    git init .
  '';

  pythonImportsCheck = [ "pre_commit_hooks" ];

  meta = with lib; {
    description = "Some out-of-the-box hooks for pre-commit";
    homepage = "https://github.com/pre-commit/pre-commit-hooks";
    changelog = "https://github.com/pre-commit/pre-commit-hooks/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
  };
}
