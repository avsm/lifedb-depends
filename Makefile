DISTS+=json-wheel-1.0.6 json-static-0.9.6
DISTS+=ocaml-sqlite3-1.4.0 ANSITerminal-0.3
DISTS+=ocamlnet-2.2.9
DISTS+=ocaml-sql-orm-0.1

OBJ := $(PWD)/obj
OBJST := $(OBJ)/.stamp

DEFAULT: all

PATCHES_ocamlnet-2.2.9 := ocamlnet
CONFIGURE_ocamlnet-2.2.9 := -with-nethttpd

DEPS_json-static-0.9.6 := json-wheel-1.0.6
DEPS_ocaml-sql-orm-0.1 := ocaml-sqlite3-1.4.0

TARG_ocamlnet-2.2.9 := all opt

$(OBJST):
	mkdir -p $(OBJ)
	@touch $@

$(OBJ)/%.tgz: dist/%.tar.gz $(OBJST)
	tar -C $(OBJ) -zxf $<
	P=$(PATCHES_$*); if [ "$$P" != "" ]; then \
	  cd $(OBJ)/$*; for i in $(PWD)/patches/$$P/patch-*; do patch -p0 < $$i; done; fi
	@touch $@

$(OBJ)/%.build: $(OBJ)/%.tgz
	if [ "$(DEPS_$*)" != "" ]; then $(MAKE) $(OBJ)/$(DEPS_$*).install; fi
	D=$(OBJ)/$*; cd $$D; if [ -x ./configure ]; then ./configure $(CONFIGURE_$*); fi; make $(TARG_$*)
	@touch $@

$(OBJ)/%.install: $(OBJ)/%.build
	D=$(OBJ)/$*; cd $$D; sudo make uninstall; sudo make install && touch $@
	
all: $(DISTS:%=$(OBJ)/%.build)
	@ :

install: $(DISTS:%=$(OBJ)/%.install)
	@ :

x-%:
	@echo $($*)

clean:
	rm -rf $(OBJ)
