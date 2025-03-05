{
  description = "A Nix flake default template for a development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSupportedSystem =
        f: nixpkgs.lib.genAttrs supportedSystems (system: f { pkgs = import nixpkgs { inherit system; }; });
    in
    {
      devShells = forEachSupportedSystem (
        { pkgs }:
        let
          system = "x86_64-linux";
          pkgs = import nixpkgs {
            inherit system;
          };
          stdenv = pkgs.gcc14Stdenv;        
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              llvmPackages_17.clang-tools
              raylib
            ];
            env = {
              CLANGD_FLAGS = "--query-driver=${pkgs.lib.getExe pkgs.gcc14Stdenv.cc}";
            };
            # shellHook = ''
            #   ln -sfn ${self.packages.${system}.default}/.build/source/build/compile_commands.json .
            # '';            
          };
        }
      );
    };
}

