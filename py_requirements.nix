{ pkgs, ... }:
pypkgs: with pypkgs; [
  flask
  (buildPythonPackage rec {
    pname = "pybadges";
    version = "3.0.1";
    pyproject = true;
    src = pkgs.fetchFromGitHub {
      owner = "antares0982";
      repo = pname;
      rev = "f5324039a54c01427b5c9fa9da607a05e16b3815";
      sha256 = "sha256-EjV5F/nT8zG0CvLl4dJFP6Si6efeIWHDgJZhPRreCFw=";
    };
    build-system = [
      setuptools
    ];
    dependencies = [
      jinja2
      requests
      standard-imghdr
    ];
  })
  # add packages here
]
