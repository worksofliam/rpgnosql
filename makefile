
LIB=RPGNOSQL

all: rpgnosql.srvpgm rpgnosql.bnddir

rpgnosql.srvpgm: rpgnosql.sqlmod
rpgnosql.bnddir: rpgnosql.entry

%.srvpgm:
	system "CRTSRVPGM SRVPGM($(LIB)/$*) MODULE($(patsubst %,$(LIB)/%,$(basename $^))) EXPORT(*ALL) TGTRLS($(TGTRLS))"

%.sqlmod: src/%.sqlrpgle
	system -s "CHGATR OBJ('$<') ATR(*CCSID) VALUE(1252)"
	system -s "CRTSQLRPGI OBJ($(LIB)/$*) SRCSTMF('$<') COMMIT(*NONE) OBJTYPE(*MODULE) OPTION(*EVENTF *XREF) DBGVIEW(*SOURCE) TGTRLS($(TGTRLS))"

%.bnddir:
	-system -s "CRTBNDDIR BNDDIR($(LIB)/$*)"
	-system -s "ADDBNDDIRE BNDDIR($(LIB)/$*) OBJ($(patsubst %.entry,(*LIBL/% *SRVPGM *IMMED),$^))"

%.entry:
	@echo "Binding entry: $*"