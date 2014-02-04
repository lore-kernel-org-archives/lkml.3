Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbaBDJQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 04:16:49 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.219]:52107 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999AbaBDJQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 04:16:30 -0500
X-Greylist: delayed 358 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Feb 2014 04:16:28 EST
X-RZG-AUTH: :PmMGcFK8W/5pU+Ks2M0NQC5NPKaCTD3iBS6utBjx84tOfLS6aDDJsDWX7bo=
X-RZG-CLASS-ID: mo00
Message-ID: <52F0AE6B.9070809@au-79.de>
Date: Tue, 04 Feb 2014 10:10:03 +0100
From: Robert Goldner <robert@au-79.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Problem with Wake-up after suspend to ram
References: <52F0A66E.2070203@au-79.de>
In-Reply-To: <52F0A66E.2070203@au-79.de>
X-Forwarded-Message-Id: <52F0A66E.2070203@au-79.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I tryed to get suspend to ram on my system working. The system gets
sleeping and wakes up again (by wake-up on LAN).

But I got some trouble with one of my DVB-T cards after wake-up.

If there are any further questions, please let me know.

Regards

Robert

dmesg:
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.10.28-agathe (root@agathe) (gcc version
4.8.2 (Debian 4.8.2-14) ) #8 SMP Mon Jan 27 08:51:10 CET 2014
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.10.28-agathe
root=UUID=2e02f109-9a26-41a3-8068-0b70b84ce2df ro quiet
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009ebff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009ec00-0x000000000009ffff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff]
reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000a7b2dfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000a7b2e000-0x00000000a7b82fff]
ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000a7b83000-0x00000000a7cb6fff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000a7cb7000-0x00000000a7cc7fff]
ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000a7cc8000-0x00000000a7cdafff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000a7cdb000-0x00000000a7cdbfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000a7cdc000-0x00000000a7ce3fff]
ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000a7ce4000-0x00000000a7d47fff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000a7d48000-0x00000000a7d8afff]
ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000a7d8b000-0x00000000a7efffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec10000-0x00000000fec10fff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed00fff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed61000-0x00000000fed70fff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed80000-0x00000000fed8ffff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fef00000-0x00000000ffffffff]
reserved
[    0.000000] BIOS-e820: [mem 0x0000000100001000-0x000000013effffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI: System manufacturer System Product Name/E35M1-M PRO,
BIOS 1602 08/06/2012
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x13f000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF write-through
[    0.000000]   C0000-CEFFF write-protect
[    0.000000]   CF000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F00000000 write-back
[    0.000000]   1 base 0A7F00000 mask FFFF00000 uncachable
[    0.000000]   2 base 0A8000000 mask FF8000000 uncachable
[    0.000000]   3 base 0B0000000 mask FF0000000 uncachable
[    0.000000]   4 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 000000013f000000 aka 5104M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new
0x7010600070106
[    0.000000] e820: update [mem 0xa7f00000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xa7f00 max_arch_pfn = 0x400000000
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01a5d000, 0x01a5dfff] PGTABLE
[    0.000000] BRK [0x01a5e000, 0x01a5efff] PGTABLE
[    0.000000] BRK [0x01a5f000, 0x01a5ffff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13ee00000-0x13effffff]
[    0.000000]  [mem 0x13ee00000-0x13effffff] page 2M
[    0.000000] BRK [0x01a60000, 0x01a60fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13c000000-0x13edfffff]
[    0.000000]  [mem 0x13c000000-0x13edfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x100001000-0x13bffffff]
[    0.000000]  [mem 0x100001000-0x1001fffff] page 4k
[    0.000000]  [mem 0x100200000-0x13bffffff] page 2M
[    0.000000] BRK [0x01a61000, 0x01a61fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0xa7b2dfff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x7fffffff] page 1G
[    0.000000]  [mem 0x80000000-0xa79fffff] page 2M
[    0.000000]  [mem 0xa7a00000-0xa7b2dfff] page 4k
[    0.000000] init_memory_mapping: [mem 0xa7cdb000-0xa7cdbfff]
[    0.000000]  [mem 0xa7cdb000-0xa7cdbfff] page 4k
[    0.000000] BRK [0x01a62000, 0x01a62fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xa7d8b000-0xa7efffff]
[    0.000000]  [mem 0xa7d8b000-0xa7efffff] page 4k
[    0.000000] RAMDISK: [mem 0x3789c000-0x37c45fff]
[    0.000000] ACPI: RSDP 00000000000f0430 00024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 00000000a7b78068 00054 (v01 ALASKA    A M I
01072009 AMI  00010013)
[    0.000000] ACPI: FACP 00000000a7b7e2e8 000F4 (v04 ALASKA    A M I
01072009 AMI  00010013)
[    0.000000] ACPI BIOS Bug: Warning: Optional FADT field
Pm2ControlBlock has zero address or length: 0x0000000000000000/0x1
(20130328/tbfadt-603)
[    0.000000] ACPI: DSDT 00000000a7b78150 06192 (v02 ALASKA    A M I
00000000 INTL 20051117)
[    0.000000] ACPI: FACS 00000000a7ce3f80 00040
[    0.000000] ACPI: APIC 00000000a7b7e3e0 00062 (v03 ALASKA    A M I
01072009 AMI  00010013)
[    0.000000] ACPI: MCFG 00000000a7b7e448 0003C (v01 ALASKA    A M I
01072009 MSFT 00010013)
[    0.000000] ACPI: HPET 00000000a7b7e488 00038 (v01 ALASKA    A M I
01072009 AMI  00000004)
[    0.000000] ACPI: SSDT 00000000a7b7e4c0 003DE (v01 AMD    POWERNOW
00000001 AMD  00000001)
[    0.000000] ACPI: SSDT 00000000a7b7e8a0 012FA (v02    AMD     ALIB
00000001 MSFT 04000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000013effffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x13effffff]
[    0.000000]   NODE_DATA [mem 0x13eff9000-0x13effcfff]
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD ->
[ffff88013ac00000-ffff88013dffffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x13effffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0xa7b2dfff]
[    0.000000]   node   0: [mem 0xa7cdb000-0xa7cdbfff]
[    0.000000]   node   0: [mem 0xa7d8b000-0xa7efffff]
[    0.000000]   node   0: [mem 0x100001000-0x13effffff]
[    0.000000] On node 0 totalpages: 945216
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3997 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 9341 pages used for memmap
[    0.000000]   DMA32 zone: 683172 pages, LIFO batch:31
[    0.000000]   Normal zone: 3528 pages used for memmap
[    0.000000]   Normal zone: 258047 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 33, address 0xfec00000, GSI
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0xffffffff base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009e000 -
000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 -
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 -
00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 -
0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000a7b2e000 -
00000000a7b83000
[    0.000000] PM: Registered nosave memory: 00000000a7b83000 -
00000000a7cb7000
[    0.000000] PM: Registered nosave memory: 00000000a7cb7000 -
00000000a7cc8000
[    0.000000] PM: Registered nosave memory: 00000000a7cc8000 -
00000000a7cdb000
[    0.000000] PM: Registered nosave memory: 00000000a7cdc000 -
00000000a7ce4000
[    0.000000] PM: Registered nosave memory: 00000000a7ce4000 -
00000000a7d48000
[    0.000000] PM: Registered nosave memory: 00000000a7d48000 -
00000000a7d8b000
[    0.000000] PM: Registered nosave memory: 00000000a7f00000 -
00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 -
00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 -
00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 -
00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 -
00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 -
00000000fec11000
[    0.000000] PM: Registered nosave memory: 00000000fec11000 -
00000000fed00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 -
00000000fed01000
[    0.000000] PM: Registered nosave memory: 00000000fed01000 -
00000000fed61000
[    0.000000] PM: Registered nosave memory: 00000000fed61000 -
00000000fed71000
[    0.000000] PM: Registered nosave memory: 00000000fed71000 -
00000000fed80000
[    0.000000] PM: Registered nosave memory: 00000000fed80000 -
00000000fed90000
[    0.000000] PM: Registered nosave memory: 00000000fed90000 -
00000000fef00000
[    0.000000] PM: Registered nosave memory: 00000000fef00000 -
0000000100000000
[    0.000000] PM: Registered nosave memory: 0000000100000000 -
0000000100001000
[    0.000000] e820: [mem 0xa7f00000-0xdfffffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2
nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88013ec00000 s79808
r8192 d22592 u1048576
[    0.000000] pcpu-alloc: s79808 r8192 d22592 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.
Total pages: 932270
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line:
BOOT_IMAGE=/boot/vmlinuz-3.10.28-agathe
root=UUID=2e02f109-9a26-41a3-8068-0b70b84ce2df ro quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 3646764k/5226496k available (5079k kernel code,
1445632k absent, 134100k reserved, 3739k data, 912k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=2.
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.004000] tsc: Detected 1600.095 MHz processor
[    0.000005] Calibrating delay loop (skipped), value calculated using
timer frequency.. 3200.19 BogoMIPS (lpj=6400380)
[    0.000011] pid_max: default: 32768 minimum: 301
[    0.000067] Security Framework initialized
[    0.000077] AppArmor: AppArmor disabled by boot time parameter
[    0.000505] Dentry cache hash table entries: 524288 (order: 10,
4194304 bytes)
[    0.003142] Inode-cache hash table entries: 262144 (order: 9, 2097152
bytes)
[    0.004395] Mount-cache hash table entries: 256
[    0.004774] Initializing cgroup subsys devices
[    0.004783] Initializing cgroup subsys freezer
[    0.004786] Initializing cgroup subsys net_cls
[    0.004789] Initializing cgroup subsys blkio
[    0.004792] Initializing cgroup subsys perf_event
[    0.004844] tseg: 00a7f00000
[    0.004849] CPU: Physical Processor ID: 0
[    0.004851] CPU: Processor Core ID: 0
[    0.004854] mce: CPU supports 6 MCE banks
[    0.004870] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 4
[    0.004870] Last level dTLB entries: 4KB 512, 2MB 8, 4MB 4
[    0.004870] tlb_flushall_shift: 5
[    0.005034] Freeing SMP alternatives: 20k freed
[    0.005051] ACPI: Core revision 20130328
[    0.010429] ACPI: All ACPI Tables successfully acquired
[    0.017228] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.056922] smpboot: CPU0: AMD E-350 Processor (fam: 14, model: 01,
stepping: 00)
[    0.164446] Performance Events: AMD PMU driver.
[    0.164455] ... version:                0
[    0.164458] ... bit width:              48
[    0.164460] ... generic registers:      4
[    0.164462] ... value mask:             0000ffffffffffff
[    0.164465] ... max period:             00007fffffffffff
[    0.164467] ... fixed-purpose events:   0
[    0.164469] ... event mask:             000000000000000f
[    0.164879] NMI watchdog: enabled on all CPUs, permanently consumes
one hw-PMU counter.
[    0.165070] smpboot: Booting Node   0, Processors  #1 OK
[    0.178158] Brought up 2 CPUs
[    0.178163] smpboot: Total of 2 processors activated (6400.38 BogoMIPS)
[    0.179131] devtmpfs: initialized
[    0.179685] PM: Registering ACPI NVS region [mem
0xa7b2e000-0xa7b82fff] (348160 bytes)
[    0.179719] PM: Registering ACPI NVS region [mem
0xa7cb7000-0xa7cc7fff] (69632 bytes)
[    0.179725] PM: Registering ACPI NVS region [mem
0xa7cdc000-0xa7ce3fff] (32768 bytes)
[    0.179732] PM: Registering ACPI NVS region [mem
0xa7d48000-0xa7d8afff] (274432 bytes)
[    0.180118] NET: Registered protocol family 16
[    0.180430] ACPI: bus type PCI registered
[    0.180534] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xe0000000-0xefffffff] (base 0xe0000000)
[    0.180539] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.203094] PCI: Using configuration type 1 for base access
[    0.203298] mtrr: your CPUs had inconsistent fixed MTRR settings
[    0.203302] mtrr: probably your BIOS does not setup all CPUs.
[    0.203304] mtrr: corrected configuration.
[    0.204774] bio: create slab <bio-0> at 0
[    0.205035] ACPI: Added _OSI(Module Device)
[    0.205039] ACPI: Added _OSI(Processor Device)
[    0.205043] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.205046] ACPI: Added _OSI(Processor Aggregator Device)
[    0.206277] ACPI: EC: Look up EC in DSDT
[    0.208100] ACPI: Executed 3 blocks of module-level executable AML code
[    0.221328] ACPI: Interpreter enabled
[    0.221347] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep
State [\_S1_] (20130328/hwxface-568)
[    0.221357] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep
State [\_S2_] (20130328/hwxface-568)
[    0.221384] ACPI: (supports S0 S3 S4 S5)
[    0.221388] ACPI: Using IOAPIC for interrupt routing
[    0.221677] PCI: Using host bridge windows from ACPI; if necessary,
use "pci=nocrs" and report a bug
[    0.221813] ACPI: No dock devices found.
[    0.348913] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.349347] acpi PNP0A08:00: ignoring host bridge window [mem
0x000c8000-0x000dffff] (conflicts with Video ROM [mem
0x000c0000-0x000ce1ff])
[    0.349404] PCI host bridge to bus 0000:00
[    0.349411] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.349416] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.349420] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.349425] pci_bus 0000:00: root bus resource [mem
0x000a0000-0x000bffff]
[    0.349429] pci_bus 0000:00: root bus resource [mem
0xc0000000-0xffffffff]
[    0.349446] pci 0000:00:00.0: [1022:1510] type 00 class 0x060000
[    0.349619] pci 0000:00:01.0: [1002:9802] type 00 class 0x030000
[    0.349635] pci 0000:00:01.0: reg 10: [mem 0xc0000000-0xcfffffff pref]
[    0.349645] pci 0000:00:01.0: reg 14: [io  0xf000-0xf0ff]
[    0.349655] pci 0000:00:01.0: reg 18: [mem 0xfd100000-0xfd13ffff]
[    0.349717] pci 0000:00:01.0: supports D1 D2
[    0.349845] pci 0000:00:01.1: [1002:1314] type 00 class 0x040300
[    0.349859] pci 0000:00:01.1: reg 10: [mem 0xfd144000-0xfd147fff]
[    0.349931] pci 0000:00:01.1: supports D1 D2
[    0.350090] pci 0000:00:11.0: [1002:4390] type 00 class 0x01018f
[    0.350117] pci 0000:00:11.0: reg 10: [io  0xf190-0xf197]
[    0.350131] pci 0000:00:11.0: reg 14: [io  0xf180-0xf183]
[    0.350146] pci 0000:00:11.0: reg 18: [io  0xf170-0xf177]
[    0.350159] pci 0000:00:11.0: reg 1c: [io  0xf160-0xf163]
[    0.350173] pci 0000:00:11.0: reg 20: [io  0xf150-0xf15f]
[    0.350187] pci 0000:00:11.0: reg 24: [mem 0xfd14f000-0xfd14f3ff]
[    0.350216] pci 0000:00:11.0: set SATA to AHCI mode
[    0.350390] pci 0000:00:12.0: [1002:4397] type 00 class 0x0c0310
[    0.350410] pci 0000:00:12.0: reg 10: [mem 0xfd14e000-0xfd14efff]
[    0.350565] pci 0000:00:12.0: System wakeup disabled by ACPI
[    0.350653] pci 0000:00:12.2: [1002:4396] type 00 class 0x0c0320
[    0.350680] pci 0000:00:12.2: reg 10: [mem 0xfd14d000-0xfd14d0ff]
[    0.350789] pci 0000:00:12.2: supports D1 D2
[    0.350793] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.350884] pci 0000:00:12.2: System wakeup disabled by ACPI
[    0.350951] pci 0000:00:13.0: [1002:4397] type 00 class 0x0c0310
[    0.350971] pci 0000:00:13.0: reg 10: [mem 0xfd14c000-0xfd14cfff]
[    0.351120] pci 0000:00:13.0: System wakeup disabled by ACPI
[    0.351189] pci 0000:00:13.2: [1002:4396] type 00 class 0x0c0320
[    0.351217] pci 0000:00:13.2: reg 10: [mem 0xfd14b000-0xfd14b0ff]
[    0.351325] pci 0000:00:13.2: supports D1 D2
[    0.351329] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.351416] pci 0000:00:13.2: System wakeup disabled by ACPI
[    0.351484] pci 0000:00:14.0: [1002:4385] type 00 class 0x0c0500
[    0.351690] pci 0000:00:14.1: [1002:439c] type 00 class 0x01018a
[    0.351711] pci 0000:00:14.1: reg 10: [io  0xf140-0xf147]
[    0.351724] pci 0000:00:14.1: reg 14: [io  0xf130-0xf133]
[    0.351738] pci 0000:00:14.1: reg 18: [io  0xf120-0xf127]
[    0.351752] pci 0000:00:14.1: reg 1c: [io  0xf110-0xf113]
[    0.351766] pci 0000:00:14.1: reg 20: [io  0xf100-0xf10f]
[    0.351924] pci 0000:00:14.2: [1002:4383] type 00 class 0x040300
[    0.351954] pci 0000:00:14.2: reg 10: [mem 0xfd140000-0xfd143fff 64bit]
[    0.352042] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.352128] pci 0000:00:14.2: System wakeup disabled by ACPI
[    0.352189] pci 0000:00:14.3: [1002:439d] type 00 class 0x060100
[    0.352396] pci 0000:00:14.4: [1002:4384] type 01 class 0x060401
[    0.352533] pci 0000:00:14.4: System wakeup disabled by ACPI
[    0.352594] pci 0000:00:14.5: [1002:4399] type 00 class 0x0c0310
[    0.352614] pci 0000:00:14.5: reg 10: [mem 0xfd14a000-0xfd14afff]
[    0.352762] pci 0000:00:14.5: System wakeup disabled by ACPI
[    0.352833] pci 0000:00:15.0: [1002:43a0] type 01 class 0x060400
[    0.352938] pci 0000:00:15.0: supports D1 D2
[    0.353029] pci 0000:00:15.0: System wakeup disabled by ACPI
[    0.353098] pci 0000:00:15.1: [1002:43a1] type 01 class 0x060400
[    0.353202] pci 0000:00:15.1: supports D1 D2
[    0.353293] pci 0000:00:15.1: System wakeup disabled by ACPI
[    0.353361] pci 0000:00:15.2: [1002:43a2] type 01 class 0x060400
[    0.353464] pci 0000:00:15.2: supports D1 D2
[    0.353555] pci 0000:00:15.2: System wakeup disabled by ACPI
[    0.353623] pci 0000:00:15.3: [1002:43a3] type 01 class 0x060400
[    0.353727] pci 0000:00:15.3: supports D1 D2
[    0.353820] pci 0000:00:15.3: System wakeup disabled by ACPI
[    0.353891] pci 0000:00:16.0: [1002:4397] type 00 class 0x0c0310
[    0.353911] pci 0000:00:16.0: reg 10: [mem 0xfd149000-0xfd149fff]
[    0.354062] pci 0000:00:16.0: System wakeup disabled by ACPI
[    0.354131] pci 0000:00:16.2: [1002:4396] type 00 class 0x0c0320
[    0.354158] pci 0000:00:16.2: reg 10: [mem 0xfd148000-0xfd1480ff]
[    0.354267] pci 0000:00:16.2: supports D1 D2
[    0.354270] pci 0000:00:16.2: PME# supported from D0 D1 D2 D3hot
[    0.354357] pci 0000:00:16.2: System wakeup disabled by ACPI
[    0.354428] pci 0000:00:18.0: [1022:1700] type 00 class 0x060000
[    0.354580] pci 0000:00:18.1: [1022:1701] type 00 class 0x060000
[    0.354726] pci 0000:00:18.2: [1022:1702] type 00 class 0x060000
[    0.354874] pci 0000:00:18.3: [1022:1703] type 00 class 0x060000
[    0.355035] pci 0000:00:18.4: [1022:1704] type 00 class 0x060000
[    0.355181] pci 0000:00:18.5: [1022:1718] type 00 class 0x060000
[    0.355327] pci 0000:00:18.6: [1022:1716] type 00 class 0x060000
[    0.355475] pci 0000:00:18.7: [1022:1719] type 00 class 0x060000
[    0.355733] pci 0000:00:14.4: PCI bridge to [bus 01] (subtractive decode)
[    0.355748] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7]
(subtractive decode)
[    0.355752] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff]
(subtractive decode)
[    0.355756] pci 0000:00:14.4:   bridge window [mem
0x000a0000-0x000bffff] (subtractive decode)
[    0.355760] pci 0000:00:14.4:   bridge window [mem
0xc0000000-0xffffffff] (subtractive decode)
[    0.355880] pci 0000:02:00.0: [1131:7164] type 00 class 0x048000
[    0.355916] pci 0000:02:00.0: reg 10: [mem 0xfd800000-0xfdbfffff 64bit]
[    0.355944] pci 0000:02:00.0: reg 18: [mem 0xfd400000-0xfd7fffff 64bit]
[    0.356081] pci 0000:02:00.0: supports D1 D2
[    0.356085] pci 0000:02:00.0: PME# supported from D0 D1 D2
[    0.360677] pci 0000:00:15.0: PCI bridge to [bus 02]
[    0.360708] pci 0000:00:15.0:   bridge window [mem 0xfd400000-0xfdbfffff]
[    0.360884] pci 0000:03:00.0: [10ec:8168] type 00 class 0x020000
[    0.360913] pci 0000:03:00.0: reg 10: [io  0xe000-0xe0ff]
[    0.360953] pci 0000:03:00.0: reg 18: [mem 0xd0004000-0xd0004fff
64bit pref]
[    0.360978] pci 0000:03:00.0: reg 20: [mem 0xd0000000-0xd0003fff
64bit pref]
[    0.361083] pci 0000:03:00.0: supports D1 D2
[    0.361087] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.361165] pci 0000:03:00.0: System wakeup disabled by ACPI
[    0.368672] pci 0000:00:15.1: PCI bridge to [bus 03]
[    0.368699] pci 0000:00:15.1:   bridge window [io  0xe000-0xefff]
[    0.368715] pci 0000:00:15.1:   bridge window [mem
0xd0000000-0xd00fffff 64bit pref]
[    0.368878] pci 0000:04:00.0: [1b21:1080] type 01 class 0x060401
[    0.369051] pci 0000:04:00.0: System wakeup disabled by ACPI
[    0.369126] pci 0000:00:15.2: PCI bridge to [bus 04-05]
[    0.369137] pci 0000:00:15.2:   bridge window [io  0xd000-0xdfff]
[    0.369143] pci 0000:00:15.2:   bridge window [mem 0xfa000000-0xfd0fffff]
[    0.369244] pci 0000:05:00.0: [14f1:8800] type 00 class 0x040000
[    0.369284] pci 0000:05:00.0: reg 10: [mem 0xfc000000-0xfcffffff]
[    0.369530] pci 0000:05:00.1: [14f1:8811] type 00 class 0x048000
[    0.369565] pci 0000:05:00.1: reg 10: [mem 0xfb000000-0xfbffffff]
[    0.369789] pci 0000:05:00.2: [14f1:8802] type 00 class 0x048000
[    0.369824] pci 0000:05:00.2: reg 10: [mem 0xfa000000-0xfaffffff]
[    0.370063] pci 0000:05:02.0: [1106:3044] type 00 class 0x0c0010
[    0.370100] pci 0000:05:02.0: reg 10: [mem 0xfd000000-0xfd0007ff]
[    0.370120] pci 0000:05:02.0: reg 14: [io  0xd000-0xd07f]
[    0.370264] pci 0000:05:02.0: supports D2
[    0.370268] pci 0000:05:02.0: PME# supported from D2 D3hot D3cold
[    0.370408] pci 0000:04:00.0: PCI bridge to [bus 05] (subtractive decode)
[    0.370421] pci 0000:04:00.0:   bridge window [io  0xd000-0xdfff]
[    0.370428] pci 0000:04:00.0:   bridge window [mem 0xfa000000-0xfd0fffff]
[    0.370441] pci 0000:04:00.0:   bridge window [io  0xd000-0xdfff]
(subtractive decode)
[    0.370445] pci 0000:04:00.0:   bridge window [mem
0xfa000000-0xfd0fffff] (subtractive decode)
[    0.370450] pci 0000:04:00.0:   bridge window [??? 0x00000000 flags
0x0] (subtractive decode)
[    0.370454] pci 0000:04:00.0:   bridge window [??? 0x00000000 flags
0x0] (subtractive decode)
[    0.370590] pci 0000:06:00.0: [1b21:1042] type 00 class 0x0c0330
[    0.370625] pci 0000:06:00.0: reg 10: [mem 0xfdc00000-0xfdc07fff 64bit]
[    0.370784] pci 0000:06:00.0: PME# supported from D3hot D3cold
[    0.376680] pci 0000:00:15.3: PCI bridge to [bus 06]
[    0.376709] pci 0000:00:15.3:   bridge window [mem 0xfdc00000-0xfdcfffff]
[    0.376766] acpi PNP0A08:00: ACPI _OSC support notification failed,
disabling PCIe ASPM
[    0.376770] acpi PNP0A08:00: Unable to request _OSC control (_OSC
support mask: 0x08)
[    0.424920] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 7 10 11 14 15) *0
[    0.425067] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 10 11 14 15) *0
[    0.425206] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 10 11 14 15) *0
[    0.425342] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 10 11 14 15) *0
[    0.425456] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 14 15) *0
[    0.425550] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 11 14 15) *0
[    0.425643] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 7 10 11 14 15) *0
[    0.425735] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 10 11 14 15) *0
[    0.426050] acpi root: \_SB_.PCI0 notify handler is installed
[    0.426117] Found 1 acpi root devices
[    0.426428] vgaarb: device added:
PCI:0000:00:01.0,decodes=io+mem,owns=io+mem,locks=none
[    0.426448] vgaarb: loaded
[    0.426451] vgaarb: bridge control possible 0000:00:01.0
[    0.426701] SCSI subsystem initialized
[    0.426707] ACPI: bus type ATA registered
[    0.426840] libata version 3.00 loaded.
[    0.426904] PCI: Using ACPI for IRQ routing
[    0.437608] PCI: pci_cache_line_size set to 64 bytes
[    0.437747] e820: reserve RAM buffer [mem 0x0009ec00-0x0009ffff]
[    0.437754] e820: reserve RAM buffer [mem 0xa7b2e000-0xa7ffffff]
[    0.437758] e820: reserve RAM buffer [mem 0xa7cdc000-0xa7ffffff]
[    0.437761] e820: reserve RAM buffer [mem 0xa7f00000-0xa7ffffff]
[    0.437764] e820: reserve RAM buffer [mem 0x13f000000-0x13fffffff]
[    0.437972] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.437981] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    0.440009] Switching to clocksource hpet
[    0.443519] pnp: PnP ACPI init
[    0.443554] ACPI: bus type PNP registered
[    0.443826] system 00:00: [mem 0xe0000000-0xefffffff] has been reserved
[    0.443836] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.444463] system 00:01: [io  0x040b] has been reserved
[    0.444468] system 00:01: [io  0x04d6] has been reserved
[    0.444473] system 00:01: [io  0x0c00-0x0c01] has been reserved
[    0.444477] system 00:01: [io  0x0c14] has been reserved
[    0.444482] system 00:01: [io  0x0c50-0x0c51] has been reserved
[    0.444486] system 00:01: [io  0x0c52] has been reserved
[    0.444490] system 00:01: [io  0x0c6c] has been reserved
[    0.444494] system 00:01: [io  0x0c6f] has been reserved
[    0.444499] system 00:01: [io  0x0cd0-0x0cd1] has been reserved
[    0.444503] system 00:01: [io  0x0cd2-0x0cd3] has been reserved
[    0.444507] system 00:01: [io  0x0cd4-0x0cd5] has been reserved
[    0.444512] system 00:01: [io  0x0cd6-0x0cd7] has been reserved
[    0.444516] system 00:01: [io  0x0cd8-0x0cdf] has been reserved
[    0.444520] system 00:01: [io  0x0800-0x089f] has been reserved
[    0.444525] system 00:01: [io  0x0b20-0x0b3f] has been reserved
[    0.444529] system 00:01: [io  0x0900-0x090f] has been reserved
[    0.444534] system 00:01: [io  0x0910-0x091f] has been reserved
[    0.444538] system 00:01: [io  0xfe00-0xfefe] has been reserved
[    0.444545] system 00:01: [mem 0xfec00000-0xfec00fff] could not be
reserved
[    0.444550] system 00:01: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.444555] system 00:01: [mem 0xfed80000-0xfed8ffff] has been reserved
[    0.444560] system 00:01: [mem 0xfed61000-0xfed70fff] has been reserved
[    0.444565] system 00:01: [mem 0xfec10000-0xfec10fff] has been reserved
[    0.444570] system 00:01: [mem 0xfed00000-0xfed00fff] has been reserved
[    0.444575] system 00:01: [mem 0xffc00000-0xffffffff] has been reserved
[    0.444581] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.444834] system 00:02: [io  0x0290-0x029f] has been reserved
[    0.444840] system 00:02: [io  0x0a20-0x0a2f] has been reserved
[    0.444845] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.445347] pnp 00:03: [dma 0 disabled]
[    0.445541] pnp 00:03: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.445566] pnp 00:04: [dma 4]
[    0.445606] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.445665] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.445712] pnp 00:06: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.445839] system 00:07: [io  0x04d0-0x04d1] has been reserved
[    0.445846] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.445901] pnp 00:08: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.445982] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.446405] pnp 00:0a: [dma 0 disabled]
[    0.446502] pnp 00:0a: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.568644] system 00:0b: [mem 0xa8000000-0xbfffffff] has been reserved
[    0.568657] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.568968] pnp 00:0c: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.568981] pnp: PnP ACPI: found 13 devices
[    0.568984] ACPI: bus type PNP unregistered
[    0.582600] pci 0000:00:14.4: PCI bridge to [bus 01]
[    0.582624] pci 0000:00:15.0: PCI bridge to [bus 02]
[    0.582633] pci 0000:00:15.0:   bridge window [mem 0xfd400000-0xfdbfffff]
[    0.582646] pci 0000:00:15.1: PCI bridge to [bus 03]
[    0.582651] pci 0000:00:15.1:   bridge window [io  0xe000-0xefff]
[    0.582662] pci 0000:00:15.1:   bridge window [mem
0xd0000000-0xd00fffff 64bit pref]
[    0.582672] pci 0000:04:00.0: PCI bridge to [bus 05]
[    0.582678] pci 0000:04:00.0:   bridge window [io  0xd000-0xdfff]
[    0.582688] pci 0000:04:00.0:   bridge window [mem 0xfa000000-0xfd0fffff]
[    0.582705] pci 0000:00:15.2: PCI bridge to [bus 04-05]
[    0.582709] pci 0000:00:15.2:   bridge window [io  0xd000-0xdfff]
[    0.582717] pci 0000:00:15.2:   bridge window [mem 0xfa000000-0xfd0fffff]
[    0.582728] pci 0000:00:15.3: PCI bridge to [bus 06]
[    0.582736] pci 0000:00:15.3:   bridge window [mem 0xfdc00000-0xfdcfffff]
[    0.583156] pci 0000:04:00.0: setting latency timer to 64
[    0.583254] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.583259] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.583263] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.583267] pci_bus 0000:00: resource 7 [mem 0xc0000000-0xffffffff]
[    0.583272] pci_bus 0000:01: resource 4 [io  0x0000-0x0cf7]
[    0.583276] pci_bus 0000:01: resource 5 [io  0x0d00-0xffff]
[    0.583280] pci_bus 0000:01: resource 6 [mem 0x000a0000-0x000bffff]
[    0.583283] pci_bus 0000:01: resource 7 [mem 0xc0000000-0xffffffff]
[    0.583287] pci_bus 0000:02: resource 1 [mem 0xfd400000-0xfdbfffff]
[    0.583291] pci_bus 0000:03: resource 0 [io  0xe000-0xefff]
[    0.583296] pci_bus 0000:03: resource 2 [mem 0xd0000000-0xd00fffff
64bit pref]
[    0.583300] pci_bus 0000:04: resource 0 [io  0xd000-0xdfff]
[    0.583304] pci_bus 0000:04: resource 1 [mem 0xfa000000-0xfd0fffff]
[    0.583308] pci_bus 0000:05: resource 0 [io  0xd000-0xdfff]
[    0.583311] pci_bus 0000:05: resource 1 [mem 0xfa000000-0xfd0fffff]
[    0.583315] pci_bus 0000:05: resource 4 [io  0xd000-0xdfff]
[    0.583319] pci_bus 0000:05: resource 5 [mem 0xfa000000-0xfd0fffff]
[    0.583323] pci_bus 0000:06: resource 1 [mem 0xfdc00000-0xfdcfffff]
[    0.583458] NET: Registered protocol family 2
[    0.583921] TCP established hash table entries: 32768 (order: 7,
524288 bytes)
[    0.584285] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
[    0.584568] TCP: Hash tables configured (established 32768 bind 32768)
[    0.584676] TCP: reno registered
[    0.584704] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.584758] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.585069] NET: Registered protocol family 1
[    0.585103] pci 0000:00:01.0: Boot video device
[    1.644872] PCI: CLS 64 bytes, default 64
[    1.644972] Unpacking initramfs...
[    1.770678] Freeing initrd memory: 3752k freed
[    1.772864] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.772876] software IO TLB [mem 0xa3b2e000-0xa7b2e000] (64MB) mapped
at [ffff8800a3b2e000-ffff8800a7b2dfff]
[    1.773148] LVT offset 0 assigned for vector 0x400
[    1.773204] perf: AMD IBS detected (0x000000ff)
[    1.773264] Scanning for low memory corruption every 60 seconds
[    1.775061] PCLMULQDQ-NI instructions are not detected.
[    1.775072] sha256_ssse3: Using SSSE3 optimized SHA-256 implementation
[    1.775292] sha512_ssse3: Using SSSE3 optimized SHA-512 implementation
[    1.775489] AVX or AES-NI instructions are not detected.
[    1.775500] AVX instructions are not detected.
[    1.775503] AVX2 or AES-NI instructions are not detected.
[    1.775505] AVX2 instructions are not detected.
[    1.775867] audit: initializing netlink socket (disabled)
[    1.775889] type=2000 audit(1391493588.664:1): initialized
[    1.802269] bounce pool size: 64 pages
[    1.802299] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.803367] VFS: Disk quotas dquot_6.5.2
[    1.803429] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.803725] msgmni has been set to 7129
[    1.805436] alg: No test for stdrng (krng)
[    1.805463] Key type asymmetric registered
[    1.805474] Asymmetric key parser 'x509' registered
[    1.805531] Block layer SCSI generic (bsg) driver version 0.4 loaded
(major 253)
[    1.805535] io scheduler noop registered
[    1.805538] io scheduler deadline registered
[    1.805560] io scheduler cfq registered (default)
[    1.806198] input: Power Button as
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    1.806208] ACPI: Power Button [PWRB]
[    1.806285] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.806289] ACPI: Power Button [PWRF]
[    1.806374] ACPI: acpi_idle registered with cpuidle
[    1.913496] GHES: HEST is not enabled!
[    1.913610] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.934155] 00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.934838] ahci 0000:00:11.0: version 3.0
[    1.935088] ahci 0000:00:11.0: AHCI 0001.0200 32 slots 4 ports 6 Gbps
0xf impl SATA mode
[    1.935096] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo
pmp pio slum part
[    1.936295] scsi0 : ahci
[    1.936679] scsi1 : ahci
[    1.937009] scsi2 : ahci
[    1.937329] scsi3 : ahci
[    1.937498] ata1: SATA max UDMA/133 abar m1024@0xfd14f000 port
0xfd14f100 irq 19
[    1.937504] ata2: SATA max UDMA/133 abar m1024@0xfd14f000 port
0xfd14f180 irq 19
[    1.937508] ata3: SATA max UDMA/133 abar m1024@0xfd14f000 port
0xfd14f200 irq 19
[    1.937513] ata4: SATA max UDMA/133 abar m1024@0xfd14f000 port
0xfd14f280 irq 19
[    1.937673] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    1.940273] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.940296] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.940554] mousedev: PS/2 mouse device common for all mice
[    1.940637] rtc_cmos 00:05: RTC can wake from S4
[    1.940795] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    1.940827] rtc_cmos 00:05: alarms up to one month, y3k, 114 bytes
nvram, hpet irqs
[    1.940913] device-mapper: uevent: version 1.0.3
[    1.940994] device-mapper: ioctl: 4.24.0-ioctl (2013-01-15)
initialised: dm-devel@redhat.com
[    1.941298] device-mapper: cache-policy-mq: version 1.0.0 loaded
[    1.941308] device-mapper: cache cleaner: version 1.0.0 loaded
[    1.941377] cpuidle: using governor ladder
[    1.941474] cpuidle: using governor menu
[    1.941559] drop_monitor: Initializing network drop monitor service
[    1.941678] TCP: cubic registered
[    1.941774] NET: Registered protocol family 10
[    1.942161] mip6: Mobile IPv6
[    1.942166] NET: Registered protocol family 17
[    1.942187] Key type dns_resolver registered
[    1.942561] PM: Hibernation image not present or could not be loaded.
[    1.942579] registered taskstats version 1
[    1.944118] rtc_cmos 00:05: setting system clock to 2014-02-04
05:59:49 UTC (1391493589)
[    1.944220] acpi-cpufreq: overriding BIOS provided _PSD data
[    2.256338] ata4: SATA link down (SStatus 0 SControl 300)
[    2.256457] ata3: SATA link down (SStatus 0 SControl 300)
[    2.428333] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    2.428388] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.430118] ata2.00: ATA-7: Hitachi HDT725032VLA360, V54OA7EA, max
UDMA/133
[    2.430134] ata2.00: 625142448 sectors, multi 16: LBA48 NCQ (depth
31/32), AA
[    2.431852] ata2.00: configured for UDMA/133
[    2.435308] ata1.00: ATA-8: WDC WD20EARX-00PASB0, 51.0AB51, max UDMA/133
[    2.435324] ata1.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth
31/32), AA
[    2.442270] ata1.00: configured for UDMA/133
[    2.442707] scsi 0:0:0:0: Direct-Access     ATA      WDC WD20EARX-00P
51.0 PQ: 0 ANSI: 5
[    2.443630] scsi 1:0:0:0: Direct-Access     ATA      Hitachi HDT72503
V54O PQ: 0 ANSI: 5
[    2.446902] Freeing unused kernel memory: 912k freed
[    2.447571] Write protecting the kernel read-only data: 8192k
[    2.456810] Freeing unused kernel memory: 1056k freed
[    2.460769] Freeing unused kernel memory: 356k freed
[    2.504447] systemd-udevd[80]: starting version 204
[    2.547552] ACPI: bus type USB registered
[    2.547608] usbcore: registered new interface driver usbfs
[    2.547633] usbcore: registered new interface driver hub
[    2.548866] usbcore: registered new device driver usb
[    2.549513] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.549776] ehci-pci: EHCI PCI platform driver
[    2.550006] ehci-pci 0000:00:12.2: EHCI Host Controller
[    2.550019] ehci-pci 0000:00:12.2: new USB bus registered, assigned
bus number 1
[    2.550036] QUIRK: Enable AMD PLL fix
[    2.550041] ehci-pci 0000:00:12.2: applying AMD
SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    2.550057] ehci-pci 0000:00:12.2: debug port 1
[    2.550132] ehci-pci 0000:00:12.2: irq 17, io mem 0xfd14d000
[    2.550736] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.560147] ehci-pci 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    2.560202] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.560207] usb usb1: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    2.560212] usb usb1: Product: EHCI Host Controller
[    2.560215] usb usb1: Manufacturer: Linux 3.10.28-agathe ehci_hcd
[    2.560219] usb usb1: SerialNumber: 0000:00:12.2
[    2.560479] hub 1-0:1.0: USB hub found
[    2.560494] hub 1-0:1.0: 5 ports detected
[    2.560908] ehci-pci 0000:00:13.2: EHCI Host Controller
[    2.560920] ehci-pci 0000:00:13.2: new USB bus registered, assigned
bus number 2
[    2.560930] ehci-pci 0000:00:13.2: applying AMD
SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    2.560949] ehci-pci 0000:00:13.2: debug port 1
[    2.560998] ehci-pci 0000:00:13.2: irq 17, io mem 0xfd14b000
[    2.572180] ehci-pci 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    2.572237] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    2.572242] usb usb2: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    2.572246] usb usb2: Product: EHCI Host Controller
[    2.572250] usb usb2: Manufacturer: Linux 3.10.28-agathe ehci_hcd
[    2.572254] usb usb2: SerialNumber: 0000:00:13.2
[    2.572496] hub 2-0:1.0: USB hub found
[    2.572509] hub 2-0:1.0: 5 ports detected
[    2.572919] ehci-pci 0000:00:16.2: EHCI Host Controller
[    2.572934] ehci-pci 0000:00:16.2: new USB bus registered, assigned
bus number 3
[    2.572943] ehci-pci 0000:00:16.2: applying AMD
SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    2.572960] ehci-pci 0000:00:16.2: debug port 1
[    2.573011] ehci-pci 0000:00:16.2: irq 17, io mem 0xfd148000
[    2.584133] ehci-pci 0000:00:16.2: USB 2.0 started, EHCI 1.00
[    2.584194] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    2.584199] usb usb3: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    2.584203] usb usb3: Product: EHCI Host Controller
[    2.584207] usb usb3: Manufacturer: Linux 3.10.28-agathe ehci_hcd
[    2.584211] usb usb3: SerialNumber: 0000:00:16.2
[    2.584468] hub 3-0:1.0: USB hub found
[    2.584478] hub 3-0:1.0: 4 ports detected
[    2.585180] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    2.585198] ohci_hcd 0000:00:12.0: new USB bus registered, assigned
bus number 4
[    2.585253] ohci_hcd 0000:00:12.0: irq 18, io mem 0xfd14e000
[    2.609781] sd 0:0:0:0: [sda] 3907029168 512-byte logical blocks:
(2.00 TB/1.81 TiB)
[    2.609791] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    2.609895] sd 0:0:0:0: [sda] Write Protect is off
[    2.609901] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.609947] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    2.615959] sd 1:0:0:0: [sdb] 625142448 512-byte logical blocks: (320
GB/298 GiB)
[    2.616118] sd 1:0:0:0: [sdb] Write Protect is off
[    2.616124] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.616170] sd 1:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    2.623474] xhci_hcd 0000:06:00.0: xHCI Host Controller
[    2.623494] xhci_hcd 0000:06:00.0: new USB bus registered, assigned
bus number 5
[    2.633235]  sda: sda1 sda2 sda3
[    2.633818] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.638818]  sdb: sdb1 sdb2 sdb3 sdb4
[    2.639553] sd 1:0:0:0: [sdb] Attached SCSI disk
[    2.640021] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    2.640383] r8169 0000:03:00.0: irq 40 for MSI/MSI-X
[    2.640677] r8169 0000:03:00.0 eth0: RTL8168e/8111e at
0xffffc9000061c000, f4:6d:04:70:a4:cf, XID 0c200000 IRQ 40
[    2.640682] r8169 0000:03:00.0 eth0: jumbo features [frames: 9200
bytes, tx checksumming: ko]
[    2.642153] xhci_hcd 0000:06:00.0: irq 41 for MSI/MSI-X
[    2.642168] xhci_hcd 0000:06:00.0: irq 42 for MSI/MSI-X
[    2.642179] xhci_hcd 0000:06:00.0: irq 43 for MSI/MSI-X
[    2.642329] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
[    2.642334] usb usb5: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    2.642338] usb usb5: Product: xHCI Host Controller
[    2.642342] usb usb5: Manufacturer: Linux 3.10.28-agathe xhci_hcd
[    2.642345] usb usb5: SerialNumber: 0000:06:00.0
[    2.643010] xHCI xhci_add_endpoint called for root hub
[    2.643016] xHCI xhci_check_bandwidth called for root hub
[    2.643080] hub 5-0:1.0: USB hub found
[    2.643094] hub 5-0:1.0: 2 ports detected
[    2.643259] xhci_hcd 0000:06:00.0: xHCI Host Controller
[    2.643269] xhci_hcd 0000:06:00.0: new USB bus registered, assigned
bus number 6
[    2.643323] usb usb6: New USB device found, idVendor=1d6b, idProduct=0003
[    2.643328] usb usb6: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    2.643331] usb usb6: Product: xHCI Host Controller
[    2.643335] usb usb6: Manufacturer: Linux 3.10.28-agathe xhci_hcd
[    2.643338] usb usb6: SerialNumber: 0000:06:00.0
[    2.643464] xHCI xhci_add_endpoint called for root hub
[    2.643467] xHCI xhci_check_bandwidth called for root hub
[    2.643511] hub 6-0:1.0: USB hub found
[    2.643524] hub 6-0:1.0: 2 ports detected
[    2.644319] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    2.644328] usb usb4: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    2.644332] usb usb4: Product: OHCI Host Controller
[    2.644336] usb usb4: Manufacturer: Linux 3.10.28-agathe ohci_hcd
[    2.644340] usb usb4: SerialNumber: 0000:00:12.0
[    2.644590] hub 4-0:1.0: USB hub found
[    2.644603] hub 4-0:1.0: 5 ports detected
[    2.645013] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    2.645025] ohci_hcd 0000:00:13.0: new USB bus registered, assigned
bus number 7
[    2.645060] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfd14c000
[    2.646238] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.646304] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    2.682274] microcode: CPU0: patch_level=0x05000028
[    2.688608] microcode: CPU0: new patch_level=0x05000029
[    2.689611] microcode: CPU1: patch_level=0x05000028
[    2.695887] microcode: CPU1: new patch_level=0x05000029
[    2.696099] microcode: Microcode Update Driver: v2.00
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    2.704430] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    2.704440] usb usb7: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    2.704444] usb usb7: Product: OHCI Host Controller
[    2.704448] usb usb7: Manufacturer: Linux 3.10.28-agathe ohci_hcd
[    2.704452] usb usb7: SerialNumber: 0000:00:13.0
[    2.704659] hub 7-0:1.0: USB hub found
[    2.704671] hub 7-0:1.0: 5 ports detected
[    2.705072] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    2.705086] ohci_hcd 0000:00:14.5: new USB bus registered, assigned
bus number 8
[    2.705126] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfd14a000
[    2.732210] firewire_ohci 0000:05:02.0: added OHCI v1.10 device as
card 0, 4 IR + 8 IT contexts, quirks 0x11
[    2.764369] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    2.764385] usb usb8: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    2.764394] usb usb8: Product: OHCI Host Controller
[    2.764402] usb usb8: Manufacturer: Linux 3.10.28-agathe ohci_hcd
[    2.764409] usb usb8: SerialNumber: 0000:00:14.5
[    2.764830] hub 8-0:1.0: USB hub found
[    2.764850] hub 8-0:1.0: 2 ports detected
[    2.765423] ohci_hcd 0000:00:16.0: OHCI Host Controller
[    2.765444] ohci_hcd 0000:00:16.0: new USB bus registered, assigned
bus number 9
[    2.765493] ohci_hcd 0000:00:16.0: irq 18, io mem 0xfd149000
[    2.772252] tsc: Refined TSC clocksource calibration: 1599.989 MHz
[    2.772270] Switching to clocksource tsc
[    2.824478] usb usb9: New USB device found, idVendor=1d6b, idProduct=0001
[    2.824494] usb usb9: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    2.824503] usb usb9: Product: OHCI Host Controller
[    2.824510] usb usb9: Manufacturer: Linux 3.10.28-agathe ohci_hcd
[    2.824518] usb usb9: SerialNumber: 0000:00:16.0
[    2.824917] hub 9-0:1.0: USB hub found
[    2.824937] hub 9-0:1.0: 4 ports detected
[    3.232506] firewire_core 0000:05:02.0: created device fw0: GUID
001e8c00004f9c55, S400
[    3.294050] EXT4-fs (sda1): INFO: recovery required on readonly
filesystem
[    3.294065] EXT4-fs (sda1): write access will be enabled during recovery
[    4.072674] EXT4-fs (sda1): orphan cleanup on readonly fs
[    4.072704] EXT4-fs (sda1): ext4_orphan_cleanup: deleting
unreferenced inode 130794
[    4.072786] EXT4-fs (sda1): ext4_orphan_cleanup: deleting
unreferenced inode 137946
[    4.072821] EXT4-fs (sda1): ext4_orphan_cleanup: deleting
unreferenced inode 136826
[    4.072851] EXT4-fs (sda1): ext4_orphan_cleanup: deleting
unreferenced inode 135203
[    4.072879] EXT4-fs (sda1): ext4_orphan_cleanup: deleting
unreferenced inode 132176
[    4.072908] EXT4-fs (sda1): ext4_orphan_cleanup: deleting
unreferenced inode 130923
[    4.072941] EXT4-fs (sda1): ext4_orphan_cleanup: deleting
unreferenced inode 130748
[    4.072966] EXT4-fs (sda1): 7 orphan inodes deleted
[    4.072972] EXT4-fs (sda1): recovery complete
[    4.156270] EXT4-fs (sda1): mounted filesystem with ordered data
mode. Opts: (null)
[    5.649896] systemd-udevd[361]: starting version 204
[    6.201833] wmi: Mapper loaded
[    6.242953] parport_pc 00:03: reported by Plug and Play ACPI
[    6.243017] parport0: PC-style at 0x378, irq 5 [PCSPP]
[    6.247912] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00,
revision 0
[    6.254847] sp5100_tco: SP5100/SB800 TCO WatchDog Timer Driver v0.05
[    6.254943] sp5100_tco: PCI Revision ID: 0x42
[    6.255000] sp5100_tco: Using 0xfed80b00 for watchdog MMIO address
[    6.255014] sp5100_tco: Last reboot was not triggered by watchdog.
[    6.255683] sp5100_tco: initialized (0xffffc9000063eb00).
heartbeat=60 sec (nowayout=0)
[    6.286841] [drm] Initialized drm 1.1.0 20060810
[    6.315608] snd_hda_intel 0000:00:01.1: irq 44 for MSI/MSI-X
[    6.366241] input: HD-Audio Generic HDMI/DP,pcm=3 as
/devices/pci0000:00/0000:00:01.1/sound/card0/input2
[    6.370337] Linux video capture interface: v2.00
[    6.402861] input: PC Speaker as /devices/platform/pcspkr/input/input3
[    6.431381] input: HDA ATI SB Front Headphone as
/devices/pci0000:00/0000:00:14.2/sound/card1/input4
[    6.431547] input: HDA ATI SB Line Out as
/devices/pci0000:00/0000:00:14.2/sound/card1/input5
[    6.431664] input: HDA ATI SB Line as
/devices/pci0000:00/0000:00:14.2/sound/card1/input6
[    6.431771] input: HDA ATI SB Rear Mic as
/devices/pci0000:00/0000:00:14.2/sound/card1/input7
[    6.431879] input: HDA ATI SB Front Mic as
/devices/pci0000:00/0000:00:14.2/sound/card1/input8
[    6.518986] [drm] radeon kernel modesetting enabled.
[    6.520561] [drm] initializing kernel modesetting (PALM 0x1002:0x9802
0x1043:0x84A5).
[    6.520659] [drm] register mmio base: 0xFD100000
[    6.520664] [drm] register mmio size: 262144
[    6.520835] ATOM BIOS: AMD
[    6.520940] radeon 0000:00:01.0: VRAM: 384M 0x0000000000000000 -
0x0000000017FFFFFF (384M used)
[    6.520951] radeon 0000:00:01.0: GTT: 512M 0x0000000018000000 -
0x0000000037FFFFFF
[    6.520967] mtrr: type mismatch for c0000000,10000000 old: write-back
new: write-combining
[    6.520973] [drm] Detected VRAM RAM=384M, BAR=256M
[    6.520978] [drm] RAM width 32bits DDR
[    6.521138] [TTM] Zone  kernel: Available graphics memory: 1826430 kiB
[    6.521144] [TTM] Initializing pool allocator
[    6.521159] [TTM] Initializing DMA pool allocator
[    6.521232] [drm] radeon: 384M of VRAM memory ready
[    6.521238] [drm] radeon: 512M of GTT memory ready.
[    6.794445] saa7164 driver loaded
[    6.796418] CORE saa7164[0]: subsystem: 0070:8940, board: Hauppauge
WinTV-HVR2200 [card=9,autodetected]
[    6.796433] saa7164[0]/0: found at 0000:02:00.0, rev: 129, irq: 16,
latency: 0, mmio: 0xfd800000
[    6.806757] kvm: Nested Virtualization enabled
[    6.806775] kvm: Nested Paging enabled
[    6.897761] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    6.905967] [drm] Loading PALM Microcode
[    6.956308] saa7164_downloadfirmware() no first image
[    6.956392] saa7164_downloadfirmware() Waiting for firmware upload
(NXP7164-2010-03-10.1.fw)
[    6.985899] [drm] PCIE GART of 512M enabled (table at
0x0000000000273000).
[    6.986219] radeon 0000:00:01.0: WB enabled
[    6.986234] radeon 0000:00:01.0: fence driver on ring 0 use gpu addr
0x0000000018000c00 and cpu addr 0xffff880139c3ec00
[    6.986244] radeon 0000:00:01.0: fence driver on ring 3 use gpu addr
0x0000000018000c0c and cpu addr 0xffff880139c3ec0c
[    6.987276] radeon 0000:00:01.0: fence driver on ring 5 use gpu addr
0x0000000000072118 and cpu addr 0xffffc90011632118
[    6.987288] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    6.987293] [drm] Driver supports precise vblank timestamp query.
[    6.987349] radeon 0000:00:01.0: irq 45 for MSI/MSI-X
[    6.987384] radeon 0000:00:01.0: radeon: using MSI.
[    6.987445] [drm] radeon: irq initialized.
[    7.005296] [drm] ring test on 0 succeeded in 1 usecs
[    7.005367] [drm] ring test on 3 succeeded in 1 usecs
[    7.061149] [drm] ring test on 5 succeeded in 1 usecs
[    7.061164] [drm] UVD initialized successfully.
[    7.082098] [drm] ib test on ring 0 succeeded in 0 usecs
[    7.082138] [drm] ib test on ring 3 succeeded in 0 usecs
[    7.102845] [drm] ib test on ring 5 succeeded
[    7.124220] [drm] Radeon Display Connectors
[    7.124226] [drm] Connector 0:
[    7.124229] [drm]   HDMI-A-1
[    7.124231] [drm]   HPD1
[    7.124235] [drm]   DDC: 0x6430 0x6430 0x6434 0x6434 0x6438 0x6438
0x643c 0x643c
[    7.124237] [drm]   Encoders:
[    7.124240] [drm]     DFP1: INTERNAL_UNIPHY
[    7.124243] [drm] Connector 1:
[    7.124245] [drm]   DVI-D-1
[    7.124247] [drm]   HPD2
[    7.124250] [drm]   DDC: 0x6440 0x6440 0x6444 0x6444 0x6448 0x6448
0x644c 0x644c
[    7.124252] [drm]   Encoders:
[    7.124254] [drm]     DFP2: INTERNAL_UNIPHY
[    7.124256] [drm] Connector 2:
[    7.124258] [drm]   VGA-1
[    7.124261] [drm]   DDC: 0x64d8 0x64d8 0x64dc 0x64dc 0x64e0 0x64e0
0x64e4 0x64e4
[    7.124263] [drm]   Encoders:
[    7.124265] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    7.124384] [drm] Internal thermal controller without fan control
[    7.124513] [drm] radeon: power management initialized
[    7.138415] radeon 0000:00:01.0: No connectors reported connected
with modes
[    7.138433] [drm] Cannot find any crtc or sizes - going 1024x768
[    7.140546] [drm] fb mappable at 0xC0375000
[    7.140552] [drm] vram apper at 0xC0000000
[    7.140557] [drm] size 3145728
[    7.140561] [drm] fb depth is 24
[    7.140565] [drm]    pitch is 4096
[    7.140826] fbcon: radeondrmfb (fb0) is primary device
[    7.151911] Console: switching to colour frame buffer device 128x48
[    7.156857] radeon 0000:00:01.0: fb0: radeondrmfb frame buffer device
[    7.156861] radeon 0000:00:01.0: registered panic notifier
[    7.156872] [drm] Initialized radeon 2.33.0 20080528 for 0000:00:01.0
on minor 0
[    7.168925] cx2388x alsa driver version 0.0.9 loaded
[    7.169186] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.9 loaded
[    7.171004] cx88[0]: subsystem: 0070:9600, board: Hauppauge
WinTV-HVR1300 DVB-T/Hybrid MPEG Encoder [card=56,autodetected],
frontend(s): 1
[    7.221400] saa7164_downloadfirmware() firmware read 4019072 bytes.
[    7.221412] saa7164_downloadfirmware() firmware loaded.
[    7.221417] Firmware file header part 1:
[    7.221422]  .FirmwareSize = 0x0
[    7.221426]  .BSLSize = 0x0
[    7.221430]  .Reserved = 0x3d538
[    7.221434]  .Version = 0x3
[    7.221440] saa7164_downloadfirmware() SecBootLoader.FileSize = 4019072
[    7.221450] saa7164_downloadfirmware() FirmwareSize = 0x1fd6
[    7.221455] saa7164_downloadfirmware() BSLSize = 0x0
[    7.221459] saa7164_downloadfirmware() Reserved = 0x0
[    7.221464] saa7164_downloadfirmware() Version = 0x1661c00
[    7.290634] cx88[0]: i2c init: enabling analog demod on
HVR1300/3000/4000 tuner
[    7.328194] cx88/0: cx2388x v4l2 driver version 0.0.9 loaded
[    7.456868] tda9887 9-0043: creating new instance
[    7.456882] tda9887 9-0043: tda988[5/6/7] found
[    7.457952] tuner 9-0043: Tuner 74 found with type(s) Radio TV.
[    7.462722] tuner 9-0061: Tuner -1 found with type(s) Radio TV.
[    7.514206] tveeprom 9-0050: Hauppauge model 96559, rev C5A0, serial#
750453
[    7.514217] tveeprom 9-0050: MAC address is 00:0d:fe:0b:73:75
[    7.514224] tveeprom 9-0050: tuner model is Philips FMD1216ME (idx
100, type 63)
[    7.514233] tveeprom 9-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L')
PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
[    7.514241] tveeprom 9-0050: audio processor is CX882 (idx 33)
[    7.514247] tveeprom 9-0050: decoder processor is CX882 (idx 25)
[    7.514252] tveeprom 9-0050: has radio
[    7.514258] cx88[0]: hauppauge eeprom: model=96559
[    7.541631] tuner-simple 9-0061: creating new instance
[    7.541648] tuner-simple 9-0061: type set to 63 (Philips FMD1216ME
MK3 Hybrid Tuner)
[    7.549908] cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
[    7.550393] cx88[0]/2: cx2388x 8802 Driver Manager
[    7.550528] cx88[0]/2: found at 0000:05:00.2, rev: 5, irq: 18,
latency: 32, mmio: 0xfa000000
[    7.550845] cx88[0]/0: found at 0000:05:00.0, rev: 5, irq: 18,
latency: 32, mmio: 0xfc000000
[    7.556402] wm8775 9-001b: chip found @ 0x36 (cx88[0])
[    7.574222] cx88[0]/0: registered device video0 [v4l2]
[    7.574277] cx88[0]/0: registered device vbi0
[    7.574324] cx88[0]/0: registered device radio0
[    7.676572] cx88/2: cx2388x dvb driver version 0.0.9 loaded
[    7.676586] cx88/2: registering cx8802 driver, type: dvb access: shared
[    7.676597] cx88[0]/2: subsystem: 0070:9600, board: Hauppauge
WinTV-HVR1300 DVB-T/Hybrid MPEG Encoder [card=56]
[    7.676605] cx88[0]/2: cx2388x based DVB/ATSC card
[    7.676610] cx8802_alloc_frontends() allocating 1 frontend(s)
[    7.712531] tuner-simple 9-0061: attaching existing instance
[    7.712546] tuner-simple 9-0061: type set to 63 (Philips FMD1216ME
MK3 Hybrid Tuner)
[    7.717793] DVB: registering new adapter (cx88[0])
[    7.717804] cx88-mpeg driver manager 0000:05:00.2: DVB: registering
adapter 0 frontend 0 (Conexant CX22702 DVB-T)...
[    7.764589] cx2388x blackbird driver version 0.0.9 loaded
[    7.764598] cx88/2: registering cx8802 driver, type: blackbird
access: shared
[    7.764604] cx88[0]/2: subsystem: 0070:9600, board: Hauppauge
WinTV-HVR1300 DVB-T/Hybrid MPEG Encoder [card=56]
[    7.764659] cx88[0]/2: cx23416 based mpeg encoder (blackbird
reference design)
[    7.764888] cx88[0]/2-bb: Firmware and/or mailbox pointer not
initialized or corrupted
[   11.064189] saa7164_downloadimage() Image downloaded, booting...
[   11.168178] saa7164_downloadimage() Image booted successfully.
[   11.168195] starting firmware download(2)
[   11.171209] cx88[0]/2-bb: Firmware upload successful.
[   11.178531] cx88[0]/2-bb: Firmware version is 0x02060039
[   11.203677] cx88[0]/2: registered device video1 [mpeg]
[   13.900247] saa7164_downloadimage() Image downloaded, booting...
[   15.564229] saa7164_downloadimage() Image booted successfully.
[   15.564245] firmware download complete.
[   15.613120] tveeprom 10-0000: Hauppauge model 89619, rev D3F2,
serial# 7259593
[   15.613135] tveeprom 10-0000: MAC address is 00:0d:fe:6e:c5:c9
[   15.613144] tveeprom 10-0000: tuner model is NXP 18271C2_716x (idx
152, type 4)
[   15.613153] tveeprom 10-0000: TV standards PAL(B/G) NTSC(M) PAL(I)
SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xfc)
[   15.613160] tveeprom 10-0000: audio processor is SAA7164 (idx 43)
[   15.613167] tveeprom 10-0000: decoder processor is SAA7164 (idx 40)
[   15.613172] tveeprom 10-0000: has radio
[   15.613177] saa7164[0]: Hauppauge eeprom: model=89619
[   15.682922] tda18271 11-0060: creating new instance
[   15.687861] TDA18271HD/C2 detected @ 11-0060
[   15.945835] DVB: registering new adapter (saa7164)
[   15.945863] saa7164 0000:02:00.0: DVB: registering adapter 5 frontend
0 (NXP TDA10048HN DVB-T)...
[   15.978111] tda18271 12-0060: creating new instance
[   15.982888] TDA18271HD/C2 detected @ 12-0060
[   16.237263] tda18271: performing RF tracking filter calibration
[   18.593977] tda18271: RF tracking filter calibration complete
[   18.598242] DVB: registering new adapter (saa7164)
[   18.598270] saa7164 0000:02:00.0: DVB: registering adapter 6 frontend
0 (NXP TDA10048HN DVB-T)...
[   18.600473] saa7164[0]: registered device video2 [mpeg]
[   18.832032] saa7164[0]: registered device video3 [mpeg]
[   19.045058] saa7164[0]: registered device vbi1 [vbi]
[   19.045547] saa7164[0]: registered device vbi2 [vbi]
[   20.099660] EXT4-fs (sda1): re-mounted. Opts: (null)
[   20.301282] EXT4-fs (sda1): re-mounted. Opts:
errors=remount-ro,errors=remount-ro
[   65.668628] fuse init (API version 7.22)
[   65.698755] loop: module loaded
[   65.872334] kjournald starting.  Commit interval 5 seconds
[   65.873528] EXT3-fs (sdb2): using internal journal
[   65.873547] EXT3-fs (sdb2): mounted filesystem with ordered data mode
[   65.986072] EXT4-fs (sda3): mounted filesystem with ordered data
mode. Opts: (null)
[   67.883711] r8169 0000:03:00.0 eth0: link down
[   67.883742] r8169 0000:03:00.0 eth0: link down
[   67.884002] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   68.350241] RPC: Registered named UNIX socket transport module.
[   68.350250] RPC: Registered udp transport module.
[   68.350253] RPC: Registered tcp transport module.
[   68.350256] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   68.356583] FS-Cache: Loaded
[   68.385802] FS-Cache: Netfs 'nfs' registered for caching
[   68.443954] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   69.792591] r8169 0000:03:00.0 eth0: link up
[   69.792608] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   98.696111] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state
recovery directory
[   98.701090] NFSD: starting 90-second grace period (net ffffffff8187b840)
[  108.112832] tda10048_firmware_upload: waiting for firmware upload
(dvb-fe-tda10048-1.0.fw)...
[  108.234351] tda10048_firmware_upload: firmware read 24878 bytes.
[  108.234364] tda10048_firmware_upload: firmware uploading
[  109.319059] ip_tables: (C) 2000-2006 Netfilter Core Team
[  109.648694] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[  109.749293] ip6_tables: (C) 2000-2006 Netfilter Core Team
[  111.205888] tda10048_firmware_upload: firmware uploaded
[  111.507956] tda18271: performing RF tracking filter calibration
[  113.885642] tda18271: RF tracking filter calibration complete
[  114.895501] tda10048_firmware_upload: waiting for firmware upload
(dvb-fe-tda10048-1.0.fw)...
[  114.895650] tda10048_firmware_upload: firmware read 24878 bytes.
[  114.895657] tda10048_firmware_upload: firmware uploading
[  117.878266] tda10048_firmware_upload: firmware uploaded
[  117.932627] tda18271: performing RF tracking filter calibration
[  120.306101] tda18271: RF tracking filter calibration complete
[  252.260633] IN=eth0 OUT=
MAC=f4:6d:04:70:a4:cf:24:65:11:8e:46:a2:08:00 SRC=212.227.17.170
DST=192.168.22.1 LEN=52 TOS=0x00 PREC=0x00 TTL=57 ID=59184 DF PROTO=TCP
SPT=993 DPT=44091 WINDOW=33 RES=0x00 ACK URGP=0
[  253.180255] IN=eth0 OUT=
MAC=f4:6d:04:70:a4:cf:24:65:11:8e:46:a2:08:00 SRC=212.227.17.170
DST=192.168.22.1 LEN=52 TOS=0x00 PREC=0x00 TTL=57 ID=17697 DF PROTO=TCP
SPT=993 DPT=44094 WINDOW=33 RES=0x00 ACK URGP=0
[  312.411961] IN=eth0 OUT=
MAC=f4:6d:04:70:a4:cf:24:65:11:8e:46:a2:08:00 SRC=212.227.17.170
DST=192.168.22.1 LEN=52 TOS=0x00 PREC=0x00 TTL=57 ID=59185 DF PROTO=TCP
SPT=993 DPT=44091 WINDOW=33 RES=0x00 ACK URGP=0
[  313.335593] IN=eth0 OUT=
MAC=f4:6d:04:70:a4:cf:24:65:11:8e:46:a2:08:00 SRC=212.227.17.170
DST=192.168.22.1 LEN=52 TOS=0x00 PREC=0x00 TTL=57 ID=17698 DF PROTO=TCP
SPT=993 DPT=44094 WINDOW=33 RES=0x00 ACK URGP=0
[  372.571405] IN=eth0 OUT=
MAC=f4:6d:04:70:a4:cf:24:65:11:8e:46:a2:08:00 SRC=212.227.17.170
DST=192.168.22.1 LEN=52 TOS=0x00 PREC=0x00 TTL=57 ID=59186 DF PROTO=TCP
SPT=993 DPT=44091 WINDOW=33 RES=0x00 ACK URGP=0
[  373.494979] IN=eth0 OUT=
MAC=f4:6d:04:70:a4:cf:24:65:11:8e:46:a2:08:00 SRC=212.227.17.170
DST=192.168.22.1 LEN=52 TOS=0x00 PREC=0x00 TTL=57 ID=17699 DF PROTO=TCP
SPT=993 DPT=44094 WINDOW=33 RES=0x00 ACK URGP=0
[  432.730859] IN=eth0 OUT=
MAC=f4:6d:04:70:a4:cf:24:65:11:8e:46:a2:08:00 SRC=212.227.17.170
DST=192.168.22.1 LEN=52 TOS=0x00 PREC=0x00 TTL=57 ID=59187 DF PROTO=TCP
SPT=993 DPT=44091 WINDOW=33 RES=0x00 ACK RST URGP=0
[  433.654507] IN=eth0 OUT=
MAC=f4:6d:04:70:a4:cf:24:65:11:8e:46:a2:08:00 SRC=212.227.17.170
DST=192.168.22.1 LEN=52 TOS=0x00 PREC=0x00 TTL=57 ID=17700 DF PROTO=TCP
SPT=993 DPT=44094 WINDOW=33 RES=0x00 ACK RST URGP=0
[ 8696.054204] PM: Syncing filesystems ... done.
[ 8696.076986] PM: Preparing system for mem sleep
[ 8696.082380] Freezing user space processes ... (elapsed 0.01 seconds)
done.
[ 8696.095520] Freezing remaining freezable tasks ... (elapsed 0.01
seconds) done.
[ 8696.111741] PM: Entering mem sleep
[ 8696.111831] Suspending console(s) (use no_console_suspend to debug)
[ 8696.114014] tda9887 9-0043: i2c i/o error: rc == -6 (should be 4)
[ 8696.114832] sd 1:0:0:0: [sdb] Synchronizing SCSI cache
[ 8696.114961] sd 1:0:0:0: [sdb] Stopping disk
[ 8696.114978] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[ 8696.117643] serial 00:0a: disabled
[ 8696.117653] serial 00:0a: System wakeup disabled by ACPI
[ 8696.118023] parport_pc 00:03: disabled
[ 8696.159555] sd 0:0:0:0: [sda] Stopping disk
[ 8696.597765] PM: suspend of devices complete after 485.735 msecs
[ 8696.598025] PM: late suspend of devices complete after 0.255 msecs
[ 8696.598280] pcieport 0000:00:15.3: System wakeup enabled by ACPI
[ 8696.611881] r8169 0000:03:00.0: System wakeup enabled by ACPI
[ 8696.627876] ehci-pci 0000:00:16.2: System wakeup enabled by ACPI
[ 8696.643677] ohci_hcd 0000:00:16.0: System wakeup enabled by ACPI
[ 8696.643881] ohci_hcd 0000:00:14.5: System wakeup enabled by ACPI
[ 8696.644024] ehci-pci 0000:00:13.2: System wakeup enabled by ACPI
[ 8696.659677] ohci_hcd 0000:00:13.0: System wakeup enabled by ACPI
[ 8696.659723] ehci-pci 0000:00:12.2: System wakeup enabled by ACPI
[ 8696.675686] ohci_hcd 0000:00:12.0: System wakeup enabled by ACPI
[ 8696.675741] PM: noirq suspend of devices complete after 77.712 msecs
[ 8696.675774] ACPI: Preparing to enter system sleep state S3
[ 8696.675914] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[ 8697.188081] PM: Saving platform NVS memory
[ 8697.189270] Disabling non-boot CPUs ...
[ 8697.190113] Broke affinity for irq 18
[ 8697.190118] Broke affinity for irq 40
[ 8697.291443] smpboot: CPU 1 is now offline
[ 8697.292263] ACPI: Low-level resume complete
[ 8697.292317] PM: Restoring platform NVS memory
[ 8697.293049] LVT offset 0 assigned for vector 0x400
[ 8697.299395] microcode: CPU0: new patch_level=0x05000029
[ 8697.299471] Enabling non-boot CPUs ...
[ 8697.299649] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 8697.319368] microcode: CPU1: new patch_level=0x05000029
[ 8697.319377] CPU1 is up
[ 8697.319929] ACPI: Waking up from system sleep state S3
[ 8697.752721] ahci 0000:00:11.0: set SATA to AHCI mode
[ 8697.752770] ohci_hcd 0000:00:12.0: System wakeup disabled by ACPI
[ 8697.768692] ehci-pci 0000:00:12.2: System wakeup disabled by ACPI
[ 8697.768734] ohci_hcd 0000:00:13.0: System wakeup disabled by ACPI
[ 8697.784692] ehci-pci 0000:00:13.2: System wakeup disabled by ACPI
[ 8697.800768] ohci_hcd 0000:00:14.5: System wakeup disabled by ACPI
[ 8697.801011] ohci_hcd 0000:00:16.0: System wakeup disabled by ACPI
[ 8697.816693] ehci-pci 0000:00:16.2: System wakeup disabled by ACPI
[ 8697.880726] pcieport 0000:00:15.3: System wakeup disabled by ACPI
[ 8697.880860] PM: noirq resume of devices complete after 159.870 msecs
[ 8697.881043] PM: early resume of devices complete after 0.146 msecs
[ 8697.881462] snd_hda_intel 0000:00:01.1: irq 44 for MSI/MSI-X
[ 8697.882677] r8169 0000:03:00.0: System wakeup disabled by ACPI
[ 8697.885118] [drm] PCIE GART of 512M enabled (table at
0x0000000000273000).
[ 8697.885372] radeon 0000:00:01.0: WB enabled
[ 8697.885377] radeon 0000:00:01.0: fence driver on ring 0 use gpu addr
0x0000000018000c00 and cpu addr 0xffff880139c3ec00
[ 8697.885381] radeon 0000:00:01.0: fence driver on ring 3 use gpu addr
0x0000000018000c0c and cpu addr 0xffff880139c3ec0c
[ 8697.886156] radeon 0000:00:01.0: fence driver on ring 5 use gpu addr
0x0000000000072118 and cpu addr 0xffffc90011632118
[ 8697.902576] pci 0000:04:00.0: setting latency timer to 64
[ 8697.902762] usb usb5: root hub lost power or was reset
[ 8697.902765] usb usb6: root hub lost power or was reset
[ 8697.913348] parport_pc 00:03: activated
[ 8697.914679] serial 00:0a: activated
[ 8697.915043] xhci_hcd 0000:06:00.0: irq 41 for MSI/MSI-X
[ 8697.915052] xhci_hcd 0000:06:00.0: irq 42 for MSI/MSI-X
[ 8697.915061] xhci_hcd 0000:06:00.0: irq 43 for MSI/MSI-X
[ 8697.915329] [drm] ring test on 0 succeeded in 1 usecs
[ 8697.915389] [drm] ring test on 3 succeeded in 1 usecs
[ 8697.971358] [drm] ring test on 5 succeeded in 1 usecs
[ 8697.971361] [drm] UVD initialized successfully.
[ 8697.991516] [drm] ib test on ring 0 succeeded in 0 usecs
[ 8697.991552] [drm] ib test on ring 3 succeeded in 1 usecs
[ 8698.012238] [drm] ib test on ring 5 succeeded
[ 8698.043483] r8169 0000:03:00.0 eth0: link down
[ 8698.236657] ata3: SATA link down (SStatus 0 SControl 300)
[ 8698.236695] ata4: SATA link down (SStatus 0 SControl 300)
[ 8698.480667] firewire_core 0000:05:02.0: rediscovered device fw0
[ 8700.249659] r8169 0000:03:00.0 eth0: link up
[ 8704.680529] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 8704.695277] ata2.00: configured for UDMA/133
[ 8704.708610] sd 1:0:0:0: [sdb] Starting disk
[ 8708.020472] ata1: softreset failed (device not ready)
[ 8709.408473] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[ 8709.444074] ata1.00: configured for UDMA/133
[ 8709.459741] sd 0:0:0:0: [sda] Starting disk
[ 8709.478594] tda9887 9-0043: i2c i/o error: rc == -6 (should be 4)
[ 8709.479558] tda9887 9-0043: i2c i/o error: rc == -6 (should be 4)
[ 8709.480536] tuner-simple 9-0061: i2c i/o error: rc == -6 (should be 4)
[ 8709.480568] PM: resume of devices complete after 11599.700 msecs
[ 8709.482105] PM: Finishing wakeup.
[ 8709.482108] Restarting tasks ... done.
[ 8711.373436] cx22702_readreg: error (reg == 0x0a, ret == -6)
[ 8711.374559] cx22702_readreg: error (reg == 0x23, ret == -6)
[ 8711.376483] saa7164[0]: Dumping the bus structure:
[ 8711.376505] saa7164[0]:  .type             = 2
[ 8711.376518] saa7164[0]:  .dev->bmmio       = 0xffffc90010d00000
[ 8711.376528] saa7164[0]:  .m_wMaxReqSize    = 0x100
[ 8711.376534] saa7164[0]:  .m_pdwSetRing     = 0xffffc90010d01000
[ 8711.376547] saa7164[0]:  .m_dwSizeSetRing  = 0x1000
[ 8711.376552] saa7164[0]:  .m_pdwGetRing     = 0xffffc90010d02000
[ 8711.376565] saa7164[0]:  .m_dwSizeGetRing  = 0x1000
[ 8711.376573] saa7164[0]:  .m_dwSetReadPos   = 0xf4 (0xe99b020a)
[ 8711.376588] saa7164[0]:  .m_dwSetWritePos  = 0xf0 (0x29dee487)
[ 8711.376599] saa7164[0]:  .m_dwGetReadPos   = 0xfc (0x32cc8948)
[ 8711.376610] saa7164[0]:  .m_dwGetWritePos  = 0xf8 (0x4bb18d66)
[ 8711.376705] ------------[ cut here ]------------
[ 8711.376820] kernel BUG at drivers/media/pci/saa7164/saa7164-bus.c:105!
[ 8711.376951] invalid opcode: 0000 [#1] SMP
[ 8711.377951] saa7164[0]: Dumping the bus structure:
[ 8711.377955] saa7164[0]:  .type             = 2
[ 8711.377963] saa7164[0]:  .dev->bmmio       = 0xffffc90010d00000
[ 8711.377965] saa7164[0]:  .m_wMaxReqSize    = 0x100
[ 8711.377968] saa7164[0]:  .m_pdwSetRing     = 0xffffc90010d01000
[ 8711.377970] saa7164[0]:  .m_dwSizeSetRing  = 0x1000
[ 8711.377972] saa7164[0]:  .m_pdwGetRing     = 0xffffc90010d02000
[ 8711.377974] saa7164[0]:  .m_dwSizeGetRing  = 0x1000
[ 8711.377979] saa7164[0]:  .m_dwSetReadPos   = 0xf4 (0xe99b020a)
[ 8711.377984] saa7164[0]:  .m_dwSetWritePos  = 0xf0 (0x29dee487)
[ 8711.377988] saa7164[0]:  .m_dwGetReadPos   = 0xfc (0x32cc8948)
[ 8711.377993] saa7164[0]:  .m_dwGetWritePos  = 0xf8 (0x4bb18d66)
[ 8711.377053] Modules linked in: ip6table_raw ip6table_mangle xt_mac
ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables
xt_LOG ipt_REJECT xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
nf_conntrack xt_multiport iptable_filter ip_tables x_tables nfsd
auth_rpcgss nfs_acl nfs lockd fscache sunrpc ext3 jbd loop fuse tda18271
tda10048 cx88_blackbird cx2341x cx22702 cx88_dvb videobuf_dvb
cx88_vp3054_i2c wm8775 tuner_simple tuner_types tda9887 tda8290 cx8800
tuner cx8802 cx88_alsa cx88xx btcx_risc videobuf_dma_sg kvm_amd saa7164
dvb_core videobuf_core tveeprom rc_core radeon kvm snd_hda_codec_realtek
v4l2_common pcspkr psmouse videodev drm_kms_helper snd_hda_codec_hdmi
serio_raw k10temp ttm snd_hda_intel i2c_algo_bit snd_hda_codec drm
snd_hwdep snd_pcm snd_page_alloc snd_timer sp5100_tco i2c_piix4
parport_pc snd parport evdev wmi soundcore i2c_core microcode
firewire_ohci firewire_core crc_itu_t sg r8169 mii xhci_hcd sd_mod
crc_t10dif ohci_hcd ehci_pci ehci_hcd usbcore usb_common
[ 8711.380857] CPU: 0 PID: 4532 Comm: kdvb-ad-6-fe-0 Not tainted
3.10.28-agathe #8
[ 8711.381001] Hardware name: System manufacturer System Product
Name/E35M1-M PRO, BIOS 1602 08/06/2012
[ 8711.381178] task: ffff88011451e100 ti: ffff8800a05ae000 task.ti:
ffff8800a05ae000
[ 8711.381325] RIP: 0010:[<ffffffffa02d8dea>]  [<ffffffffa02d8dea>]
saa7164_bus_verify+0x7a/0x90 [saa7164]
[ 8711.381533] RSP: 0018:ffff8800a05af7e8  EFLAGS: 00010282
[ 8711.381641] RAX: 0000000000000032 RBX: ffff8801399e0000 RCX:
00000000000000d6
[ 8711.381781] RDX: 000000000000007c RSI: 0000000000000046 RDI:
ffffffff819dd330
[ 8711.381920] RBP: 0000000000000000 R08: 000000000000000a R09:
000000000000042e
[ 8711.382060] R10: 0000000000000000 R11: ffff8800a05af54e R12:
ffff8800a05af87a
[ 8711.382199] R13: ffff8800a05af87a R14: 0000000000000002 R15:
ffff8801399e0000
[ 8711.382340] FS:  00007f846d2b7700(0000) GS:ffff88013ec00000(0000)
knlGS:0000000000000000
[ 8711.382497] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 8711.382612] CR2: 00007f512bb87138 CR3: 00000000a35f0000 CR4:
00000000000007f0
[ 8711.382751] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[ 8711.382890] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[ 8711.383027] Stack:
[ 8711.383074]  ffffffffa02d8e36 ffff8800a05afa2e 00001f00db4cc57f
00000000db4cc57f
[ 8711.383252]  ffff8801399e0000 0000000000000000 ffff8800a05af87a
0000000000000085
[ 8711.383428]  0000000000000002 0000000000000000 ffffffffa02da190
00001f0000000000
[ 8711.388731] Call Trace:
[ 8711.393980]  [<ffffffffa02d8e36>] ? saa7164_bus_set+0x36/0x5a0 [saa7164]
[ 8711.399342]  [<ffffffffa02da190>] ? saa7164_cmd_send+0x220/0xcf0
[saa7164]
[ 8711.404638]  [<ffffffff81084d90>] ? wake_up_bit+0x40/0x40
[ 8711.409885]  [<ffffffffa02de79b>] ? saa7164_api_i2c_read+0xfb/0x300
[saa7164]
[ 8711.415162]  [<ffffffffa02d6f51>] ? i2c_xfer+0xe1/0x180 [saa7164]
[ 8711.420416]  [<ffffffffa00af1b1>] ? __i2c_transfer+0x51/0x70 [i2c_core]
[ 8711.425654]  [<ffffffffa00afb11>] ? i2c_transfer+0x81/0xc0 [i2c_core]
[ 8711.430759]  [<ffffffffa0434163>] ? tda10048_readreg+0x73/0xc0 [tda10048]
[ 8711.435752]  [<ffffffffa0434dc7>] ? tda10048_read_status+0x27/0x80
[tda10048]
[ 8711.440620]  [<ffffffffa02bb2d9>] ? dvb_frontend_swzigzag+0x119/0x380
[dvb_core]
[ 8711.445369]  [<ffffffff81096a94>] ? update_curr+0xa4/0x120
[ 8711.450099]  [<ffffffff81097080>] ? dequeue_task_fair+0x280/0x8e0
[ 8711.454853]  [<ffffffff81094f50>] ? __dequeue_entity+0x40/0x50
[ 8711.459608]  [<ffffffff81096066>] ? pick_next_task_fair+0x56/0x1c0
[ 8711.464377]  [<ffffffff8106f3b2>] ? lock_timer_base.isra.35+0x32/0x70
[ 8711.469172]  [<ffffffff810700b4>] ? try_to_del_timer_sync+0x44/0x60
[ 8711.473983]  [<ffffffff8107011a>] ? del_timer_sync+0x4a/0x60
[ 8711.478792]  [<ffffffff814e8ce6>] ? schedule_timeout+0x186/0x2c0
[ 8711.483628]  [<ffffffff8106f120>] ? ftrace_raw_output_tick_stop+0x60/0x60
[ 8711.488529]  [<ffffffffa02bbf05>] ? dvb_frontend_thread+0x475/0x590
[dvb_core]
[ 8711.493481]  [<ffffffff81084d90>] ? wake_up_bit+0x40/0x40
[ 8711.498465]  [<ffffffffa02bba90>] ?
dvb_frontend_should_wakeup.isra.2+0x70/0x70 [dvb_core]
[ 8711.503392]  [<ffffffff810840af>] ? kthread+0xaf/0xc0
[ 8711.508173]  [<ffffffff81084000>] ? kthread_create_on_node+0x110/0x110
[ 8711.512839]  [<ffffffff814f22ec>] ? ret_from_fork+0x7c/0xb0
[ 8711.517365]  [<ffffffff81084000>] ? kthread_create_on_node+0x110/0x110
[ 8711.521782] Code: 00 83 e0 fc 48 03 47 30 8b 00 39 87 10 01 00 00 73
1f c7 05 e9 59 01 00 ff ff 00 00 e8 80 fd ff ff c7 05 da 59 01 00 00 04
00 00 <0f> 0b 0f 1f 40 00 85 d2 75 dd f3 c3 66 2e 0f 1f 84 00 00 00 00
[ 8711.531286] RIP  [<ffffffffa02d8dea>] saa7164_bus_verify+0x7a/0x90
[saa7164]
[ 8711.535774]  RSP <ffff8800a05af7e8>
[ 8711.540170] ------------[ cut here ]------------
[ 8711.540248] ---[ end trace bfb6553ff6d381da ]---
[ 8711.548771] kernel BUG at drivers/media/pci/saa7164/saa7164-bus.c:105!
[ 8711.553022] invalid opcode: 0000 [#2] SMP
[ 8711.557273] Modules linked in: ip6table_raw ip6table_mangle xt_mac
ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables
xt_LOG ipt_REJECT xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
nf_conntrack xt_multiport iptable_filter ip_tables x_tables nfsd
auth_rpcgss nfs_acl nfs lockd fscache sunrpc ext3 jbd loop fuse tda18271
tda10048 cx88_blackbird cx2341x cx22702 cx88_dvb videobuf_dvb
cx88_vp3054_i2c wm8775 tuner_simple tuner_types tda9887 tda8290 cx8800
tuner cx8802 cx88_alsa cx88xx btcx_risc videobuf_dma_sg kvm_amd saa7164
dvb_core videobuf_core tveeprom rc_core radeon kvm snd_hda_codec_realtek
v4l2_common pcspkr psmouse videodev drm_kms_helper snd_hda_codec_hdmi
serio_raw k10temp ttm snd_hda_intel i2c_algo_bit snd_hda_codec drm
snd_hwdep snd_pcm snd_page_alloc snd_timer sp5100_tco i2c_piix4
parport_pc snd parport evdev wmi soundcore i2c_core microcode
firewire_ohci firewire_core crc_itu_t sg r8169 mii xhci_hcd sd_mod
crc_t10dif ohci_hcd ehci_pci ehci_hcd usbcore usb_common
[ 8711.597161] CPU: 1 PID: 4540 Comm: kdvb-ad-5-fe-0 Tainted: G      D
     3.10.28-agathe #8
[ 8711.602500] Hardware name: System manufacturer System Product
Name/E35M1-M PRO, BIOS 1602 08/06/2012
[ 8711.607891] task: ffff8800a37041c0 ti: ffff8800a343c000 task.ti:
ffff8800a343c000
[ 8711.613307] RIP: 0010:[<ffffffffa02d8dea>]  [<ffffffffa02d8dea>]
saa7164_bus_verify+0x7a/0x90 [saa7164]
[ 8711.618892] RSP: 0018:ffff8800a343d7e8  EFLAGS: 00010282
[ 8711.624385] RAX: 0000000000000032 RBX: ffff8801399e0000 RCX:
000000000000002f
[ 8711.629915] RDX: 0000000000000000 RSI: 0000000000000086 RDI:
ffffffff81831260
[ 8711.635455] RBP: 0000000000000000 R08: 0000000000015570 R09:
ffffffff819d288e
[ 8711.640954] R10: 0000000000000054 R11: 000000000000aa90 R12:
ffff8800a343d87a
[ 8711.646432] R13: ffff8800a343d87a R14: 0000000000000002 R15:
ffff8801399e0000
[ 8711.651886] FS:  00007fcbad971700(0000) GS:ffff88013ed00000(0000)
knlGS:0000000000000000
[ 8711.657402] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 8711.662921] CR2: 00007f512b57f000 CR3: 00000001148ba000 CR4:
00000000000007e0
[ 8711.668486] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[ 8711.674054] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[ 8711.679563] Stack:
[ 8711.684998]  ffffffffa02d8e36 ffff8800a343da2e 00001e000d883eff
000000000d883eff
[ 8711.690621]  ffff8801399e0000 0000000000000000 ffff8800a343d87a
0000000000000085
[ 8711.696275]  0000000000000002 0000000000000000 ffffffffa02da190
00001e0000000000
[ 8711.701925] Call Trace:
[ 8711.707527]  [<ffffffffa02d8e36>] ? saa7164_bus_set+0x36/0x5a0 [saa7164]
[ 8711.713238]  [<ffffffffa02da190>] ? saa7164_cmd_send+0x220/0xcf0
[saa7164]
[ 8711.718937]  [<ffffffff81084d90>] ? wake_up_bit+0x40/0x40
[ 8711.724632]  [<ffffffffa02de79b>] ? saa7164_api_i2c_read+0xfb/0x300
[saa7164]
[ 8711.730365]  [<ffffffffa02d6f51>] ? i2c_xfer+0xe1/0x180 [saa7164]
[ 8711.736086]  [<ffffffffa00af1b1>] ? __i2c_transfer+0x51/0x70 [i2c_core]
[ 8711.741794]  [<ffffffffa00afb11>] ? i2c_transfer+0x81/0xc0 [i2c_core]
[ 8711.747460]  [<ffffffffa0434163>] ? tda10048_readreg+0x73/0xc0 [tda10048]
[ 8711.753085]  [<ffffffffa0434dc7>] ? tda10048_read_status+0x27/0x80
[tda10048]
[ 8711.758733]  [<ffffffffa02bb2d9>] ? dvb_frontend_swzigzag+0x119/0x380
[dvb_core]
[ 8711.764385]  [<ffffffff81096a94>] ? update_curr+0xa4/0x120
[ 8711.770019]  [<ffffffff81097080>] ? dequeue_task_fair+0x280/0x8e0
[ 8711.775554]  [<ffffffff81094f50>] ? __dequeue_entity+0x40/0x50
[ 8711.780954]  [<ffffffff81096066>] ? pick_next_task_fair+0x56/0x1c0
[ 8711.786284]  [<ffffffff8106f3b2>] ? lock_timer_base.isra.35+0x32/0x70
[ 8711.791582]  [<ffffffff810700b4>] ? try_to_del_timer_sync+0x44/0x60
[ 8711.796881]  [<ffffffff8107011a>] ? del_timer_sync+0x4a/0x60
[ 8711.802174]  [<ffffffff814e8ce6>] ? schedule_timeout+0x186/0x2c0
[ 8711.807443]  [<ffffffff8106f120>] ? ftrace_raw_output_tick_stop+0x60/0x60
[ 8711.812719]  [<ffffffffa02bbf05>] ? dvb_frontend_thread+0x475/0x590
[dvb_core]
[ 8711.817894]  [<ffffffff81084d90>] ? wake_up_bit+0x40/0x40
[ 8711.822943]  [<ffffffffa02bba90>] ?
dvb_frontend_should_wakeup.isra.2+0x70/0x70 [dvb_core]
[ 8711.827937]  [<ffffffff810840af>] ? kthread+0xaf/0xc0
[ 8711.832779]  [<ffffffff81084000>] ? kthread_create_on_node+0x110/0x110
[ 8711.837509]  [<ffffffff814f22ec>] ? ret_from_fork+0x7c/0xb0
[ 8711.842095]  [<ffffffff81084000>] ? kthread_create_on_node+0x110/0x110
[ 8711.846574] Code: 00 83 e0 fc 48 03 47 30 8b 00 39 87 10 01 00 00 73
1f c7 05 e9 59 01 00 ff ff 00 00 e8 80 fd ff ff c7 05 da 59 01 00 00 04
00 00 <0f> 0b 0f 1f 40 00 85 d2 75 dd f3 c3 66 2e 0f 1f 84 00 00 00 00
[ 8711.856141] RIP  [<ffffffffa02d8dea>] saa7164_bus_verify+0x7a/0x90
[saa7164]
[ 8711.860614]  RSP <ffff8800a343d7e8>
[ 8711.865153] ---[ end trace bfb6553ff6d381db ]---
[ 8712.557412] cx22702_readreg: error (reg == 0x0a, ret == -6)
[ 8712.562756] cx22702_readreg: error (reg == 0x23, ret == -6)
[ 8713.613422] cx22702_readreg: error (reg == 0x0a, ret == -6)
[ 8713.618599] cx22702_readreg: error (reg == 0x23, ret == -6)

.config
#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.10.28 Kernel Configuration
#
CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_HAVE_INTEL_TXT=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi
-fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9
-fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION="-agathe"
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_FHANDLE=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y
# CONFIG_AUDIT_LOGINUID_IMMUTABLE is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
# CONFIG_NO_HZ_FULL is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
# CONFIG_RCU_USER_QS is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_RCU_FAST_NO_HZ=y
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=m
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
# CONFIG_NUMA_BALANCING is not set
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
# CONFIG_CGROUP_HUGETLB is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
# CONFIG_USER_NS is not set
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_UIDGID_CONVERTED=y
# CONFIG_UIDGID_STRICT_TYPE_CHECKS is not set
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HOTPLUG=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_ALL is not set
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_COMPAT_BRK is not set
CONFIG_SLAB=y
# CONFIG_SLUB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
# CONFIG_JUMP_LABEL is not set
CONFIG_OPTPROBES=y
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
# CONFIG_MODULE_SIG is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
# CONFIG_BLK_DEV_THROTTLING is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
# CONFIG_SOLARIS_X86_PARTITION is not set
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
CONFIG_SYSV68_PARTITION=y
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_CFQ_GROUP_IOSCHED=y
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_ASN1=y
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_INLINE_READ_UNLOCK=y
CONFIG_INLINE_READ_UNLOCK_IRQ=y
CONFIG_INLINE_WRITE_UNLOCK=y
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
# CONFIG_X86_X2APIC is not set
# CONFIG_X86_MPPARSE is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
# CONFIG_HYPERVISOR_GUEST is not set
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
CONFIG_MK8=y
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=8
# CONFIG_SCHED_SMT is not set
# CONFIG_SCHED_MC is not set
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
# CONFIG_I8K is not set
CONFIG_MICROCODE=m
# CONFIG_MICROCODE_INTEL is not set
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
# CONFIG_AMD_NUMA is not set
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
# CONFIG_MOVABLE_NODE is not set
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=65536
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_CLEANCACHE=y
CONFIG_FRONTSWAP=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
CONFIG_EFI=y
CONFIG_EFI_STUB=y
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
# CONFIG_KEXEC_JUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_COMPAT_VDSO is not set
CONFIG_CMDLINE_BOOL=y
CONFIG_CMDLINE=""
# CONFIG_CMDLINE_OVERRIDE is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
CONFIG_PM_WAKELOCKS_GC=y
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
# CONFIG_ACPI_PROC_EVENT is not set
# CONFIG_ACPI_AC is not set
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_FAN is not set
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_I2C=m
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
# CONFIG_ACPI_THERMAL is not set
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
CONFIG_ACPI_HED=y
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_BGRT is not set
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_PCIEAER=y
# CONFIG_ACPI_APEI_EINJ is not set
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_GOV_COMMON=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
# CONFIG_X86_PCC_CPUFREQ is not set
CONFIG_X86_ACPI_CPUFREQ=y
CONFIG_X86_ACPI_CPUFREQ_CPB=y
# CONFIG_X86_POWERNOW_K8 is not set
CONFIG_X86_AMD_FREQ_SENSITIVITY=y
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_COREDUMP=y
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=y
# CONFIG_X86_X32 is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_KEYS_COMPAT=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=y
CONFIG_XFRM=y
# CONFIG_XFRM_USER is not set
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
# CONFIG_XFRM_STATISTICS is not set
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
# CONFIG_NET_IP_TUNNEL is not set
CONFIG_IP_MROUTE=y
CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
# CONFIG_INET_LRO is not set
# CONFIG_INET_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
# CONFIG_TCP_CONG_BIC is not set
CONFIG_TCP_CONG_CUBIC=y
# CONFIG_TCP_CONG_WESTWOOD is not set
# CONFIG_TCP_CONG_HTCP is not set
# CONFIG_TCP_CONG_HSTCP is not set
# CONFIG_TCP_CONG_HYBLA is not set
# CONFIG_TCP_CONG_VEGAS is not set
# CONFIG_TCP_CONG_SCALABLE is not set
# CONFIG_TCP_CONG_LP is not set
# CONFIG_TCP_CONG_VENO is not set
# CONFIG_TCP_CONG_YEAH is not set
# CONFIG_TCP_CONG_ILLINOIS is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
CONFIG_IPV6_PRIVACY=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
CONFIG_IPV6_MIP6=y
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET6_XFRM_MODE_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_BEET is not set
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
# CONFIG_IPV6_SIT is not set
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_GRE is not set
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
# CONFIG_NETLABEL is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
# CONFIG_NETFILTER_NETLINK_ACCT is not set
# CONFIG_NETFILTER_NETLINK_QUEUE is not set
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_PROCFS=y
CONFIG_NF_CONNTRACK_EVENTS=y
# CONFIG_NF_CONNTRACK_TIMEOUT is not set
CONFIG_NF_CONNTRACK_TIMESTAMP=y
# CONFIG_NF_CT_PROTO_DCCP is not set
# CONFIG_NF_CT_PROTO_SCTP is not set
# CONFIG_NF_CT_PROTO_UDPLITE is not set
# CONFIG_NF_CONNTRACK_AMANDA is not set
# CONFIG_NF_CONNTRACK_FTP is not set
# CONFIG_NF_CONNTRACK_H323 is not set
# CONFIG_NF_CONNTRACK_IRC is not set
# CONFIG_NF_CONNTRACK_NETBIOS_NS is not set
# CONFIG_NF_CONNTRACK_SNMP is not set
# CONFIG_NF_CONNTRACK_PPTP is not set
# CONFIG_NF_CONNTRACK_SANE is not set
# CONFIG_NF_CONNTRACK_SIP is not set
# CONFIG_NF_CONNTRACK_TFTP is not set
# CONFIG_NF_CT_NETLINK is not set
# CONFIG_NF_CT_NETLINK_TIMEOUT is not set
CONFIG_NETFILTER_XTABLES=m

#
# Xtables combined modules
#
# CONFIG_NETFILTER_XT_MARK is not set
# CONFIG_NETFILTER_XT_CONNMARK is not set

#
# Xtables targets
#
# CONFIG_NETFILTER_XT_TARGET_AUDIT is not set
# CONFIG_NETFILTER_XT_TARGET_CHECKSUM is not set
# CONFIG_NETFILTER_XT_TARGET_CLASSIFY is not set
# CONFIG_NETFILTER_XT_TARGET_CONNMARK is not set
# CONFIG_NETFILTER_XT_TARGET_CONNSECMARK is not set
# CONFIG_NETFILTER_XT_TARGET_CT is not set
# CONFIG_NETFILTER_XT_TARGET_DSCP is not set
# CONFIG_NETFILTER_XT_TARGET_HL is not set
# CONFIG_NETFILTER_XT_TARGET_HMARK is not set
# CONFIG_NETFILTER_XT_TARGET_IDLETIMER is not set
# CONFIG_NETFILTER_XT_TARGET_LED is not set
CONFIG_NETFILTER_XT_TARGET_LOG=m
# CONFIG_NETFILTER_XT_TARGET_MARK is not set
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
# CONFIG_NETFILTER_XT_TARGET_NFQUEUE is not set
# CONFIG_NETFILTER_XT_TARGET_NOTRACK is not set
# CONFIG_NETFILTER_XT_TARGET_RATEEST is not set
# CONFIG_NETFILTER_XT_TARGET_TEE is not set
# CONFIG_NETFILTER_XT_TARGET_TRACE is not set
# CONFIG_NETFILTER_XT_TARGET_SECMARK is not set
# CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set
# CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP is not set

#
# Xtables matches
#
# CONFIG_NETFILTER_XT_MATCH_ADDRTYPE is not set
# CONFIG_NETFILTER_XT_MATCH_BPF is not set
# CONFIG_NETFILTER_XT_MATCH_CLUSTER is not set
# CONFIG_NETFILTER_XT_MATCH_COMMENT is not set
# CONFIG_NETFILTER_XT_MATCH_CONNBYTES is not set
# CONFIG_NETFILTER_XT_MATCH_CONNLABEL is not set
# CONFIG_NETFILTER_XT_MATCH_CONNLIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_CONNMARK is not set
# CONFIG_NETFILTER_XT_MATCH_CONNTRACK is not set
# CONFIG_NETFILTER_XT_MATCH_CPU is not set
# CONFIG_NETFILTER_XT_MATCH_DCCP is not set
# CONFIG_NETFILTER_XT_MATCH_DEVGROUP is not set
# CONFIG_NETFILTER_XT_MATCH_DSCP is not set
# CONFIG_NETFILTER_XT_MATCH_ECN is not set
# CONFIG_NETFILTER_XT_MATCH_ESP is not set
# CONFIG_NETFILTER_XT_MATCH_HASHLIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_HELPER is not set
# CONFIG_NETFILTER_XT_MATCH_HL is not set
# CONFIG_NETFILTER_XT_MATCH_IPRANGE is not set
# CONFIG_NETFILTER_XT_MATCH_LENGTH is not set
# CONFIG_NETFILTER_XT_MATCH_LIMIT is not set
CONFIG_NETFILTER_XT_MATCH_MAC=m
# CONFIG_NETFILTER_XT_MATCH_MARK is not set
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
# CONFIG_NETFILTER_XT_MATCH_NFACCT is not set
# CONFIG_NETFILTER_XT_MATCH_OSF is not set
# CONFIG_NETFILTER_XT_MATCH_OWNER is not set
# CONFIG_NETFILTER_XT_MATCH_POLICY is not set
# CONFIG_NETFILTER_XT_MATCH_PKTTYPE is not set
# CONFIG_NETFILTER_XT_MATCH_QUOTA is not set
# CONFIG_NETFILTER_XT_MATCH_RATEEST is not set
# CONFIG_NETFILTER_XT_MATCH_REALM is not set
# CONFIG_NETFILTER_XT_MATCH_RECENT is not set
# CONFIG_NETFILTER_XT_MATCH_SCTP is not set
CONFIG_NETFILTER_XT_MATCH_STATE=m
# CONFIG_NETFILTER_XT_MATCH_STATISTIC is not set
# CONFIG_NETFILTER_XT_MATCH_STRING is not set
# CONFIG_NETFILTER_XT_MATCH_TCPMSS is not set
# CONFIG_NETFILTER_XT_MATCH_TIME is not set
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
# CONFIG_IP_SET is not set
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_CONNTRACK_IPV4=m
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_IPTABLES=m
# CONFIG_IP_NF_MATCH_AH is not set
# CONFIG_IP_NF_MATCH_ECN is not set
# CONFIG_IP_NF_MATCH_TTL is not set
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_ULOG=m
# CONFIG_NF_NAT_IPV4 is not set
# CONFIG_IP_NF_MANGLE is not set
# CONFIG_IP_NF_RAW is not set
# CONFIG_IP_NF_SECURITY is not set
# CONFIG_IP_NF_ARPTABLES is not set

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV6=m
CONFIG_NF_CONNTRACK_IPV6=m
CONFIG_IP6_NF_IPTABLES=m
# CONFIG_IP6_NF_MATCH_AH is not set
# CONFIG_IP6_NF_MATCH_EUI64 is not set
# CONFIG_IP6_NF_MATCH_FRAG is not set
# CONFIG_IP6_NF_MATCH_OPTS is not set
# CONFIG_IP6_NF_MATCH_HL is not set
# CONFIG_IP6_NF_MATCH_IPV6HEADER is not set
# CONFIG_IP6_NF_MATCH_MH is not set
# CONFIG_IP6_NF_MATCH_RPFILTER is not set
# CONFIG_IP6_NF_MATCH_RT is not set
# CONFIG_IP6_NF_TARGET_HL is not set
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
# CONFIG_IP6_NF_SECURITY is not set
# CONFIG_NF_NAT_IPV6 is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
# CONFIG_BRIDGE is not set
CONFIG_HAVE_NET_DSA=y
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
# CONFIG_NET_SCH_HTB is not set
# CONFIG_NET_SCH_HFSC is not set
# CONFIG_NET_SCH_PRIO is not set
# CONFIG_NET_SCH_MULTIQ is not set
# CONFIG_NET_SCH_RED is not set
# CONFIG_NET_SCH_SFB is not set
# CONFIG_NET_SCH_SFQ is not set
# CONFIG_NET_SCH_TEQL is not set
# CONFIG_NET_SCH_TBF is not set
# CONFIG_NET_SCH_GRED is not set
# CONFIG_NET_SCH_DSMARK is not set
# CONFIG_NET_SCH_NETEM is not set
# CONFIG_NET_SCH_DRR is not set
# CONFIG_NET_SCH_MQPRIO is not set
# CONFIG_NET_SCH_CHOKE is not set
# CONFIG_NET_SCH_QFQ is not set
# CONFIG_NET_SCH_CODEL is not set
# CONFIG_NET_SCH_FQ_CODEL is not set
# CONFIG_NET_SCH_INGRESS is not set
# CONFIG_NET_SCH_PLUG is not set

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_ROUTE4 is not set
# CONFIG_NET_CLS_FW is not set
# CONFIG_NET_CLS_U32 is not set
# CONFIG_NET_CLS_RSVP is not set
# CONFIG_NET_CLS_RSVP6 is not set
# CONFIG_NET_CLS_FLOW is not set
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
# CONFIG_NET_EMATCH_CMP is not set
# CONFIG_NET_EMATCH_NBYTE is not set
# CONFIG_NET_EMATCH_U32 is not set
# CONFIG_NET_EMATCH_META is not set
# CONFIG_NET_EMATCH_TEXT is not set
CONFIG_NET_CLS_ACT=y
# CONFIG_NET_ACT_POLICE is not set
# CONFIG_NET_ACT_GACT is not set
# CONFIG_NET_ACT_MIRRED is not set
# CONFIG_NET_ACT_IPT is not set
# CONFIG_NET_ACT_NAT is not set
# CONFIG_NET_ACT_PEDIT is not set
# CONFIG_NET_ACT_SIMP is not set
# CONFIG_NET_ACT_SKBEDIT is not set
# CONFIG_NET_ACT_CSUM is not set
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_BQL=y
CONFIG_BPF_JIT=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
CONFIG_NET_DROP_MONITOR=y
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
# CONFIG_CFG80211_WEXT is not set
# CONFIG_LIB80211 is not set
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set
# CONFIG_NFC is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
# CONFIG_PARPORT_SERIAL is not set
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_PARIDE is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ATMEL_SSC is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_TI_DAC7512 is not set
# CONFIG_BMP085_I2C is not set
# CONFIG_BMP085_SPI is not set
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_LATTICE_ECP3_CONFIG is not set
# CONFIG_SRAM is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_AT25 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_EEPROM_93XX46 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
# CONFIG_VMWARE_VMCI is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=m
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
# CONFIG_SATA_AHCI_PLATFORM is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
# CONFIG_ATA_PIIX is not set
# CONFIG_SATA_HIGHBANK is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARASAN_CF is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
# CONFIG_BCACHE is not set
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
CONFIG_DM_BUFIO=y
CONFIG_DM_BIO_PRISON=y
CONFIG_DM_PERSISTENT_DATA=y
# CONFIG_DM_CRYPT is not set
# CONFIG_DM_SNAPSHOT is not set
# CONFIG_DM_THIN_PROVISIONING is not set
CONFIG_DM_CACHE=y
CONFIG_DM_CACHE_MQ=y
CONFIG_DM_CACHE_CLEANER=y
# CONFIG_DM_MIRROR is not set
# CONFIG_DM_RAID is not set
# CONFIG_DM_ZERO is not set
# CONFIG_DM_MULTIPATH is not set
# CONFIG_DM_DELAY is not set
CONFIG_DM_UEVENT=y
# CONFIG_DM_FLAKEY is not set
# CONFIG_DM_VERITY is not set
# CONFIG_TARGET_CORE is not set
CONFIG_FUSION=y
# CONFIG_FUSION_SPI is not set
# CONFIG_FUSION_FC is not set
# CONFIG_FUSION_SAS is not set
CONFIG_FUSION_MAX_SGE=128
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
# CONFIG_FIREWIRE_SBP2 is not set
# CONFIG_FIREWIRE_NET is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
# CONFIG_DUMMY is not set
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
CONFIG_MII=m
# CONFIG_IFB is not set
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
# CONFIG_VXLAN is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
# CONFIG_ARCNET is not set

#
# CAIF transport drivers
#
# CONFIG_VHOST_NET is not set

#
# Distributed Switch Architecture drivers
#
# CONFIG_NET_DSA_MV88E6XXX is not set
# CONFIG_NET_DSA_MV88E6060 is not set
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
CONFIG_ETHERNET=y
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_NET_VENDOR_ADAPTEC is not set
# CONFIG_NET_VENDOR_ALTEON is not set
# CONFIG_NET_VENDOR_AMD is not set
# CONFIG_NET_VENDOR_ATHEROS is not set
# CONFIG_NET_CADENCE is not set
# CONFIG_NET_VENDOR_BROADCOM is not set
# CONFIG_NET_VENDOR_BROCADE is not set
# CONFIG_NET_CALXEDA_XGMAC is not set
# CONFIG_NET_VENDOR_CHELSIO is not set
# CONFIG_NET_VENDOR_CISCO is not set
# CONFIG_DNET is not set
# CONFIG_NET_VENDOR_DEC is not set
# CONFIG_NET_VENDOR_DLINK is not set
# CONFIG_NET_VENDOR_EMULEX is not set
# CONFIG_NET_VENDOR_EXAR is not set
# CONFIG_NET_VENDOR_HP is not set
# CONFIG_NET_VENDOR_INTEL is not set
# CONFIG_IP1000 is not set
# CONFIG_JME is not set
# CONFIG_NET_VENDOR_MARVELL is not set
# CONFIG_NET_VENDOR_MELLANOX is not set
# CONFIG_NET_VENDOR_MICREL is not set
# CONFIG_NET_VENDOR_MICROCHIP is not set
# CONFIG_NET_VENDOR_MYRI is not set
# CONFIG_FEALNX is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
# CONFIG_NET_VENDOR_NVIDIA is not set
# CONFIG_NET_VENDOR_OKI is not set
# CONFIG_ETHOC is not set
# CONFIG_NET_PACKET_ENGINE is not set
# CONFIG_NET_VENDOR_QLOGIC is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_ATP is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
CONFIG_R8169=m
# CONFIG_NET_VENDOR_RDC is not set
# CONFIG_NET_VENDOR_SEEQ is not set
# CONFIG_NET_VENDOR_SILAN is not set
# CONFIG_NET_VENDOR_SIS is not set
# CONFIG_SFC is not set
# CONFIG_NET_VENDOR_SMSC is not set
# CONFIG_NET_VENDOR_STMICRO is not set
# CONFIG_NET_VENDOR_SUN is not set
# CONFIG_NET_VENDOR_TEHUTI is not set
# CONFIG_NET_VENDOR_TI is not set
# CONFIG_NET_VENDOR_VIA is not set
# CONFIG_NET_VENDOR_WIZNET is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_PHYLIB is not set
# CONFIG_MICREL_KS8995MA is not set
# CONFIG_PLIP is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_RTL8152 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_USB_IPHETH is not set
CONFIG_WLAN=y
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_AT76C50X_USB is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
# CONFIG_ADM8211 is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_MWL8K is not set
CONFIG_ATH_COMMON=m
CONFIG_ATH_CARDS=m
# CONFIG_ATH_DEBUG is not set
# CONFIG_ATH5K is not set
# CONFIG_ATH5K_PCI is not set
# CONFIG_ATH9K is not set
# CONFIG_ATH9K_HTC is not set
CONFIG_CARL9170=m
CONFIG_CARL9170_LEDS=y
CONFIG_CARL9170_WPC=y
# CONFIG_ATH6KL is not set
# CONFIG_AR5523 is not set
# CONFIG_WIL6210 is not set
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_BRCMFMAC is not set
# CONFIG_HOSTAP is not set
# CONFIG_IPW2100 is not set
# CONFIG_IWLWIFI is not set
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
# CONFIG_LIBERTAS is not set
# CONFIG_P54_COMMON is not set
CONFIG_RT2X00=m
# CONFIG_RT2400PCI is not set
# CONFIG_RT2500PCI is not set
# CONFIG_RT61PCI is not set
# CONFIG_RT2800PCI is not set
# CONFIG_RT2500USB is not set
CONFIG_RT73USB=m
CONFIG_RT2800USB=m
# CONFIG_RT2800USB_RT33XX is not set
# CONFIG_RT2800USB_RT35XX is not set
# CONFIG_RT2800USB_RT53XX is not set
# CONFIG_RT2800USB_RT55XX is not set
# CONFIG_RT2800USB_UNKNOWN is not set
CONFIG_RT2800_LIB=m
CONFIG_RT2X00_LIB_USB=m
CONFIG_RT2X00_LIB=m
CONFIG_RT2X00_LIB_FIRMWARE=y
CONFIG_RT2X00_LIB_CRYPTO=y
CONFIG_RT2X00_LIB_LEDS=y
# CONFIG_RT2X00_DEBUG is not set
# CONFIG_RTLWIFI is not set
# CONFIG_WL_TI is not set
# CONFIG_ZD1211RW is not set
# CONFIG_MWIFIEX is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set
CONFIG_INPUT_SPARSEKMAP=m
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=m
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_GPIO is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
# CONFIG_JOYSTICK_A3D is not set
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
# CONFIG_JOYSTICK_GRIP_MP is not set
# CONFIG_JOYSTICK_GUILLEMOT is not set
# CONFIG_JOYSTICK_INTERACT is not set
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
# CONFIG_JOYSTICK_WARRIOR is not set
# CONFIG_JOYSTICK_MAGELLAN is not set
# CONFIG_JOYSTICK_SPACEORB is not set
# CONFIG_JOYSTICK_SPACEBALL is not set
# CONFIG_JOYSTICK_STINGER is not set
# CONFIG_JOYSTICK_TWIDJOY is not set
# CONFIG_JOYSTICK_ZHENHUA is not set
# CONFIG_JOYSTICK_DB9 is not set
# CONFIG_JOYSTICK_GAMECON is not set
# CONFIG_JOYSTICK_TURBOGRAFX is not set
# CONFIG_JOYSTICK_AS5011 is not set
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
# CONFIG_JOYSTICK_WALKERA0701 is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_GTCO is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_ADS7846 is not set
# CONFIG_TOUCHSCREEN_AD7877 is not set
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
# CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
# CONFIG_TOUCHSCREEN_BU21013 is not set
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
# CONFIG_TOUCHSCREEN_EETI is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_ILI210X is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
# CONFIG_TOUCHSCREEN_WACOM_I2C is not set
# CONFIG_TOUCHSCREEN_MAX11801 is not set
# CONFIG_TOUCHSCREEN_MCS5000 is not set
# CONFIG_TOUCHSCREEN_MMS114 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_PIXCIR is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
# CONFIG_TOUCHSCREEN_TSC2005 is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_ST1232 is not set
# CONFIG_TOUCHSCREEN_TPS6507X is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
CONFIG_INPUT_PCSPKR=m
# CONFIG_INPUT_MMA8450 is not set
# CONFIG_INPUT_MPU3050 is not set
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_GP2A is not set
# CONFIG_INPUT_GPIO_TILT_POLLED is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_KXTJ9 is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_UINPUT is not set
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_IMS_PCU is not set
# CONFIG_INPUT_CMA3000 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_SERIO_ARC_PS2 is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=m
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_ISMT is not set
CONFIG_I2C_PIIX4=m
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_INTEL_MID is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_PARPORT is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
# CONFIG_SPI_BITBANG is not set
# CONFIG_SPI_BUTTERFLY is not set
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_LM70_LLP is not set
# CONFIG_SPI_OC_TINY is not set
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
# CONFIG_SPI_SC18IS602 is not set
# CONFIG_SPI_TOPCLIFF_PCH is not set
# CONFIG_SPI_XCOMM is not set
# CONFIG_SPI_XILINX is not set
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_TLE62X0 is not set

#
# Qualcomm MSM SSBI bus support
#
# CONFIG_SSBI is not set
# CONFIG_HSI is not set

#
# PPS support
#
# CONFIG_PPS is not set

#
# PPS generators support
#

#
# PTP clock support
#
# CONFIG_PTP_1588_CLOCK is not set

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_IT8761E is not set
# CONFIG_GPIO_TS5500 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_LANGWELL is not set
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MCP23S08 is not set
# CONFIG_GPIO_MC33880 is not set
# CONFIG_GPIO_74X164 is not set

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#

#
# USB GPIO expanders:
#
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_BATTERY_GOLDFISH is not set
CONFIG_POWER_RESET=y
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7314 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADCXX is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7310 is not set
# CONFIG_SENSORS_ADT7410 is not set
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
CONFIG_SENSORS_K10TEMP=m
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_GPIO_FAN is not set
# CONFIG_SENSORS_HIH6130 is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_LINEAGE is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM70 is not set
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_LM95234 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_NCT6775=m
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT15 is not set
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC6W201 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
# CONFIG_SENSORS_ADS1015 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_ADS7871 is not set
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_INA209 is not set
# CONFIG_SENSORS_INA2XX is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_USER_SPACE is not set
# CONFIG_CPU_THERMAL is not set
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_CORE is not set
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_F71808E_WDT is not set
CONFIG_SP5100_TCO=m
# CONFIG_SC520_WDT is not set
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_VIA_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_CROS_EC is not set
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_MC13XXX_SPI is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_EZX_PCAP is not set
# CONFIG_MFD_VIPERBOARD is not set
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TPS65912 is not set
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_REGULATOR is not set
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
CONFIG_MEDIA_RADIO_SUPPORT=y
CONFIG_MEDIA_RC_SUPPORT=y
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2=m
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF_DVB=m
# CONFIG_VIDEO_V4L2_INT_DEVICE is not set
CONFIG_DVB_CORE=m
CONFIG_DVB_NET=y
# CONFIG_TTPCI_EEPROM is not set
CONFIG_DVB_MAX_ADAPTERS=8
# CONFIG_DVB_DYNAMIC_MINORS is not set

#
# Media drivers
#
CONFIG_RC_CORE=m
CONFIG_RC_MAP=m
# CONFIG_RC_DECODERS is not set
# CONFIG_RC_DEVICES is not set
CONFIG_MEDIA_USB_SUPPORT=y

#
# Analog/digital TV USB devices
#
# CONFIG_VIDEO_AU0828 is not set
# CONFIG_VIDEO_CX231XX is not set
# CONFIG_VIDEO_TM6000 is not set

#
# Digital TV USB devices
#
CONFIG_DVB_USB=m
# CONFIG_DVB_USB_DEBUG is not set
# CONFIG_DVB_USB_A800 is not set
# CONFIG_DVB_USB_DIBUSB_MB is not set
# CONFIG_DVB_USB_DIBUSB_MC is not set
# CONFIG_DVB_USB_DIB0700 is not set
# CONFIG_DVB_USB_UMT_010 is not set
# CONFIG_DVB_USB_CXUSB is not set
# CONFIG_DVB_USB_M920X is not set
# CONFIG_DVB_USB_DIGITV is not set
# CONFIG_DVB_USB_VP7045 is not set
# CONFIG_DVB_USB_VP702X is not set
# CONFIG_DVB_USB_GP8PSK is not set
CONFIG_DVB_USB_NOVA_T_USB2=m
# CONFIG_DVB_USB_TTUSB2 is not set
# CONFIG_DVB_USB_DTT200U is not set
# CONFIG_DVB_USB_OPERA1 is not set
# CONFIG_DVB_USB_AF9005 is not set
# CONFIG_DVB_USB_PCTV452E is not set
# CONFIG_DVB_USB_DW2102 is not set
# CONFIG_DVB_USB_CINERGY_T2 is not set
# CONFIG_DVB_USB_DTV5100 is not set
# CONFIG_DVB_USB_FRIIO is not set
# CONFIG_DVB_USB_AZ6027 is not set
# CONFIG_DVB_USB_TECHNISAT_USB2 is not set
CONFIG_DVB_USB_V2=m
CONFIG_DVB_USB_AF9015=m
# CONFIG_DVB_USB_AF9035 is not set
# CONFIG_DVB_USB_ANYSEE is not set
# CONFIG_DVB_USB_AU6610 is not set
# CONFIG_DVB_USB_AZ6007 is not set
# CONFIG_DVB_USB_CE6230 is not set
# CONFIG_DVB_USB_EC168 is not set
# CONFIG_DVB_USB_GL861 is not set
# CONFIG_DVB_USB_IT913X is not set
# CONFIG_DVB_USB_LME2510 is not set
# CONFIG_DVB_USB_MXL111SF is not set
# CONFIG_DVB_USB_RTL28XXU is not set
# CONFIG_DVB_TTUSB_BUDGET is not set
# CONFIG_DVB_TTUSB_DEC is not set
# CONFIG_SMS_USB_DRV is not set
# CONFIG_DVB_B2C2_FLEXCOP_USB is not set

#
# Webcam, TV (analog/digital) USB devices
#
# CONFIG_VIDEO_EM28XX is not set
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture/analog/hybrid TV support
#
# CONFIG_VIDEO_CX18 is not set
# CONFIG_VIDEO_CX23885 is not set
# CONFIG_VIDEO_CX25821 is not set
CONFIG_VIDEO_CX88=m
CONFIG_VIDEO_CX88_ALSA=m
CONFIG_VIDEO_CX88_BLACKBIRD=m
CONFIG_VIDEO_CX88_DVB=m
CONFIG_VIDEO_CX88_VP3054=m
CONFIG_VIDEO_CX88_MPEG=m
# CONFIG_VIDEO_BT848 is not set
# CONFIG_VIDEO_SAA7134 is not set
CONFIG_VIDEO_SAA7164=m

#
# Media digital TV PCI Adapters
#
# CONFIG_DVB_AV7110 is not set
# CONFIG_DVB_BUDGET_CORE is not set
# CONFIG_DVB_B2C2_FLEXCOP_PCI is not set
# CONFIG_DVB_PLUTO2 is not set
# CONFIG_DVB_DM1105 is not set
# CONFIG_DVB_PT1 is not set
# CONFIG_MANTIS_CORE is not set
# CONFIG_DVB_NGENE is not set
# CONFIG_DVB_DDBRIDGE is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_RADIO_ADAPTERS=y
# CONFIG_RADIO_SI470X is not set
# CONFIG_USB_MR800 is not set
# CONFIG_USB_DSBR is not set
# CONFIG_RADIO_MAXIRADIO is not set
# CONFIG_RADIO_SHARK is not set
# CONFIG_RADIO_SHARK2 is not set
# CONFIG_I2C_SI4713 is not set
# CONFIG_RADIO_SI4713 is not set
# CONFIG_USB_KEENE is not set
# CONFIG_USB_MA901 is not set
# CONFIG_RADIO_TEA5764 is not set
# CONFIG_RADIO_SAA7706H is not set
# CONFIG_RADIO_TEF6862 is not set
# CONFIG_RADIO_WL1273 is not set

#
# Texas Instruments WL128x FM driver (ST based)
#

#
# Supported FireWire (IEEE 1394) Adapters
#
# CONFIG_DVB_FIREDTV is not set
CONFIG_VIDEO_CX2341X=m
CONFIG_VIDEO_BTCX=m
CONFIG_VIDEO_TVEEPROM=m
# CONFIG_CYPRESS_FIRMWARE is not set

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y
CONFIG_MEDIA_ATTACH=y
CONFIG_VIDEO_IR_I2C=m

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_WM8775=m

#
# RDS decoders
#

#
# Video decoders
#

#
# Video and audio decoders
#

#
# Video encoders
#

#
# Camera sensor devices
#

#
# Flash devices
#

#
# Video improvement chips
#

#
# Miscelaneous helper chips
#

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=m
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_MT2060=m
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_XC4000=m
CONFIG_MEDIA_TUNER_MXL5005S=m
CONFIG_MEDIA_TUNER_MXL5007T=m
CONFIG_MEDIA_TUNER_MC44S803=m
CONFIG_MEDIA_TUNER_TDA18218=m

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB6100=m

#
# Multistandard (cable + terrestrial) frontends
#

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24123=m
CONFIG_DVB_STV0288=m
CONFIG_DVB_STB6000=m
CONFIG_DVB_STV0299=m
CONFIG_DVB_STV0900=m
CONFIG_DVB_CX24116=m
CONFIG_DVB_TS2020=m
CONFIG_DVB_DS3000=m

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_CX22702=m
CONFIG_DVB_MT352=m
CONFIG_DVB_ZL10353=m
CONFIG_DVB_DIB3000MC=m
CONFIG_DVB_TDA10048=m
CONFIG_DVB_AF9013=m

#
# DVB-C (cable) frontends
#

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=m
CONFIG_DVB_OR51132=m
CONFIG_DVB_LGDT330X=m
CONFIG_DVB_S5H1411=m

#
# ISDB-T (terrestrial) frontends
#

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=m

#
# SEC control devices for DVB-S
#
CONFIG_DVB_ISL6421=m

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=m
CONFIG_DRM_KMS_HELPER=m
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
CONFIG_DRM_TTM=m

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
# CONFIG_DRM_I2C_SIL164 is not set
# CONFIG_DRM_I2C_NXP_TDA998X is not set
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=m
# CONFIG_DRM_RADEON_UMS is not set
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_DRM_QXL is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
CONFIG_HDMI=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
# CONFIG_FB_DDC is not set
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_GOLDFISH is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LM3630 is not set
# CONFIG_BACKLIGHT_LM3639 is not set
# CONFIG_BACKLIGHT_LP855X is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=m
# CONFIG_SOUND_OSS_CORE is not set
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_JACK=y
# CONFIG_SND_SEQUENCER is not set
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
# CONFIG_SND_HRTIMER is not set
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_SUPPORT_OLD_API=y
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_KCTL_JACK=y
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_DRIVERS=y
# CONFIG_SND_PCSP is not set
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_ALOOP is not set
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_MTS64 is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set
# CONFIG_SND_PORTMAN2X4 is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ASIHPI is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_HDA_PREALLOC_SIZE=64
CONFIG_SND_HDA_HWDEP=y
CONFIG_SND_HDA_RECONFIG=y
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_BEEP_MODE=1
CONFIG_SND_HDA_INPUT_JACK=y
# CONFIG_SND_HDA_PATCH_LOADER is not set
CONFIG_SND_HDA_CODEC_REALTEK=y
# CONFIG_SND_HDA_CODEC_ANALOG is not set
# CONFIG_SND_HDA_CODEC_SIGMATEL is not set
# CONFIG_SND_HDA_CODEC_VIA is not set
CONFIG_SND_HDA_CODEC_HDMI=y
# CONFIG_SND_HDA_CODEC_CIRRUS is not set
# CONFIG_SND_HDA_CODEC_CONEXANT is not set
# CONFIG_SND_HDA_CODEC_CA0110 is not set
# CONFIG_SND_HDA_CODEC_CA0132 is not set
# CONFIG_SND_HDA_CODEC_CMEDIA is not set
# CONFIG_SND_HDA_CODEC_SI3054 is not set
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=1
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LOLA is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
# CONFIG_SND_SPI is not set
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=m
# CONFIG_SND_USB_UA101 is not set
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set
# CONFIG_SND_USB_US122L is not set
# CONFIG_SND_USB_6FIRE is not set
# CONFIG_SND_FIREWIRE is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set

#
# HID support
#
CONFIG_HID=m
CONFIG_HIDRAW=y
CONFIG_UHID=m
CONFIG_HID_GENERIC=m

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=m
# CONFIG_HID_APPLEIR is not set
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=m
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=m
# CONFIG_HID_PRODIKEYS is not set
CONFIG_HID_CYPRESS=m
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
CONFIG_HID_EZKEY=m
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_ICADE is not set
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=m
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LENOVO_TPKBD is not set
CONFIG_HID_LOGITECH=m
# CONFIG_HID_LOGITECH_DJ is not set
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWHEELS_FF is not set
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_NTRIG is not set
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_PS3REMOTE is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SONY is not set
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THINGM is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
# CONFIG_HID_WIIMOTE is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set

#
# USB HID support
#
CONFIG_USB_HID=m
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=m
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=m
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
CONFIG_USB_DYNAMIC_MINORS=y
# CONFIG_USB_OTG is not set
# CONFIG_USB_MON is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=m
# CONFIG_USB_XHCI_HCD_DEBUGGING is not set
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=m
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_OHCI_HCD=m
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_MUSB_HDRC is not set
# CONFIG_USB_RENESAS_USBHS is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_REALTEK is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_CHIPIDEA is not set

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
CONFIG_USB_SERIAL=m
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
# CONFIG_USB_SERIAL_CP210X is not set
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
# CONFIG_USB_SERIAL_EMPEG is not set
CONFIG_USB_SERIAL_FTDI_SIO=m
# CONFIG_USB_SERIAL_FUNSOFT is not set
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_F81232 is not set
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_IUU is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_METRO is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_MOTOROLA is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
CONFIG_USB_SERIAL_PL2303=m
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_QCAUX is not set
# CONFIG_USB_SERIAL_QUALCOMM is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
# CONFIG_USB_SERIAL_HP4X is not set
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIEMENS_MPI is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_SYMBOL is not set
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_XIRCOM is not set
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_OPTICON is not set
# CONFIG_USB_SERIAL_VIVOPAY_SERIAL is not set
# CONFIG_USB_SERIAL_XSENS_MT is not set
# CONFIG_USB_SERIAL_ZIO is not set
# CONFIG_USB_SERIAL_WISHBONE is not set
# CONFIG_USB_SERIAL_ZTE is not set
# CONFIG_USB_SERIAL_SSU100 is not set
# CONFIG_USB_SERIAL_QT2 is not set
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
# CONFIG_USB_EZUSB_FX2 is not set
# CONFIG_USB_HSIC_USB3503 is not set
# CONFIG_USB_PHY is not set
CONFIG_USB_GADGET=m
# CONFIG_USB_GADGET_DEBUG is not set
# CONFIG_USB_GADGET_DEBUG_FILES is not set
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
# CONFIG_USB_R8A66597 is not set
# CONFIG_USB_PXA27X is not set
# CONFIG_USB_MV_UDC is not set
# CONFIG_USB_MV_U3D is not set
# CONFIG_USB_M66592 is not set
# CONFIG_USB_AMD5536UDC is not set
# CONFIG_USB_NET2272 is not set
# CONFIG_USB_NET2280 is not set
# CONFIG_USB_GOKU is not set
# CONFIG_USB_EG20T is not set
# CONFIG_USB_DUMMY_HCD is not set
# CONFIG_USB_ZERO is not set
# CONFIG_USB_AUDIO is not set
# CONFIG_USB_ETH is not set
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
# CONFIG_USB_MASS_STORAGE is not set
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_MIDI_GADGET is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_ACM_MS is not set
# CONFIG_USB_G_MULTI is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set
# CONFIG_USB_G_WEBCAM is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_LP5562 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA9633 is not set
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_LT3593 is not set
# CONFIG_LEDS_DELL_NETBOOKS is not set
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_LM355x is not set
# CONFIG_LEDS_OT200 is not set
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_GPIO is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
# CONFIG_LEDS_TRIGGER_CAMERA is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
# CONFIG_EDAC_DECODE_MCE is not set
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_DS3232 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_ISL12022 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8523 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_BQ32K is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set
# CONFIG_RTC_DRV_EM3027 is not set
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T93 is not set
# CONFIG_RTC_DRV_M41T94 is not set
# CONFIG_RTC_DRV_DS1305 is not set
# CONFIG_RTC_DRV_DS1390 is not set
# CONFIG_RTC_DRV_MAX6902 is not set
# CONFIG_RTC_DRV_R9701 is not set
# CONFIG_RTC_DRV_RS5C348 is not set
# CONFIG_RTC_DRV_DS3234 is not set
# CONFIG_RTC_DRV_PCF2123 is not set
# CONFIG_RTC_DRV_RX4581 is not set

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
# CONFIG_RTC_DRV_V3020 is not set
# CONFIG_RTC_DRV_DS2404 is not set

#
# on-CPU RTC drivers
#

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_HID_SENSOR_TIME is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_DW_DMAC is not set
# CONFIG_TIMB_DMA is not set
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ACPI=y
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
# CONFIG_VFIO is not set
CONFIG_VIRT_DRIVERS=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_CHROMEOS_LAPTOP is not set
# CONFIG_DELL_WMI is not set
# CONFIG_DELL_WMI_AIO is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WMI is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
CONFIG_ACPI_WMI=m
# CONFIG_MSI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_LAPTOP is not set
# CONFIG_MXM_WMI is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_PVPANIC is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y
CONFIG_AMD_IOMMU=y
# CONFIG_AMD_IOMMU_STATS is not set
CONFIG_AMD_IOMMU_V2=m
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
# CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
CONFIG_INTEL_IOMMU_FLOPPY_WA=y
CONFIG_IRQ_REMAP=y

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
# CONFIG_EFI_VARS is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=m
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=m
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
# CONFIG_EXT3_FS_XATTR is not set
CONFIG_EXT4_FS=y
# CONFIG_EXT4_FS_POSIX_ACL is not set
# CONFIG_EXT4_FS_SECURITY is not set
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD=m
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
CONFIG_BTRFS_FS=m
# CONFIG_BTRFS_FS_POSIX_ACL is not set
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
# CONFIG_FANOTIFY_ACCESS_PERMISSIONS is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
# CONFIG_QFMT_V1 is not set
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m
# CONFIG_CUSE is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
CONFIG_FSCACHE=m
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
# CONFIG_CACHEFILES is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="utf8"
CONFIG_NTFS_FS=m
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_LOGFS is not set
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
# CONFIG_PSTORE_RAM is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_F2FS_FS is not set
# CONFIG_EFIVAR_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V2=m
CONFIG_NFS_V3=m
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=m
# CONFIG_NFS_SWAP is not set
CONFIG_NFS_V4_1=y
CONFIG_PNFS_FILE_LAYOUT=m
CONFIG_PNFS_BLOCK=m
CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
CONFIG_NFS_FSCACHE=y
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
# CONFIG_NFSD_FAULT_INJECTION is not set
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_BACKCHANNEL=y
# CONFIG_SUNRPC_DEBUG is not set
# CONFIG_CEPH_FS is not set
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=m

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_DEBUG_SLAB is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_ATOMIC_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_INFO_REDUCED is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
# CONFIG_FRAME_POINTER is not set
CONFIG_BOOT_PRINTK_DELAY=y

#
# RCU Debugging
#
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_LKDTM is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
# CONFIG_TRACER_SNAPSHOT is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
# CONFIG_KPROBE_EVENT is not set
# CONFIG_UPROBE_EVENT is not set
# CONFIG_PROBE_EVENTS is not set
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
# CONFIG_TEST_STRING_HELPERS is not set
# CONFIG_TEST_KSTRTOX is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_DEBUG_SET_MODULE_RONX=y
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_NMI_SELFTEST is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_ENCRYPTED_KEYS is not set
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
# CONFIG_INTEL_TXT is not set
CONFIG_LSM_MMAP_MIN_ADDR=65536
CONFIG_SECURITY_SELINUX=y
# CONFIG_SECURITY_SELINUX_BOOTPARAM is not set
# CONFIG_SECURITY_SELINUX_DISABLE is not set
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
# CONFIG_SECURITY_SMACK is not set
CONFIG_SECURITY_TOMOYO=y
CONFIG_SECURITY_TOMOYO_MAX_ACCEPT_ENTRY=2048
CONFIG_SECURITY_TOMOYO_MAX_AUDIT_LOG=1024
# CONFIG_SECURITY_TOMOYO_OMIT_USERSPACE_LOADER is not set
CONFIG_SECURITY_TOMOYO_POLICY_LOADER="/sbin/tomoyo-init"
CONFIG_SECURITY_TOMOYO_ACTIVATION_TRIGGER="/sbin/init"
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
# CONFIG_SECURITY_YAMA is not set
# CONFIG_IMA is not set
# CONFIG_EVM is not set
# CONFIG_DEFAULT_SECURITY_SELINUX is not set
# CONFIG_DEFAULT_SECURITY_TOMOYO is not set
# CONFIG_DEFAULT_SECURITY_APPARMOR is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_ABLK_HELPER_X86=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
# CONFIG_CRYPTO_CBC is not set
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
# CONFIG_CRYPTO_ECB is not set
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
# CONFIG_CRYPTO_CMAC is not set
# CONFIG_CRYPTO_HMAC is not set
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_CRC32=m
CONFIG_CRYPTO_CRC32_PCLMUL=y
# CONFIG_CRYPTO_GHASH is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
# CONFIG_CRYPTO_SHA1 is not set
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
CONFIG_CRYPTO_SHA256_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=m
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_BLOWFISH_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set
# CONFIG_CRYPTO_TWOFISH_X86_64_3WAY is not set
# CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
# CONFIG_KVM_INTEL is not set
CONFIG_KVM_AMD=m
# CONFIG_KVM_MMU_AUDIT is not set
CONFIG_KVM_DEVICE_ASSIGNMENT=y
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=m
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y




lspci

00:00.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 14h
Processor Root Complex
00:01.0 VGA compatible controller: Advanced Micro Devices, Inc.
[AMD/ATI] Wrestler [Radeon HD 6310]
00:01.1 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] Wrestler
HDMI Audio
00:11.0 SATA controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 SATA Controller [IDE mode] (rev 40)
00:12.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
00:12.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB EHCI Controller
00:13.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
00:13.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB EHCI Controller
00:14.0 SMBus: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 SMBus
Controller (rev 42)
00:14.1 IDE interface: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 IDE Controller (rev 40)
00:14.2 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] SBx00
Azalia (Intel HDA) (rev 40)
00:14.3 ISA bridge: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 LPC host controller (rev 40)
00:14.4 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 PCI to
PCI Bridge (rev 40)
00:14.5 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB OHCI2 Controller
00:15.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI]
SB700/SB800/SB900 PCI to PCI bridge (PCIE port 0)
00:15.1 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI]
SB700/SB800/SB900 PCI to PCI bridge (PCIE port 1)
00:15.2 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] SB900 PCI to
PCI bridge (PCIE port 2)
00:15.3 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] SB900 PCI to
PCI bridge (PCIE port 3)
00:16.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
00:16.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB EHCI Controller
00:18.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 12h/14h
Processor Function 0 (rev 43)
00:18.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 12h/14h
Processor Function 1
00:18.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 12h/14h
Processor Function 2
00:18.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 12h/14h
Processor Function 3
00:18.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 12h/14h
Processor Function 4
00:18.5 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 12h/14h
Processor Function 6
00:18.6 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 12h/14h
Processor Function 5
00:18.7 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 12h/14h
Processor Function 7
02:00.0 Multimedia controller: Philips Semiconductors SAA7164 (rev 81)
03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 06)
04:00.0 PCI bridge: ASMedia Technology Inc. ASM1083/1085 PCIe to PCI
Bridge (rev 01)
05:00.0 Multimedia video controller: Conexant Systems, Inc.
CX23880/1/2/3 PCI Video and Audio Decoder (rev 05)
05:00.1 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI
Video and Audio Decoder [Audio Port] (rev 05)
05:00.2 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI
Video and Audio Decoder [MPEG Port] (rev 05)
05:02.0 FireWire (IEEE 1394): VIA Technologies, Inc. VT6306/7/8 [Fire
II(M)] IEEE 1394 OHCI Controller (rev c0)
06:00.0 USB controller: ASMedia Technology Inc. ASM1042 SuperSpeed USB
Host Controller



