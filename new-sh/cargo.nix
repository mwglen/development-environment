{
  inputs.utils.url = "github:numtide/flake-utils"
  outputs = { self, nixpkgs, utils }:
    utils.lib.simpleFlake {
      inherit self nixpkgs;
      name = "cargo_script";
      shell = { pkgs }: pkgs.mkShell {
        nativeBuildInputs = [
          # Rust Dependencies
          cargo rustfmt clippy
        ];
      };
   };
}
