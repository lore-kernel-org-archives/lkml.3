Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbaDTJ4q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 05:56:46 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:36580 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303AbaDTJ4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 05:56:16 -0400
Date: Sun, 20 Apr 2014 11:56:12 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Christian =?iso-8859-1?Q?K=F6nig?= <deathsimple@vodafone.de>
Cc: Alex Deucher <alexdeucher@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Subject: Re: [git pull] drm fixes
Message-ID: <20140420095612.GA268@x4>
References: <alpine.DEB.2.00.1404190810001.7507@skynet.skynet.ie>
 <20140419190305.GA267@x4>
 <CADnq5_M9COdOJhOu4_9yRpDoFt3bcc9HVqrvQqnYM3YuTLv15A@mail.gmail.com>
 <20140420062450.GA281@x4>
 <535384FC.1060708@vodafone.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <535384FC.1060708@vodafone.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On 2014.04.20 at 10:27 +0200, Christian König wrote:
> > I did and it doesn't fix the issue.
> In this case please open up a new bugreport on 
> https://bugs.freedesktop.org/enter_bug.cgi?product=DRI and select 
> DRM/Radeon as component.
> 
> Additional to that please provide a dmesg output generated with 
> drm.debug=0xE for both the good and the bad case.

Good vs. bad:

-[drm:radeon_compute_pll_avivo] 146250 - 14439, pll dividers - fb: 2047.0 ref: 29, post 7
+[drm:radeon_compute_pll_avivo] 146250 - 14955, pll dividers - fb: 1023.5 ref: 14, post 7

Full bad dmesg is attached.

-- 
Markus

--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=radeon_dmesg

Linux version 3.15.0-rc1-00421-g6d4596905b65-dirty (markus@x4) (gcc version 4.9.0 20140417 (prerelease) (GCC) ) #24 SMP Sun Apr 20 11:44:09 CEST 2014
Command line: BOOT_IMAGE=/bzImage root=PARTUUID=3ce070b6-a2b4-4127-9478-6ea8ceb69db7 init=/sbin/minit fbcon=rotate:3 radeon.dpm=1 radeon.audio=0 drm_kms_helper.poll=0 quiet drm.debug=0xE
KERNEL supported cpus:
  AMD AuthenticAMD
e820: BIOS-provided physical RAM map:
BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
BIOS-e820: [mem 0x00000000000e6000-0x00000000000fffff] reserved
BIOS-e820: [mem 0x0000000000100000-0x00000000dfe8ffff] usable
BIOS-e820: [mem 0x00000000dfe90000-0x00000000dfea7fff] ACPI data
BIOS-e820: [mem 0x00000000dfea8000-0x00000000dfecffff] ACPI NVS
BIOS-e820: [mem 0x00000000dfed0000-0x00000000dfefffff] reserved
BIOS-e820: [mem 0x00000000fff00000-0x00000000ffffffff] reserved
BIOS-e820: [mem 0x0000000100000000-0x000000021fffffff] usable
NX (Execute Disable) protection: active
SMBIOS 2.5 present.
DMI: System manufacturer System Product Name/M4A78T-E, BIOS 3503    04/13/2011
e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
e820: remove [mem 0x000a0000-0x000fffff] usable
e820: last_pfn = 0x220000 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-EFFFF uncachable
  F0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000000 mask FFFF80000000 write-back
  1 base 000080000000 mask FFFFC0000000 write-back
  2 base 0000C0000000 mask FFFFE0000000 write-back
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
TOM2: 0000000220000000 aka 8704M
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
e820: update [mem 0xe0000000-0xffffffff] usable ==> reserved
e820: last_pfn = 0xdfe90 max_arch_pfn = 0x400000000
Base memory trampoline at [ffff880000099000] 99000 size 24576
Using GB pages for direct mapping
init_memory_mapping: [mem 0x00000000-0x000fffff]
 [mem 0x00000000-0x000fffff] page 4k
BRK [0x019bf000, 0x019bffff] PGTABLE
BRK [0x019c0000, 0x019c0fff] PGTABLE
BRK [0x019c1000, 0x019c1fff] PGTABLE
init_memory_mapping: [mem 0x21fe00000-0x21fffffff]
 [mem 0x21fe00000-0x21fffffff] page 2M
BRK [0x019c2000, 0x019c2fff] PGTABLE
init_memory_mapping: [mem 0x21c000000-0x21fdfffff]
 [mem 0x21c000000-0x21fdfffff] page 2M
init_memory_mapping: [mem 0x200000000-0x21bffffff]
 [mem 0x200000000-0x21bffffff] page 2M
init_memory_mapping: [mem 0x00100000-0xdfe8ffff]
 [mem 0x00100000-0x001fffff] page 4k
 [mem 0x00200000-0x3fffffff] page 2M
 [mem 0x40000000-0xbfffffff] page 1G
 [mem 0xc0000000-0xdfdfffff] page 2M
 [mem 0xdfe00000-0xdfe8ffff] page 4k
init_memory_mapping: [mem 0x100000000-0x1ffffffff]
 [mem 0x100000000-0x1ffffffff] page 1G
ACPI: RSDP 0x00000000000FB880 000024 (v02 ACPIAM)
ACPI: XSDT 0x00000000DFE90100 00005C (v01 041311 XSDT1656 20110413 MSFT 00000097)
ACPI: FACP 0x00000000DFE90290 0000F4 (v03 041311 FACP1656 20110413 MSFT 00000097)
ACPI BIOS Warning (bug): Optional FADT field Pm2ControlBlock has zero address or length: 0x0000000000000000/0x1 (20140214/tbfadt-634)
ACPI BIOS Warning (bug): 32/64X length mismatch in FADT/Gpe0Block: 64/32 (20140214/tbfadt-603)
ACPI: DSDT 0x00000000DFE90450 00E6FE (v01 A1152  A1152000 00000000 INTL 20060113)
ACPI: FACS 0x00000000DFEA8000 000040
ACPI: APIC 0x00000000DFE90390 00007C (v01 041311 APIC1656 20110413 MSFT 00000097)
ACPI: MCFG 0x00000000DFE90410 00003C (v01 041311 OEMMCFG  20110413 MSFT 00000097)
ACPI: OEMB 0x00000000DFEA8040 000072 (v01 041311 OEMB1656 20110413 MSFT 00000097)
ACPI: SRAT 0x00000000DFE9F450 0000E8 (v01 AMD    FAM_F_10 00000002 AMD  00000001)
ACPI: HPET 0x00000000DFE9F540 000038 (v01 041311 OEMHPET  20110413 MSFT 00000097)
ACPI: SSDT 0x00000000DFE9F580 00088C (v01 A M I  POWERNOW 00000001 AMD  00000001)
ACPI: Local APIC address 0xfee00000
 [ffffea0000000000-ffffea00087fffff] PMD -> [ffff880217600000-ffff88021f5fffff] on node 0
Zone ranges:
  DMA      [mem 0x00001000-0x00ffffff]
  DMA32    [mem 0x01000000-0xffffffff]
  Normal   [mem 0x100000000-0x21fffffff]
Movable zone start for each node
Early memory node ranges
  node   0: [mem 0x00001000-0x0009efff]
  node   0: [mem 0x00100000-0xdfe8ffff]
  node   0: [mem 0x100000000-0x21fffffff]
On node 0 totalpages: 2096686
  DMA zone: 64 pages used for memmap
  DMA zone: 21 pages reserved
  DMA zone: 3998 pages, LIFO batch:0
  DMA32 zone: 14267 pages used for memmap
  DMA32 zone: 913040 pages, LIFO batch:31
  Normal zone: 18432 pages used for memmap
  Normal zone: 1179648 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x84] disabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x85] disabled)
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8300 base: 0xfed00000
smpboot: Allowing 4 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 40
e820: [mem 0xdff00000-0xffefffff] available for PCI devices
setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
PERCPU: Embedded 24 pages/cpu @ffff88021fc00000 s75072 r0 d23232 u524288
pcpu-alloc: s75072 r0 d23232 u524288 alloc=1*2097152
pcpu-alloc: [0] 0 1 2 3 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2063902
Kernel command line: BOOT_IMAGE=/bzImage root=PARTUUID=3ce070b6-a2b4-4127-9478-6ea8ceb69db7 init=/sbin/minit fbcon=rotate:3 radeon.dpm=1 radeon.audio=0 drm_kms_helper.poll=0 quiet drm.debug=0xE
PID hash table entries: 4096 (order: 3, 32768 bytes)
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Memory: 8166704K/8386744K available (5596K kernel code, 444K rwdata, 1864K rodata, 708K init, 604K bss, 220040K reserved)
SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Hierarchical RCU implementation.
NR_IRQS:4352 nr_irqs:712 16
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x25
console [tty0] enabled
hpet clockevent registered
tsc: Fast TSC calibration using PIT
tsc: Detected 3211.119 MHz processor
Calibrating delay loop (skipped), value calculated using timer frequency.. 6424.83 BogoMIPS (lpj=10703730)
pid_max: default: 32768 minimum: 301
ACPI: Core revision 20140214
ACPI: All ACPI Tables successfully acquired
Mount-cache hash table entries: 16384 (order: 5, 131072 bytes)
Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes)
tseg: 0000000000
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 6 MCE banks
LVT offset 0 assigned for vector 0xf9
process: using AMD E400 aware idle routine
Last level iTLB entries: 4KB 512, 2MB 16, 4MB 8
Last level dTLB entries: 4KB 512, 2MB 128, 4MB 64, 1GB 0
tlb_flushall_shift: 6
Freeing SMP alternatives memory: 20K (ffffffff81922000 - ffffffff81927000)
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
smpboot: CPU0: AMD Phenom(tm) II X4 955 Processor (fam: 10, model: 04, stepping: 02)
Performance Events: AMD PMU driver.
... version:                0
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             00007fffffffffff
... fixed-purpose events:   0
... event mask:             000000000000000f
MCE: In-kernel MCE decoding enabled.
x86: Booting SMP configuration:
.... node  #0, CPUs:      #1
process: System has AMD C1E enabled
process: Switch to broadcast mode on CPU1
 #2
process: Switch to broadcast mode on CPU2
 #3
x86: Booted up 1 node, 4 CPUs
smpboot: Total of 4 processors activated (25699.32 BogoMIPS)
process: Switch to broadcast mode on CPU3
process: Switch to broadcast mode on CPU0
devtmpfs: initialized
NET: Registered protocol family 16
cpuidle: using governor ladder
cpuidle: using governor menu
node 0 link 0: io port [1000, ffffff]
TOM: 00000000e0000000 aka 3584M
Fam 10h mmconf [mem 0xe0000000-0xefffffff]
node 0 link 0: mmio [a0000, bffff]
node 0 link 0: mmio [e0000000, efffffff] ==> none
node 0 link 0: mmio [f0000000, fbcfffff]
node 0 link 0: mmio [fbd00000, fbefffff]
node 0 link 0: mmio [fbf00000, ffefffff]
TOM2: 0000000220000000 aka 8704M
bus: [bus 00-07] on node 0 link 0
bus: 00 [io  0x0000-0xffff]
bus: 00 [mem 0x000a0000-0x000bffff]
bus: 00 [mem 0xf0000000-0xffffffff]
bus: 00 [mem 0x220000000-0xfcffffffff]
ACPI: bus type PCI registered
PCI: Using configuration type 1 for base access
PCI: Using configuration type 1 for extended access
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI: Executed 3 blocks of module-level executable AML code
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig Segments MSI]
acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [bus 00-ff]
pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000dffff]
pci_bus 0000:00: root bus resource [mem 0xdff00000-0xdfffffff]
pci_bus 0000:00: root bus resource [mem 0xf0000000-0xfebfffff]
pci 0000:00:00.0: [1022:9600] type 00 class 0x060000
pci 0000:00:01.0: [1022:9602] type 01 class 0x060400
pci 0000:00:06.0: [1022:9606] type 01 class 0x060400
pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
pci 0000:00:11.0: [1002:4391] type 00 class 0x010601
pci 0000:00:11.0: reg 0x10: [io  0xc000-0xc007]
pci 0000:00:11.0: reg 0x14: [io  0xb000-0xb003]
pci 0000:00:11.0: reg 0x18: [io  0xa000-0xa007]
pci 0000:00:11.0: reg 0x1c: [io  0x9000-0x9003]
pci 0000:00:11.0: reg 0x20: [io  0x8000-0x800f]
pci 0000:00:11.0: reg 0x24: [mem 0xfbcffc00-0xfbcfffff]
pci 0000:00:12.0: [1002:4397] type 00 class 0x0c0310
pci 0000:00:12.0: reg 0x10: [mem 0xfbcfd000-0xfbcfdfff]
pci 0000:00:12.1: [1002:4398] type 00 class 0x0c0310
pci 0000:00:12.1: reg 0x10: [mem 0xfbcfe000-0xfbcfefff]
pci 0000:00:12.2: [1002:4396] type 00 class 0x0c0320
pci 0000:00:12.2: reg 0x10: [mem 0xfbcff800-0xfbcff8ff]
pci 0000:00:12.2: supports D1 D2
pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
pci 0000:00:13.0: [1002:4397] type 00 class 0x0c0310
pci 0000:00:13.0: reg 0x10: [mem 0xfbcfb000-0xfbcfbfff]
pci 0000:00:13.1: [1002:4398] type 00 class 0x0c0310
pci 0000:00:13.1: reg 0x10: [mem 0xfbcfc000-0xfbcfcfff]
pci 0000:00:13.2: [1002:4396] type 00 class 0x0c0320
pci 0000:00:13.2: reg 0x10: [mem 0xfbcff400-0xfbcff4ff]
pci 0000:00:13.2: supports D1 D2
pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
pci 0000:00:14.0: [1002:4385] type 00 class 0x0c0500
pci 0000:00:14.1: [1002:439c] type 00 class 0x01018a
pci 0000:00:14.1: reg 0x10: [io  0x0000-0x0007]
pci 0000:00:14.1: reg 0x14: [io  0x0000-0x0003]
pci 0000:00:14.1: reg 0x18: [io  0x0000-0x0007]
pci 0000:00:14.1: reg 0x1c: [io  0x0000-0x0003]
pci 0000:00:14.1: reg 0x20: [io  0xff00-0xff0f]
pci 0000:00:14.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
pci 0000:00:14.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
pci 0000:00:14.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
pci 0000:00:14.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
pci 0000:00:14.2: [1002:4383] type 00 class 0x040300
pci 0000:00:14.2: reg 0x10: [mem 0xfbcf4000-0xfbcf7fff 64bit]
pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
pci 0000:00:14.3: [1002:439d] type 00 class 0x060100
pci 0000:00:14.4: [1002:4384] type 01 class 0x060401
pci 0000:00:14.5: [1002:4399] type 00 class 0x0c0310
pci 0000:00:14.5: reg 0x10: [mem 0xfbcfa000-0xfbcfafff]
pci 0000:00:18.0: [1022:1200] type 00 class 0x060000
pci 0000:00:18.1: [1022:1201] type 00 class 0x060000
pci 0000:00:18.2: [1022:1202] type 00 class 0x060000
pci 0000:00:18.3: [1022:1203] type 00 class 0x060000
pci 0000:00:18.4: [1022:1204] type 00 class 0x060000
pci 0000:01:05.0: [1002:9614] type 00 class 0x030000
pci 0000:01:05.0: reg 0x10: [mem 0xf0000000-0xf7ffffff pref]
pci 0000:01:05.0: reg 0x14: [io  0xd000-0xd0ff]
pci 0000:01:05.0: reg 0x18: [mem 0xfbee0000-0xfbeeffff]
pci 0000:01:05.0: reg 0x24: [mem 0xfbd00000-0xfbdfffff]
pci 0000:01:05.0: supports D1 D2
pci 0000:01:05.1: [1002:960f] type 00 class 0x040300
pci 0000:01:05.1: reg 0x10: [mem 0xfbefc000-0xfbefffff]
pci 0000:01:05.1: supports D1 D2
pci 0000:00:01.0: PCI bridge to [bus 01]
pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
pci 0000:00:01.0:   bridge window [mem 0xfbd00000-0xfbefffff]
pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf7ffffff 64bit pref]
pci 0000:02:00.0: [1969:1026] type 00 class 0x020000
pci 0000:02:00.0: reg 0x10: [mem 0xfbfc0000-0xfbffffff 64bit]
pci 0000:02:00.0: reg 0x18: [io  0xec00-0xec7f]
pci 0000:02:00.0: PME# supported from D3hot D3cold
pci 0000:00:06.0: PCI bridge to [bus 02]
pci 0000:00:06.0:   bridge window [io  0xe000-0xefff]
pci 0000:00:06.0:   bridge window [mem 0xfbf00000-0xfbffffff]
pci 0000:00:14.4: PCI bridge to [bus 03] (subtractive decode)
pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0xdff00000-0xdfffffff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0xf0000000-0xfebfffff] (subtractive decode)
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Link [LNKA] (IRQs 4 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs *4 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 4 *7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 4 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 10 11 12 14 15) *0, disabled.
ACPI: Enabled 1 GPEs in block 00 to 1F
SCSI subsystem initialized
libata version 3.00 loaded.
ACPI: bus type USB registered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
EDAC MC: Ver: 3.0.0
Advanced Linux Sound Architecture Driver Initialized.
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
e820: reserve RAM buffer [mem 0xdfe90000-0xdfffffff]
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 comparators, 32-bit 14.318180 MHz counter
Switched to clocksource hpet
pnp: PnP ACPI init
ACPI: bus type PNP registered
system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:01: [dma 4]
pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:03: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:05: Plug and Play ACPI device, IDs PNP0103 (active)
system 00:06: [mem 0xfec00000-0xfec00fff] could not be reserved
system 00:06: [mem 0xfee00000-0xfee00fff] has been reserved
system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
system 00:07: [io  0x04d0-0x04d1] has been reserved
system 00:07: [io  0x040b] has been reserved
system 00:07: [io  0x04d6] has been reserved
system 00:07: [io  0x0c00-0x0c01] has been reserved
system 00:07: [io  0x0c14] has been reserved
system 00:07: [io  0x0c50-0x0c51] has been reserved
system 00:07: [io  0x0c52] has been reserved
system 00:07: [io  0x0c6c] has been reserved
system 00:07: [io  0x0c6f] has been reserved
system 00:07: [io  0x0cd0-0x0cd1] has been reserved
system 00:07: [io  0x0cd2-0x0cd3] has been reserved
system 00:07: [io  0x0cd4-0x0cd5] has been reserved
system 00:07: [io  0x0cd6-0x0cd7] has been reserved
system 00:07: [io  0x0cd8-0x0cdf] has been reserved
system 00:07: [io  0x0b00-0x0b3f] has been reserved
system 00:07: [io  0x0800-0x089f] could not be reserved
system 00:07: [io  0x0b00-0x0b0f] has been reserved
system 00:07: [io  0x0b20-0x0b3f] has been reserved
system 00:07: [io  0x0900-0x090f] has been reserved
system 00:07: [io  0x0910-0x091f] has been reserved
system 00:07: [io  0xfe00-0xfefe] has been reserved
system 00:07: [mem 0xdff00000-0xdfffffff] has been reserved
system 00:07: [mem 0xffb80000-0xffbfffff] has been reserved
system 00:07: [mem 0xfec10000-0xfec1001f] has been reserved
system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
system 00:08: [io  0x0230-0x023f] has been reserved
system 00:08: [io  0x0290-0x029f] has been reserved
system 00:08: [io  0x0f40-0x0f4f] has been reserved
system 00:08: [io  0x0a30-0x0a3f] has been reserved
system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
system 00:09: [mem 0xe0000000-0xefffffff] has been reserved
system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
system 00:0a: [mem 0x00000000-0x0009ffff] could not be reserved
system 00:0a: [mem 0x000c0000-0x000cffff] could not be reserved
system 00:0a: [mem 0x000e0000-0x000fffff] could not be reserved
system 00:0a: [mem 0x00100000-0xdfefffff] could not be reserved
system 00:0a: [mem 0xfec00000-0xffffffff] could not be reserved
system 00:0a: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp: PnP ACPI: found 11 devices
ACPI: bus type PNP unregistered
pci 0000:00:01.0: PCI bridge to [bus 01]
pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
pci 0000:00:01.0:   bridge window [mem 0xfbd00000-0xfbefffff]
pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf7ffffff 64bit pref]
pci 0000:00:06.0: PCI bridge to [bus 02]
pci 0000:00:06.0:   bridge window [io  0xe000-0xefff]
pci 0000:00:06.0:   bridge window [mem 0xfbf00000-0xfbffffff]
pci 0000:00:14.4: PCI bridge to [bus 03]
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
pci_bus 0000:00: resource 8 [mem 0xdff00000-0xdfffffff]
pci_bus 0000:00: resource 9 [mem 0xf0000000-0xfebfffff]
pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
pci_bus 0000:01: resource 1 [mem 0xfbd00000-0xfbefffff]
pci_bus 0000:01: resource 2 [mem 0xf0000000-0xf7ffffff 64bit pref]
pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
pci_bus 0000:02: resource 1 [mem 0xfbf00000-0xfbffffff]
pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:03: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:03: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:03: resource 7 [mem 0x000d0000-0x000dffff]
pci_bus 0000:03: resource 8 [mem 0xdff00000-0xdfffffff]
pci_bus 0000:03: resource 9 [mem 0xf0000000-0xfebfffff]
NET: Registered protocol family 2
TCP established hash table entries: 65536 (order: 7, 524288 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 65536 bind 65536)
TCP: reno registered
UDP hash table entries: 4096 (order: 5, 131072 bytes)
UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
NET: Registered protocol family 1
pci 0000:00:01.0: MSI quirk detected; subordinate MSI disabled
pci 0000:01:05.0: Boot video device
PCI: CLS 64 bytes, default 64
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
software IO TLB [mem 0xdbe90000-0xdfe90000] (64MB) mapped at [ffff8800dbe90000-ffff8800dfe8ffff]
kvm: Nested Virtualization enabled
kvm: Nested Paging enabled
microcode: CPU0: patch_level=0x010000c6
microcode: CPU1: patch_level=0x010000c6
microcode: CPU2: patch_level=0x010000c6
microcode: CPU3: patch_level=0x010000c6
microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
LVT offset 1 assigned for vector 0x400
IBS: LVT offset 1 assigned
perf: AMD IBS detected (0x0000001f)
futex hash table entries: 1024 (order: 4, 65536 bytes)
9p: Installing v9fs 9p2000 file system support
msgmni has been set to 15950
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered (default)
ACPI: processor limited to max C-state 1
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[drm] Initialized drm 1.1.0 20060810
[drm] radeon kernel modesetting enabled.
[drm] initializing kernel modesetting (RS780 0x1002:0x9614 0x1043:0x834D).
[drm] register mmio base: 0xFBEE0000
[drm] register mmio size: 65536
ATOM BIOS: 113
radeon 0000:01:05.0: VRAM: 128M 0x00000000C0000000 - 0x00000000C7FFFFFF (128M used)
radeon 0000:01:05.0: GTT: 512M 0x00000000A0000000 - 0x00000000BFFFFFFF
[drm] Detected VRAM RAM=128M, BAR=128M
[drm] RAM width 32bits DDR
[TTM] Zone  kernel: Available graphics memory: 4083362 kiB
[TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[TTM] Initializing pool allocator
[TTM] Initializing DMA pool allocator
[drm] radeon: 128M of VRAM memory ready
[drm] radeon: 512M of GTT memory ready.
[drm] Loading RS780 Microcode
== power state 0 ==
	ui class: none
	internal class: boot 
	caps: video 
	uvd    vclk: 0 dclk: 0
		power level 0    sclk: 50000 vddc_index: 2
		power level 1    sclk: 50000 vddc_index: 2
	status: c r b 
== power state 1 ==
	ui class: performance
	internal class: none
	caps: video 
	uvd    vclk: 0 dclk: 0
		power level 0    sclk: 50000 vddc_index: 1
		power level 1    sclk: 70000 vddc_index: 2
	status: 
== power state 2 ==
	ui class: none
	internal class: uvd 
	caps: video 
	uvd    vclk: 53300 dclk: 40000
		power level 0    sclk: 50000 vddc_index: 1
		power level 1    sclk: 50000 vddc_index: 1
	status: 
[drm] radeon: dpm initialized
[drm] GART: num cpu pages 131072, num gpu pages 131072
[drm] PCIE GART of 512M enabled (table at 0x00000000C0040000).
radeon 0000:01:05.0: WB enabled
radeon 0000:01:05.0: fence driver on ring 0 use gpu addr 0x00000000a0000c00 and cpu addr 0xffff8800db8f4c00
[drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[drm] Driver supports precise vblank timestamp query.
[drm] radeon: irq initialized.
[drm] ring test on 0 succeeded in 1 usecs
[drm] ib test on ring 0 succeeded in 0 usecs
[drm:radeon_atombios_get_tv_info] Unknown TV standard; defaulting to NTSC
[drm] Radeon Display Connectors
[drm] Connector 0:
[drm]   VGA-1
[drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
[drm]   Encoders:
[drm]     CRT1: INTERNAL_KLDSCP_DAC1
[drm] Connector 1:
[drm]   DVI-D-1
[drm]   HPD3
[drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
[drm]   Encoders:
[drm]     DFP3: INTERNAL_KLDSCP_LVTMA
[drm:radeon_atom_encoder_dpms] encoder dpms 21 to mode 3, devices 00000001, active_devices 00000000
[drm:radeon_atom_encoder_dpms] encoder dpms 31 to mode 3, devices 00000200, active_devices 00000000
switching from power state:
	ui class: none
	internal class: boot 
	caps: video 
	uvd    vclk: 0 dclk: 0
		power level 0    sclk: 50000 vddc_index: 2
		power level 1    sclk: 50000 vddc_index: 2
	status: c b 
switching to power state:
	ui class: performance
	internal class: none
	caps: video 
	uvd    vclk: 0 dclk: 0
		power level 0    sclk: 50000 vddc_index: 1
		power level 1    sclk: 70000 vddc_index: 2
	status: r 
[drm:drm_helper_probe_single_connector_modes] [CONNECTOR:18:VGA-1]
[drm:radeon_atom_dac_detect] Bios 0 scratch 200000 00000001
[drm:radeon_atombios_connected_scratch_regs] CRT1 disconnected
[drm:drm_helper_probe_single_connector_modes] [CONNECTOR:18:VGA-1] disconnected
[drm:drm_helper_probe_single_connector_modes] [CONNECTOR:20:DVI-D-1]
[drm:radeon_atombios_connected_scratch_regs] DFP3 connected
[drm:drm_edid_to_eld] ELD: no CEA Extension found
[drm:drm_helper_probe_single_connector_modes] [CONNECTOR:20:DVI-D-1] probed modes :
[drm:drm_mode_debug_printmodeline] Modeline 22:"1680x1050" 60 146250 1680 1784 1960 2240 1050 1053 1059 1089 0x48 0x6
[drm:drm_mode_debug_printmodeline] Modeline 31:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[drm:drm_mode_debug_printmodeline] Modeline 23:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
[drm:drm_mode_debug_printmodeline] Modeline 24:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[drm:drm_mode_debug_printmodeline] Modeline 25:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[drm:drm_mode_debug_printmodeline] Modeline 32:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[drm:drm_mode_debug_printmodeline] Modeline 33:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[drm:drm_mode_debug_printmodeline] Modeline 34:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[drm:drm_mode_debug_printmodeline] Modeline 35:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[drm:drm_mode_debug_printmodeline] Modeline 26:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[drm:drm_mode_debug_printmodeline] Modeline 27:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[drm:drm_mode_debug_printmodeline] Modeline 28:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[drm:drm_mode_debug_printmodeline] Modeline 29:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[drm:drm_mode_debug_printmodeline] Modeline 30:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[drm:drm_setup_crtcs] 
[drm:drm_enable_connectors] connector 18 enabled? no
[drm:drm_enable_connectors] connector 20 enabled? yes
[drm:drm_target_preferred] looking for cmdline mode on connector 20
[drm:drm_target_preferred] looking for preferred mode on connector 20
[drm:drm_target_preferred] found mode 1680x1050
[drm:drm_setup_crtcs] picking CRTCs for 8192x8192 config
[drm:drm_setup_crtcs] desired mode 1680x1050 set on crtc 14
[drm] fb mappable at 0xF0141000
[drm] vram apper at 0xF0000000
[drm] size 7299072
[drm] fb depth is 24
[drm]    pitch is 6912
fbcon: radeondrmfb (fb0) is primary device
[drm:drm_crtc_helper_set_config] 
[drm:drm_crtc_helper_set_config] [CRTC:14] [FB:37] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config] crtc has no fb, full mode set
[drm:drm_crtc_helper_set_config] modes are different, full mode set
[drm:drm_mode_debug_printmodeline] Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[drm:drm_mode_debug_printmodeline] Modeline 36:"1680x1050" 60 146250 1680 1784 1960 2240 1050 1053 1059 1089 0x48 0x6
[drm:drm_crtc_helper_set_config] encoder changed, full mode switch
[drm:drm_crtc_helper_set_config] crtc changed, full mode switch
[drm:drm_crtc_helper_set_config] [CONNECTOR:20:DVI-D-1] to [CRTC:14]
[drm:drm_crtc_helper_set_config] attempting to set mode from userspace
[drm:drm_mode_debug_printmodeline] Modeline 36:"1680x1050" 60 146250 1680 1784 1960 2240 1050 1053 1059 1089 0x48 0x6
[drm:radeon_encoder_set_active_device] setting active device to 00000200 from 00000200 00000200 for encoder 2
[drm:drm_crtc_helper_set_mode] [CRTC:14]
[drm:radeon_atom_encoder_dpms] encoder dpms 21 to mode 3, devices 00000001, active_devices 00000000
[drm:radeon_compute_pll_avivo] 146250 - 14439, pll dividers - fb: 2047.0 ref: 29, post 7
[drm:drm_crtc_helper_set_mode] [ENCODER:19:TMDS-19] set [MODE:36:1680x1050]
[drm:radeon_atom_encoder_dpms] encoder dpms 31 to mode 3, devices 00000200, active_devices 00000200
[drm:avivo_crtc_load_lut] 0
[drm:radeon_atom_encoder_dpms] encoder dpms 31 to mode 0, devices 00000200, active_devices 00000200
[drm:drm_crtc_helper_set_config] Setting connector DPMS state to on
[drm:drm_crtc_helper_set_config] 	[CONNECTOR:20:DVI-D-1] set DPMS on
[drm:radeon_atom_encoder_dpms] encoder dpms 21 to mode 3, devices 00000001, active_devices 00000000
[drm:drm_crtc_helper_set_config] 
[drm:drm_crtc_helper_set_config] [CRTC:16] [NOFB]
[drm:radeon_atom_encoder_dpms] encoder dpms 21 to mode 3, devices 00000001, active_devices 00000000
[drm:drm_crtc_helper_set_config] 
[drm:drm_crtc_helper_set_config] [CRTC:14] [FB:37] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config] [CONNECTOR:20:DVI-D-1] to [CRTC:14]
[drm:avivo_crtc_load_lut] 0
[drm:avivo_crtc_load_lut] 0
[drm:drm_crtc_helper_set_config] 
[drm:drm_crtc_helper_set_config] [CRTC:14] [FB:37] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config] [CONNECTOR:20:DVI-D-1] to [CRTC:14]
[drm:avivo_crtc_load_lut] 0
[drm:avivo_crtc_load_lut] 0
Console: switching to colour frame buffer device 131x105
[drm:drm_crtc_helper_set_config] 
[drm:drm_crtc_helper_set_config] [CRTC:14] [FB:37] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config] [CONNECTOR:20:DVI-D-1] to [CRTC:14]
[drm:avivo_crtc_load_lut] 0
[drm:avivo_crtc_load_lut] 0
radeon 0000:01:05.0: fb0: radeondrmfb frame buffer device
radeon 0000:01:05.0: registered panic notifier
[drm:radeon_acpi_init] Call to ATCS verify_interface failed: -5
[drm:radeon_atif_verify_interface] ATIF version 1
[drm] Initialized radeon 2.38.0 20080528 for 0000:01:05.0 on minor 0
loop: module loaded
ahci 0000:00:11.0: version 3.0
ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcffd00 irq 22
ata2: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcffd80 irq 22
ata3: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcffe00 irq 22
ata4: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcffe80 irq 22
ata5: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcfff00 irq 22
ata6: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcfff80 irq 22
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci-pci: EHCI PCI platform driver
QUIRK: Enable AMD PLL fix
ehci-pci 0000:00:12.2: EHCI Host Controller
ehci-pci 0000:00:12.2: new USB bus registered, assigned bus number 1
ehci-pci 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
ehci-pci 0000:00:12.2: applying AMD SB600/SB700 USB freeze workaround
ehci-pci 0000:00:12.2: debug port 1
ehci-pci 0000:00:12.2: irq 17, io mem 0xfbcff800
ehci-pci 0000:00:12.2: USB 2.0 started, EHCI 1.00
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
ehci-pci 0000:00:13.2: EHCI Host Controller
ehci-pci 0000:00:13.2: new USB bus registered, assigned bus number 2
ehci-pci 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
ehci-pci 0000:00:13.2: applying AMD SB600/SB700 USB freeze workaround
ehci-pci 0000:00:13.2: debug port 1
ehci-pci 0000:00:13.2: irq 19, io mem 0xfbcff400
ehci-pci 0000:00:13.2: USB 2.0 started, EHCI 1.00
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci-pci: OHCI PCI platform driver
ohci-pci 0000:00:12.0: OHCI PCI host controller
ohci-pci 0000:00:12.0: new USB bus registered, assigned bus number 3
ohci-pci 0000:00:12.0: irq 16, io mem 0xfbcfd000
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 3 ports detected
ohci-pci 0000:00:12.1: OHCI PCI host controller
ohci-pci 0000:00:12.1: new USB bus registered, assigned bus number 4
ohci-pci 0000:00:12.1: irq 16, io mem 0xfbcfe000
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 3 ports detected
ohci-pci 0000:00:13.0: OHCI PCI host controller
ohci-pci 0000:00:13.0: new USB bus registered, assigned bus number 5
ohci-pci 0000:00:13.0: irq 18, io mem 0xfbcfb000
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 3 ports detected
ohci-pci 0000:00:13.1: OHCI PCI host controller
ohci-pci 0000:00:13.1: new USB bus registered, assigned bus number 6
ohci-pci 0000:00:13.1: irq 18, io mem 0xfbcfc000
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 3 ports detected
ohci-pci 0000:00:14.5: OHCI PCI host controller
ohci-pci 0000:00:14.5: new USB bus registered, assigned bus number 7
ohci-pci 0000:00:14.5: irq 18, io mem 0xfbcfa000
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: ATA-8: OCZ VERTEX-TURBO, 1.7, max UDMA/133
ata3.00: 62533296 sectors, multi 1: LBA48 NCQ (depth 31/32), AA
ata2.00: ATA-9: ST2000DM001-1CH164, CC29, max UDMA/133
ata2.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
ata2.00: configured for UDMA/133
ata3.00: configured for UDMA/133
ata4: SATA link down (SStatus 0 SControl 300)
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata6: SATA link down (SStatus 0 SControl 300)
ata1: SATA link down (SStatus 0 SControl 300)
scsi 1:0:0:0: Direct-Access     ATA      ST2000DM001-1CH1 CC29 PQ: 0 ANSI: 5
sd 1:0:0:0: [sda] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
sd 1:0:0:0: [sda] 4096-byte physical blocks
sd 1:0:0:0: Attached scsi generic sg0 type 0
sd 1:0:0:0: [sda] Write Protect is off
sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
scsi 2:0:0:0: Direct-Access     ATA      OCZ VERTEX-TURBO 1.7  PQ: 0 ANSI: 5
sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sdb] 62533296 512-byte logical blocks: (32.0 GB/29.8 GiB)
sd 2:0:0:0: Attached scsi generic sg1 type 0
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata5.00: ATAPI: ASUS     DRW-24F1ST   a, 1.00, max UDMA/100
 sdb: sdb1 sdb2 sdb3
ata5.00: configured for UDMA/100
sd 2:0:0:0: [sdb] Attached SCSI disk
scsi 4:0:0:0: CD-ROM            ASUS     DRW-24F1ST   a   1.00 PQ: 0 ANSI: 5
 sda: unknown partition table
sd 1:0:0:0: [sda] Attached SCSI disk
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
usbcore: registered new interface driver usblp
usbcore: registered new interface driver usb-storage
i8042: PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
rtc_cmos 00:02: RTC can wake from S4
rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
rtc_cmos 00:02: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
i2c /dev entries driver
AMD64 EDAC driver v3.4.0
EDAC amd64: DRAM ECC enabled.
EDAC amd64: F10h detected (node 0).
EDAC MC: DCT0 chip selects:
EDAC amd64: MC: 0:  1024MB 1:  1024MB
EDAC amd64: MC: 2:  1024MB 3:  1024MB
EDAC amd64: MC: 4:     0MB 5:     0MB
EDAC amd64: MC: 6:     0MB 7:     0MB
EDAC MC: DCT1 chip selects:
EDAC amd64: MC: 0:  1024MB 1:  1024MB
EDAC amd64: MC: 2:  1024MB 3:  1024MB
EDAC amd64: MC: 4:     0MB 5:     0MB
EDAC amd64: MC: 6:     0MB 7:     0MB
EDAC amd64: using x4 syndromes.
EDAC amd64: MCT channel count: 2
EDAC amd64: CS0: Unbuffered DDR3 RAM
EDAC amd64: CS1: Unbuffered DDR3 RAM
EDAC amd64: CS2: Unbuffered DDR3 RAM
EDAC amd64: CS3: Unbuffered DDR3 RAM
EDAC MC0: Giving out device to module amd64_edac controller F10h: DEV 0000:00:18.2 (INTERRUPT)
EDAC PCI0: Giving out device to module amd64_edac controller EDAC PCI controller: DEV 0000:00:18.2 (POLLED)
hidraw: raw HID events driver (C) Jiri Kosina
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
usbcore: registered new interface driver snd-usb-audio
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ctnetlink v0.93: registering with nfnetlink.
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP: cubic registered
NET: Registered protocol family 17
9pnet: Installing 9P2000 support
registered taskstats version 1
rtc_cmos 00:02: setting system clock to 2014-04-20 09:44:51 UTC (1397987091)
acpi-cpufreq: overriding BIOS provided _PSD data
ALSA device list:
  No soundcards found.
sound hdaudioC1D0: autoconfig: line_outs=0 (0x0/0x0/0x0/0x0/0x0) type:line
sound hdaudioC1D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
sound hdaudioC1D0:    hp_outs=0 (0x0/0x0/0x0/0x0/0x0)
sound hdaudioC1D0:    mono: mono_out=0x0
sound hdaudioC1D0:    dig-out=0x3/0x0
sound hdaudioC1D0:    inputs:
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
cdrom: Uniform CD-ROM driver Revision: 3.20
sr 4:0:0:0: Attached scsi CD-ROM sr0
sr 4:0:0:0: Attached scsi generic sg2 type 5
sound hdaudioC0D0: autoconfig: line_outs=4 (0x1c/0x19/0x22/0x23/0x0) type:line
sound hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
sound hdaudioC0D0:    hp_outs=1 (0x1d/0x0/0x0/0x0/0x0)
sound hdaudioC0D0:    mono: mono_out=0x0
sound hdaudioC0D0:    dig-out=0x20/0x21
sound hdaudioC0D0:    inputs:
sound hdaudioC0D0:      Rear Mic=0x1a
sound hdaudioC0D0:      Front Mic=0x1e
sound hdaudioC0D0:      Line=0x1b
sound hdaudioC0D0:      CD=0x1f
EXT4-fs (sdb3): mounted filesystem with ordered data mode. Opts: (null)
VFS: Mounted root (ext4 filesystem) readonly on device 8:19.
devtmpfs: mounted
Freeing unused kernel memory: 708K (ffffffff81871000 - ffffffff81922000)
Write protecting the kernel read-only data: 8192k
Freeing unused kernel memory: 540K (ffff880001579000 - ffff880001600000)
Freeing unused kernel memory: 184K (ffff8800017d2000 - ffff880001800000)
tsc: Refined TSC clocksource calibration: 3210.828 MHz
usb 4-2: new full-speed USB device number 2 using ohci-pci
EXT4-fs (sda): mounted filesystem with ordered data mode. Opts: (null)
udevd[94]: starting eudev version 1.0
logitech-djreceiver 0003:046D:C52B.0003: hiddev0,hidraw0: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:12.1-2/input2
random: nonblocking pool is initialized
input: Logitech Unifying Device. Wireless PID:4026 as /devices/pci0000:00/0000:00:12.1/usb4/4-2/4-2:1.2/0003:046D:C52B.0003/0003:046D:C52B.0004/input/input2
logitech-djdevice 0003:046D:C52B.0004: input,hidraw1: USB HID v1.11 Keyboard [Logitech Unifying Device. Wireless PID:4026] on usb-0000:00:12.1-2:1
usb 3-1: new low-speed USB device number 2 using ohci-pci
input: HID 046a:0011 as /devices/pci0000:00/0000:00:12.0/usb3/3-1/3-1:1.0/0003:046A:0011.0005/input/input3
hid-generic 0003:046A:0011.0005: input,hidraw2: USB HID v1.10 Keyboard [HID 046a:0011] on usb-0000:00:12.0-1/input0
Switched to clocksource tsc
ATL1E 0000:02:00.0 eth0: NIC Link is Up <1000 Mbps Full Duplex>
EXT4-fs (sdb3): re-mounted. Opts: (null)
microcode: CPU0: new patch_level=0x010000db
microcode: CPU1: new patch_level=0x010000db
microcode: CPU2: new patch_level=0x010000db
microcode: CPU3: new patch_level=0x010000db
Adding 3071996k swap on /var/cache/swapfile.img.  Priority:-1 extents:3 across:3555324k 

--Nq2Wo0NMKNjxTN9z--
