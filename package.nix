{
  pkgs,
  callPackage,
  ...
}:

let
  requiredPythonPackages = callPackage ./py_requirements.nix { };
  mypyenv = pkgs.python313.withPackages requiredPythonPackages;
in

pkgs.stdenv.mkDerivation {
  pname = "visitor-badge";
  version = "1.0.0";

  src = ./.;

  installPhase = ''
    mkdir -p $out/bin
    sed "1s|^#!.*python3.*|#!${mypyenv}/bin/python|" $src/main.py > $out/bin/main.py
    cp $src/persistent_counter.py $out/bin/persistent_counter.py
    chmod +x $out/bin/main.py
  '';
}
