{
  description = "Typst slides development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forAllSystems = f:
        nixpkgs.lib.genAttrs systems (
          system: f (import nixpkgs { inherit system; })
        );
    in {
      devShells = forAllSystems (pkgs:
        let
          fonts = with pkgs; [
            noto-fonts-cjk-sans
            noto-fonts-cjk-serif
            dejavu_fonts
          ];

          typst = pkgs.typst.wrapper {
            packages = ps: with ps; [ touying cetz fletcher ];
            inherit fonts;
          };
        in {
          default = pkgs.mkShell {
            packages = [
              typst
              pkgs.tinymist
              pkgs.typstyle
              pkgs.poppler-utils
            ] ++ pkgs.lib.optional pkgs.stdenv.hostPlatform.isLinux pkgs.pdfpc;

            shellHook = ''
              unset SOURCE_DATE_EPOCH
              export TYPST_PACKAGE_CACHE_PATH="${typst}/lib/typst/packages"
              export TYPST_FONT_PATHS="${pkgs.lib.makeSearchPath "share/fonts" fonts}"
            '';
          };
        });

      formatter = forAllSystems (pkgs: pkgs.typstyle);
    };
}
