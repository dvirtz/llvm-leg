//===-- LEGSchedule.td - Target Description for LEG ---*- tablegen -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file describes the LEG scheduling in TableGen format.
//
//===----------------------------------------------------------------------===//

foreach Operand = ["GR", "SP", "LR", "CPSR", "Imm", "Mem"] in {
  foreach Unit = ["ALU", "PCU", "LS"] in {
    def Write_#Unit#_#Operand : SchedWrite;
    def Read_#Unit#_#Operand : SchedRead;
  }
}

class LegLatency {
  int Latency;
}

// resources
foreach i = 1-2 in {
  def LEG#i#SchedModel : SchedMachineModel;

  let BufferSize = 0 in {
    foreach Unit = ["ALU", "PCU", "LS"] in {
      def LEG#i#_#Unit : ProcResource<1>;
    }
  }
}

// schedule each used SchedWrite and SchedRead
let SchedModel = LEG1SchedModel in {
  let Latency = 1 in {
    def : WriteRes<Write_ALU_GR, [LEG1_ALU]>;
    def : WriteRes<Write_ALU_CPSR, [LEG1_ALU]>;
    def : WriteRes<Write_PCU_LR, [LEG1_PCU]>;
    def : WriteRes<Write_LS_GR, [LEG1_LS]>;
    def : WriteRes<Write_LS_Mem, [LEG1_LS]>;
  }
  
  def : ReadAdvance<Read_ALU_GR, -1, [Write_ALU_GR]>;
  def : ReadAdvance<Read_ALU_Imm, 0, [Write_ALU_GR]>;
  def : ReadAdvance<Read_PCU_CPSR, 4, [Write_PCU_GR]>;
  def : ReadAdvance<Read_PCU_Imm, 4, [Write_PCU_GR]>;
  def : ReadAdvance<Read_PCU_SP, 4, [Write_PCU_GR]>;
  def : ReadAdvance<Read_LS_Mem, 4, [Write_LS_GR]>;
  def : ReadAdvance<Read_LS_GR, 4, [Write_LS_GR]>;
}

let SchedModel = LEG2SchedModel in {
  let Latency = 3 in {
    def : WriteRes<Write_ALU_GR, [LEG2_ALU]>;
    def : WriteRes<Write_ALU_CPSR, [LEG2_ALU]>;
    def : WriteRes<Write_PCU_LR, [LEG2_PCU]>;
    def : WriteRes<Write_LS_GR, [LEG2_LS]>;
    def : WriteRes<Write_LS_Mem, [LEG2_LS]>;
  }
  
  def : ReadAdvance<Read_ALU_GR, -1, [Write_ALU_GR]>;
  def : ReadAdvance<Read_ALU_Imm, 0, [Write_ALU_GR]>;
  def : ReadAdvance<Read_PCU_CPSR, 3, [Write_PCU_GR]>;
  def : ReadAdvance<Read_PCU_Imm, 3, [Write_PCU_GR]>;
  def : ReadAdvance<Read_PCU_SP, 3, [Write_PCU_GR]>;
  def : ReadAdvance<Read_LS_Mem, 3, [Write_LS_GR]>;
  def : ReadAdvance<Read_LS_GR, 3, [Write_LS_GR]>;
}