{
  description =
    "A flake for Typeman, 'Typing speed test with practice mode in GUI, TUI and CLI'";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ rust-overlay.overlays.default ];
        pkgs = import nixpkgs { inherit system overlays; };
        rustVersion = pkgs.rust-bin.stable.latest.default;
      in {
        packages.default = pkgs.rustPlatform.buildRustPackage {
          name = "typeman";
          version = "0.0.1";

          src = pkgs.fetchFromGitHub {
            owner = "mzums";
            repo = "typeman";
            rev = "main";
            sha256 = "sha256-LrnGRbHt8CcS4SZcuZrz+MMvZ++bRdkLW0Sd22pn3ss=";

          };

          cargoLock = {
            lockFileContents = builtins.readFile (pkgs.fetchurl {
              url =
                "https://raw.githubusercontent.com/mzums/typeman/main/Cargo.lock";
              sha256 = "sha256-i2AIQ21VvW15l0uCpH3W8N0jcEx7UhAMoNIEZmD/Luk=";

            });
          };

          nativeBuildInputs = with pkgs; [
            gcc
            gnumake
            rustc
            rustVersion
            cargo
            pkg-config
          ];
          buildInputs = with pkgs; [
            fontconfig
            libsixel
            systemd

            # X11/Wayland
            xorg.libX11
            xorg.libXcursor
            xorg.libXrandr
            xorg.libXi
            wayland

            # Graphics
            libGL
            vulkan-loader

          ];
          LD_LIBRARY_PATH =
            pkgs.lib.makeLibraryPath [ pkgs.libGL pkgs.vulkan-loader ];
        };
      });
}
