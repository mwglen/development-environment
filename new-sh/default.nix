{ writeShellScriptBin, writeShellScript, cargo, poetry, ... }:
let
  new-cargo = writeShellScript "new-cargo" ''
    ${cargo}/bin/cargo new $@
    cp ${./cargo.nix} flakes.nix
    echo "use flake" > .envrc
  '';

  new-poetry = writeShellScript "new-poetry" ''
    ${poetry}/bin/poetry new "$@"
    cp ${./poetry.nix} flakes.nix
    echo "use flake" > .envrc
  '';
in writeShellScriptBin "new" ''
  case $1 in
    (cargo)
      shift
      ${new-cargo} ;;
    (poetry)
      shift
      ${new-poetry} ;;
    (tensorflow)
      shift
      echo "Unimplemented" ;;
    (help)
      shift
      echo "Unimplemented" ;;
    (*)
      shift
      echo "Not Found" >&2 ;;
  esac
''
