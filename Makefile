DISTS=ocaml-sqlite3-1.4.0 ANSITerminal-0.3

OBJ=$(PWD)/obj
OBJST=$(OBJ)/.stamp

DEFAULT: all

$(OBJST):
	mkdir -p $(OBJ)
	@touch $@

$(OBJ)/%.tgz: dist/%.tar.gz $(OBJST)
	tar -C $(OBJ) -zxf $<
	@touch $@

$(OBJ)/%.build: $(OBJ)/%.tgz
	D=$(OBJ)/$*; cd $$D; if [ -x ./configure ]; then ./configure; fi; make all
	@touch $@

all: $(DISTS:%=$(OBJ)/%.build)
	@ :

x-%:
	@echo $($*)

clean:
	rm -rf $(OBJ)
