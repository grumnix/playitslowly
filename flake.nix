{
  description = "Play it slowly is a software to play back audio files at a different speed or pitch";

  inputs = rec {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages = rec {
          default = playitslowly;

          playitslowly = pkgs.python3Packages.buildPythonPackage rec {
            pname = "playitslowly";
            version = "1.5.1";
            src = ./.;

            # Temporary fix for wrapGAppsHook
            # See https://github.com/NixOS/nixpkgs/issues/57029
            # and https://github.com/NixOS/nixpkgs/issues/56943
            strictDeps = false;

            doCheck = false;  # no tests

            nativeBuildInputs = with pkgs; [
              pkg-config
              gobject-introspection
              wrapGAppsHook
              python3Packages.wrapPython
            ];
            buildInputs = with pkgs; [
              gtk3
              gst_all_1.gstreamer
              gst_all_1.gst-plugins-base
              gst_all_1.gst-plugins-good
              gst_all_1.gst-plugins-bad
            ];
            propagatedBuildInputs = with pkgs; [
              python3Packages.pygobject3
              python3Packages.gst-python
            ];
          };
        };
      }
    );
}
