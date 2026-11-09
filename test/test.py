import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_riscv_processor(dut):

    dut._log.info("Starting RISC-V processor simulation")

    # Start 50 MHz clock
    clock = Clock(dut.clk, 20, unit="ns")
    cocotb.start_soon(clock.start())

    # Initialize inputs
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0

    # Apply reset
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 5)

    # Release reset
    dut.rst_n.value = 1

    dut._log.info("Reset released")

    # Allow processor to execute instructions
    await ClockCycles(dut.clk, 30)

    # Read GPIO outputs
    pc_value = int(dut.uo_out.value)
    wb_value = int(dut.uio_out.value)

    dut._log.info(f"PC debug output: {pc_value}")
    dut._log.info(f"Writeback debug output: {wb_value}")

    # Check that processor has progressed
    assert pc_value != 0, "Processor PC has not progressed"

    dut._log.info("RISC-V simulation completed")
