PWD := $(shell pwd)
GENSVG := $(PWD)/scripts/gensvg.sh

PALETTES := $(shell ls palette/)
PALETTES_SVG := $(PALETTES:.palette=.svg)

QTCREATOR_SHARE_PATH := /usr/share/qtcreator
QTCREATOR_STYLES_PATH := $(QTCREATOR_SHARE_PATH)/styles
QTCREATOR_THEMES_PATH := $(QTCREATOR_SHARE_PATH)/themes

all: build install

build: palette

install:
	sudo cp styles/* $(QTCREATOR_STYLES_PATH)
	sudo cp themes/* $(QTCREATOR_THEMES_PATH)

clean:
	$(RM) -r img/*.svg

palette: $(addprefix img/,$(PALETTES_SVG))

img/%.svg: palette/%.palette
	$(GENSVG) $< > $@

.PHONY: all build install clean palette
