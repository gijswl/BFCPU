import sys;

rom = list();

def process_char(c):
	if(c == "+"):
		rom.append("2b");
	elif(c == "-"):
		rom.append("2d");
	elif(c == ">"):
		rom.append("3e");
	elif(c == "<"):
		rom.append("3c");
	elif(c == "."):
		rom.append("2e");
	elif(c == ","):
		rom.append("2c");
	elif(c == "["):
		rom.append("5b");
	elif(c == "]"):
		rom.append("5d");
	return;

def main():
	if(len(sys.argv) != 2):
		print("[ERR] Usage: create_rom.py <file>");
		return;
	
	f_name = sys.argv[1];
	rf_name = "rom_" + f_name;

	try:
		f = open(f_name, "r");
	except FileNotFoundError as x:
		print("[ERR] File \"" + f_name + "\" does not exist!");
		return;
	except IsADirectoryError as x:
		print("[ERR] File \"" + f_name + "\" is a directory!");
		return;
		
	for line in f:  
		for ch in line:
			process_char(ch);
			
	f.close();
	
	try:
		f = open(rf_name, "w");
	except IsADirectoryError as x:
		print("[ERR] File \"" + rf_name + "\" is a directory!");
		return;
		
	for byte in rom:
		f.write(byte + "\n");
		
	f.close();
main();
