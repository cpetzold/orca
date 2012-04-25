COFFEE := ./node_modules/coffee-script/bin/coffee

compile:
	$(COFFEE) -b -o ./lib -c ./src