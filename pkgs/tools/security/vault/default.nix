{ stdenv, fetchFromGitHub, buildGoPackage, installShellFiles }:

buildGoPackage rec {
  pname = "vault";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "vault";
    rev = "v${version}";
    sha256 = "0bin0r0qmyz8xal910csbclzc6ng2xv69jszyi69gd6n6f43vqw8";
  };

  goPackagePath = "github.com/hashicorp/vault";

  subPackages = [ "." ];

  nativeBuildInputs = [ installShellFiles ];

  buildFlagsArray = [ "-tags=vault" "-ldflags=-s -w -X ${goPackagePath}/sdk/version.GitCommit=${src.rev}" ];

  postInstall = ''
    echo "complete -C $out/bin/vault vault" > vault.bash
    installShellCompletion vault.bash
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.vaultproject.io/";
    description = "A tool for managing secrets";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.mpl20;
    maintainers = with maintainers; [ rushmorem lnl7 offline pradeepchhetri ];
  };
}
