# Command Aliases
OPENSCAD = openscad

DIST_DIR ?= dist
MODELS ?= $(patsubst %.scad, $(DIST_DIR)/%.stl, $(wildcard **/*.scad))

.PHONY: all
all: $(MODELS)

$(DIST_DIR):
	@mkdir -p $@

$(DIST_DIR)/%.stl: %.scad
	@mkdir -p $(dir $@)
	$(OPENSCAD) -o $@ $<

clean:
	rm -rf $(DIST_DIR)
