{
  inputs.utils.url = "github:numtide/flake-utils";
  inputs.poetry2nix.url = "github:nix-community/poetry2nix";
  outputs = { self, nixpkgs, utils, poetry2nix }: let
    myAppEnv = pkgs.poetry2nix.mkPoetryEnv {
      projectDir = ./.;
      editablePackageSources = {
        application = ./src;
      };
    };
  in
    utils.lib.simpleFlake {
      inherit self nixpkgs;
      name = "poetry_script";
      overlay = [ poetry2nix.overlay ];
      shell = { pkgs }: pkgs.mkShell {
        nativeBuildInputs = [myAppEnv];
      };
    };
}
