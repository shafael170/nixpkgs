{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "adafruit-platformdetect";
  version = "3.79.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "adafruit_platformdetect";
    inherit version;
    hash = "sha256-E/UixKuSRBYAw/R/15WxYQpkYDSSLs0svB4gfGTDz38=";
  };

  build-system = [ setuptools-scm ];

  # Project has not published tests yet
  doCheck = false;

  pythonImportsCheck = [ "adafruit_platformdetect" ];

  meta = with lib; {
    description = "Platform detection for use by Adafruit libraries";
    homepage = "https://github.com/adafruit/Adafruit_Python_PlatformDetect";
    changelog = "https://github.com/adafruit/Adafruit_Python_PlatformDetect/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
