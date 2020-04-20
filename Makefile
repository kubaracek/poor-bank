deps:
	cabal2nix . > default.nix

build:
	nix-build release.nix

run: build
	result/bin/exe

repl:
	nix-shell --pure shell.nix --run \
		"cabal repl --ghc-options='+RTS -N2' lib:bank"

shell:
	nix-shell shell.nix

shell-pure:
	nix-shell --pure shell.nix

.PHONY: deps build run repl shell shell-pure
