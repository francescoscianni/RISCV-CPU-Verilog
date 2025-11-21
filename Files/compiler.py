def to_bin(val, bits):
    val = int(val)
    if val < 0:
        val = (1 << bits) + val
    return format(val & ((1 << bits) - 1), f'0{bits}b')

def get_reg(reg_str):
    reg_str = reg_str.replace(',', '').strip()
    if reg_str == 'zero': return "00000"
    if reg_str.startswith('x'):
        val = int(reg_str[1:])
        return to_bin(val, 5)
    return to_bin(0, 5) 

def assemble(line):
    line = line.split('//')[0].strip()
    if not line: return None
    parts = line.replace(',', ' ').split()
    instr = parts[0]

    OP_R_TYPE = "0110011"
    OP_I_TYPE = "0010011"
    OP_LOAD   = "0000011"
    OP_STORE  = "0100011"
    OP_BRANCH = "1100011"
    OP_JAL    = "1101111"

    machine_code = ""

    try:
        match instr:
            #R-TYPE Instructions
            #Format: funct7 | rs2 | rs1 | funct3 | rd | opcode
            case 'add' | 'sub' | 'sll' | 'slt' | 'xor' | 'srl' | 'or' | 'and':
                rd = get_reg(parts[1])
                rs1 = get_reg(parts[2])
                rs2 = get_reg(parts[3])
                
                funct3_map = {
                    'add': '000', 'sub': '000', 'sll': '001', 'slt': '010',
                    'xor': '100', 'srl': '101', 'or':  '110', 'and': '111'
                }
                funct7 = "0100000" if instr == 'sub' else "0000000"
                
                machine_code = f"{funct7}{rs2}{rs1}{funct3_map[instr]}{rd}{OP_R_TYPE}"

            #I-TYPE Instructions
            #Format: imm[11:0] | rs1 | funct3 | rd | opcode
            case 'addi' | 'slti' | 'xori' | 'ori' | 'andi' | 'slli' | 'srli':
                rd = get_reg(parts[1])
                rs1 = get_reg(parts[2])
                imm = to_bin(parts[3], 12)
                
                funct3_map = {
                    'addi': '000', 'slti': '010', 'xori': '100', 
                    'ori':  '110', 'andi': '111', 'slli': '001', 'srli': '101'
                }
                
                machine_code = f"{imm}{rs1}{funct3_map[instr]}{rd}{OP_I_TYPE}"

            #LOAD Instruction (lw)
            #Format: imm[11:0] | rs1 | funct3 | rd | opcode
            
            case 'lw':
                rd = get_reg(parts[1])
                mem_part = parts[2]
                offset_str = mem_part.split('(')[0]
                base_str = mem_part.split('(')[1].replace(')', '')
                
                imm = to_bin(offset_str, 12)
                rs1 = get_reg(base_str)
                funct3 = "010" #LW
                
                machine_code = f"{imm}{rs1}{funct3}{rd}{OP_LOAD}"

            #STORE Instruction (sw) 
            #Format: imm[11:5] | rs2 | rs1 | funct3 | imm[4:0] | opcode
            case 'sw':
                rs2 = get_reg(parts[1])
                mem_part = parts[2]
                offset_str = mem_part.split('(')[0]
                base_str = mem_part.split('(')[1].replace(')', '')
                
                imm_val = int(offset_str)
                rs1 = get_reg(base_str)
                
                #Split immediate for S-Type
                imm_bin = to_bin(imm_val, 12)
                imm_11_5 = imm_bin[0:7]
                imm_4_0 = imm_bin[7:12]
                funct3 = "010" #SW

                machine_code = f"{imm_11_5}{rs2}{rs1}{funct3}{imm_4_0}{OP_STORE}"

            #BRANCH Instruction (beq)
            #Format: imm[12]|imm[10:5]|rs2|rs1|funct3|imm[4:1]|imm[11]|opcode
            case 'beq':
                rs1 = get_reg(parts[1])
                rs2 = get_reg(parts[2])
                imm_val = int(parts[3])
                imm_bin = to_bin(imm_val, 13) 
        
                imm_12 = imm_bin[0]
                imm_11 = imm_bin[1]
                imm_10_5 = imm_bin[2:8]
                imm_4_1 = imm_bin[8:12]
                
                funct3 = "000" #BEQ
                
                machine_code = f"{imm_12}{imm_10_5}{rs2}{rs1}{funct3}{imm_4_1}{imm_11}{OP_BRANCH}"

            #JUMP Instruction (jal)
            #Format: imm[20]|imm[10:1]|imm[11]|imm[19:12]|rd|opcode
            case 'jal':
                rd = get_reg(parts[1])
                imm_val = int(parts[2])
                
                imm_bin = to_bin(imm_val, 21)
        
                imm_20 = imm_bin[0]
                imm_19_12 = imm_bin[1:9]
                imm_11 = imm_bin[9]
                imm_10_1 = imm_bin[10:20]
                
                machine_code = f"{imm_20}{imm_10_1}{imm_11}{imm_19_12}{rd}{OP_JAL}"

            case _:
                return f"// Unknown instruction: {instr}"

        #Convert Binary string to Hex (8 chars)
        hex_val = f"{int(machine_code, 2):08x}"
        return hex_val

    except Exception as e:
        return f"// Error assembling {line}: {e}"

if __name__ == '__main__':
    input_file = 'assembly.asm'
    
    #Check if file exists
    try:
        with open(input_file, 'r') as f:
            lines = f.readlines()
            
        print(f"Compiling {input_file}...")
        for i in range(16): #Number of empty memory locations before code
            print("00000000") #Empty space for writing memory
        
        for i, line in enumerate(lines):
            hex_code = assemble(line)
            if hex_code:
                print(hex_code) #Instructions
                
        print("0000006F") #END instruction (JAL x0, 0)
                
    except FileNotFoundError:
        print(f"Error: Could not find file '{input_file}'")