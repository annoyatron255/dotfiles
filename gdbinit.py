import gdb
import sys

class IPythonGDBShell(gdb.Command):
    def __init__(self):
        super(IPythonGDBShell, self).__init__("ipython", gdb.COMMAND_USER)

    def invoke(self, argument, fromtty):
        # Backup old settings
        old_pagination = gdb.parameter("pagination")
        old_stdout = sys.stdout
        old_stderr = sys.stderr

        # Disable pagination/gdb IO wrappers for terminal access
        gdb.set_parameter("pagination", False)
        sys.stdout = sys.__stdout__
        sys.stderr = sys.__stderr__

        # Have to import here since the colors won't work if done earlier
        import IPython

        IPython.embed(colors="neutral")

        # Restore old settings
        gdb.set_parameter("pagination", old_pagination)
        sys.stdout = old_stdout
        sys.stderr = old_stderr

IPythonGDBShell()

class SingleStepStackUsage(gdb.Command):
    def __init__(self):
        super(SingleStepStackUsage, self).__init__("single_step_stack_usage",
                                                 gdb.COMMAND_USER)

    def invoke(self, argument, fromtty):
        # Backup old settings
        old_pagination = gdb.parameter("pagination")

        start_sp = int(gdb.parse_and_eval("$sp"))
        print(f"Start SP: 0x{start_sp:08x}")
        ret_addr = int(gdb.newest_frame().older().pc())

        min_sp = start_sp

        while int(gdb.parse_and_eval("$pc")) != ret_addr:
            gdb.execute("si")

            sp = int(gdb.parse_and_eval("$sp"))
            if sp < min_sp:
                min_sp = sp

        print(f"Min SP: 0x{min_sp:08x}, SP usage: 0x{start_sp - min_sp:08x}")

        # Restore old settings
        gdb.set_parameter("pagination", old_pagination)

SingleStepStackUsage()

class FreeRTOSMemoryUsage(gdb.Command):
    def __init__(self):
        super(FreeRTOSMemoryUsage, self).__init__("freertos_memory_usage",
                                                 gdb.COMMAND_USER)

    def invoke(self, argument, fromtty):
        inferior = gdb.selected_inferior()

        for thread in inferior.threads():
            tcb_addr = thread.ptid[1]

            stack_size = int(gdb.parse_and_eval(f"(((TCB_t*){tcb_addr})->pxEndOfStack - ((TCB_t*){tcb_addr})->pxStack) * sizeof(StackType_t)"))
            stack_current_used = int(gdb.parse_and_eval(f"(((TCB_t*){tcb_addr})->pxEndOfStack - ((TCB_t*){tcb_addr})->pxTopOfStack) * sizeof(StackType_t)"))
            stack_max_used = stack_size - int(gdb.parse_and_eval(f"uxTaskGetStackHighWaterMark({tcb_addr}) * sizeof(StackType_t)"))

            print(f"{thread.global_num:>2} ", end="")
            print(f"Thread {str(thread.details):<30} ", end="")
            print(f"Stack Size: {stack_size:>5}, ", end="")
            print(f"Used: {stack_current_used:>5} ({round((stack_current_used) / stack_size * 100):>2}%), ", end="")
            print(f"High Water Mark: {stack_max_used:>5} ({round((stack_max_used) / stack_size * 100):>2}%)")

        print()
        heap_stats = gdb.parse_and_eval("UpdateHeapStats()").dereference()
        heap_size = int(gdb.parse_and_eval('sizeof(ucHeap)'))
        heap_used = heap_size - int(heap_stats["xAvailableHeapSpaceInBytes"])
        heap_max_used = heap_size - int(heap_stats["xMinimumEverFreeBytesRemaining"])
        heap_smallest_free = heap_stats["xSizeOfSmallestFreeBlockInBytes"]
        heap_largest_free = heap_stats["xSizeOfLargestFreeBlockInBytes"]
        heap_num_free_blocks = heap_stats["xNumberOfFreeBlocks"]
        heap_num_mallocs = heap_stats["xNumberOfSuccessfulAllocations"]
        heap_num_frees = heap_stats["xNumberOfSuccessfulFrees"]

        print(f"Heap Size: {heap_size}, ", end="")
        print(f"Used: {heap_used} ({round(heap_used / heap_size * 100)}%), ", end="")
        print(f"Max Used: {heap_max_used} ({round(heap_max_used / heap_size * 100)}%)")
        print(f"Num Free Blocks: {heap_num_free_blocks}, Smallest Free Block: {heap_smallest_free}, Largest Free Block: {heap_largest_free}")
        print(f"Num Mallocs: {heap_num_mallocs}, Num Frees: {heap_num_frees}, Delta: {heap_num_mallocs - heap_num_frees}")

FreeRTOSMemoryUsage()
