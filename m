Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023Ab3CALbk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 06:31:40 -0500
Received: from isp.esoch.eu ([46.174.232.11]:47246 "EHLO isp.esoch.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826Ab3CALbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 06:31:38 -0500
X-Greylist: delayed 632 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Mar 2013 06:31:37 EST
Message-ID: <51308F0F.5080701@esoch.pl>
Date: Fri, 01 Mar 2013 12:20:47 +0100
From: Marcin Romanowski <marcin@esoch.pl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130113 Thunderbird/17.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: DELL 1950 problem with 3.x kernels
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
When system starts  kernel is hanging. on lsd is presented system error 
E1410 CPU IEERR and on screen:

#v+
pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: root bus resource [mem 0xc0000000-0xfdffffff]
pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
pci 0000:00:02.0 PCI bridge to [bus 06-0b]
pci 0000:06:00.0 PCI bridge to [bus 07-0a]
pci 0000:07:00.0 PCI bridge to [bus 08-09]
pci 0000:08:00.0 PCI bridge to [bus 09-09]
pci 0000:07:01.0 PCI bridge to [bus 0a-0a]
pci 0000:06:00.3 PCI bridge to [bus 0b-0b]
#v-
and that all. system hangs. i must restart with power off.
but sometimes system starts normally and then dmsesg shows:

#v+
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.4.32-std341-amd64 (root@catalyst) (gcc 
version 4.5.4 (Gentoo 4.5.4 p1.0, pie-0.4.7) ) #2 SMP Sun Feb 17 
20:20:16 UTC 2013
[    0.000000] Command line: initrd=initram.igz BOOT_IMAGE=rescue64
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bfb50000 (usable)
[    0.000000]  BIOS-e820: 00000000bfb50000 - 00000000bfb66000 (reserved)
[    0.000000]  BIOS-e820: 00000000bfb66000 - 00000000bfb85c00 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bfb85c00 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fe000000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000440000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.5 present.
[    0.000000] DMI: Dell Inc. PowerEdge 1950/0UR033, BIOS 2.7.0 10/30/2010
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 
(usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 
(usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x440000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-EBFFF uncachable
[    0.000000]   EC000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 base 100000000 mask F00000000 write-back
[    0.000000]   3 base 200000000 mask E00000000 write-back
[    0.000000]   4 base 400000000 mask FC0000000 write-back
[    0.000000]   5 base 0BFC00000 mask FFFC00000 uncachable
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 
0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 4GB, range: 4GB, type WB
[    0.000000] reg 3, base: 8GB, range: 8GB, type WB
[    0.000000] reg 4, base: 16GB, range: 1GB, type WB
[    0.000000] reg 5, base: 3068MB, range: 4MB, type UC
[    0.000000] total RAM covered: 16380M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K     chunk_size: 8M     num_reg: 6      
lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 3068MB, range: 4MB, type UC
[    0.000000] reg 3, base: 4GB, range: 4GB, type WB
[    0.000000] reg 4, base: 8GB, range: 8GB, type WB
[    0.000000] reg 5, base: 16GB, range: 1GB, type WB
[    0.000000] e820 update range: 00000000bfc00000 - 0000000100000000 
(usable) ==> (reserved)
[    0.000000] last_pfn = 0xbfb50 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000fe710] fe710
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff88000009d000] 9d000 size 8192
[    0.000000] init_memory_mapping: 0000000000000000-00000000bfb50000
[    0.000000]  0000000000 - 00bfa00000 page 2M
[    0.000000]  00bfa00000 - 00bfb50000 page 4k
[    0.000000] kernel direct mapping tables up to 0xbfb4ffff @ [mem 
0x1fffb000-0x1fffffff]
[    0.000000] init_memory_mapping: 0000000100000000-0000000440000000
[    0.000000]  0100000000 - 0440000000 page 2M
[    0.000000] kernel direct mapping tables up to 0x43fffffff @ [mem 
0xbfb42000-0xbfb4ffff]
[    0.000000] RAMDISK: 7f4e6000 - 7ffff000
[    0.000000] ACPI: RSDP 00000000000f2160 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT 00000000000f21fc 00084 (v01 DELL PE_SC3 
00000001 DELL 00000001)
[    0.000000] ACPI: FACP 00000000bfb83524 000F4 (v03 DELL PE_SC3 
00000001 DELL 00000001)
[    0.000000] ACPI: DSDT 00000000bfb66000 04996 (v01 DELL PE_SC3 
00000001 INTL 20050624)
[    0.000000] ACPI: FACS 00000000bfb85c00 00040
[    0.000000] ACPI: APIC 00000000bfb83078 0009E (v01 DELL PE_SC3 
00000001 DELL 00000001)
[    0.000000] ACPI: SPCR 00000000bfb83130 00050 (v01 DELL PE_SC3 
00000001 DELL 00000001)
[    0.000000] ACPI: HPET 00000000bfb83184 00038 (v01 DELL PE_SC3 
00000001 DELL 00000001)
[    0.000000] ACPI: MCFG 00000000bfb831c0 0003C (v01 DELL PE_SC3 
00000001 DELL 00000001)
[    0.000000] ACPI: WD__ 00000000bfb83200 00134 (v01 DELL PE_SC3 
00000001 DELL 00000001)
[    0.000000] ACPI: SLIC 00000000bfb83338 00024 (v01 DELL PE_SC3 
00000001 DELL 00000001)
[    0.000000] ACPI: ERST 00000000bfb6ab18 00210 (v01 DELL PE_SC3 
00000001 DELL 00000001)
[    0.000000] ACPI: HEST 00000000bfb6ad28 0027C (v01 DELL PE_SC3 
00000001 DELL 00000001)
[    0.000000] ACPI: BERT 00000000bfb6a998 00030 (v01 DELL PE_SC3 
00000001 DELL 00000001)
[    0.000000] ACPI: EINJ 00000000bfb6a9c8 00150 (v01 DELL PE_SC3 
00000001 DELL 00000001)
[    0.000000] ACPI: TCPA 00000000bfb834bc 00064 (v02 DELL PE_SC3 
00000001 DELL 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000440000000
[    0.000000] Initmem setup node 0 0000000000000000-0000000440000000
[    0.000000]   NODE_DATA [000000043ffec000 - 000000043fffffff]
[    0.000000]  [ffffea0000000000-ffffea0010ffffff] PMD -> 
[ffff88042f600000-ffff88043f5fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00440000
[    0.000000] Movable zone start PFN for each node
[    0.000000] Early memory PFN ranges
[    0.000000]     0: 0x00000010 -> 0x000000a0
[    0.000000]     0: 0x00000100 -> 0x000bfb50
[    0.000000]     0: 0x00100000 -> 0x00440000
[    0.000000] On node 0 totalpages: 4192992
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 3 pages reserved
[    0.000000]   DMA zone: 3917 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 764816 pages, LIFO batch:31
[    0.000000]   Normal zone: 53248 pages used for memmap
[    0.000000]   Normal zone: 3354624 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 
0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec81000] gsi_base[64])
[    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec81000, GSI 
64-87
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 104
[    0.000000] Allocating PCI resources starting at c0000000 (gap: 
c0000000:20000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 
nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88043fc00000 s83008 
r8192 d23488 u262144
[    0.000000] pcpu-alloc: s83008 r8192 d23488 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on. 
Total pages: 4123357
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: initrd=initram.igz BOOT_IMAGE=rescue64
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 16406720k/17825792k available (6805k kernel code, 
1053824k absent, 365248k reserved, 6465k data, 9712k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, 
CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:16640 nr_irqs:1832 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 67108864 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't 
want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2327.642 MHz processor.
[    0.001005] Calibrating delay loop (skipped), value calculated using 
timer frequency.. 4655.28 BogoMIPS (lpj=2327642)
[    0.001519] pid_max: default: 32768 minimum: 301
[    0.002034] Security Framework initialized
[    0.002298] SELinux:  Disabled at boot.
[    0.004705] Dentry cache hash table entries: 2097152 (order: 12, 
16777216 bytes)
[    0.014077] Inode-cache hash table entries: 1048576 (order: 11, 
8388608 bytes)
[    0.018509] Mount-cache hash table entries: 256
[    0.019111] Initializing cgroup subsys cpuacct
[    0.019370] Initializing cgroup subsys memory
[    0.019647] Initializing cgroup subsys devices
[    0.019904] Initializing cgroup subsys freezer
[    0.020003] Initializing cgroup subsys net_cls
[    0.020258] Initializing cgroup subsys blkio
[    0.020524] Initializing cgroup subsys perf_event
[    0.020810] CPU: Physical Processor ID: 0
[    0.021002] CPU: Processor Core ID: 0
[    0.021256] mce: CPU supports 6 MCE banks
[    0.021518] CPU0: Thermal monitoring enabled (TM1)
[    0.022004] using mwait in idle threads.
[    0.022758] ACPI: Core revision 20120320
[    0.024535] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.035305] CPU0: Intel(R) Xeon(R) CPU           E5345  @ 2.33GHz 
stepping 07
[    0.035997] Performance Events: PEBS fmt0-, 4-deep LBR, Core2 events, 
Intel PMU driver.
[    0.035997] PEBS disabled due to CPU errata.
[    0.035997] ... version:                2
[    0.035999] ... bit width:              40
[    0.036252] ... generic registers:      2
[    0.036506] ... value mask:             000000ffffffffff
[    0.036762] ... max period:             000000007fffffff
[    0.036999] ... fixed-purpose events:   3
[    0.037251] ... event mask:             0000000700000003
[    0.038132] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.038539] Booting Node   0, Processors  #1
[    0.110012] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.110658]  #2
[    0.122009] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.123154]  #3
[    0.135008] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.136110]  #4
[    0.148026] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.149183]  #5
[    0.161005] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.162119]  #6
[    0.174013] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.175059]  #7 Ok.
[    0.187001] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.187293] Brought up 8 CPUs
[    0.187983] Total of 8 processors activated (37241.27 BogoMIPS).
[    0.189288] devtmpfs: initialized
[    0.191313] atomic64 test passed for x86-64 platform with CX8 and 
with SSE
[    0.191618] RTC time:  8:48:49, date: 03/01/13
[    0.191939] NET: Registered protocol family 16
[    0.192257] ACPI FADT declares the system doesn't support PCIe ASPM, 
so disable it
[    0.192982] ACPI: bus type pci registered
[    0.193338] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 
0xe0000000-0xefffffff] (base 0xe0000000)
[    0.193822] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in 
E820
[    0.219308] PCI: Using configuration type 1 for base access
[    0.219585] PCI: Dell PowerEdge 1950 detected, enabling pci=bfsort.
[    0.221703] bio: create slab <bio-0> at 0
[    0.222034] ACPI: Added _OSI(Module Device)
[    0.222288] ACPI: Added _OSI(Processor Device)
[    0.222561] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.222978] ACPI: Added _OSI(Processor Aggregator Device)
[    0.223753] ACPI: EC: Look up EC in DSDT
[    0.224641] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.225091] ACPI Error: [CDW1] Namespace lookup failure, AE_NOT_FOUND 
(20120320/psargs-359)
[    0.225714] ACPI Error: Method parse/execution failed [\_SB_._OSC] 
(Node ffff880429451488), AE_NOT_FOUND (20120320/psparse-536)
[    0.226448] ACPI: Interpreter enabled
[    0.226738] ACPI: (supports S0 S5)
[    0.227224] ACPI: Using IOAPIC for interrupt routing
[    0.233056] ACPI: No dock devices found.
[    0.233479] HEST: Table parsing has been initialized.
[    0.233757] PCI: Using host bridge windows from ACPI; if necessary, 
use "pci=nocrs" and report a bug
[    0.234190] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.234594] pci_root PNP0A08:00: host bridge window [io 0x0000-0x0cf7]
[    0.234976] pci_root PNP0A08:00: host bridge window [io 0x0d00-0xffff]
[    0.235976] pci_root PNP0A08:00: host bridge window [mem 
0x000a0000-0x000bffff]
[    0.236975] pci_root PNP0A08:00: host bridge window [mem 
0xc0000000-0xfdffffff]
[    0.237456] pci_root PNP0A08:00: host bridge window [mem 
0xfed40000-0xfed44fff]
[    0.238020] PCI host bridge to bus 0000:00
[    0.238295] pci_bus 0000:00: root bus resource [io 0x0000-0x0cf7]
[    0.238553] pci_bus 0000:00: root bus resource [io 0x0d00-0xffff]
[    0.238976] pci_bus 0000:00: root bus resource [mem 
0x000a0000-0x000bffff]
[    0.239235] pci_bus 0000:00: root bus resource [mem 
0xc0000000-0xfdffffff]
[    0.239515] pci_bus 0000:00: root bus resource [mem 
0xfed40000-0xfed44fff]
[    0.239796] pci 0000:00:00.0: [8086:25c0] type 00 class 0x060000
[    0.240013] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    0.240039] pci 0000:00:02.0: [8086:25e2] type 01 class 0x060400
[    0.240082] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.240100] pci 0000:00:03.0: [8086:25e3] type 01 class 0x060400
[    0.240163] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.240181] pci 0000:00:04.0: [8086:25f8] type 01 class 0x060400
[    0.240225] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.240243] pci 0000:00:05.0: [8086:25e5] type 01 class 0x060400
[    0.240285] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    0.240303] pci 0000:00:06.0: [8086:25f9] type 01 class 0x060400
[    0.240346] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    0.240364] pci 0000:00:07.0: [8086:25e7] type 01 class 0x060400
[    0.240406] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.240427] pci 0000:00:10.0: [8086:25f0] type 00 class 0x060000
[    0.240457] pci 0000:00:10.1: [8086:25f0] type 00 class 0x060000
[    0.240488] pci 0000:00:10.2: [8086:25f0] type 00 class 0x060000
[    0.240522] pci 0000:00:11.0: [8086:25f1] type 00 class 0x060000
[    0.240560] pci 0000:00:13.0: [8086:25f3] type 00 class 0x060000
[    0.240624] pci 0000:00:15.0: [8086:25f5] type 00 class 0x060000
[    0.240660] pci 0000:00:16.0: [8086:25f6] type 00 class 0x060000
[    0.240699] pci 0000:00:1c.0: [8086:2690] type 01 class 0x060400
[    0.240767] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.240795] pci 0000:00:1d.0: [8086:2688] type 00 class 0x0c0300
[    0.240835] pci 0000:00:1d.0: reg 20: [io  0xdce0-0xdcff]
[    0.240867] pci 0000:00:1d.1: [8086:2689] type 00 class 0x0c0300
[    0.240907] pci 0000:00:1d.1: reg 20: [io  0xdcc0-0xdcdf]
[    0.240955] pci 0000:00:1d.2: [8086:268a] type 00 class 0x0c0300
[    0.241001] pci 0000:00:1d.2: reg 20: [io  0xdca0-0xdcbf]
[    0.241043] pci 0000:00:1d.7: [8086:268c] type 00 class 0x0c0320
[    0.241062] pci 0000:00:1d.7: reg 10: [mem 0xfc600000-0xfc6003ff]
[    0.241143] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.241184] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    0.241243] pci 0000:00:1f.0: [8086:2670] type 00 class 0x060100
[    0.241329] pci 0000:00:1f.1: [8086:269e] type 00 class 0x01018a
[    0.241342] pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
[    0.241351] pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
[    0.241361] pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
[    0.241370] pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
[    0.241379] pci 0000:00:1f.1: reg 20: [io  0xfc00-0xfc0f]
[    0.241758] pci 0000:06:00.0: [8086:3500] type 01 class 0x060400
[    0.244796] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
[    0.245758] pci 0000:06:00.3: [8086:350c] type 01 class 0x060400
[    0.248062] pci 0000:06:00.3: PME# supported from D0 D3hot D3cold
[    0.250072] pci 0000:00:02.0: PCI bridge to [bus 06-0b]
[    0.250340] pci 0000:00:02.0:   bridge window [mem 
0xf2000000-0xf7ffffff]
[    0.252107] pci 0000:07:00.0: [8086:3510] type 01 class 0x060400
[    0.255519] pci 0000:07:00.0: PME# supported from D0 D3hot D3cold
[    0.256473] pci 0000:07:01.0: [8086:3514] type 01 class 0x060400
[    0.259885] pci 0000:07:01.0: PME# supported from D0 D3hot D3cold
[    0.261794] pci 0000:06:00.0: PCI bridge to [bus 07-0a]
[    0.262152] pci 0000:06:00.0:   bridge window [mem 
0xf4000000-0xf7ffffff]
[    0.264564] pci 0000:08:00.0: [1166:0103] type 01 class 0x060400
[    0.267518] pci 0000:08:00.0: PME# supported from D0 D3hot D3cold
[    0.268793] pci 0000:07:00.0: PCI bridge to [bus 08-09]
[    0.269126] pci 0000:07:00.0:   bridge window [mem 
0xf4000000-0xf7ffffff]
[    0.271105] pci 0000:09:00.0: [14e4:164c] type 00 class 0x020000
[    0.271884] pci 0000:09:00.0: reg 10: [mem 0xf4000000-0xf5ffffff 64bit]
[    0.275426] pci 0000:09:00.0: PME# supported from D3hot D3cold
[    0.277287] pci 0000:08:00.0: PCI bridge to [bus 09-09]
[    0.277791] pci 0000:08:00.0:   bridge window [mem 
0xf4000000-0xf7ffffff]
[    0.280012] pci 0000:07:01.0: PCI bridge to [bus 0a-0a]
[    0.283653] pci 0000:06:00.3: PCI bridge to [bus 0b-0b]
[    0.284730] pci 0000:01:00.0: [8086:0370] type 01 class 0x060400
[    0.284810] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    0.284834] pci 0000:01:00.2: [8086:0372] type 01 class 0x060400
[    0.284894] pci 0000:01:00.2: PME# supported from D0 D3hot D3cold
[    0.285976] pci 0000:00:03.0: PCI bridge to [bus 01-03]
[    0.286247] pci 0000:00:03.0:   bridge window [mem 
0xfc300000-0xfc5fffff]
[    0.286252] pci 0000:00:03.0:   bridge window [mem 
0xd8000000-0xd80fffff 64bit pref]
[    0.286356] pci 0000:02:0e.0: [1028:0015] type 00 class 0x010400
[    0.286381] pci 0000:02:0e.0: reg 10: [mem 0xd80f0000-0xd80fffff pref]
[    0.286400] pci 0000:02:0e.0: reg 18: [mem 0xfc5c0000-0xfc5dffff]
[    0.286435] pci 0000:02:0e.0: reg 30: [mem 0xfc400000-0xfc407fff pref]
[    0.286481] pci 0000:02:0e.0: supports D1
[    0.286510] pci 0000:01:00.0: PCI bridge to [bus 02-02]
[    0.286770] pci 0000:01:00.0:   bridge window [mem 
0xfc400000-0xfc5fffff]
[    0.286776] pci 0000:01:00.0:   bridge window [mem 
0xd8000000-0xd80fffff 64bit pref]
[    0.286838] pci 0000:01:00.2: PCI bridge to [bus 03-03]
[    0.287006] pci 0000:00:04.0: PCI bridge to [bus 0c-0c]
[    0.287311] pci 0000:00:05.0: PCI bridge to [bus 0d-0d]
[    0.287595] pci 0000:00:06.0: PCI bridge to [bus 0e-0e]
[    0.287997] pci 0000:00:07.0: PCI bridge to [bus 0f-0f]
[    0.288325] pci 0000:04:00.0: [1166:0103] type 01 class 0x060400
[    0.288408] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
[    0.289977] pci 0000:00:1c.0: PCI bridge to [bus 04-05]
[    0.290268] pci 0000:00:1c.0:   bridge window [mem 
0xf8000000-0xfbffffff]
[    0.290326] pci 0000:05:00.0: [14e4:164c] type 00 class 0x020000
[    0.290352] pci 0000:05:00.0: reg 10: [mem 0xf8000000-0xf9ffffff 64bit]
[    0.290477] pci 0000:05:00.0: PME# supported from D3hot D3cold
[    0.290535] pci 0000:04:00.0: PCI bridge to [bus 05-05]
[    0.290798] pci 0000:04:00.0:   bridge window [mem 
0xf8000000-0xfbffffff]
[    0.290862] pci 0000:10:0d.0: [1002:515e] type 00 class 0x030000
[    0.290880] pci 0000:10:0d.0: reg 10: [mem 0xd0000000-0xd7ffffff pref]
[    0.290891] pci 0000:10:0d.0: reg 14: [io  0xec00-0xecff]
[    0.290902] pci 0000:10:0d.0: reg 18: [mem 0xfc2d0000-0xfc2dffff]
[    0.290937] pci 0000:10:0d.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.290970] pci 0000:10:0d.0: supports D1 D2
[    0.291010] pci 0000:00:1e.0: PCI bridge to [bus 10-10] (subtractive 
decode)
[    0.291270] pci 0000:00:1e.0:   bridge window [io 0xe000-0xefff]
[    0.291274] pci 0000:00:1e.0:   bridge window [mem 
0xfc100000-0xfc2fffff]
[    0.291281] pci 0000:00:1e.0:   bridge window [mem 
0xd0000000-0xd7ffffff 64bit pref]
[    0.291284] pci 0000:00:1e.0:   bridge window [io 0x0000-0x0cf7] 
(subtractive decode)
[    0.291287] pci 0000:00:1e.0:   bridge window [io 0x0d00-0xffff] 
(subtractive decode)
[    0.291289] pci 0000:00:1e.0:   bridge window [mem 
0x000a0000-0x000bffff] (subtractive decode)
[    0.291292] pci 0000:00:1e.0:   bridge window [mem 
0xc0000000-0xfdffffff] (subtractive decode)
[    0.291295] pci 0000:00:1e.0:   bridge window [mem 
0xfed40000-0xfed44fff] (subtractive decode)
[    0.291323] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.291646] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]
[    0.291728] ACPI: PCI Interrupt Routing Table 
[\_SB_.PCI0.PEX2.UPST._PRT]
[    0.291786] ACPI: PCI Interrupt Routing Table 
[\_SB_.PCI0.PEX2.UPST.DWN1._PRT]
[    0.291869] ACPI: PCI Interrupt Routing Table 
[\_SB_.PCI0.PEX2.UPST.DWN2._PRT]
[    0.291947] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
[    0.292038] ACPI: PCI Interrupt Routing Table 
[\_SB_.PCI0.PEX3.PE2P._PRT]
[    0.292104] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[    0.292182] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX6._PRT]
[    0.292261] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.SBEX._PRT]
[    0.292342] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.COMP._PRT]
[    0.292513]  pci0000:00: Requesting ACPI _OSC control (0x15)
[    0.293006]  pci0000:00: ACPI _OSC control (0x15) granted
[    0.297078] ACPI: PCI Interrupt Link [LK00] (IRQs 3 4 *5 6 7 10 11 12)
[    0.297883] ACPI: PCI Interrupt Link [LK01] (IRQs 3 4 5 6 7 10 11 12 
<tel:4%205%206%207%2010%2011%2012>) *0, disabled.
[    0.298994] ACPI: PCI Interrupt Link [LK02] (IRQs 3 4 5 *6 7 10 11 12)
[    0.299790] ACPI: PCI Interrupt Link [LK03] (IRQs 3 4 5 6 7 10 *11 12)
[    0.300560] ACPI: PCI Interrupt Link [LK04] (IRQs 3 4 5 6 7 *10 11 12)
[    0.301359] ACPI: PCI Interrupt Link [LK05] (IRQs 3 4 5 6 7 10 *11 12)
[    0.302023] ACPI: PCI Interrupt Link [LK06] (IRQs 3 4 5 6 7 10 11 12 
<tel:4%205%206%207%2010%2011%2012>) *0, disabled.
[    0.303267] ACPI: PCI Interrupt Link [LK07] (IRQs 3 4 5 6 7 10 11 12 
<tel:4%205%206%207%2010%2011%2012>) *0, disabled.
[    0.304287] vgaarb: device added: 
PCI:0000:10:0d.0,decodes=io+mem,owns=io+mem,locks=none
[    0.304966] vgaarb: loaded
[    0.305215] vgaarb: bridge control possible 0000:10:0d.0
[    0.305586] SCSI subsystem initialized
[    0.305852] libata version 3.00 loaded.
[    0.306035] usbcore: registered new interface driver usbfs
[    0.306357] usbcore: registered new interface driver hub
[    0.306639] usbcore: registered new device driver usb
[    0.307025] PCI: Using ACPI for IRQ routing
[    0.313371] PCI: pci_cache_line_size set to 64 bytes
[    0.313976] reserve RAM buffer: 00000000bfb50000 - 00000000bfffffff
[    0.314101] NetLabel: Initializing
[    0.314385] NetLabel:  domain hash size = 128
[    0.314638] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.314925] NetLabel:  unlabeled traffic allowed by default
[    0.315008] HPET: 3 timers in total, 0 timers will be used for 
per-cpu timer
[    0.315289] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.315964] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.323045] Switching to clocksource hpet
[    0.335726] pnp: PnP ACPI init
[    0.336016] ACPI: bus type pnp registered
[    0.336410] pnp 00:00: [bus 00-ff]
[    0.336413] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.336416] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.336422] pnp 00:00: [io  0x0d00-0xffff window]
[    0.336424] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.336427] pnp 00:00: [mem 0xc0000000-0xfdffffff window]
[    0.336429] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[    0.336491] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 
(active)
[    0.336548] pnp 00:01: [io  0x0080-0x009f]
[    0.336551] pnp 00:01: [io  0x0000-0x001f]
[    0.336553] pnp 00:01: [io  0x00c0-0x00df]
[    0.336556] pnp 00:01: [dma 4]
[    0.336590] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.336613] pnp 00:02: [io  0x00f0-0x00ff]
[    0.336626] pnp 00:02: [irq 13]
[    0.336656] pnp 00:02: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.336680] pnp 00:03: [io  0x0061]
[    0.336770] system 00:03: Plug and Play ACPI device, IDs PNP0c01 
(active)
[    0.336792] pnp 00:04: [io  0x0070-0x007f]
[    0.336798] pnp 00:04: [irq 8]
[    0.336838] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.336977] pnp 00:05: Plug and Play ACPI device, IDs PNP0700 (disabled)
[    0.337154] pnp 00:06: [io  0x03f8-0x03ff]
[    0.337161] pnp 00:06: [irq 4]
[    0.337269] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.337431] pnp 00:07: [io  0x02f8-0x02ff]
[    0.337438] pnp 00:07: [irq 3]
[    0.337536] pnp 00:07: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.340250] pnp 00:08: [io  0x0800-0x087f]
[    0.340253] pnp 00:08: [io  0x0880-0x08bf]
[    0.340255] pnp 00:08: [io  0x08c0-0x08df]
[    0.340257] pnp 00:08: [io  0x08e0-0x08e3]
[    0.340260] pnp 00:08: [io  0x0900]
[    0.340262] pnp 00:08: [io  0x0c00-0x0c7f]
[    0.340264] pnp 00:08: [io  0x0ca0-0x0ca7]
[    0.340266] pnp 00:08: [io  0x0ca9-0x0cab]
[    0.340268] pnp 00:08: [io  0x0cad-0x0caf]
[    0.340270] pnp 00:08: [io  0x0060]
[    0.340272] pnp 00:08: [io  0x0064]
[    0.340341] system 00:08: [io  0x0800-0x087f] has been reserved
[    0.340598] system 00:08: [io  0x0880-0x08bf] has been reserved
[    0.340856] system 00:08: [io  0x08c0-0x08df] has been reserved
[    0.341124] system 00:08: [io  0x08e0-0x08e3] has been reserved
[    0.341381] system 00:08: [io  0x0900] has been reserved
[    0.341638] system 00:08: [io  0x0c00-0x0c7f] has been reserved
[    0.341895] system 00:08: [io  0x0ca0-0x0ca7] has been reserved
[    0.342160] system 00:08: [io  0x0ca9-0x0cab] has been reserved
[    0.342418] system 00:08: [io  0x0cad-0x0caf] has been reserved
[    0.342676] system 00:08: Plug and Play ACPI device, IDs PNP0c01 
(active)
[    0.342725] pnp 00:09: [io  0x0ca8]
[    0.342727] pnp 00:09: [io  0x0cac]
[    0.342786] system 00:09: [io  0x0ca8] has been reserved
[    0.343051] system 00:09: [io  0x0cac] has been reserved
[    0.343310] system 00:09: Plug and Play ACPI device, IDs IPI0001 
PNP0c01 (active)
[    0.344088] pnp 00:0a: [mem 0xe0000000-0xefffffff]
[    0.344153] system 00:0a: [mem 0xe0000000-0xefffffff] has been reserved
[    0.344414] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 
(active)
[    0.344452] pnp 00:0b: [mem 0xfed00000-0xfed003ff]
[    0.344488] pnp 00:0b: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.344663] pnp: PnP ACPI: found 12 devices
[    0.344917] ACPI: ACPI bus type pnp unregistered
[    0.355135] pci 0000:08:00.0: PCI bridge to [bus 09-09]
[    0.355487] pci 0000:08:00.0:   bridge window [mem 
0xf4000000-0xf7ffffff]
[    0.355990] pci 0000:07:00.0: PCI bridge to [bus 08-09]
[    0.356359] pci 0000:07:00.0:   bridge window [mem 
0xf4000000-0xf7ffffff]
[    0.356863] pci 0000:07:01.0: PCI bridge to [bus 0a-0a]
[    0.357506] pci 0000:06:00.0: PCI bridge to [bus 07-0a]
[    0.357873] pci 0000:06:00.0:   bridge window [mem 
0xf4000000-0xf7ffffff]
[    0.358379] pci 0000:06:00.3: PCI bridge to [bus 0b-0b]
[    0.359027] pci 0000:00:02.0: PCI bridge to [bus 06-0b]
[    0.359285] pci 0000:00:02.0:   bridge window [mem 
0xf2000000-0xf7ffffff]
[    0.359548] pci 0000:01:00.0: PCI bridge to [bus 02-02]
[    0.359807] pci 0000:01:00.0:   bridge window [mem 
0xfc400000-0xfc5fffff]
[    0.360076] pci 0000:01:00.0:   bridge window [mem 
0xd8000000-0xd80fffff 64bit pref]
[    0.360541] pci 0000:01:00.2: PCI bridge to [bus 03-03]
[    0.360804] pci 0000:00:03.0: PCI bridge to [bus 01-03]
[    0.361070] pci 0000:00:03.0:   bridge window [mem 
0xfc300000-0xfc5fffff]
[    0.361329] pci 0000:00:03.0:   bridge window [mem 
0xd8000000-0xd80fffff 64bit pref]
[    0.361790] pci 0000:00:04.0: PCI bridge to [bus 0c-0c]
[    0.362057] pci 0000:00:05.0: PCI bridge to [bus 0d-0d]
[    0.362317] pci 0000:00:06.0: PCI bridge to [bus 0e-0e]
[    0.362578] pci 0000:00:07.0: PCI bridge to [bus 0f-0f]
[    0.362839] pci 0000:04:00.0: PCI bridge to [bus 05-05]
[    0.363106] pci 0000:04:00.0:   bridge window [mem 
0xf8000000-0xfbffffff]
[    0.363372] pci 0000:00:1c.0: PCI bridge to [bus 04-05]
[    0.363630] pci 0000:00:1c.0:   bridge window [mem 
0xf8000000-0xfbffffff]
[    0.363897] pci 0000:10:0d.0: BAR 6: assigned [mem 
0xfc100000-0xfc11ffff pref]
[    0.364366] pci 0000:00:1e.0: PCI bridge to [bus 10-10]
[    0.364623] pci 0000:00:1e.0:   bridge window [io 0xe000-0xefff]
[    0.364883] pci 0000:00:1e.0:   bridge window [mem 
0xfc100000-0xfc2fffff]
[    0.365151] pci 0000:00:1e.0:   bridge window [mem 
0xd0000000-0xd7ffffff 64bit pref]
[    0.366307] pci 0000:00:1e.0: setting latency timer to 64
[    0.366311] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.366314] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.366317] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.366319] pci_bus 0000:00: resource 7 [mem 0xc0000000-0xfdffffff]
[    0.366322] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed44fff]
[    0.366325] pci_bus 0000:06: resource 1 [mem 0xf2000000-0xf7ffffff]
[    0.366327] pci_bus 0000:07: resource 1 [mem 0xf4000000-0xf7ffffff]
[    0.366330] pci_bus 0000:08: resource 1 [mem 0xf4000000-0xf7ffffff]
[    0.366333] pci_bus 0000:09: resource 1 [mem 0xf4000000-0xf7ffffff]
[    0.366336] pci_bus 0000:01: resource 1 [mem 0xfc300000-0xfc5fffff]
[    0.366338] pci_bus 0000:01: resource 2 [mem 0xd8000000-0xd80fffff 
64bit pref]
[    0.366341] pci_bus 0000:02: resource 1 [mem 0xfc400000-0xfc5fffff]
[    0.366343] pci_bus 0000:02: resource 2 [mem 0xd8000000-0xd80fffff 
64bit pref]
[    0.366347] pci_bus 0000:04: resource 1 [mem 0xf8000000-0xfbffffff]
[    0.366349] pci_bus 0000:05: resource 1 [mem 0xf8000000-0xfbffffff]
[    0.366352] pci_bus 0000:10: resource 0 [io  0xe000-0xefff]
[    0.366355] pci_bus 0000:10: resource 1 [mem 0xfc100000-0xfc2fffff]
[    0.366357] pci_bus 0000:10: resource 2 [mem 0xd0000000-0xd7ffffff 
64bit pref]
[    0.366360] pci_bus 0000:10: resource 4 [io  0x0000-0x0cf7]
[    0.366362] pci_bus 0000:10: resource 5 [io  0x0d00-0xffff]
[    0.366365] pci_bus 0000:10: resource 6 [mem 0x000a0000-0x000bffff]
[    0.366367] pci_bus 0000:10: resource 7 [mem 0xc0000000-0xfdffffff]
[    0.366370] pci_bus 0000:10: resource 8 [mem 0xfed40000-0xfed44fff]
[    0.366436] NET: Registered protocol family 2
[    0.367278] IP route cache hash table entries: 524288 (order: 10, 
4194304 bytes)
[    0.370556] TCP established hash table entries: 524288 (order: 11, 
8388608 bytes)
[    0.375082] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.375830] TCP: Hash tables configured (established 524288 bind 65536)
[    0.376101] TCP: reno registered
[    0.376386] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.376798] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    0.377300] NET: Registered protocol family 1
[    0.377731] RPC: Registered named UNIX socket transport module.
[    0.378000] RPC: Registered udp transport module.
[    0.378265] RPC: Registered tcp transport module.
[    0.378519] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.378964] pci 0000:00:1f.0: rerouting interrupts for [8086:2670]
[    0.379252] pci 0000:01:00.0: rerouting interrupts for [8086:0370]
[    0.379511] pci 0000:01:00.2: rerouting interrupts for [8086:0372]
[    0.380023] pci 0000:10:0d.0: Boot video device
[    0.380027] PCI: CLS 64 bytes, default 64
[    0.397347] Unpacking initramfs...
[    1.621449] Freeing initrd memory: 11364k freed
[    1.627148] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.627412] Placing 64MB software IO TLB between ffff8800bbb42000 - 
ffff8800bfb42000
[    1.627872] software IO TLB at phys 0xbbb42000 - 0xbfb42000
[    1.630400] audit: initializing netlink socket (disabled)
[    1.630671] type=2000 audit(1362127730.629:1): initialized
[    1.672491] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.677212] VFS: Disk quotas dquot_6.5.2
[    1.677528] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.678321] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    1.678724] NFS: Registering the id_resolver key type
[    1.679196] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[    1.679473] NTFS driver 2.1.30 [Flags: R/O].
[    1.679862] fuse init (API version 7.18)
[    1.680397] JFS: nTxBlock = 8192, nTxLock = 65536
[    1.684258] SGI XFS with ACLs, security attributes, realtime, large 
block/inode numbers, no debug enabled
[    1.685669] Btrfs loaded
[    1.686083] aufs 3.4-20121126
[    1.686350] msgmni has been set to 32066
[    1.687273] alg: No test for stdrng (krng)
[    1.687585] NET: Registered protocol family 38
[    1.687892] Block layer SCSI generic (bsg) driver version 0.4 loaded 
(major 253)
[    1.688442] io scheduler noop registered
[    1.688708] io scheduler deadline registered
[    1.689042] io scheduler cfq registered (default)
[    1.689513] pcieport 0000:00:02.0: irq 104 for MSI/MSI-X
[    1.689590] pcieport 0000:00:03.0: irq 105 for MSI/MSI-X
[    1.689668] pcieport 0000:00:04.0: irq 106 for MSI/MSI-X
[    1.689739] pcieport 0000:00:05.0: irq 107 for MSI/MSI-X
[    1.689815] pcieport 0000:00:06.0: irq 108 for MSI/MSI-X
[    1.689887] pcieport 0000:00:07.0: irq 109 for MSI/MSI-X
[    1.689976] pcieport 0000:00:1c.0: irq 110 for MSI/MSI-X
[    1.694129] pcieport 0000:00:02.0: Signaling PME through PCIe PME 
interrupt
[    1.694389] pcieport 0000:06:00.0: Signaling PME through PCIe PME 
interrupt
[    1.694649] pcieport 0000:07:00.0: Signaling PME through PCIe PME 
interrupt
[    1.694907] pci 0000:08:00.0: Signaling PME through PCIe PME interrupt
[    1.695198] pci 0000:09:00.0: Signaling PME through PCIe PME interrupt
[    1.695456] pcieport 0000:07:01.0: Signaling PME through PCIe PME 
interrupt
[    1.695715] pci 0000:06:00.3: Signaling PME through PCIe PME interrupt
[    1.695975] pcie_pme 0000:00:02.0:pcie01: service driver pcie_pme loaded
[    1.695996] pcieport 0000:00:03.0: Signaling PME through PCIe PME 
interrupt
[    1.696284] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    1.696541] pci 0000:02:0e.0: Signaling PME through PCIe PME interrupt
[    1.696800] pci 0000:01:00.2: Signaling PME through PCIe PME interrupt
[    1.697087] pcie_pme 0000:00:03.0:pcie01: service driver pcie_pme loaded
[    1.697104] pcieport 0000:00:04.0: Signaling PME through PCIe PME 
interrupt
[    1.697365] pcie_pme 0000:00:04.0:pcie01: service driver pcie_pme loaded
[    1.697382] pcieport 0000:00:05.0: Signaling PME through PCIe PME 
interrupt
[    1.697642] pcie_pme 0000:00:05.0:pcie01: service driver pcie_pme loaded
[    1.697662] pcieport 0000:00:06.0: Signaling PME through PCIe PME 
interrupt
[    1.697923] pcie_pme 0000:00:06.0:pcie01: service driver pcie_pme loaded
[    1.697939] pcieport 0000:00:07.0: Signaling PME through PCIe PME 
interrupt
[    1.698229] pcie_pme 0000:00:07.0:pcie01: service driver pcie_pme loaded
[    1.698248] pcieport 0000:00:1c.0: Signaling PME through PCIe PME 
interrupt
[    1.698509] pci 0000:04:00.0: Signaling PME through PCIe PME interrupt
[    1.698767] pci 0000:05:00.0: Signaling PME through PCIe PME interrupt
[    1.699051] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    1.699085] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.699360] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.699618] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    1.700195] intel_idle: does not run on family 6 model 15
[    1.700282] input: Power Button as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    1.700746] ACPI: Power Button [PWRF]
[    1.709930] ERST: Failed to get Error Log Address Range.
[    1.722228] GHES: APEI firmware first mode is enabled by WHEA _OSC.
[    1.722610] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    1.743422] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.764295] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.787126] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.808062] 00:07: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.808887] Non-volatile memory driver v1.3
[    1.809184] Linux agpgart interface v0.103
[    1.810715] loop: module loaded
[    1.811081] ata_piix 0000:00:1f.1: version 2.13
[    1.811141] ata_piix 0000:00:1f.1: setting latency timer to 64
[    1.811537] scsi0 : ata_piix
[    1.811909] scsi1 : ata_piix
[    1.812227] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xfc00 
irq 14
[    1.812487] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xfc08 
irq 15
[    1.812830] Fixed MDIO Bus: probed
[    1.813009] ata2: port disabled--ignoring
[    1.813238] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.813564] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.813568] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.813926] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned 
bus number 1
[    1.814453] ehci_hcd 0000:00:1d.7: debug port 1
[    1.818600] ehci_hcd 0000:00:1d.7: cache line size of 64 is not 
supported
[    1.818617] ehci_hcd 0000:00:1d.7: irq 21, io mem 0xfc600000
[    1.824036] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.824328] usb usb1: New USB device found, idVendor=1d6b, 
idProduct=0002
[    1.824587] usb usb1: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    1.825056] usb usb1: Product: EHCI Host Controller
[    1.825311] usb usb1: Manufacturer: Linux 3.4.32-std341-amd64 ehci_hcd
[    1.825569] usb usb1: SerialNumber: 0000:00:1d.7
[    1.825986] hub 1-0:1.0: USB hub found
[    1.826284] hub 1-0:1.0: 6 ports detected
[    1.826634] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.826903] uhci_hcd: USB Universal Host Controller Interface driver
[    1.827208] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.827211] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.827545] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned 
bus number 2
[    1.828057] uhci_hcd 0000:00:1d.0: irq 21, io base 0x0000dce0
[    1.828358] usb usb2: New USB device found, idVendor=1d6b, 
idProduct=0001
[    1.828616] usb usb2: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    1.829115] usb usb2: Product: UHCI Host Controller
[    1.829371] usb usb2: Manufacturer: Linux 3.4.32-std341-amd64 uhci_hcd
[    1.829630] usb usb2: SerialNumber: 0000:00:1d.0
[    1.830036] hub 2-0:1.0: USB hub found
[    1.830304] hub 2-0:1.0: 2 ports detected
[    1.830638] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    1.830642] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.830976] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned 
bus number 3
[    1.831498] uhci_hcd 0000:00:1d.1: irq 20, io base 0x0000dcc0
[    1.831788] usb usb3: New USB device found, idVendor=1d6b, 
idProduct=0001
[    1.832065] usb usb3: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    1.832524] usb usb3: Product: UHCI Host Controller
[    1.832780] usb usb3: Manufacturer: Linux 3.4.32-std341-amd64 uhci_hcd
[    1.833064] usb usb3: SerialNumber: 0000:00:1d.1
[    1.833473] hub 3-0:1.0: USB hub found
[    1.833739] hub 3-0:1.0: 2 ports detected
[    1.834109] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    1.834112] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.834469] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned 
bus number 4
[    1.834961] uhci_hcd 0000:00:1d.2: irq 21, io base 0x0000dca0
[    1.835279] usb usb4: New USB device found, idVendor=1d6b, 
idProduct=0001
[    1.835538] usb usb4: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    1.835998] usb usb4: Product: UHCI Host Controller
[    1.836282] usb usb4: Manufacturer: Linux 3.4.32-std341-amd64 uhci_hcd
[    1.836540] usb usb4: SerialNumber: 0000:00:1d.2
[    1.836942] hub 4-0:1.0: USB hub found
[    1.837220] hub 4-0:1.0: 2 ports detected
[    1.837605] usbcore: registered new interface driver usbserial
[    1.837876] usbcore: registered new interface driver usbserial_generic
[    1.838172] USB Serial support registered for generic
[    1.838428] usbserial: USB Serial Driver core
[    1.838732] i8042: PNP: No PS/2 controller found. Probing ports 
directly.
[    1.841726] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.842014] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.842394] mousedev: PS/2 mouse device common for all mice
[    1.842838] rtc_cmos 00:04: RTC can wake from S4
[    1.843262] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    1.843542] rtc0: alarms up to one day, y3k, 242 bytes nvram, hpet irqs
[    1.843907] device-mapper: uevent: version 1.0.3
[    1.844252] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) 
initialised: dm-devel@redhat.com <mailto:dm-devel@redhat.com>
[    1.844764] cpuidle: using governor ladder
[    1.845028] cpuidle: using governor menu
[    1.845877] EFI Variables Facility v0.08 2004-May-17
[    1.846297] usbcore: registered new interface driver usbhid
[    1.846553] usbhid: USB HID core driver
[    1.846964] ip_tables: (C) 2000-2006 Netfilter Core Team
[    1.847429] TCP: cubic registered
[    1.847686] Initializing XFRM netlink socket
[    1.848190] NET: Registered protocol family 10
[    1.848715] Mobile IPv6
[    1.848966] NET: Registered protocol family 17
[    1.849280] Registering the dns_resolver key type
[    1.849833] registered taskstats version 1
[    1.854519]   Magic number: 5:688:825
[    1.854913] rtc_cmos 00:04: setting system clock to 2013-03-01 
08:48:51 UTC (1362127731)
[    1.855440] p4-clockmod: Warning: EST-capable CPU detected. The 
acpi-cpufreq module offers voltage scaling in addition to frequency 
scaling. You should use that instead of p4-clockmod, if possible.
[    1.856165] ondemand governor failed, too long transition latency of 
HW, fallback to performance governor
[    1.856665] ondemand governor failed, too long transition latency of 
HW, fallback to performance governor
[    1.857181] ondemand governor failed, too long transition latency of 
HW, fallback to performance governor
[    1.857671] ondemand governor failed, too long transition latency of 
HW, fallback to performance governor
[    1.858165] ondemand governor failed, too long transition latency of 
HW, fallback to performance governor
[    1.858659] ondemand governor failed, too long transition latency of 
HW, fallback to performance governor
[    1.859165] ondemand governor failed, too long transition latency of 
HW, fallback to performance governor
[    1.859649] ondemand governor failed, too long transition latency of 
HW, fallback to performance governor
[    1.860131] p4-clockmod: P4/Xeon(TM) CPU On-Demand Clock Modulation 
available
[    1.860429] Initializing network drop monitor service
[    1.966340] ata1.00: ATAPI: HL-DT-STDVD-ROM GDR-T10N, 1.02, max UDMA/33
[    1.972207] ata1.00: configured for UDMA/33
[    1.975483] scsi 0:0:0:0: CD-ROM            HL-DT-ST DVD-ROM GDR-T10N 
1.02 PQ: 0 ANSI: 5
[    1.978052] sr0: scsi3-mmc drive: 24x/24x cd/rw xa/form2 cdda tray
[    1.978321] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.978778] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    1.978904] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    1.983289] Freeing unused kernel memory: 9712k freed
[    1.987953] Write protecting the kernel read-only data: 12288k
[    1.994769] Freeing unused kernel memory: 1368k freed
[    1.999791] Freeing unused kernel memory: 880k freed
[    2.128051] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    2.242582] usb 1-1: New USB device found, idVendor=413c, idProduct=a001
[    2.242586] usb 1-1: New USB device strings: Mfr=0, Product=0, 
SerialNumber=0
[    2.242899] hub 1-1:1.0: USB hub found
[    2.243059] hub 1-1:1.0: 2 ports detected
[    2.323729] bnx2: Broadcom NetXtreme II Gigabit Ethernet Driver bnx2 
v2.2.1 (Dec 18, 2011)
[    2.328558] megasas: 00.00.06.14-rc1 Fri. Jan. 6 17:00:00 PDT 2012
[    2.328593] megasas: 0x1028:0x0015:0x1028:0x1f03: bus 2:slot 14:func 0
[    2.328607] megaraid_sas 0000:02:0e.0: PCI IRQ 78 -> rerouted to 
legacy IRQ 18
[    2.329642] megasas: FW now in Ready state
[    2.337046] [drm] Initialized drm 1.1.0 20060810
[    2.354260] [drm] radeon defaulting to kernel modesetting.
[    2.354264] [drm] radeon kernel modesetting enabled.
[    2.354659] [drm] initializing kernel modesetting (RV100 
0x1002:0x515E 0x1028:0x01B3).
[    2.354682] [drm] register mmio base: 0xFC2D0000
[    2.354684] [drm] register mmio size: 65536
[    2.354858] radeon 0000:10:0d.0: VRAM: 128M 0x00000000D0000000 - 
0x00000000D7FFFFFF (16M used)
[    2.354862] radeon 0000:10:0d.0: GTT: 512M 0x00000000B0000000 - 
0x00000000CFFFFFFF
[    2.354869] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    2.354871] [drm] Driver supports precise vblank timestamp query.
[    2.354894] [drm] radeon: irq initialized.
[    2.361161] [drm] Detected VRAM RAM=128M, BAR=128M
[    2.361165] [drm] RAM width 16bits DDR
[    2.361336] [TTM] Zone  kernel: Available graphics memory: 8215022 kiB
[    2.361339] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[    2.361341] [TTM] Initializing pool allocator
[    2.361349] [TTM] Initializing DMA pool allocator
[    2.361408] [drm] radeon: 16M of VRAM memory ready
[    2.361411] [drm] radeon: 512M of GTT memory ready.
[    2.361445] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    2.362845] [drm] radeon: ib pool ready.
[    2.383562] [drm] PCIE GART of 512M enabled (table at 
0x000000007FA00000).
[    2.383593] radeon 0000:10:0d.0: WB disabled
[    2.383597] [drm] fence driver on ring 0 use gpu addr 0xb0000000 and 
cpu addr 0xffff88007f9b7000
[    2.383653] [drm] Loading R100 Microcode
[    2.386709] [drm] radeon: ring at 0x00000000B0001000
[    2.386731] [drm] ring test succeeded in 1 usecs
[    2.387390] [drm] ib test succeeded in 0 usecs
[    2.387634] [drm] Radeon Display Connectors
[    2.387636] [drm] Connector 0:
[    2.387638] [drm]   VGA
[    2.387640] [drm]   DDC: 0x60 0x60 0x60 0x60 0x60 0x60 0x60 0x60
[    2.387642] [drm]   Encoders:
[    2.387644] [drm]     CRT1: INTERNAL_DAC1
[    2.396055] usb 1-5: new high-speed USB device number 4 using ehci_hcd
[    2.429221] [drm] fb mappable at 0xD0040000
[    2.429223] [drm] vram apper at 0xD0000000
[    2.429225] [drm] size 786432
[    2.429227] [drm] fb depth is 8
[    2.429228] [drm]    pitch is 1024
[    2.429321] fbcon: radeondrmfb (fb0) is primary device
[    2.510458] usb 1-5: New USB device found, idVendor=04b4, idProduct=6560
[    2.510461] usb 1-5: New USB device strings: Mfr=0, Product=0, 
SerialNumber=0
[    2.510714] hub 1-5:1.0: USB hub found
[    2.510807] hub 1-5:1.0: 4 ports detected
[    2.592072] Console: switching to colour frame buffer device 128x48
[    2.599727] fb0: radeondrmfb frame buffer device
[    2.599730] drm: registered panic notifier
[    2.599737] [drm] Initialized radeon 2.16.0 20080528 for 0000:10:0d.0 
on minor 0
[    2.630037] Refined TSC clocksource calibration: 2327.523 MHz.
[    2.630045] Switching to clocksource tsc
[    2.659439] bnx2 0000:05:00.0: eth0: Broadcom NetXtreme II BCM5708 
1000Base-T (B2) PCI-X 64-bit 133MHz found at mem f8000000, IRQ 16, node 
addr 00:1d:09:65:5f:4d
[    2.717059] usb 3-2: new low-speed USB device number 2 using uhci_hcd
[    2.861810] usb 3-2: New USB device found, idVendor=0566, idProduct=3108
[    2.861814] usb 3-2: New USB device strings: Mfr=0, Product=0, 
SerialNumber=0
[    2.878099] input: HID 0566:3108 as 
/devices/pci0000:00/0000:00:1d.1/usb3/3-2/3-2:1.0/input/input1
[    2.878247] generic-usb 0003:0566:3108.0001: input,hidraw0: USB HID 
v1.10 Keyboard [HID 0566:3108] on usb-0000:00:1d.1-2/input0
[    2.900934] input: HID 0566:3108 as 
/devices/pci0000:00/0000:00:1d.1/usb3/3-2/3-2:1.1/input/input2
[    2.901076] generic-usb 0003:0566:3108.0002: input,hidraw1: USB HID 
v1.10 Device [HID 0566:3108] on usb-0000:00:1d.1-2/input1
[    2.963209] usb 1-1.1: new full-speed USB device number 5 using ehci_hcd
[    2.992261] bnx2 0000:09:00.0: eth1: Broadcom NetXtreme II BCM5708 
1000Base-T (B2) PCI-X 64-bit 133MHz found at mem f4000000, IRQ 16, node 
addr 00:1d:09:65:5f:4f
[    3.039062] usb 1-1.1: New USB device found, idVendor=413c, 
idProduct=0000
[    3.039067] usb 1-1.1: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[    3.039070] usb 1-1.1: Product: DRAC5
[    3.039072] usb 1-1.1: Manufacturer: Dell
[    3.039075] usb 1-1.1: SerialNumber: 0000000
[    3.041316] input: Dell DRAC5 as 
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1.1/1-1.1:1.0/input/input3
[    3.041478] generic-usb 0003:413C:0000.0003: input,hidraw2: USB HID 
v1.10 Keyboard [Dell DRAC5] on usb-0000:00:1d.7-1.1/input0
[    3.043196] input: Dell DRAC5 as 
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1.1/1-1.1:1.1/input/input4
[    3.043381] generic-usb 0003:413C:0000.0004: input,hidraw3: USB HID 
v1.10 Mouse [Dell DRAC5] on usb-0000:00:1d.7-1.1/input1
[   19.550039] megasas_init_mfi: fw_support_ieee=0
[   19.550042] megasas: INIT adapter done
[   19.613062] scsi2 : LSI SAS based MegaRAID driver
[   19.613069] megaraid_sas: fw state:c0000000
[   19.613072] megasas: fwstate:c0000000, dis_OCR=0
[   19.968284] scsi 2:0:0:0: Direct-Access     ATA ST2000DM001-9YN1 CC4B 
PQ: 0 ANSI: 5
[   19.976618] scsi 2:0:1:0: Direct-Access     ATA ST2000DM001-9YN1 CC4B 
PQ: 0 ANSI: 5
[   20.025813] scsi 2:0:8:0: Enclosure         DP BACKPLANE  1.05 PQ: 0 
ANSI: 5
[   20.073649] scsi 2:2:0:0: Direct-Access     DELL     PERC 5/i  1.03 
PQ: 0 ANSI: 5
[   20.099932] scsi 2:0:8:0: Attached scsi generic sg1 type 13
[   20.100318] sd 2:2:0:0: Attached scsi generic sg2 type 0
[   20.100460] sd 2:2:0:0: [sda] 3905945600 512-byte logical blocks: 
(1.99 TB/1.81 TiB)
[   20.100676] sd 2:2:0:0: [sda] Write Protect is off
[   20.100691] sd 2:2:0:0: [sda] Mode Sense: 1f 00 00 08
[   20.100956] sd 2:2:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[   20.142992]  sda: sda1 sda2 sda3 sda4 < sda5 >
[   20.143877] sd 2:2:0:0: [sda] Attached SCSI disk
[   20.234714] ses 2:0:8:0: Attached Enclosure device
[   31.145207] md: linear personality registered for level -1
[   31.146871] md: multipath personality registered for level -4
[   31.148528] md: raid0 personality registered for level 0
[   31.150534] md: raid1 personality registered for level 1
[   31.152093] async_tx: api initialized (async)
[   31.152591] xor: automatically using best checksumming function: 
generic_sse
[   31.157004]    generic_sse:  8276.000 MB/sec
[   31.157006] xor: using function: generic_sse (8276.000 MB/sec)
[   31.175022] raid6: int64x1   1937 MB/s
[   31.192031] raid6: int64x2   2207 MB/s
[   31.209007] raid6: int64x4   1882 MB/s
[   31.226045] raid6: int64x8   1300 MB/s
[   31.243006] raid6: sse2x1    2875 MB/s
[   31.260022] raid6: sse2x2    5675 MB/s
[   31.277022] raid6: sse2x4    6332 MB/s
[   31.277024] raid6: using algorithm sse2x4 (6332 MB/s)
[   31.279411] md: raid6 personality registered for level 6
[   31.279424] md: raid5 personality registered for level 5
[   31.279426] md: raid4 personality registered for level 4
[   31.284796] md: raid10 personality registered for level 10
[   35.980297] ISO 9660 Extensions: Microsoft Joliet Level 3
[   35.986050] ISO 9660 Extensions: RRIP_1991A
[   36.355986] aufs test_add:264:mount[392]: uid/gid/perm /squashfs 
0/0/0755, 0/0/01777
[   36.364019] aufs test_add:264:mount[397]: uid/gid/perm /boot 
0/0/0775, 0/0/01777
[   49.081066] systemd-udevd[862]: starting version 197
[   50.777410] microcode: CPU0 sig=0x6f7, pf=0x40, revision=0x6b
[   50.903896] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   50.906467] microcode: CPU1 sig=0x6f7, pf=0x40, revision=0x6b
[   50.907248] microcode: CPU2 sig=0x6f7, pf=0x40, revision=0x6b
[   50.907625] microcode: CPU3 sig=0x6f7, pf=0x40, revision=0x6b
[   50.908034] microcode: CPU4 sig=0x6f7, pf=0x40, revision=0x6b
[   50.908430] microcode: CPU5 sig=0x6f7, pf=0x40, revision=0x6b
[   50.908816] microcode: CPU6 sig=0x6f7, pf=0x40, revision=0x6b
[   50.909244] microcode: CPU7 sig=0x6f7, pf=0x40, revision=0x6b
[   50.909669] microcode: Microcode Update Driver: v2.00 
<tigran@aivazian.fsnet.co.uk> <mailto:tigran@aivazian.fsnet.co.uk>, 
Peter Oruba
[   51.145642] intel_rng: FWH not detected
[   51.728980] dcdbas dcdbas: Dell Systems Management Base Driver 
(version 5.6.0-3.2)
[   51.736198] coretemp coretemp.0: Using relative temperature scale!
[   51.736329] coretemp coretemp.1: Using relative temperature scale!
[   51.736376] coretemp coretemp.0: Using relative temperature scale!
[   51.736405] coretemp coretemp.1: Using relative temperature scale!
[   51.736418] coretemp coretemp.0: Using relative temperature scale!
[   51.736433] coretemp coretemp.1: Using relative temperature scale!
[   51.736451] coretemp coretemp.0: Using relative temperature scale!
[   51.736473] coretemp coretemp.1: Using relative temperature scale!
[   51.744956] EDAC MC: Ver: 2.1.0
[   52.021898] iTCO_vendor_support: vendor-support=0
[   52.022392] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.07
[   52.022579] iTCO_wdt: Found a 631xESB/632xESB TCO device (Version=2, 
TCOBASE=0x0860)
[   52.022663] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   52.022815] EDAC MC0: Giving out device to 'i5000_edac.c' 'I5000': 
DEV 0000:00:10.0
[   52.022862] EDAC PCI0: Giving out device to module 'i5000_edac' 
controller 'EDAC PCI controller': DEV '0000:00:10.0' (POLLED)
[   55.854923] intel_rng: FWH not detected
[   56.264311] warning: process `hwsetup' used the deprecated sysctl 
system call with 1.23.
[   73.201688] bnx2 0000:09:00.0: irq 111 for MSI/MSI-X
[   73.319045] bnx2 0000:09:00.0: eth1: using MSI
[   73.322184] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   73.330987] bnx2 0000:05:00.0: irq 112 for MSI/MSI-X
[   73.449027] bnx2 0000:05:00.0: eth0: using MSI
[   73.452124] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   76.536219] md: Autodetecting RAID arrays.
[   76.536223] md: Scanned 0 and added 0 devices.
[   76.536225] md: autorun ...
[   76.536226] md: ... autorun DONE.
[  114.628152] usb 1-5.2: new high-speed USB device number 6 using ehci_hcd
[  115.610001] usb 1-5.2: New USB device found, idVendor=4146, 
idProduct=ba65
[  115.610027] usb 1-5.2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[  115.610030] usb 1-5.2: Product: USB Mass Storage Device
[  115.610032] usb 1-5.2: Manufacturer: PRETEC UG-32GB
[  115.610034] usb 1-5.2: SerialNumber: 74b1f82028e3e5
[  119.475031] Initializing USB Mass Storage driver...
[  119.475309] scsi3 : usb-storage 1-5.2:1.0
[  119.475453] usbcore: registered new interface driver usb-storage
[  119.475456] USB Mass Storage support registered.
[  120.477152] scsi 3:0:0:0: Direct-Access     Pretec UltimateGuard 
  8.01 PQ: 0 ANSI: 2
[  120.478215] sd 3:0:0:0: Attached scsi generic sg3 type 0
[  120.479509] sd 3:0:0:0: [sdb] 63137952 512-byte logical blocks: (32.3 
GB/30.1 GiB)
[  120.480135] sd 3:0:0:0: [sdb] Write Protect is off
[  120.480139] sd 3:0:0:0: [sdb] Mode Sense: 00 00 00 00
[  120.480748] sd 3:0:0:0: [sdb] Asking for cache data failed
[  120.480751] sd 3:0:0:0: [sdb] Assuming drive cache: write through
[  120.484999] sd 3:0:0:0: [sdb] Asking for cache data failed
[  120.485012] sd 3:0:0:0: [sdb] Assuming drive cache: write through
[  120.635439]  sdb: sdb1
[  121.519623] sd 3:0:0:0: [sdb] Asking for cache data failed
[  121.519626] sd 3:0:0:0: [sdb] Assuming drive cache: write through
[  121.519630] sd 3:0:0:0: [sdb] Attached SCSI removable disk
#v-

lcpci
#v+
00:00.0 Host bridge: Intel Corporation 5000X Chipset Memory Controller 
Hub (rev 12)
00:02.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4 
Port 2 (rev 12)
00:03.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4 
Port 3 (rev 12)
00:04.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x8 
Port 4-5 (rev 12)
00:05.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4 
Port 5 (rev 12)
00:06.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x8 
Port 6-7 (rev 12)
00:07.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4 
Port 7 (rev 12)
00:10.0 Host bridge: Intel Corporation 5000 Series Chipset FSB Registers 
(rev 12)
00:10.1 Host bridge: Intel Corporation 5000 Series Chipset FSB Registers 
(rev 12)
00:10.2 Host bridge: Intel Corporation 5000 Series Chipset FSB Registers 
(rev 12)
00:11.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved 
Registers (rev 12)
00:13.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved 
Registers (rev 12)
00:15.0 Host bridge: Intel Corporation 5000 Series Chipset FBD Registers 
(rev 12)
00:16.0 Host bridge: Intel Corporation 5000 Series Chipset FBD Registers 
(rev 12)
00:1c.0 PCI bridge: Intel Corporation 631xESB/632xESB/3100 Chipset PCI 
Express Root Port 1 (rev 09)
00:1d.0 USB controller: Intel Corporation 631xESB/632xESB/3100 Chipset 
UHCI USB Controller #1 (rev 09)
00:1d.1 USB controller: Intel Corporation 631xESB/632xESB/3100 Chipset 
UHCI USB Controller #2 (rev 09)
00:1d.2 USB controller: Intel Corporation 631xESB/632xESB/3100 Chipset 
UHCI USB Controller #3 (rev 09)
00:1d.7 USB controller: Intel Corporation 631xESB/632xESB/3100 Chipset 
EHCI USB2 Controller (rev 09)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev d9)
00:1f.0 ISA bridge: Intel Corporation 631xESB/632xESB/3100 Chipset LPC 
Interface Controller (rev 09)
00:1f.1 IDE interface: Intel Corporation 631xESB/632xESB IDE Controller 
(rev 09)
01:00.0 PCI bridge: Intel Corporation 80333 Segment-A PCI Express-to-PCI 
Express Bridge
01:00.2 PCI bridge: Intel Corporation 80333 Segment-B PCI Express-to-PCI 
Express Bridge
02:0e.0 RAID bus controller: Dell PowerEdge Expandable RAID controller 5
04:00.0 PCI bridge: Broadcom EPB PCI-Express to PCI-X Bridge (rev c3)
05:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708 
Gigabit Ethernet (rev 12)
06:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express 
Upstream Port (rev 01)
06:00.3 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express to 
PCI-X Bridge (rev 01)
07:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express 
Downstream Port E1 (rev 01)
07:01.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express 
Downstream Port E2 (rev 01)
08:00.0 PCI bridge: Broadcom EPB PCI-Express to PCI-X Bridge (rev c3)
09:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708 
Gigabit Ethernet (rev 12)
10:0d.0 VGA compatible controller: Advanced Micro Devices [AMD] nee ATI 
ES1000 (rev 02)
#v-

cat /proc/cpuinfo
#v+
processor    : 0
vendor_id    : GenuineIntel
cpu family    : 6
model        : 15
model name    : Intel(R) Xeon(R) CPU           E5345  @ 2.33GHz
stepping    : 7
microcode    : 0x6b
cpu MHz        : 2333.331
cache size    : 4096 KB
physical id    : 0
siblings    : 4
core id        : 0
cpu cores    : 4
apicid        : 0
initial apicid    : 0
fpu        : yes
fpu_exception    : yes
cpuid level    : 10
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall 
nx lm constant_tsc arch_perfmon pebs bts rep_good nopl aperfmperf pni 
dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca lahf_lm 
dtherm tpr_shadow
bogomips    : 4655.28
clflush size    : 64
cache_alignment    : 64
address sizes    : 36 bits physical, 48 bits virtual
power management:

processor    : 1
vendor_id    : GenuineIntel
cpu family    : 6
model        : 15
model name    : Intel(R) Xeon(R) CPU           E5345  @ 2.33GHz
stepping    : 7
microcode    : 0x6b
cpu MHz        : 2333.331
cache size    : 4096 KB
physical id    : 1
siblings    : 4
core id        : 0
cpu cores    : 4
apicid        : 4
initial apicid    : 4
fpu        : yes
fpu_exception    : yes
cpuid level    : 10
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall 
nx lm constant_tsc arch_perfmon pebs bts rep_good nopl aperfmperf pni 
dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca lahf_lm 
dtherm tpr_shadow
bogomips    : 4655.03
clflush size    : 64
cache_alignment    : 64
address sizes    : 36 bits physical, 48 bits virtual
power management:

processor    : 2
vendor_id    : GenuineIntel
cpu family    : 6
model        : 15
model name    : Intel(R) Xeon(R) CPU           E5345  @ 2.33GHz
stepping    : 7
microcode    : 0x6b
cpu MHz        : 2333.331
cache size    : 4096 KB
physical id    : 0
siblings    : 4
core id        : 2
cpu cores    : 4
apicid        : 2
initial apicid    : 2
fpu        : yes
fpu_exception    : yes
cpuid level    : 10
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall 
nx lm constant_tsc arch_perfmon pebs bts rep_good nopl aperfmperf pni 
dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca lahf_lm 
dtherm tpr_shadow
bogomips    : 4655.28
clflush size    : 64
cache_alignment    : 64
address sizes    : 36 bits physical, 48 bits virtual
power management:

processor    : 3
vendor_id    : GenuineIntel
cpu family    : 6
model        : 15
model name    : Intel(R) Xeon(R) CPU           E5345  @ 2.33GHz
stepping    : 7
microcode    : 0x6b
cpu MHz        : 2333.331
cache size    : 4096 KB
physical id    : 1
siblings    : 4
core id        : 2
cpu cores    : 4
apicid        : 6
initial apicid    : 6
fpu        : yes
fpu_exception    : yes
cpuid level    : 10
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall 
nx lm constant_tsc arch_perfmon pebs bts rep_good nopl aperfmperf pni 
dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca lahf_lm 
dtherm tpr_shadow
bogomips    : 4655.03
clflush size    : 64
cache_alignment    : 64
address sizes    : 36 bits physical, 48 bits virtual
power management:

processor    : 4
vendor_id    : GenuineIntel
cpu family    : 6
model        : 15
model name    : Intel(R) Xeon(R) CPU           E5345  @ 2.33GHz
stepping    : 7
microcode    : 0x6b
cpu MHz        : 2333.331
cache size    : 4096 KB
physical id    : 0
siblings    : 4
core id        : 1
cpu cores    : 4
apicid        : 1
initial apicid    : 1
fpu        : yes
fpu_exception    : yes
cpuid level    : 10
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall 
nx lm constant_tsc arch_perfmon pebs bts rep_good nopl aperfmperf pni 
dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca lahf_lm 
dtherm tpr_shadow
bogomips    : 4655.28
clflush size    : 64
cache_alignment    : 64
address sizes    : 36 bits physical, 48 bits virtual
power management:

processor    : 5
vendor_id    : GenuineIntel
cpu family    : 6
model        : 15
model name    : Intel(R) Xeon(R) CPU           E5345  @ 2.33GHz
stepping    : 7
microcode    : 0x6b
cpu MHz        : 2333.331
cache size    : 4096 KB
physical id    : 1
siblings    : 4
core id        : 1
cpu cores    : 4
apicid        : 5
initial apicid    : 5
fpu        : yes
fpu_exception    : yes
cpuid level    : 10
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall 
nx lm constant_tsc arch_perfmon pebs bts rep_good nopl aperfmperf pni 
dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca lahf_lm 
dtherm tpr_shadow
bogomips    : 4655.03
clflush size    : 64
cache_alignment    : 64
address sizes    : 36 bits physical, 48 bits virtual
power management:

processor    : 6
vendor_id    : GenuineIntel
cpu family    : 6
model        : 15
model name    : Intel(R) Xeon(R) CPU           E5345  @ 2.33GHz
stepping    : 7
microcode    : 0x6b
cpu MHz        : 2333.331
cache size    : 4096 KB
physical id    : 0
siblings    : 4
core id        : 3
cpu cores    : 4
apicid        : 3
initial apicid    : 3
fpu        : yes
fpu_exception    : yes
cpuid level    : 10
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall 
nx lm constant_tsc arch_perfmon pebs bts rep_good nopl aperfmperf pni 
dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca lahf_lm 
dtherm tpr_shadow
bogomips    : 4655.28
clflush size    : 64
cache_alignment    : 64
address sizes    : 36 bits physical, 48 bits virtual
power management:

processor    : 7
vendor_id    : GenuineIntel
cpu family    : 6
model        : 15
model name    : Intel(R) Xeon(R) CPU           E5345  @ 2.33GHz
stepping    : 7
microcode    : 0x6b
cpu MHz        : 2333.331
cache size    : 4096 KB
physical id    : 1
siblings    : 4
core id        : 3
cpu cores    : 4
apicid        : 7
initial apicid    : 7
fpu        : yes
fpu_exception    : yes
cpuid level    : 10
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall 
nx lm constant_tsc arch_perfmon pebs bts rep_good nopl aperfmperf pni 
dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca lahf_lm 
dtherm tpr_shadow
bogomips    : 4655.03
clflush size    : 64
cache_alignment    : 64
address sizes    : 36 bits physical, 48 bits virtual
power management:
#v-

lspci -vv
#v+
00:00.0 Host bridge: Intel Corporation 5000X Chipset Memory Controller 
Hub (rev 12)
     Subsystem: Intel Corporation Device 8086
     Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
Stepping- SERR+ FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Interrupt: pin A routed to IRQ 0
     Capabilities: [50] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [58] MSI: Enable- Count=1/2 Maskable- 64bit-
         Address: fee00000  Data: 0000
     Capabilities: [6c] Express (v1) Root Port (Slot-), MSI 00
         DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s 
unlimited, L1 unlimited
             ExtTag- RBE- FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal+ 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-
         LnkCap:    Port #0, Speed 2.5GT/s, Width x4, ASPM L0s, Latency 
L0 unlimited, L1 unlimited
             ClockPM- Surprise+ LLActRep+ BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt- ABWMgmt-
         RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- 
CRSVisible-
         RootCap: CRSVisible-
         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
     Capabilities: [100 v1] Advanced Error Reporting
         UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt+ UnxCmplt+ 
RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
         UESvrt:    DLP+ SDES+ TLP+ FCP+ CmpltTO+ CmpltAbrt- UnxCmplt- 
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol+
         CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
         CEMsk:    RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr-
         AERCap:    First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-

00:02.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4 
Port 2 (rev 12) (prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
Stepping- SERR+ FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Bus: primary=00, secondary=06, subordinate=0b, sec-latency=0
     Memory behind bridge: f2000000-f7ffffff
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
     BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [50] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [58] MSI: Enable+ Count=1/2 Maskable- 64bit-
         Address: feeff00c  Data: 4151
     Capabilities: [6c] Express (v1) Root Port (Slot-), MSI 00
         DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s 
unlimited, L1 unlimited
             ExtTag- RBE- FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal+ 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-
         LnkCap:    Port #2, Speed 2.5GT/s, Width x4, ASPM L0s, Latency 
L0 unlimited, L1 unlimited
             ClockPM- Surprise+ LLActRep+ BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt- ABWMgmt-
         RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal+ PMEIntEna+ 
CRSVisible-
         RootCap: CRSVisible-
         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
     Capabilities: [100 v1] Advanced Error Reporting
         UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt+ UnxCmplt+ 
RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
         UESvrt:    DLP+ SDES+ TLP+ FCP+ CmpltTO+ CmpltAbrt- UnxCmplt- 
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
         CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
         CEMsk:    RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr-
         AERCap:    First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
     Kernel driver in use: pcieport
     Kernel modules: shpchp

00:03.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4 
Port 3 (rev 12) (prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
Stepping- SERR+ FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Bus: primary=00, secondary=01, subordinate=03, sec-latency=0
     Memory behind bridge: fc300000-fc5fffff
     Prefetchable memory behind bridge: 00000000d8000000-00000000d80fffff
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
     BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [50] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [58] MSI: Enable+ Count=1/2 Maskable- 64bit-
         Address: feeff00c  Data: 4159
     Capabilities: [6c] Express (v1) Root Port (Slot-), MSI 00
         DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s 
unlimited, L1 unlimited
             ExtTag- RBE- FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal+ 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
             MaxPayload 256 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-
         LnkCap:    Port #3, Speed 2.5GT/s, Width x4, ASPM L0s, Latency 
L0 unlimited, L1 unlimited
             ClockPM- Surprise+ LLActRep+ BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt- ABWMgmt-
         RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal+ PMEIntEna+ 
CRSVisible-
         RootCap: CRSVisible-
         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
     Capabilities: [100 v1] Advanced Error Reporting
         UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt+ UnxCmplt+ 
RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
         UESvrt:    DLP+ SDES+ TLP+ FCP+ CmpltTO+ CmpltAbrt- UnxCmplt- 
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
         CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
         CEMsk:    RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr-
         AERCap:    First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
     Kernel driver in use: pcieport
     Kernel modules: shpchp

00:04.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x8 
Port 4-5 (rev 12) (prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
Stepping- SERR+ FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Bus: primary=00, secondary=0c, subordinate=0c, sec-latency=0
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
     BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [50] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [58] MSI: Enable+ Count=1/2 Maskable- 64bit-
         Address: feeff00c  Data: 4161
     Capabilities: [6c] Express (v1) Root Port (Slot+), MSI 00
         DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s 
unlimited, L1 unlimited
             ExtTag- RBE- FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal+ 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-
         LnkCap:    Port #4, Speed 2.5GT/s, Width x8, ASPM L0s, Latency 
L0 unlimited, L1 unlimited
             ClockPM- Surprise+ LLActRep+ BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled+ Retrain- CommClk-
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
         SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- 
Surprise-
             Slot #1, PowerLimit 25.000W; Interlock- NoCompl-
         SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- 
HPIrq- LinkChg-
             Control: AttnInd Off, PwrInd Off, Power- Interlock-
         SltSta:    Status: AttnBtn- PowerFlt- MRL+ CmdCplt- PresDet- 
Interlock-
             Changed: MRL- PresDet+ LinkState-
         RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal+ PMEIntEna+ 
CRSVisible-
         RootCap: CRSVisible-
         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
     Capabilities: [100 v1] Advanced Error Reporting
         UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt+ UnxCmplt+ 
RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
         UESvrt:    DLP+ SDES+ TLP+ FCP+ CmpltTO+ CmpltAbrt- UnxCmplt- 
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
         CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
         CEMsk:    RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr-
         AERCap:    First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
     Kernel driver in use: pcieport
     Kernel modules: shpchp

00:05.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4 
Port 5 (rev 12) (prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
Stepping- SERR+ FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Bus: primary=00, secondary=0d, subordinate=0d, sec-latency=0
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
     BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [50] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [58] MSI: Enable+ Count=1/2 Maskable- 64bit-
         Address: feeff00c  Data: 4169
     Capabilities: [6c] Express (v1) Root Port (Slot-), MSI 00
         DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s 
unlimited, L1 unlimited
             ExtTag- RBE- FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal+ 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-
         LnkCap:    Port #5, Speed 2.5GT/s, Width x4, ASPM L0s, Latency 
L0 unlimited, L1 unlimited
             ClockPM- Surprise+ LLActRep+ BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled+ Retrain- CommClk-
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
         RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal+ PMEIntEna+ 
CRSVisible-
         RootCap: CRSVisible-
         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
     Capabilities: [100 v1] Advanced Error Reporting
         UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt+ UnxCmplt+ 
RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
         UESvrt:    DLP+ SDES+ TLP+ FCP+ CmpltTO+ CmpltAbrt- UnxCmplt- 
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
         CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
         CEMsk:    RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr-
         AERCap:    First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
     Kernel driver in use: pcieport
     Kernel modules: shpchp

00:06.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x8 
Port 6-7 (rev 12) (prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
Stepping- SERR+ FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Bus: primary=00, secondary=0e, subordinate=0e, sec-latency=0
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
     BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [50] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [58] MSI: Enable+ Count=1/2 Maskable- 64bit-
         Address: feeff00c  Data: 4171
     Capabilities: [6c] Express (v1) Root Port (Slot+), MSI 00
         DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s 
unlimited, L1 unlimited
             ExtTag- RBE- FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal+ 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-
         LnkCap:    Port #6, Speed 2.5GT/s, Width x8, ASPM L0s, Latency 
L0 unlimited, L1 unlimited
             ClockPM- Surprise+ LLActRep+ BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled+ Retrain- CommClk-
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
         SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- 
Surprise-
             Slot #2, PowerLimit 25.000W; Interlock- NoCompl-
         SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- 
HPIrq- LinkChg-
             Control: AttnInd Off, PwrInd Off, Power- Interlock-
         SltSta:    Status: AttnBtn- PowerFlt- MRL+ CmdCplt- PresDet- 
Interlock-
             Changed: MRL- PresDet+ LinkState-
         RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal+ PMEIntEna+ 
CRSVisible-
         RootCap: CRSVisible-
         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
     Capabilities: [100 v1] Advanced Error Reporting
         UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt+ UnxCmplt+ 
RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
         UESvrt:    DLP+ SDES+ TLP+ FCP+ CmpltTO+ CmpltAbrt- UnxCmplt- 
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
         CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
         CEMsk:    RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr-
         AERCap:    First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
     Kernel driver in use: pcieport
     Kernel modules: shpchp

00:07.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4 
Port 7 (rev 12) (prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
Stepping- SERR+ FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Bus: primary=00, secondary=0f, subordinate=0f, sec-latency=0
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
     BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [50] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [58] MSI: Enable+ Count=1/2 Maskable- 64bit-
         Address: feeff00c  Data: 4179
     Capabilities: [6c] Express (v1) Root Port (Slot-), MSI 00
         DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s 
unlimited, L1 unlimited
             ExtTag- RBE- FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal+ 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-
         LnkCap:    Port #7, Speed 2.5GT/s, Width x4, ASPM L0s, Latency 
L0 unlimited, L1 unlimited
             ClockPM- Surprise+ LLActRep+ BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled+ Retrain- CommClk-
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
         RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal+ PMEIntEna+ 
CRSVisible-
         RootCap: CRSVisible-
         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
     Capabilities: [100 v1] Advanced Error Reporting
         UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt+ UnxCmplt+ 
RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
         UESvrt:    DLP+ SDES+ TLP+ FCP+ CmpltTO+ CmpltAbrt- UnxCmplt- 
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
         CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
         CEMsk:    RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr-
         AERCap:    First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
     Kernel driver in use: pcieport
     Kernel modules: shpchp

00:10.0 Host bridge: Intel Corporation 5000 Series Chipset FSB Registers 
(rev 12)
     Subsystem: Dell Device 01b3
     Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Kernel driver in use: i5000_edac
     Kernel modules: i5000_edac, i5k_amb, i7300_idle

00:10.1 Host bridge: Intel Corporation 5000 Series Chipset FSB Registers 
(rev 12)
     Subsystem: Dell Device 01b3
     Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Kernel modules: i5000_edac, i5k_amb, i7300_idle

00:10.2 Host bridge: Intel Corporation 5000 Series Chipset FSB Registers 
(rev 12)
     Subsystem: Dell Device 01b3
     Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Kernel modules: i5000_edac, i5k_amb, i7300_idle

00:11.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved 
Registers (rev 12)
     Subsystem: Intel Corporation Device 8086
     Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:13.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved 
Registers (rev 12)
     Subsystem: Intel Corporation Device 8086
     Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:15.0 Host bridge: Intel Corporation 5000 Series Chipset FBD Registers 
(rev 12)
     Subsystem: Intel Corporation Device 8086
     Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:16.0 Host bridge: Intel Corporation 5000 Series Chipset FBD Registers 
(rev 12)
     Subsystem: Intel Corporation Device 8086
     Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:1c.0 PCI bridge: Intel Corporation 631xESB/632xESB/3100 Chipset PCI 
Express Root Port 1 (rev 09) (prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
Stepping- SERR+ FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Bus: primary=00, secondary=04, subordinate=05, sec-latency=0
     Memory behind bridge: f8000000-fbffffff
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
     BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [40] Express (v1) Root Port (Slot-), MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
unlimited, L1 unlimited
             ExtTag+ RBE- FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal+ Fatal+ 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-
         LnkCap:    Port #1, Speed 2.5GT/s, Width x4, ASPM L0s L1, 
Latency L0 <256ns, L1 <4us
             ClockPM- Surprise- LLActRep- BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
         RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+ PMEIntEna+ 
CRSVisible-
         RootCap: CRSVisible-
         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
     Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
         Address: feeff00c  Data: 4181
     Capabilities: [90] Subsystem: Dell Device 01b3
     Capabilities: [a0] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [100 v1] Virtual Channel
         Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
         Arb:    Fixed+ WRR32- WRR64- WRR128-
         Ctrl:    ArbSelect=Fixed
         Status:    InProgress-
         VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
             Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
             Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
             Status:    NegoPending- InProgress-
         VC1:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
             Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
             Ctrl:    Enable- ID=0 ArbSelect=Fixed TC/VC=00
             Status:    NegoPending- InProgress-
     Capabilities: [180 v1] Root Complex Link
         Desc:    PortNumber=01 ComponentID=02 EltType=Config
         Link0:    Desc:    TargetPort=00 TargetComponent=02 AssocRCRB- 
LinkType=MemMapped LinkValid+
             Addr:    00000000fed1c001
     Kernel driver in use: pcieport
     Kernel modules: shpchp

00:1d.0 USB controller: Intel Corporation 631xESB/632xESB/3100 Chipset 
UHCI USB Controller #1 (rev 09) (prog-if 00 [UHCI])
     Subsystem: Dell Device 01b3
     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin A routed to IRQ 21
     Region 4: I/O ports at dce0 [size=32]
     Kernel driver in use: uhci_hcd

00:1d.1 USB controller: Intel Corporation 631xESB/632xESB/3100 Chipset 
UHCI USB Controller #2 (rev 09) (prog-if 00 [UHCI])
     Subsystem: Dell Device 01b3
     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin B routed to IRQ 20
     Region 4: I/O ports at dcc0 [size=32]
     Kernel driver in use: uhci_hcd

00:1d.2 USB controller: Intel Corporation 631xESB/632xESB/3100 Chipset 
UHCI USB Controller #3 (rev 09) (prog-if 00 [UHCI])
     Subsystem: Dell Device 01b3
     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin C routed to IRQ 21
     Region 4: I/O ports at dca0 [size=32]
     Kernel driver in use: uhci_hcd

00:1d.7 USB controller: Intel Corporation 631xESB/632xESB/3100 Chipset 
EHCI USB2 Controller (rev 09) (prog-if 20 [EHCI])
     Subsystem: Dell Device 01b3
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin A routed to IRQ 21
     Region 0: Memory at fc600000 (32-bit, non-prefetchable) [size=1K]
     Capabilities: [50] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [58] Debug port: BAR=1 offset=00a0
     Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev d9) (prog-if 
01 [Subtractive decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
Stepping- SERR+ FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Bus: primary=00, secondary=10, subordinate=10, sec-latency=32
     I/O behind bridge: 0000e000-0000efff
     Memory behind bridge: fc100000-fc2fffff
     Prefetchable memory behind bridge: 00000000d0000000-00000000d7ffffff
     Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
     BridgeCtl: Parity+ SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [50] Subsystem: Device 0000:0000

00:1f.0 ISA bridge: Intel Corporation 631xESB/632xESB/3100 Chipset LPC 
Interface Controller (rev 09)
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
Stepping- SERR+ FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Kernel modules: iTCO_wdt, intel-rng

00:1f.1 IDE interface: Intel Corporation 631xESB/632xESB IDE Controller 
(rev 09) (prog-if 8a [Master SecP PriP])
     Subsystem: Dell Device 01b3
     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin A routed to IRQ 16
     Region 0: I/O ports at 01f0 [size=8]
     Region 1: I/O ports at 03f4
     Region 2: I/O ports at 0170 [size=8]
     Region 3: I/O ports at 0374
     Region 4: I/O ports at fc00 [size=16]
     Kernel driver in use: ata_piix

01:00.0 PCI bridge: Intel Corporation 80333 Segment-A PCI Express-to-PCI 
Express Bridge (prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
Stepping- SERR+ FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Bus: primary=01, secondary=02, subordinate=02, sec-latency=64
     Memory behind bridge: fc400000-fc5fffff
     Prefetchable memory behind bridge: 00000000d8000000-00000000d80fffff
     Secondary status: 66MHz+ FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
     BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [44] Express (v1) PCI/PCI-X Bridge, MSI 00
         DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
             ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal+ 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop- BrConfRtry-
             MaxPayload 256 bytes, MaxReadReq 512 bytes
         DevSta:    CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- 
TransPend-
         LnkCap:    Port #0, Speed 2.5GT/s, Width x8, ASPM L0s, Latency 
L0 unlimited, L1 unlimited
             ClockPM- Surprise- LLActRep- BwNot-
         LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk-
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk- 
DLActive- BWMgmt- ABWMgmt-
     Capabilities: [5c] MSI: Enable- Count=1/1 Maskable- 64bit+
         Address: 0000000000000000  Data: 0000
     Capabilities: [6c] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [d8] PCI-X bridge device
         Secondary Status: 64bit+ 133MHz+ SCD- USC- SCO- SRD- Freq=133MHz
         Status: Dev=01:00.0 64bit- 133MHz- SCD- USC- SCO- SRD-
         Upstream: Capacity=65535 CommitmentLimit=65535
         Downstream: Capacity=65535 CommitmentLimit=65535
     Capabilities: [100 v1] Advanced Error Reporting
         UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
         UEMsk:    DLP- SDES- TLP- FCP- CmpltTO+ CmpltAbrt+ UnxCmplt+ 
RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
         UESvrt:    DLP+ SDES- TLP+ FCP+ CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
         CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
         CEMsk:    RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr-
         AERCap:    First Error Pointer: 14, GenCap- CGenEn- ChkCap- ChkEn-
     Capabilities: [300 v1] Power Budgeting <?>
     Kernel modules: shpchp

01:00.2 PCI bridge: Intel Corporation 80333 Segment-B PCI Express-to-PCI 
Express Bridge (prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
Stepping- SERR+ FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Bus: primary=01, secondary=03, subordinate=03, sec-latency=64
     Secondary status: 66MHz+ FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
     BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [44] Express (v1) PCI/PCI-X Bridge, MSI 00
         DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
             ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal+ 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop- BrConfRtry-
             MaxPayload 256 bytes, MaxReadReq 512 bytes
         DevSta:    CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- 
TransPend-
         LnkCap:    Port #0, Speed 2.5GT/s, Width x8, ASPM L0s, Latency 
L0 unlimited, L1 unlimited
             ClockPM- Surprise- LLActRep- BwNot-
         LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk-
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk- 
DLActive- BWMgmt- ABWMgmt-
     Capabilities: [5c] MSI: Enable- Count=1/1 Maskable- 64bit+
         Address: 0000000000000000  Data: 0000
     Capabilities: [6c] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [d8] PCI-X bridge device
         Secondary Status: 64bit+ 133MHz+ SCD- USC- SCO- SRD- Freq=133MHz
         Status: Dev=01:00.2 64bit- 133MHz- SCD- USC- SCO- SRD-
         Upstream: Capacity=65535 CommitmentLimit=65535
         Downstream: Capacity=65535 CommitmentLimit=65535
     Capabilities: [100 v1] Advanced Error Reporting
         UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
         UEMsk:    DLP- SDES- TLP- FCP- CmpltTO+ CmpltAbrt+ UnxCmplt+ 
RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
         UESvrt:    DLP+ SDES- TLP+ FCP+ CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
         CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
         CEMsk:    RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr-
         AERCap:    First Error Pointer: 14, GenCap- CGenEn- ChkCap- ChkEn-
     Capabilities: [300 v1] Power Budgeting <?>
     Kernel modules: shpchp

02:0e.0 RAID bus controller: Dell PowerEdge Expandable RAID controller 5
     Subsystem: Dell PERC 5/i Integrated RAID Controller
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ 
Stepping+ SERR+ FastB2B- DisINTx-
     Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 32 (32000ns min), Cache Line Size: 64 bytes
     Interrupt: pin A routed to IRQ 18
     Region 0: Memory at d80f0000 (32-bit, prefetchable) [size=64K]
     Region 2: Memory at fc5c0000 (32-bit, non-prefetchable) [size=128K]
     Expansion ROM at fc400000 [disabled] [size=32K]
     Capabilities: [c0] Power Management version 2
         Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [d0] MSI: Enable- Count=1/2 Maskable- 64bit+
         Address: 0000000000000000  Data: 0000
     Capabilities: [e0] PCI-X non-bridge device
         Command: DPERE- ERO- RBC=512 OST=4
         Status: Dev=02:0e.0 64bit+ 133MHz+ SCD- USC- DC=bridge 
DMMRBC=1024 DMOST=4 DMCRS=16 RSCEM- 266MHz- 533MHz-
     Kernel driver in use: megaraid_sas
     Kernel modules: megaraid_sas

04:00.0 PCI bridge: Broadcom EPB PCI-Express to PCI-X Bridge (rev c3) 
(prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
Stepping- SERR+ FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Bus: primary=04, secondary=05, subordinate=05, sec-latency=64
     Memory behind bridge: f8000000-fbffffff
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
     BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [60] Express (v1) PCI/PCI-X Bridge, MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
             ExtTag+ AttnBtn- AttnInd- PwrInd- RBE- FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal+ 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop- BrConfRtry-
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-
         LnkCap:    Port #0, Speed 2.5GT/s, Width x4, ASPM L0s L1, 
Latency L0 <1us, L1 <4us
             ClockPM- Surprise- LLActRep- BwNot-
         LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
     Capabilities: [90] PCI-X bridge device
         Secondary Status: 64bit+ 133MHz+ SCD- USC- SCO- SRD- Freq=133MHz
         Status: Dev=04:00.0 64bit- 133MHz- SCD- USC- SCO- SRD-
         Upstream: Capacity=0 CommitmentLimit=0
         Downstream: Capacity=0 CommitmentLimit=0
     Capabilities: [b0] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [100 v1] Advanced Error Reporting
         UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UEMsk:    DLP- SDES- TLP- FCP- CmpltTO+ CmpltAbrt+ UnxCmplt+ 
RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
         UESvrt:    DLP+ SDES- TLP+ FCP+ CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
         CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
         CEMsk:    RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr-
         AERCap:    First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
     Capabilities: [14c v1] Power Budgeting <?>
     Capabilities: [160 v1] Device Serial Number 00-1d-09-ff-fe-65-5f-4d
     Kernel modules: shpchp

05:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708 
Gigabit Ethernet (rev 12)
     Subsystem: Dell Device 01b3
     Control: I/O- Mem+ BusMaster+ SpecCycle+ MemWINV+ VGASnoop- ParErr+ 
Stepping- SERR+ FastB2B- DisINTx+
     Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 32 (16000ns min), Cache Line Size: 64 bytes
     Interrupt: pin A routed to IRQ 112
     Region 0: Memory at f8000000 (64-bit, non-prefetchable) [size=32M]
     Capabilities: [40] PCI-X non-bridge device
         Command: DPERE- ERO- RBC=512 OST=8
         Status: Dev=05:00.0 64bit+ 133MHz+ SCD- USC- DC=simple 
DMMRBC=512 DMOST=8 DMCRS=32 RSCEM- 266MHz- 533MHz-
     Capabilities: [48] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
     Capabilities: [50] Vital Product Data
         Product Name: Broadcom NetXtreme II Ethernet Controller
         Read-only fields:
             [PN] Part number: BCM95708B0
             [EC] Engineering changes: 220197-2
             [SN] Serial number: 0123456789
             [MN] Manufacture ID: 31 34 65 34
             [RV] Reserved: checksum bad, 31 byte(s) reserved
         No end tag found
     Capabilities: [58] MSI: Enable+ Count=1/1 Maskable- 64bit+
         Address: 00000000feeff00c  Data: 41a1
     Kernel driver in use: bnx2
     Kernel modules: bnx2

06:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express 
Upstream Port (rev 01) (prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
Stepping- SERR+ FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Bus: primary=06, secondary=07, subordinate=0a, sec-latency=0
     Memory behind bridge: f4000000-f7ffffff
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
     BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [44] Express (v1) Upstream Port, MSI 00
         DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
             ExtTag- AttnBtn- AttnInd- PwrInd- RBE- 
FLReset-SlotPowerLimit 0.000W
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal+ 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 128 bytes, MaxReadReq 4096 bytes
         DevSta:    CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- 
TransPend-
         LnkCap:    Port #0, Speed 2.5GT/s, Width x8, ASPM L0s, Latency 
L0 <256ns, L1 unlimited
             ClockPM- Surprise- LLActRep- BwNot-
         LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
     Capabilities: [70] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [80] Subsystem: Device 0000:0000
     Capabilities: [100 v1] Advanced Error Reporting
         UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
         UEMsk:    DLP- SDES- TLP- FCP- CmpltTO+ CmpltAbrt+ UnxCmplt+ 
RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
         UESvrt:    DLP+ SDES- TLP+ FCP+ CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
         CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
         CEMsk:    RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr-
         AERCap:    First Error Pointer: 14, GenCap- CGenEn- ChkCap- ChkEn-
     Kernel driver in use: pcieport
     Kernel modules: shpchp

06:00.3 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express to 
PCI-X Bridge (rev 01) (prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
Stepping- SERR+ FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Bus: primary=06, secondary=0b, subordinate=0b, sec-latency=64
     Secondary status: 66MHz+ FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
     BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [44] Express (v1) PCI/PCI-X Bridge, MSI 00
         DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
             ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal+ 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop- BrConfRtry-
             MaxPayload 128 bytes, MaxReadReq 256 bytes
         DevSta:    CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- 
TransPend-
         LnkCap:    Port #0, Speed 2.5GT/s, Width x8, ASPM L0s, Latency 
L0 <256ns, L1 unlimited
             ClockPM- Surprise- LLActRep- BwNot-
         LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk- 
DLActive- BWMgmt- ABWMgmt-
     Capabilities: [6c] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [80] Subsystem: Device 0000:0000
     Capabilities: [d8] PCI-X bridge device
         Secondary Status: 64bit+ 133MHz+ SCD- USC- SCO- SRD- Freq=133MHz
         Status: Dev=00:00.3 64bit- 133MHz- SCD- USC- SCO- SRD-
         Upstream: Capacity=65535 CommitmentLimit=65535
         Downstream: Capacity=65535 CommitmentLimit=65535
     Capabilities: [100 v1] Advanced Error Reporting
         UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
         UEMsk:    DLP- SDES- TLP- FCP- CmpltTO+ CmpltAbrt+ UnxCmplt+ 
RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
         UESvrt:    DLP+ SDES- TLP+ FCP+ CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
         CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
         CEMsk:    RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr-
         AERCap:    First Error Pointer: 14, GenCap- CGenEn- ChkCap- ChkEn-
     Kernel modules: shpchp

07:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express 
Downstream Port E1 (rev 01) (prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
Stepping- SERR+ FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Bus: primary=07, secondary=08, subordinate=09, sec-latency=0
     Memory behind bridge: f4000000-f7ffffff
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
     BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [44] Express (v1) Downstream Port (Slot-), MSI 00
         DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
             ExtTag- RBE- FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal+ 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 128 bytes, MaxReadReq 4096 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-
         LnkCap:    Port #0, Speed 2.5GT/s, Width x4, ASPM L0s, Latency 
L0 <512ns, L1 unlimited
             ClockPM- Surprise- LLActRep- BwNot-
         LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
     Capabilities: [60] MSI: Enable- Count=1/1 Maskable- 64bit+
         Address: 0000000000000000  Data: 0000
     Capabilities: [70] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [80] Subsystem: Device 0000:0000
     Capabilities: [100 v1] Advanced Error Reporting
         UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UEMsk:    DLP- SDES- TLP- FCP- CmpltTO+ CmpltAbrt+ UnxCmplt+ 
RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
         UESvrt:    DLP+ SDES- TLP+ FCP+ CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
         CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
         CEMsk:    RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr-
         AERCap:    First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
     Kernel driver in use: pcieport
     Kernel modules: shpchp

07:01.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express 
Downstream Port E2 (rev 01) (prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
Stepping- SERR+ FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Bus: primary=07, secondary=0a, subordinate=0a, sec-latency=0
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
     BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [44] Express (v1) Downstream Port (Slot-), MSI 00
         DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
             ExtTag- RBE- FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal+ 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 128 bytes, MaxReadReq 4096 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-
         LnkCap:    Port #0, Speed 2.5GT/s, Width x4, ASPM L0s, Latency 
L0 unlimited, L1 unlimited
             ClockPM- Surprise- LLActRep- BwNot-
         LnkCtl:    ASPM Disabled; Disabled+ Retrain- CommClk-
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
     Capabilities: [60] MSI: Enable- Count=1/1 Maskable- 64bit+
         Address: 0000000000000000  Data: 0000
     Capabilities: [70] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [80] Subsystem: Device 0000:0000
     Capabilities: [100 v1] Advanced Error Reporting
         UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UEMsk:    DLP- SDES- TLP- FCP- CmpltTO+ CmpltAbrt+ UnxCmplt+ 
RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
         UESvrt:    DLP+ SDES- TLP+ FCP+ CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
         CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
         CEMsk:    RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr-
         AERCap:    First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
     Kernel driver in use: pcieport
     Kernel modules: shpchp

08:00.0 PCI bridge: Broadcom EPB PCI-Express to PCI-X Bridge (rev c3) 
(prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
Stepping- SERR+ FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Bus: primary=08, secondary=09, subordinate=09, sec-latency=64
     Memory behind bridge: f4000000-f7ffffff
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
     BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [60] Express (v1) PCI/PCI-X Bridge, MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
             ExtTag+ AttnBtn- AttnInd- PwrInd- RBE- FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal+ 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop- BrConfRtry-
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-
         LnkCap:    Port #0, Speed 2.5GT/s, Width x4, ASPM L0s L1, 
Latency L0 <1us, L1 <4us
             ClockPM- Surprise- LLActRep- BwNot-
         LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
     Capabilities: [90] PCI-X bridge device
         Secondary Status: 64bit+ 133MHz+ SCD- USC- SCO- SRD- Freq=133MHz
         Status: Dev=08:00.0 64bit- 133MHz- SCD- USC- SCO- SRD-
         Upstream: Capacity=0 CommitmentLimit=0
         Downstream: Capacity=0 CommitmentLimit=0
     Capabilities: [b0] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [100 v1] Advanced Error Reporting
         UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UEMsk:    DLP- SDES- TLP- FCP- CmpltTO+ CmpltAbrt+ UnxCmplt+ 
RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
         UESvrt:    DLP+ SDES- TLP+ FCP+ CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
         CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
         CEMsk:    RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr-
         AERCap:    First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
     Capabilities: [14c v1] Power Budgeting <?>
     Capabilities: [160 v1] Device Serial Number 00-1d-09-ff-fe-65-5f-4f
     Kernel modules: shpchp

09:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708 
Gigabit Ethernet (rev 12)
     Subsystem: Dell Device 01b3
     Control: I/O- Mem+ BusMaster+ SpecCycle+ MemWINV+ VGASnoop- ParErr+ 
Stepping- SERR+ FastB2B- DisINTx+
     Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 64 (16000ns min), Cache Line Size: 64 bytes
     Interrupt: pin A routed to IRQ 111
     Region 0: Memory at f4000000 (64-bit, non-prefetchable) [size=32M]
     Capabilities: [40] PCI-X non-bridge device
         Command: DPERE- ERO- RBC=512 OST=8
         Status: Dev=09:00.0 64bit+ 133MHz+ SCD- USC- DC=simple 
DMMRBC=512 DMOST=8 DMCRS=32 RSCEM- 266MHz- 533MHz-
     Capabilities: [48] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
     Capabilities: [50] Vital Product Data
         Product Name: Broadcom NetXtreme II Ethernet Controller
         Read-only fields:
             [PN] Part number: BCM95708B0
             [EC] Engineering changes: 220197-2
             [SN] Serial number: 0123456789
             [MN] Manufacture ID: 31 34 65 34
             [RV] Reserved: checksum bad, 31 byte(s) reserved
         No end tag found
     Capabilities: [58] MSI: Enable+ Count=1/1 Maskable- 64bit+
         Address: 00000000feeff00c  Data: 4199
     Kernel driver in use: bnx2
     Kernel modules: bnx2

10:0d.0 VGA compatible controller: Advanced Micro Devices [AMD] nee ATI 
ES1000 (rev 02) (prog-if 00 [VGA controller])
     Subsystem: Dell Device 01b3
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop+ ParErr- 
Stepping+ SERR+ FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 32 (2000ns min), Cache Line Size: 64 bytes
     Interrupt: pin A routed to IRQ 19
     Region 0: Memory at d0000000 (32-bit, prefetchable) [size=128M]
     Region 1: I/O ports at ec00 [size=256]
     Region 2: Memory at fc2d0000 (32-bit, non-prefetchable) [size=64K]
     [virtual] Expansion ROM at fc100000 [disabled] [size=128K]
     Capabilities: [50] Power Management version 2
         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Kernel driver in use: radeon
     Kernel modules: radeon
#v-

this problem doesn't happen in 2.6 kernels.
is there any solution to prevent hanging system?
