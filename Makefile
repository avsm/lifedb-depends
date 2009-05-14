DISTS=ocaml-sqlite3-1.4.0 ANSITerminal-0.3
DISTS+=ocamlnet-2.2.9

OBJ=$(PWD)/obj
OBJST=$(OBJ)/.stamp

DEFAULT: all

PATCHES_ocamlnet-2.2.9 := ocamlnet

$(OBJST):
	mkdir -p $(OBJ)
	@touch $@

$(OBJ)/%.tgz: dist/%.tar.gz $(OBJST)
	tar -C $(OBJ) -zxf $<
	P=$(PATCHES_$*); if [ "$$P" != "" ]; then \
	  cd $(OBJ)/$*; for i in $(PWD)/patches/$$P/patch-*; do patch -p0 < $$i; done; fi
	@touch $@

$(OBJ)/%.build: $(OBJ)/%.tgz
	D=$(OBJ)/$*; cd $$D; if [ -x ./configure ]; then ./configure; fi; make all
	@touch $@

$(OBJ)/%.install: $(OBJ)/%.build
	D=$(OBJ)/$*; cd $$D; make install && touch $@
	
all: $(DISTS:%=$(OBJ)/%.build)
	@ :

install: $(DISTS:%=$(OBJ)/%.install)
	@ :

x-%:
	@echo $($*)

clean:
	rm -rf $(OBJ)
