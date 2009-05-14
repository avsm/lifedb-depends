DISTS+=json-wheel-1.0.6 json-static-0.9.6
DISTS+=ocaml-sqlite3-1.4.0 ANSITerminal-0.3
DISTS+=ocamlnet-2.2.9

OBJ=$(PWD)/obj
OBJST=$(OBJ)/.stamp

DEFAULT: all

PATCHES_ocamlnet-2.2.9 := ocamlnet
CONFIGURE_ocamlnet-2.2.9 := -with-nethttpd

DEPS_json-static-0.9.6 := json-wheel-1.0.6

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
	D=$(OBJ)/$*; cd $$D; if [ -x ./configure ]; then ./configure $(CONFIGURE_$*); fi; make all
	@touch $@

$(OBJ)/%.install: $(OBJ)/%.build
	D=$(OBJ)/$*; cd $$D; make uninstall; make install && touch $@
	
all: $(DISTS:%=$(OBJ)/%.build)
	@ :

install: $(DISTS:%=$(OBJ)/%.install)
	@ :

x-%:
	@echo $($*)

clean:
	rm -rf $(OBJ)
