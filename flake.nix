{
  description = "Typst slides development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

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
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          typst
          pkgs.tinymist
          pkgs.typstyle
          pkgs.poppler-utils
          pkgs.pdfpc
        ];

        shellHook = ''
          unset SOURCE_DATE_EPOCH
          export TYPST_PACKAGE_CACHE_PATH="${typst}/lib/typst/packages"
          export TYPST_FONT_PATHS="${pkgs.lib.makeSearchPath "share/fonts" fonts}"
        '';
      };

      formatter.${system} = pkgs.typstyle;
    };
}
