{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      imports = [ inputs.git-hooks.flakeModule ];

      perSystem =
        { config, pkgs, ... }:
        {
          formatter = pkgs.nixfmt-rfc-style;

          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              cargo
              rustc
              git-archive-all
            ];
            shellHook = config.pre-commit.installationScript;
          };

          pre-commit.settings.hooks = {
            nixfmt-rfc-style = {
              enable = true;
              excludes = [ "vendor/.*" ];
            };
            deadnix = {
              enable = true;
              excludes = [ "vendor/.*" ];
            };
            opam-lint.enable = true;
          };
        };
    };
}
