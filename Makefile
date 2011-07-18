.PHONY: all clean run $(EXE)

OPA ?= opa
EXE = opapp.exe

all: $(EXE)

$(EXE): src/*.opa 
	$(OPA) src/main.opa -o $(EXE)

run: all
	./$(EXE) || exit 0 

clean:
	rm -Rf *.exe _build _tracks *.log **/#*#

