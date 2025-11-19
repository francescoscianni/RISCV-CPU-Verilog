def assemble(line):
    parts = line.strip().split()
    instr = parts[0]
    match(instr):
        case 'lw':
            rd, off, rs1 = parts[1].split(',')[0] 
            return 0
        case 'addi':
            return 0
        case 'slli':
            return 0
        case 'slti':
            return 0
        case 'xori':
            return 0
        case 'srli':
            return 0
        case 'ori':
            return 0
        case 'andi':
            return 0
        case 'sw':
            return 0
        case 'add':
            return 0
        case 'sub':
            return 0
        case 'sll':
            return 0
        case 'slt':
            return 0
        case 'xor':
            return 0
        case 'srl':
            return 0
        case 'or':
            return 0
        case 'and':
            return 0
        case 'beq':
            return 0
        case 'jal':
            return 0

if __name__=='__main__':
    asm_code =[
        "addi x1,x0,2",
        "addi x2,x1,5",
        "sw x2, 0(x0)"
    ]
    
    for line in asm_code:
        print(assemble(line))