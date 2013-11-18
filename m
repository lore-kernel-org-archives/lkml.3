Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374Ab3KRJXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 04:23:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836Ab3KRJXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 04:23:07 -0500
Message-ID: <5289DC61.7030106@redhat.com>
Date: Mon, 18 Nov 2013 10:22:41 +0100
From: Zdenek Kabelac <zkabelac@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: robert.moore@intel.com, rafael.j.wysocki@intel.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: FADT errors reported by Lenovo T61
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello


I've noticed strange errors in the log - while my wifi seems to work ok,
the surrounding errors do not seem normal.

Is there anything I could do to fix them ?
Or it will remain broken or there could workaround ?

I'm attaching my boot log - with:

"ACPI BIOS Warning (bug): 32/64X length mismatch in FADT/Gpe1Block: 0/32 
(20130725/tbfadt-572)"

which probably leads to -

"ACPI FADT declares the system doesn't support PCIe ASPM, so disable it"

and

"acpi PNP0A08:00: Disabling ASPM (FADT indicates it is unsupported)"

and at the end after my networking is started I get this:

iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 
in-tree:ds
iwl3945: Copyright(c) 2003-2011 Intel Corporation
iwl3945 0000:03:00.0: can't disable ASPM; OS doesn't have ASPM control


thanks

Zdenek



Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Initializing cgroup subsys cpuacct
Linux version 3.12.0-00053-g6ed31ed (kabi@linux) (gcc version 4.8.2 20131017 
(Red Hat 4.8.2-1) (GCC) ) #166 SMP PREEMPT Tue Nov 5 13:10:45 CET 2013
Command line: BOOT_IMAGE=/vmlinuz-3.12.0-00053-g6ed31ed root=/dev/sda2 ro 
selinux=0 kmemleak=off lockdep.prove_locking=0 lockdep.lock_stat=0 
ipv6.disable=1 systemd.log_level=info systemd.log_target=kmsg quiet 
console=ttyS0,115200 console=tty LANG=cs_CZ.UTF-8
e820: BIOS-provided physical RAM map:
BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
BIOS-e820: [mem 0x0000000000100000-0x00000000bf6affff] usable
BIOS-e820: [mem 0x00000000bf6b0000-0x00000000bf6cbfff] ACPI data
BIOS-e820: [mem 0x00000000bf6cc000-0x00000000bf6fffff] ACPI NVS
BIOS-e820: [mem 0x00000000bf700000-0x00000000bfffffff] reserved
BIOS-e820: [mem 0x00000000f0000000-0x00000000f3ffffff] reserved
BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
BIOS-e820: [mem 0x00000000fed00000-0x00000000fed003ff] reserved
BIOS-e820: [mem 0x00000000fed14000-0x00000000fed19fff] reserved
BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed8ffff] reserved
BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
BIOS-e820: [mem 0x0000000100000000-0x000000013bffffff] usable
kmemleak: Kernel memory leak detector disabled
NX (Execute Disable) protection: active
SMBIOS 2.4 present.
DMI: LENOVO 6464CTO/6464CTO, BIOS 7LETC9WW (2.29 ) 03/18/2011
e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
e820: remove [mem 0x000a0000-0x000fffff] usable
No AGP bridge found
e820: last_pfn = 0x13c000 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
   00000-9FFFF write-back
   A0000-BFFFF uncachable
   C0000-CFFFF write-protect
   D0000-DFFFF uncachable
   E0000-FFFFF write-protect
MTRR variable ranges enabled:
   0 base 0C0000000 mask FC0000000 uncachable
   1 base 13C000000 mask FFC000000 uncachable
   2 base 000000000 mask F00000000 write-back
   3 base 100000000 mask FC0000000 write-back
   4 base 0BF700000 mask FFFF00000 uncachable
   5 base 0BF800000 mask FFF800000 uncachable
   6 disabled
   7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
original variable MTRRs
reg 0, base: 3GB, range: 1GB, type UC
reg 1, base: 5056MB, range: 64MB, type UC
reg 2, base: 0GB, range: 4GB, type WB
reg 3, base: 4GB, range: 1GB, type WB
reg 4, base: 3063MB, range: 1MB, type UC
reg 5, base: 3064MB, range: 8MB, type UC
total RAM covered: 4023M
Found optimal setting for mtrr clean up
  gran_size: 64K         chunk_size: 128M         num_reg: 6          lose 
cover RAM: 0G
New variable MTRRs
reg 0, base: 0GB, range: 2GB, type WB
reg 1, base: 2GB, range: 1GB, type WB
reg 2, base: 3063MB, range: 1MB, type UC
reg 3, base: 3064MB, range: 8MB, type UC
reg 4, base: 4GB, range: 1GB, type WB
reg 5, base: 5056MB, range: 64MB, type UC
e820: update [mem 0xbf700000-0xffffffff] usable ==> reserved
e820: last_pfn = 0xbf6b0 max_arch_pfn = 0x400000000
found SMP MP-table at [mem 0x000f68f0-0x000f68ff] mapped at [ffff8800000f68f0]
Scanning 1 areas for low memory corruption
Base memory trampoline at [ffff880000097000] 97000 size 24576
init_memory_mapping: [mem 0x00000000-0x000fffff]
  [mem 0x00000000-0x000fffff] page 4k
BRK [0x02847000, 0x02847fff] PGTABLE
BRK [0x02848000, 0x02848fff] PGTABLE
BRK [0x02849000, 0x02849fff] PGTABLE
init_memory_mapping: [mem 0x13be00000-0x13bffffff]
  [mem 0x13be00000-0x13bffffff] page 2M
BRK [0x0284a000, 0x0284afff] PGTABLE
init_memory_mapping: [mem 0x138000000-0x13bdfffff]
  [mem 0x138000000-0x13bdfffff] page 2M
init_memory_mapping: [mem 0x100000000-0x137ffffff]
  [mem 0x100000000-0x137ffffff] page 2M
init_memory_mapping: [mem 0x00100000-0xbf6affff]
  [mem 0x00100000-0x001fffff] page 4k
  [mem 0x00200000-0xbf5fffff] page 2M
  [mem 0xbf600000-0xbf6affff] page 4k
RAMDISK: [mem 0x36df2000-0x376f0fff]
ACPI: RSDP 00000000000f68c0 00024 (v02 LENOVO)
ACPI: XSDT 00000000bf6bb496 0009C (v01 LENOVO TP-7U    00002290  LTP 00000000)
ACPI: FACP 00000000bf6bb600 000F4 (v03 LENOVO TP-7U    00002290 LNVO 00000001)
ACPI BIOS Warning (bug): 32/64X length mismatch in FADT/Gpe1Block: 0/32 
(20130725/tbfadt-572)
ACPI BIOS Warning (bug): Optional FADT field Gpe1Block has zero address or 
length: 0x000000000000102C/0x0 (20130725/tbfadt-603)
ACPI: DSDT 00000000bf6bba1d 1003C (v01 LENOVO TP-7U    00002290 MSFT 03000000)
ACPI: FACS 00000000bf6e4000 00040
ACPI: SSDT 00000000bf6bb7b4 00269 (v01 LENOVO TP-7U    00002290 MSFT 03000000)
ACPI: ECDT 00000000bf6cba59 00052 (v01 LENOVO TP-7U    00002290 LNVO 00000001)
ACPI: TCPA 00000000bf6cbaab 00032 (v02 LENOVO TP-7U    00002290 LNVO 00000001)
ACPI: APIC 00000000bf6cbadd 00068 (v01 LENOVO TP-7U    00002290 LNVO 00000001)
ACPI: MCFG 00000000bf6cbb45 0003C (v01 LENOVO TP-7U    00002290 LNVO 00000001)
ACPI: HPET 00000000bf6cbb81 00038 (v01 LENOVO TP-7U    00002290 LNVO 00000001)
ACPI: SLIC 00000000bf6cbbb9 00176 (v01 LENOVO TP-7U    00002290  LTP 00000000)
ACPI: SLAC 00000000bf6cbdf0 00176 (v01 LENOVO TP-7U    00002290  LTP 00000000)
ACPI: BOOT 00000000bf6cbf66 00028 (v01 LENOVO TP-7U    00002290  LTP 00000001)
ACPI: ASF! 00000000bf6cbf8e 00072 (v16 LENOVO TP-7U    00002290 PTL  00000001)
ACPI: SSDT 00000000bf6e26d9 0025F (v01 LENOVO TP-7U    00002290 INTL 20050513)
ACPI: SSDT 00000000bf6e2938 000A6 (v01 LENOVO TP-7U    00002290 INTL 20050513)
ACPI: SSDT 00000000bf6e29de 004F7 (v01 LENOVO TP-7U    00002290 INTL 20050513)
ACPI: SSDT 00000000bf6e2ed5 001D8 (v01 LENOVO TP-7U    00002290 INTL 20050513)
ACPI: DMI detected: Lenovo ThinkPad T61
ACPI: Local APIC address 0xfee00000
  [ffffea0000000000-ffffea0004ffffff] PMD -> 
[ffff880137600000-ffff88013b5fffff] on node 0
Zone ranges:
   DMA      [mem 0x00001000-0x00ffffff]
   DMA32    [mem 0x01000000-0xffffffff]
   Normal   [mem 0x100000000-0x13bffffff]
Movable zone start for each node
Early memory node ranges
   node   0: [mem 0x00001000-0x0009cfff]
   node   0: [mem 0x00100000-0xbf6affff]
   node   0: [mem 0x100000000-0x13bffffff]
On node 0 totalpages: 1029708
   DMA zone: 64 pages used for memmap
   DMA zone: 21 pages reserved
   DMA zone: 3996 pages, LIFO batch:0
   DMA32 zone: 12187 pages used for memmap
   DMA32 zone: 779952 pages, LIFO batch:31
   Normal zone: 3840 pages used for memmap
   Normal zone: 245760 pages, LIFO batch:31
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
PM: Registered nosave memory: [mem 0x0009d000-0x0009dfff]
PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
PM: Registered nosave memory: [mem 0xbf6b0000-0xbf6cbfff]
PM: Registered nosave memory: [mem 0xbf6cc000-0xbf6fffff]
PM: Registered nosave memory: [mem 0xbf700000-0xbfffffff]
PM: Registered nosave memory: [mem 0xc0000000-0xefffffff]
PM: Registered nosave memory: [mem 0xf0000000-0xf3ffffff]
PM: Registered nosave memory: [mem 0xf4000000-0xfebfffff]
PM: Registered nosave memory: [mem 0xfec00000-0xfec0ffff]
PM: Registered nosave memory: [mem 0xfec10000-0xfecfffff]
PM: Registered nosave memory: [mem 0xfed00000-0xfed13fff]
PM: Registered nosave memory: [mem 0xfed14000-0xfed19fff]
PM: Registered nosave memory: [mem 0xfed1a000-0xfed1bfff]
PM: Registered nosave memory: [mem 0xfed1c000-0xfed8ffff]
PM: Registered nosave memory: [mem 0xfed90000-0xfedfffff]
PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
PM: Registered nosave memory: [mem 0xfee01000-0xfeffffff]
PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
e820: [mem 0xc0000000-0xefffffff] available for PCI devices
setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 476 pages/cpu @ffff880137200000 s1920384 r8192 d21120 u2097152
pcpu-alloc: s1920384 r8192 d21120 u2097152 alloc=1*2097152
pcpu-alloc: [0] 0 [0] 1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1013596
Kernel command line: BOOT_IMAGE=/vmlinuz-3.12.0-00053-g6ed31ed root=/dev/sda2 
ro selinux=0 kmemleak=off lockdep.prove_locking=0 lockdep.lock_stat=0 
ipv6.disable=1 systemd.log_level=info systemd.log_target=kmsg quiet 
console=ttyS0,115200 console=tty LANG=cs_CZ.UTF-8
PID hash table entries: 4096 (order: 3, 32768 bytes)
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Checking aperture...
No AGP bridge found
Memory: 3942696K/4118832K available (5801K kernel code, 869K rwdata, 2460K 
rodata, 2968K init, 10748K bss, 176136K reserved)
SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
Preemptible hierarchical RCU implementation.
         RCU debugfs-based tracing is enabled.
         RCU dyntick-idle grace-period acceleration is enabled.
         RCU lockdep checking is enabled.
         Additional per-CPU info printed with stalls.
NR_IRQS:4352 nr_irqs:512 16
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     16384
... MAX_LOCKDEP_CHAINS:      32768
... CHAINHASH_SIZE:          16384
  memory used by lock dependency info: 6367 kB
  per task-struct memory footprint: 2688 bytes
allocated 16777216 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
hpet clockevent registered
tsc: Fast TSC calibration using PIT
tsc: Detected 2194.534 MHz processor
Calibrating delay loop (skipped), value calculated using timer frequency.. 
4390.94 BogoMIPS (lpj=7315113)
pid_max: default: 32768 minimum: 301
Security Framework initialized
SELinux:  Disabled at boot.
Mount-cache hash table entries: 256
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys blkio
Initializing cgroup subsys hugetlb
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 6 MCE banks
CPU0: Thermal monitoring enabled (TM2)
Last level iTLB entries: 4KB 128, 2MB 4, 4MB 4
Last level dTLB entries: 4KB 256, 2MB 0, 4MB 32
tlb_flushall_shift: -1
Freeing SMP alternatives memory: 20K (ffffffff81dc1000 - ffffffff81dc6000)
ACPI: Core revision 20130725
ACPI: All ACPI Tables successfully acquired
ftrace: allocating 20064 entries in 79 pages
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
smpboot: CPU0: Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz (fam: 06, 
model: 0f, stepping: 0a)
Performance Events: PEBS fmt0+, 4-deep LBR, Core2 events, Intel PMU driver.
perf_event_intel: PEBS disabled due to CPU errata
... version:                2
... bit width:              40
... generic registers:      2
... value mask:             000000ffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             0000000700000003
SMP alternatives: lockdep: fixing up alternatives
smpboot: Booting Node   0, Processors  #   1 OK
TSC synchronization [CPU#0 -> CPU#1]:
Measured 399740 cycles TSC warp between CPUs, turning off TSC clock.
tsc: Marking TSC unstable due to check_tsc_sync_source failed
NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
Brought up 2 CPUs
smpboot: Total of 2 processors activated (8781.89 BogoMIPS)
devtmpfs: initialized
EVM: security.selinux
EVM: security.capability
PM: Registering ACPI NVS region [mem 0xbf6cc000-0xbf6fffff] (212992 bytes)
regulator-dummy: no parameters
RTC time: 15:00:11, date: 11/17/13
NET: Registered protocol family 16
cpuidle: using governor ladder
cpuidle: using governor menu
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type PCI registered
PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf0000000-0xf3ffffff] (base 
0xf0000000)
PCI: MMCONFIG at [mem 0xf0000000-0xf3ffffff] reserved in E820
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI: Added _OSI(Linux)
ACPI: EC: EC description table is found, configuring boot EC
[Firmware Bug]: ACPI: BIOS _OSI(Linux) query honored via DMI
ACPI: SSDT 00000000bf6e1b32 002C4 (v01  PmRef  Cpu0Ist 00000100 INTL 20050513)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 002C4 (v01  PmRef  Cpu0Ist 00000100 INTL 20050513)
ACPI: SSDT 00000000bf6e1e7b 0085E (v01  PmRef  Cpu0Cst 00000100 INTL 20050513)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 0085E (v01  PmRef  Cpu0Cst 00000100 INTL 20050513)
ACPI: SSDT 00000000bf6e1a6a 000C8 (v01  PmRef  Cpu1Ist 00000100 INTL 20050513)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 000C8 (v01  PmRef  Cpu1Ist 00000100 INTL 20050513)
ACPI: SSDT 00000000bf6e1df6 00085 (v01  PmRef  Cpu1Cst 00000100 INTL 20050513)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 00085 (v01  PmRef  Cpu1Cst 00000100 INTL 20050513)
ACPI: Interpreter enabled
ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] 
(20130725/hwxface-571)
ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] 
(20130725/hwxface-571)
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and 
report a bug
ACPI: ACPI Dock Station Driver: 3 docks/bays found
ACPI: Power Resource [PUBS] (on)
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 *10 11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
acpi PNP0A08:00: Requesting ACPI _OSC control (0x1d)
acpi PNP0A08:00: ACPI _OSC control (0x1d) granted
acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-3f] only 
partially covers this bridge
PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [bus 00-ff]
pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
pci_bus 0000:00: root bus resource [mem 0xc0000000-0xfebfffff]
pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed4bfff]
pci 0000:00:00.0: [8086:2a00] type 00 class 0x060000
pci 0000:00:02.0: [8086:2a02] type 00 class 0x030000
pci 0000:00:02.0: reg 0x10: [mem 0xf8100000-0xf81fffff 64bit]
pci 0000:00:02.0: reg 0x18: [mem 0xe0000000-0xefffffff 64bit pref]
pci 0000:00:02.0: reg 0x20: [io  0x1800-0x1807]
pci 0000:00:02.1: [8086:2a03] type 00 class 0x038000
pci 0000:00:02.1: reg 0x10: [mem 0xf8200000-0xf82fffff 64bit]
pci 0000:00:19.0: [8086:1049] type 00 class 0x020000
pci 0000:00:19.0: reg 0x10: [mem 0xfe000000-0xfe01ffff]
pci 0000:00:19.0: reg 0x14: [mem 0xfe025000-0xfe025fff]
pci 0000:00:19.0: reg 0x18: [io  0x1840-0x185f]
pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
pci 0000:00:19.0: System wakeup disabled by ACPI
pci 0000:00:1a.0: [8086:2834] type 00 class 0x0c0300
pci 0000:00:1a.0: reg 0x20: [io  0x1860-0x187f]
pci 0000:00:1a.0: System wakeup disabled by ACPI
pci 0000:00:1a.1: [8086:2835] type 00 class 0x0c0300
pci 0000:00:1a.1: reg 0x20: [io  0x1880-0x189f]
pci 0000:00:1a.1: System wakeup disabled by ACPI
pci 0000:00:1a.7: [8086:283a] type 00 class 0x0c0320
pci 0000:00:1a.7: reg 0x10: [mem 0xfe226c00-0xfe226fff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: System wakeup disabled by ACPI
pci 0000:00:1b.0: [8086:284b] type 00 class 0x040300
pci 0000:00:1b.0: reg 0x10: [mem 0xfe020000-0xfe023fff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: System wakeup disabled by ACPI
pci 0000:00:1c.0: [8086:283f] type 01 class 0x060400
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: System wakeup disabled by ACPI
pci 0000:00:1c.1: [8086:2841] type 01 class 0x060400
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: System wakeup disabled by ACPI
pci 0000:00:1c.2: [8086:2843] type 01 class 0x060400
pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.2: System wakeup disabled by ACPI
pci 0000:00:1c.3: [8086:2845] type 01 class 0x060400
pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.3: System wakeup disabled by ACPI
pci 0000:00:1c.4: [8086:2847] type 01 class 0x060400
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: System wakeup disabled by ACPI
pci 0000:00:1d.0: [8086:2830] type 00 class 0x0c0300
pci 0000:00:1d.0: reg 0x20: [io  0x18a0-0x18bf]
pci 0000:00:1d.0: System wakeup disabled by ACPI
pci 0000:00:1d.1: [8086:2831] type 00 class 0x0c0300
pci 0000:00:1d.1: reg 0x20: [io  0x18c0-0x18df]
pci 0000:00:1d.1: System wakeup disabled by ACPI
pci 0000:00:1d.2: [8086:2832] type 00 class 0x0c0300
pci 0000:00:1d.2: reg 0x20: [io  0x18e0-0x18ff]
pci 0000:00:1d.2: System wakeup disabled by ACPI
pci 0000:00:1d.7: [8086:2836] type 00 class 0x0c0320
pci 0000:00:1d.7: reg 0x10: [mem 0xfe227000-0xfe2273ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: System wakeup disabled by ACPI
pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
pci 0000:00:1e.0: System wakeup disabled by ACPI
pci 0000:00:1f.0: [8086:2811] type 00 class 0x060100
pci 0000:00:1f.0: address space collision: [io  0x1000-0x107f] conflicts with 
ACPI CPU throttle [??? 0x00001010-0x00001015 flags 0x80000000]
pci 0000:00:1f.0: quirk: [io  0x1180-0x11bf] claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 1600 (mask 007f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 15e0 (mask 000f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 1680 (mask 001f)
pci 0000:00:1f.1: [8086:2850] type 00 class 0x01018a
pci 0000:00:1f.1: reg 0x10: [io  0x0000-0x0007]
pci 0000:00:1f.1: reg 0x14: [io  0x0000-0x0003]
pci 0000:00:1f.1: reg 0x18: [io  0x0000-0x0007]
pci 0000:00:1f.1: reg 0x1c: [io  0x0000-0x0003]
pci 0000:00:1f.1: reg 0x20: [io  0x1c00-0x1c0f]
pci 0000:00:1f.2: [8086:2829] type 00 class 0x010601
pci 0000:00:1f.2: reg 0x10: [io  0x1c50-0x1c57]
pci 0000:00:1f.2: reg 0x14: [io  0x1c44-0x1c47]
pci 0000:00:1f.2: reg 0x18: [io  0x1c48-0x1c4f]
pci 0000:00:1f.2: reg 0x1c: [io  0x1c40-0x1c43]
pci 0000:00:1f.2: reg 0x20: [io  0x1c20-0x1c3f]
pci 0000:00:1f.2: reg 0x24: [mem 0xfe226000-0xfe2267ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.3: [8086:283e] type 00 class 0x0c0500
pci 0000:00:1f.3: reg 0x10: [mem 0xfe227400-0xfe2274ff]
pci 0000:00:1f.3: reg 0x20: [io  0x1c60-0x1c7f]
pci 0000:00:1c.0: PCI bridge to [bus 02]
pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.0:   bridge window [mem 0xfc000000-0xfdffffff]
pci 0000:00:1c.0:   bridge window [mem 0xf8000000-0xf80fffff 64bit pref]
pci 0000:03:00.0: [8086:4227] type 00 class 0x028000
pci 0000:03:00.0: reg 0x10: [mem 0xdf3ff000-0xdf3fffff]
pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PCI bridge to [bus 03]
pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
pci 0000:00:1c.1:   bridge window [mem 0xdc000000-0xdf3fffff]
pci 0000:00:1c.1:   bridge window [mem 0xdfe00000-0xdfefffff 64bit pref]
pci 0000:00:1c.2: PCI bridge to [bus 04]
pci 0000:00:1c.2:   bridge window [io  0x4000-0x4fff]
pci 0000:00:1c.2:   bridge window [mem 0xd8000000-0xd9ffffff]
pci 0000:00:1c.2:   bridge window [mem 0xdfb00000-0xdfbfffff 64bit pref]
pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
pci 0000:00:1c.3:   bridge window [io  0x5000-0x5fff]
pci 0000:00:1c.3:   bridge window [mem 0xd4000000-0xd5ffffff]
pci 0000:00:1c.3:   bridge window [mem 0xdf800000-0xdf8fffff 64bit pref]
pci 0000:00:1c.4: PCI bridge to [bus 0d-14]
pci 0000:00:1c.4:   bridge window [io  0x6000-0x6fff]
pci 0000:00:1c.4:   bridge window [mem 0xd0000000-0xd1ffffff]
pci 0000:00:1c.4:   bridge window [mem 0xdf500000-0xdf5fffff 64bit pref]
pci 0000:15:00.0: [1180:0476] type 02 class 0x060700
pci 0000:15:00.0: proprietary Ricoh MMC controller disabled (via cardbus function)
pci 0000:15:00.0: MMC cards are now supported by standard SDHCI controller
pci 0000:15:00.0: reg 0x10: [mem 0xf8300000-0xf8300fff]
pci 0000:15:00.0: supports D1 D2
pci 0000:15:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:15:00.2: [1180:0822] type 00 class 0x080500
pci 0000:15:00.2: reg 0x10: [mem 0xf8301000-0xf83010ff]
pci 0000:15:00.2: supports D1 D2
pci 0000:15:00.2: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:15:00.4: [1180:0592] type 00 class 0x088000
pci 0000:15:00.4: reg 0x10: [mem 0xf8301800-0xf83018ff]
pci 0000:15:00.4: supports D1 D2
pci 0000:15:00.4: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:15:00.5: [1180:0852] type 00 class 0x088000
pci 0000:15:00.5: reg 0x10: [mem 0xf8301c00-0xf8301cff]
pci 0000:15:00.5: supports D1 D2
pci 0000:15:00.5: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:1e.0: PCI bridge to [bus 15-18] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x7000-0xafff]
pci 0000:00:1e.0:   bridge window [mem 0xf8300000-0xfbffffff]
pci 0000:00:1e.0:   bridge window [mem 0xf4000000-0xf7ffffff 64bit pref]
pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)lis 
17 16:00:12 linux kernel: pci 0000:00:1e.0:   bridge window [io 
0x0d00-0xffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000d3fff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000dc000-0x000dffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xfebfffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfed4bfff] (subtractive decode)
pci_bus 0000:16: busn_res: can not insert [bus 16-ff] under [bus 15-18] 
(conflicts with (null) [bus 15-18])
pci_bus 0000:16: busn_res: [bus 16-ff] end is updated to 17
pci_bus 0000:00: on NUMA node 0
acpi PNP0A08:00: Disabling ASPM (FADT indicates it is unsupported)
ACPI: Enabled 3 GPEs in block 00 to 1F
ACPI: \_SB_.PCI0: notify handler is installed
Found 1 acpi root devices
ACPI: EC: GPE = 0x12, I/O: command/status = 0x66, data = 0x62
vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
vgaarb: bridge control possible 0000:00:02.0
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
e820: reserve RAM buffer [mem 0xbf6b0000-0xbfffffff]
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
Switched to clocksource hpet
pnp: PnP ACPI init
ACPI: bus type PNP registered
system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
system 00:00: [mem 0x00100000-0xbfffffff] could not be reserved
system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
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
system 00:01: [mem 0xfed45000-0xfed4bfff] has been reserved
system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:02: Plug and Play ACPI device, IDs PNP0103 (active)
pnp 00:03: [dma 4]
pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
pnp 00:08: Plug and Play ACPI device, IDs IBM0057 PNP0f13 (active)
pnp 00:09: Plug and Play ACPI device, IDs ATM1200 PNP0c31 (active)
pnp: PnP ACPI: found 10 devices
ACPI: bus type PNP unregistered
pci 0000:00:1f.0: BAR 13: [io  0x1000-0x107f] has bogus alignment
pci 0000:00:1c.0: PCI bridge to [bus 02]
pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.0:   bridge window [mem 0xfc000000-0xfdffffff]
pci 0000:00:1c.0:   bridge window [mem 0xf8000000-0xf80fffff 64bit pref]
pci 0000:00:1c.1: PCI bridge to [bus 03]
pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
pci 0000:00:1c.1:   bridge window [mem 0xdc000000-0xdf3fffff]
pci 0000:00:1c.1:   bridge window [mem 0xdfe00000-0xdfefffff 64bit pref]
pci 0000:00:1c.2: PCI bridge to [bus 04]
pci 0000:00:1c.2:   bridge window [io  0x4000-0x4fff]
pci 0000:00:1c.2:   bridge window [mem 0xd8000000-0xd9ffffff]
pci 0000:00:1c.2:   bridge window [mem 0xdfb00000-0xdfbfffff 64bit pref]
pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
pci 0000:00:1c.3:   bridge window [io  0x5000-0x5fff]
pci 0000:00:1c.3:   bridge window [mem 0xd4000000-0xd5ffffff]
pci 0000:00:1c.3:   bridge window [mem 0xdf800000-0xdf8fffff 64bit pref]
pci 0000:00:1c.4: PCI bridge to [bus 0d-14]
pci 0000:00:1c.4:   bridge window [io  0x6000-0x6fff]
pci 0000:00:1c.4:   bridge window [mem 0xd0000000-0xd1ffffff]
pci 0000:00:1c.4:   bridge window [mem 0xdf500000-0xdf5fffff 64bit pref]
pci 0000:15:00.0: res[15]=[mem 0x04000000-0x03ffffff pref] get_res_add_size 
add_size 4000000
pci 0000:15:00.0: res[16]=[mem 0x04000000-0x03ffffff] get_res_add_size 
add_size 4000000
pci 0000:15:00.0: res[13]=[io  0x0100-0x00ff] get_res_add_size add_size 100
pci 0000:15:00.0: res[14]=[io  0x0100-0x00ff] get_res_add_size add_size 100
pci 0000:15:00.0: BAR 15: assigned [mem 0xf4000000-0xf7ffffff pref]
pci 0000:15:00.0: BAR 16: assigned [mem 0xc0000000-0xc3ffffff]
pci 0000:15:00.0: BAR 13: assigned [io  0x7000-0x70ff]
pci 0000:15:00.0: BAR 14: assigned [io  0x7400-0x74ff]
pci 0000:15:00.0: CardBus bridge to [bus 16-17]
pci 0000:15:00.0:   bridge window [io  0x7000-0x70ff]
pci 0000:15:00.0:   bridge window [io  0x7400-0x74ff]
pci 0000:15:00.0:   bridge window [mem 0xf4000000-0xf7ffffff pref]
pci 0000:15:00.0:   bridge window [mem 0xc0000000-0xc3ffffff]
pci 0000:00:1e.0: PCI bridge to [bus 15-18]
pci 0000:00:1e.0:   bridge window [io  0x7000-0xafff]
pci 0000:00:1e.0:   bridge window [mem 0xf8300000-0xfbffffff]
pci 0000:00:1e.0:   bridge window [mem 0xf4000000-0xf7ffffff 64bit pref]
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
pci_bus 0000:00: resource 10 [mem 0x000dc000-0x000dffff]
pci_bus 0000:00: resource 11 [mem 0xc0000000-0xfebfffff]
pci_bus 0000:00: resource 12 [mem 0xfed40000-0xfed4bfff]
pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
pci_bus 0000:02: resource 1 [mem 0xfc000000-0xfdffffff]
pci_bus 0000:02: resource 2 [mem 0xf8000000-0xf80fffff 64bit pref]
pci_bus 0000:03: resource 0 [io  0x3000-0x3fff]
pci_bus 0000:03: resource 1 [mem 0xdc000000-0xdf3fffff]
pci_bus 0000:03: resource 2 [mem 0xdfe00000-0xdfefffff 64bit pref]
pci_bus 0000:04: resource 0 [io  0x4000-0x4fff]
pci_bus 0000:04: resource 1 [mem 0xd8000000-0xd9ffffff]
pci_bus 0000:04: resource 2 [mem 0xdfb00000-0xdfbfffff 64bit pref]
pci_bus 0000:05: resource 0 [io  0x5000-0x5fff]
pci_bus 0000:05: resource 1 [mem 0xd4000000-0xd5ffffff]
pci_bus 0000:05: resource 2 [mem 0xdf800000-0xdf8fffff 64bit pref]
pci_bus 0000:0d: resource 0 [io  0x6000-0x6fff]
pci_bus 0000:0d: resource 1 [mem 0xd0000000-0xd1ffffff]
pci_bus 0000:0d: resource 2 [mem 0xdf500000-0xdf5fffff 64bit pref]
pci_bus 0000:15: resource 0 [io  0x7000-0xafff]
pci_bus 0000:15: resource 1 [mem 0xf8300000-0xfbffffff]
pci_bus 0000:15: resource 2 [mem 0xf4000000-0xf7ffffff 64bit pref]
pci_bus 0000:15: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:15: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:15: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:15: resource 7 [mem 0x000d0000-0x000d3fff]
pci_bus 0000:15: resource 8 [mem 0x000d4000-0x000d7fff]
pci_bus 0000:15: resource 9 [mem 0x000d8000-0x000dbfff]
pci_bus 0000:15: resource 10 [mem 0x000dc000-0x000dffff]
pci_bus 0000:15: resource 11 [mem 0xc0000000-0xfebfffff]
pci_bus 0000:15: resource 12 [mem 0xfed40000-0xfed4bfff]
pci_bus 0000:16: resource 0 [io  0x7000-0x70ff]
pci_bus 0000:16: resource 1 [io  0x7400-0x74ff]
pci_bus 0000:16: resource 2 [mem 0xf4000000-0xf7ffffff pref]
pci_bus 0000:16: resource 3 [mem 0xc0000000-0xc3ffffff]
NET: Registered protocol family 2
TCP established hash table entries: 32768 (order: 7, 524288 bytes)
TCP bind hash table entries: 32768 (order: 9, 2621440 bytes)
TCP: Hash tables configured (established 32768 bind 32768)
TCP: reno registered
UDP hash table entries: 2048 (order: 6, 393216 bytes)
UDP-Lite hash table entries: 2048 (order: 6, 393216 bytes)
NET: Registered protocol family 1
pci 0000:00:02.0: Boot video device
PCI: CLS mismatch (64 != 32), using 64 bytes
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 9212K (ffff880036df2000 - ffff8800376f1000)
DMA-API: preallocated 65536 debug entries
DMA-API: debugging enabled by kernel config
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
software IO TLB [mem 0xbb6b0000-0xbf6b0000] (64MB) mapped at 
[ffff8800bb6b0000-ffff8800bf6affff]
Simple Boot Flag at 0x35 set to 0x1
Scanning for low memory corruption every 60 seconds
audit: initializing netlink socket (disabled)
type=2000 audit(1384700411.119:1): initialized
bounce pool size: 64 pages
HugeTLB registered 2 MB page size, pre-allocated 0 pages
msgmni has been set to 7718
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
io scheduler noop registered
io scheduler deadline registered (default)
pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
pcieport 0000:00:1c.2: irq 42 for MSI/MSI-X
pcieport 0000:00:1c.3: irq 43 for MSI/MSI-X
pcieport 0000:00:1c.4: irq 44 for MSI/MSI-X
pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
pcieport 0000:00:1c.2: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:1c.2:pcie01: service driver pcie_pme loaded
pcieport 0000:00:1c.3: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:1c.3:pcie01: service driver pcie_pme loaded
pcieport 0000:00:1c.4: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:1c.4:pcie01: service driver pcie_pme loaded
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ACPI: Deprecated procfs I/F for AC is loaded, please retry with 
CONFIG_ACPI_PROCFS_POWER cleared
ACPI: AC Adapter [AC] (on-line)
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
ACPI: Lid Switch [LID]
input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
ACPI: Sleep Button [SLPB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
ACPI: Power Button [PWRF]
ACPI: Requesting acpi_cpufreq
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state
ACPI: acpi_idle registered with cpuidle
thermal LNXTHERM:00: registered as thermal_zone0
ACPI: Thermal Zone [THM0] (52 C)
thermal LNXTHERM:01: registered as thermal_zone1
ACPI: Thermal Zone [THM1] (48 C)
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel 965GM Chipset
agpgart-intel 0000:00:00.0: detected gtt size: 524288K total, 262144K mappable
agpgart-intel 0000:00:00.0: detected 8192K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
brd: module loaded
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: irq 45 for MSI/MSI-X
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x5 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ccc
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
ata1: SATA max UDMA/133 abar m2048@0xfe226000 port 0xfe226100 irq 45
ata2: DUMMY
ata3: SATA max UDMA/133 abar m2048@0xfe226000 port 0xfe226200 irq 45
ata_piix 0000:00:1f.1: version 2.13
ata_piix 0000:00:1f.1: setting latency timer to 64
ACPI: Deprecated procfs I/F for battery is loaded, please retry with 
CONFIG_ACPI_PROCFS_POWER cleared
ACPI: Battery Slot [BAT0] (battery present)
scsi3 : ata_piix
scsi4 : ata_piix
ata4: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1c00 irq 14
ata5: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1c08 irq 15
i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
ata5: port disabled--ignoring
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
rtc_cmos 00:06: RTC can wake from S4
rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
rtc_cmos 00:06: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
hdaps: inverting axis (3) readings
hdaps: LENOVO ThinkPad T61 detected
input: hdaps as /devices/platform/hdaps/input/input4
hdaps: driver successfully loaded
TCP: cubic registered
NET: Registered protocol family 17
Key type dns_resolver registered
registered taskstats version 1
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
Key type encrypted registered
EVM: Error registering secfs
   Magic number: 5:859:32
rtc_cmos 00:06: setting system clock to 2013-11-17 15:00:12 UTC (1384700412)
PM: Hibernation image not present or could not be loaded.
ata4.00: ATAPI: MATSHITADVD-RAM UJ-842 z, RC01, max UDMA/33
ata4.00: configured for UDMA/33
ata3: SATA link down (SStatus 0 SControl 300)
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ATA-9: SAMSUNG SSD 830 Series, CXM03B1Q, max UDMA/133
ata1.00: 500118192 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG SSD 830  CXM0 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 500118192 512-byte logical blocks: (256 GB/238 GiB)
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
scsi 3:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ-842 z RC01 PQ: 0 ANSI: 5
  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
scsi 3:0:0:0: Attached scsi generic sg1 type 5
sd 0:0:0:0: [sda] Attached SCSI disk
Freeing unused kernel memory: 2968K (ffffffff81adb000 - ffffffff81dc1000)
Write protecting the kernel read-only data: 10240k
Freeing unused kernel memory: 332K (ffff8800015ad000 - ffff880001600000)
Freeing unused kernel memory: 1636K (ffff880001867000 - ffff880001a00000)
