Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbaKXIvH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 03:51:07 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:61369 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaKXIvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 03:51:04 -0500
Date: Mon, 24 Nov 2014 00:50:59 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Dudley Du <dudley.dulixin@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 00/19] input: cyapa: instruction of cyapa patches
Message-ID: <20141124085059.GA15770@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Dudley Du <dudley.dulixin@gmail.com>, linux-kernel@vger.kernel.org
References: <1416386271-28167-1-git-send-email-dudley.dulixin@gmail.com>
 <20141121085611.GA21999@hudson.localdomain>
 <000001d00793$9d756d90$d86048b0$@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
In-Reply-To: <000001d00793$9d756d90$d86048b0$@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Dudley,

On Mon, Nov 24, 2014 at 11:06:05AM +0800, Dudley Du wrote:
> Jeremiah,
> 
> Thank you very much for your information.
> I will look into this issue.
> Could you send me the system log if possible when you encounter this issue.
> 
> Thanks
> Dudley
> 

I did a clean reboot, the touch pad worked, then a suspend and resume,
the touchpad quit working.  Attached is the dmesg after this sequence.
There is an oops with a trace in there that looks interesting...

[]

-- 
- Jeremiah Mahler

--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=20141124-dmesg

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.18.0-rc5-next-20141121 (jeri@newt) (gcc version 4.9.2 (Debian 4.9.2-2) ) #50 SMP Fri Nov 21 01:17:40 PST 2014
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.18.0-rc5-next-20141121 root=UUID=e5fd0a8b-e57d-428c-831e-3aff30526800 ro quiet
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000002ffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000030000-0x000000000003ffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000040000-0x000000000009e3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000000efffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000f00000-0x0000000000ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000001000000-0x000000007bf79fff] usable
[    0.000000] BIOS-e820: [mem 0x000000007bf7a000-0x000000007e9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f0000000-0x00000000f3ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed19fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed84000-0x00000000fed84fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x00000001005fffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Acer Peppy, BIOS          04/30/2014
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x100600 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-back
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask 7F80000000 write-back
[    0.000000]   1 base 007C800000 mask 7FFF800000 uncachable
[    0.000000]   2 base 007D000000 mask 7FFF000000 uncachable
[    0.000000]   3 base 007E000000 mask 7FFE000000 uncachable
[    0.000000]   4 base 00D0000000 mask 7FF0000000 write-combining
[    0.000000]   5 base 00FF800000 mask 7FFF800000 uncachable
[    0.000000]   6 base 0100000000 mask 7F00000000 write-back
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: last_pfn = 0x7bf7a max_arch_pfn = 0x400000000
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01b0f000, 0x01b0ffff] PGTABLE
[    0.000000] BRK [0x01b10000, 0x01b10fff] PGTABLE
[    0.000000] BRK [0x01b11000, 0x01b11fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x100400000-0x1005fffff]
[    0.000000]  [mem 0x100400000-0x1005fffff] page 2M
[    0.000000] BRK [0x01b12000, 0x01b12fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x100000000-0x1003fffff]
[    0.000000]  [mem 0x100000000-0x1003fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x00efffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x00dfffff] page 2M
[    0.000000]  [mem 0x00e00000-0x00efffff] page 4k
[    0.000000] BRK [0x01b13000, 0x01b13fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x01000000-0x7bf79fff]
[    0.000000]  [mem 0x01000000-0x7bdfffff] page 2M
[    0.000000]  [mem 0x7be00000-0x7bf79fff] page 4k
[    0.000000] RAMDISK: [mem 0x3544e000-0x36a1efff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FDBB0 000024 (v02 CORE  )
[    0.000000] ACPI: XSDT 0x000000007BF840E0 000054 (v01 CORE   COREBOOT 00000000 CORE 00000000)
[    0.000000] ACPI: FACP 0x000000007BF88690 0000F4 (v03 CORE   COREBOOT 00000000 CORE 00000001)
[    0.000000] ACPI: DSDT 0x000000007BF84250 004431 (v02 COREv4 COREBOOT 20110725 INTL 20090123)
[    0.000000] ACPI: FACS 0x000000007BF84210 000040
[    0.000000] ACPI: HPET 0x000000007BF88790 000038 (v01 CORE   COREBOOT 00000000 CORE 00000000)
[    0.000000] ACPI: APIC 0x000000007BF887D0 00005C (v01 CORE   COREBOOT 00000000 CORE 00000000)
[    0.000000] ACPI: MCFG 0x000000007BF88830 00003C (v01 CORE   COREBOOT 00000000 CORE 00000000)
[    0.000000] ACPI: SSDT 0x000000007BF89730 0008A0 (v02 CORE   COREBOOT 0000002A CORE 0000002A)
[    0.000000] ACPI: SSDT 0x000000007BF89FD0 00005C (v02 CORE   COREBOOT 0000002A CORE 0000002A)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x00000001005fffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x1005fa000-0x1005fdfff]
[    0.000000]  [ffffea0000000000-ffffea00041fffff] PMD -> [ffff880079800000-ffff88007b9fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x1005fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0002ffff]
[    0.000000]   node   0: [mem 0x00040000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0x00efffff]
[    0.000000]   node   0: [mem 0x01000000-0x7bf79fff]
[    0.000000]   node   0: [mem 0x100000000-0x1005fffff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x1005fffff]
[    0.000000] On node 0 totalpages: 508935
[    0.000000]   DMA zone: 59 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3725 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7870 pages used for memmap
[    0.000000]   DMA32 zone: 503674 pages, LIFO batch:31
[    0.000000]   Normal zone: 24 pages used for memmap
[    0.000000]   Normal zone: 1536 pages, LIFO batch:0
[    0.000000] Reserving Intel graphics stolen memory at 0x7ca00000-0x7e9fffff
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x02] enabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-39
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x00030000-0x0003ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009efff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x00f00000-0x00ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0x7bf7a000-0x7e9fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x7ea00000-0xefffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf0000000-0xf3ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf4000000-0xfed0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed10000-0xfed19fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1a000-0xfed83fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed84000-0xfed84fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed85000-0xffffffff]
[    0.000000] e820: [mem 0x7ea00000-0xefffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 31 pages/cpu @ffff880100200000 s87104 r8192 d31680 u1048576
[    0.000000] pcpu-alloc: s87104 r8192 d31680 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 500961
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.18.0-rc5-next-20141121 root=UUID=e5fd0a8b-e57d-428c-831e-3aff30526800 ro quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x3, cntxt size 0x240 using standard form
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 1900572K/2035740K available (5378K kernel code, 1028K rwdata, 1832K rodata, 1224K init, 844K bss, 135168K reserved, 0K cma-reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=2.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=2
[    0.000000] NR_IRQS:33024 nr_irqs:512 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 1396.798 MHz processor
[    0.000045] Calibrating delay loop (skipped), value calculated using timer frequency.. 2793.59 BogoMIPS (lpj=5587192)
[    0.000049] pid_max: default: 32768 minimum: 301
[    0.000058] ACPI: Core revision 20140926
[    0.004314] ACPI: All ACPI Tables successfully acquired
[    0.008090] Security Framework initialized
[    0.008100] AppArmor: AppArmor disabled by boot time parameter
[    0.008102] Yama: becoming mindful.
[    0.008343] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.008976] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.009255] Mount-cache hash table entries: 4096 (order: 3, 32768 bytes)
[    0.009261] Mountpoint-cache hash table entries: 4096 (order: 3, 32768 bytes)
[    0.009551] Initializing cgroup subsys memory
[    0.009558] Initializing cgroup subsys devices
[    0.009562] Initializing cgroup subsys freezer
[    0.009565] Initializing cgroup subsys net_cls
[    0.009568] Initializing cgroup subsys blkio
[    0.009571] Initializing cgroup subsys perf_event
[    0.009574] Initializing cgroup subsys net_prio
[    0.009609] CPU: Physical Processor ID: 0
[    0.009610] CPU: Processor Core ID: 0
[    0.010965] mce: CPU supports 7 MCE banks
[    0.010984] CPU0: Thermal monitoring enabled (TM1)
[    0.011137] Freeing SMP alternatives memory: 20K (ffffffff81a35000 - ffffffff81a3a000)
[    0.012413] ftrace: allocating 21892 entries in 86 pages
[    0.026029] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.065711] smpboot: CPU0: Intel(R) Celeron(R) 2955U @ 1.40GHz (fam: 06, model: 45, stepping: 01)
[    0.065720] TSC deadline timer enabled
[    0.065751] Performance Events: PEBS fmt2+, 16-deep LBR, Haswell events, full-width counters, Intel PMU driver.
[    0.065782] ... version:                3
[    0.065783] ... bit width:              48
[    0.065784] ... generic registers:      8
[    0.065786] ... value mask:             0000ffffffffffff
[    0.065787] ... max period:             0000ffffffffffff
[    0.065788] ... fixed-purpose events:   3
[    0.065789] ... event mask:             00000007000000ff
[    0.067751] x86: Booting SMP configuration:
[    0.067754] .... node  #0, CPUs:      #1
[    0.082303] x86: Booted up 1 node, 2 CPUs
[    0.082307] smpboot: Total of 2 processors activated (5587.19 BogoMIPS)
[    0.082341] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.084341] devtmpfs: initialized
[    0.088461] pinctrl core: initialized pinctrl subsystem
[    0.088517] RTC time:  8:42:08, date: 11/24/14
[    0.088649] NET: Registered protocol family 16
[    0.102314] cpuidle: using governor ladder
[    0.118319] cpuidle: using governor menu
[    0.118392] ACPI: bus type PCI registered
[    0.118395] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.118467] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000)
[    0.118470] PCI: MMCONFIG at [mem 0xf0000000-0xf3ffffff] reserved in E820
[    0.118586] PCI: Using configuration type 1 for base access
[    0.134846] ACPI: Added _OSI(Module Device)
[    0.134849] ACPI: Added _OSI(Processor Device)
[    0.134851] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.134853] ACPI: Added _OSI(Processor Aggregator Device)
[    0.138445] ACPI: Interpreter enabled
[    0.138453] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140926/hwxface-580)
[    0.138459] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140926/hwxface-580)
[    0.138475] ACPI: (supports S0 S3 S4 S5)
[    0.138477] ACPI: Using IOAPIC for interrupt routing
[    0.138506] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.143777] ACPI: Power Resource [TNP0] (off)
[    0.143826] ACPI: Power Resource [TNP1] (on)
[    0.144482] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.144490] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.144543] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME AER PCIeCapability]
[    0.144673] acpi PNP0A08:00: ignoring host bridge window [mem 0x000cc000-0x000cffff] (conflicts with Video ROM [mem 0x000c0000-0x000cebff])
[    0.144678] acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-3f] only partially covers this bridge
[    0.144911] PCI host bridge to bus 0000:00
[    0.144915] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.144918] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.144920] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.144922] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.144924] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000c3fff]
[    0.144926] pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000c7fff]
[    0.144928] pci_bus 0000:00: root bus resource [mem 0x000c8000-0x000cbfff]
[    0.144930] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
[    0.144932] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.144935] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.144937] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    0.144939] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
[    0.144941] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
[    0.144943] pci_bus 0000:00: root bus resource [mem 0x000e8000-0x000ebfff]
[    0.144945] pci_bus 0000:00: root bus resource [mem 0x000ec000-0x000effff]
[    0.144947] pci_bus 0000:00: root bus resource [mem 0x000f0000-0x000fffff]
[    0.144949] pci_bus 0000:00: root bus resource [mem 0x7ea00001-0xfebfffff]
[    0.144951] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
[    0.144962] pci 0000:00:00.0: [8086:0a04] type 00 class 0x060000
[    0.145101] pci 0000:00:02.0: [8086:0a06] type 00 class 0x030000
[    0.145117] pci 0000:00:02.0: reg 0x10: [mem 0xe0000000-0xe03fffff 64bit]
[    0.145127] pci 0000:00:02.0: reg 0x18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.145134] pci 0000:00:02.0: reg 0x20: [io  0x1800-0x183f]
[    0.145260] pci 0000:00:03.0: [8086:0a0c] type 00 class 0x040300
[    0.145272] pci 0000:00:03.0: reg 0x10: [mem 0xe0510000-0xe0513fff 64bit]
[    0.145423] pci 0000:00:14.0: [8086:9c31] type 00 class 0x0c0330
[    0.145444] pci 0000:00:14.0: reg 0x10: [mem 0xe0500000-0xe050ffff 64bit]
[    0.145514] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.145570] pci 0000:00:14.0: System wakeup disabled by ACPI
[    0.145628] pci 0000:00:15.0: [8086:9c60] type 00 class 0x080102
[    0.145647] pci 0000:00:15.0: reg 0x10: [mem 0xe0518000-0xe0518fff]
[    0.145659] pci 0000:00:15.0: reg 0x14: [mem 0xe0519000-0xe0519fff]
[    0.145827] pci 0000:00:15.1: [8086:9c61] type 00 class 0x0c8000
[    0.145847] pci 0000:00:15.1: reg 0x10: [mem 0xe051a000-0xe051afff]
[    0.145858] pci 0000:00:15.1: reg 0x14: [mem 0xe051b000-0xe051bfff]
[    0.146026] pci 0000:00:15.2: [8086:9c62] type 00 class 0x0c8000
[    0.146044] pci 0000:00:15.2: reg 0x10: [mem 0xe051c000-0xe051cfff]
[    0.146056] pci 0000:00:15.2: reg 0x14: [mem 0xe051d000-0xe051dfff]
[    0.146234] pci 0000:00:1b.0: [8086:9c20] type 00 class 0x040300
[    0.146252] pci 0000:00:1b.0: reg 0x10: [mem 0xe0514000-0xe0517fff 64bit]
[    0.146336] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.146393] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.146446] pci 0000:00:1c.0: [8086:9c10] type 01 class 0x060400
[    0.146525] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.146645] pci 0000:00:1d.0: [8086:9c26] type 00 class 0x0c0320
[    0.146668] pci 0000:00:1d.0: reg 0x10: [mem 0xe051f800-0xe051fbff]
[    0.146771] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.146829] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.146886] pci 0000:00:1f.0: [8086:9c45] type 00 class 0x060100
[    0.147104] pci 0000:00:1f.2: [8086:9c03] type 00 class 0x010601
[    0.147122] pci 0000:00:1f.2: reg 0x10: [io  0x1860-0x1867]
[    0.147130] pci 0000:00:1f.2: reg 0x14: [io  0x1870-0x1873]
[    0.147139] pci 0000:00:1f.2: reg 0x18: [io  0x1868-0x186f]
[    0.147148] pci 0000:00:1f.2: reg 0x1c: [io  0x1874-0x1877]
[    0.147156] pci 0000:00:1f.2: reg 0x20: [io  0x1840-0x185f]
[    0.147165] pci 0000:00:1f.2: reg 0x24: [mem 0xe051f000-0xe051f7ff]
[    0.147208] pci 0000:00:1f.2: PME# supported from D3hot
[    0.147309] pci 0000:00:1f.3: [8086:9c22] type 00 class 0x0c0500
[    0.147326] pci 0000:00:1f.3: reg 0x10: [mem 0xe051fc00-0xe051fcff 64bit]
[    0.147349] pci 0000:00:1f.3: reg 0x20: [io  0x0400-0x041f]
[    0.147470] pci 0000:00:1f.6: [8086:9c24] type 00 class 0x118000
[    0.147504] pci 0000:00:1f.6: reg 0x10: [mem 0xe051e000-0xe051efff 64bit]
[    0.147781] pci 0000:01:00.0: [168c:0034] type 00 class 0x028000
[    0.147809] pci 0000:01:00.0: reg 0x10: [mem 0xe0400000-0xe047ffff 64bit]
[    0.147868] pci 0000:01:00.0: reg 0x30: [mem 0xe0480000-0xe048ffff pref]
[    0.147944] pci 0000:01:00.0: supports D1 D2
[    0.147946] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.154369] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.154375] pci 0000:00:1c.0:   bridge window [mem 0xe0400000-0xe04fffff]
[    0.154512] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11, disabled.
[    0.154576] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *10, disabled.
[    0.154634] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11, disabled.
[    0.154691] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15), disabled.
[    0.154749] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    0.154805] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.154862] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    0.154919] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.155668] ACPI : EC: GPE = 0x24, I/O: command/status = 0x66, data = 0x62
[    0.155811] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.155814] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.155818] vgaarb: loaded
[    0.155820] vgaarb: bridge control possible 0000:00:02.0
[    0.155912] PCI: Using ACPI for IRQ routing
[    0.157514] PCI: pci_cache_line_size set to 64 bytes
[    0.157566] e820: reserve RAM buffer [mem 0x0009e400-0x0009ffff]
[    0.157568] e820: reserve RAM buffer [mem 0x7bf7a000-0x7bffffff]
[    0.157570] e820: reserve RAM buffer [mem 0x100600000-0x103ffffff]
[    0.157765] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.157772] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.159807] Switched to clocksource hpet
[    0.166911] pnp: PnP ACPI init
[    0.167030] system 00:00: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.167034] system 00:00: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.167036] system 00:00: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.167039] system 00:00: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.167042] system 00:00: [mem 0xf0000000-0xf3ffffff] has been reserved
[    0.167044] system 00:00: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.167047] system 00:00: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.167050] system 00:00: [mem 0xfed45000-0xfed8ffff] could not be reserved
[    0.167053] system 00:00: [mem 0x00f00000-0x00ffffff] has been reserved
[    0.167057] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.167370] system 00:01: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.167374] system 00:01: Plug and Play ACPI device, IDs PNP0103 PNP0c01 (active)
[    0.167454] system 00:02: [io  0x1000-0x10fe] could not be reserved
[    0.167458] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.167491] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.167541] system 00:04: [io  0x0900-0x09fe] has been reserved
[    0.167544] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.167594] system 00:05: [io  0x0200] has been reserved
[    0.167596] system 00:05: [io  0x0204] has been reserved
[    0.167599] system 00:05: [io  0x0800-0x087f] has been reserved
[    0.167601] system 00:05: [io  0x0880-0x08ff] has been reserved
[    0.167604] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.167651] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.167694] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    0.167743] pnp 00:08: Plug and Play ACPI device, IDs IFX0102 PNP0c31 (active)
[    0.167868] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.168007] pnp: PnP ACPI: found 10 devices
[    0.174967] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.174974] pci 0000:00:1c.0:   bridge window [mem 0xe0400000-0xe04fffff]
[    0.174985] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.174987] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.174989] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.174991] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000c3fff]
[    0.174993] pci_bus 0000:00: resource 8 [mem 0x000c4000-0x000c7fff]
[    0.174995] pci_bus 0000:00: resource 9 [mem 0x000c8000-0x000cbfff]
[    0.174998] pci_bus 0000:00: resource 10 [mem 0x000d0000-0x000d3fff]
[    0.175000] pci_bus 0000:00: resource 11 [mem 0x000d4000-0x000d7fff]
[    0.175002] pci_bus 0000:00: resource 12 [mem 0x000d8000-0x000dbfff]
[    0.175004] pci_bus 0000:00: resource 13 [mem 0x000dc000-0x000dffff]
[    0.175006] pci_bus 0000:00: resource 14 [mem 0x000e0000-0x000e3fff]
[    0.175008] pci_bus 0000:00: resource 15 [mem 0x000e4000-0x000e7fff]
[    0.175010] pci_bus 0000:00: resource 16 [mem 0x000e8000-0x000ebfff]
[    0.175012] pci_bus 0000:00: resource 17 [mem 0x000ec000-0x000effff]
[    0.175014] pci_bus 0000:00: resource 18 [mem 0x000f0000-0x000fffff]
[    0.175016] pci_bus 0000:00: resource 19 [mem 0x7ea00001-0xfebfffff]
[    0.175018] pci_bus 0000:00: resource 20 [mem 0xfed40000-0xfed44fff]
[    0.175021] pci_bus 0000:01: resource 1 [mem 0xe0400000-0xe04fffff]
[    0.175077] NET: Registered protocol family 2
[    0.175276] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
[    0.175329] TCP bind hash table entries: 16384 (order: 6, 262144 bytes)
[    0.175377] TCP: Hash tables configured (established 16384 bind 16384)
[    0.175401] TCP: reno registered
[    0.175409] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.175421] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.175491] NET: Registered protocol family 1
[    0.175512] pci 0000:00:02.0: Video device with shadowed ROM
[    0.176067] PCI: CLS 64 bytes, default 64
[    0.176128] Unpacking initramfs...
[    0.779548] Freeing initrd memory: 22340K (ffff88003544e000 - ffff880036a1f000)
[    0.779562] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.779566] software IO TLB [mem 0x75800000-0x79800000] (64MB) mapped at [ffff880075800000-ffff8800797fffff]
[    0.779762] RAPL PMU detected, hw unit 2^-14 Joules, API unit is 2^-32 Joules, 4 fixed counters 655360 ms ovfl timer
[    0.779836] microcode: CPU0 sig=0x40651, pf=0x40, revision=0x15
[    0.779844] microcode: CPU1 sig=0x40651, pf=0x40, revision=0x15
[    0.779907] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.780303] futex hash table entries: 512 (order: 3, 32768 bytes)
[    0.780349] audit: initializing netlink subsys (disabled)
[    0.780368] audit: type=2000 audit(1416818528.780:1): initialized
[    0.780823] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.780861] zpool: loaded
[    0.780866] zbud: loaded
[    0.781053] VFS: Disk quotas dquot_6.5.2
[    0.781073] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.781581] alg: No test for stdrng (krng)
[    0.781613] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.781653] io scheduler noop registered
[    0.781658] io scheduler deadline registered
[    0.781671] io scheduler cfq registered (default)
[    0.782061] aer 0000:00:1c.0:pcie02: service driver aer loaded
[    0.782086] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    0.782088] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    0.782093] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    0.782104] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.782129] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.782157] intel_idle: MWAIT substates: 0x11142120
[    0.782158] intel_idle: v0.4 model 0x45
[    0.782160] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.782373] GHES: HEST is not enabled!
[    0.782468] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.783089] Linux agpgart interface v0.103
[    0.783195] error detecting cacheinfo..cpu0
[    0.783299] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    0.783300] i8042: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    0.784674] i8042: Warning: Keylock active
[    0.784864] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.785040] mousedev: PS/2 mouse device common for all mice
[    0.785098] rtc_cmos 00:03: RTC can wake from S4
[    0.785267] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    0.785297] rtc_cmos 00:03: alarms up to one month, 242 bytes nvram, hpet irqs
[    0.785311] Intel P-state driver initializing.
[    0.785440] ledtrig-cpu: registered to indicate activity on CPUs
[    0.785648] AMD IOMMUv2 driver by Joerg Roedel <joerg.roedel@amd.com>
[    0.785650] AMD IOMMUv2 functionality not available on this system
[    0.785878] TCP: cubic registered
[    0.785978] NET: Registered protocol family 10
[    0.786398] mip6: Mobile IPv6
[    0.786405] NET: Registered protocol family 17
[    0.786417] mpls_gso: MPLS GSO support
[    0.787325] registered taskstats version 1
[    0.787946]   Magic number: 6:366:726
[    0.788058] rtc_cmos 00:03: setting system clock to 2014-11-24 08:42:09 UTC (1416818529)
[    0.788211] PM: Hibernation image not present or could not be loaded.
[    0.790172] Freeing unused kernel memory: 1224K (ffffffff81903000 - ffffffff81a35000)
[    0.790175] Write protecting the kernel read-only data: 8192k
[    0.794437] Freeing unused kernel memory: 756K (ffff880001543000 - ffff880001600000)
[    0.795572] Freeing unused kernel memory: 216K (ffff8800017ca000 - ffff880001800000)
[    0.795690] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    0.813536] systemd-udevd[62]: starting version 215
[    0.813972] random: systemd-udevd urandom read with 2 bits of entropy available
[    0.832456] sdhci: Secure Digital Host Controller Interface driver
[    0.832461] sdhci: Copyright(c) Pierre Ossman
[    0.834234] thermal LNXTHERM:00: registered as thermal_zone0
[    0.834239] ACPI: Thermal Zone [THRM] (41 C)
[    0.843216] SCSI subsystem initialized
[    0.845725] libata version 3.00 loaded.
[    0.846784] ahci 0000:00:1f.2: version 3.0
[    0.846987] ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
[    0.847005] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 2 ports 6 Gbps 0x1 impl SATA mode
[    0.847009] ahci 0000:00:1f.2: flags: 64bit ncq ilck stag pm led clo only pio slum part deso sadm sds apst 
[    0.849805] scsi host0: ahci
[    0.854265] scsi host1: ahci
[    0.854357] ata1: SATA max UDMA/133 abar m2048@0xe051f000 port 0xe051f100 irq 41
[    0.854361] ata2: DUMMY
[    1.171719] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.171981] ata1.00: ATA-10: SC2 M2 SSD, S9FM01.7, max UDMA/100
[    1.171986] ata1.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.172267] ata1.00: configured for UDMA/100
[    1.172448] scsi 0:0:0:0: Direct-Access     ATA      SC2 M2 SSD       01.7 PQ: 0 ANSI: 5
[    1.174750] sd 0:0:0:0: [sda] 234441648 512-byte logical blocks: (120 GB/111 GiB)
[    1.174828] sd 0:0:0:0: [sda] Write Protect is off
[    1.174833] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.174852] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.175298]  sda: sda1 sda2 < sda5 >
[    1.175796] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.176514] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.287653] PM: Starting manual resume from disk
[    1.287659] PM: Hibernation image partition 8:5 present
[    1.287661] PM: Looking for hibernation image.
[    1.287866] PM: Image not found (code -22)
[    1.287868] PM: Hibernation image not present or could not be loaded.
[    1.340133] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    1.668889] fuse init (API version 7.23)
[    1.700727] systemd-udevd[160]: starting version 215
[    1.775547] tsc: Refined TSC clocksource calibration: 1396.767 MHz
[    1.825229] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
[    1.844325] systemd-journald[140]: Received request to flush runtime journal from PID 1
[    1.869216] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1
[    1.869459] ACPI: Lid Switch [LID0]
[    1.869538] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input2
[    1.869543] ACPI: Power Button [PWRB]
[    1.869603] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input3
[    1.869607] ACPI: Sleep Button [TPAD]
[    1.869663] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:01/input/input4
[    1.869666] ACPI: Sleep Button [TSCR]
[    1.869745] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input5
[    1.869748] ACPI: Power Button [PWRF]
[    1.888916] ACPI: AC Adapter [AC] (on-line)
[    1.890188] ACPI: Battery Slot [BAT0] (battery present)
[    1.896532] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    1.896696] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input6
[    1.898266] tpm_tis tpm_tis: 1.2 TPM (device-id 0xB, rev-id 16)
[    1.924607] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    1.924898] i801_smbus 0000:00:1f.3: SMBus using PCI interrupt
[    1.935441] input: PC Speaker as /devices/platform/pcspkr/input/input7
[    1.944716] ACPI: bus type USB registered
[    1.944758] usbcore: registered new interface driver usbfs
[    1.944775] usbcore: registered new interface driver hub
[    1.944801] usbcore: registered new device driver usb
[    1.954045] [drm] Initialized drm 1.1.0 20060810
[    1.971525] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.971631] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
[    1.971730] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    1.971833] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.971836] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.971838] usb usb1: Product: xHCI Host Controller
[    1.971840] usb usb1: Manufacturer: Linux 3.18.0-rc5-next-20141121 xhci-hcd
[    1.971842] usb usb1: SerialNumber: 0000:00:14.0
[    1.972055] hub 1-0:1.0: USB hub found
[    1.972068] hub 1-0:1.0: 8 ports detected
[    1.972402] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.972407] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
[    1.972447] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
[    1.972449] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.972452] usb usb2: Product: xHCI Host Controller
[    1.972454] usb usb2: Manufacturer: Linux 3.18.0-rc5-next-20141121 xhci-hcd
[    1.972456] usb usb2: SerialNumber: 0000:00:14.0
[    1.972599] hub 2-0:1.0: USB hub found
[    1.972609] hub 2-0:1.0: 4 ports detected
[    1.986251] alg: No test for crc32 (crc32-pclmul)
[    2.009863] __add_probed_i2c_device failed to register device 1-4a
[    2.015824] sound hdaudioC1D0: autoconfig: line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:speaker
[    2.015830] sound hdaudioC1D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    2.015832] sound hdaudioC1D0:    hp_outs=1 (0x21/0x0/0x0/0x0/0x0)
[    2.015834] sound hdaudioC1D0:    mono: mono_out=0x0
[    2.015836] sound hdaudioC1D0:    inputs:
[    2.015839] sound hdaudioC1D0:      Internal Mic=0x1a
[    2.015842] sound hdaudioC1D0:      Mic=0x19
[    2.025441] platform chromeos_laptop: Driver chromeos_laptop requests probe deferral
[    2.028627] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/sound/card1/hdaudioC1D0/input8
[    2.031756] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card1/input9
[    2.031846] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card1/input10
[    2.050252] cfg80211: Calling CRDA to update world regulatory domain
[    2.094419] __add_probed_i2c_device failed to register device 1-4a
[    2.094435] platform chromeos_laptop: Driver chromeos_laptop requests probe deferral
[    2.100692] intel_rapl: Found RAPL domain package
[    2.100697] intel_rapl: Found RAPL domain core
[    2.100699] intel_rapl: Found RAPL domain uncore
[    2.100701] intel_rapl: Found RAPL domain dram
[    2.103203] iTCO_vendor_support: vendor-support=0
[    2.105380] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    2.105428] iTCO_wdt: Found a Lynx Point_LP TCO device (Version=2, TCOBASE=0x1060)
[    2.105543] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    2.106465] __add_probed_i2c_device failed to register device 1-4a
[    2.106477] platform chromeos_laptop: Driver chromeos_laptop requests probe deferral
[    2.111523] input: Cypress APA Trackpad (cyapa) as /devices/pci0000:00/0000:00:15.1/i2c-0/0-0067/input/input11
[    2.113048] __add_probed_i2c_device failed to register device 1-4a
[    2.113061] platform chromeos_laptop: Driver chromeos_laptop requests probe deferral
[    2.158871] [drm] Memory usable by graphics device = 2048M
[    2.158876] [drm] Replacing VGA console driver
[    2.160335] Console: switching to colour dummy device 80x25
[    2.161651] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    2.161655] [drm] Driver supports precise vblank timestamp query.
[    2.161741] [drm] applying backlight present quirk
[    2.161765] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    2.166721] tpm_inf_pnp 00:08: Found TPM with ID IFX0102
[    2.186204] cfg80211: World regulatory domain updated:
[    2.186209] cfg80211:  DFS Master region: unset
[    2.186211] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[    2.186214] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[    2.186217] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[    2.186219] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
[    2.186220] cfg80211:   (5170000 KHz - 5250000 KHz @ 160000 KHz), (N/A, 2000 mBm), (N/A)
[    2.186223] cfg80211:   (5250000 KHz - 5330000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
[    2.186224] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
[    2.186226] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
[    2.186228] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
[    2.226412] Adding 4069372k swap on /dev/sda5.  Priority:-1 extents:1 across:4069372k SSFS
[    2.236157] [drm] Initialized i915 1.6.0 20141107 for 0000:00:02.0 on minor 0
[    2.237581] fbcon: inteldrmfb (fb0) is primary device
[    2.238400] __add_probed_i2c_device failed to register device 1-4a
[    2.238401] chromeos_laptop_probe: Ran out of tries for device.
[    2.256985] input: HDA Intel HDMI HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:03.0/sound/card0/input12
[    2.257068] input: HDA Intel HDMI HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:03.0/sound/card0/input13
[    2.257139] input: HDA Intel HDMI HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:03.0/sound/card0/input14
[    2.270428] ath: phy0: ASPM enabled: 0x43
[    2.270430] ath: EEPROM regdomain: 0x6c
[    2.270431] ath: EEPROM indicates we should expect a direct regpair map
[    2.270433] ath: Country alpha2 being used: 00
[    2.270433] ath: Regpair used: 0x6c
[    2.275245] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[    2.275576] ieee80211 phy0: Atheros AR9462 Rev:2 mem=0xffffc90004980000, irq=16
[    2.283501] usb 1-3: new high-speed USB device number 2 using xhci_hcd
[    2.292068] RPC: Registered named UNIX socket transport module.
[    2.292069] RPC: Registered udp transport module.
[    2.292070] RPC: Registered tcp transport module.
[    2.292070] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    2.302509] FS-Cache: Loaded
[    2.356359] FS-Cache: Netfs 'nfs' registered for caching
[    2.395839] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    2.536811] usb 1-3: New USB device found, idVendor=1bcf, idProduct=2c67
[    2.536813] usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.536814] usb 1-3: Product: HD WebCam
[    2.536816] usb 1-3: Manufacturer: NC.21411.024409008DCLM0001
[    2.612620] media: Linux media interface: v0.10
[    2.626063] Linux video capture interface: v2.00
[    2.643357] uvcvideo: Found UVC 1.00 device HD WebCam (1bcf:2c67)
[    2.652139] input: HD WebCam as /devices/pci0000:00/0000:00:14.0/usb1/1-3/1-3:1.0/input/input15
[    2.652237] usbcore: registered new interface driver uvcvideo
[    2.652238] USB Video Class driver (1.1.1)
[    2.775489] usb 1-4: new full-speed USB device number 3 using xhci_hcd
[    2.775652] Switched to clocksource tsc
[    2.905355] usb 1-4: language id specifier not provided by device, defaulting to English
[    2.907453] usb 1-4: New USB device found, idVendor=0489, idProduct=e056
[    2.907455] usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.943301] Bluetooth: Core ver 2.19
[    2.943319] NET: Registered protocol family 31
[    2.943320] Bluetooth: HCI device and connection manager initialized
[    2.943323] Bluetooth: HCI socket layer initialized
[    2.943325] Bluetooth: L2CAP socket layer initialized
[    2.943335] Bluetooth: SCO socket layer initialized
[    2.946800] usbcore: registered new interface driver btusb
[    2.948917] usbcore: registered new interface driver ath3k
[    3.307470] Console: switching to colour frame buffer device 170x48
[    3.311164] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    3.311166] i915 0000:00:02.0: registered panic notifier
[    3.330492] systemd-journald[140]: Received request to flush runtime journal from PID 1
[    3.615377] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    3.615381] Bluetooth: BNEP filters: protocol multicast
[    3.615387] Bluetooth: BNEP socket layer initialized
[    4.564020] random: nonblocking pool is initialized
[    7.436824] wlan0: authenticate with 00:1a:70:5a:6e:0b
[    7.448022] wlan0: send auth to 00:1a:70:5a:6e:0b (try 1/3)
[    7.450079] wlan0: authenticated
[    7.450415] ath9k 0000:01:00.0 wlan0: disabling HT as WMM/QoS is not supported by the AP
[    7.450419] ath9k 0000:01:00.0 wlan0: disabling VHT as WMM/QoS is not supported by the AP
[    7.450690] wlan0: associate with 00:1a:70:5a:6e:0b (try 1/3)
[    7.453088] wlan0: RX AssocResp from 00:1a:70:5a:6e:0b (capab=0x401 status=0 aid=8)
[    7.453184] wlan0: associated
[   21.081101] PM: Syncing filesystems ... done.
[   21.102575] PM: Preparing system for mem sleep
[   21.102716] Freezing user space processes ... (elapsed 0.001 seconds) done.
[   21.104134] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
[   21.105392] PM: Entering mem sleep
[   21.105412] Suspending console(s) (use no_console_suspend to debug)
[   21.105690] wlan0: deauthenticating from 00:1a:70:5a:6e:0b by local choice (Reason: 3=DEAUTH_LEAVING)
[   21.114830] cfg80211: Calling CRDA to update world regulatory domain
[   21.212603] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[   21.212796] sd 0:0:0:0: [sda] Stopping disk
[   21.518754] PM: suspend of devices complete after 413.236 msecs
[   21.556533] PM: late suspend of devices complete after 37.779 msecs
[   21.557151] xhci_hcd 0000:00:14.0: System wakeup enabled by ACPI
[   21.572596] PM: noirq suspend of devices complete after 16.061 msecs
[   21.572878] ACPI: Preparing to enter system sleep state S3
[   21.573253] PM: Saving platform NVS memory
[   21.573254] Disabling non-boot CPUs ...
[   21.573299] intel_pstate CPU 1 exiting
[   21.573498] Broke affinity for irq 21
[   21.573509] Broke affinity for irq 41
[   21.573510] Broke affinity for irq 42
[   21.574517] kvm: disabling virtualization on CPU1
[   21.574528] smpboot: CPU 1 is now offline
[   21.576137] ACPI: Low-level resume complete
[   21.576200] PM: Restoring platform NVS memory
[   21.576582] Enabling non-boot CPUs ...
[   21.576650] x86: Booting SMP configuration:
[   21.576651] smpboot: Booting Node 0 Processor 1 APIC 0x2
[   21.589127] kvm: enabling virtualization on CPU1
[   21.591506] CPU1 is up
[   21.593253] ACPI: Waking up from system sleep state S3
[   21.654266] xhci_hcd 0000:00:14.0: System wakeup disabled by ACPI
[   21.654374] PM: noirq resume of devices complete after 60.962 msecs
[   21.678090] PM: early resume of devices complete after 23.694 msecs
[   21.678665] rtc_cmos 00:03: System wakeup disabled by ACPI
[   21.679279] ath: phy0: ASPM enabled: 0x43
[   21.694021] sd 0:0:0:0: [sda] Starting disk
[   21.803878] ------------[ cut here ]------------
[   21.803886] WARNING: CPU: 0 PID: 901 at kernel/irq/manage.c:444 enable_irq+0x3a/0x80()
[   21.803886] Unbalanced enable for IRQ 0
[   21.803927] Modules linked in: binfmt_misc bnep ecb ath3k btusb bluetooth uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common videodev media nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace fscache sunrpc arc4 ath9k snd_hda_codec_hdmi ath9k_common ath9k_hw ath tpm_infineon mac80211 i915 joydev x86_pkg_temp_thermal iTCO_wdt intel_powerclamp cyapa iTCO_vendor_support intel_rapl iosf_mbi coretemp kvm_intel kvm cfg80211 snd_hda_codec_realtek snd_hda_codec_generic chromeos_laptop crct10dif_pclmul crc32_pclmul i2c_algo_bit crc32c_intel snd_hda_intel drm_kms_helper xhci_pci xhci_hcd ghash_clmulni_intel snd_hda_controller snd_hda_codec cryptd rfkill drm usbcore evdev pcspkr snd_hwdep serio_raw snd_pcm i2c_i801 shpchp snd_timer usb_common lpc_ich snd tpm_tis mfd_core video i2c_designware_pci
[   21.803941]  tpm battery ac soundcore i2c_designware_platform i2c_designware_core i2c_core processor button fuse autofs4 ext4 crc16 mbcache jbd2 sg sd_mod ahci libahci libata scsi_mod fan thermal thermal_sys sdhci_acpi sdhci mmc_core
[   21.803945] CPU: 0 PID: 901 Comm: systemd-sleep Not tainted 3.18.0-rc5-next-20141121 #50
[   21.803946] Hardware name: Acer Peppy, BIOS          04/30/2014
[   21.803949]  0000000000000000 ffffffff81725091 ffffffff81535c6c ffff8800740cbc78
[   21.803951]  ffffffff81069f61 ffff880100405400 0000000000000000 ffff88006c9c1c20
[   21.803953]  ffff88006ae73220 0000000000000010 ffffffff81069fda ffffffff8171bbb8
[   21.803953] Call Trace:
[   21.803959]  [<ffffffff81535c6c>] ? dump_stack+0x40/0x50
[   21.803964]  [<ffffffff81069f61>] ? warn_slowpath_common+0x81/0xb0
[   21.803967]  [<ffffffff81069fda>] ? warn_slowpath_fmt+0x4a/0x50
[   21.803969]  [<ffffffff810b9792>] ? __irq_get_desc_lock+0x52/0x90
[   21.803971]  [<ffffffff810bb32a>] ? enable_irq+0x3a/0x80
[   21.803976]  [<ffffffffa0412535>] ? cyapa_resume+0x85/0xb0 [cyapa]
[   21.803984]  [<ffffffffa01c3e90>] ? i2c_device_pm_thaw+0x40/0x40 [i2c_core]
[   21.803988]  [<ffffffff813ce85a>] ? dpm_run_callback+0x4a/0x100
[   21.803991]  [<ffffffff813cedd6>] ? device_resume+0xd6/0x210
[   21.803994]  [<ffffffff813d02c9>] ? dpm_resume+0x109/0x2c0
[   21.803997]  [<ffffffff813d07cd>] ? dpm_resume_end+0xd/0x20
[   21.804000]  [<ffffffff810ae1e7>] ? suspend_devices_and_enter+0x137/0x630
[   21.804003]  [<ffffffff810aea32>] ? pm_suspend+0x352/0x3d0
[   21.804005]  [<ffffffff810ad266>] ? state_store+0x76/0xf0
[   21.804010]  [<ffffffff8122bd5c>] ? kernfs_fop_write+0x12c/0x180
[   21.804013]  [<ffffffff811b78a2>] ? vfs_write+0xb2/0x1f0
[   21.804015]  [<ffffffff811b8432>] ? SyS_write+0x42/0xb0
[   21.804018]  [<ffffffff8153b6ad>] ? system_call_fastpath+0x16/0x1b
[   21.804020] ---[ end trace 83d258439f6abe06 ]---
[   21.950207] usb 1-3: reset high-speed USB device number 2 using xhci_hcd
[   21.950304] xhci_hcd 0000:00:14.0: Setup ERROR: setup context command for slot 1.
[   21.950318] usb 1-3: hub failed to enable device, error -22
[   22.013961] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[   22.014501] ata1.00: configured for UDMA/100
[   22.061971] usb 1-3: reset high-speed USB device number 2 using xhci_hcd
[   22.061994] xhci_hcd 0000:00:14.0: Setup ERROR: setup context command for slot 1.
[   22.061997] usb 1-3: hub failed to enable device, error -22
[   22.174015] usb 1-3: reset high-speed USB device number 2 using xhci_hcd
[   22.248252] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800743acdc0
[   22.318296] PM: resume of devices complete after 640.307 msecs
[   22.318523] PM: Finishing wakeup.
[   22.318525] Restarting tasks ... 
[   22.326581] cfg80211: World regulatory domain updated:
[   22.326587] cfg80211:  DFS Master region: unset
[   22.326588] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[   22.326592] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[   22.326594] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[   22.326596] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
[   22.326598] cfg80211:   (5170000 KHz - 5250000 KHz @ 160000 KHz), (N/A, 2000 mBm), (N/A)
[   22.326600] cfg80211:   (5250000 KHz - 5330000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
[   22.326602] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
[   22.326604] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
[   22.326606] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
[   22.327163] done.
[   22.333946] usb 1-4: USB disconnect, device number 3
[   22.450841] wlan0: authenticate with 00:1a:70:5a:6e:0b
[   22.458798] wlan0: send auth to 00:1a:70:5a:6e:0b (try 1/3)
[   22.460935] wlan0: authenticated
[   22.461208] ath9k 0000:01:00.0 wlan0: disabling HT as WMM/QoS is not supported by the AP
[   22.461215] ath9k 0000:01:00.0 wlan0: disabling VHT as WMM/QoS is not supported by the AP
[   22.461907] wlan0: associate with 00:1a:70:5a:6e:0b (try 1/3)
[   22.466033] wlan0: RX AssocResp from 00:1a:70:5a:6e:0b (capab=0x401 status=0 aid=8)
[   22.466126] wlan0: associated
[   23.677715] usb 1-4: new full-speed USB device number 4 using xhci_hcd
[   23.807361] usb 1-4: language id specifier not provided by device, defaulting to English
[   23.809240] usb 1-4: New USB device found, idVendor=0489, idProduct=e056
[   23.809245] usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   23.847691] usb 1-4: USB disconnect, device number 4
[   24.117655] usb 1-4: new full-speed USB device number 5 using xhci_hcd
[   24.247363] usb 1-4: language id specifier not provided by device, defaulting to English
[   24.249285] usb 1-4: New USB device found, idVendor=0489, idProduct=e056
[   24.249292] usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3

--WIyZ46R2i8wDzkSu--
