Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab3IIKIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 06:08:17 -0400
Received: from mailout08.t-online.de ([194.25.134.20]:43093 "EHLO
	mailout08.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab3IIKIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 06:08:13 -0400
Message-ID: <522D9DF9.7020901@t-online.de>
Date: Mon, 09 Sep 2013 12:07:53 +0200
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Daniel Vetter <daniel@ffwll.ch>
CC: intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Intel-gfx] [BUG kernel 3.11+] i915: pipe state doesn't match
References: <522A5008.6060005@t-online.de> <CAKMK7uHAMr_qzismVMB8m3za8UwogMVknPcj7LsZFuC7L8GnrQ@mail.gmail.com>
In-Reply-To: <CAKMK7uHAMr_qzismVMB8m3za8UwogMVknPcj7LsZFuC7L8GnrQ@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------060306050801040109040806"
X-ID: Zq2SJZZl8hHoPfyiwZYq25LmqFyfd+qpJczbknf6UHGMJ9UY5IqffdydY1d9ZedQmF
X-TOI-MSGID: 549f2263-e7c4-463f-87c7-bbbdd0b0cae0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060306050801040109040806
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 07.09.2013 18:54, Daniel Vetter wrote:
> On Fri, Sep 6, 2013 at 11:58 PM, Knut Petersen
> <Knut_Petersen@t-online.de> wrote:
>> Someone might be interested ... kernel
>> 2e032852245b3dcfe5461d7353e34eb6da095ccf.
>>
>> [    0.000000] Linux version 3.11.0-main+ (knut@linux-ktth.site) (gcc
>> version 4.7.2 20130108 [gcc-4_7-branch revision 195012] (SUSE Linux) ) #34
>> PREEMPT Fri Sep 6 09:46:35 CEST 2013
>
> http://cgit.freedesktop.org/~danvet/drm-intel/commit/?id=4c6df4b4ca1b26f4532d403b544f649a1c801fd1

That does not help, so dmesg attached
> could be of interest for you. If that doesn't help please boot with
> drm.debug=0xe and attach the complete dmesg.
>
> Thanks, Daniel


--------------060306050801040109040806
Content-Type: text/plain; charset=UTF-8;
 name="dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg"

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.11.0-main+ (knut@linux-ktth.site) (gcc version 4.7.2 20130108 [gcc-4_7-branch revision 195012] (SUSE Linux) ) #67 PREEMPT Mon Sep 9 11:03:35 CEST 2013
[    0.000000] Disabled fast string operations
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009f7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007f7effff] usable
[    0.000000] BIOS-e820: [mem 0x000000007f7f0000-0x000000007f7f2fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007f7f3000-0x000000007f7fffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffb00000-0x00000000ffffffff] reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.3 present.
[    0.000000] DMI:    /i915GMm-HFS, BIOS 6.00 PG 11/04/2005
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x7f7f0 max_arch_pfn = 0x1000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-F7FFF uncachable
[    0.000000]   F8000-FBFFF write-through
[    0.000000]   FC000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 07F800000 mask FFF800000 uncachable
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] initial memory mapped: [mem 0x00000000-0x011fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x37800000-0x379fffff]
[    0.000000]  [mem 0x37800000-0x379fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x34000000-0x377fffff]
[    0.000000]  [mem 0x34000000-0x377fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x33ffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x33ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x37a00000-0x37bfdfff]
[    0.000000]  [mem 0x37a00000-0x37bfdfff] page 4k
[    0.000000] BRK [0x00db6000, 0x00db6fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x37bf2000-0x37feffff]
[    0.000000] Allocated new RAMDISK: [mem 0x377f4000-0x37bf1155]
[    0.000000] Move RAMDISK from [mem 0x37bf2000-0x37fef155] to [mem 0x377f4000-0x37bf1155]
[    0.000000] ACPI: RSDP 000f9320 00014 (v00 AOpen )
[    0.000000] ACPI: RSDT 7f7f3040 00038 (v01 AOpen  AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: FACP 7f7f30c0 00074 (v01 AOpen  AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: DSDT 7f7f3180 042E3 (v01 AOPEN  AWRDACPI 00001000 MSFT 0100000E)
[    0.000000] ACPI: FACS 7f7f0000 00040
[    0.000000] ACPI: MCFG 7f7f7580 0003C (v01 AOpen  AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: APIC 7f7f74c0 0005A (v01 AOpen  AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: SSDT 7f7f7600 001E0 (v01  PmRef  Cpu0Ist 00003000 INTL 20040311)
[    0.000000] ACPI: SSDT 7f7f7a00 000E0 (v01  PmRef    CpuPm 00003000 INTL 20040311)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 1147MB HIGHMEM available.
[    0.000000] 891MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 37bfe000
[    0.000000]   low ram: 0 - 37bfe000
[    0.000000] BRK [0x00db7000, 0x00db7fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x37bfdfff]
[    0.000000]   HighMem  [mem 0x37bfe000-0x7f7effff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x7f7effff]
[    0.000000] On node 0 totalpages: 522126
[    0.000000] free_area_init_node: node 0, pgdat c07c9a28, node_mem_map f6804020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 1752 pages used for memmap
[    0.000000]   Normal zone: 224254 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2296 pages used for memmap
[    0.000000]   HighMem zone: 293874 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x7f800000-0xdfffffff] available for PCI devices
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 520342
[    0.000000] Kernel command line: root=/dev/hda2 acpi_enforce_resources=lax sky2.legacy_pme=1 splash=verbose quiet edd=off 3 resume=/dev/hda1 drm.debug=0xe
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00037bfe:0007f7f0)
[    0.000000] Memory: 2054036K/2088504K available (4387K kernel code, 387K rwdata, 2204K rodata, 488K init, 5500K bss, 34468K reserved, 1175496K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffa2000 - 0xfffff000   ( 372 kB)
[    0.000000]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
[    0.000000]     vmalloc : 0xf83fe000 - 0xffbfe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf7bfe000   ( 891 MB)
[    0.000000]       .init : 0xc07d3000 - 0xc084d000   ( 488 kB)
[    0.000000]       .data : 0xc05492f2 - 0xc07d2fc0   (2599 kB)
[    0.000000]       .text : 0xc0100000 - 0xc05492f2   (4388 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:2304 nr_irqs:256 16
[    0.000000] CPU 0 irqstacks, hard=f6008000 soft=f600a000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3567 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 1200.008 MHz processor
[    0.008003] Calibrating delay loop (skipped), value calculated using timer frequency.. 2400.01 BogoMIPS (lpj=4800032)
[    0.008014] pid_max: default: 32768 minimum: 301
[    0.008121] Security Framework initialized
[    0.008143] AppArmor: AppArmor initialized
[    0.008182] Mount-cache hash table entries: 512
[    0.012161] Disabled fast string operations
[    0.012176] mce: CPU supports 5 MCE banks
[    0.012193] CPU0: Thermal monitoring enabled (TM1)
[    0.012218] Last level iTLB entries: 4KB 128, 2MB 0, 4MB 2
[    0.012218] Last level dTLB entries: 4KB 128, 2MB 0, 4MB 8
[    0.012218] tlb_flushall_shift: 6
[    0.012225] CPU: Intel(R) Pentium(R) M processor 1.20GHz (fam: 06, model: 0d, stepping: 08)
[    0.012303] ACPI: Core revision 20130725
[    0.026191] ACPI: All ACPI Tables successfully acquired
[    0.028026] ftrace: allocating 22198 entries in 44 pages
[    0.044908] Performance Events: p6 PMU driver.
[    0.044946] ... version:                0
[    0.044951] ... bit width:              32
[    0.044956] ... generic registers:      2
[    0.044961] ... value mask:             00000000ffffffff
[    0.044965] ... max period:             000000007fffffff
[    0.044970] ... fixed-purpose events:   0
[    0.044974] ... event mask:             0000000000000003
[    0.046650] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.047289] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.052227] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.092000] devtmpfs: initialized
[    0.092000] PM: Registering ACPI NVS region [mem 0x7f7f0000-0x7f7f2fff] (12288 bytes)
[    0.092000] NET: Registered protocol family 16
[    0.093181] cpuidle: using governor ladder
[    0.093188] cpuidle: using governor menu
[    0.093468] ACPI: bus type PCI registered
[    0.093808] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.093817] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.093822] PCI: Using MMCONFIG for extended config space
[    0.093827] PCI: Using configuration type 1 for base access
[    0.101382] bio: create slab <bio-0> at 0
[    0.101785] ACPI: Added _OSI(Module Device)
[    0.101793] ACPI: Added _OSI(Processor Device)
[    0.101799] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.101806] ACPI: Added _OSI(Processor Aggregator Device)
[    0.108224] ACPI: EC: Look up EC in DSDT
[    0.128345] ACPI: Interpreter enabled
[    0.128383] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130725/hwxface-571)
[    0.128494] ACPI: (supports S0 S1 S3 S4 S5)
[    0.128500] ACPI: Using IOAPIC for interrupt routing
[    0.128615] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.161075] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.161098] acpi PNP0A08:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.161106] acpi PNP0A08:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.161607] acpi PNP0A08:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.161616] acpi PNP0A08:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.161624] acpi PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.161631] acpi PNP0A08:00: host bridge window [mem 0x000c0000-0x000dffff] (ignored)
[    0.161639] acpi PNP0A08:00: host bridge window [mem 0x7f800000-0xfebfffff] (ignored)
[    0.161647] PCI: root bus 00: using default resources
[    0.161656] acpi PNP0A08:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.162026] PCI host bridge to bus 0000:00
[    0.162059] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.162068] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.162075] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffff]
[    0.162241] pci 0000:00:00.0: [8086:2590] type 00 class 0x060000
[    0.163040] pci 0000:00:02.0: [8086:2592] type 00 class 0x030000
[    0.163073] pci 0000:00:02.0: reg 0x10: [mem 0xd2280000-0xd22fffff]
[    0.163092] pci 0000:00:02.0: reg 0x14: [io  0xe000-0xe007]
[    0.163111] pci 0000:00:02.0: reg 0x18: [mem 0xc0000000-0xcfffffff pref]
[    0.163130] pci 0000:00:02.0: reg 0x1c: [mem 0xd2300000-0xd233ffff]
[    0.163636] pci 0000:00:02.1: [8086:2792] type 00 class 0x038000
[    0.163664] pci 0000:00:02.1: reg 0x10: [mem 0xd2200000-0xd227ffff]
[    0.164304] pci 0000:00:1b.0: [8086:2668] type 00 class 0x040300
[    0.164348] pci 0000:00:1b.0: reg 0x10: [mem 0xd2340000-0xd2343fff 64bit]
[    0.164535] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.165047] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.165422] pci 0000:00:1c.0: [8086:2660] type 01 class 0x060400
[    0.165604] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.165952] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.166135] pci 0000:00:1c.1: [8086:2662] type 01 class 0x060400
[    0.166329] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.166678] pci 0000:00:1c.1: System wakeup disabled by ACPI
[    0.166863] pci 0000:00:1c.2: [8086:2664] type 01 class 0x060400
[    0.167058] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.167407] pci 0000:00:1c.2: System wakeup disabled by ACPI
[    0.167612] pci 0000:00:1c.3: [8086:2666] type 01 class 0x060400
[    0.167792] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.168153] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    0.168337] pci 0000:00:1d.0: [8086:2658] type 00 class 0x0c0300
[    0.168439] pci 0000:00:1d.0: reg 0x20: [io  0xe100-0xe11f]
[    0.168818] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.168987] pci 0000:00:1d.1: [8086:2659] type 00 class 0x0c0300
[    0.169089] pci 0000:00:1d.1: reg 0x20: [io  0xe200-0xe21f]
[    0.169468] pci 0000:00:1d.1: System wakeup disabled by ACPI
[    0.169641] pci 0000:00:1d.2: [8086:265a] type 00 class 0x0c0300
[    0.169742] pci 0000:00:1d.2: reg 0x20: [io  0xe300-0xe31f]
[    0.170124] pci 0000:00:1d.2: System wakeup disabled by ACPI
[    0.170292] pci 0000:00:1d.3: [8086:265b] type 00 class 0x0c0300
[    0.170393] pci 0000:00:1d.3: reg 0x20: [io  0xe400-0xe41f]
[    0.170772] pci 0000:00:1d.3: System wakeup disabled by ACPI
[    0.170957] pci 0000:00:1d.7: [8086:265c] type 00 class 0x0c0320
[    0.170997] pci 0000:00:1d.7: reg 0x10: [mem 0xd2344000-0xd23443ff]
[    0.171168] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.171503] pci 0000:00:1d.7: System wakeup disabled by ACPI
[    0.171681] pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
[    0.172153] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    0.172328] pci 0000:00:1f.0: [8086:2641] type 00 class 0x060100
[    0.172539] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.172557] pci 0000:00:1f.0: quirk: [io  0x4000-0x407f] claimed by ICH6 ACPI/GPIO/TCO
[    0.172572] pci 0000:00:1f.0: quirk: [io  0x4080-0x40bf] claimed by ICH6 GPIO
[    0.172582] pci 0000:00:1f.0: LPC Generic IO decode 1 PIO at 0280-02ff
[    0.172592] pci 0000:00:1f.0: LPC Generic IO decode 2 PIO at 1640-164f
[    0.173039] pci 0000:00:1f.1: [8086:266f] type 00 class 0x01018a
[    0.173072] pci 0000:00:1f.1: reg 0x10: [io  0x0000-0x0007]
[    0.173097] pci 0000:00:1f.1: reg 0x14: [io  0x0000-0x0003]
[    0.173121] pci 0000:00:1f.1: reg 0x18: [io  0x0000-0x0007]
[    0.173145] pci 0000:00:1f.1: reg 0x1c: [io  0x0000-0x0003]
[    0.173170] pci 0000:00:1f.1: reg 0x20: [io  0xf000-0xf00f]
[    0.173672] pci 0000:00:1f.2: [8086:2653] type 00 class 0x01018f
[    0.173712] pci 0000:00:1f.2: reg 0x10: [io  0xe500-0xe507]
[    0.173736] pci 0000:00:1f.2: reg 0x14: [io  0xe600-0xe603]
[    0.173761] pci 0000:00:1f.2: reg 0x18: [io  0xe700-0xe707]
[    0.173785] pci 0000:00:1f.2: reg 0x1c: [io  0xe800-0xe803]
[    0.173809] pci 0000:00:1f.2: reg 0x20: [io  0xe900-0xe90f]
[    0.173834] pci 0000:00:1f.2: reg 0x24: [mem 0xd2345000-0xd23453ff]
[    0.173921] pci 0000:00:1f.2: PME# supported from D3hot
[    0.174395] pci 0000:00:1f.3: [8086:266a] type 00 class 0x0c0500
[    0.174513] pci 0000:00:1f.3: reg 0x20: [io  0x5000-0x501f]
[    0.175187] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.175206] pci 0000:00:1c.0:   bridge window [mem 0x00000000-0x000fffff]
[    0.175223] pci 0000:00:1c.0:   bridge window [mem 0x00000000-0x000fffff 64bit pref]
[    0.175471] pci 0000:02:00.0: [11ab:4362] type 00 class 0x020000
[    0.175530] pci 0000:02:00.0: reg 0x10: [mem 0xd2120000-0xd2123fff 64bit]
[    0.175562] pci 0000:02:00.0: reg 0x18: [io  0xc000-0xc0ff]
[    0.175668] pci 0000:02:00.0: reg 0x30: [mem 0x00000000-0x0001ffff pref]
[    0.175836] pci 0000:02:00.0: supports D1 D2
[    0.175843] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.176044] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.176265] pci 0000:00:1c.1: PCI bridge to [bus 02]
[    0.176277] pci 0000:00:1c.1:   bridge window [io  0xc000-0xcfff]
[    0.176289] pci 0000:00:1c.1:   bridge window [mem 0xd2100000-0xd21fffff]
[    0.176540] pci 0000:03:00.0: [11ab:4362] type 00 class 0x020000
[    0.176599] pci 0000:03:00.0: reg 0x10: [mem 0xd2020000-0xd2023fff 64bit]
[    0.176631] pci 0000:03:00.0: reg 0x18: [io  0xd000-0xd0ff]
[    0.176737] pci 0000:03:00.0: reg 0x30: [mem 0x00000000-0x0001ffff pref]
[    0.176904] pci 0000:03:00.0: supports D1 D2
[    0.176911] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.177103] pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.177130] pci 0000:00:1c.2: PCI bridge to [bus 03]
[    0.177143] pci 0000:00:1c.2:   bridge window [io  0xd000-0xdfff]
[    0.177155] pci 0000:00:1c.2:   bridge window [mem 0xd2000000-0xd20fffff]
[    0.177358] pci 0000:00:1c.3: PCI bridge to [bus 04]
[    0.177375] pci 0000:00:1c.3:   bridge window [mem 0x00000000-0x000fffff]
[    0.177393] pci 0000:00:1c.3:   bridge window [mem 0x00000000-0x000fffff 64bit pref]
[    0.177572] pci 0000:05:03.0: [11c1:5811] type 00 class 0x0c0010
[    0.177614] pci 0000:05:03.0: reg 0x10: [mem 0xd1000000-0xd1000fff]
[    0.177800] pci 0000:05:03.0: supports D1 D2
[    0.177806] pci 0000:05:03.0: PME# supported from D0 D1 D2 D3hot
[    0.178003] pci 0000:05:04.0: [10ee:3fc3] type 00 class 0x040100
[    0.178039] pci 0000:05:04.0: reg 0x10: [mem 0xd0000000-0xd0ffffff]
[    0.178398] pci 0000:00:1e.0: PCI bridge to [bus 05] (subtractive decode)
[    0.178415] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xd1ffffff]
[    0.178433] pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
[    0.178441] pci 0000:00:1e.0:   bridge window [mem 0x00000000-0xffffffff] (subtractive decode)
[    0.178539] pci_bus 0000:00: on NUMA node 0
[    0.182219] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 7 9 10 11 12 14 15)
[    0.182612] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 *10 11 12 14 15)
[    0.183003] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 11 *12 14 15)
[    0.183393] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12 14 15)
[    0.183783] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 *9 10 11 12 14 15)
[    0.184184] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.184576] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.184971] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 9 10 *11 12 14 15)
[    0.186244] ACPI: \_SB_.PCI0: notify handler is installed
[    0.186508] Found 1 acpi root devices
[    0.187578] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.187608] vgaarb: loaded
[    0.187612] vgaarb: bridge control possible 0000:00:02.0
[    0.187921] SCSI subsystem initialized
[    0.188128] libata version 3.00 loaded.
[    0.188156] ACPI: bus type USB registered
[    0.188246] usbcore: registered new interface driver usbfs
[    0.188291] usbcore: registered new interface driver hub
[    0.188376] usbcore: registered new device driver usb
[    0.188498] PCI: Using ACPI for IRQ routing
[    0.203379] PCI: pci_cache_line_size set to 64 bytes
[    0.203531] e820: reserve RAM buffer [mem 0x0009f800-0x0009ffff]
[    0.203555] e820: reserve RAM buffer [mem 0x7f7f0000-0x7fffffff]
[    0.205302] hpet clockevent registered
[    0.205311] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.205321] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.205335] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.207764] Switched to clocksource hpet
[    0.232765] AppArmor: AppArmor Filesystem Enabled
[    0.232850] pnp: PnP ACPI init
[    0.232949] ACPI: bus type PNP registered
[    0.233721] system 00:00: [io  0x0b78-0x0b7b] has been reserved
[    0.233733] system 00:00: [io  0x0f78-0x0f7b] has been reserved
[    0.233743] system 00:00: [io  0x0a78-0x0a7b] has been reserved
[    0.233752] system 00:00: [io  0x0e78-0x0e7b] has been reserved
[    0.233762] system 00:00: [io  0x0bbc-0x0bbf] has been reserved
[    0.233771] system 00:00: [io  0x0fbc-0x0fbf] has been reserved
[    0.233781] system 00:00: [io  0x04d0-0x04d1] has been reserved
[    0.233790] system 00:00: [io  0x0290-0x0297] has been reserved
[    0.233799] system 00:00: [io  0x0880-0x088f] has been reserved
[    0.234040] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.234104] pnp 00:01: [dma 4]
[    0.234209] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.234392] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.234529] pnp 00:03: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.234678] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.235812] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.236747] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.238135] pnp 00:07: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.238802] system 00:08: [io  0x4000-0x40bf] could not be reserved
[    0.238817] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.239008] pnp 00:09: Plug and Play ACPI device, IDs INT0800 (active)
[    0.240263] system 00:0a: [mem 0xe0000000-0xefffffff] has been reserved
[    0.240279] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.241207] system 00:0b: [mem 0x000d0000-0x000d3fff] has been reserved
[    0.241218] system 00:0b: [mem 0x000db800-0x000dbfff] has been reserved
[    0.241264] system 00:0b: [mem 0x000f0000-0x000fbfff] could not be reserved
[    0.241275] system 00:0b: [mem 0x000fc000-0x000fffff] could not be reserved
[    0.241285] system 00:0b: [mem 0x7f7f0000-0x7f7fffff] could not be reserved
[    0.241295] system 00:0b: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.241306] system 00:0b: [mem 0x00100000-0x7f7effff] could not be reserved
[    0.241316] system 00:0b: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.241326] system 00:0b: [mem 0xfed13000-0xfed1dfff] has been reserved
[    0.241336] system 00:0b: [mem 0xfed20000-0xfed8ffff] has been reserved
[    0.241345] system 00:0b: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.241355] system 00:0b: [mem 0xffb00000-0xffb7ffff] has been reserved
[    0.241365] system 00:0b: [mem 0xfff00000-0xffffffff] has been reserved
[    0.241374] system 00:0b: [mem 0x000e0000-0x000effff] has been reserved
[    0.241388] system 00:0b: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.241428] pnp: PnP ACPI: found 12 devices
[    0.241434] ACPI: bus type PNP unregistered
[    0.284737] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus 01] add_size 1000
[    0.284751] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 01] add_size 200000
[    0.284760] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff] to [bus 01] add_size 200000
[    0.284788] pci 0000:00:1c.1: bridge window [mem 0x00100000-0x001fffff pref] to [bus 02] add_size 200000
[    0.284813] pci 0000:00:1c.2: bridge window [mem 0x00100000-0x001fffff pref] to [bus 03] add_size 200000
[    0.284836] pci 0000:00:1c.3: bridge window [io  0x1000-0x0fff] to [bus 04] add_size 1000
[    0.284846] pci 0000:00:1c.3: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 04] add_size 200000
[    0.284855] pci 0000:00:1c.3: bridge window [mem 0x00100000-0x000fffff] to [bus 04] add_size 200000
[    0.284896] pci 0000:00:1c.0: res[8]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[    0.284904] pci 0000:00:1c.0: res[9]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.284913] pci 0000:00:1c.1: res[9]=[mem 0x00100000-0x001fffff pref] get_res_add_size add_size 200000
[    0.284921] pci 0000:00:1c.2: res[9]=[mem 0x00100000-0x001fffff pref] get_res_add_size add_size 200000
[    0.284929] pci 0000:00:1c.3: res[8]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[    0.284938] pci 0000:00:1c.3: res[9]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.284946] pci 0000:00:1c.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.284954] pci 0000:00:1c.3: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.284970] pci 0000:00:1c.0: BAR 8: assigned [mem 0x80000000-0x801fffff]
[    0.284981] pci 0000:00:1c.0: BAR 9: assigned [mem 0x80200000-0x803fffff 64bit pref]
[    0.284992] pci 0000:00:1c.1: BAR 9: assigned [mem 0x80400000-0x806fffff pref]
[    0.285002] pci 0000:00:1c.2: BAR 9: assigned [mem 0x80700000-0x809fffff pref]
[    0.285012] pci 0000:00:1c.3: BAR 8: assigned [mem 0x80a00000-0x80bfffff]
[    0.285023] pci 0000:00:1c.3: BAR 9: assigned [mem 0x80c00000-0x80dfffff 64bit pref]
[    0.285035] pci 0000:00:1c.0: BAR 7: assigned [io  0x1000-0x1fff]
[    0.285046] pci 0000:00:1c.3: BAR 7: assigned [io  0x2000-0x2fff]
[    0.285061] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.285072] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    0.285087] pci 0000:00:1c.0:   bridge window [mem 0x80000000-0x801fffff]
[    0.285099] pci 0000:00:1c.0:   bridge window [mem 0x80200000-0x803fffff 64bit pref]
[    0.285119] pci 0000:02:00.0: BAR 6: assigned [mem 0x80400000-0x8041ffff pref]
[    0.285127] pci 0000:00:1c.1: PCI bridge to [bus 02]
[    0.285136] pci 0000:00:1c.1:   bridge window [io  0xc000-0xcfff]
[    0.285151] pci 0000:00:1c.1:   bridge window [mem 0xd2100000-0xd21fffff]
[    0.285163] pci 0000:00:1c.1:   bridge window [mem 0x80400000-0x806fffff pref]
[    0.285182] pci 0000:03:00.0: BAR 6: assigned [mem 0x80700000-0x8071ffff pref]
[    0.285189] pci 0000:00:1c.2: PCI bridge to [bus 03]
[    0.285199] pci 0000:00:1c.2:   bridge window [io  0xd000-0xdfff]
[    0.285213] pci 0000:00:1c.2:   bridge window [mem 0xd2000000-0xd20fffff]
[    0.285226] pci 0000:00:1c.2:   bridge window [mem 0x80700000-0x809fffff pref]
[    0.285242] pci 0000:00:1c.3: PCI bridge to [bus 04]
[    0.285251] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.285266] pci 0000:00:1c.3:   bridge window [mem 0x80a00000-0x80bfffff]
[    0.285278] pci 0000:00:1c.3:   bridge window [mem 0x80c00000-0x80dfffff 64bit pref]
[    0.285295] pci 0000:00:1e.0: PCI bridge to [bus 05]
[    0.285310] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xd1ffffff]
[    0.285332] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    0.285340] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffff]
[    0.285348] pci_bus 0000:01: resource 0 [io  0x1000-0x1fff]
[    0.285355] pci_bus 0000:01: resource 1 [mem 0x80000000-0x801fffff]
[    0.285363] pci_bus 0000:01: resource 2 [mem 0x80200000-0x803fffff 64bit pref]
[    0.285370] pci_bus 0000:02: resource 0 [io  0xc000-0xcfff]
[    0.285377] pci_bus 0000:02: resource 1 [mem 0xd2100000-0xd21fffff]
[    0.285385] pci_bus 0000:02: resource 2 [mem 0x80400000-0x806fffff pref]
[    0.285392] pci_bus 0000:03: resource 0 [io  0xd000-0xdfff]
[    0.285400] pci_bus 0000:03: resource 1 [mem 0xd2000000-0xd20fffff]
[    0.285407] pci_bus 0000:03: resource 2 [mem 0x80700000-0x809fffff pref]
[    0.285414] pci_bus 0000:04: resource 0 [io  0x2000-0x2fff]
[    0.285422] pci_bus 0000:04: resource 1 [mem 0x80a00000-0x80bfffff]
[    0.285429] pci_bus 0000:04: resource 2 [mem 0x80c00000-0x80dfffff 64bit pref]
[    0.285437] pci_bus 0000:05: resource 1 [mem 0xd0000000-0xd1ffffff]
[    0.285444] pci_bus 0000:05: resource 4 [io  0x0000-0xffff]
[    0.285451] pci_bus 0000:05: resource 5 [mem 0x00000000-0xffffffff]
[    0.285566] NET: Registered protocol family 2
[    0.286631] TCP established hash table entries: 8192 (order: 4, 65536 bytes)
[    0.286798] TCP bind hash table entries: 8192 (order: 6, 294912 bytes)
[    0.288500] TCP: Hash tables configured (established 8192 bind 8192)
[    0.288638] TCP: reno registered
[    0.288651] UDP hash table entries: 512 (order: 3, 40960 bytes)
[    0.288877] UDP-Lite hash table entries: 512 (order: 3, 40960 bytes)
[    0.289571] NET: Registered protocol family 1
[    0.289614] pci 0000:00:02.0: Boot video device
[    1.892033] pci 0000:00:1d.7: EHCI: BIOS handoff failed (BIOS bug?) 01010001
[    1.892499] PCI: CLS 32 bytes, default 64
[    1.893054] Unpacking initramfs...
[    2.137971] Freeing initrd memory: 4088K (f77f4000 - f7bf2000)
[    2.138880] microcode: CPU0 sig=0x6d8, pf=0x20, revision=0x20
[    2.139155] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    2.140357] audit: initializing netlink socket (disabled)
[    2.140488] type=2000 audit(1378720858.140:1): initialized
[    2.187099] bounce pool size: 64 pages
[    2.187117] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.187393] VFS: Disk quotas dquot_6.5.2
[    2.187423] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    2.188105] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    2.188669] fuse init (API version 7.22)
[    2.188845] msgmni has been set to 1723
[    2.207130] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    2.207187] io scheduler noop registered
[    2.207192] io scheduler deadline registered
[    2.207208] io scheduler cfq registered (default)
[    2.207724] pcieport 0000:00:1c.0: enabling device (0100 -> 0103)
[    2.208567] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    2.209468] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
[    2.210139] pcieport 0000:00:1c.2: irq 42 for MSI/MSI-X
[    2.210336] pcieport 0000:00:1c.3: enabling device (0100 -> 0103)
[    2.210854] pcieport 0000:00:1c.3: irq 43 for MSI/MSI-X
[    2.211564] intel_idle: does not run on family 6 model 13
[    2.211925] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    2.212143] ACPI: Power Button [PWRB]
[    2.212398] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    2.212411] ACPI: Power Button [PWRF]
[    2.212840] ACPI: Fan [FAN] (on)
[    2.213152] ACPI: Requesting acpi_cpufreq
[    2.213757] ACPI: AOpen i915GMm-HFS detected: disabling all active thermal trip points
[    2.213764] ACPI: AOpen i915GMm-HFS detected: disabling all passive thermal trip points
[    2.213769] ACPI: AOpen i915GMm-HFS detected: enabling thermal zone polling
[    2.219137] thermal LNXTHERM:00: registered as thermal_zone0
[    2.219144] ACPI: Thermal Zone [THRM] (49 C)
[    2.219327] Serial: 8250/16550 driver, 8 ports, IRQ sharing enabled
[    2.240932] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    2.262224] 00:06: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
[    2.267741] lp: driver loaded but no devices found
[    2.268158] Non-volatile memory driver v1.3
[    2.268164] Linux agpgart interface v0.103
[    2.268339] agpgart-intel 0000:00:00.0: Intel 915GM Chipset
[    2.268505] agpgart-intel 0000:00:00.0: detected gtt size: 262144K total, 262144K mappable
[    2.269219] agpgart-intel 0000:00:00.0: detected 8192K stolen memory
[    2.269669] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
[    2.269810] [drm] Initialized drm 1.1.0 20060810
[    2.274014] [drm:i915_dump_device_info], i915 device info: gen=3, pciid=0x2592 flags=is_mobile,cursor_needs_physical,has_overlay,overlay_needs_physical,supports_tv,
[    2.274191] [drm] Memory usable by graphics device = 256M
[    2.274197] [drm:i915_gem_gtt_init], GMADR size = 256M
[    2.274204] [drm:i915_gem_gtt_init], GTT stolen size = 8M
[    2.274340] i915 0000:00:02.0: setting latency timer to 64
[    2.274478] [drm:intel_detect_pch], No PCH found?
[    2.275403] [drm:intel_opregion_setup], graphic opregion physical addr: 0x0
[    2.275411] [drm:intel_opregion_setup], ACPI OpRegion not supported!
[    2.275511] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    2.275516] [drm] Driver supports precise vblank timestamp query.
[    2.275524] [drm:init_vbt_defaults], Set default to SSC at 100MHz
[    2.276174] [drm:parse_general_features], BDB_GENERAL_FEATURES int_tv_support 1 int_crt_support 0 lvds_use_ssc 0 lvds_ssc_freq 96 display_clock_mode 0 fdi_rx_polarity_inverted 0
[    2.276186] [drm:parse_general_definitions], crt_ddc_bus_pin: 2
[    2.276230] [drm:parse_lfp_panel_data], Found panel mode in BIOS VBT tables:
[    2.276237] [drm:drm_mode_debug_printmodeline], Modeline 0:"1024x768" 0 65000 1024 1048 1184 1344 768 771 777 806 0x8 0xa
[    2.276268] [drm:parse_lfp_panel_data], VBT initial LVDS value 40000300
[    2.276296] [drm:parse_sdvo_panel_data], Found SDVO panel mode in BIOS VBT tables:
[    2.276303] [drm:drm_mode_debug_printmodeline], Modeline 0:"1024x768" 0 65000 1024 1048 1184 1344 768 771 777 806 0x8 0xa
[    2.276316] [drm:parse_sdvo_device_mapping], the SDVO device with slave addr 70 is found on SDVOB port
[    2.276325] [drm:parse_sdvo_device_mapping], SDVO device: dvo=1, addr=70, wiring=1, ddc_pin=29, i2c_pin=5
[    2.276333] [drm:parse_sdvo_device_mapping], the SDVO device with slave addr 72 is found on SDVOC port
[    2.276342] [drm:parse_sdvo_device_mapping], SDVO device: dvo=2, addr=72, wiring=0, ddc_pin=29, i2c_pin=5
[    2.276467] [drm:i915_stolen_to_physical] *ERROR* conflict detected with stolen region: [0x7f800000 - 0x80000000]
[    2.277190] [drm:intel_modeset_init], 2 display pipes available.
[    2.277325] [drm:intel_crtc_init], swapping pipes & planes for FBC
[    2.277332] [drm:intel_modeset_init], pipe A sprite A init failed: -19
[    2.277382] [drm:intel_crtc_init], swapping pipes & planes for FBC
[    2.277389] [drm:intel_modeset_init], pipe B sprite B init failed: -19
[    2.277396] [drm:intel_shared_dpll_init], 0 shared PLLs initialized
[    2.277413] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    2.277780] [drm] Skipping LVDS initialization for AOpen i915GMm-HFS
[    2.278133] [drm:intel_setup_outputs], probing SDVOB
[    2.278145] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus dpb. force bit now 1
[    2.363941] [drm:intel_sdvo_debug_write], SDVOB: W: 02                         (SDVO_CMD_GET_DEVICE_CAPS)
[    2.366262] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 02 3C 06 01 01 01 01 00
[    2.378320] [drm:intel_sdvo_get_capabilities], SDVO capabilities:
[    2.378320]   vendor_id: 2
[    2.378320]   device_id: 60
[    2.378320]   device_rev_id: 6
[    2.378320]   sdvo_version_major: 1
[    2.378320]   sdvo_version_minor: 1
[    2.378320]   sdvo_inputs_mask: 1
[    2.378320]   smooth_scaling: 0
[    2.378320]   sharp_scaling: 0
[    2.378320]   up_scaling: 0
[    2.378320]   down_scaling: 0
[    2.378320]   stall_support: 0
[    2.378320]   output_flags: 1
[    2.378339] [drm:intel_sdvo_debug_write], SDVOB: W: 0C                         (SDVO_CMD_GET_HOT_PLUG_SUPPORT)
[    2.380658] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[    2.384684] [drm:intel_sdvo_debug_write], SDVOB: W: 0D 01 00                   (SDVO_CMD_SET_ACTIVE_HOT_PLUG)
[    2.388894] [drm:intel_sdvo_debug_write], SDVOB: W: 9D                         (SDVO_CMD_GET_SUPP_ENCODE)
[    2.391199] [drm:intel_sdvo_read_response], SDVOB: R: (Not supported)... failed
[    2.392695] [drm:intel_sdvo_debug_write], SDVOB: W: 10 00                      (SDVO_CMD_SET_TARGET_INPUT)
[    2.395948] [drm:intel_sdvo_read_response], SDVOB: R: (Success)
[    2.397305] [drm:intel_sdvo_debug_write], SDVOB: W: 1D                         (SDVO_CMD_GET_INPUT_PIXEL_CLOCK_RANGE)
[    2.399610] [drm:intel_sdvo_read_response], SDVOB: R: (Success) C4 09 20 4E
[    2.406319] [drm:intel_sdvo_init], SDVOB device VID/DID: 02:3C.06, clock range 25MHz - 200MHz, input 1: Y, input 2: N, output 1: Y, output 2: N
[    2.406330] [drm:intel_setup_outputs], probing SDVOC
[    2.406337] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus dpb. force bit now 2
[    2.491792] [drm:intel_sdvo_debug_write], SDVOC: W: 02                         (SDVO_CMD_GET_DEVICE_CAPS)
[    2.494112] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 02 C2 01 01 01 3D 3E 00
[    2.506172] [drm:intel_sdvo_get_capabilities], SDVO capabilities:
[    2.506172]   vendor_id: 2
[    2.506172]   device_id: 194
[    2.506172]   device_rev_id: 1
[    2.506172]   sdvo_version_major: 1
[    2.506172]   sdvo_version_minor: 1
[    2.506172]   sdvo_inputs_mask: 1
[    2.506172]   smooth_scaling: 1
[    2.506172]   sharp_scaling: 1
[    2.506172]   up_scaling: 1
[    2.506172]   down_scaling: 1
[    2.506172]   stall_support: 0
[    2.506172]   output_flags: 62
[    2.506324] [drm:intel_sdvo_debug_write], SDVOC: W: 11 08 00                   (SDVO_CMD_SET_TARGET_OUTPUT)
[    2.510541] [drm:intel_sdvo_read_response], SDVOC: R: (Success)
[    2.511884] [drm:intel_sdvo_debug_write], SDVOC: W: 27                         (SDVO_CMD_GET_SUPPORTED_TV_FORMATS)
[    2.514192] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FF FF FF FF FF 1F
[    2.523603] [drm:intel_sdvo_debug_write], SDVOC: W: 84                         (SDVO_CMD_GET_SUPPORTED_ENHANCEMENTS)
[    2.525920] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FA DF
[    2.529941] [drm:intel_sdvo_debug_write], SDVOC: W: 61                         (SDVO_CMD_GET_MAX_OVERSCAN_H)
[    2.532252] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 2F 00 20 00
[    2.538942] [drm:intel_sdvo_debug_write], SDVOC: W: 62                         (SDVO_CMD_GET_OVERSCAN_H)
[    2.541260] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 20 00
[    2.545291] [drm:intel_sdvo_create_enhance_property_tv], h_overscan: max 47, default 32, current 32
[    2.545300] [drm:intel_sdvo_debug_write], SDVOC: W: 64                         (SDVO_CMD_GET_MAX_OVERSCAN_V)
[    2.547604] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 2F 00 20 00
[    2.554304] [drm:intel_sdvo_debug_write], SDVOC: W: 65                         (SDVO_CMD_GET_OVERSCAN_V)
[    2.556619] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 20 00
[    2.560646] [drm:intel_sdvo_create_enhance_property_tv], v_overscan: max 47, default 32, current 32
[    2.560654] [drm:intel_sdvo_debug_write], SDVOC: W: 67                         (SDVO_CMD_GET_MAX_HPOS)
[    2.562958] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FF 03 00 02
[    2.569657] [drm:intel_sdvo_debug_write], SDVOC: W: 68                         (SDVO_CMD_GET_HPOS)
[    2.571961] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 02
[    2.575989] [drm:intel_sdvo_create_enhance_property_tv], hpos: max 1023, default 512, current 512
[    2.575998] [drm:intel_sdvo_debug_write], SDVOC: W: 6A                         (SDVO_CMD_GET_MAX_VPOS)
[    2.578317] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FF 03 00 02
[    2.585023] [drm:intel_sdvo_debug_write], SDVOC: W: 6B                         (SDVO_CMD_GET_VPOS)
[    2.587327] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 02
[    2.591354] [drm:intel_sdvo_create_enhance_property_tv], vpos: max 1023, default 512, current 512
[    2.591363] [drm:intel_sdvo_debug_write], SDVOC: W: 55                         (SDVO_CMD_GET_MAX_SATURATION)
[    2.593680] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 7F 00 45 00
[    2.600389] [drm:intel_sdvo_debug_write], SDVOC: W: 56                         (SDVO_CMD_GET_SATURATION)
[    2.602693] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 45 00
[    2.606721] [drm:intel_sdvo_create_enhance_property_tv], saturation: max 127, default 69, current 69
[    2.606730] [drm:intel_sdvo_debug_write], SDVOC: W: 5E                         (SDVO_CMD_GET_MAX_CONTRAST)
[    2.609049] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 7F 00 40 00
[    2.615740] [drm:intel_sdvo_debug_write], SDVOC: W: 5F                         (SDVO_CMD_GET_CONTRAST)
[    2.618054] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 40 00
[    2.622082] [drm:intel_sdvo_create_enhance_property_tv], contrast: max 127, default 64, current 64
[    2.622091] [drm:intel_sdvo_debug_write], SDVOC: W: 58                         (SDVO_CMD_GET_MAX_HUE)
[    2.624405] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 7F 00 40 00
[    2.631099] [drm:intel_sdvo_debug_write], SDVOC: W: 59                         (SDVO_CMD_GET_HUE)
[    2.633414] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 40 00
[    2.637442] [drm:intel_sdvo_create_enhance_property_tv], hue: max 127, default 64, current 64
[    2.637450] [drm:intel_sdvo_debug_write], SDVOC: W: 6D                         (SDVO_CMD_GET_MAX_SHARPNESS)
[    2.639754] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 07 00 04 00
[    2.646455] [drm:intel_sdvo_debug_write], SDVOC: W: 6E                         (SDVO_CMD_GET_SHARPNESS)
[    2.648774] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 04 00
[    2.652802] [drm:intel_sdvo_create_enhance_property_tv], sharpness: max 7, default 4, current 4
[    2.652810] [drm:intel_sdvo_debug_write], SDVOC: W: 5B                         (SDVO_CMD_GET_MAX_BRIGHTNESS)
[    2.655114] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FF 00 80 00
[    2.661824] [drm:intel_sdvo_debug_write], SDVOC: W: 5C                         (SDVO_CMD_GET_BRIGHTNESS)
[    2.664135] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 80 00
[    2.668158] [drm:intel_sdvo_create_enhance_property_tv], brightness: max 255, default 128, current 128
[    2.668167] [drm:intel_sdvo_debug_write], SDVOC: W: 7B                         (SDVO_CMD_GET_MAX_FLICKER_FILTER_ADAPTIVE)
[    2.670472] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 07 00 07 00
[    2.677171] [drm:intel_sdvo_debug_write], SDVOC: W: 50                         (SDVO_CMD_GET_FLICKER_FILTER_ADAPTIVE)
[    2.679475] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 07 00
[    2.683503] [drm:intel_sdvo_create_enhance_property_tv], flicker_filter_adaptive: max 7, default 7, current 7
[    2.683512] [drm:intel_sdvo_debug_write], SDVOC: W: 74                         (SDVO_CMD_GET_MAX_TV_CHROMA_FILTER)
[    2.685828] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 03 00 01 00
[    2.692533] [drm:intel_sdvo_debug_write], SDVOC: W: 75                         (SDVO_CMD_GET_TV_CHROMA_FILTER)
[    2.694837] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 01 00
[    2.698860] [drm:intel_sdvo_create_enhance_property_tv], tv_chroma_filter: max 3, default 1, current 1
[    2.698869] [drm:intel_sdvo_debug_write], SDVOC: W: 77                         (SDVO_CMD_GET_MAX_TV_LUMA_FILTER)
[    2.701183] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 02 00 00 00
[    2.707877] [drm:intel_sdvo_debug_write], SDVOC: W: 78                         (SDVO_CMD_GET_TV_LUMA_FILTER)
[    2.710195] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    2.714223] [drm:intel_sdvo_create_enhance_property_tv], tv_luma_filter: max 2, default 0, current 0
[    2.714232] [drm:intel_sdvo_debug_write], SDVOC: W: 70                         (SDVO_CMD_GET_DOT_CRAWL)
[    2.716550] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    2.720575] [drm:intel_sdvo_create_enhance_property_tv], dot crawl: current 0
[    2.720713] [drm:intel_sdvo_debug_write], SDVOC: W: 11 04 00                   (SDVO_CMD_SET_TARGET_OUTPUT)
[    2.724929] [drm:intel_sdvo_read_response], SDVOC: R: (Success)
[    2.726272] [drm:intel_sdvo_debug_write], SDVOC: W: 27                         (SDVO_CMD_GET_SUPPORTED_TV_FORMATS)
[    2.728586] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FF FF FF FF FF 1F
[    2.737972] [drm:intel_sdvo_debug_write], SDVOC: W: 84                         (SDVO_CMD_GET_SUPPORTED_ENHANCEMENTS)
[    2.740285] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FA DF
[    2.744306] [drm:intel_sdvo_debug_write], SDVOC: W: 61                         (SDVO_CMD_GET_MAX_OVERSCAN_H)
[    2.746611] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 2F 00 20 00
[    2.753319] [drm:intel_sdvo_debug_write], SDVOC: W: 62                         (SDVO_CMD_GET_OVERSCAN_H)
[    2.755623] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 20 00
[    2.759651] [drm:intel_sdvo_create_enhance_property_tv], h_overscan: max 47, default 32, current 32
[    2.759659] [drm:intel_sdvo_debug_write], SDVOC: W: 64                         (SDVO_CMD_GET_MAX_OVERSCAN_V)
[    2.761978] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 2F 00 20 00
[    2.768686] [drm:intel_sdvo_debug_write], SDVOC: W: 65                         (SDVO_CMD_GET_OVERSCAN_V)
[    2.770990] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 20 00
[    2.775013] [drm:intel_sdvo_create_enhance_property_tv], v_overscan: max 47, default 32, current 32
[    2.775021] [drm:intel_sdvo_debug_write], SDVOC: W: 67                         (SDVO_CMD_GET_MAX_HPOS)
[    2.777340] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FF 03 00 02
[    2.784040] [drm:intel_sdvo_debug_write], SDVOC: W: 68                         (SDVO_CMD_GET_HPOS)
[    2.786344] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 02
[    2.790372] [drm:intel_sdvo_create_enhance_property_tv], hpos: max 1023, default 512, current 512
[    2.790380] [drm:intel_sdvo_debug_write], SDVOC: W: 6A                         (SDVO_CMD_GET_MAX_VPOS)
[    2.792698] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FF 03 00 02
[    2.799390] [drm:intel_sdvo_debug_write], SDVOC: W: 6B                         (SDVO_CMD_GET_VPOS)
[    2.801709] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 02
[    2.805737] [drm:intel_sdvo_create_enhance_property_tv], vpos: max 1023, default 512, current 512
[    2.805746] [drm:intel_sdvo_debug_write], SDVOC: W: 55                         (SDVO_CMD_GET_MAX_SATURATION)
[    2.808060] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 7F 00 45 00
[    2.814754] [drm:intel_sdvo_debug_write], SDVOC: W: 56                         (SDVO_CMD_GET_SATURATION)
[    2.817073] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 45 00
[    2.821101] [drm:intel_sdvo_create_enhance_property_tv], saturation: max 127, default 69, current 69
[    2.821110] [drm:intel_sdvo_debug_write], SDVOC: W: 5E                         (SDVO_CMD_GET_MAX_CONTRAST)
[    2.823414] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 7F 00 40 00
[    2.830122] [drm:intel_sdvo_debug_write], SDVOC: W: 5F                         (SDVO_CMD_GET_CONTRAST)
[    2.832437] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 40 00
[    2.836460] [drm:intel_sdvo_create_enhance_property_tv], contrast: max 127, default 64, current 64
[    2.836469] [drm:intel_sdvo_debug_write], SDVOC: W: 58                         (SDVO_CMD_GET_MAX_HUE)
[    2.838773] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 7F 00 40 00
[    2.845474] [drm:intel_sdvo_debug_write], SDVOC: W: 59                         (SDVO_CMD_GET_HUE)
[    2.847778] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 40 00
[    2.851805] [drm:intel_sdvo_create_enhance_property_tv], hue: max 127, default 64, current 64
[    2.851814] [drm:intel_sdvo_debug_write], SDVOC: W: 6D                         (SDVO_CMD_GET_MAX_SHARPNESS)
[    2.854129] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 07 00 04 00
[    2.860837] [drm:intel_sdvo_debug_write], SDVOC: W: 6E                         (SDVO_CMD_GET_SHARPNESS)
[    2.863141] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 04 00
[    2.867169] [drm:intel_sdvo_create_enhance_property_tv], sharpness: max 7, default 4, current 4
[    2.867178] [drm:intel_sdvo_debug_write], SDVOC: W: 5B                         (SDVO_CMD_GET_MAX_BRIGHTNESS)
[    2.869496] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FF 00 80 00
[    2.876205] [drm:intel_sdvo_debug_write], SDVOC: W: 5C                         (SDVO_CMD_GET_BRIGHTNESS)
[    2.878509] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 80 00
[    2.882537] [drm:intel_sdvo_create_enhance_property_tv], brightness: max 255, default 128, current 128
[    2.882546] [drm:intel_sdvo_debug_write], SDVOC: W: 7B                         (SDVO_CMD_GET_MAX_FLICKER_FILTER_ADAPTIVE)
[    2.884865] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 07 00 07 00
[    2.891555] [drm:intel_sdvo_debug_write], SDVOC: W: 50                         (SDVO_CMD_GET_FLICKER_FILTER_ADAPTIVE)
[    2.893874] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 07 00
[    2.897902] [drm:intel_sdvo_create_enhance_property_tv], flicker_filter_adaptive: max 7, default 7, current 7
[    2.897911] [drm:intel_sdvo_debug_write], SDVOC: W: 74                         (SDVO_CMD_GET_MAX_TV_CHROMA_FILTER)
[    2.900229] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 03 00 01 00
[    2.906924] [drm:intel_sdvo_debug_write], SDVOC: W: 75                         (SDVO_CMD_GET_TV_CHROMA_FILTER)
[    2.909240] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 01 00
[    2.913269] [drm:intel_sdvo_create_enhance_property_tv], tv_chroma_filter: max 3, default 1, current 1
[    2.913277] [drm:intel_sdvo_debug_write], SDVOC: W: 77                         (SDVO_CMD_GET_MAX_TV_LUMA_FILTER)
[    2.915582] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 02 00 00 00
[    2.922287] [drm:intel_sdvo_debug_write], SDVOC: W: 78                         (SDVO_CMD_GET_TV_LUMA_FILTER)
[    2.924602] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    2.928629] [drm:intel_sdvo_create_enhance_property_tv], tv_luma_filter: max 2, default 0, current 0
[    2.928638] [drm:intel_sdvo_debug_write], SDVOC: W: 70                         (SDVO_CMD_GET_DOT_CRAWL)
[    2.930942] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    2.934971] [drm:intel_sdvo_create_enhance_property_tv], dot crawl: current 0
[    2.935097] [drm:intel_sdvo_debug_write], SDVOC: W: 11 10 00                   (SDVO_CMD_SET_TARGET_OUTPUT)
[    2.939309] [drm:intel_sdvo_read_response], SDVOC: R: (Success)
[    2.940664] [drm:intel_sdvo_debug_write], SDVOC: W: 27                         (SDVO_CMD_GET_SUPPORTED_TV_FORMATS)
[    2.942966] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FF FF FF FF FF 1F
[    2.952374] [drm:intel_sdvo_debug_write], SDVOC: W: 84                         (SDVO_CMD_GET_SUPPORTED_ENHANCEMENTS)
[    2.954678] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FA DF
[    2.958696] [drm:intel_sdvo_debug_write], SDVOC: W: 61                         (SDVO_CMD_GET_MAX_OVERSCAN_H)
[    2.961015] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 2F 00 20 00
[    2.967708] [drm:intel_sdvo_debug_write], SDVOC: W: 62                         (SDVO_CMD_GET_OVERSCAN_H)
[    2.970021] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 20 00
[    2.974049] [drm:intel_sdvo_create_enhance_property_tv], h_overscan: max 47, default 32, current 32
[    2.974058] [drm:intel_sdvo_debug_write], SDVOC: W: 64                         (SDVO_CMD_GET_MAX_OVERSCAN_V)
[    2.976372] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 2F 00 20 00
[    2.983061] [drm:intel_sdvo_debug_write], SDVOC: W: 65                         (SDVO_CMD_GET_OVERSCAN_V)
[    2.985380] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 20 00
[    2.989411] [drm:intel_sdvo_create_enhance_property_tv], v_overscan: max 47, default 32, current 32
[    2.989419] [drm:intel_sdvo_debug_write], SDVOC: W: 67                         (SDVO_CMD_GET_MAX_HPOS)
[    2.991723] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FF 03 00 02
[    2.998423] [drm:intel_sdvo_debug_write], SDVOC: W: 68                         (SDVO_CMD_GET_HPOS)
[    3.000741] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 02
[    3.004769] [drm:intel_sdvo_create_enhance_property_tv], hpos: max 1023, default 512, current 512
[    3.004778] [drm:intel_sdvo_debug_write], SDVOC: W: 6A                         (SDVO_CMD_GET_MAX_VPOS)
[    3.007082] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FF 03 00 02
[    3.013791] [drm:intel_sdvo_debug_write], SDVOC: W: 6B                         (SDVO_CMD_GET_VPOS)
[    3.016102] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 02
[    3.020125] [drm:intel_sdvo_create_enhance_property_tv], vpos: max 1023, default 512, current 512
[    3.020134] [drm:intel_sdvo_debug_write], SDVOC: W: 55                         (SDVO_CMD_GET_MAX_SATURATION)
[    3.022438] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 7F 00 45 00
[    3.029138] [drm:intel_sdvo_debug_write], SDVOC: W: 56                         (SDVO_CMD_GET_SATURATION)
[    3.031442] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 45 00
[    3.035470] [drm:intel_sdvo_create_enhance_property_tv], saturation: max 127, default 69, current 69
[    3.035478] [drm:intel_sdvo_debug_write], SDVOC: W: 5E                         (SDVO_CMD_GET_MAX_CONTRAST)
[    3.037796] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 7F 00 40 00
[    3.044505] [drm:intel_sdvo_debug_write], SDVOC: W: 5F                         (SDVO_CMD_GET_CONTRAST)
[    3.046809] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 40 00
[    3.050837] [drm:intel_sdvo_create_enhance_property_tv], contrast: max 127, default 64, current 64
[    3.050846] [drm:intel_sdvo_debug_write], SDVOC: W: 58                         (SDVO_CMD_GET_MAX_HUE)
[    3.053164] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 7F 00 40 00
[    3.059855] [drm:intel_sdvo_debug_write], SDVOC: W: 59                         (SDVO_CMD_GET_HUE)
[    3.062174] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 40 00
[    3.066202] [drm:intel_sdvo_create_enhance_property_tv], hue: max 127, default 64, current 64
[    3.066210] [drm:intel_sdvo_debug_write], SDVOC: W: 6D                         (SDVO_CMD_GET_MAX_SHARPNESS)
[    3.068529] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 07 00 04 00
[    3.075223] [drm:intel_sdvo_debug_write], SDVOC: W: 6E                         (SDVO_CMD_GET_SHARPNESS)
[    3.077541] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 04 00
[    3.081569] [drm:intel_sdvo_create_enhance_property_tv], sharpness: max 7, default 4, current 4
[    3.081578] [drm:intel_sdvo_debug_write], SDVOC: W: 5B                         (SDVO_CMD_GET_MAX_BRIGHTNESS)
[    3.083882] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FF 00 80 00
[    3.090587] [drm:intel_sdvo_debug_write], SDVOC: W: 5C                         (SDVO_CMD_GET_BRIGHTNESS)
[    3.092906] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 80 00
[    3.096934] [drm:intel_sdvo_create_enhance_property_tv], brightness: max 255, default 128, current 128
[    3.096943] [drm:intel_sdvo_debug_write], SDVOC: W: 7B                         (SDVO_CMD_GET_MAX_FLICKER_FILTER_ADAPTIVE)
[    3.099247] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 07 00 07 00
[    3.105956] [drm:intel_sdvo_debug_write], SDVOC: W: 50                         (SDVO_CMD_GET_FLICKER_FILTER_ADAPTIVE)
[    3.108268] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 07 00
[    3.112292] [drm:intel_sdvo_create_enhance_property_tv], flicker_filter_adaptive: max 7, default 7, current 7
[    3.112300] [drm:intel_sdvo_debug_write], SDVOC: W: 74                         (SDVO_CMD_GET_MAX_TV_CHROMA_FILTER)
[    3.114605] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 03 00 01 00
[    3.121311] [drm:intel_sdvo_debug_write], SDVOC: W: 75                         (SDVO_CMD_GET_TV_CHROMA_FILTER)
[    3.123615] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 01 00
[    3.127640] [drm:intel_sdvo_create_enhance_property_tv], tv_chroma_filter: max 3, default 1, current 1
[    3.127648] [drm:intel_sdvo_debug_write], SDVOC: W: 77                         (SDVO_CMD_GET_MAX_TV_LUMA_FILTER)
[    3.136203] tsc: Refined TSC clocksource calibration: 1199.999 MHz
[    3.129964] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 02 00 00 00
[    3.136916] [drm:intel_sdvo_debug_write], SDVOC: W: 78                         (SDVO_CMD_GET_TV_LUMA_FILTER)
[    3.139221] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.143246] [drm:intel_sdvo_create_enhance_property_tv], tv_luma_filter: max 2, default 0, current 0
[    3.143260] [drm:intel_sdvo_debug_write], SDVOC: W: 70                         (SDVO_CMD_GET_DOT_CRAWL)
[    3.145579] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.149607] [drm:intel_sdvo_create_enhance_property_tv], dot crawl: current 0
[    3.149780] [drm:intel_sdvo_debug_write], SDVOC: W: 10 00                      (SDVO_CMD_SET_TARGET_INPUT)
[    3.153045] [drm:intel_sdvo_read_response], SDVOC: R: (Success)
[    3.154388] [drm:intel_sdvo_debug_write], SDVOC: W: 1D                         (SDVO_CMD_GET_INPUT_PIXEL_CLOCK_RANGE)
[    3.156706] [drm:intel_sdvo_read_response], SDVOC: R: (Success) C4 09 D8 40
[    3.163390] [drm:intel_sdvo_init], SDVOC device VID/DID: 02:C2.01, clock range 25MHz - 166MHz, input 1: Y, input 2: N, output 1: Y, output 2: N
[    3.163597] [drm:i915_gem_setup_global_gtt], clearing unused GTT space: [0, ffff000]
[    3.168457] [drm:i915_gem_context_init], Disabling HW Contexts; old hardware
[    3.168686] [drm] initialized overlay support
[    3.168707] [drm:intel_modeset_readout_hw_state], [CRTC:3] hw state readout: enabled
[    3.168715] [drm:intel_modeset_readout_hw_state], [CRTC:4] hw state readout: disabled
[    3.168726] [drm:intel_modeset_readout_hw_state], [ENCODER:6:DAC-6] hw state readout: enabled, pipe=0
[    3.168736] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.171043] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 00 00
[    3.175072] [drm:intel_modeset_readout_hw_state], [ENCODER:7:TMDS-7] hw state readout: disabled, pipe=0
[    3.175082] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.177398] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.181424] [drm:intel_modeset_readout_hw_state], [ENCODER:9:DAC-9] hw state readout: disabled, pipe=0
[    3.181433] [drm:intel_modeset_readout_hw_state], [ENCODER:63:TV-63] hw state readout: disabled, pipe=0
[    3.181446] [drm:intel_modeset_readout_hw_state], [CONNECTOR:5:VGA-1] hw state readout: enabled
[    3.181455] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.183758] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 00 00
[    3.187780] [drm:intel_modeset_readout_hw_state], [CONNECTOR:8:DVI-D-1] hw state readout: disabled
[    3.187789] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.190107] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.194132] [drm:intel_modeset_readout_hw_state], [CONNECTOR:10:SVIDEO-1] hw state readout: disabled
[    3.194140] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.196454] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.200474] [drm:intel_modeset_readout_hw_state], [CONNECTOR:27:SVIDEO-2] hw state readout: disabled
[    3.200483] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.202787] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.206806] [drm:intel_modeset_readout_hw_state], [CONNECTOR:44:SVIDEO-3] hw state readout: disabled
[    3.206814] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.209133] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.213153] [drm:intel_modeset_readout_hw_state], [CONNECTOR:61:VGA-2] hw state readout: disabled
[    3.213162] [drm:intel_modeset_readout_hw_state], [CONNECTOR:62:SVIDEO-4] hw state readout: disabled
[    3.213175] [drm:intel_dump_pipe_config], [CRTC:3][setup_hw_state] config for pipe A
[    3.213182] [drm:intel_dump_pipe_config], cpu_transcoder: A
[    3.213188] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
[    3.213195] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    3.213203] [drm:intel_dump_pipe_config], requested mode:
[    3.213209] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 800 0 0 0 600 0 0 0 0x0 0x0
[    3.213218] [drm:intel_dump_pipe_config], adjusted mode:
[    3.213224] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 40000 0 0 0 0 0 0 0 0 0x0 0x5
[    3.213234] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    3.213241] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000
[    3.213248] [drm:intel_dump_pipe_config], ips: 0
[    3.213257] [drm:intel_dump_pipe_config], [CRTC:4][setup_hw_state] config for pipe B
[    3.213264] [drm:intel_dump_pipe_config], cpu_transcoder: B
[    3.213270] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
[    3.213276] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    3.213285] [drm:intel_dump_pipe_config], requested mode:
[    3.213290] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[    3.213299] [drm:intel_dump_pipe_config], adjusted mode:
[    3.213305] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[    3.213314] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    3.213322] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000
[    3.213328] [drm:intel_dump_pipe_config], ips: 0
[    3.213337] [drm:intel_connector_check_state], [CONNECTOR:5:VGA-1]
[    3.213346] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.215649] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 00 00
[    3.219671] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.221988] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.226007] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.228318] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.232340] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.234642] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.238666] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.240981] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.245003] [drm:check_encoder_state], [ENCODER:6:DAC-6]
[    3.245011] [drm:check_encoder_state], [ENCODER:7:TMDS-7]
[    3.245020] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.247324] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 00 00
[    3.251342] [drm:check_encoder_state], [ENCODER:9:DAC-9]
[    3.251350] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.253664] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.257690] [drm:check_encoder_state], [ENCODER:63:TV-63]
[    3.257698] [drm:check_crtc_state], [CRTC:3]
[    3.257724] [drm:check_crtc_state], [CRTC:4]
[    3.257806] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1]
[    3.257813] [drm:intel_crt_detect], [CONNECTOR:5:VGA-1] force=1
[    3.260033] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[    3.260043] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    3.260050] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[    3.260057] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[    3.301272] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[    3.301280] [drm:intel_crt_detect_ddc], CRT detected via DDC:0x50 [EDID]
[    3.304029] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[    3.304038] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    3.304045] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[    3.304052] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[    3.345256] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[    3.345315] [drm:drm_edid_to_eld], ELD: no CEA Extension found
[    3.345335] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1] probed modes :
[    3.345343] [drm:drm_mode_debug_printmodeline], Modeline 86:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[    3.345353] [drm:drm_mode_debug_printmodeline], Modeline 78:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
[    3.345364] [drm:drm_mode_debug_printmodeline], Modeline 93:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[    3.345374] [drm:drm_mode_debug_printmodeline], Modeline 87:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[    3.345384] [drm:drm_mode_debug_printmodeline], Modeline 88:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[    3.345394] [drm:drm_mode_debug_printmodeline], Modeline 89:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[    3.345404] [drm:drm_mode_debug_printmodeline], Modeline 90:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[    3.345413] [drm:drm_mode_debug_printmodeline], Modeline 91:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[    3.345423] [drm:drm_mode_debug_printmodeline], Modeline 92:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[    3.345433] [drm:drm_mode_debug_printmodeline], Modeline 79:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[    3.345443] [drm:drm_mode_debug_printmodeline], Modeline 80:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[    3.345453] [drm:drm_mode_debug_printmodeline], Modeline 81:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[    3.345463] [drm:drm_mode_debug_printmodeline], Modeline 82:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[    3.345473] [drm:drm_mode_debug_printmodeline], Modeline 83:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[    3.345483] [drm:drm_mode_debug_printmodeline], Modeline 84:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[    3.345493] [drm:drm_mode_debug_printmodeline], Modeline 85:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[    3.345504] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:DVI-D-1]
[    3.345511] [drm:intel_sdvo_detect], [CONNECTOR:8:DVI-D-1]
[    3.345519] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[    3.347825] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 00 00
[    3.351848] [drm:intel_sdvo_detect], SDVO response 0 0 [1]
[    3.351855] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:DVI-D-1] disconnected
[    3.351863] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:10:SVIDEO-1]
[    3.351870] [drm:intel_sdvo_detect], [CONNECTOR:10:SVIDEO-1]
[    3.351878] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[    3.354196] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.404050] [drm:intel_sdvo_detect], SDVO response 0 0 [8]
[    3.404058] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:10:SVIDEO-1] disconnected
[    3.404066] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:27:SVIDEO-2]
[    3.404073] [drm:intel_sdvo_detect], [CONNECTOR:27:SVIDEO-2]
[    3.404080] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[    3.406386] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.456039] [drm:intel_sdvo_detect], SDVO response 0 0 [4]
[    3.456047] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:27:SVIDEO-2] disconnected
[    3.456055] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:44:SVIDEO-3]
[    3.456062] [drm:intel_sdvo_detect], [CONNECTOR:44:SVIDEO-3]
[    3.456070] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[    3.458375] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.508049] [drm:intel_sdvo_detect], SDVO response 0 0 [10]
[    3.508057] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:44:SVIDEO-3] disconnected
[    3.508065] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:61:VGA-2]
[    3.508072] [drm:intel_sdvo_detect], [CONNECTOR:61:VGA-2]
[    3.508079] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[    3.510385] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.560039] [drm:intel_sdvo_detect], SDVO response 0 0 [2]
[    3.560047] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:61:VGA-2] disconnected
[    3.560055] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:62:SVIDEO-4]
[    3.560062] [drm:intel_tv_detect], [CONNECTOR:62:SVIDEO-4] force=1
[    3.560070] [drm:intel_get_load_detect_pipe], [CONNECTOR:62:SVIDEO-4], [ENCODER:63:TV-63]
[    3.560112] [drm:intel_get_load_detect_pipe], creating tmp fb for load-detection
[    3.560422] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 2, prepare: 2, disable: 0
[    3.560434] [drm:connected_sink_compute_bpp], [CONNECTOR:62:SVIDEO-4] checking for sink bpp constrains
[    3.560442] [drm:intel_tv_compute_config], forcing bpc to 8 for TV
[    3.560449] [drm:intel_modeset_pipe_config], plane bpp: 24, pipe bpp: 24, dithering: 0
[    3.560456] [drm:intel_dump_pipe_config], [CRTC:4][modeset] config for pipe B
[    3.560463] [drm:intel_dump_pipe_config], cpu_transcoder: B
[    3.560469] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[    3.560476] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    3.560484] [drm:intel_dump_pipe_config], requested mode:
[    3.560490] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[    3.560501] [drm:intel_dump_pipe_config], adjusted mode:
[    3.560507] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 108000 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0xa
[    3.560517] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    3.560524] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000
[    3.560531] [drm:intel_dump_pipe_config], ips: 0
[    3.574488] [drm:i9xx_update_plane], Writing base 00020000 00000000 0 0 5120
[    3.574510] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    3.574519] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    3.574526] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 29
[    3.574535] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 29, C: 2, SR 1
[    3.574545] [drm:i9xx_update_wm], memory self refresh disabled
[    3.574554] [drm:intel_crtc_mode_set], [ENCODER:63:TV-63] set [MODE:0:NTSC 480i]
[    3.579726] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    3.579733] [drm:intel_calculate_wm], FIFO entries required for mode: 34
[    3.579740] [drm:intel_calculate_wm], FIFO watermark level: -8
[    3.579747] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    3.579754] [drm:i9xx_update_wm], FIFO watermarks - A: 1, B: 29
[    3.579763] [drm:i9xx_update_wm], self-refresh entries: 80
[    3.579770] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 1, B: 29, C: 2, SR 15
[    3.579780] [drm:i9xx_update_wm], memory self refresh enabled
[    3.604037] [drm:intel_connector_check_state], [CONNECTOR:5:VGA-1]
[    3.604050] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.606542] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 00 00
[    3.610736] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.613148] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.617341] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.619743] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.623942] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.626357] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.630552] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.632969] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.637485] [drm:intel_connector_check_state], [CONNECTOR:62:SVIDEO-4]
[    3.637494] [drm:check_encoder_state], [ENCODER:6:DAC-6]
[    3.637502] [drm:check_encoder_state], [ENCODER:7:TMDS-7]
[    3.637512] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.639915] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 00 00
[    3.644128] [drm:check_encoder_state], [ENCODER:9:DAC-9]
[    3.644137] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.646541] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.650733] [drm:check_encoder_state], [ENCODER:63:TV-63]
[    3.650742] [drm:check_crtc_state], [CRTC:3]
[    3.650770] [drm:check_crtc_state], [CRTC:4]
[    3.650795] [drm:intel_pipe_config_compare] *ERROR* mismatch in adjusted_mode.flags(DRM_MODE_FLAG_NHSYNC) (expected 2, found 0)
[    3.651099] ------------[ cut here ]------------
[    3.651112] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/i915/intel_display.c:8746 check_crtc_state+0x6c5/0x6f9()
[    3.651117] pipe state doesn't match!
[    3.651122] Modules linked in:
[    3.651131] CPU: 0 PID: 1 Comm: swapper Not tainted 3.11.0-main+ #67
[    3.651136] Hardware name:    /i915GMm-HFS, BIOS 6.00 PG 11/04/2005
[    3.651142]  00000000 c07045c2 f607989c c053ced2 f60798b4 c012a920 c03c8753 00000000
[    3.651162]  f6360000 f632fc48 f60798cc c012a9aa 00000009 f60798c4 c07045c2 f60798e0
[    3.651182]  f6079b34 c03c8753 c0703488 0000222a c07045c2 f606a4f8 f6354344 f606a4fc
[    3.651202] Call Trace:
[    3.651215]  [<c053ced2>] dump_stack+0x16/0x18
[    3.651227]  [<c012a920>] warn_slowpath_common+0x5f/0x76
[    3.651236]  [<c03c8753>] ? check_crtc_state+0x6c5/0x6f9
[    3.651245]  [<c012a9aa>] warn_slowpath_fmt+0x2b/0x2f
[    3.651254]  [<c03c8753>] check_crtc_state+0x6c5/0x6f9
[    3.651282]  [<c03d1bc7>] intel_modeset_check_state+0x30c/0x58b
[    3.651293]  [<c03d1e6c>] intel_set_mode+0x26/0x2f
[    3.651303]  [<c03d2d9b>] intel_get_load_detect_pipe+0x2b4/0x308
[    3.651316]  [<c03ecbab>] intel_tv_detect+0x108/0x444
[    3.651333]  [<c0390d7e>] drm_helper_probe_single_connector_modes+0xa0/0x270
[    3.651346]  [<c038e882>] drm_fb_helper_probe_connector_modes+0x39/0x4c
[    3.651356]  [<c038fd67>] drm_fb_helper_initial_config+0x143/0x3ac
[    3.651367]  [<c05428e0>] ? _raw_spin_unlock_irqrestore+0x38/0x5b
[    3.651376]  [<c05428ec>] ? _raw_spin_unlock_irqrestore+0x44/0x5b
[    3.651386]  [<c05428ec>] ? _raw_spin_unlock_irqrestore+0x44/0x5b
[    3.651396]  [<c03ec4fb>] intel_fbdev_initial_config+0x1e/0x20
[    3.651406]  [<c03a9edd>] i915_driver_load+0xb48/0xd23
[    3.651421]  [<c039a6ae>] drm_get_pci_dev+0x172/0x266
[    3.651430]  [<c05428ec>] ? _raw_spin_unlock_irqrestore+0x44/0x5b
[    3.651440]  [<c03a71b5>] i915_pci_probe+0x46/0x4f
[    3.651451]  [<c0307f04>] pci_device_probe+0x5e/0x96
[    3.651461]  [<c0404d8d>] driver_probe_device+0x83/0x17a
[    3.651470]  [<c0404ed7>] __driver_attach+0x53/0x6f
[    3.651481]  [<c04037ea>] bus_for_each_dev+0x43/0x6d
[    3.651490]  [<c04049cb>] driver_attach+0x19/0x1b
[    3.651499]  [<c0404e84>] ? driver_probe_device+0x17a/0x17a
[    3.651507]  [<c0404615>] bus_add_driver+0xc3/0x1ee
[    3.651516]  [<c04053d5>] driver_register+0x73/0xa5
[    3.651526]  [<c0307fe7>] __pci_register_driver+0x4a/0x4d
[    3.651538]  [<c07fc62b>] ? ftrace_define_fields_drm_vblank_event+0x45/0x45
[    3.651547]  [<c039a80f>] drm_pci_init+0x6d/0xc5
[    3.651557]  [<c07fc62b>] ? ftrace_define_fields_drm_vblank_event+0x45/0x45
[    3.651567]  [<c07fc689>] i915_init+0x5e/0x60
[    3.651576]  [<c01003b5>] do_one_initcall+0x6f/0xea
[    3.651586]  [<c0141339>] ? parameq+0x21/0x25
[    3.651594]  [<c0141445>] ? parse_args+0x108/0x209
[    3.651607]  [<c07d39c2>] kernel_init_freeable+0xce/0x153
[    3.651617]  [<c0537276>] kernel_init+0xd/0xb9
[    3.651627]  [<c0547f77>] ret_from_kernel_thread+0x1b/0x28
[    3.651635]  [<c0537269>] ? rest_init+0xa5/0xa5
[    3.651812] ---[ end trace 4bf2a83f021b5162 ]---
[    3.651818] [drm:intel_dump_pipe_config], [CRTC:4][hw state] config for pipe B
[    3.651825] [drm:intel_dump_pipe_config], cpu_transcoder: B
[    3.651831] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
[    3.651838] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    3.651847] [drm:intel_dump_pipe_config], requested mode:
[    3.651853] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 1280 0 0 0 1024 0 0 0 0x0 0x0
[    3.651863] [drm:intel_dump_pipe_config], adjusted mode:
[    3.651869] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 108000 0 0 0 0 0 0 0 0 0x0 0x0
[    3.651878] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    3.651886] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000
[    3.651893] [drm:intel_dump_pipe_config], ips: 0
[    3.651899] [drm:intel_dump_pipe_config], [CRTC:4][sw state] config for pipe B
[    3.651906] [drm:intel_dump_pipe_config], cpu_transcoder: B
[    3.651912] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[    3.651918] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    3.651927] [drm:intel_dump_pipe_config], requested mode:
[    3.651933] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[    3.651943] [drm:intel_dump_pipe_config], adjusted mode:
[    3.651949] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 108000 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0xa
[    3.651959] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    3.651966] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000
[    3.651973] [drm:intel_dump_pipe_config], ips: 0
[    3.688027] [drm:intel_tv_detect_type], TV detected: 400c0c07, 7f0000aa
[    3.688035] [drm:intel_tv_detect_type], Unrecognised TV connection
[    3.720028] [drm:intel_release_load_detect_pipe], [CONNECTOR:62:SVIDEO-4], [ENCODER:63:TV-63]
[    3.720038] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 0, prepare: 0, disable: 2
[    3.758922] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    3.758931] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    3.758938] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 29
[    3.758946] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 29, C: 2, SR 1
[    3.758955] [drm:i9xx_update_wm], memory self refresh disabled
[    3.758969] [drm:intel_connector_check_state], [CONNECTOR:5:VGA-1]
[    3.758979] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.761396] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 00 00
[    3.765589] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.767989] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.772198] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.774598] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.778794] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.781209] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.785405] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.787805] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.792015] [drm:check_encoder_state], [ENCODER:6:DAC-6]
[    3.792024] [drm:check_encoder_state], [ENCODER:7:TMDS-7]
[    3.792033] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.794433] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 00 00
[    3.798626] [drm:check_encoder_state], [ENCODER:9:DAC-9]
[    3.798635] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.801048] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.805236] [drm:check_encoder_state], [ENCODER:63:TV-63]
[    3.805245] [drm:check_crtc_state], [CRTC:3]
[    3.805270] [drm:check_crtc_state], [CRTC:4]
[    3.805279] [drm:i9xx_crtc_clock_get], Unknown DPLL mode 00000000 in programmed mode
[    3.807764] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:62:SVIDEO-4] disconnected
[    3.807773] [drm:drm_setup_crtcs], 
[    3.807781] [drm:drm_enable_connectors], connector 5 enabled? yes
[    3.807788] [drm:drm_enable_connectors], connector 8 enabled? no
[    3.807795] [drm:drm_enable_connectors], connector 10 enabled? no
[    3.807801] [drm:drm_enable_connectors], connector 27 enabled? no
[    3.807808] [drm:drm_enable_connectors], connector 44 enabled? no
[    3.807814] [drm:drm_enable_connectors], connector 61 enabled? no
[    3.807820] [drm:drm_enable_connectors], connector 62 enabled? no
[    3.807827] [drm:drm_target_preferred], looking for cmdline mode on connector 5
[    3.807834] [drm:drm_target_preferred], looking for preferred mode on connector 5
[    3.807843] [drm:drm_target_preferred], found mode 1280x1024
[    3.807850] [drm:drm_setup_crtcs], picking CRTCs for 4096x4096 config
[    3.807859] [drm:drm_setup_crtcs], desired mode 1280x1024 set on crtc 3
[    3.822710] [drm:intelfb_create], allocated 1280x1024 fb: 0x00020000, bo f6379c80
[    3.824072] fbcon: inteldrmfb (fb0) is primary device
[    3.827222] [drm:intel_crtc_set_config], [CRTC:3] [FB:95] #connectors=1 (x y) (0 0)
[    3.827240] [drm:intel_set_config_compute_mode_changes], inactive crtc, full mode set
[    3.827245] [drm:intel_set_config_compute_mode_changes], modes are different, full mode set
[    3.827253] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[    3.827261] [drm:drm_mode_debug_printmodeline], Modeline 94:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[    3.827266] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=1, fb_changed=0
[    3.827274] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:VGA-1] to [CRTC:3]
[    3.827281] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 1, prepare: 1, disable: 0
[    3.827290] [drm:connected_sink_compute_bpp], [CONNECTOR:5:VGA-1] checking for sink bpp constrains
[    3.827298] [drm:intel_modeset_pipe_config], plane bpp: 24, pipe bpp: 24, dithering: 0
[    3.827303] [drm:intel_dump_pipe_config], [CRTC:3][modeset] config for pipe A
[    3.827307] [drm:intel_dump_pipe_config], cpu_transcoder: A
[    3.827312] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[    3.827318] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    3.827322] [drm:intel_dump_pipe_config], requested mode:
[    3.827330] [drm:drm_mode_debug_printmodeline], Modeline 0:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[    3.827334] [drm:intel_dump_pipe_config], adjusted mode:
[    3.827342] [drm:drm_mode_debug_printmodeline], Modeline 0:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[    3.827348] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    3.827353] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000
[    3.827357] [drm:intel_dump_pipe_config], ips: 0
[    3.852264] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    3.852271] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    3.852276] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 29
[    3.852284] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 29, C: 2, SR 1
[    3.852290] [drm:i9xx_update_wm], memory self refresh disabled
[    3.852647] [drm:i9xx_update_plane], Writing base 00020000 00000000 0 0 5120
[    3.852658] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    3.852664] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    3.852669] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 29
[    3.852677] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 29, C: 2, SR 1
[    3.852683] [drm:i9xx_update_wm], memory self refresh disabled
[    3.852690] [drm:intel_crtc_mode_set], [ENCODER:6:DAC-6] set [MODE:0:1280x1024]
[    3.852699] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    3.852705] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    3.852710] [drm:intel_calculate_wm], FIFO entries required for mode: 43
[    3.852714] [drm:intel_calculate_wm], FIFO watermark level: -14
[    3.852719] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 1
[    3.852725] [drm:i9xx_update_wm], self-refresh entries: 80
[    3.852732] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 1, C: 2, SR 15
[    3.852740] [drm:i9xx_update_wm], memory self refresh enabled
[    3.868039] [drm:intel_connector_check_state], [CONNECTOR:5:VGA-1]
[    3.868062] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.875209] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 00 00
[    3.875228] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.882357] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.882376] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.889499] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.889518] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.896644] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.896663] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.903783] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.903790] [drm:check_encoder_state], [ENCODER:6:DAC-6]
[    3.903797] [drm:check_encoder_state], [ENCODER:7:TMDS-7]
[    3.903817] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.910945] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 00 00
[    3.910951] [drm:check_encoder_state], [ENCODER:9:DAC-9]
[    3.910971] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.918102] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.918108] [drm:check_encoder_state], [ENCODER:63:TV-63]
[    3.918114] [drm:check_crtc_state], [CRTC:3]
[    3.918144] [drm:check_crtc_state], [CRTC:4]
[    3.918153] [drm:i9xx_crtc_clock_get], Unknown DPLL mode 00000000 in programmed mode
[    3.918161] [drm:intel_crtc_set_config], [CRTC:4] [NOFB]
[    3.918169] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:4], mode_changed=0, fb_changed=0
[    3.918175] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:VGA-1] to [CRTC:3]
[    3.918240] [drm:intel_crtc_set_config], [CRTC:3] [FB:95] #connectors=1 (x y) (0 0)
[    3.918249] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[    3.918255] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:VGA-1] to [CRTC:3]
[    3.932743] [drm:intel_crtc_set_config], [CRTC:3] [FB:95] #connectors=1 (x y) (0 0)
[    3.932752] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[    3.932758] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:VGA-1] to [CRTC:3]
[    3.947096] Console: switching to colour frame buffer device 160x64
[    3.947110] [drm:intel_crtc_set_config], [CRTC:3] [FB:95] #connectors=1 (x y) (0 0)
[    3.947119] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[    3.947125] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:VGA-1] to [CRTC:3]
[    3.961294] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    3.961301] i915 0000:00:02.0: registered panic notifier
[    3.961368] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    3.961999] parport_pc 00:07: reported by Plug and Play ACPI
[    3.962160] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[    4.056882] lp0: using parport0 (interrupt-driven).
[    4.062652] loop: module loaded
[    4.062851] ACPI Warning: 0x00004028-0x0000402f SystemIO conflicts with Region \PM2S 1 (20130725/utaddress-251)
[    4.062868] ACPI: This conflict may cause random problems and system instability
[    4.062874] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    4.062890] ACPI Warning: 0x000040b0-0x000040bf SystemIO conflicts with Region \GPO2 1 (20130725/utaddress-251)
[    4.062903] ACPI: This conflict may cause random problems and system instability
[    4.062908] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    4.062915] ACPI Warning: 0x00004080-0x000040af SystemIO conflicts with Region \GPO_ 1 (20130725/utaddress-251)
[    4.062928] ACPI: This conflict may cause random problems and system instability
[    4.062933] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    4.063063] Uniform Multi-Platform E-IDE driver
[    4.063187] piix 0000:00:1f.1: IDE controller (0x8086:0x266f rev 0x04)
[    4.063858] piix 0000:00:1f.1: not 100% native mode: will probe irqs later
[    4.063871]     ide0: BM-DMA at 0xf000-0xf007
[    4.063886]     ide1: BM-DMA at 0xf008-0xf00f
[    4.063899] Probing IDE interface ide0...
[    4.136325] Switched to clocksource tsc
[    4.352325] hda: FUJITSU MHV2080AT, ATA DISK drive
[    5.024332] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    5.029328] hda: UDMA/100 mode selected
[    5.033967] Probing IDE interface ide1...
[    5.600345] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    5.621103] ide1 at 0x170-0x177,0x376 on irq 15
[    5.621551] ide-gd driver 1.18
[    5.621750] hda: max request size: 128KiB
[    5.621909] hda: 156301488 sectors (80026 MB) w/8192KiB Cache, CHS=65535/16/63
[    5.626576] hda: cache flushes supported
[    5.643246]  hda: hda1 hda2
[    5.644924] ide-cd driver 5.00
[    5.645340] ata_piix 0000:00:1f.2: version 2.13
[    5.645805] ata_piix 0000:00:1f.2: MAP [
[    5.645810]  P0 P2 -- -- ]
[    5.645981] ata_piix 0000:00:1f.2: setting latency timer to 64
[    5.647863] scsi0 : ata_piix
[    5.648587] scsi1 : ata_piix
[    5.648781] ata1: SATA max UDMA/133 cmd 0xe500 ctl 0xe600 bmdma 0xe900 irq 19
[    5.648788] ata2: SATA max UDMA/133 cmd 0xe700 ctl 0xe800 bmdma 0xe908 irq 19
[    5.649009] sky2: driver version 1.30
[    5.649284] sky2 0000:02:00.0: Yukon-2 EC chip revision 2
[    5.649386] sky2 0000:02:00.0: irq 44 for MSI/MSI-X
[    5.650284] sky2 0000:02:00.0 eth0: addr 00:01:80:62:cf:b1
[    5.651270] sky2 0000:03:00.0: Yukon-2 EC chip revision 2
[    5.651361] sky2 0000:03:00.0: irq 45 for MSI/MSI-X
[    5.651856] sky2 0000:03:00.0 eth1: addr 00:01:80:62:cf:b2
[    5.651985] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.651990] ehci-pci: EHCI PCI platform driver
[    5.652524] ehci-pci 0000:00:1d.7: setting latency timer to 64
[    5.652686] ehci-pci 0000:00:1d.7: EHCI Host Controller
[    5.653082] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    5.657243] ehci-pci 0000:00:1d.7: cache line size of 32 is not supported
[    5.657352] ehci-pci 0000:00:1d.7: irq 23, io mem 0xd2344000
[    5.668026] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    5.668711] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    5.668719] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.668727] usb usb1: Product: EHCI Host Controller
[    5.668734] usb usb1: Manufacturer: Linux 3.11.0-main+ ehci_hcd
[    5.668741] usb usb1: SerialNumber: 0000:00:1d.7
[    5.670405] hub 1-0:1.0: USB hub found
[    5.670596] hub 1-0:1.0: 8 ports detected
[    5.672750] uhci_hcd: USB Universal Host Controller Interface driver
[    5.673252] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    5.673307] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    5.673355] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    5.673404] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000e100
[    5.673687] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    5.673695] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.673702] usb usb2: Product: UHCI Host Controller
[    5.673710] usb usb2: Manufacturer: Linux 3.11.0-main+ uhci_hcd
[    5.673716] usb usb2: SerialNumber: 0000:00:1d.0
[    5.674232] hub 2-0:1.0: USB hub found
[    5.674308] hub 2-0:1.0: 2 ports detected
[    5.675351] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    5.675362] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    5.675387] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    5.675435] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000e200
[    5.675638] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    5.675646] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.675653] usb usb3: Product: UHCI Host Controller
[    5.675660] usb usb3: Manufacturer: Linux 3.11.0-main+ uhci_hcd
[    5.675667] usb usb3: SerialNumber: 0000:00:1d.1
[    5.676281] hub 3-0:1.0: USB hub found
[    5.676315] hub 3-0:1.0: 2 ports detected
[    5.677302] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    5.677312] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    5.677365] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    5.677429] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000e300
[    5.677632] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    5.677641] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.677648] usb usb4: Product: UHCI Host Controller
[    5.677655] usb usb4: Manufacturer: Linux 3.11.0-main+ uhci_hcd
[    5.677661] usb usb4: SerialNumber: 0000:00:1d.2
[    5.678244] hub 4-0:1.0: USB hub found
[    5.678278] hub 4-0:1.0: 2 ports detected
[    5.679254] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    5.679265] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    5.679289] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    5.679364] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000e400
[    5.679564] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    5.679572] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.679579] usb usb5: Product: UHCI Host Controller
[    5.679586] usb usb5: Manufacturer: Linux 3.11.0-main+ uhci_hcd
[    5.679593] usb usb5: SerialNumber: 0000:00:1d.3
[    5.680126] hub 5-0:1.0: USB hub found
[    5.680162] hub 5-0:1.0: 2 ports detected
[    5.680776] usbcore: registered new interface driver usblp
[    5.680867] usbcore: registered new interface driver usb-storage
[    5.681275] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    5.851290] ata1.00: ATA-8: ST31000340NS, SN06, max UDMA/133
[    5.851298] ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    5.907747] ata1.00: configured for UDMA/133
[    5.908888] scsi 0:0:0:0: Direct-Access     ATA      ST31000340NS     SN06 PQ: 0 ANSI: 5
[    5.911088] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    5.912455] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    5.912674] sd 0:0:0:0: [sda] Write Protect is off
[    5.912682] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.912775] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.931262]  sda: sda1 sda2 sda3 sda4
[    5.932419] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.933568] mousedev: PS/2 mouse device common for all mice
[    5.936127] sd 0:0:0:0: [sda] Attached SCSI disk
[    5.936400] input: PC Speaker as /devices/platform/pcspkr/input/input2
[    5.936748] rtc_cmos 00:02: RTC can wake from S4
[    5.937398] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    5.937465] rtc_cmos 00:02: alarms up to one month, 242 bytes nvram, hpet irqs
[    5.938058] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
[    5.938279] w83627hf: w83627hf: Found W83627THF chip at 0x290
[    5.938315] ACPI Warning: 0x00000295-0x00000296 SystemIO conflicts with Region \SEN1 1 (20130725/utaddress-251)
[    5.938330] ACPI: This conflict may cause random problems and system instability
[    5.938336] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    5.939023] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[    5.939083] iTCO_wdt: Found a ICH6-M TCO device (Version=2, TCOBASE=0x4060)
[    5.939753] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    5.939799] device-mapper: uevent: version 1.0.3
[    5.940053] device-mapper: ioctl: 4.25.0-ioctl (2013-06-26) initialised: dm-devel@redhat.com
[    5.941198] hidraw: raw HID events driver (C) Jiri Kosina
[    5.941609] usbcore: registered new interface driver usbhid
[    5.941614] usbhid: USB HID core driver
[    5.941962] TCP: cubic registered
[    5.941967] Initializing XFRM netlink socket
[    5.942643] Using IPI Shortcut mode
[    5.943029] PM: Checking hibernation image partition /dev/hda1
[    5.943070] PM: Hibernation image partition 3:1 present
[    5.943074] PM: Looking for hibernation image.
[    5.958522] PM: Image not found (code -22)
[    5.958529] PM: Hibernation image not present or could not be loaded.
[    5.958610] registered taskstats version 1
[    5.958622] AppArmor: AppArmor sha1 policy hashing enabled
[    5.959835] rtc_cmos 00:02: setting system clock to 2013-09-09 10:01:02 UTC (1378720862)
[    5.961390] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    5.961395] EDD information not available.
[    5.962341] Freeing unused kernel memory: 488K (c07d3000 - c084d000)
[    5.962710] Write protecting the kernel text: 4392k
[    5.963025] Write protecting the kernel read-only data: 2208k
[    5.963030] NX-protecting the kernel data: 4824k
[    6.088689] systemd-udevd[85]: starting version 195
[    6.536151] tsc: Marking TSC unstable due to cpufreq changes
[    6.536648] Switched to clocksource hpet
[    7.038745] EXT4-fs (hda2): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[    7.421034] EXT4-fs (hda2): re-mounted. Opts: acl,user_xattr
[    8.578884] systemd[1]: systemd 195 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ; suse)
[    8.666193] systemd[1]: Set hostname to <linux-ktth.site>.
[   10.102975] systemd[1]: Starting Forward Password Requests to Wall Directory Watch.
[   10.103754] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[   10.103835] systemd[1]: Starting Syslog Socket.
[   10.104265] systemd[1]: Listening on Syslog Socket.
[   10.104333] systemd[1]: Starting Remote File Systems.
[   10.104422] systemd[1]: Reached target Remote File Systems.
[   10.104489] systemd[1]: Starting /dev/initctl Compatibility Named Pipe.
[   10.104690] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
[   10.104753] systemd[1]: Starting Delayed Shutdown Socket.
[   10.104977] systemd[1]: Listening on Delayed Shutdown Socket.
[   10.105078] systemd[1]: Starting Dispatch Password Requests to Console Directory Watch.
[   10.105500] systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
[   10.105912] systemd[1]: Starting udev Kernel Socket.
[   10.106104] systemd[1]: Listening on udev Kernel Socket.
[   10.106410] systemd[1]: Starting udev Control Socket.
[   10.106641] systemd[1]: Listening on udev Control Socket.
[   10.106708] systemd[1]: Starting Encrypted Volumes.
[   10.106795] systemd[1]: Reached target Encrypted Volumes.
[   10.107111] systemd[1]: Starting Arbitrary Executable File Formats File System Automount Point.
[   10.108875] systemd[1]: Set up automount Arbitrary Executable File Formats File System Automount Point.
[   10.108919] systemd[1]: Expecting device dev-hda1.device...
[   10.108979] systemd[1]: Starting Journal Socket.
[   10.109379] systemd[1]: Listening on Journal Socket.
[   10.109428] systemd[1]: Starting LSB: Set default boot entry if called...
[   10.111651] systemd[1]: Starting Create dynamic rule for /dev/root link...
[   10.340134] systemd[1]: Starting Load Kernel Modules...
[   10.343187] systemd[1]: Mounting Huge Pages File System...
[   10.410976] systemd[1]: Started Set Up Additional Binary Formats.
[   10.411080] systemd[1]: Starting Setup Virtual Console...
[   10.414297] systemd[1]: Mounting POSIX Message Queue File System...
[   10.423032] systemd[1]: Started File System Check on Root Device.
[   10.423168] systemd[1]: Starting Remount Root and Kernel File Systems...
[   10.425399] systemd[1]: Starting Journal Service...
[   10.427565] systemd[1]: Started Journal Service.
[   11.702720] EXT4-fs (hda2): re-mounted. Opts: acl,user_xattr
[   12.600208] systemd-udevd[202]: starting version 195
[   12.880398] systemd-journald[177]: Received SIGUSR1
[   13.984752] [drm:intel_sdvo_detect], [CONNECTOR:61:VGA-2]
[   13.984818] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   13.988183] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[   14.033559] [drm:intel_sdvo_detect], SDVO response 0 0 [2]
[   14.033578] [drm:intel_tv_detect], [CONNECTOR:62:SVIDEO-4] force=0
[   14.240707] [drm:intel_crtc_set_config], [CRTC:3] [FB:95] #connectors=1 (x y) (0 0)
[   14.240723] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[   14.240734] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:VGA-1] to [CRTC:3]
[   16.235733] pci 0000:00:1e.0: setting latency timer to 64
[   16.563532] Adding 4192252k swap on /dev/hda1.  Priority:-1 extents:1 across:4192252k 
[   19.656352] systemd-logind[338]: Watching system buttons on /dev/input/event1 (Power Button)
[   19.657042] systemd-logind[338]: Watching system buttons on /dev/input/event0 (Power Button)
[   20.734394] NET: Registered protocol family 10
[   24.064125] [drm:intel_sdvo_detect], [CONNECTOR:61:VGA-2]
[   24.064150] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   24.067317] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[   24.121594] [drm:intel_sdvo_detect], SDVO response 0 0 [2]
[   24.121613] [drm:intel_tv_detect], [CONNECTOR:62:SVIDEO-4] force=0
[   31.783654] sky2 0000:02:00.0 eth0: enabling interface
[   31.783996] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   34.144079] [drm:intel_sdvo_detect], [CONNECTOR:61:VGA-2]
[   34.144104] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   34.147271] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[   34.206036] [drm:intel_sdvo_detect], SDVO response 0 0 [2]
[   34.206055] [drm:intel_tv_detect], [CONNECTOR:62:SVIDEO-4] force=0
[   34.219216] sky2 0000:02:00.0 eth0: Link is up at 1000 Mbps, full duplex, flow control both
[   34.219457] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   44.224086] [drm:intel_sdvo_detect], [CONNECTOR:61:VGA-2]
[   44.224112] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   44.227279] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[   44.281539] [drm:intel_sdvo_detect], SDVO response 0 0 [2]
[   44.281557] [drm:intel_tv_detect], [CONNECTOR:62:SVIDEO-4] force=0

--------------060306050801040109040806--
