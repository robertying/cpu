import re

OpCode_dict = {"nop":"000000", "lw":"100011", "sw":"101011", "lui":"001111", "add":"000000", "addu":"000000",
               "sub":"000000", "subu":"000000", "addi":"001000", "addiu":"001001", "and":"000000", "or":"000000",
               "xor":"000000", "nor":"000000", "andi":"001100", "sll":"000000", "srl":"000000", "sra":"000000",
               "slt":"000000", "slti":"001010", "sltiu":"001011", "beq":"000100", "bne":"000101", "blez":"000110",
               "bgtz":"000111", "bltz":"000001", "j":"000010", "jal":"000011", "jr":"000000", "jalr":"000000"}

Funct_dict = {"nop":"000000", "add":"100000", "addu":"100001", "sub":"100010", "subu":"100011", "and":"100100",
              "or":"100101", "xor":"100110", "nor":"100111", "sll":"000000", "srl":"000010", "sra":"000011",
              "slt":"101010", "jr":"001000", "jalr":"001001"}

r_dict = {"$zero":"00000", "$0":"00000", "$at":"00001", "$v0":"00010", "$v1":"00011", "$a0":"00100", "$a1":"00101",
          "$a2":"00110", "$a3":"00111", "$t0":"01000", "$t1":"01001", "$t2":"01010", "$t3":"01011", "$t4":"01100",
          "$t5":"01101", "$t6":"01110", "$t7":"01111", "$s0":"10000", "$s1":"10001", "$s2":"10010", "$s3":"10011",
          "$s4":"10100", "$s5":"10101", "$s6":"10110", "$s7":"10111", "$t8":"11000", "$t9":"11001", "$k0":"11010",
          "$k1":"11011", "$gp":"11100", "$sp":"11101", "$fp":"11110", "$ra":"11111"}

shamt_command = ["sll", "srl", "sra"]

labels = {}

bin_to_hex = {"0000":"0", "0001":"1", "0010":"2", "0011":"3", "0100":"4", "0101":"5", "0110":"6", "0111":"7",
              "1000":"8", "1001":"9", "1010":"a", "1011":"b", "1100":"c", "1101":"d", "1110":"e", "1111":"f"}


def Bin_to_Hex(bincode):
    hexcode = ""
    num = 0;
    while num != 32:
        hexcode = hexcode + bin_to_hex[bincode[num:num+4]]
        num = num + 4
    return hexcode


def Target(PC):
    target = bin(PC)[2:]
    target = (26 - len(target)) * "0" + target
    return target


def Shamt(shamt):
    binary_shamt = bin(shamt)[2:]
    binary_shamt = (5 - len(binary_shamt)) * "0"+ binary_shamt
    return binary_shamt


def Imm(imm):
    if imm >= 0:
        binary_imm = bin(imm)[2:]
        binary_imm = (16 - len(binary_imm)) * "0" + binary_imm
    else:
        binary_imm = bin(-imm)[2:]
        binary_imm = (16 - len(binary_imm)) * "0" + binary_imm
        binary_imm = binary_imm.replace("0", "2")
        binary_imm = binary_imm.replace("1", "0")
        binary_imm = binary_imm.replace("2", "1")
        binary_imm = str(bin(int(binary_imm, 2) + 1))[2:]
    return binary_imm


def compile(compile_code, PC):
    split_command = re.split(r'[\s\,\(\)]+', compile_code)
    command = ""
    rd = ""
    rs = ""
    rt = ""
    shamt = "00000"
    for word in split_command:
        if word == "":
            continue
        if command == "":
            command = word
            OpCode = OpCode_dict[word]
            if OpCode == "000000":
                Funct = Funct_dict[word]
        elif word in r_dict.keys():
            if OpCode == "000000":
                if command == "jr":
                    rs = r_dict[word]
                    rd = "00000"
                    rt = "00000"
                elif rd == "":
                    rd = r_dict[word]
                elif command in shamt_command:
                    rt = r_dict[word]
                    rs = "00000"
                elif rs == "":
                    rs = r_dict[word]
                    if command == "jalr":
                        rt = "00000"
                else:
                    rt = r_dict[word]
            elif command == "lui":
                rt = r_dict[word]
                rs = "00000"
            elif command[0] == "b":
                if rs is "":
                    rs = r_dict[word]
                    if command[-1] == "z":
                        rt = "00000"
                else:
                    rt = r_dict[word]
            else:
                if rt is "":
                    rt = r_dict[word]
                else:
                    rs = r_dict[word]
        elif word in labels.keys():
            if command[0] == "j":
                target = Target(labels[word]/4)
            else:
                imm = Imm((labels[word] - PC) / 4 - 1)
        elif command in shamt_command:
            shamt = Shamt(int(word))
        elif word[0:2] == "0x":
            imm = Imm(eval(word))
        else:
            imm = Imm(int(word))
    if command == "nop":
        machine_code = 32*"0"
    elif OpCode == "000000":
        machine_code = OpCode + rs + rt + rd + shamt + Funct
    elif command in ["j", "jal"]:
        machine_code = OpCode + target
    else:
        machine_code = OpCode + rs + rt + imm
    return machine_code


def main():
    compile_codes = open("compile.txt", "r")
    machine_codes = open("machine.txt", "w")
    lines = compile_codes.readlines()
    PC = 0
    commands = []
    for line in lines:
        line = line[0:-1]
        if line[-2] == ":":
            labels[line[0:-2]] = PC
        else:
            PC = PC + 4
            commands.append(line)
    PC = 0
    note = ""
    for line in lines:
        line = line[0:-1]
        if line[-2] == ":":
            note = note + line[0:-2] + ":"
        else:
            machine_code = compile(line, PC)
            # print(machine_code[0:6]+"_"+machine_code[6:11]+"_"+machine_code[11:16]+"_"+machine_code[16:32])
            machine_code = Bin_to_Hex(machine_code)
            # print(PC)
            machine_codes.write(4*" "+"//"+str(hex(PC))+"  "+note+line+"\n")
            machine_codes.write(4*" "+"ROMDATA["+str(PC/4)+"] <= 32'h"+machine_code+";\n")
            PC = PC + 4
            note = ""
    compile_codes.close()
    machine_codes.close()


main()
