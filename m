Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbaJOMvB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 08:51:01 -0400
Received: from mx1.riseup.net ([198.252.153.129]:46575 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864AbaJOMuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 08:50:54 -0400
MIME-Version: 1.0
Date: Wed, 15 Oct 2014 09:50:52 -0300
Message-ID: <CA+bYFQYSEFLZNvK2_N0+nkL7+CggSubU9b4rQ5mS=z5w=E5GkA@mail.gmail.com>
Subject: Dmesg command of kernel current
From: Albino Biasutti Neto <bino@riseup.net>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I am sending the dmesg command. I compile kernel current (3.17.0-rc7+)
for testing.

STI Semp Toshiba
Core i3 370M
3Gb RAM
HD 500gbs Sata II

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.17.0-rc7+ (albino@tux) (gcc version
4.8.2 (Ubuntu 4.8.2-19ubuntu1) ) #1 SMP Sun Oct 12 08:06:54 BRT 2014
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009c3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009c400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000dc000-0x00000000000dffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e4000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000b727bfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000b727c000-0x00000000b7281fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000b7282000-0x00000000b73eafff] usable
[    0.000000] BIOS-e820: [mem 0x00000000b73eb000-0x00000000b740efff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000b740f000-0x00000000b746efff] usable
[    0.000000] BIOS-e820: [mem 0x00000000b746f000-0x00000000b746ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000b7470000-0x00000000b74f0fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000b74f1000-0x00000000b770efff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000b770f000-0x00000000b7716fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000b7717000-0x00000000b771efff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000b771f000-0x00000000b777ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000b7780000-0x00000000b779efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000b779f000-0x00000000b77e3fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000b77e4000-0x00000000b77fefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000b77ff000-0x00000000b77fffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000b7800000-0x00000000bbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f090a000-0x00000000f090afff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feaff000-0x00000000feafffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed003ff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed8ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI: Semp Toshiba IS 1423G/IS 1423G, BIOS 1.01S 05/07/2010
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0xb7800 max_arch_pfn = 0x1000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-DBFFF uncachable
[    0.000000]   DC000-FFFFF write-through
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 disabled
[    0.000000]   1 base 0B8000000 mask FF8000000 uncachable
[    0.000000]   2 base 000000000 mask F80000000 write-back
[    0.000000]   3 base 080000000 mask FC0000000 write-back
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 1, base: 2944MB, range: 128MB, type UC
[    0.000000] reg 2, base: 0GB, range: 2GB, type WB
[    0.000000] reg 3, base: 2GB, range: 1GB, type WB
[    0.000000] total RAM covered: 2944M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K chunk_size: 256M num_reg: 3   lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 2944MB, range: 128MB, type UC
[    0.000000] found SMP MP-table at [mem 0x000f6a60-0x000f6a6f]
mapped at [c00f6a60]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x021fffff]
[    0.000000] Base memory trampoline at [c0098000] 98000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x37400000-0x375fffff]
[    0.000000]  [mem 0x37400000-0x375fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x34000000-0x373fffff]
[    0.000000]  [mem 0x34000000-0x373fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x33ffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x33ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x37600000-0x377fdfff]
[    0.000000]  [mem 0x37600000-0x377fdfff] page 4k
[    0.000000] BRK [0x01bd0000, 0x01bd0fff] PGTABLE
[    0.000000] BRK [0x01bd1000, 0x01bd1fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x25eda000-0x2ef64fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x000F69A0 000024 (v02 PTLTD )
[    0.000000] ACPI: XSDT 0xB77F6088 000054 (v01 stinfo sempinfo
06040000  LTP 00000000)
[    0.000000] ACPI: FACP 0xB77E6000 0000F4 (v03 INTEL  CALPELLA
06040000 PTEC 00000001)
[    0.000000] ACPI: DSDT 0xB77E7000 008B16 (v02 Intel  CALPELLA
06040000 INTL 20060912)
[    0.000000] ACPI: FACS 0xB779BFC0 000040
[    0.000000] ACPI: HPET 0xB77FED92 000038 (v01 INTEL  CALPELLA
06040000 PTEC 00000001)
[    0.000000] ACPI: MCFG 0xB77FEDCA 00003C (v01 INTEL  CALPELLA
06040000 PTEC 00000001)
[    0.000000] ACPI: APIC 0xB77FEE06 000084 (v01 PTLTD  ? APIC
06040000  LTP 00000000)
[    0.000000] ACPI: SLIC 0xB77FEE8A 000176 (v01 stinfo sempinfo
06040000  LTP 00000000)
[    0.000000] ACPI: SSDT 0xB77E5000 0009F1 (v01 PmRef  CpuPm
00003000 INTL 20061109)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 2048MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000] BRK [0x01bd2000, 0x01bd2fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x377fdfff]
[    0.000000]   HighMem  [mem 0x377fe000-0xb77fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009bfff]
[    0.000000]   node   0: [mem 0x00100000-0xb727bfff]
[    0.000000]   node   0: [mem 0xb7282000-0xb73eafff]
[    0.000000]   node   0: [mem 0xb740f000-0xb746efff]
[    0.000000]   node   0: [mem 0xb770f000-0xb7716fff]
[    0.000000]   node   0: [mem 0xb771f000-0xb777ffff]
[    0.000000]   node   0: [mem 0xb779f000-0xb77e3fff]
[    0.000000]   node   0: [mem 0xb77ff000-0xb77fffff]
[    0.000000] On node 0 totalpages: 750735
[    0.000000] free_area_init_node: node 0, pgdat c19edc40,
node_mem_map f610e020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3995 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 223230 pages, LIFO batch:31
[    0.000000]   HighMem zone: 4097 pages used for memmap
[    0.000000]   HighMem zone: 523510 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] Reserving Intel graphics stolen memory at 0xba000000-0xbbffffff
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x0009c000-0x0009cfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dbfff]
[    0.000000] PM: Registered nosave memory: [mem 0x000dc000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000e3fff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e4000-0x000fffff]
[    0.000000] e820: [mem 0xbc000000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4
nr_node_ids:1
[    0.000000] PERCPU: Embedded 14 pages/cpu @f60c9000 s35840 r0 d21504 u57344
[    0.000000] pcpu-alloc: s35840 r0 d21504 u57344 alloc=14*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 748959
[    0.000000] Kernel command line:
BOOT_IMAGE=/boot/vmlinuz-3.17.0-rc7+
root=UUID=900de6bd-a913-4889-8618-21d24eebd934 ro quiet splash
vt.handoff=7
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] allocated 6012920 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't
want memory cgroups
[    0.000000] Initializing HighMem for node 0 (000377fe:000b7800)
[    0.000000] Initializing Movable for node 0 (00000000:00000000)
[    0.000000] Memory: 2812316K/3002940K available (6672K kernel code,
666K rwdata, 2944K rodata, 900K init, 796K bss, 190624K reserved,
2094040K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff15000 - 0xfffff000   ( 936 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffa00000   (2048 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc1a0e000 - 0xc1aef000   ( 900 kB)
[    0.000000]       .data : 0xc1684659 - 0xc1a0cbc0   (3617 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1684659   (6673 kB)
[    0.000000] Checking if this processor honours the WP bit even in
supervisor mode...Ok.
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=4.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
[    0.000000] NR_IRQS:2304 nr_irqs:456 0
[    0.000000] CPU 0 irqstacks, hard=f5408000 soft=f540a000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2394.226 MHz processor
[    0.000034] Calibrating delay loop (skipped), value calculated
using timer frequency.. 4788.45 BogoMIPS (lpj=9576904)
[    0.000037] pid_max: default: 32768 minimum: 301
[    0.000042] ACPI: Core revision 20140724
[    0.007033] ACPI: All ACPI Tables successfully acquired
[    0.019850] Security Framework initialized
[    0.019868] AppArmor: AppArmor initialized
[    0.019870] Yama: becoming mindful.
[    0.019917] Mount-cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.019919] Mountpoint-cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.020106] Initializing cgroup subsys memory
[    0.020112] Initializing cgroup subsys devices
[    0.020115] Initializing cgroup subsys freezer
[    0.020118] Initializing cgroup subsys net_cls
[    0.020120] Initializing cgroup subsys blkio
[    0.020122] Initializing cgroup subsys perf_event
[    0.020124] Initializing cgroup subsys hugetlb
[    0.020145] CPU: Physical Processor ID: 0
[    0.020147] CPU: Processor Core ID: 0
[    0.020152] mce: CPU supports 9 MCE banks
[    0.020161] CPU0: Thermal monitoring handled by SMI
[    0.020173] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
[    0.020173] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.020689] Freeing SMP alternatives memory: 32K (c1aef000 - c1af7000)
[    0.021656] ftrace: allocating 28459 entries in 56 pages
[    0.035643] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.036153] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.075865] smpboot: CPU0: Intel(R) Core(TM) i3 CPU       M 370  @
2.40GHz (fam: 06, model: 25, stepping: 05)
[    0.180557] Performance Events: PEBS fmt1+, 16-deep LBR, Westmere
events, Intel PMU driver.
[    0.180577] perf_event_intel: CPUID marked event: 'bus cycles' unavailable
[    0.180579] ... version:                3
[    0.180580] ... bit width:              48
[    0.180581] ... generic registers:      4
[    0.180582] ... value mask:             0000ffffffffffff
[    0.180583] ... max period:             000000007fffffff
[    0.180584] ... fixed-purpose events:   3
[    0.180585] ... event mask:             000000070000000f
[    0.182241] CPU 1 irqstacks, hard=f54fa000 soft=f54fc000
[    0.182243] x86: Booting SMP configuration:
[    0.182244] .... node  #0, CPUs:      #1
[    0.192507] Initializing CPU#1
[    0.193299] CPU1: Thermal monitoring handled by SMI
[    0.195475] NMI watchdog: enabled on all CPUs, permanently consumes
one hw-PMU counter.
[    0.195576] CPU 2 irqstacks, hard=f55ea000 soft=f55ec000
[    0.195578]  #2
[    0.205766] Initializing CPU#2
[    0.206634] CPU2: Thermal monitoring handled by SMI
[    0.208856] CPU 3 irqstacks, hard=f5640000 soft=f5642000
[    0.208860]  #3
[    0.219022] Initializing CPU#3
[    0.219913] CPU3: Thermal monitoring handled by SMI
[    0.222040] x86: Booted up 1 node, 4 CPUs
[    0.222045] smpboot: Total of 4 processors activated (19153.80 BogoMIPS)
[    0.224673] devtmpfs: initialized
[    0.224904] evm: security.selinux
[    0.224905] evm: security.SMACK64
[    0.224906] evm: security.ima
[    0.224907] evm: security.capability
[    0.225002] PM: Registering ACPI NVS region [mem
0xb7470000-0xb74f0fff] (528384 bytes)
[    0.225014] PM: Registering ACPI NVS region [mem
0xb7780000-0xb779efff] (126976 bytes)
[    0.226088] pinctrl core: initialized pinctrl subsystem
[    0.226175] regulator-dummy: no parameters
[    0.226214] RTC time: 14:33:45, date: 10/12/14
[    0.226312] NET: Registered protocol family 16
[    0.226501] EISA bus registered
[    0.226504] cpuidle: using governor ladder
[    0.226506] cpuidle: using governor menu
[    0.226600] ACPI: bus type PCI registered
[    0.226602] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.226690] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xe0000000-0xefffffff] (base 0xe0000000)
[    0.226693] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.226695] PCI: Using MMCONFIG for extended config space
[    0.226696] PCI: Using configuration type 1 for base access
[    0.237081] ACPI: Added _OSI(Module Device)
[    0.237084] ACPI: Added _OSI(Processor Device)
[    0.237086] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.237087] ACPI: Added _OSI(Processor Aggregator Device)
[    0.243803] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.244132] ACPI: Dynamic OEM Table Load:
[    0.244139] ACPI: SSDT 0xF5728800 000432 (v01 PmRef  Cpu0Ist
00003000 INTL 20061109)
[    0.244611] ACPI: Dynamic OEM Table Load:
[    0.244616] ACPI: SSDT 0xF5588000 000891 (v01 PmRef  Cpu0Cst
00003001 INTL 20061109)
[    0.266334] ACPI: Dynamic OEM Table Load:
[    0.266339] ACPI: SSDT 0xF5549C00 000303 (v01 PmRef  ApIst
00003000 INTL 20061109)
[    0.279588] ACPI: Dynamic OEM Table Load:
[    0.279592] ACPI: SSDT 0xF574C000 000119 (v01 PmRef  ApCst
00003000 INTL 20061109)
[    0.306500] ACPI: Interpreter enabled
[    0.306512] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep
State [\_S1_] (20140724/hwxface-580)
[    0.306517] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep
State [\_S2_] (20140724/hwxface-580)
[    0.306533] ACPI: (supports S0 S3 S4 S5)
[    0.306534] ACPI: Using IOAPIC for interrupt routing
[    0.306566] PCI: Using host bridge windows from ACPI; if necessary,
use "pci=nocrs" and report a bug
[    0.312240] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    0.312246] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM
ClockPM Segments MSI]
[    0.312284] \_SB_.PCI0:_OSC invalid UUID
[    0.312285] _OSC request data:1 1f 0
[    0.312289] acpi PNP0A08:00: _OSC failed (AE_ERROR); disabling ASPM
[    0.313087] PCI host bridge to bus 0000:00
[    0.313090] pci_bus 0000:00: root bus resource [bus 00-fe]
[    0.313092] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.313094] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.313096] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.313098] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.313099] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.313101] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
[    0.313103] pci_bus 0000:00: root bus resource [mem 0xbc000000-0xfeafffff]
[    0.313113] pci 0000:00:00.0: [8086:0044] type 00 class 0x060000
[    0.313133] DMAR: BIOS has allocated no shadow GTT; disabling IOMMU
for graphics
[    0.313221] pci 0000:00:02.0: [8086:0046] type 00 class 0x030000
[    0.313234] pci 0000:00:02.0: reg 0x10: [mem 0xf0000000-0xf03fffff 64bit]
[    0.313240] pci 0000:00:02.0: reg 0x18: [mem 0xd0000000-0xdfffffff
64bit pref]
[    0.313245] pci 0000:00:02.0: reg 0x20: [io  0x1800-0x1807]
[    0.313379] pci 0000:00:16.0: [8086:3b64] type 00 class 0x078000
[    0.313410] pci 0000:00:16.0: reg 0x10: [mem 0xf0904000-0xf090400f 64bit]
[    0.313507] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.313619] pci 0000:00:1a.0: [8086:3b3c] type 00 class 0x0c0320
[    0.313646] pci 0000:00:1a.0: reg 0x10: [mem 0xf0906000-0xf09063ff]
[    0.313758] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.313863] pci 0000:00:1b.0: [8086:3b56] type 00 class 0x040300
[    0.313888] pci 0000:00:1b.0: reg 0x10: [mem 0xf0900000-0xf0903fff 64bit]
[    0.313999] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.314055] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.314106] pci 0000:00:1c.0: [8086:3b42] type 01 class 0x060400
[    0.314216] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.314272] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.314321] pci 0000:00:1c.1: [8086:3b44] type 01 class 0x060400
[    0.314430] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.314486] pci 0000:00:1c.1: System wakeup disabled by ACPI
[    0.314535] pci 0000:00:1c.3: [8086:3b48] type 01 class 0x060400
[    0.314643] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.314698] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    0.314757] pci 0000:00:1d.0: [8086:3b34] type 00 class 0x0c0320
[    0.314784] pci 0000:00:1d.0: reg 0x10: [mem 0xf0907000-0xf09073ff]
[    0.314896] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.314962] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.315011] pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
[    0.315125] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    0.315172] pci 0000:00:1f.0: [8086:3b09] type 00 class 0x060100
[    0.315364] pci 0000:00:1f.2: [8086:3b29] type 00 class 0x010601
[    0.315393] pci 0000:00:1f.2: reg 0x10: [io  0x1818-0x181f]
[    0.315404] pci 0000:00:1f.2: reg 0x14: [io  0x180c-0x180f]
[    0.315415] pci 0000:00:1f.2: reg 0x18: [io  0x1810-0x1817]
[    0.315426] pci 0000:00:1f.2: reg 0x1c: [io  0x1808-0x180b]
[    0.315438] pci 0000:00:1f.2: reg 0x20: [io  0x1820-0x183f]
[    0.315449] pci 0000:00:1f.2: reg 0x24: [mem 0xf0908000-0xf09087ff]
[    0.315519] pci 0000:00:1f.2: PME# supported from D3hot
[    0.315614] pci 0000:00:1f.3: [8086:3b30] type 00 class 0x0c0500
[    0.315636] pci 0000:00:1f.3: reg 0x10: [mem 0xf0909000-0xf09090ff 64bit]
[    0.315667] pci 0000:00:1f.3: reg 0x20: [io  0x1840-0x185f]
[    0.315780] pci 0000:00:1f.6: [8086:3b32] type 00 class 0x118000
[    0.315809] pci 0000:00:1f.6: reg 0x10: [mem 0xf090a000-0xf090afff 64bit]
[    0.317457] pci 0000:02:00.0: [10ec:8171] type 00 class 0x028000
[    0.318458] pci 0000:02:00.0: reg 0x10: [io  0x2000-0x20ff]
[    0.319013] pci 0000:02:00.0: reg 0x14: [mem 0xf0500000-0xf0503fff]
[    0.324165] pci 0000:02:00.0: supports D1 D2
[    0.324166] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot
[    0.325590] pci 0000:02:00.0: System wakeup disabled by ACPI
[    0.326612] pci 0000:00:1c.0: PCI bridge to [bus 02-03]
[    0.326617] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.326622] pci 0000:00:1c.0:   bridge window [mem 0xf0500000-0xf05fffff]
[    0.326630] pci 0000:00:1c.0:   bridge window [mem
0xf0c00000-0xf0dfffff 64bit pref]
[    0.326792] pci 0000:04:00.0: [10ec:8168] type 00 class 0x020000
[    0.326870] pci 0000:04:00.0: reg 0x10: [io  0x3000-0x30ff]
[    0.326946] pci 0000:04:00.0: reg 0x18: [mem 0xf0a00000-0xf0a00fff
64bit pref]
[    0.327017] pci 0000:04:00.0: reg 0x20: [mem 0xf0a04000-0xf0a07fff
64bit pref]
[    0.327039] pci 0000:04:00.0: reg 0x30: [mem 0x00000000-0x0001ffff pref]
[    0.327359] pci 0000:04:00.0: supports D1 D2
[    0.327361] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.327471] pci 0000:04:00.0: System wakeup disabled by ACPI
[    0.327584] pci 0000:00:1c.1: PCI bridge to [bus 04-05]
[    0.327589] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    0.327594] pci 0000:00:1c.1:   bridge window [mem 0xf0400000-0xf04fffff]
[    0.327602] pci 0000:00:1c.1:   bridge window [mem
0xf0a00000-0xf0bfffff 64bit pref]
[    0.327682] pci 0000:00:1c.3: PCI bridge to [bus 06-07]
[    0.327687] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    0.327691] pci 0000:00:1c.3:   bridge window [mem 0xf0600000-0xf06fffff]
[    0.327699] pci 0000:00:1c.3:   bridge window [mem
0xf0e00000-0xf0ffffff 64bit pref]
[    0.327788] pci 0000:00:1e.0: PCI bridge to [bus 08] (subtractive decode)
[    0.327802] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7]
(subtractive decode)
[    0.327804] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff]
(subtractive decode)
[    0.327806] pci 0000:00:1e.0:   bridge window [mem
0x000a0000-0x000bffff] (subtractive decode)
[    0.327808] pci 0000:00:1e.0:   bridge window [mem
0x000d4000-0x000d7fff] (subtractive decode)
[    0.327809] pci 0000:00:1e.0:   bridge window [mem
0x000d8000-0x000dbfff] (subtractive decode)
[    0.327811] pci 0000:00:1e.0:   bridge window [mem
0x000e0000-0x000e3fff] (subtractive decode)
[    0.327813] pci 0000:00:1e.0:   bridge window [mem
0xbc000000-0xfeafffff] (subtractive decode)
[    0.327906] pci_bus 0000:00: on NUMA node 0
[    0.329082] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12
14 15) *11
[    0.329140] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12
14 15) *10
[    0.329196] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 *10 12 14 15)
[    0.329251] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 *5 6 7 11 12 14 15)
[    0.329308] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12
14 15) *0, disabled.
[    0.329364] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12
14 15) *0, disabled.
[    0.329420] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 *7 10 12 14 15)
[    0.329475] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.329620] ACPI: PCI Root Bridge [CPBG] (domain 0000 [bus ff])
[    0.329624] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM
ClockPM Segments MSI]
[    0.329629] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.329701] PCI host bridge to bus 0000:ff
[    0.329704] pci_bus 0000:ff: root bus resource [bus ff]
[    0.329710] pci 0000:ff:00.0: [8086:2c62] type 00 class 0x060000
[    0.329762] pci 0000:ff:00.1: [8086:2d01] type 00 class 0x060000
[    0.329818] pci 0000:ff:02.0: [8086:2d10] type 00 class 0x060000
[    0.329867] pci 0000:ff:02.1: [8086:2d11] type 00 class 0x060000
[    0.329915] pci 0000:ff:02.2: [8086:2d12] type 00 class 0x060000
[    0.329964] pci 0000:ff:02.3: [8086:2d13] type 00 class 0x060000
[    0.330022] pci_bus 0000:ff: on NUMA node 0
[    0.330115] ACPI: Enabled 8 GPEs in block 00 to 3F
[    0.330150] ACPI : EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.330281] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.330283] vgaarb: device added:
PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.330287] vgaarb: loaded
[    0.330288] vgaarb: bridge control possible 0000:00:02.0
[    0.330528] SCSI subsystem initialized
[    0.330578] libata version 3.00 loaded.
[    0.330607] ACPI: bus type USB registered
[    0.330630] usbcore: registered new interface driver usbfs
[    0.330640] usbcore: registered new interface driver hub
[    0.330662] usbcore: registered new device driver usb
[    0.330809] PCI: Using ACPI for IRQ routing
[    0.341198] PCI: pci_cache_line_size set to 64 bytes
[    0.341481] e820: reserve RAM buffer [mem 0x0009c400-0x0009ffff]
[    0.341483] e820: reserve RAM buffer [mem 0xb727c000-0xb7ffffff]
[    0.341486] e820: reserve RAM buffer [mem 0xb73eb000-0xb7ffffff]
[    0.341488] e820: reserve RAM buffer [mem 0xb746f000-0xb7ffffff]
[    0.341491] e820: reserve RAM buffer [mem 0xb7717000-0xb7ffffff]
[    0.341493] e820: reserve RAM buffer [mem 0xb7780000-0xb7ffffff]
[    0.341495] e820: reserve RAM buffer [mem 0xb77e4000-0xb7ffffff]
[    0.341497] e820: reserve RAM buffer [mem 0xb7800000-0xb7ffffff]
[    0.341622] NetLabel: Initializing
[    0.341624] NetLabel:  domain hash size = 128
[    0.341624] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.341637] NetLabel:  unlabeled traffic allowed by default
[    0.341766] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.341772] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.343816] Switched to clocksource hpet
[    0.351924] AppArmor: AppArmor Filesystem Enabled
[    0.351970] pnp: PnP ACPI init
[    0.352465] system 00:00: [io  0x0200-0x020f] has been reserved
[    0.352468] system 00:00: [io  0x0260-0x026f] has been reserved
[    0.352470] system 00:00: [io  0x0300-0x030f] has been reserved
[    0.352472] system 00:00: [io  0x0680-0x069f] has been reserved
[    0.352474] system 00:00: [io  0x0500-0x050f] has been reserved
[    0.352476] system 00:00: [io  0x0600-0x0603] has been reserved
[    0.352478] system 00:00: [io  0xffff] has been reserved
[    0.352481] system 00:00: [io  0x0400-0x047f] could not be reserved
[    0.352483] system 00:00: [io  0x1180-0x11ff] has been reserved
[    0.352485] system 00:00: [io  0x164e-0x164f] has been reserved
[    0.352487] system 00:00: [io  0xfe00] has been reserved
[    0.352491] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.352551] system 00:01: [io  0x06a0-0x06af] has been reserved
[    0.352554] system 00:01: [io  0x06b0-0x06ff] has been reserved
[    0.352556] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.352605] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.352645] pnp 00:03: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.352675] pnp 00:04: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.352982] system 00:05: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.352984] system 00:05: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.352987] system 00:05: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.352989] system 00:05: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.352991] system 00:05: [mem 0xe0000000-0xefffffff] has been reserved
[    0.352993] system 00:05: [mem 0xfeaff000-0xfeafffff] has been reserved
[    0.352996] system 00:05: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.352998] system 00:05: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.353000] system 00:05: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.353002] system 00:05: [mem 0xff000000-0xffffffff] has been reserved
[    0.353004] system 00:05: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.353007] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.353150] pnp: PnP ACPI: found 6 devices
[    0.353157] PnPBIOS: Disabled by ACPI PNP
[    0.390269] pci 0000:00:1c.0: PCI bridge to [bus 02-03]
[    0.390274] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.390281] pci 0000:00:1c.0:   bridge window [mem 0xf0500000-0xf05fffff]
[    0.390286] pci 0000:00:1c.0:   bridge window [mem
0xf0c00000-0xf0dfffff 64bit pref]
[    0.390299] pci 0000:04:00.0: BAR 6: assigned [mem
0xf0400000-0xf041ffff pref]
[    0.390301] pci 0000:00:1c.1: PCI bridge to [bus 04-05]
[    0.390305] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    0.390311] pci 0000:00:1c.1:   bridge window [mem 0xf0400000-0xf04fffff]
[    0.390316] pci 0000:00:1c.1:   bridge window [mem
0xf0a00000-0xf0bfffff 64bit pref]
[    0.390323] pci 0000:00:1c.3: PCI bridge to [bus 06-07]
[    0.390327] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    0.390333] pci 0000:00:1c.3:   bridge window [mem 0xf0600000-0xf06fffff]
[    0.390338] pci 0000:00:1c.3:   bridge window [mem
0xf0e00000-0xf0ffffff 64bit pref]
[    0.390345] pci 0000:00:1e.0: PCI bridge to [bus 08]
[    0.390361] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.390363] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.390365] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.390367] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
[    0.390368] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
[    0.390370] pci_bus 0000:00: resource 9 [mem 0x000e0000-0x000e3fff]
[    0.390372] pci_bus 0000:00: resource 10 [mem 0xbc000000-0xfeafffff]
[    0.390374] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.390376] pci_bus 0000:02: resource 1 [mem 0xf0500000-0xf05fffff]
[    0.390378] pci_bus 0000:02: resource 2 [mem 0xf0c00000-0xf0dfffff
64bit pref]
[    0.390380] pci_bus 0000:04: resource 0 [io  0x3000-0x3fff]
[    0.390382] pci_bus 0000:04: resource 1 [mem 0xf0400000-0xf04fffff]
[    0.390384] pci_bus 0000:04: resource 2 [mem 0xf0a00000-0xf0bfffff
64bit pref]
[    0.390386] pci_bus 0000:06: resource 0 [io  0x4000-0x4fff]
[    0.390387] pci_bus 0000:06: resource 1 [mem 0xf0600000-0xf06fffff]
[    0.390389] pci_bus 0000:06: resource 2 [mem 0xf0e00000-0xf0ffffff
64bit pref]
[    0.390392] pci_bus 0000:08: resource 4 [io  0x0000-0x0cf7]
[    0.390393] pci_bus 0000:08: resource 5 [io  0x0d00-0xffff]
[    0.390395] pci_bus 0000:08: resource 6 [mem 0x000a0000-0x000bffff]
[    0.390397] pci_bus 0000:08: resource 7 [mem 0x000d4000-0x000d7fff]
[    0.390399] pci_bus 0000:08: resource 8 [mem 0x000d8000-0x000dbfff]
[    0.390400] pci_bus 0000:08: resource 9 [mem 0x000e0000-0x000e3fff]
[    0.390402] pci_bus 0000:08: resource 10 [mem 0xbc000000-0xfeafffff]
[    0.390432] NET: Registered protocol family 2
[    0.390615] TCP established hash table entries: 8192 (order: 3, 32768 bytes)
[    0.390630] TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
[    0.390655] TCP: Hash tables configured (established 8192 bind 8192)
[    0.390676] TCP: reno registered
[    0.390678] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.390684] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.390731] NET: Registered protocol family 1
[    0.390746] pci 0000:00:02.0: Video device with shadowed ROM
[    0.391328] PCI: CLS 64 bytes, default 64
[    0.391379] Trying to unpack rootfs image as initramfs...
[    3.453107] Freeing initrd memory: 148012K (e5eda000 - eef65000)
[    3.453486] microcode: CPU0 sig=0x20655, pf=0x10, revision=0x1
[    3.453495] microcode: CPU1 sig=0x20655, pf=0x10, revision=0x1
[    3.453504] microcode: CPU2 sig=0x20655, pf=0x10, revision=0x1
[    3.453513] microcode: CPU3 sig=0x20655, pf=0x10, revision=0x1
[    3.453591] microcode: Microcode Update Driver: v2.00
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    3.453622] Scanning for low memory corruption every 60 seconds
[    3.454055] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    3.454084] Initialise system trusted keyring
[    3.454110] audit: initializing netlink subsys (disabled)
[    3.454127] audit: type=2000 audit(1413124428.332:1): initialized
[    3.454461] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    3.456256] zpool: loaded
[    3.456259] zbud: loaded
[    3.456369] VFS: Disk quotas dquot_6.5.2
[    3.456414] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    3.456957] fuse init (API version 7.23)
[    3.457066] msgmni has been set to 1692
[    3.457134] Key type big_key registered
[    3.457841] Key type asymmetric registered
[    3.457846] Asymmetric key parser 'x509' registered
[    3.457866] bounce: pool size: 64 pages
[    3.457878] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 252)
[    3.457936] io scheduler noop registered
[    3.457941] io scheduler deadline registered (default)
[    3.457981] io scheduler cfq registered
[    3.458661] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.458679] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    3.458737] vesafb: mode is 1024x768x32, linelength=4096, pages=0
[    3.458738] vesafb: scrolling: redraw
[    3.458740] vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    3.458763] vesafb: framebuffer at 0xd0000000, mapped to
0xf8080000, using 3072k, total 3072k
[    3.585743] Console: switching to colour frame buffer device 128x48
[    3.712714] fb0: VESA VGA frame buffer device
[    3.712741] intel_idle: MWAIT substates: 0x1120
[    3.712743] intel_idle: v0.4 model 0x25
[    3.712744] intel_idle: lapic_timer_reliable_states 0xffffffff
[    3.712941] ipmi message handler version 39.2
[    3.714012] ACPI: Deprecated procfs I/F for AC is loaded, please
retry with CONFIG_ACPI_PROCFS_POWER cleared
[    3.714630] ACPI: AC Adapter [AC0] (off-line)
[    3.714727] input: Power Button as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    3.714732] ACPI: Power Button [PWRB]
[    3.714777] input: Lid Switch as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1
[    3.715141] ACPI: Lid Switch [LID]
[    3.715278] input: Sleep Button as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
[    3.715287] ACPI: Sleep Button [SLPB]
[    3.715398] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    3.715405] ACPI: Power Button [PWRF]
[    3.718621] thermal LNXTHERM:00: registered as thermal_zone0
[    3.718625] ACPI: Thermal Zone [THRM] (52 C)
[    3.718673] GHES: HEST is not enabled!
[    3.718693] isapnp: Scanning for PnP cards...
[    3.730736] ACPI: Deprecated procfs I/F for battery is loaded,
please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    3.730743] ACPI: Battery Slot [BAT0] (battery present)
[    4.030436] isapnp: No Plug & Play device found
[    4.030771] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    4.036798] Linux agpgart interface v0.103
[    4.036881] agpgart-intel 0000:00:00.0: Intel HD Graphics Chipset
[    4.036903] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K
total, 262144K mappable
[    4.037544] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[    4.037748] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    4.039668] brd: module loaded
[    4.040501] loop: module loaded
[    4.041032] libphy: Fixed MDIO Bus: probed
[    4.041159] tun: Universal TUN/TAP device driver, 1.6
[    4.041160] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    4.041216] PPP generic driver version 2.4.2
[    4.041279] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.041284] ehci-pci: EHCI PCI platform driver
[    4.041486] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    4.041493] ehci-pci 0000:00:1a.0: new USB bus registered, assigned
bus number 1
[    4.041510] ehci-pci 0000:00:1a.0: debug port 2
[    4.045516] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    4.045536] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf0906000
[    4.054144] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    4.054207] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    4.054210] usb usb1: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    4.054212] usb usb1: Product: EHCI Host Controller
[    4.054214] usb usb1: Manufacturer: Linux 3.17.0-rc7+ ehci_hcd
[    4.054215] usb usb1: SerialNumber: 0000:00:1a.0
[    4.054376] hub 1-0:1.0: USB hub found
[    4.054383] hub 1-0:1.0: 3 ports detected
[    4.054690] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    4.054696] ehci-pci 0000:00:1d.0: new USB bus registered, assigned
bus number 2
[    4.054711] ehci-pci 0000:00:1d.0: debug port 2
[    4.058720] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    4.058735] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf0907000
[    4.070237] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    4.070360] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    4.070364] usb usb2: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    4.070367] usb usb2: Product: EHCI Host Controller
[    4.070370] usb usb2: Manufacturer: Linux 3.17.0-rc7+ ehci_hcd
[    4.070372] usb usb2: SerialNumber: 0000:00:1d.0
[    4.070581] hub 2-0:1.0: USB hub found
[    4.070592] hub 2-0:1.0: 3 ports detected
[    4.070797] ehci-platform: EHCI generic platform driver
[    4.070814] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    4.070823] ohci-pci: OHCI PCI platform driver
[    4.070843] ohci-platform: OHCI generic platform driver
[    4.070858] uhci_hcd: USB Universal Host Controller Interface driver
[    4.070976] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M]
at 0x60,0x64 irq 1,12
[    4.075452] i8042: Detected active multiplexing controller, rev 1.1
[    4.077363] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.077374] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    4.077452] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    4.077514] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    4.077578] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    4.077912] mousedev: PS/2 mouse device common for all mice
[    4.078798] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    4.078841] rtc_cmos 00:02: alarms up to one month, y3k, 242 bytes
nvram, hpet irqs
[    4.078983] device-mapper: uevent: version 1.0.3
[    4.079177] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30)
initialised: dm-devel@redhat.com
[    4.079234] platform eisa.0: Probing EISA bus 0
[    4.079240] platform eisa.0: EISA: Cannot allocate resource for mainboard
[    4.079245] platform eisa.0: Cannot allocate resource for EISA slot 1
[    4.079249] platform eisa.0: Cannot allocate resource for EISA slot 2
[    4.079254] platform eisa.0: Cannot allocate resource for EISA slot 3
[    4.079258] platform eisa.0: Cannot allocate resource for EISA slot 4
[    4.079263] platform eisa.0: Cannot allocate resource for EISA slot 5
[    4.079267] platform eisa.0: Cannot allocate resource for EISA slot 6
[    4.079271] platform eisa.0: Cannot allocate resource for EISA slot 7
[    4.079276] platform eisa.0: Cannot allocate resource for EISA slot 8
[    4.079280] platform eisa.0: EISA: Detected 0 cards
[    4.079310] cpufreq-nforce2: No nForce2 chipset.
[    4.079326] ledtrig-cpu: registered to indicate activity on CPUs
[    4.079606] TCP: cubic registered
[    4.079905] NET: Registered protocol family 10
[    4.080406] NET: Registered protocol family 17
[    4.080430] Key type dns_resolver registered
[    4.081073] Using IPI No-Shortcut mode
[    4.081393] Loading compiled-in X.509 certificates
[    4.090058] Loaded X.509 cert 'Magrathea: Glacier signing key:
1176c6c2e872565f86a3008f7a9c6e840cad1871'
[    4.090094] registered taskstats version 1
[    4.093659] Key type trusted registered
[    4.098934] Key type encrypted registered
[    4.103532] AppArmor: AppArmor sha1 policy hashing enabled
[    4.103544] ima: No TPM chip found, activating TPM-bypass!
[    4.103603] evm: HMAC attrs: 0x1
[    4.105626]   Magic number: 2:440:586
[    4.105809] rtc_cmos 00:02: setting system clock to 2014-10-12
14:33:49 UTC (1413124429)
[    4.106856] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    4.106858] EDD information not available.
[    4.106978] PM: Hibernation image not present or could not be loaded.
[    4.107298] Freeing unused kernel memory: 900K (c1a0e000 - c1aef000)
[    4.107358] Write protecting the kernel text: 6676k
[    4.107445] Write protecting the kernel read-only data: 2948k
[    4.107446] NX-protecting the kernel data: 5612k
[    4.119693] input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input4
[    4.121243] systemd-udevd[108]: starting version 204
[    4.214415] ahci 0000:00:1f.2: version 3.0
[    4.221447] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    4.221458] r8169 0000:04:00.0: can't disable ASPM; OS doesn't have
ASPM control
[    4.256473] r8169 0000:04:00.0: irq 24 for MSI/MSI-X
[    4.256819] r8169 0000:04:00.0 eth0: RTL8168d/8111d at 0xf8072000,
00:03:0d:f9:82:f1, XID 083000c0 IRQ 24
[    4.256823] r8169 0000:04:00.0 eth0: jumbo features [frames: 9200
bytes, tx checksumming: ko]
[    4.257076] ahci 0000:00:1f.2: irq 25 for MSI/MSI-X
[    4.257113] ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
[    4.257165] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 4 ports 3
Gbps 0x33 impl SATA mode
[    4.257170] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag pm
led clo pio slum part ems sxs apst
[    4.281786] scsi host0: ahci
[    4.281977] scsi host1: ahci
[    4.282138] scsi host2: ahci
[    4.282318] scsi host3: ahci
[    4.282457] scsi host4: ahci
[    4.282595] scsi host5: ahci
[    4.282683] ata1: SATA max UDMA/133 abar m2048@0xf0908000 port
0xf0908100 irq 25
[    4.282688] ata2: SATA max UDMA/133 abar m2048@0xf0908000 port
0xf0908180 irq 25
[    4.282690] ata3: DUMMY
[    4.282692] ata4: DUMMY
[    4.282695] ata5: SATA max UDMA/133 abar m2048@0xf0908000 port
0xf0908300 irq 25
[    4.282700] ata6: SATA max UDMA/133 abar m2048@0xf0908000 port
0xf0908380 irq 25
[    4.366444] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    4.450419] tsc: Refined TSC clocksource calibration: 2393.986 MHz
[    4.499073] usb 1-1: New USB device found, idVendor=8087, idProduct=0020
[    4.499078] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    4.499606] hub 1-1:1.0: USB hub found
[    4.499786] hub 1-1:1.0: 6 ports detected
[    4.602503] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.610655] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    4.612620] ata1.00: ATA-8: SAMSUNG HM500JI, 2AC101C4, max UDMA/133
[    4.612627] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    4.622813] ata1.00: configured for UDMA/133
[    4.623195] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG
HM500JI  01C4 PQ: 0 ANSI: 5
[    4.623758] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    4.623790] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks:
(500 GB/465 GiB)
[    4.623983] sd 0:0:0:0: [sda] Write Protect is off
[    4.623990] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.624207] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    4.664206]  sda: sda1 sda2 sda3
[    4.665530] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.743028] usb 2-1: New USB device found, idVendor=8087, idProduct=0020
[    4.743033] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    4.743518] hub 2-1:1.0: USB hub found
[    4.743675] hub 2-1:1.0: 8 ports detected
[    4.814788] usb 1-1.6: new full-speed USB device number 3 using ehci-pci
[    4.908681] usb 1-1.6: New USB device found, idVendor=138a, idProduct=0005
[    4.908686] usb 1-1.6: New USB device strings: Mfr=0, Product=0,
SerialNumber=1
[    4.908689] usb 1-1.6: SerialNumber: 05103e50f300
[    4.942777] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.945404] ata2.00: ATAPI: HL-DT-STDVDRAM GT32N, AS00, max UDMA/100
[    4.949473] ata2.00: configured for UDMA/100
[    4.954540] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GT32N
  AS00 PQ: 0 ANSI: 5
[    4.973711] sr 1:0:0:0: [sr0] scsi3-mmc drive: 24x/24x writer
dvd-ram cd/rw xa/form2 cdda tray
[    4.973717] cdrom: Uniform CD-ROM driver Revision: 3.20
[    4.973917] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    4.974015] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    5.014874] usb 2-1.2: new full-speed USB device number 3 using ehci-pci
[    5.111159] usb 2-1.2: New USB device found, idVendor=0d8d, idProduct=0516
[    5.111162] usb 2-1.2: New USB device strings: Mfr=1, Product=2,
SerialNumber=0
[    5.111164] usb 2-1.2: Product: HID-compliant Mouse
[    5.111166] usb 2-1.2: Manufacturer: HID-compliant Mouse
[    5.136797] hidraw: raw HID events driver (C) Jiri Kosina
[    5.161167] usbcore: registered new interface driver usbhid
[    5.161169] usbhid: USB HID core driver
[    5.169291] input: HID-compliant Mouse HID-compliant Mouse as
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2:1.0/0003:0D8D:0516.0001/input/input13
[    5.169550] hid-generic 0003:0D8D:0516.0001: input,hidraw0: USB HID
v1.10 Mouse [HID-compliant Mouse HID-compliant Mouse] on
usb-0000:00:1d.0-1.2/input0
[    5.182934] usb 2-1.5: new high-speed USB device number 4 using ehci-pci
[    5.242660] psmouse serio4: synaptics: Touchpad model: 1, fw: 7.2,
id: 0x1c0b1, caps: 0xd04733/0xa40000/0xa0000, board id: 3655, fw id:
547508
[    5.290962] ata5: SATA link down (SStatus 0 SControl 300)
[    5.300939] input: SynPS/2 Synaptics TouchPad as
/devices/platform/i8042/serio4/input/input12
[    5.451295] Switched to clocksource tsc
[    5.611128] ata6: SATA link down (SStatus 0 SControl 300)
[    6.028689] EXT4-fs (sda1): mounted filesystem with ordered data
mode. Opts: (null)
[    6.260414] usb 2-1.5: New USB device found, idVendor=1fea, idProduct=0060
[    6.260420] usb 2-1.5: New USB device strings: Mfr=1, Product=2,
SerialNumber=0
[    6.260423] usb 2-1.5: Product: USB 2.0 PC Camera
[    6.260426] usb 2-1.5: Manufacturer: Alcor Micro, Corp.
[    6.743421] random: init urandom read with 126 bits of entropy available
[    6.774928] random: nonblocking pool is initialized
[   15.607772] Adding 1686524k swap on /dev/sda2.  Priority:-1
extents:1 across:1686524k FS
[   15.829883] systemd-udevd[296]: starting version 204
[   16.308275] ACPI Warning: SystemIO range 0x00000428-0x0000042f
conflicts with OpRegion 0x00000400-0x0000047f (\PMIO)
(20140724/utaddress-258)
[   16.308283] ACPI: If an ACPI driver is available for this device,
you should use it instead of the native driver
[   16.308287] ACPI Warning: SystemIO range 0x000011c0-0x000011cf
conflicts with OpRegion 0x00001180-0x000011e3 (\GPIO)
(20140724/utaddress-258)
[   16.308290] ACPI: If an ACPI driver is available for this device,
you should use it instead of the native driver
[   16.308291] ACPI Warning: SystemIO range 0x000011b0-0x000011bf
conflicts with OpRegion 0x00001180-0x000011e3 (\GPIO)
(20140724/utaddress-258)
[   16.308294] ACPI: If an ACPI driver is available for this device,
you should use it instead of the native driver
[   16.308295] ACPI Warning: SystemIO range 0x00001180-0x000011af
conflicts with OpRegion 0x00001180-0x000011e3 (\GPIO)
(20140724/utaddress-258)
[   16.308298] ACPI: If an ACPI driver is available for this device,
you should use it instead of the native driver
[   16.308299] lpc_ich: Resource conflict(s) found affecting gpio_ich
[   16.493924] lp: driver loaded but no devices found
[   16.526150] ppdev: user-space parallel port driver
[   16.562959] mei_me 0000:00:16.0: irq 26 for MSI/MSI-X
[   16.575042] wmi: Mapper loaded
[   16.615960] intel ips 0000:00:1f.6: CPU TDP doesn't match expected
value (found 25, expected 29)
[   16.616224] intel ips 0000:00:1f.6: failed to get i915 symbols,
graphics turbo disabled until i915 loads
[   16.616323] intel ips 0000:00:1f.6: IPS driver initialized, MCP temp limit 90
[   16.752524] audit: type=1400 audit(1413124442.132:2):
apparmor="STATUS" operation="profile_load" name="/sbin/dhclient"
pid=341 comm="apparmor_parser"
[   16.752727] audit: type=1400 audit(1413124442.132:3):
apparmor="STATUS" operation="profile_load"
name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=341
comm="apparmor_parser"
[   16.752906] audit: type=1400 audit(1413124442.132:4):
apparmor="STATUS" operation="profile_load"
name="/usr/lib/connman/scripts/dhclient-script" pid=341
comm="apparmor_parser"
[   17.788981] asus_wmi: Asus Management GUID not found
[   17.957428] kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL does not work
properly. Using workaround
[   18.293694] Linux video capture interface: v2.00
[   18.485933] cfg80211: Calling CRDA to update world regulatory domain
[   18.756452] cfg80211: World regulatory domain updated:
[   18.756457] cfg80211:  DFS Master region: unset
[   18.756459] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp), (dfs_cac_time)
[   18.756462] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm), (N/A)
[   18.756464] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm), (N/A)
[   18.756465] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz),
(300 mBi, 2000 mBm), (N/A)
[   18.756467] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm), (N/A)
[   18.756469] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm), (N/A)
[   18.760603] [drm] Initialized drm 1.1.0 20060810
[   19.647088] uvcvideo: Found UVC 1.00 device USB 2.0 PC Camera (1fea:0060)
[   19.650502] input: USB 2.0 PC Camera as
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.5/2-1.5:1.0/input/input14
[   19.650613] usbcore: registered new interface driver uvcvideo
[   19.650615] USB Video Class driver (1.1.1)
[   19.815622] snd_hda_intel 0000:00:1b.0: irq 27 for MSI/MSI-X
[   20.026712] sound hdaudioC0D0: autoconfig: line_outs=1
(0x14/0x0/0x0/0x0/0x0) type:speaker
[   20.026716] sound hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   20.026719] sound hdaudioC0D0:    hp_outs=1 (0x15/0x0/0x0/0x0/0x0)
[   20.026720] sound hdaudioC0D0:    mono: mono_out=0x0
[   20.026722] sound hdaudioC0D0:    inputs:
[   20.026724] sound hdaudioC0D0:      Internal Mic=0x19
[   20.026726] sound hdaudioC0D0:      Mic=0x18
[   20.204576] input: HDA Intel MID Mic as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input15
[   20.204724] input: HDA Intel MID Headphone as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input16
[   20.208794] input: HDA Intel MID HDMI/DP,pcm=3 as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input17
[   21.394958] [drm] Memory usable by graphics device = 2048M
[   21.394962] [drm] Replacing VGA console driver
[   21.394967] checking generic (d0000000 300000) vs hw (d0000000 10000000)
[   21.394969] fb: switching to inteldrmfb from VESA VGA
[   21.395018] Console: switching to colour dummy device 80x25
[   21.420832] i915 0000:00:02.0: irq 28 for MSI/MSI-X
[   21.420852] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[   21.420856] [drm] Driver supports precise vblank timestamp query.
[   21.420948] vgaarb: device changed decodes:
PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[   21.455243] fbcon: inteldrmfb (fb0) is primary device
[   21.782064] rtl8192se: FW Power Save off (module option)
[   21.782100] rtl8192se: Driver for Realtek RTL8192SE/RTL8191SE
[   21.782100] Loading firmware rtlwifi/rtl8192sefw.bin
[   22.164018] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
[   22.621736] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
[   22.709716] Console: switching to colour frame buffer device 170x48
[   22.715124] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[   22.715127] i915 0000:00:02.0: registered panic notifier
[   22.731452] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[   22.732807] ACPI Warning: \_SB_.PCI0.GFX0.DD02._BQC: Return type
mismatch - found Reference, expected Integer (20140724/nspredef-290)
[   22.736059] acpi device:03: registered as cooling_device5
[   22.736190] input: Video Bus as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input18
[   22.736475] [drm] Initialized i915 1.6.0 20140725 for 0000:00:02.0 on minor 0
[   22.894925] EXT4-fs (sda3): mounted filesystem with ordered data
mode. Opts: (null)
[   26.727596] init: failsafe main process (630) killed by TERM signal
[   26.904143] intel ips 0000:00:1f.6: i915 driver attached,
reenabling gpu turbo
[   27.734859] audit: type=1400 audit(1413124453.108:5):
apparmor="STATUS" operation="profile_load"
name="/usr/lib/cups/backend/cups-pdf" pid=735 comm="apparmor_parser"
[   27.735185] audit: type=1400 audit(1413124453.108:6):
apparmor="STATUS" operation="profile_load" name="/usr/sbin/cupsd"
pid=735 comm="apparmor_parser"
[   27.862336] Bluetooth: Core ver 2.19
[   27.862354] NET: Registered protocol family 31
[   27.862356] Bluetooth: HCI device and connection manager initialized
[   27.862364] Bluetooth: HCI socket layer initialized
[   27.862366] Bluetooth: L2CAP socket layer initialized
[   27.862373] Bluetooth: SCO socket layer initialized
[   27.877359] init: cups main process (745) killed by HUP signal
[   27.877375] init: cups main process ended, respawning
[   28.203403] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   28.203407] Bluetooth: BNEP filters: protocol multicast
[   28.203418] Bluetooth: BNEP socket layer initialized
[   28.222078] Bluetooth: RFCOMM TTY layer initialized
[   28.222100] Bluetooth: RFCOMM socket layer initialized
[   28.222115] Bluetooth: RFCOMM ver 1.11
[   28.873174] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   29.086765] r8169 0000:04:00.0 eth0: link down
[   29.086913] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   29.251607] audit: type=1400 audit(1413124454.624:7):
apparmor="STATUS" operation="profile_load"
name="/usr/lib/lightdm/lightdm-guest-session" pid=800
comm="apparmor_parser"
[   29.251890] audit: type=1400 audit(1413124454.624:8):
apparmor="STATUS" operation="profile_load" name="chromium" pid=800
comm="apparmor_parser"
[   29.278851] audit: type=1400 audit(1413124454.652:9):
apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient"
pid=801 comm="apparmor_parser"
[   29.279121] audit: type=1400 audit(1413124454.652:10):
apparmor="STATUS" operation="profile_replace"
name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=801
comm="apparmor_parser"
[   29.279326] audit: type=1400 audit(1413124454.652:11):
apparmor="STATUS" operation="profile_replace"
name="/usr/lib/connman/scripts/dhclient-script" pid=801
comm="apparmor_parser"
[   29.284311] audit: type=1400 audit(1413124454.656:12):
apparmor="STATUS" operation="profile_replace"
name="/usr/lib/cups/backend/cups-pdf" pid=812 comm="apparmor_parser"
[   29.284321] audit: type=1400 audit(1413124454.656:13):
apparmor="STATUS" operation="profile_replace" name="/usr/sbin/cupsd"
pid=812 comm="apparmor_parser"
[   29.285120] audit: type=1400 audit(1413124454.656:14):
apparmor="STATUS" operation="profile_replace" name="/usr/sbin/cupsd"
pid=812 comm="apparmor_parser"
[   30.775178] wlan0: authenticate with 00:0f:66:35:03:d2
[   30.796934] wlan0: send auth to 00:0f:66:35:03:d2 (try 1/3)
[   30.800218] wlan0: authenticated
[   30.800359] rtl8192se 0000:02:00.0 wlan0: disabling HT/VHT due to
WEP/TKIP use
[   30.800364] rtl8192se 0000:02:00.0 wlan0: disabling HT as WMM/QoS
is not supported by the AP
[   30.800367] rtl8192se 0000:02:00.0 wlan0: disabling VHT as WMM/QoS
is not supported by the AP
[   30.802482] wlan0: associate with 00:0f:66:35:03:d2 (try 1/3)
[   30.805753] wlan0: RX AssocResp from 00:0f:66:35:03:d2 (capab=0x15
status=0 aid=3)
[   30.809326] wlan0: associated
[   30.809340] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   30.811311] wlan0: deauthenticating from 00:0f:66:35:03:d2 by local
choice (Reason: 2=PREV_AUTH_NOT_VALID)
[   30.845404] cfg80211: Calling CRDA to update world regulatory domain
[   30.845692] wlan0: authenticate with 00:0f:66:35:03:d2
[   30.856569] wlan0: send auth to 00:0f:66:35:03:d2 (try 1/3)
[   30.856708] cfg80211: World regulatory domain updated:
[   30.856711] cfg80211:  DFS Master region: unset
[   30.856713] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp), (dfs_cac_time)
[   30.856715] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm), (N/A)
[   30.856717] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm), (N/A)
[   30.856719] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz),
(300 mBi, 2000 mBm), (N/A)
[   30.856721] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm), (N/A)
[   30.856723] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm), (N/A)
[   30.858783] wlan0: authenticated
[   30.858918] rtl8192se 0000:02:00.0 wlan0: disabling HT/VHT due to
WEP/TKIP use
[   30.858923] rtl8192se 0000:02:00.0 wlan0: disabling HT as WMM/QoS
is not supported by the AP
[   30.858926] rtl8192se 0000:02:00.0 wlan0: disabling VHT as WMM/QoS
is not supported by the AP
[   30.862481] wlan0: associate with 00:0f:66:35:03:d2 (try 1/3)
[   30.865433] wlan0: RX AssocResp from 00:0f:66:35:03:d2 (capab=0x15
status=0 aid=4)
[   30.868916] wlan0: associated
[   33.180992] audit_printk_skb: 21 callbacks suppressed
[   33.180996] audit: type=1400 audit(1413124458.552:22):
apparmor="STATUS" operation="profile_load" name="/usr/bin/evince"
pid=802 comm="apparmor_parser"
[   33.181456] audit: type=1400 audit(1413124458.552:23):
apparmor="STATUS" operation="profile_load" name="sanitized_helper"
pid=802 comm="apparmor_parser"
[   33.182288] audit: type=1400 audit(1413124458.552:24):
apparmor="STATUS" operation="profile_load"
name="/usr/bin/evince-previewer" pid=802 comm="apparmor_parser"
[   33.182550] audit: type=1400 audit(1413124458.552:25):
apparmor="STATUS" operation="profile_load" name="sanitized_helper"
pid=802 comm="apparmor_parser"
[   33.183113] audit: type=1400 audit(1413124458.552:26):
apparmor="STATUS" operation="profile_load"
name="/usr/bin/evince-thumbnailer" pid=802 comm="apparmor_parser"
[   33.183323] audit: type=1400 audit(1413124458.552:27):
apparmor="STATUS" operation="profile_load" name="sanitized_helper"
pid=802 comm="apparmor_parser"
[   33.446328] audit: type=1400 audit(1413124458.816:28):
apparmor="STATUS" operation="profile_replace"
name="/usr/sbin/cups-browsed" pid=953 comm="apparmor_parser"
[   35.886517] init: plymouth-upstart-bridge main process ended, respawning
[   35.896053] init: plymouth-upstart-bridge main process ended, respawning
[   40.877338] wlan0: deauthenticating from 00:0f:66:35:03:d2 by local
choice (Reason: 3=DEAUTH_LEAVING)
[   40.911983] cfg80211: Calling CRDA to update world regulatory domain
[   40.914728] cfg80211: World regulatory domain updated:
[   40.914732] cfg80211:  DFS Master region: unset
[   40.914733] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp), (dfs_cac_time)
[   40.914736] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm), (N/A)
[   40.914738] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm), (N/A)
[   40.914740] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz),
(300 mBi, 2000 mBm), (N/A)
[   40.914742] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm), (N/A)
[   40.914743] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm), (N/A)
[   42.066200] wlan0: authenticate with 00:0f:66:35:03:d2
[   42.087798] wlan0: send auth to 00:0f:66:35:03:d2 (try 1/3)
[   42.090138] wlan0: authenticated
[   42.090453] rtl8192se 0000:02:00.0 wlan0: disabling HT/VHT due to
WEP/TKIP use
[   42.090457] rtl8192se 0000:02:00.0 wlan0: disabling HT as WMM/QoS
is not supported by the AP
[   42.090460] rtl8192se 0000:02:00.0 wlan0: disabling VHT as WMM/QoS
is not supported by the AP
[   42.093402] wlan0: associate with 00:0f:66:35:03:d2 (try 1/3)
[   42.095868] wlan0: RX AssocResp from 00:0f:66:35:03:d2 (capab=0x15
status=0 aid=5)
[   42.098985] wlan0: associated
[   57.965878] audit: type=1400 audit(1413124483.320:29):
apparmor="STATUS" operation="profile_replace"
name="/usr/lib/cups/backend/cups-pdf" pid=1496 comm="apparmor_parser"
[   57.965886] audit: type=1400 audit(1413124483.320:30):
apparmor="STATUS" operation="profile_replace" name="/usr/sbin/cupsd"
pid=1496 comm="apparmor_parser"
[   57.966359] audit: type=1400 audit(1413124483.320:31):
apparmor="STATUS" operation="profile_replace" name="/usr/sbin/cupsd"
pid=1496 comm="apparmor_parser"
[  139.895417] init: tty1 main process ended, respawning


                          Albino
                          binoanb.eti.br
