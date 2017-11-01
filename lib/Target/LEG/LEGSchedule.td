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
  def LEG#i#_SchedModel : SchedMachineModel;
  
  let Latency = i in
    def Leg#i#Latency : LegLatency;

  let BufferSize = 0 in {
    foreach Unit = ["ALU", "PCU", "LS"] in {
      def LEG#i#_#Unit : ProcResource<1>;
    }
  }
  
  let SchedModel = !cast<SchedMachineModel>("LEG"#i#"_SchedModel") in {
    foreach Operand = ["GR", "SP", "LR", "CPSR", "Imm", "Mem"]  in {
      foreach Unit = ["ALU", "PCU", "LS"] in {    
        let Latency = !cast<LegLatency>("Leg"#i#"Latency").Latency in  {
          def : WriteRes<!cast<SchedWrite>("Write_"#Unit#"_"#Operand), [!cast<ProcResourceKind>("LEG"#i#_#Unit)]>;
        }
        def : ReadAdvance<!cast<SchedRead>("Read_"#Unit#"_"#Operand), 0, [!cast<SchedWrite>("Write_"#Unit#"_"#Operand)]>;
      }
    }
  }
}
