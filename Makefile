release: lit/markdown/source d-files
	@if not exist bin mkdir bin
	dub build --build=release
	@del bin\tangle.exe

debug: lit/markdown/source d-files
	@if not exist bin mkdir bin
	dub build

bin/tangle:
	dub --root=lit/tangle build

d-files: bin/tangle
	@if not exist source mkdir source
	bin/tangle -odir source lit/main.lit lit/parser.lit lit/tangler.lit lit/util.lit lit/weaver.lit

doc: bin/lit
	@if not exist doc mkdir doc
	bin\lit -w -odir doc lit/main.lit lit/parser.lit lit/tangler.lit lit/util.lit lit/weaver.lit

test: lit
	dub test

lit/markdown/source:
	@if [ ! -s lit/markdown/source ]; then \
		if [ ! -s .git ]; then \
			git clone https://github.com/zyedidia/dmarkdown lit/markdown; \
		else \
			git submodule init; \
			git submodule update; \
		fi \
	fi;

clean:
	dub clean
	dub clean --root=lit/markdown
	dub clean --root=lit/tangle

clean-all:
	dub clean
	dub clean --root=lit/markdown
	dub clean --root=lit/tangle
	rm -rf bin source
