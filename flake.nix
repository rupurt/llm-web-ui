{
  description = "Development environment for llm-web-ui. Manage and chat with models";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    flake-utils,
    nixpkgs,
    ...
  }: let
    systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    outputs = flake-utils.lib.eachSystem systems (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [];
      };
    in {
      # packages exported by the flake
      packages = {};

      # nix run
      apps = {};

      # nix fmt
      formatter = pkgs.alejandra;

      # nix develop -c $SHELL
      devShells.default = pkgs.mkShellNoCC {
        name = "default dev shell";
        packages = with pkgs; [
          python311Packages.python
          python311Packages.pip
          python311Packages.virtualenv
          python311Packages.ipython
          python311Packages.venvShellHook
        ];
        venvDir = ".venv";
      };
    });
  in
    outputs;
}
