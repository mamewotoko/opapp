.PHONY: all clean run $(EXE)

OPA ?= opa
EXE = hello.exe

all: $(EXE)

$(EXE): src/*.opa 
	$(OPA) src/hello.opa -o $(EXE)

run: all
	./$(EXE) || exit 0 

clean:
	rm -Rf *.exe _build _tracks *.log **/#*#
