{ mkDerivation, base, conduit, containers, mtl, random, stdenv
, streamly
}:
mkDerivation {
  pname = "bank";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base conduit containers mtl random streamly
  ];
  executableHaskellDepends = [
    base conduit containers mtl random streamly
  ];
  license = "unknown";
  hydraPlatforms = stdenv.lib.platforms.none;
}
