Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbaCRHwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 03:52:33 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48459 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbaCRHw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 03:52:29 -0400
Date: Tue, 18 Mar 2014 08:52:25 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>
Subject: 3.14-rc6: softlockup at kswapd
Message-ID: <20140318075225.GA6955@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Machine should have been idle overnight, but I think  something killed
chromium-browser -- so it may ran out of memory.

Anyway, dmesg below.

Any ideas?
								Pavel

PS: That warn_on from wifi on every boot is getting boring :-(.

Initializing cgroup subsys cpu
Linux version 3.14.0-rc6+ (pavel@duo) (gcc version 4.4.5 (Debian 4.4.5-8) ) #330 SMP Sat Mar 15 10:55:26 CET 2014
Disabled fast string operations
e820: BIOS-provided physical RAM map:
BIOS-e820: [mem 0x0000000000000000-0x000000000009efff] usable
BIOS-e820: [mem 0x000000000009f000-0x000000000009ffff] reserved
BIOS-e820: [mem 0x00000000000d2000-0x00000000000d3fff] reserved
BIOS-e820: [mem 0x00000000000dc000-0x00000000000fffff] reserved
BIOS-e820: [mem 0x0000000000100000-0x000000007f6cffff] usable
BIOS-e820: [mem 0x000000007f6d0000-0x000000007f6defff] ACPI data
BIOS-e820: [mem 0x000000007f6df000-0x000000007f6fffff] ACPI NVS
BIOS-e820: [mem 0x000000007f700000-0x000000007fffffff] reserved
BIOS-e820: [mem 0x00000000f0000000-0x00000000f3ffffff] reserved
BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
BIOS-e820: [mem 0x00000000fed00000-0x00000000fed003ff] reserved
BIOS-e820: [mem 0x00000000fed14000-0x00000000fed19fff] reserved
BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed8ffff] reserved
BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] reserved
Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
SMBIOS 2.4 present.
DMI: LENOVO 17097HU/17097HU, BIOS 7BETD8WW (2.19 ) 03/31/2011
e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
e820: remove [mem 0x000a0000-0x000fffff] usable
e820: last_pfn = 0x7f6d0 max_arch_pfn = 0x100000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-CFFFF write-protect
  D0000-DBFFF uncachable
  DC000-DFFFF write-back
  E0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000 mask F80000000 write-back
  1 base 07F700000 mask FFFF00000 uncachable
  2 base 07F800000 mask FFF800000 uncachable
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
PAT not supported by CPU.
initial memory mapped: [mem 0x00000000-0x053fffff]
Base memory trampoline at [c009b000] 9b000 size 16384
init_memory_mapping: [mem 0x00000000-0x000fffff]
 [mem 0x00000000-0x000fffff] page 4k
init_memory_mapping: [mem 0x37000000-0x373fffff]
 [mem 0x37000000-0x373fffff] page 4k
BRK [0x050e1000, 0x050e1fff] PGTABLE
init_memory_mapping: [mem 0x30000000-0x36ffffff]
 [mem 0x30000000-0x36ffffff] page 4k
BRK [0x050e2000, 0x050e2fff] PGTABLE
BRK [0x050e3000, 0x050e3fff] PGTABLE
BRK [0x050e4000, 0x050e4fff] PGTABLE
BRK [0x050e5000, 0x050e5fff] PGTABLE
BRK [0x050e6000, 0x050e6fff] PGTABLE
init_memory_mapping: [mem 0x00100000-0x2fffffff]
 [mem 0x00100000-0x2fffffff] page 4k
init_memory_mapping: [mem 0x37400000-0x377fdfff]
 [mem 0x37400000-0x377fdfff] page 4k
ACPI: RSDP 000f67c0 000024 (v02 LENOVO)
ACPI: XSDT 7f6d191c 000084 (v01 LENOVO TP-7B    00002190  LTP 00000000)
ACPI: FACP 7f6d1a00 0000F4 (v03 LENOVO TP-7B    00002190 LNVO 00000001)
ACPI BIOS Warning (bug): 32/64X length mismatch in FADT/Gpe0Block: 64/32 (20131218/tbfadt-603)
ACPI BIOS Warning (bug): 32/64X length mismatch in FADT/Gpe1Block: 0/32 (20131218/tbfadt-603)
ACPI BIOS Warning (bug): Optional FADT field Gpe1Block has zero address or length: 0x000000000000102C/0x0 (20131218/tbfadt-634)
ACPI: DSDT 7f6d1d90 00CFB9 (v01 LENOVO TP-7B    00002190 MSFT 0100000E)
ACPI: FACS 7f6f4000 000040
ACPI: SSDT 7f6d1bb4 0001DC (v01 LENOVO TP-7B    00002190 MSFT 0100000E)
ACPI: ECDT 7f6ded49 000052 (v01 LENOVO TP-7B    00002190 LNVO 00000001)
ACPI: TCPA 7f6ded9b 000032 (v02 LENOVO TP-7B    00002190 LNVO 00000001)
ACPI: APIC 7f6dedcd 000068 (v01 LENOVO TP-7B    00002190 LNVO 00000001)
ACPI: MCFG 7f6dee35 00003C (v01 LENOVO TP-7B    00002190 LNVO 00000001)
ACPI: HPET 7f6dee71 000038 (v01 LENOVO TP-7B    00002190 LNVO 00000001)
ACPI: BOOT 7f6defd8 000028 (v01 LENOVO TP-7B    00002190  LTP 00000001)
ACPI: SSDT 7f6f2645 00025F (v01 LENOVO TP-7B    00002190 INTL 20050513)
ACPI: SSDT 7f6f28a4 0000A6 (v01 LENOVO TP-7B    00002190 INTL 20050513)
ACPI: SSDT 7f6f294a 0004F7 (v01 LENOVO TP-7B    00002190 INTL 20050513)
ACPI: SSDT 7f6f2e41 0001D8 (v01 LENOVO TP-7B    00002190 INTL 20050513)
ACPI: Local APIC address 0xfee00000
1150MB HIGHMEM available.
887MB LOWMEM available.
  mapped low ram: 0 - 377fe000
  low ram: 0 - 377fe000
Zone ranges:
  DMA      [mem 0x00001000-0x00ffffff]
  Normal   [mem 0x01000000-0x377fdfff]
  HighMem  [mem 0x377fe000-0x7f6cffff]
Movable zone start for each node
Early memory node ranges
  node   0: [mem 0x00001000-0x0009efff]
  node   0: [mem 0x00100000-0x7f6cffff]
On node 0 totalpages: 521838
free_area_init_node: node 0, pgdat c4b30200, node_mem_map f614f024
  DMA zone: 36 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3998 pages, LIFO batch:0
  Normal zone: 1962 pages used for memmap
  Normal zone: 223230 pages, LIFO batch:31
  HighMem zone: 2590 pages used for memmap
  HighMem zone: 294610 pages, LIFO batch:31
Using APIC driver default
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
smpboot: Allowing 2 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 40
PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
PM: Registered nosave memory: [mem 0x000a0000-0x000d1fff]
PM: Registered nosave memory: [mem 0x000d2000-0x000d3fff]
PM: Registered nosave memory: [mem 0x000d4000-0x000dbfff]
PM: Registered nosave memory: [mem 0x000dc000-0x000fffff]
e820: [mem 0x80000000-0xefffffff] available for PCI devices
setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 13 pages/cpu @f77c2000 s29248 r0 d24000 u53248
pcpu-alloc: s29248 r0 d24000 u53248 alloc=13*4096
pcpu-alloc: [0] 0 [0] 1 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 519840
Kernel command line: BOOT_IMAGE=(hd0,2)/l/linux-good/arch/x86/boot/bzImage root=/dev/sda3 resume=/dev/sda1 psmouse.psmouse_proto=imps psmouse_proto=imps psmouse.proto=imps acpi_sleep=s3_bios,s3_mode no_console_suspend i915.modeset=1 video=inteldrmfb:mode=1024x768 fbcon=scrollback:64k
PID hash table entries: 4096 (order: 2, 16384 bytes)
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Initializing CPU#0
Initializing HighMem for node 0 (000377fe:0007f6d0)
Initializing Movable for node 0 (00000000:00000000)
Memory: 2049808K/2087352K available (8073K kernel code, 512K rwdata, 2972K rodata, 492K init, 5104K bss, 37544K reserved, 1178440K highmem)
virtual kernel memory layout:
    fixmap  : 0xffe6e000 - 0xfffff000   (1604 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc4b4c000 - 0xc4bc7000   ( 492 kB)
      .data : 0xc47e28a3 - 0xc4b4b040   (3489 kB)
      .text : 0xc4000000 - 0xc47e28a3   (8074 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
Hierarchical RCU implementation.
	RCU dyntick-idle grace-period acceleration is enabled.
	RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=2.
RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=2
NR_IRQS:2304 nr_irqs:512 16
CPU 0 irqstacks, hard=f5c1a000 soft=f5c1c000
ACPI: Core revision 20131218
ACPI: All ACPI Tables successfully acquired
Console: colour VGA+ 80x25
console [tty0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     16384
... MAX_LOCKDEP_CHAINS:      32768
... CHAINHASH_SIZE:          16384
 memory used by lock dependency info: 3551 kB
 per task-struct memory footprint: 1152 bytes
ODEBUG: 9 of 9 active objects replaced
hpet clockevent registered
tsc: Fast TSC calibration using PIT
tsc: Detected 1828.705 MHz processor
Calibrating delay loop (skipped), value calculated using timer frequency.. 3657.41 BogoMIPS (lpj=7314820)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 512
Disabled fast string operations
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
Last level iTLB entries: 4KB 128, 2MB 0, 4MB 2
Last level dTLB entries: 4KB 128, 2MB 0, 4MB 8, 1GB 0
tlb_flushall_shift: 6
debug: unmapping init [mem 0xc4bc7000-0xc4bcefff]
Enabling APIC mode:  Flat.  Using 1 I/O APICs
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
smpboot: CPU0: Genuine Intel(R) CPU           T2400  @ 1.83GHz (fam: 06, model: 0e, stepping: 08)
Performance Events: Core events, core PMU driver.
... version:                1
... bit width:              40
... generic registers:      2
... value mask:             000000ffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   0
... event mask:             0000000000000003
NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
CPU 1 irqstacks, hard=f5ddc000 soft=f5dde000
x86: Booting SMP configuration:
.... node  #0, CPUs:      #1
Initializing CPU#1
Disabled fast string operations
TSC synchronization [CPU#0 -> CPU#1]:
Measured 579975 cycles TSC warp between CPUs, turning off TSC clock.
tsc: Marking TSC unstable due to check_tsc_sync_source failed
x86: Booted up 1 node, 2 CPUs
smpboot: Total of 2 processors activated (7314.82 BogoMIPS)
devtmpfs: initialized
PM: Registering ACPI NVS region [mem 0x7f6df000-0x7f6fffff] (135168 bytes)
NET: Registered protocol family 16
cpuidle: using governor ladder
cpuidle: using governor menu
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type PCI registered
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000)
PCI: MMCONFIG at [mem 0xf0000000-0xf3ffffff] reserved in E820
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI : EC: EC description table is found, configuring boot EC
ACPI: SSDT 7f6f1d26 000240 (v01  PmRef  Cpu0Ist 00000100 INTL 20050513)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT   (null) 000240 (v01  PmRef  Cpu0Ist 00000100 INTL 20050513)
ACPI: SSDT 7f6f1feb 00065A (v01  PmRef  Cpu0Cst 00000100 INTL 20050513)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT   (null) 00065A (v01  PmRef  Cpu0Cst 00000100 INTL 20050513)
ACPI: SSDT 7f6f1c5e 0000C8 (v01  PmRef  Cpu1Ist 00000100 INTL 20050513)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT   (null) 0000C8 (v01  PmRef  Cpu1Ist 00000100 INTL 20050513)
ACPI: SSDT 7f6f1f66 000085 (v01  PmRef  Cpu1Cst 00000100 INTL 20050513)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT   (null) 000085 (v01  PmRef  Cpu1Cst 00000100 INTL 20050513)
ACPI: Interpreter enabled
ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20131218/hwxface-580)
ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20131218/hwxface-580)
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
ACPI: ACPI Dock Station Driver: 3 docks/bays found
ACPI: Power Resource [PUBS] (on)
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments]
acpi PNP0A08:00: _OSC: not requesting OS control; OS requires [ExtendedConfig ASPM ClockPM MSI]
acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-3f] only partially covers this bridge
PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [bus 00-ff]
pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff]
pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed40fff]
pci 0000:00:00.0: [8086:27a0] type 00 class 0x060000
pci 0000:00:02.0: [8086:27a2] type 00 class 0x030000
pci 0000:00:02.0: reg 0x10: [mem 0xee100000-0xee17ffff]
pci 0000:00:02.0: reg 0x14: [io  0x1800-0x1807]
pci 0000:00:02.0: reg 0x18: [mem 0xd0000000-0xdfffffff pref]
pci 0000:00:02.0: reg 0x1c: [mem 0xee200000-0xee23ffff]
pci 0000:00:02.1: [8086:27a6] type 00 class 0x038000
pci 0000:00:02.1: reg 0x10: [mem 0xee180000-0xee1fffff]
pci 0000:00:1b.0: [8086:27d8] type 00 class 0x040300
pci 0000:00:1b.0: reg 0x10: [mem 0xee240000-0xee243fff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: System wakeup disabled by ACPI
pci 0000:00:1c.0: [8086:27d0] type 01 class 0x060400
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: System wakeup disabled by ACPI
pci 0000:00:1c.1: [8086:27d2] type 01 class 0x060400
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: System wakeup disabled by ACPI
pci 0000:00:1c.2: [8086:27d4] type 01 class 0x060400
pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.2: System wakeup disabled by ACPI
pci 0000:00:1c.3: [8086:27d6] type 01 class 0x060400
pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.3: System wakeup disabled by ACPI
pci 0000:00:1d.0: [8086:27c8] type 00 class 0x0c0300
pci 0000:00:1d.0: reg 0x20: [io  0x1820-0x183f]
pci 0000:00:1d.0: System wakeup disabled by ACPI
pci 0000:00:1d.1: [8086:27c9] type 00 class 0x0c0300
pci 0000:00:1d.1: reg 0x20: [io  0x1840-0x185f]
pci 0000:00:1d.1: System wakeup disabled by ACPI
pci 0000:00:1d.2: [8086:27ca] type 00 class 0x0c0300
pci 0000:00:1d.2: reg 0x20: [io  0x1860-0x187f]
pci 0000:00:1d.2: System wakeup disabled by ACPI
pci 0000:00:1d.3: [8086:27cb] type 00 class 0x0c0300
pci 0000:00:1d.3: reg 0x20: [io  0x1880-0x189f]
pci 0000:00:1d.7: [8086:27cc] type 00 class 0x0c0320
pci 0000:00:1d.7: reg 0x10: [mem 0xee444000-0xee4443ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: System wakeup disabled by ACPI
pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
pci 0000:00:1e.0: System wakeup disabled by ACPI
pci 0000:00:1f.0: [8086:27b9] type 00 class 0x060100
pci 0000:00:1f.0: address space collision: [io  0x1000-0x107f] conflicts with ACPI CPU throttle [??? 0x00001010-0x00001015 flags 0x80000000]
pci 0000:00:1f.0: quirk: [io  0x1180-0x11bf] claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 1600 (mask 007f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 15e0 (mask 000f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 1680 (mask 001f)
pci 0000:00:1f.1: [8086:27df] type 00 class 0x01018a
pci 0000:00:1f.1: reg 0x10: [io  0x0000-0x0007]
pci 0000:00:1f.1: reg 0x14: [io  0x0000-0x0003]
pci 0000:00:1f.1: reg 0x18: [io  0x0000-0x0007]
pci 0000:00:1f.1: reg 0x1c: [io  0x0000-0x0003]
pci 0000:00:1f.1: reg 0x20: [io  0x1810-0x181f]
pci 0000:00:1f.2: [8086:27c5] type 00 class 0x010601
pci 0000:00:1f.2: reg 0x10: [io  0x18d0-0x18d7]
pci 0000:00:1f.2: reg 0x14: [io  0x18c4-0x18c7]
pci 0000:00:1f.2: reg 0x18: [io  0x18c8-0x18cf]
pci 0000:00:1f.2: reg 0x1c: [io  0x18c0-0x18c3]
pci 0000:00:1f.2: reg 0x20: [io  0x18b0-0x18bf]
pci 0000:00:1f.2: reg 0x24: [mem 0xee444400-0xee4447ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.3: [8086:27da] type 00 class 0x0c0500
pci 0000:00:1f.3: reg 0x20: [io  0x18e0-0x18ff]
pci 0000:02:00.0: [8086:109a] type 00 class 0x020000
pci 0000:02:00.0: reg 0x10: [mem 0xee000000-0xee01ffff]
pci 0000:02:00.0: reg 0x18: [io  0x2000-0x201f]
pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:1c.0: PCI bridge to [bus 02]
pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.0:   bridge window [mem 0xee000000-0xee0fffff]
pci 0000:03:00.0: [8086:4227] type 00 class 0x028000
pci 0000:03:00.0: reg 0x10: [mem 0xedf00000-0xedf00fff]
pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:1c.1: PCI bridge to [bus 03]
pci 0000:00:1c.1:   bridge window [io  0x3000-0x4fff]
pci 0000:00:1c.1:   bridge window [mem 0xec000000-0xedffffff]
pci 0000:00:1c.1:   bridge window [mem 0xe4000000-0xe40fffff 64bit pref]
acpiphp: Slot [1] registered
pci 0000:00:1c.2: PCI bridge to [bus 04-0b]
pci 0000:00:1c.2:   bridge window [io  0x5000-0x6fff]
pci 0000:00:1c.2:   bridge window [mem 0xe8000000-0xe9ffffff]
pci 0000:00:1c.2:   bridge window [mem 0xe4100000-0xe41fffff 64bit pref]
pci 0000:00:1c.3: PCI bridge to [bus 0c-13]
pci 0000:00:1c.3:   bridge window [io  0x7000-0x8fff]
pci 0000:00:1c.3:   bridge window [mem 0xea000000-0xebffffff]
pci 0000:00:1c.3:   bridge window [mem 0xe4200000-0xe42fffff 64bit pref]
pci 0000:15:00.0: [1180:0476] type 02 class 0x060700
pci 0000:15:00.0: reg 0x10: [mem 0xe4300000-0xe4300fff]
pci 0000:15:00.0: supports D1 D2
pci 0000:15:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:15:00.1: [1180:0552] type 00 class 0x0c0010
pci 0000:15:00.1: reg 0x10: [mem 0xe4301000-0xe43017ff]
pci 0000:15:00.1: PME# supported from D0 D3hot D3cold
pci 0000:15:00.2: [1180:0822] type 00 class 0x080500
pci 0000:15:00.2: reg 0x10: [mem 0xe4301800-0xe43018ff]
pci 0000:15:00.2: supports D1 D2
pci 0000:15:00.2: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:1e.0: PCI bridge to [bus 15-18] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x9000-0xcfff]
pci 0000:00:1e.0:   bridge window [mem 0xe4300000-0xe7ffffff]
pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xe3ffffff 64bit pref]
pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x80000000-0xfebfffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfed40fff] (subtractive decode)
pci_bus 0000:16: busn_res: can not insert [bus 16-ff] under [bus 15-18] (conflicts with (null) [bus 15-18])
pci_bus 0000:16: busn_res: [bus 16-ff] end is updated to 17
pci_bus 0000:00: on NUMA node 0
ACPI: Enabled 2 GPEs in block 00 to 1F
ACPI : EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
vgaarb: bridge control possible 0000:00:02.0
SCSI subsystem initialized
libata version 3.00 loaded.
ACPI: bus type USB registered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
pps_core: LinuxPPS API ver. 1 registered
pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
PTP clock support registered
EDAC MC: Ver: 3.0.0
Advanced Linux Sound Architecture Driver Initialized.
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
e820: reserve RAM buffer [mem 0x0009f000-0x0009ffff]
e820: reserve RAM buffer [mem 0x7f6d0000-0x7fffffff]
Bluetooth: Core ver 2.18
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO socket layer initialized
------------[ cut here ]------------
WARNING: CPU: 1 PID: 1 at net/wireless/reg.c:481 regulatory_init+0x92/0xff()
db.txt is empty, you should update it...
Modules linked in:
CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc6+ #330
Hardware name: LENOVO 17097HU/17097HU, BIOS 7BETD8WW (2.19 ) 03/31/2011
 000001e1 f5d21e44 c47dc0eb c4a7c290 f5d21e74 c4037f9a c4a85d40 f5d21ea0
 00000001 c4a7c290 000001e1 c4b82a9f c4b82a9f 00000000 c4b82936 f5d21ec8
 f5d21e8c c403803e 00000009 f5d21e84 c4a85d40 f5d21ea0 f5d21ecc c4b82a9f
Call Trace:
 [<c47dc0eb>] dump_stack+0x41/0x52
 [<c4037f9a>] warn_slowpath_common+0x7a/0xa0
 [<c4b82a9f>] ? regulatory_init+0x92/0xff
 [<c4b82a9f>] ? regulatory_init+0x92/0xff
 [<c4b82936>] ? cache_initialize+0x86/0x86
 [<c403803e>] warn_slowpath_fmt+0x2e/0x30
 [<c4b82a9f>] regulatory_init+0x92/0xff
 [<c4b82995>] cfg80211_init+0x5f/0xd7
 [<c4b81ff3>] ? bt_init+0x6e/0x98
 [<c40003fa>] do_one_initcall+0xca/0x180
 [<c4b4c663>] ? repair_env_string+0x15/0x5b
 [<c40514c1>] ? parse_args+0x1f1/0x440
 [<c4b4c5a9>] kernel_init_freeable+0xec/0x191
 [<c4b4c64e>] ? kernel_init_freeable+0x191/0x191
 [<c47d893b>] kernel_init+0xb/0xe0
 [<c47e13b7>] ret_from_kernel_thread+0x1b/0x28
 [<c47d8930>] ? rest_init+0xb0/0xb0
---[ end trace fd1b107111d0460f ]---
cfg80211: Calling CRDA to update world regulatory domain
Switched to clocksource hpet
pnp: PnP ACPI init
ACPI: bus type PNP registered
pnp 00:00: unknown resource type 10 in _CRS
pnp 00:00: can't evaluate _CRS: 1
system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
system 00:00: [mem 0x000cc000-0x000cffff] could not be reserved
system 00:00: [mem 0x000d0000-0x000d3fff] could not be reserved
system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
system 00:01: [io  0x164e-0x164f] has been reserved
system 00:01: [io  0x1000-0x107f] could not be reserved
system 00:01: [io  0x1180-0x11bf] has been reserved
system 00:01: [io  0x0800-0x080f] has been reserved
system 00:01: [io  0x15e0-0x15ef] has been reserved
system 00:01: [io  0x1600-0x165f] could not be reserved
system 00:01: [mem 0xf0000000-0xf3ffffff] has been reserved
system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
system 00:01: [mem 0xfed14000-0xfed17fff] has been reserved
system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:02: Plug and Play ACPI device, IDs PNP0103 (active)
pnp 00:03: [dma 4]
pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
pnp 00:08: Plug and Play ACPI device, IDs IBM3780 PNP0f13 (active)
pnp 00:09: Plug and Play ACPI device, IDs PNP0501 (active)
pnp 00:0a: Plug and Play ACPI device, IDs PNP0400 (active)
pnp 00:0b: [dma 3]
pnp 00:0b: Plug and Play ACPI device, IDs IBM0071 PNP0511 (active)
pnp 00:0c: Plug and Play ACPI device, IDs ATM1200 PNP0c31 (active)
pnp: PnP ACPI: found 13 devices
ACPI: bus type PNP unregistered
pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 02] add_size 200000
pci 0000:00:1f.0: BAR 7: [io  0x1000-0x107f] has bogus alignment
pci 0000:00:1c.0: res[9]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
pci 0000:00:1c.0: BAR 9: assigned [mem 0x80000000-0x801fffff 64bit pref]
pci 0000:00:1c.0: PCI bridge to [bus 02]
pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.0:   bridge window [mem 0xee000000-0xee0fffff]
pci 0000:00:1c.0:   bridge window [mem 0x80000000-0x801fffff 64bit pref]
pci 0000:00:1c.1: PCI bridge to [bus 03]
pci 0000:00:1c.1:   bridge window [io  0x3000-0x4fff]
pci 0000:00:1c.1:   bridge window [mem 0xec000000-0xedffffff]
pci 0000:00:1c.1:   bridge window [mem 0xe4000000-0xe40fffff 64bit pref]
pci 0000:00:1c.2: PCI bridge to [bus 04-0b]
pci 0000:00:1c.2:   bridge window [io  0x5000-0x6fff]
pci 0000:00:1c.2:   bridge window [mem 0xe8000000-0xe9ffffff]
pci 0000:00:1c.2:   bridge window [mem 0xe4100000-0xe41fffff 64bit pref]
pci 0000:00:1c.3: PCI bridge to [bus 0c-13]
pci 0000:00:1c.3:   bridge window [io  0x7000-0x8fff]
pci 0000:00:1c.3:   bridge window [mem 0xea000000-0xebffffff]
pci 0000:00:1c.3:   bridge window [mem 0xe4200000-0xe42fffff 64bit pref]
pci 0000:15:00.0: res[9]=[mem 0x04000000-0x03ffffff pref] get_res_add_size add_size 4000000
pci 0000:15:00.0: res[10]=[mem 0x04000000-0x03ffffff] get_res_add_size add_size 4000000
pci 0000:15:00.0: res[7]=[io  0x0100-0x00ff] get_res_add_size add_size 100
pci 0000:15:00.0: res[8]=[io  0x0100-0x00ff] get_res_add_size add_size 100
pci 0000:15:00.0: BAR 9: assigned [mem 0xe0000000-0xe3ffffff pref]
pci 0000:15:00.0: BAR 10: assigned [mem 0x84000000-0x87ffffff]
pci 0000:15:00.0: BAR 7: assigned [io  0x9000-0x90ff]
pci 0000:15:00.0: BAR 8: assigned [io  0x9400-0x94ff]
pci 0000:15:00.0: CardBus bridge to [bus 16-17]
pci 0000:15:00.0:   bridge window [io  0x9000-0x90ff]
pci 0000:15:00.0:   bridge window [io  0x9400-0x94ff]
pci 0000:15:00.0:   bridge window [mem 0xe0000000-0xe3ffffff pref]
pci 0000:15:00.0:   bridge window [mem 0x84000000-0x87ffffff]
pci 0000:00:1e.0: PCI bridge to [bus 15-18]
pci 0000:00:1e.0:   bridge window [io  0x9000-0xcfff]
pci 0000:00:1e.0:   bridge window [mem 0xe4300000-0xe7ffffff]
pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xe3ffffff 64bit pref]
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
pci_bus 0000:00: resource 9 [mem 0x80000000-0xfebfffff]
pci_bus 0000:00: resource 10 [mem 0xfed40000-0xfed40fff]
pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
pci_bus 0000:02: resource 1 [mem 0xee000000-0xee0fffff]
pci_bus 0000:02: resource 2 [mem 0x80000000-0x801fffff 64bit pref]
pci_bus 0000:03: resource 0 [io  0x3000-0x4fff]
pci_bus 0000:03: resource 1 [mem 0xec000000-0xedffffff]
pci_bus 0000:03: resource 2 [mem 0xe4000000-0xe40fffff 64bit pref]
pci_bus 0000:04: resource 0 [io  0x5000-0x6fff]
pci_bus 0000:04: resource 1 [mem 0xe8000000-0xe9ffffff]
pci_bus 0000:04: resource 2 [mem 0xe4100000-0xe41fffff 64bit pref]
pci_bus 0000:0c: resource 0 [io  0x7000-0x8fff]
pci_bus 0000:0c: resource 1 [mem 0xea000000-0xebffffff]
pci_bus 0000:0c: resource 2 [mem 0xe4200000-0xe42fffff 64bit pref]
pci_bus 0000:15: resource 0 [io  0x9000-0xcfff]
pci_bus 0000:15: resource 1 [mem 0xe4300000-0xe7ffffff]
pci_bus 0000:15: resource 2 [mem 0xe0000000-0xe3ffffff 64bit pref]
pci_bus 0000:15: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:15: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:15: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:15: resource 7 [mem 0x000d4000-0x000d7fff]
pci_bus 0000:15: resource 8 [mem 0x000d8000-0x000dbfff]
pci_bus 0000:15: resource 9 [mem 0x80000000-0xfebfffff]
pci_bus 0000:15: resource 10 [mem 0xfed40000-0xfed40fff]
pci_bus 0000:16: resource 0 [io  0x9000-0x90ff]
pci_bus 0000:16: resource 1 [io  0x9400-0x94ff]
pci_bus 0000:16: resource 2 [mem 0xe0000000-0xe3ffffff pref]
pci_bus 0000:16: resource 3 [mem 0x84000000-0x87ffffff]
NET: Registered protocol family 2
TCP established hash table entries: 8192 (order: 3, 32768 bytes)
TCP bind hash table entries: 8192 (order: 6, 294912 bytes)
TCP: Hash tables configured (established 8192 bind 8192)
TCP: reno registered
UDP hash table entries: 512 (order: 3, 40960 bytes)
UDP-Lite hash table entries: 512 (order: 3, 40960 bytes)
NET: Registered protocol family 1
RPC: Registered named UNIX socket transport module.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
pci 0000:00:02.0: Boot video device
PCI: CLS mismatch (64 != 32), using 64 bytes
Simple Boot Flag at 0x35 set to 0x1
futex hash table entries: 512 (order: 3, 32768 bytes)
bounce pool size: 64 pages
NTFS driver 2.1.30 [Flags: R/W].
fuse init (API version 7.22)
msgmni has been set to 1701
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
intel_idle: does not run on family 6 model 14
ACPI: AC Adapter [AC] (on-line)
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
ACPI: Lid Switch [LID]
input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
ACPI: Sleep Button [SLPB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
ACPI: Power Button [PWRF]
ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
acpi device:02: registered as cooling_device0
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input3
ACPI: acpi_idle registered with cpuidle
thermal LNXTHERM:00: registered as thermal_zone0
ACPI: Thermal Zone [THM0] (72 C)
thermal LNXTHERM:01: registered as thermal_zone1
ACPI: Thermal Zone [THM1] (71 C)
GHES: HEST is not enabled!
ERST DBG: ERST support is disabled.
ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
ACPI: Battery Slot [BAT0] (battery present)
Error: Driver 'battery' is already registered, aborting...
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
00:09: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 921600) is a NS16550A
lp: driver loaded but no devices found
Non-volatile memory driver v1.3
intel_rng: FWH not detected
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel 945GM Chipset
agpgart-intel 0000:00:00.0: detected gtt size: 262144K total, 262144K mappable
agpgart-intel 0000:00:00.0: detected 8192K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[drm] Initialized drm 1.1.0 20060810
[drm] Memory usable by graphics device = 256M
[drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[drm] Driver supports precise vblank timestamp query.
vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[drm] initialized overlay support
fbcon: inteldrmfb (fb0) is primary device
Console: switching to colour frame buffer device 102x42
i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
i915 0000:00:02.0: registered panic notifier
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
usbcore: registered new interface driver udl
parport_pc 00:0a: reported by Plug and Play ACPI
parport0: PC-style at 0x3bc, irq 7 [PCSPP(,...)]
lp0: using parport0 (interrupt-driven).
loop: module loaded
nbd: registered device at major 43
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 1.5 Gbps 0x1 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part 
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 abar m1024@0xee444400 port 0xee444500 irq 16
ata2: DUMMY
ata3: DUMMY
ata4: DUMMY
ata_piix 0000:00:1f.1: version 2.13
scsi4 : ata_piix
scsi5 : ata_piix
ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1810 irq 14
ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1818 irq 15
ata6: port disabled--ignoring
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
e1000e 0000:02:00.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
ata5.00: ATAPI: UJDA765 DVD/CDRW, 1.70, max UDMA/33
e1000e 0000:02:00.0 eth0: (PCI Express:2.5GT/s:Width x1) 00:16:d3:25:19:04
e1000e 0000:02:00.0 eth0: Intel(R) PRO/1000 Network Connection
e1000e 0000:02:00.0 eth0: MAC: 2, PHY: 2, PBA No: 005302-003
ata5.00: configured for UDMA/33
PPP generic driver version 2.4.2
PPP BSD Compression module registered
PPP Deflate Compression module registered
SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256).
CSLIP: code copyright 1989 Regents of the University of California.
iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, in-tree:ds
iwl3945: Copyright(c) 2003-2011 Intel Corporation
iwl3945 0000:03:00.0: Tunable channels: 11 802.11bg, 13 802.11a channels
iwl3945 0000:03:00.0: Detected Intel Wireless WiFi Link 3945ABG
ieee80211 phy0: Selected rate control algorithm 'iwl-3945-rs'
usbcore: registered new interface driver ax88179_178a
usbcore: registered new interface driver cdc_ether
usbcore: registered new interface driver r815x
usbcore: registered new interface driver net1080
usbcore: registered new interface driver cdc_subset
usbcore: registered new interface driver zaurus
usbcore: registered new interface driver cdc_ncm
pci 0000:00:1e.0: enabling device (0005 -> 0007)
yenta_cardbus 0000:15:00.0: CardBus bridge found [17aa:201c]
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ATA-8: ST9500325AS, 0001SDM1, max UDMA/133
ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      ST9500325AS      0001 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 4:0:0:0: CD-ROM            MATSHITA UJDA765 DVD/CDRW 1.70 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
cdrom: Uniform CD-ROM driver Revision: 3.20
sr 4:0:0:0: Attached scsi CD-ROM sr0
sr 4:0:0:0: Attached scsi generic sg1 type 5
 sda: sda1 sda2 sda3 sda4
sd 0:0:0:0: [sda] Attached SCSI disk
yenta_cardbus 0000:15:00.0: ISA IRQ mask 0x0c38, PCI irq 16
yenta_cardbus 0000:15:00.0: Socket status: 30000006
yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [io  0x9000-0xcfff]
yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [mem 0xe4300000-0xe7ffffff]
pcmcia_socket pcmcia_socket0: cs: memory probe 0xe4300000-0xe7ffffff:
 excluding 0xe4300000-0xe46cffff
yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [mem 0xe0000000-0xe3ffffff 64bit pref]
pcmcia_socket pcmcia_socket0: cs: memory probe 0xe0000000-0xe3ffffff:
 excluding 0xe0000000-0xe3ffffff
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci-pci: EHCI PCI platform driver
ehci-pci 0000:00:1d.7: EHCI Host Controller
ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci-pci 0000:00:1d.7: debug port 1
ehci-pci 0000:00:1d.7: cache line size of 64 is not supported
ehci-pci 0000:00:1d.7: irq 19, io mem 0xee444000
ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 3.14.0-rc6+ ehci_hcd
usb usb1: SerialNumber: 0000:00:1d.7
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci-pci: OHCI PCI platform driver
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: detected 2 ports
uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001820
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 3.14.0-rc6+ uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: detected 2 ports
uhci_hcd 0000:00:1d.1: irq 17, io base 0x00001840
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 3.14.0-rc6+ uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.1
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: detected 2 ports
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001860
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 3.14.0-rc6+ uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.2
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: detected 2 ports
uhci_hcd 0000:00:1d.3: irq 19, io base 0x00001880
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 3.14.0-rc6+ uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.3
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usbcore: registered new interface driver cdc_acm
cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
usbcore: registered new interface driver usblp
usbcore: registered new interface driver usb-storage
usbcore: registered new interface driver ums-sddr09
usbcore: registered new interface driver usbserial
usbcore: registered new interface driver usbserial_generic
usbserial: USB Serial support registered for generic
usbcore: registered new interface driver ftdi_sio
usbserial: USB Serial support registered for FTDI USB Serial Device
usbcore: registered new interface driver option
usbserial: USB Serial support registered for GSM modem (1-port)
usbcore: registered new interface driver pl2303
usbserial: USB Serial support registered for pl2303
usbcore: registered new interface driver ti_usb_3410_5052
usbserial: USB Serial support registered for TI USB 3410 1 port adapter
usbserial: USB Serial support registered for TI USB 5052 2 port adapter
driver ftdi-elan
usbcore: registered new interface driver ftdi-elan
i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
input: PC Speaker as /devices/platform/pcspkr/input/input5
rtc_cmos 00:06: RTC can wake from S4
rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
rtc_cmos 00:06: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
Bluetooth: HCI UART driver ver 2.2
Bluetooth: HCI H4 protocol initialized
Bluetooth: HCI BCSP protocol initialized
usbcore: registered new interface driver btusb
lguest: mapped switcher at ffe68000
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
sdhci-pci 0000:15:00.2: SDHCI controller found [1180:0822] (rev 18)
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
mmc0: SDHCI controller on PCI [0000:15:00.2] using DMA
hidraw: raw HID events driver (C) Jiri Kosina
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
thinkpad_acpi: ThinkPad ACPI Extras v0.25
thinkpad_acpi: http://ibm-acpi.sf.net/
thinkpad_acpi: ThinkPad BIOS 7BETD8WW (2.19 ), EC 7BHT40WW-1.13
thinkpad_acpi: Lenovo ThinkPad X60, model 17097HU
thinkpad_acpi: detected a 8-level brightness capable ThinkPad
thinkpad_acpi: ACPI backlight control delay disabled
thinkpad_acpi: radio switch found; radios are enabled
thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
usb 1-6: new high-speed USB device number 2 using ehci-pci
thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
thinkpad_acpi: warning: userspace override of important firmware LEDs is enabled
thinkpad_acpi: Standard ACPI backlight interface available, not loading native one
thinkpad_acpi: volume: disabled as there is no ALSA support in this kernel
input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input8
hda_intel: probe_mask set to 0x1 for device 17aa:2010
usbcore: registered new interface driver snd-usb-audio
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP: cubic registered
NET: Registered protocol family 17
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM ver 1.11
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
Bluetooth: BNEP socket layer initialized
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
Bluetooth: HIDP socket layer initialized
autoconfig: line_outs=1 (0x5/0x0/0x0/0x0/0x0) type:speaker
   speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
   hp_outs=0 (0x0/0x0/0x0/0x0/0x0)
   mono: mono_out=0x0
   inputs:
     Mic=0x8
     CD=0x19
Using IPI No-Shortcut mode
rtc_cmos 00:06: setting system clock to 2014-03-15 10:00:25 UTC (1394877625)
PM: Checking hibernation image partition /dev/sda1
PM: Hibernation image partition 8:1 present
PM: Looking for hibernation image.
usb 1-6: New USB device found, idVendor=17ef, idProduct=1000
usb 1-6: New USB device strings: Mfr=0, Product=0, SerialNumber=0
hub 1-6:1.0: USB hub found
hub 1-6:1.0: 4 ports detected
input: PS/2 Generic Mouse as /devices/platform/i8042/serio1/input/input7
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
PM: Image not found (code -22)
PM: Hibernation image not present or could not be loaded.
ALSA device list:
  #0: HDA Intel at 0xee240000 irq 17
md: Waiting for all devices to be available before autodetect
md: If you don't use raid, use raid=noautodetect
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda3): mounted filesystem with ordered data mode
VFS: Mounted root (ext3 filesystem) readonly on device 8:3.
devtmpfs: mounted
debug: unmapping init [mem 0xc4b4c000-0xc4bc6fff]
Write protecting the kernel text: 8076k
Write protecting the kernel read-only data: 2976k
usb 5-1: new full-speed USB device number 2 using uhci_hcd
usb 5-1: New USB device found, idVendor=0a5c, idProduct=2110
usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 5-1: Product: BCM2045B
usb 5-1: Manufacturer: Broadcom Corp
usb 5-2: new full-speed USB device number 3 using uhci_hcd
usb 5-2: New USB device found, idVendor=0483, idProduct=2016
usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 5-2: Product: Biometric Coprocessor
usb 5-2: Manufacturer: STMicroelectronics
udev[1753]: starting version 164
random: nonblocking pool is initialized
usb 1-6.1: new low-speed USB device number 5 using ehci-pci
usb 1-6.1: New USB device found, idVendor=04f2, idProduct=0111
usb 1-6.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-6.1: Product: USB Keyboard
usb 1-6.1: Manufacturer: Chicony
input: Chicony USB Keyboard as /devices/pci0000:00/0000:00:1d.7/usb1/1-6/1-6.1/1-6.1:1.0/0003:04F2:0111.0001/input/input9
hid-generic 0003:04F2:0111.0001: input,hidraw0: USB HID v1.10 Keyboard [Chicony USB Keyboard] on usb-0000:00:1d.7-6.1/input0
input: Chicony USB Keyboard as /devices/pci0000:00/0000:00:1d.7/usb1/1-6/1-6.1/1-6.1:1.1/0003:04F2:0111.0002/input/input10
hid-generic 0003:04F2:0111.0002: input,hiddev0,hidraw1: USB HID v1.10 Device [Chicony USB Keyboard] on usb-0000:00:1d.7-6.1/input1
usb 1-6.2: new low-speed USB device number 6 using ehci-pci
usb 1-6.2: New USB device found, idVendor=046d, idProduct=c05a
usb 1-6.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-6.2: Product: USB Optical Mouse
usb 1-6.2: Manufacturer: Logitech
input: Logitech USB Optical Mouse as /devices/pci0000:00/0000:00:1d.7/usb1/1-6/1-6.2/1-6.2:1.0/0003:046D:C05A.0003/input/input11
hid-generic 0003:046D:C05A.0003: input,hidraw2: USB HID v1.11 Mouse [Logitech USB Optical Mouse] on usb-0000:00:1d.7-6.2/input0
pcmcia_socket pcmcia_socket0: cs: memory probe 0x0c0000-0x0fffff:
 excluding 0xc0000-0xd3fff 0xdc000-0xfffff
pcmcia_socket pcmcia_socket0: cs: memory probe 0xa0000000-0xa0ffffff:
 clean.
pcmcia_socket pcmcia_socket0: cs: memory probe 0x60000000-0x60ffffff:
 excluding 0x60000000-0x60ffffff
Adding 779148k swap on /dev/sda1.  Priority:-1 extents:1 across:779148k 
EXT3-fs (sda3): using internal journal
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda2): warning: maximal mount count reached, running e2fsck is recommended
EXT3-fs (sda2): using internal journal
EXT3-fs (sda2): mounted filesystem with ordered data mode
EXT3-fs (sda4): error: can't find ext3 filesystem on dev sda4.
input: ACPI Virtual Keyboard Device as /devices/virtual/input/input12
iwl3945 0000:03:00.0: loaded firmware version 15.32.2.9
sshd (3350): /proc/3350/oom_adj is deprecated, please use /proc/3350/oom_score_adj instead.
wlan0: authenticate with 00:33:13:01:31:45
wlan0: send auth to 00:33:13:01:31:45 (try 1/3)
wlan0: authenticated
wlan0: associate with 00:33:13:01:31:45 (try 1/3)
wlan0: RX AssocResp from 00:33:13:01:31:45 (capab=0x401 status=0 aid=2)
wlan0: associated
wlan0: deauthenticating from 00:33:13:01:31:45 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
perf samples too long (2514 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
wlan0: authenticate with 00:33:13:01:31:45
wlan0: send auth to 00:33:13:01:31:45 (try 1/3)
wlan0: authenticated
wlan0: associate with 00:33:13:01:31:45 (try 1/3)
wlan0: RX AssocResp from 00:33:13:01:31:45 (capab=0x1 status=0 aid=3)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP 00:33:13:01:31:45 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:33:13:01:31:45
wlan0: send auth to 00:33:13:01:31:45 (try 1/3)
wlan0: authenticated
wlan0: associate with 00:33:13:01:31:45 (try 1/3)
wlan0: RX AssocResp from 00:33:13:01:31:45 (capab=0x401 status=0 aid=2)
wlan0: associated
nf_conntrack: automatic helper assignment is deprecated and it will be removed soon. Use the iptables CT target to attach helpers instead.
ieee80211 phy0: wlan0: No probe response from AP 00:33:13:01:31:45 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:33:13:01:31:45
wlan0: send auth to 00:33:13:01:31:45 (try 1/3)
wlan0: authenticated
wlan0: associate with 00:33:13:01:31:45 (try 1/3)
wlan0: RX AssocResp from 00:33:13:01:31:45 (capab=0x401 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP 00:33:13:01:31:45 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:33:13:01:31:45
wlan0: send auth to 00:33:13:01:31:45 (try 1/3)
wlan0: authenticated
wlan0: associate with 00:33:13:01:31:45 (try 1/3)
wlan0: RX AssocResp from 00:33:13:01:31:45 (capab=0x401 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP 00:33:13:01:31:45 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:33:13:01:31:45
wlan0: send auth to 00:33:13:01:31:45 (try 1/3)
wlan0: authenticated
wlan0: associate with 00:33:13:01:31:45 (try 1/3)
wlan0: RX AssocResp from 00:33:13:01:31:45 (capab=0x401 status=0 aid=2)
wlan0: associated
ata5.00: disabled
ata5.00: detaching (SCSI 4:0:0:0)
acpi PNP0401:00: Cannot transition to non-D0 state from D3
ACPI: \_SB_.GDCK: undocking
usb 1-6: USB disconnect, device number 2
usb 1-6.1: USB disconnect, device number 5
usb 1-6.2: USB disconnect, device number 6
usb 5-1: USB disconnect, device number 2
wlan0: deauthenticating from 00:33:13:01:31:45 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
PM: Syncing filesystems ... done.
PM: Preparing system for mem sleep
Freezing user space processes ... (elapsed 0.006 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.007 seconds) done.
PM: Entering mem sleep
sd 0:0:0:0: [sda] Synchronizing SCSI cache
sd 0:0:0:0: [sda] Stopping disk
parport_pc 00:0a: disabled
serial 00:09: disabled
serial 00:09: System wakeup disabled by ACPI
PM: suspend of devices complete after 414.023 msecs
PM: suspend devices took 0.416 seconds
PM: late suspend of devices complete after 1.971 msecs
pcieport 0000:00:1c.0: System wakeup enabled by ACPI
ehci-pci 0000:00:1d.7: System wakeup enabled by ACPI
uhci_hcd 0000:00:1d.2: System wakeup enabled by ACPI
uhci_hcd 0000:00:1d.1: System wakeup enabled by ACPI
uhci_hcd 0000:00:1d.0: System wakeup enabled by ACPI
PM: noirq suspend of devices complete after 51.815 msecs
ACPI: Preparing to enter system sleep state S3
PM: Saving platform NVS memory
Disabling non-boot CPUs ...
smpboot: CPU 1 is now offline
ACPI: Low-level resume complete
PM: Restoring platform NVS memory
Enabling non-boot CPUs ...
x86: Booting SMP configuration:
smpboot: Booting Node 0 Processor 1 APIC 0x1
Initializing CPU#1
Disabled fast string operations
CPU1 is up
ACPI: Waking up from system sleep state S3
uhci_hcd 0000:00:1d.0: System wakeup disabled by ACPI
uhci_hcd 0000:00:1d.1: System wakeup disabled by ACPI
uhci_hcd 0000:00:1d.2: System wakeup disabled by ACPI
ehci-pci 0000:00:1d.7: System wakeup disabled by ACPI
PM: noirq resume of devices complete after 110.143 msecs
PM: early resume of devices complete after 1.407 msecs
usb usb2: root hub lost power or was reset
usb usb3: root hub lost power or was reset
usb usb4: root hub lost power or was reset
usb usb5: root hub lost power or was reset
pcieport 0000:00:1c.0: System wakeup disabled by ACPI
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
ata6: port disabled--ignoring
serial 00:09: activated
parport_pc 00:0a: activated
usb 5-2: reset full-speed USB device number 3 using uhci_hcd
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: configured for UDMA/133
sd 0:0:0:0: [sda] Starting disk
thinkpad_acpi: ACPI backlight control delay disabled
PM: resume of devices complete after 2938.098 msecs
PM: resume devices took 2.940 seconds
PM: Finishing wakeup.
Restarting tasks ... done.
video LNXVIDEO:00: Restoring backlight state
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
usb 5-1: new full-speed USB device number 4 using uhci_hcd
usb 5-1: New USB device found, idVendor=0a5c, idProduct=2110
usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 5-1: Product: BCM2045B
usb 5-1: Manufacturer: Broadcom Corp
wlan0: authenticate with 00:33:13:01:31:45
wlan0: send auth to 00:33:13:01:31:45 (try 1/3)
wlan0: authenticated
wlan0: associate with 00:33:13:01:31:45 (try 1/3)
wlan0: RX AssocResp from 00:33:13:01:31:45 (capab=0x401 status=0 aid=2)
wlan0: associated
ACPI: \_SB_.GDCK: docking
usb 1-6: new high-speed USB device number 8 using ehci-pci
usb 1-6: New USB device found, idVendor=17ef, idProduct=1000
usb 1-6: New USB device strings: Mfr=0, Product=0, SerialNumber=0
hub 1-6:1.0: USB hub found
hub 1-6:1.0: 4 ports detected
usb 1-6.1: new low-speed USB device number 9 using ehci-pci
usb 1-6.1: New USB device found, idVendor=04f2, idProduct=0111
usb 1-6.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-6.1: Product: USB Keyboard
usb 1-6.1: Manufacturer: Chicony
input: Chicony USB Keyboard as /devices/pci0000:00/0000:00:1d.7/usb1/1-6/1-6.1/1-6.1:1.0/0003:04F2:0111.0004/input/input13
hid-generic 0003:04F2:0111.0004: input,hidraw0: USB HID v1.10 Keyboard [Chicony USB Keyboard] on usb-0000:00:1d.7-6.1/input0
input: Chicony USB Keyboard as /devices/pci0000:00/0000:00:1d.7/usb1/1-6/1-6.1/1-6.1:1.1/0003:04F2:0111.0005/input/input14
hid-generic 0003:04F2:0111.0005: input,hiddev0,hidraw1: USB HID v1.10 Device [Chicony USB Keyboard] on usb-0000:00:1d.7-6.1/input1
usb 1-6.2: new low-speed USB device number 10 using ehci-pci
usb 1-6.2: New USB device found, idVendor=046d, idProduct=c05a
usb 1-6.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-6.2: Product: USB Optical Mouse
usb 1-6.2: Manufacturer: Logitech
input: Logitech USB Optical Mouse as /devices/pci0000:00/0000:00:1d.7/usb1/1-6/1-6.2/1-6.2:1.0/0003:046D:C05A.0006/input/input15
hid-generic 0003:046D:C05A.0006: input,hidraw2: USB HID v1.11 Mouse [Logitech USB Optical Mouse] on usb-0000:00:1d.7-6.2/input0
ata5: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0xe frozen
ata5: ACPI event
ata5: soft resetting link
ata5.00: ATAPI: UJDA765 DVD/CDRW, 1.70, max UDMA/33
ata5.00: configured for UDMA/33
ata5: EH complete
scsi 4:0:0:0: CD-ROM            MATSHITA UJDA765 DVD/CDRW 1.70 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
sr 4:0:0:0: Attached scsi CD-ROM sr0
sr 4:0:0:0: Attached scsi generic sg1 type 5
usb 1-5: new high-speed USB device number 11 using ehci-pci
usb 1-5: New USB device found, idVendor=0421, idProduct=01c7
usb 1-5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-5: Product: N900 (Storage Mode)
usb 1-5: Manufacturer: Nokia
usb 1-5: SerialNumber: 372041756775
usb-storage 1-5:1.0: USB Mass Storage device detected
scsi6 : usb-storage 1-5:1.0
scsi 6:0:0:0: Direct-Access     Nokia    N900              031 PQ: 0 ANSI: 2
sd 6:0:0:0: Attached scsi generic sg2 type 0
sd 6:0:0:0: [sdb] Attached SCSI removable disk
scsi 6:0:0:1: Direct-Access     Nokia    N900              031 PQ: 0 ANSI: 2
sd 6:0:0:1: Attached scsi generic sg3 type 0
sd 6:0:0:1: [sdc] Attached SCSI removable disk
usb 1-5: USB disconnect, device number 11
ieee80211 phy0: wlan0: No probe response from AP 00:33:13:01:31:45 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:33:13:01:31:45
wlan0: send auth to 00:33:13:01:31:45 (try 1/3)
wlan0: authenticated
wlan0: associate with 00:33:13:01:31:45 (try 1/3)
wlan0: RX AssocResp from 00:33:13:01:31:45 (capab=0x401 status=0 aid=2)
wlan0: associated
usb 1-5: new high-speed USB device number 12 using ehci-pci
usb 1-5: New USB device found, idVendor=0421, idProduct=01c7
usb 1-5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-5: Product: N900 (Storage Mode)
usb 1-5: Manufacturer: Nokia
usb 1-5: SerialNumber: 372041756775
usb-storage 1-5:1.0: USB Mass Storage device detected
scsi7 : usb-storage 1-5:1.0
scsi 7:0:0:0: Direct-Access     Nokia    N900              031 PQ: 0 ANSI: 2
sd 7:0:0:0: Attached scsi generic sg2 type 0
sd 7:0:0:0: [sdb] Attached SCSI removable disk
scsi 7:0:0:1: Direct-Access     Nokia    N900              031 PQ: 0 ANSI: 2
sd 7:0:0:1: Attached scsi generic sg3 type 0
sd 7:0:0:1: [sdc] Attached SCSI removable disk
usb 1-5: USB disconnect, device number 12
usb 1-6.4: new high-speed USB device number 13 using ehci-pci
usb 1-6.4: New USB device found, idVendor=0421, idProduct=01c7
usb 1-6.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-6.4: Product: N900 (Storage Mode)
usb 1-6.4: Manufacturer: Nokia
usb 1-6.4: SerialNumber: 372041756775
usb-storage 1-6.4:1.0: USB Mass Storage device detected
scsi8 : usb-storage 1-6.4:1.0
scsi 8:0:0:0: Direct-Access     Nokia    N900              031 PQ: 0 ANSI: 2
sd 8:0:0:0: Attached scsi generic sg2 type 0
sd 8:0:0:0: [sdb] Attached SCSI removable disk
scsi 8:0:0:1: Direct-Access     Nokia    N900              031 PQ: 0 ANSI: 2
sd 8:0:0:1: Attached scsi generic sg3 type 0
sd 8:0:0:1: [sdc] Attached SCSI removable disk
usb 1-6.3: new full-speed USB device number 14 using ehci-pci
usb 1-6.3: New USB device found, idVendor=054c, idProduct=042f
usb 1-6.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-6.3: Product: Navigation Controller
usb 1-6.3: Manufacturer: Sony
sony 0003:054C:042F.0007: Fixing up Sony Sixaxis report descriptor
input: Sony Navigation Controller as /devices/pci0000:00/0000:00:1d.7/usb1/1-6/1-6.3/1-6.3:1.0/0003:054C:042F.0007/input/input16
sony 0003:054C:042F.0007: input,hiddev0,hidraw3: USB HID v1.11 Joystick [Sony Navigation Controller] on usb-0000:00:1d.7-6.3/input0
usb 1-6.4: USB disconnect, device number 13
usb 1-6.4: new high-speed USB device number 15 using ehci-pci
usb 1-6.4: New USB device found, idVendor=0421, idProduct=0105
usb 1-6.4: New USB device strings: Mfr=1, Product=2, SerialNumber=5
usb 1-6.4: Product: Nokia N900 (Update mode)
usb 1-6.4: Manufacturer: Nokia
usb 1-6.4: SerialNumber: 4D554D363434323537
usb 1-6.4: USB disconnect, device number 15
usb 1-6.4: new high-speed USB device number 16 using ehci-pci
usb 1-6.4: New USB device found, idVendor=0421, idProduct=01c7
usb 1-6.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-6.4: Product: N900 (Storage Mode)
usb 1-6.4: Manufacturer: Nokia
usb 1-6.4: SerialNumber: 372041756775
usb-storage 1-6.4:1.0: USB Mass Storage device detected
scsi9 : usb-storage 1-6.4:1.0
scsi 9:0:0:0: Direct-Access     Nokia    N900              031 PQ: 0 ANSI: 2
sd 9:0:0:0: Attached scsi generic sg2 type 0
sd 9:0:0:0: [sdb] Attached SCSI removable disk
scsi 9:0:0:1: Direct-Access     Nokia    N900              031 PQ: 0 ANSI: 2
sd 9:0:0:1: Attached scsi generic sg3 type 0
sd 9:0:0:1: [sdc] Attached SCSI removable disk
usb 5-1: USB disconnect, device number 4
wlan0: deauthenticating from 00:33:13:01:31:45 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
PM: Syncing filesystems ... done.
PM: Preparing system for mem sleep
Freezing user space processes ... (elapsed 0.132 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.007 seconds) done.
PM: Entering mem sleep
sd 0:0:0:0: [sda] Synchronizing SCSI cache
sd 0:0:0:0: [sda] Stopping disk
parport_pc 00:0a: disabled
serial 00:09: disabled
serial 00:09: System wakeup disabled by ACPI
PM: suspend of devices complete after 405.897 msecs
PM: suspend devices took 0.408 seconds
PM: late suspend of devices complete after 2.063 msecs
pcieport 0000:00:1c.0: System wakeup enabled by ACPI
ehci-pci 0000:00:1d.7: System wakeup enabled by ACPI
uhci_hcd 0000:00:1d.2: System wakeup enabled by ACPI
uhci_hcd 0000:00:1d.1: System wakeup enabled by ACPI
uhci_hcd 0000:00:1d.0: System wakeup enabled by ACPI
PM: noirq suspend of devices complete after 51.800 msecs
ACPI: Preparing to enter system sleep state S3
PM: Saving platform NVS memory
Disabling non-boot CPUs ...
smpboot: CPU 1 is now offline
ACPI: Low-level resume complete
PM: Restoring platform NVS memory
Enabling non-boot CPUs ...
x86: Booting SMP configuration:
smpboot: Booting Node 0 Processor 1 APIC 0x1
Initializing CPU#1
Disabled fast string operations
CPU1 is up
ACPI: Waking up from system sleep state S3
uhci_hcd 0000:00:1d.0: System wakeup disabled by ACPI
uhci_hcd 0000:00:1d.1: System wakeup disabled by ACPI
uhci_hcd 0000:00:1d.2: System wakeup disabled by ACPI
ehci-pci 0000:00:1d.7: System wakeup disabled by ACPI
PM: noirq resume of devices complete after 109.836 msecs
PM: early resume of devices complete after 1.516 msecs
usb usb2: root hub lost power or was reset
usb usb3: root hub lost power or was reset
usb usb4: root hub lost power or was reset
usb usb5: root hub lost power or was reset
pcieport 0000:00:1c.0: System wakeup disabled by ACPI
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
ata6: port disabled--ignoring
serial 00:09: activated
parport_pc 00:0a: activated
usb 5-2: reset full-speed USB device number 3 using uhci_hcd
ata5.00: ACPI cmd ef/03:42:00:00:00:a0 (SET FEATURES) filtered out
ata5.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
ata5.00: ACPI cmd e3/00:79:00:00:00:a0 (IDLE) succeeded
ata5.00: ACPI cmd e3/00:01:00:00:00:a0 (IDLE) succeeded
ata5.00: configured for UDMA/33
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: configured for UDMA/133
sd 0:0:0:0: [sda] Starting disk
thinkpad_acpi: ACPI backlight control delay disabled
PM: resume of devices complete after 2936.692 msecs
PM: resume devices took 2.940 seconds
PM: Finishing wakeup.
Restarting tasks ... done.
video LNXVIDEO:00: Restoring backlight state
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
usb 5-1: new full-speed USB device number 5 using uhci_hcd
usb 5-1: New USB device found, idVendor=0a5c, idProduct=2110
usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 5-1: Product: BCM2045B
usb 5-1: Manufacturer: Broadcom Corp
wlan0: authenticate with 00:33:13:01:31:45
wlan0: send auth to 00:33:13:01:31:45 (try 1/3)
wlan0: authenticated
wlan0: associate with 00:33:13:01:31:45 (try 1/3)
wlan0: RX AssocResp from 00:33:13:01:31:45 (capab=0x401 status=0 aid=2)
wlan0: associated
ata5.00: disabled
acpi PNP0401:00: Cannot transition to non-D0 state from D3
ACPI: \_SB_.GDCK: undocking
ata5.00: detaching (SCSI 4:0:0:0)
usb 1-6: USB disconnect, device number 8
usb 1-6.1: USB disconnect, device number 9
usb 1-6.2: USB disconnect, device number 10
usb 1-6.3: USB disconnect, device number 14
usb 1-6.4: USB disconnect, device number 16
wlan0: deauthenticating from 00:33:13:01:31:45 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
ACPI: \_SB_.PCI0: ACPI_NOTIFY_BUS_CHECK event
wlan0: authenticate with 00:33:13:01:31:45
wlan0: send auth to 00:33:13:01:31:45 (try 1/3)
wlan0: authenticated
wlan0: associate with 00:33:13:01:31:45 (try 1/3)
wlan0: RX AssocResp from 00:33:13:01:31:45 (capab=0x401 status=0 aid=2)
wlan0: associated
wlan0: deauthenticating from 00:33:13:01:31:45 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:33:13:01:31:45
wlan0: send auth to 00:33:13:01:31:45 (try 1/3)
wlan0: authenticated
wlan0: associate with 00:33:13:01:31:45 (try 1/3)
wlan0: RX AssocResp from 00:33:13:01:31:45 (capab=0x401 status=0 aid=1)
wlan0: associated
ACPI: \_SB_.GDCK: docking
usb 1-6: new high-speed USB device number 18 using ehci-pci
usb 1-6: New USB device found, idVendor=17ef, idProduct=1000
usb 1-6: New USB device strings: Mfr=0, Product=0, SerialNumber=0
hub 1-6:1.0: USB hub found
hub 1-6:1.0: 4 ports detected
usb 1-6.1: new low-speed USB device number 19 using ehci-pci
usb 1-6.1: New USB device found, idVendor=04f2, idProduct=0111
usb 1-6.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-6.1: Product: USB Keyboard
usb 1-6.1: Manufacturer: Chicony
input: Chicony USB Keyboard as /devices/pci0000:00/0000:00:1d.7/usb1/1-6/1-6.1/1-6.1:1.0/0003:04F2:0111.0008/input/input17
hid-generic 0003:04F2:0111.0008: input,hidraw0: USB HID v1.10 Keyboard [Chicony USB Keyboard] on usb-0000:00:1d.7-6.1/input0
input: Chicony USB Keyboard as /devices/pci0000:00/0000:00:1d.7/usb1/1-6/1-6.1/1-6.1:1.1/0003:04F2:0111.0009/input/input18
hid-generic 0003:04F2:0111.0009: input,hiddev0,hidraw1: USB HID v1.10 Device [Chicony USB Keyboard] on usb-0000:00:1d.7-6.1/input1
usb 1-6.2: new low-speed USB device number 20 using ehci-pci
usb 1-6.2: New USB device found, idVendor=046d, idProduct=c05a
usb 1-6.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-6.2: Product: USB Optical Mouse
usb 1-6.2: Manufacturer: Logitech
input: Logitech USB Optical Mouse as /devices/pci0000:00/0000:00:1d.7/usb1/1-6/1-6.2/1-6.2:1.0/0003:046D:C05A.000A/input/input19
hid-generic 0003:046D:C05A.000A: input,hidraw2: USB HID v1.11 Mouse [Logitech USB Optical Mouse] on usb-0000:00:1d.7-6.2/input0
ata5: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0xe frozen
ata5: ACPI event
ata5: soft resetting link
usb 1-6.3: new full-speed USB device number 21 using ehci-pci
ata5.00: ATAPI: UJDA765 DVD/CDRW, 1.70, max UDMA/33
ata5.00: configured for UDMA/33
ata5: EH complete
scsi 4:0:0:0: CD-ROM            MATSHITA UJDA765 DVD/CDRW 1.70 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
sr 4:0:0:0: Attached scsi CD-ROM sr0
sr 4:0:0:0: Attached scsi generic sg1 type 5
usb 1-6.3: New USB device found, idVendor=054c, idProduct=042f
usb 1-6.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-6.3: Product: Navigation Controller
usb 1-6.3: Manufacturer: Sony
sony 0003:054C:042F.000B: Fixing up Sony Sixaxis report descriptor
input: Sony Navigation Controller as /devices/pci0000:00/0000:00:1d.7/usb1/1-6/1-6.3/1-6.3:1.0/0003:054C:042F.000B/input/input20
sony 0003:054C:042F.000B: input,hiddev0,hidraw3: USB HID v1.11 Joystick [Sony Navigation Controller] on usb-0000:00:1d.7-6.3/input0
usb 1-6.4: new high-speed USB device number 22 using ehci-pci
usb 1-6.4: New USB device found, idVendor=0421, idProduct=01c7
usb 1-6.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-6.4: Product: N900 (Storage Mode)
usb 1-6.4: Manufacturer: Nokia
usb 1-6.4: SerialNumber: 372041756775
usb-storage 1-6.4:1.0: USB Mass Storage device detected
scsi10 : usb-storage 1-6.4:1.0
scsi 10:0:0:0: Direct-Access     Nokia    N900              031 PQ: 0 ANSI: 2
sd 10:0:0:0: Attached scsi generic sg2 type 0
scsi 10:0:0:1: Direct-Access     Nokia    N900              031 PQ: 0 ANSI: 2
sd 10:0:0:1: Attached scsi generic sg3 type 0
sd 10:0:0:0: [sdb] Attached SCSI removable disk
sd 10:0:0:1: [sdc] Attached SCSI removable disk
usb 1-6.3: USB disconnect, device number 21
usb 1-6.3: new full-speed USB device number 23 using ehci-pci
usb 1-6.3: New USB device found, idVendor=054c, idProduct=03d5
usb 1-6.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-6.3: Product: Motion Controller
usb 1-6.3: Manufacturer: Sony Computer Entertainment
input: Sony Computer Entertainment Motion Controller as /devices/pci0000:00/0000:00:1d.7/usb1/1-6/1-6.3/1-6.3:1.0/0003:054C:03D5.000C/input/input21
hid-generic 0003:054C:03D5.000C: input,hiddev0,hidraw3: USB HID v1.10 Gamepad [Sony Computer Entertainment Motion Controller] on usb-0000:00:1d.7-6.3/input0
usb 1-6.3: USB disconnect, device number 23
usb 1-6.3: new full-speed USB device number 24 using ehci-pci
usb 1-6.3: New USB device found, idVendor=054c, idProduct=03d5
usb 1-6.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-6.3: Product: Motion Controller
usb 1-6.3: Manufacturer: Sony Computer Entertainment
input: Sony Computer Entertainment Motion Controller as /devices/pci0000:00/0000:00:1d.7/usb1/1-6/1-6.3/1-6.3:1.0/0003:054C:03D5.000D/input/input22
hid-generic 0003:054C:03D5.000D: input,hiddev0,hidraw3: USB HID v1.10 Gamepad [Sony Computer Entertainment Motion Controller] on usb-0000:00:1d.7-6.3/input0
usb 1-6.3: USB disconnect, device number 24
usb 1-6.4: USB disconnect, device number 22
usb 1-6.4: new high-speed USB device number 25 using ehci-pci
usb 1-6.4: New USB device found, idVendor=0421, idProduct=01c7
usb 1-6.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-6.4: Product: N900 (Storage Mode)
usb 1-6.4: Manufacturer: Nokia
usb 1-6.4: SerialNumber: 372041756775
usb-storage 1-6.4:1.0: USB Mass Storage device detected
scsi11 : usb-storage 1-6.4:1.0
scsi 11:0:0:0: Direct-Access     Nokia    N900              031 PQ: 0 ANSI: 2
sd 11:0:0:0: Attached scsi generic sg2 type 0
scsi 11:0:0:1: Direct-Access     Nokia    N900              031 PQ: 0 ANSI: 2
sd 11:0:0:0: [sdb] Attached SCSI removable disk
sd 11:0:0:1: Attached scsi generic sg3 type 0
sd 11:0:0:1: [sdc] Attached SCSI removable disk
[sched_delayed] sched: RT throttling activated
BUG: soft lockup - CPU#0 stuck for 22s! [kswapd0:745]
Modules linked in:
CPU: 0 PID: 745 Comm: kswapd0 Tainted: G        W    3.14.0-rc6+ #330
Hardware name: LENOVO 17097HU/17097HU, BIOS 7BETD8WW (2.19 ) 03/31/2011
task: f5f785a0 ti: f5c1a000 task.ti: f509c000
EIP: 0060:[<c4075b93>] EFLAGS: 00000246 CPU: 0
EIP is at lock_release+0xa3/0x1e0
EAX: f5f785a0 EBX: f5f785a0 ECX: 00000000 EDX: 00000000
ESI: 000882a7 EDI: 00000000 EBP: f509ddd8 ESP: f509ddb4
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
CR0: 8005003b CR2: b38ab000 CR3: 04bd2000 CR4: 00000710
Stack:
 c40d188b 00000000 f5c205c0 0000013a 00000001 00000246 f5c205c0 00000000
 f509df08 f509dde4 c47e0906 f5c205c0 f509ddf4 c40d1899 f5d17800 0000013a
 f509de0c c40ef33a 00000000 00000000 00000020 f5d17ba4 f509de4c c40c519e
Call Trace:
 [<c40d188b>] ? list_lru_count_node+0x1b/0x60
 [<c47e0906>] _raw_spin_unlock+0x16/0x20
 [<c40d1899>] list_lru_count_node+0x29/0x60
 [<c40ef33a>] super_cache_count+0x5a/0xc0
 [<c40c519e>] shrink_slab_node+0x2e/0x1d0
 [<c40c536a>] ? shrink_slab+0x2a/0xf0
 [<c40c5411>] shrink_slab+0xd1/0xf0
 [<c40c5912>] kswapd+0x4e2/0x930
 [<c40534d4>] kthread+0xb4/0xd0
 [<c40c5430>] ? shrink_slab+0xf0/0xf0
 [<c4050000>] ? alloc_pid+0x2e0/0x380
 [<c47e13b7>] ret_from_kernel_thread+0x1b/0x28
 [<c4053420>] ? __init_kthread_worker+0x60/0x60
Code: 00 89 f1 89 fa 89 d8 e8 4c fc ff ff 85 c0 74 07 89 d8 e8 d1 dc ff ff 64 a1 2c 07 bc c4 c7 80 08 05 00 00 00 00 00 00 ff 75 f0 9d <8b> 5d f4 8b 75 f8 8b 7d fc 89 ec 5d c3 9c 58 f6 c4 02 74 92 e8
INFO: task kjournald:2237 blocked for more than 120 seconds.
      Tainted: G        W    3.14.0-rc6+ #330
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kjournald       D f5f5e5a0     0  2237      2 0x00000000
 f119de28 00000046 00000000 f5f5e5a0 f5f5e5d0 00000000 00000000 7397771c
 00009c09 f119c008 c4bbf000 7397771c 00009c09 f5f5e5a0 00000000 f5f5eaac
 00000298 00000000 00000000 00000000 00000000 f5f5e5a0 00000000 00000000
Call Trace:
 [<c47dd0ce>] schedule+0x1e/0x60
 [<c41a6781>] journal_commit_transaction+0x141/0x10d0
 [<c406d4d0>] ? bit_waitqueue+0x50/0x50
 [<c4041e92>] ? try_to_del_timer_sync+0x52/0x70
 [<c4041f39>] ? del_timer_sync+0x89/0xa0
 [<c41aa270>] kjournald+0xd0/0x240
 [<c406d4d0>] ? bit_waitqueue+0x50/0x50
 [<c40534d4>] kthread+0xb4/0xd0
 [<c41aa1a0>] ? commit_timeout+0x10/0x10
 [<c4050000>] ? alloc_pid+0x2e0/0x380
 [<c47e13b7>] ret_from_kernel_thread+0x1b/0x28
 [<c4053420>] ? __init_kthread_worker+0x60/0x60
no locks held by kjournald/2237.
INFO: task Chrome_DBThread:11478 blocked for more than 120 seconds.
      Tainted: G        W    3.14.0-rc6+ #330
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Chrome_DBThread D c4074e6e     0 11478      1 0x00000000
 f27e1cb8 00000046 f27e1c70 c4074e6e effb0fb0 00000000 00000001 2071de58
 00009c08 f27e0008 c4bbf000 20733c97 00009c08 d54165a0 00000373 00584371
 00000000 086e2373 0000000b d54165a0 086e2373 0000000b f27e1cac 00000046
Call Trace:
 [<c4074e6e>] ? __lock_acquire+0x3ae/0xc80
 [<c406d81e>] ? prepare_to_wait_exclusive+0x1e/0x70
 [<c47dd0ce>] schedule+0x1e/0x60
 [<c47dd15a>] io_schedule+0x4a/0x70
 [<c4116368>] sleep_on_buffer+0x8/0x10
 [<c47dd398>] __wait_on_bit_lock+0x48/0x90
 [<c4116360>] ? unmap_underlying_metadata+0x40/0x40
 [<c4116360>] ? unmap_underlying_metadata+0x40/0x40
 [<c47dd486>] out_of_line_wait_on_bit_lock+0xa6/0xc0
 [<c406d570>] ? wake_atomic_t_function+0x50/0x50
 [<c411750e>] __lock_buffer+0x2e/0x30
 [<c41a5b31>] do_get_write_access+0x381/0x410
 [<c414d931>] ? __ext3_get_inode_loc+0xb1/0x2e0
 [<c41a5be3>] journal_get_write_access+0x23/0x40
 [<c415b46f>] __ext3_journal_get_write_access+0x1f/0x50
 [<c414dbe1>] ext3_reserve_inode_write+0x61/0x80
 [<c414dc1d>] ext3_mark_inode_dirty+0x1d/0x40
 [<c414dd56>] ext3_dirty_inode+0x46/0x80
 [<c410f7a9>] __mark_inode_dirty+0x29/0x1d0
 [<c4103041>] update_time+0x71/0xb0
 [<c41030f3>] file_update_time+0x73/0xb0
 [<c40b75d1>] __generic_file_aio_write+0x141/0x550
 [<c40b7a32>] generic_file_aio_write+0x52/0xf0
 [<c40ec0b4>] do_sync_write+0x64/0xa0
 [<c40ecf6e>] vfs_write+0x9e/0x190
 [<c40ec050>] ? do_sync_readv_writev+0x90/0x90
 [<c40ed151>] SyS_write+0x51/0x90
 [<c47e143f>] sysenter_do_call+0x12/0x31
 [<c47e0000>] ? down_read_failed+0x40/0x160
3 locks held by Chrome_DBThread/11478:
 #0:  (sb_writers#3){......}, at: [<c40ed04a>] vfs_write+0x17a/0x190
 #1:  (&sb->s_type->i_mutex_key#10){......}, at: [<c40b7a20>] generic_file_aio_write+0x40/0xf0
 #2:  (jbd_handle){......}, at: [<c41a61d8>] start_this_handle+0x2a8/0x380
INFO: task Chrome_CacheThr:11483 blocked for more than 120 seconds.
      Tainted: G        W    3.14.0-rc6+ #330
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Chrome_CacheThr D cd8415a0     0 11483      1 0x00000000
 eed49d68 00000046 00000000 cd8415a0 cd8415e8 00000000 00000003 985da8c6
 00009c11 eed48008 c4bbf000 985f00d1 00009c11 cd8415a0 00000002 cd841ac4
 00000371 000002c2 00000000 00584371 00000000 cd8415a0 00584371 00000000
Call Trace:
 [<c47dd0ce>] schedule+0x1e/0x60
 [<c41a60fa>] start_this_handle+0x1ca/0x380
 [<c40e6a7c>] ? cache_alloc_debugcheck_after+0x11c/0x1e0
 [<c406d4d0>] ? bit_waitqueue+0x50/0x50
 [<c41a643d>] journal_start+0x9d/0xd0
 [<c4156d59>] ext3_journal_start_sb+0x29/0x50
 [<c414dd3a>] ext3_dirty_inode+0x2a/0x80
 [<c410f7a9>] __mark_inode_dirty+0x29/0x1d0
 [<c4103041>] update_time+0x71/0xb0
 [<c41030f3>] file_update_time+0x73/0xb0
 [<c40b75d1>] __generic_file_aio_write+0x141/0x550
 [<c40b7a32>] generic_file_aio_write+0x52/0xf0
 [<c40ec0b4>] do_sync_write+0x64/0xa0
 [<c40ecf6e>] vfs_write+0x9e/0x190
 [<c40ec050>] ? do_sync_readv_writev+0x90/0x90
 [<c40ed0ea>] SyS_pwrite64+0x8a/0xa0
 [<c47e143f>] sysenter_do_call+0x12/0x31
 [<c47e0000>] ? down_read_failed+0x40/0x160
2 locks held by Chrome_CacheThr/11483:
 #0:  (sb_writers#3){......}, at: [<c40ed04a>] vfs_write+0x17a/0x190
 #1:  (&sb->s_type->i_mutex_key#10){......}, at: [<c40b7a20>] generic_file_aio_write+0x40/0xf0
INFO: task mpd:2653 blocked for more than 120 seconds.
      Tainted: G        W    3.14.0-rc6+ #330
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
mpd             D c4074e6e     0  2653      1 0x00000000
 eeee3c14 00000046 eeee3bcc c4074e6e c49d4998 00000000 c49d4976 522eb4b1
 00009c24 eeee2008 c4bbf000 523065d0 00009c24 f5f065a0 00000378 086e2373
 0000000b c46e6378 0001610d f5f065a0 c46e6378 0001610d eeee3c08 00000046
Call Trace:
 [<c4074e6e>] ? __lock_acquire+0x3ae/0xc80
 [<c46e6378>] ? udp4_lib_lookup2+0x1e8/0x240
 [<c46e6378>] ? udp4_lib_lookup2+0x1e8/0x240
 [<c406d81e>] ? prepare_to_wait_exclusive+0x1e/0x70
 [<c47dd0ce>] schedule+0x1e/0x60
 [<c47dd15a>] io_schedule+0x4a/0x70
 [<c4116368>] sleep_on_buffer+0x8/0x10
 [<c47dd398>] __wait_on_bit_lock+0x48/0x90
 [<c4530372>] ? thermal_remove_hwmon_sysfs+0x12/0x170
 [<c4116360>] ? unmap_underlying_metadata+0x40/0x40
 [<c4116360>] ? unmap_underlying_metadata+0x40/0x40
 [<c47dd486>] out_of_line_wait_on_bit_lock+0xa6/0xc0
 [<c406d570>] ? wake_atomic_t_function+0x50/0x50
 [<c411750e>] __lock_buffer+0x2e/0x30
 [<c41a5b31>] do_get_write_access+0x381/0x410
 [<c414d931>] ? __ext3_get_inode_loc+0xb1/0x2e0
 [<c41a5be3>] journal_get_write_access+0x23/0x40
 [<c415b46f>] __ext3_journal_get_write_access+0x1f/0x50
 [<c414dbe1>] ext3_reserve_inode_write+0x61/0x80
 [<c41547a5>] ext3_orphan_add+0xc5/0x180
 [<c4150970>] ext3_setattr+0x200/0x300
 [<c403b4cb>] ? current_fs_time+0xb/0x20
 [<c4104cb5>] notify_change+0x135/0x300
 [<c40eb967>] ? do_truncate+0x57/0xa0
 [<c40eb973>] do_truncate+0x63/0xa0
 [<c40eadc5>] ? do_dentry_open+0x215/0x270
 [<c40f900b>] do_last+0x4cb/0xb30
 [<c40f6371>] ? inode_permission+0x11/0x50
 [<c40f6aed>] ? link_path_walk+0x1ed/0x730
 [<c40f971b>] path_openat+0xab/0x540
 [<c40311d1>] ? kernel_map_pages+0x71/0xf0
 [<c40f9cb3>] do_filp_open+0x33/0x80
 [<c40ea8e1>] do_sys_open+0x121/0x220
 [<c408e838>] ? getnstimeofday+0x8/0x20
 [<c40eaa1d>] SyS_open+0x1d/0x20
 [<c47e143f>] sysenter_do_call+0x12/0x31
4 locks held by mpd/2653:
 #0:  (sb_writers#3){......}, at: [<c410a791>] mnt_want_write+0x21/0x50
 #1:  (&sb->s_type->i_mutex_key#10){......}, at: [<c40eb967>] do_truncate+0x57/0xa0
 #2:  (jbd_handle){......}, at: [<c41a61d8>] start_this_handle+0x2a8/0x380
 #3:  (&sbi->s_orphan_lock){......}, at: [<c4154709>] ext3_orphan_add+0x29/0x180
ata5.00: disabled
ata5.00: detaching (SCSI 4:0:0:0)
acpi PNP0401:00: Cannot transition to non-D0 state from D3
ACPI: \_SB_.GDCK: undocking
usb 1-6: USB disconnect, device number 18
usb 1-6.1: USB disconnect, device number 19
usb 1-6.2: USB disconnect, device number 20
usb 1-6.4: USB disconnect, device number 25
ACPI: \_SB_.PCI0: ACPI_NOTIFY_BUS_CHECK event

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
