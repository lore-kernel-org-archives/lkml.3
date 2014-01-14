Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813AbaANT0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 14:26:18 -0500
Received: from fep12.mx.upcmail.net ([62.179.121.32]:44808 "EHLO
	fep12.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbaANT0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 14:26:11 -0500
X-SourceIP: 37.49.105.23
X-Authenticated-Sender: bjoern.christoph@kabelbw.de
Date: Tue, 14 Jan 2014 20:25:32 +0100
From: bjoern <lkml@call-home.ch>
To: linux-kernel@vger.kernel.org
Subject: Kernel 3.12.x breaks video playback using XBMC
Message-ID: <20140114202532.4fa0f801@ubuntu>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.13; i686-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/kfv9i6UDJpGDGa5kkhzZwR5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/kfv9i6UDJpGDGa5kkhzZwR5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I use Ubuntu 13.10 x64. I run XBMC Alpha Git 10 using HDMI output.

I use Ubuntu kernels from mainline
(http://kernel.ubuntu.com/~kernel-ppa/mainline)

Kernel 3.8.x / 3.11.10 (and some others kernels) work fine and every
frame is rendered properly.

Problem:
Using kernel 3.12.1 / 3.12.7 (I tested only these two) video playback
skips several frames per second.

Mainboard: Intel DH61AG
BIOS: AGH6110H.86A.0106.2013.0509.1441
CPU: Intel i3-3240
Memory: 4 Gb
One SSD is being used

I am attaching logs from dmesg - there are visible differences between
3.11 and 3.12, e.g.

ACPI: \_SB_.PCI0.TPMX: can't evaluate _ADR (0x5)
ACPI: \_SB_.PCI0.PDRC: can't evaluate _ADR (0x5)
ACPI: \_SB_.PCI0.DOCK: can't evaluate _ADR (0x5)

Regards,
Bjoern
--MP_/kfv9i6UDJpGDGa5kkhzZwR5
Content-Type: text/x-log
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=kernel_3.11.10.log

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.11.10-031110-generic (apw@gomeisa) (gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #201311291453 SMP Fri Nov 29 19:54:20 UTC 2013
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.11.10-031110-generic root=UUID=7f1378fa-0837-48fa-aa07-74ee97a6170a ro quiet splash vt.handoff=7
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x0000000040003fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000040004000-0x0000000040004fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000040005000-0x00000000d5c0ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000d5c10000-0x00000000d630efff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000d630f000-0x00000000d631efff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000d631f000-0x00000000d6429fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000d642a000-0x00000000d670cfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000d670d000-0x00000000d670dfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000d670e000-0x00000000d6750fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000d6751000-0x00000000d6ffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000d7800000-0x00000000df9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011f5fffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI:                  /DH61AG, BIOS AGH6110H.86A.0106.2013.0509.1441 05/09/2013
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x11f600 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F00000000 write-back
[    0.000000]   1 base 100000000 mask FE0000000 write-back
[    0.000000]   2 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   3 base 0D8000000 mask FF8000000 uncachable
[    0.000000]   4 base 0D7800000 mask FFF800000 uncachable
[    0.000000]   5 base 11F800000 mask FFF800000 uncachable
[    0.000000]   6 base 11F600000 mask FFFE00000 uncachable
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 4GB, type WB
[    0.000000] reg 1, base: 4GB, range: 512MB, type WB
[    0.000000] reg 2, base: 3584MB, range: 512MB, type UC
[    0.000000] reg 3, base: 3456MB, range: 128MB, type UC
[    0.000000] reg 4, base: 3448MB, range: 8MB, type UC
[    0.000000] reg 5, base: 4600MB, range: 8MB, type UC
[    0.000000] reg 6, base: 4598MB, range: 2MB, type UC
[    0.000000] total RAM covered: 3950M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 16M 	num_reg: 8  	lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 3GB, range: 256MB, type WB
[    0.000000] reg 3, base: 3328MB, range: 128MB, type WB
[    0.000000] reg 4, base: 3448MB, range: 8MB, type UC
[    0.000000] reg 5, base: 4GB, range: 512MB, type WB
[    0.000000] reg 6, base: 4598MB, range: 2MB, type UC
[    0.000000] reg 7, base: 4600MB, range: 8MB, type UC
[    0.000000] e820: update [mem 0xd7800000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xd7000 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fd6e0-0x000fd6ef] mapped at [ffff8800000fd6e0]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01fd1000, 0x01fd1fff] PGTABLE
[    0.000000] BRK [0x01fd2000, 0x01fd2fff] PGTABLE
[    0.000000] BRK [0x01fd3000, 0x01fd3fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11f400000-0x11f5fffff]
[    0.000000]  [mem 0x11f400000-0x11f5fffff] page 2M
[    0.000000] BRK [0x01fd4000, 0x01fd4fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11c000000-0x11f3fffff]
[    0.000000]  [mem 0x11c000000-0x11f3fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x100000000-0x11bffffff]
[    0.000000]  [mem 0x100000000-0x11bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x1fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x1fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x20200000-0x40003fff]
[    0.000000]  [mem 0x20200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x40003fff] page 4k
[    0.000000] BRK [0x01fd5000, 0x01fd5fff] PGTABLE
[    0.000000] BRK [0x01fd6000, 0x01fd6fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x40005000-0xd5c0ffff]
[    0.000000]  [mem 0x40005000-0x401fffff] page 4k
[    0.000000]  [mem 0x40200000-0xd5bfffff] page 2M
[    0.000000]  [mem 0xd5c00000-0xd5c0ffff] page 4k
[    0.000000] init_memory_mapping: [mem 0xd670d000-0xd670dfff]
[    0.000000]  [mem 0xd670d000-0xd670dfff] page 4k
[    0.000000] init_memory_mapping: [mem 0xd6751000-0xd6ffffff]
[    0.000000]  [mem 0xd6751000-0xd67fffff] page 4k
[    0.000000]  [mem 0xd6800000-0xd6ffffff] page 2M
[    0.000000] RAMDISK: [mem 0x3602c000-0x3700dfff]
[    0.000000] ACPI: RSDP 00000000000f0490 00024 (v02  INTEL)
[    0.000000] ACPI: XSDT 00000000d6313070 00064 (v01 INTEL  DH61AG   0000006A AMI  00010013)
[    0.000000] ACPI: FACP 00000000d631c828 0010C (v05 INTEL  DH61AG   0000006A AMI  00010013)
[    0.000000] ACPI: DSDT 00000000d6313168 096BF (v02 INTEL  DH61AG   0000006A INTL 20051117)
[    0.000000] ACPI: FACS 00000000d6428080 00040
[    0.000000] ACPI: APIC 00000000d631c938 00072 (v03 INTEL  DH61AG   0000006A AMI  00010013)
[    0.000000] ACPI: FPDT 00000000d631c9b0 00044 (v01 INTEL  DH61AG   0000006A AMI  00010013)
[    0.000000] ACPI: MCFG 00000000d631c9f8 0003C (v01 INTEL  DH61AG   0000006A MSFT 00000097)
[    0.000000] ACPI: HPET 00000000d631ca38 00038 (v01 INTEL  DH61AG   0000006A AMI. 00000005)
[    0.000000] ACPI: SSDT 00000000d631ca70 0036D (v01 INTEL  DH61AG   0000006A INTL 20091112)
[    0.000000] ACPI: SSDT 00000000d631cde0 009AA (v01 INTEL  DH61AG   0000006A INTL 20051117)
[    0.000000] ACPI: SSDT 00000000d631d790 00A92 (v01 INTEL  DH61AG   0000006A INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000011f5fffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x11f5fffff]
[    0.000000]   NODE_DATA [mem 0x11f5f7000-0x11f5fbfff]
[    0.000000]  [ffffea0000000000-ffffea00047fffff] PMD -> [ffff88011ae00000-ffff88011ebfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x11f5fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
[    0.000000]   node   0: [mem 0x20200000-0x40003fff]
[    0.000000]   node   0: [mem 0x40005000-0xd5c0ffff]
[    0.000000]   node   0: [mem 0xd670d000-0xd670dfff]
[    0.000000]   node   0: [mem 0xd6751000-0xd6ffffff]
[    0.000000]   node   0: [mem 0x100000000-0x11f5fffff]
[    0.000000] On node 0 totalpages: 1005659
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 13643 pages used for memmap
[    0.000000]   DMA32 zone: 873151 pages, LIFO batch:31
[    0.000000]   Normal zone: 2008 pages used for memmap
[    0.000000]   Normal zone: 128512 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009dfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x20000000-0x201fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x40004000-0x40004fff]
[    0.000000] PM: Registered nosave memory: [mem 0xd5c10000-0xd630efff]
[    0.000000] PM: Registered nosave memory: [mem 0xd630f000-0xd631efff]
[    0.000000] PM: Registered nosave memory: [mem 0xd631f000-0xd6429fff]
[    0.000000] PM: Registered nosave memory: [mem 0xd642a000-0xd670cfff]
[    0.000000] PM: Registered nosave memory: [mem 0xd670e000-0xd6750fff]
[    0.000000] PM: Registered nosave memory: [mem 0xd7000000-0xd77fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xd7800000-0xdf9fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdfa00000-0xf7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfbffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfecfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed03fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed04000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0xdfa00000-0xf7ffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88011f200000 s86656 r8192 d23936 u524288
[    0.000000] pcpu-alloc: s86656 r8192 d23936 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 989923
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.11.10-031110-generic root=UUID=7f1378fa-0837-48fa-aa07-74ee97a6170a ro quiet splash vt.handoff=7
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 3859776K/4022636K available (7351K kernel code, 1073K rwdata, 3392K rodata, 1380K init, 1416K bss, 162860K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=4.
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-255.
[    0.000000] NR_IRQS:16640 nr_irqs:712 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 16252928 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.004000] tsc: Detected 3392.373 MHz processor
[    0.000001] Calibrating delay loop (skipped), value calculated using timer frequency.. 6784.74 BogoMIPS (lpj=13569492)
[    0.000003] pid_max: default: 32768 minimum: 301
[    0.000018] Security Framework initialized
[    0.000031] AppArmor: AppArmor initialized
[    0.000032] Yama: becoming mindful.
[    0.000222] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.001148] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.001569] Mount-cache hash table entries: 256
[    0.001702] Initializing cgroup subsys memory
[    0.001711] Initializing cgroup subsys devices
[    0.001712] Initializing cgroup subsys freezer
[    0.001713] Initializing cgroup subsys blkio
[    0.001714] Initializing cgroup subsys perf_event
[    0.001716] Initializing cgroup subsys hugetlb
[    0.001735] CPU: Physical Processor ID: 0
[    0.001736] CPU: Processor Core ID: 0
[    0.001739] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.001739] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.001742] mce: CPU supports 7 MCE banks
[    0.001750] CPU0: Thermal monitoring enabled (TM1)
[    0.001757] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
[    0.001757] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
[    0.001757] tlb_flushall_shift: 1
[    0.001849] Freeing SMP alternatives memory: 24K (ffffffff81e67000 - ffffffff81e6d000)
[    0.003602] ACPI: Core revision 20130517
[    0.007098] ACPI: All ACPI Tables successfully acquired
[    0.017895] ftrace: allocating 30589 entries in 120 pages
[    0.028640] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.068347] smpboot: CPU0: Intel(R) Core(TM) i3-3240 CPU @ 3.40GHz (fam: 06, model: 3a, stepping: 09)
[    0.068353] TSC deadline timer enabled
[    0.068362] Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge events, full-width counters, Intel PMU driver.
[    0.068367] ... version:                3
[    0.068368] ... bit width:              48
[    0.068369] ... generic registers:      4
[    0.068369] ... value mask:             0000ffffffffffff
[    0.068370] ... max period:             0000ffffffffffff
[    0.068371] ... fixed-purpose events:   3
[    0.068371] ... event mask:             000000070000000f
[    0.082510] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.069432] smpboot: Booting Node   0, Processors  #1 #2 #3 OK
[    0.108942] Brought up 4 CPUs
[    0.108945] smpboot: Total of 4 processors activated (27138.98 BogoMIPS)
[    0.111595] devtmpfs: initialized
[    0.112155] EVM: security.selinux
[    0.112156] EVM: security.SMACK64
[    0.112157] EVM: security.capability
[    0.112189] PM: Registering ACPI NVS region [mem 0xd631f000-0xd6429fff] (1093632 bytes)
[    0.112199] PM: Registering ACPI NVS region [mem 0xd670e000-0xd6750fff] (274432 bytes)
[    0.112754] regulator-dummy: no parameters
[    0.112782] RTC time:  6:10:49, date: 01/14/14
[    0.112804] NET: Registered protocol family 16
[    0.112890] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.112891] ACPI: bus type PCI registered
[    0.112892] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.112929] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.112931] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.117715] PCI: Using configuration type 1 for base access
[    0.118259] bio: create slab <bio-0> at 0
[    0.118362] ACPI: Added _OSI(Module Device)
[    0.118364] ACPI: Added _OSI(Processor Device)
[    0.118365] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.118365] ACPI: Added _OSI(Processor Aggregator Device)
[    0.119311] ACPI: EC: Look up EC in DSDT
[    0.120297] ACPI: Executed 1 blocks of module-level executable AML code
[    0.125253] ACPI: SSDT 00000000d62bb018 0083B (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    0.125490] ACPI: Dynamic OEM Table Load:
[    0.125492] ACPI: SSDT           (null) 0083B (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    0.131638] ACPI: SSDT 00000000d62bca98 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
[    0.131894] ACPI: Dynamic OEM Table Load:
[    0.131895] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
[    0.135555] ACPI: SSDT 00000000d62bdc18 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
[    0.135790] ACPI: Dynamic OEM Table Load:
[    0.135791] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
[    0.139847] ACPI: Interpreter enabled
[    0.139851] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130517/hwxface-571)
[    0.139853] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130517/hwxface-571)
[    0.139862] ACPI: (supports S0 S3 S4 S5)
[    0.139863] ACPI: Using IOAPIC for interrupt routing
[    0.139881] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.139962] ACPI: No dock devices found.
[    0.144373] ACPI: Power Resource [FN00] (off)
[    0.144424] ACPI: Power Resource [FN01] (off)
[    0.144474] ACPI: Power Resource [FN02] (off)
[    0.144524] ACPI: Power Resource [FN03] (off)
[    0.144573] ACPI: Power Resource [FN04] (off)
[    0.144969] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.145117] acpi PNP0A08:00: Requesting ACPI _OSC control (0x1d)
[    0.145247] acpi PNP0A08:00: ACPI _OSC control (0x18) granted
[    0.145603] PCI host bridge to bus 0000:00
[    0.145605] pci_bus 0000:00: root bus resource [bus 00-3e]
[    0.145606] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.145607] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.145609] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.145610] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
[    0.145611] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.145612] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.145613] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    0.145614] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
[    0.145615] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
[    0.145616] pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xfeafffff]
[    0.145622] pci 0000:00:00.0: [8086:0150] type 00 class 0x060000
[    0.145688] pci 0000:00:02.0: [8086:0152] type 00 class 0x030000
[    0.145696] pci 0000:00:02.0: reg 0x10: [mem 0xf7800000-0xf7bfffff 64bit]
[    0.145700] pci 0000:00:02.0: reg 0x18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.145703] pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
[    0.145783] pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
[    0.145803] pci 0000:00:16.0: reg 0x10: [mem 0xf7d2b000-0xf7d2b00f 64bit]
[    0.145874] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.145940] pci 0000:00:19.0: [8086:1503] type 00 class 0x020000
[    0.145956] pci 0000:00:19.0: reg 0x10: [mem 0xf7d00000-0xf7d1ffff]
[    0.145964] pci 0000:00:19.0: reg 0x14: [mem 0xf7d29000-0xf7d29fff]
[    0.145972] pci 0000:00:19.0: reg 0x18: [io  0xf080-0xf09f]
[    0.146031] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.146085] pci 0000:00:1a.0: [8086:1c2d] type 00 class 0x0c0320
[    0.146104] pci 0000:00:1a.0: reg 0x10: [mem 0xf7d28000-0xf7d283ff]
[    0.146189] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.146238] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.146264] pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
[    0.146278] pci 0000:00:1b.0: reg 0x10: [mem 0xf7d20000-0xf7d23fff 64bit]
[    0.146341] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.146380] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.146403] pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
[    0.146477] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.146517] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.146540] pci 0000:00:1c.1: [8086:1c12] type 01 class 0x060400
[    0.146613] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.146653] pci 0000:00:1c.1: System wakeup disabled by ACPI
[    0.146684] pci 0000:00:1d.0: [8086:1c26] type 00 class 0x0c0320
[    0.146703] pci 0000:00:1d.0: reg 0x10: [mem 0xf7d27000-0xf7d273ff]
[    0.146788] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.146834] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.146860] pci 0000:00:1f.0: [8086:1c5c] type 00 class 0x060100
[    0.147013] pci 0000:00:1f.2: [8086:1c02] type 00 class 0x010601
[    0.147030] pci 0000:00:1f.2: reg 0x10: [io  0xf0d0-0xf0d7]
[    0.147037] pci 0000:00:1f.2: reg 0x14: [io  0xf0c0-0xf0c3]
[    0.147045] pci 0000:00:1f.2: reg 0x18: [io  0xf0b0-0xf0b7]
[    0.147052] pci 0000:00:1f.2: reg 0x1c: [io  0xf0a0-0xf0a3]
[    0.147059] pci 0000:00:1f.2: reg 0x20: [io  0xf060-0xf07f]
[    0.147067] pci 0000:00:1f.2: reg 0x24: [mem 0xf7d26000-0xf7d267ff]
[    0.147108] pci 0000:00:1f.2: PME# supported from D3hot
[    0.147162] pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
[    0.147176] pci 0000:00:1f.3: reg 0x10: [mem 0xf7d25000-0xf7d250ff 64bit]
[    0.147195] pci 0000:00:1f.3: reg 0x20: [io  0xf040-0xf05f]
[    0.147306] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.147391] pci 0000:02:00.0: [1033:0194] type 00 class 0x0c0330
[    0.147420] pci 0000:02:00.0: reg 0x10: [mem 0xf7c00000-0xf7c01fff 64bit]
[    0.147571] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.147616] pci 0000:02:00.0: System wakeup disabled by ACPI
[    0.155803] pci 0000:00:1c.1: PCI bridge to [bus 02]
[    0.155811] pci 0000:00:1c.1:   bridge window [mem 0xf7c00000-0xf7cfffff]
[    0.155845] acpi PNP0A08:00: Disabling ASPM (FADT indicates it is unsupported)
[    0.156246] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.156283] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 *4 5 6 10 11 12 14 15)
[    0.156318] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.156353] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.156389] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 10 11 12 14 15)
[    0.156426] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.156461] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 10 11 12 14 15)
[    0.156496] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.156655] ACPI: Enabled 7 GPEs in block 00 to 3F
[    0.156659] ACPI: \_SB_.PCI0: notify handler is installed
[    0.156695] Found 1 acpi root devices
[    0.156760] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.156762] vgaarb: loaded
[    0.156763] vgaarb: bridge control possible 0000:00:02.0
[    0.156864] SCSI subsystem initialized
[    0.156865] ACPI: bus type ATA registered
[    0.156902] libata version 3.00 loaded.
[    0.156923] ACPI: bus type USB registered
[    0.156935] usbcore: registered new interface driver usbfs
[    0.156941] usbcore: registered new interface driver hub
[    0.156960] usbcore: registered new device driver usb
[    0.157028] PCI: Using ACPI for IRQ routing
[    0.158484] PCI: pci_cache_line_size set to 64 bytes
[    0.158518] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
[    0.158519] e820: reserve RAM buffer [mem 0x40004000-0x43ffffff]
[    0.158520] e820: reserve RAM buffer [mem 0xd5c10000-0xd7ffffff]
[    0.158521] e820: reserve RAM buffer [mem 0xd670e000-0xd7ffffff]
[    0.158522] e820: reserve RAM buffer [mem 0xd7000000-0xd7ffffff]
[    0.158523] e820: reserve RAM buffer [mem 0x11f600000-0x11fffffff]
[    0.158586] NetLabel: Initializing
[    0.158587] NetLabel:  domain hash size = 128
[    0.158587] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.158593] NetLabel:  unlabeled traffic allowed by default
[    0.158636] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.158640] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.160662] Switched to clocksource hpet
[    0.163764] AppArmor: AppArmor Filesystem Enabled
[    0.163789] pnp: PnP ACPI init
[    0.163800] ACPI: bus type PNP registered
[    0.163879] system 00:00: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.163882] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.163892] pnp 00:01: [dma 4]
[    0.163900] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.163913] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    0.163979] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.164002] system 00:04: [io  0x0680-0x069f] has been reserved
[    0.164003] system 00:04: [io  0x1000-0x100f] has been reserved
[    0.164005] system 00:04: [io  0xffff] has been reserved
[    0.164006] system 00:04: [io  0xffff] has been reserved
[    0.164007] system 00:04: [io  0x0400-0x0453] could not be reserved
[    0.164009] system 00:04: [io  0x0458-0x047f] has been reserved
[    0.164010] system 00:04: [io  0x0500-0x057f] has been reserved
[    0.164011] system 00:04: [io  0x164e-0x164f] has been reserved
[    0.164013] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.164034] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.164061] system 00:06: [io  0x0454-0x0457] has been reserved
[    0.164063] system 00:06: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.164152] system 00:07: [io  0x0a00-0x0a0f] has been reserved
[    0.164153] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.164182] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    0.164213] pnp 00:09: Plug and Play ACPI device, IDs PNP0f03 PNP0f13 (active)
[    0.164341] system 00:0a: [io  0x04d0-0x04d1] has been reserved
[    0.164343] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.164358] pnp 00:0b: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.164514] system 00:0c: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.164515] system 00:0c: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.164516] system 00:0c: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.164518] system 00:0c: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.164519] system 00:0c: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.164520] system 00:0c: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.164521] system 00:0c: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.164523] system 00:0c: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.164524] system 00:0c: [mem 0xff000000-0xffffffff] has been reserved
[    0.164525] system 00:0c: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.164527] system 00:0c: [mem 0xdfa00000-0xdfa00fff] has been reserved
[    0.164528] system 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.164632] system 00:0d: [mem 0x20000000-0x201fffff] has been reserved
[    0.164633] system 00:0d: [mem 0x40004000-0x40004fff] has been reserved
[    0.164635] system 00:0d: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.164648] pnp: PnP ACPI: found 14 devices
[    0.164649] ACPI: bus type PNP unregistered
[    0.170610] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.170622] pci 0000:00:1c.1: PCI bridge to [bus 02]
[    0.170627] pci 0000:00:1c.1:   bridge window [mem 0xf7c00000-0xf7cfffff]
[    0.170741] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.170743] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.170744] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.170745] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.170746] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.170747] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.170748] pci_bus 0000:00: resource 10 [mem 0x000dc000-0x000dffff]
[    0.170750] pci_bus 0000:00: resource 11 [mem 0x000e0000-0x000e3fff]
[    0.170751] pci_bus 0000:00: resource 12 [mem 0x000e4000-0x000e7fff]
[    0.170752] pci_bus 0000:00: resource 13 [mem 0xdfa00000-0xfeafffff]
[    0.170753] pci_bus 0000:02: resource 1 [mem 0xf7c00000-0xf7cfffff]
[    0.170774] NET: Registered protocol family 2
[    0.170881] TCP established hash table entries: 32768 (order: 7, 524288 bytes)
[    0.171003] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
[    0.171095] TCP: Hash tables configured (established 32768 bind 32768)
[    0.171109] TCP: reno registered
[    0.171115] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.171129] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.171172] NET: Registered protocol family 1
[    0.171180] pci 0000:00:02.0: Boot video device
[    0.208845] PCI: CLS 64 bytes, default 64
[    0.208879] Trying to unpack rootfs image as initramfs...
[    0.396380] Freeing initrd memory: 16264K (ffff88003602c000 - ffff88003700e000)
[    0.396385] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.396387] software IO TLB [mem 0xd1c10000-0xd5c10000] (64MB) mapped at [ffff8800d1c10000-ffff8800d5c0ffff]
[    0.396553] Scanning for low memory corruption every 60 seconds
[    0.396757] Initialise module verification
[    0.396799] audit: initializing netlink socket (disabled)
[    0.396807] type=2000 audit(1389679848.388:1): initialized
[    0.415982] bounce pool size: 64 pages
[    0.415989] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.416695] zbud: loaded
[    0.416777] VFS: Disk quotas dquot_6.5.2
[    0.416812] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.417102] fuse init (API version 7.22)
[    0.417148] msgmni has been set to 7570
[    0.417457] Key type asymmetric registered
[    0.417458] Asymmetric key parser 'x509' registered
[    0.417477] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.417500] io scheduler noop registered
[    0.417502] io scheduler deadline registered (default)
[    0.417516] io scheduler cfq registered
[    0.417638] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.417646] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.417679] intel_idle: MWAIT substates: 0x1120
[    0.417680] intel_idle: v0.4 model 0x3A
[    0.417681] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.417746] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    0.417751] ACPI: Power Button [PWRB]
[    0.417771] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.417773] ACPI: Power Button [PWRF]
[    0.417823] ACPI: Fan [FAN0] (off)
[    0.417839] ACPI: Fan [FAN1] (off)
[    0.417855] ACPI: Fan [FAN2] (off)
[    0.417869] ACPI: Fan [FAN3] (off)
[    0.417884] ACPI: Fan [FAN4] (off)
[    0.417916] ACPI: Requesting acpi_cpufreq
[    0.433036] thermal LNXTHERM:00: registered as thermal_zone0
[    0.433037] ACPI: Thermal Zone [TZ00] (28 C)
[    0.433170] thermal LNXTHERM:01: registered as thermal_zone1
[    0.433171] ACPI: Thermal Zone [TZ01] (30 C)
[    0.433189] GHES: HEST is not enabled!
[    0.433236] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    0.434161] Linux agpgart interface v0.103
[    0.434908] brd: module loaded
[    0.435297] loop: module loaded
[    0.435484] libphy: Fixed MDIO Bus: probed
[    0.435528] tun: Universal TUN/TAP device driver, 1.6
[    0.435529] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.435558] PPP generic driver version 2.4.2
[    0.435586] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.435588] ehci-pci: EHCI PCI platform driver
[    0.435661] ehci-pci 0000:00:1a.0: setting latency timer to 64
[    0.435667] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    0.435671] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    0.435683] ehci-pci 0000:00:1a.0: debug port 2
[    0.439582] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    0.439597] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf7d28000
[    0.448810] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    0.448824] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.448825] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.448827] usb usb1: Product: EHCI Host Controller
[    0.448828] usb usb1: Manufacturer: Linux 3.11.10-031110-generic ehci_hcd
[    0.448829] usb usb1: SerialNumber: 0000:00:1a.0
[    0.448893] hub 1-0:1.0: USB hub found
[    0.448896] hub 1-0:1.0: 2 ports detected
[    0.449016] ehci-pci 0000:00:1d.0: setting latency timer to 64
[    0.449020] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    0.449024] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    0.449034] ehci-pci 0000:00:1d.0: debug port 2
[    0.452924] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    0.452935] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf7d27000
[    0.464813] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    0.464821] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.464822] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.464823] usb usb2: Product: EHCI Host Controller
[    0.464824] usb usb2: Manufacturer: Linux 3.11.10-031110-generic ehci_hcd
[    0.464825] usb usb2: SerialNumber: 0000:00:1d.0
[    0.464885] hub 2-0:1.0: USB hub found
[    0.464887] hub 2-0:1.0: 2 ports detected
[    0.464946] ehci-platform: EHCI generic platform driver
[    0.464950] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.464951] ohci-platform: OHCI generic platform driver
[    0.464955] uhci_hcd: USB Universal Host Controller Interface driver
[    0.464996] xhci_hcd 0000:02:00.0: xHCI Host Controller
[    0.464999] xhci_hcd 0000:02:00.0: new USB bus registered, assigned bus number 3
[    0.465181] xhci_hcd 0000:02:00.0: irq 40 for MSI/MSI-X
[    0.465184] xhci_hcd 0000:02:00.0: irq 41 for MSI/MSI-X
[    0.465187] xhci_hcd 0000:02:00.0: irq 42 for MSI/MSI-X
[    0.465190] xhci_hcd 0000:02:00.0: irq 43 for MSI/MSI-X
[    0.465193] xhci_hcd 0000:02:00.0: irq 44 for MSI/MSI-X
[    0.465287] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    0.465288] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.465289] usb usb3: Product: xHCI Host Controller
[    0.465290] usb usb3: Manufacturer: Linux 3.11.10-031110-generic xhci_hcd
[    0.465291] usb usb3: SerialNumber: 0000:02:00.0
[    0.465332] xHCI xhci_add_endpoint called for root hub
[    0.465333] xHCI xhci_check_bandwidth called for root hub
[    0.465345] hub 3-0:1.0: USB hub found
[    0.465351] hub 3-0:1.0: 2 ports detected
[    0.465392] xhci_hcd 0000:02:00.0: xHCI Host Controller
[    0.465394] xhci_hcd 0000:02:00.0: new USB bus registered, assigned bus number 4
[    0.468593] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
[    0.468594] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.468595] usb usb4: Product: xHCI Host Controller
[    0.468596] usb usb4: Manufacturer: Linux 3.11.10-031110-generic xhci_hcd
[    0.468597] usb usb4: SerialNumber: 0000:02:00.0
[    0.468635] xHCI xhci_add_endpoint called for root hub
[    0.468636] xHCI xhci_check_bandwidth called for root hub
[    0.468648] hub 4-0:1.0: USB hub found
[    0.468655] hub 4-0:1.0: 2 ports detected
[    0.472850] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    0.475814] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.475818] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.475881] mousedev: PS/2 mouse device common for all mice
[    0.475966] rtc_cmos 00:05: RTC can wake from S4
[    0.476072] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    0.476098] rtc_cmos 00:05: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    0.476133] device-mapper: uevent: version 1.0.3
[    0.476167] device-mapper: ioctl: 4.25.0-ioctl (2013-06-26) initialised: dm-devel@redhat.com
[    0.476172] Intel P-state driver initializing.
[    0.476178] Intel pstate controlling: cpu 0
[    0.476190] Intel pstate controlling: cpu 1
[    0.476197] Intel pstate controlling: cpu 2
[    0.476207] Intel pstate controlling: cpu 3
[    0.476268] cpuidle: using governor ladder
[    0.476332] cpuidle: using governor menu
[    0.476339] ledtrig-cpu: registered to indicate activity on CPUs
[    0.476390] TCP: cubic registered
[    0.476439] NET: Registered protocol family 10
[    0.476548] NET: Registered protocol family 17
[    0.476554] Key type dns_resolver registered
[    0.476698] PM: Hibernation image not present or could not be loaded.
[    0.476700] Loading module verification certificates
[    0.477282] MODSIGN: Loaded cert 'Magrathea: Glacier signing key: 08b3cad365c40ca24b38dbd19e1684d04ddf243d'
[    0.477291] registered taskstats version 1
[    0.478683] Key type trusted registered
[    0.479877] Key type encrypted registered
[    0.481258]   Magic number: 14:270:165
[    0.481342] rtc_cmos 00:05: setting system clock to 2014-01-14 06:10:49 UTC (1389679849)
[    0.481487] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    0.481488] EDD information not available.
[    0.482328] Freeing unused kernel memory: 1380K (ffffffff81d0e000 - ffffffff81e67000)
[    0.482329] Write protecting the kernel read-only data: 12288k
[    0.483557] Freeing unused kernel memory: 828K (ffff880001731000 - ffff880001800000)
[    0.484538] Freeing unused kernel memory: 704K (ffff880001b50000 - ffff880001c00000)
[    0.498030] systemd-udevd[114]: starting version 204
[    0.516087] pps_core: LinuxPPS API ver. 1 registered
[    0.516091] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.517163] PTP clock support registered
[    0.521107] ahci 0000:00:1f.2: version 3.0
[    0.521251] ahci 0000:00:1f.2: irq 45 for MSI/MSI-X
[    0.521300] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 4 ports 3 Gbps 0x3 impl SATA mode
[    0.521303] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part ems apst 
[    0.521309] ahci 0000:00:1f.2: setting latency timer to 64
[    0.522291] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    0.522293] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[    0.529219] scsi0 : ahci
[    0.529303] scsi1 : ahci
[    0.529377] scsi2 : ahci
[    0.529461] scsi3 : ahci
[    0.529533] ata1: SATA max UDMA/133 abar m2048@0xf7d26000 port 0xf7d26100 irq 45
[    0.529537] ata2: SATA max UDMA/133 abar m2048@0xf7d26000 port 0xf7d26180 irq 45
[    0.529538] ata3: DUMMY
[    0.529539] ata4: DUMMY
[    0.529684] e1000e 0000:00:19.0: setting latency timer to 64
[    0.529746] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    0.529767] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[    0.760963] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    0.792081] e1000e 0000:00:19.0 eth0: registered PHC clock
[    0.792084] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) e0:cb:4e:28:cb:a8
[    0.792085] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[    0.792119] e1000e 0000:00:19.0 eth0: MAC: 10, PHY: 11, PBA No: FFFFFF-0FF
[    0.849040] ata1: SATA link down (SStatus 0 SControl 300)
[    0.849069] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    0.860635] ata2.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    0.860640] ata2.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[    0.860644] ata2.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
[    0.871042] ata2.00: ATA-8: MKNSSDCR60GB, 502ABBF0, max UDMA/133
[    0.871047] ata2.00: 117231408 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    0.880612] ata2.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    0.880617] ata2.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[    0.880620] ata2.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
[    0.891047] ata2.00: configured for UDMA/133
[    0.891310] scsi 1:0:0:0: Direct-Access     ATA      MKNSSDCR60GB     502A PQ: 0 ANSI: 5
[    0.891528] sd 1:0:0:0: [sda] 117231408 512-byte logical blocks: (60.0 GB/55.8 GiB)
[    0.891535] sd 1:0:0:0: Attached scsi generic sg0 type 0
[    0.891701] sd 1:0:0:0: [sda] Write Protect is off
[    0.891706] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.891840] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.892803]  sda: sda1 sda2
[    0.892897] sda: p2 size 16384000 extends beyond EOD, enabling native capacity
[    0.893348] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[    0.893351] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    0.893509] hub 1-1:1.0: USB hub found
[    0.893608]  sda: sda1 sda2
[    0.893621] hub 1-1:1.0: 4 ports detected
[    0.893679] sda: p2 size 16384000 extends beyond EOD, truncated
[    0.894277] sd 1:0:0:0: [sda] Attached SCSI disk
[    1.005078] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    1.137509] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[    1.137513] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.137754] hub 2-1:1.0: USB hub found
[    1.137853] hub 2-1:1.0: 6 ports detected
[    1.249214] usb 3-1: new full-speed USB device number 2 using xhci_hcd
[    1.315077] usb 3-1: New USB device found, idVendor=147a, idProduct=e03e
[    1.315081] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    1.315083] usb 3-1: Product: eHome Infrared Transceiver
[    1.315085] usb 3-1: Manufacturer: Formosa21
[    1.315087] usb 3-1: SerialNumber: 0000A590
[    1.315254] usb 3-1: ep 0x83 - rounding interval to 64 microframes, ep desc says 80 microframes
[    1.320529] hidraw: raw HID events driver (C) Jiri Kosina
[    1.334135] usbcore: registered new interface driver usbhid
[    1.334137] usbhid: USB HID core driver
[    1.335780] hid-generic 0003:147A:E03E.0001: hiddev0,hidraw0: USB HID v1.00 Device [Formosa21 eHome Infrared Transceiver] on usb-0000:02:00.0-1/input1
[    1.389328] usb 1-1.1: new full-speed USB device number 3 using ehci-pci
[    1.393269] tsc: Refined TSC clocksource calibration: 3392.292 MHz
[    1.484795] usb 1-1.1: New USB device found, idVendor=046d, idProduct=c52f
[    1.484800] usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.484802] usb 1-1.1: Product: USB Receiver
[    1.484804] usb 1-1.1: Manufacturer: Logitech
[    1.487080] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.1/1-1.1:1.0/input/input2
[    1.487212] hid-generic 0003:046D:C52F.0002: input,hidraw1: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:1a.0-1.1/input0
[    1.489382] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.1/1-1.1:1.1/input/input3
[    1.489679] hid-generic 0003:046D:C52F.0003: input,hiddev0,hidraw2: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:1a.0-1.1/input1
[    1.561414] usb 1-1.2: new full-speed USB device number 4 using ehci-pci
[    1.657115] usb 1-1.2: New USB device found, idVendor=046d, idProduct=c52b
[    1.657119] usb 1-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.657121] usb 1-1.2: Product: USB Receiver
[    1.657124] usb 1-1.2: Manufacturer: Logitech
[    1.665312] logitech-djreceiver 0003:046D:C52B.0006: hiddev0,hidraw3: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:1a.0-1.2/input2
[    1.667850] input: Logitech Unifying Device. Wireless PID:2007 as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.2/0003:046D:C52B.0006/input/input4
[    1.667919] logitech-djdevice 0003:046D:C52B.0007: input,hidraw4: USB HID v1.11 Keyboard [Logitech Unifying Device. Wireless PID:2007] on usb-0000:00:1a.0-1.2:1
[    2.393887] Switched to clocksource tsc
[    5.931547] EXT4-fs (sda1): INFO: recovery required on readonly filesystem
[    5.931551] EXT4-fs (sda1): write access will be enabled during recovery
[    5.955484] EXT4-fs (sda1): recovery complete
[    5.955933] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    6.041650] init: ureadahead main process (180) terminated with status 5
[    6.096409] Adding 7673748k swap on /dev/sda2.  Priority:-1 extents:1 across:7673748k SSFS
[    6.119797] EXT4-fs (sda1): re-mounted. Opts: discard,errors=remount-ro
[    6.172979] systemd-udevd[341]: starting version 204
[    6.202881] lp: driver loaded but no devices found
[    6.243270] mei_me 0000:00:16.0: setting latency timer to 64
[    6.243314] mei_me 0000:00:16.0: irq 47 for MSI/MSI-X
[    6.261566] [drm] Initialized drm 1.1.0 20060810
[    6.277043] ACPI Warning: 0x0000000000000428-0x000000000000042f SystemIO conflicts with Region \PMIO 1 (20130517/utaddress-251)
[    6.277050] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    6.277054] ACPI Warning: 0x0000000000000540-0x000000000000054f SystemIO conflicts with Region \GPIO 1 (20130517/utaddress-251)
[    6.277058] ACPI Warning: 0x0000000000000540-0x000000000000054f SystemIO conflicts with Region \_GPE.GPS0 2 (20130517/utaddress-251)
[    6.277061] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    6.277063] ACPI Warning: 0x0000000000000530-0x000000000000053f SystemIO conflicts with Region \GPIO 1 (20130517/utaddress-251)
[    6.277065] ACPI Warning: 0x0000000000000530-0x000000000000053f SystemIO conflicts with Region \_GPE.GPS0 2 (20130517/utaddress-251)
[    6.277068] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    6.277070] ACPI Warning: 0x0000000000000500-0x000000000000052f SystemIO conflicts with Region \GPIO 1 (20130517/utaddress-251)
[    6.277073] ACPI Warning: 0x0000000000000500-0x000000000000052f SystemIO conflicts with Region \_GPE.GPS0 2 (20130517/utaddress-251)
[    6.277076] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    6.277077] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    6.289958] [drm] Memory usable by graphics device = 2048M
[    6.289967] i915 0000:00:02.0: setting latency timer to 64
[    6.318412] i915 0000:00:02.0: irq 48 for MSI/MSI-X
[    6.318424] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    6.318426] [drm] Driver supports precise vblank timestamp query.
[    6.318482] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    6.326154] microcode: CPU0 sig=0x306a9, pf=0x2, revision=0x17
[    6.351601] Bluetooth: Core ver 2.16
[    6.351618] NET: Registered protocol family 31
[    6.351620] Bluetooth: HCI device and connection manager initialized
[    6.351628] Bluetooth: HCI socket layer initialized
[    6.351631] Bluetooth: L2CAP socket layer initialized
[    6.351636] Bluetooth: SCO socket layer initialized
[    6.361063] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    6.361066] Bluetooth: BNEP filters: protocol multicast
[    6.361090] Bluetooth: BNEP socket layer initialized
[    6.361435] Bluetooth: RFCOMM TTY layer initialized
[    6.361444] Bluetooth: RFCOMM socket layer initialized
[    6.361445] Bluetooth: RFCOMM ver 1.11
[    6.375541] Registered IR keymap rc-rc6-mce
[    6.375629] input: Media Center Ed. eHome Infrared Remote Transceiver (147a:e03e) as /devices/pci0000:00/0000:00:1c.1/0000:02:00.0/usb3/3-1/3-1:1.0/rc/rc0/input5
[    6.375702] rc0: Media Center Ed. eHome Infrared Remote Transceiver (147a:e03e) as /devices/pci0000:00/0000:00:1c.1/0000:02:00.0/usb3/3-1/3-1:1.0/rc/rc0
[    6.379888] IR NEC protocol handler initialized
[    6.381367] ppdev: user-space parallel port driver
[    6.383109] IR RC5(x) protocol handler initialized
[    6.390298] IR RC6 protocol handler initialized
[    6.391627] IR JVC protocol handler initialized
[    6.392418] IR SANYO protocol handler initialized
[    6.393059] init: avahi-cups-reload main process (480) terminated with status 1
[    6.394285] IR Sony protocol handler initialized
[    6.394561] input: MCE IR Keyboard/Mouse (mceusb) as /devices/virtual/input/input6
[    6.394921] IR MCE Keyboard/mouse protocol handler initialized
[    6.395034] lirc_dev: IR Remote Control driver registered, major 248 
[    6.396488] rc rc0: lirc_dev: driver ir-lirc-codec (mceusb) registered at minor = 0
[    6.396491] IR LIRC bridge handler initialized
[    6.488271] microcode: CPU1 sig=0x306a9, pf=0x2, revision=0x17
[    6.526779] microcode: CPU2 sig=0x306a9, pf=0x2, revision=0x17
[    6.534357] microcode: CPU3 sig=0x306a9, pf=0x2, revision=0x17
[    6.536859] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    6.548834] fbcon: inteldrmfb (fb0) is primary device
[    6.583654] mceusb 3-1:1.0: Registered Formosa21 eHome Infrared Transceiver with mce emulator interface version 2
[    6.583656] mceusb 3-1:1.0: 0 tx ports (0x0 cabled) and 1 rx sensors (0x1 active)
[    6.583694] usbcore: registered new interface driver mceusb
[    6.700283] type=1400 audit(1389679855.712:2): apparmor="STATUS" operation="profile_load" name="/sbin/dhclient" pid=528 comm="apparmor_parser"
[    6.700331] type=1400 audit(1389679855.712:3): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=528 comm="apparmor_parser"
[    6.700359] type=1400 audit(1389679855.712:4): apparmor="STATUS" operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" pid=528 comm="apparmor_parser"
[    6.804207] type=1400 audit(1389679855.816:5): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=555 comm="apparmor_parser"
[    6.804262] type=1400 audit(1389679855.816:6): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=555 comm="apparmor_parser"
[    6.804297] type=1400 audit(1389679855.816:7): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=555 comm="apparmor_parser"
[    6.810097] type=1400 audit(1389679855.820:8): apparmor="STATUS" operation="profile_load" name="/usr/sbin/ntpd" pid=597 comm="apparmor_parser"
[    6.915241] type=1400 audit(1389679855.924:9): apparmor="STATUS" operation="profile_replace" name="/usr/sbin/ntpd" pid=598 comm="apparmor_parser"
[    6.926888] type=1400 audit(1389679855.936:10): apparmor="STATUS" operation="profile_load" name="/usr/lib/cups/backend/cups-pdf" pid=535 comm="apparmor_parser"
[    6.926988] type=1400 audit(1389679855.936:11): apparmor="STATUS" operation="profile_load" name="/usr/sbin/cupsd" pid=535 comm="apparmor_parser"
[    7.816517] [drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp off
[    8.432583] Console: switching to colour frame buffer device 240x67
[    8.435381] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    8.435382] i915 0000:00:02.0: registered panic notifier
[    8.441892] acpi device:4b: registered as cooling_device10
[    8.442052] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    8.442770] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input7
[    8.444366] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    8.444555] snd_hda_intel 0000:00:1b.0: irq 49 for MSI/MSI-X
[    8.459070] autoconfig: line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:line
[    8.459074]    speaker_outs=1 (0x1a/0x0/0x0/0x0/0x0)
[    8.459075]    hp_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    8.459076]    mono: mono_out=0x0
[    8.459077]    dig-out=0x1e/0x0
[    8.459078]    inputs:
[    8.459080]      Mic=0x18
[    8.459082]      Internal Mic=0x12
[    8.482151] input: HDA Intel PCH HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[    8.482313] input: HDA Intel PCH HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[    8.482467] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[    8.482988] input: HDA Intel PCH Line Out as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[    8.483727] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[    8.539453] init: failsafe main process (611) killed by TERM signal
[    8.836835] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[    8.940793] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[    8.940902] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[   12.287200] e1000e: eth1 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[   12.287237] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[   12.938414] audit_printk_skb: 54 callbacks suppressed
[   12.938418] type=1400 audit(1389679861.944:30): apparmor="STATUS" operation="profile_load" name="/usr/bin/evince" pid=900 comm="apparmor_parser"
[   12.938806] type=1400 audit(1389679861.948:31): apparmor="STATUS" operation="profile_load" name="/usr/bin/evince//sanitized_helper" pid=900 comm="apparmor_parser"
[   12.939215] type=1400 audit(1389679861.948:32): apparmor="STATUS" operation="profile_load" name="/usr/bin/evince-previewer" pid=900 comm="apparmor_parser"
[   12.939414] type=1400 audit(1389679861.948:33): apparmor="STATUS" operation="profile_load" name="/usr/bin/evince-previewer//sanitized_helper" pid=900 comm="apparmor_parser"
[   12.939648] type=1400 audit(1389679861.948:34): apparmor="STATUS" operation="profile_load" name="/usr/bin/evince-thumbnailer" pid=900 comm="apparmor_parser"
[   12.939804] type=1400 audit(1389679861.948:35): apparmor="STATUS" operation="profile_load" name="/usr/bin/evince-thumbnailer//sanitized_helper" pid=900 comm="apparmor_parser"

--MP_/kfv9i6UDJpGDGa5kkhzZwR5
Content-Type: text/x-log
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=kernel_3.12.1.log

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.12.1-031201-generic (apw@gomeisa) (gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #201311201654 SMP Wed Nov 20 21:54:49 UTC 2013
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.12.1-031201-generic root=UUID=7f1378fa-0837-48fa-aa07-74ee97a6170a ro quiet splash vt.handoff=7
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x0000000040003fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000040004000-0x0000000040004fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000040005000-0x00000000d5c0ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000d5c10000-0x00000000d630efff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000d630f000-0x00000000d631efff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000d631f000-0x00000000d6429fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000d642a000-0x00000000d670cfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000d670d000-0x00000000d670dfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000d670e000-0x00000000d6750fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000d6751000-0x00000000d6ffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000d7800000-0x00000000df9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011f5fffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI:                  /DH61AG, BIOS AGH6110H.86A.0106.2013.0509.1441 05/09/2013
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x11f600 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F00000000 write-back
[    0.000000]   1 base 100000000 mask FE0000000 write-back
[    0.000000]   2 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   3 base 0D8000000 mask FF8000000 uncachable
[    0.000000]   4 base 0D7800000 mask FFF800000 uncachable
[    0.000000]   5 base 11F800000 mask FFF800000 uncachable
[    0.000000]   6 base 11F600000 mask FFFE00000 uncachable
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 4GB, type WB
[    0.000000] reg 1, base: 4GB, range: 512MB, type WB
[    0.000000] reg 2, base: 3584MB, range: 512MB, type UC
[    0.000000] reg 3, base: 3456MB, range: 128MB, type UC
[    0.000000] reg 4, base: 3448MB, range: 8MB, type UC
[    0.000000] reg 5, base: 4600MB, range: 8MB, type UC
[    0.000000] reg 6, base: 4598MB, range: 2MB, type UC
[    0.000000] total RAM covered: 3950M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 16M 	num_reg: 8  	lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 3GB, range: 256MB, type WB
[    0.000000] reg 3, base: 3328MB, range: 128MB, type WB
[    0.000000] reg 4, base: 3448MB, range: 8MB, type UC
[    0.000000] reg 5, base: 4GB, range: 512MB, type WB
[    0.000000] reg 6, base: 4598MB, range: 2MB, type UC
[    0.000000] reg 7, base: 4600MB, range: 8MB, type UC
[    0.000000] e820: update [mem 0xd7800000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xd7000 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fd6e0-0x000fd6ef] mapped at [ffff8800000fd6e0]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01fd3000, 0x01fd3fff] PGTABLE
[    0.000000] BRK [0x01fd4000, 0x01fd4fff] PGTABLE
[    0.000000] BRK [0x01fd5000, 0x01fd5fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11f400000-0x11f5fffff]
[    0.000000]  [mem 0x11f400000-0x11f5fffff] page 2M
[    0.000000] BRK [0x01fd6000, 0x01fd6fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11c000000-0x11f3fffff]
[    0.000000]  [mem 0x11c000000-0x11f3fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x100000000-0x11bffffff]
[    0.000000]  [mem 0x100000000-0x11bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x1fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x1fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x20200000-0x40003fff]
[    0.000000]  [mem 0x20200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x40003fff] page 4k
[    0.000000] BRK [0x01fd7000, 0x01fd7fff] PGTABLE
[    0.000000] BRK [0x01fd8000, 0x01fd8fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x40005000-0xd5c0ffff]
[    0.000000]  [mem 0x40005000-0x401fffff] page 4k
[    0.000000]  [mem 0x40200000-0xd5bfffff] page 2M
[    0.000000]  [mem 0xd5c00000-0xd5c0ffff] page 4k
[    0.000000] init_memory_mapping: [mem 0xd670d000-0xd670dfff]
[    0.000000]  [mem 0xd670d000-0xd670dfff] page 4k
[    0.000000] init_memory_mapping: [mem 0xd6751000-0xd6ffffff]
[    0.000000]  [mem 0xd6751000-0xd67fffff] page 4k
[    0.000000]  [mem 0xd6800000-0xd6ffffff] page 2M
[    0.000000] RAMDISK: [mem 0x35d88000-0x36ebbfff]
[    0.000000] ACPI: RSDP 00000000000f0490 00024 (v02  INTEL)
[    0.000000] ACPI: XSDT 00000000d6313070 00064 (v01 INTEL  DH61AG   0000006A AMI  00010013)
[    0.000000] ACPI: FACP 00000000d631c828 0010C (v05 INTEL  DH61AG   0000006A AMI  00010013)
[    0.000000] ACPI: DSDT 00000000d6313168 096BF (v02 INTEL  DH61AG   0000006A INTL 20051117)
[    0.000000] ACPI: FACS 00000000d6428080 00040
[    0.000000] ACPI: APIC 00000000d631c938 00072 (v03 INTEL  DH61AG   0000006A AMI  00010013)
[    0.000000] ACPI: FPDT 00000000d631c9b0 00044 (v01 INTEL  DH61AG   0000006A AMI  00010013)
[    0.000000] ACPI: MCFG 00000000d631c9f8 0003C (v01 INTEL  DH61AG   0000006A MSFT 00000097)
[    0.000000] ACPI: HPET 00000000d631ca38 00038 (v01 INTEL  DH61AG   0000006A AMI. 00000005)
[    0.000000] ACPI: SSDT 00000000d631ca70 0036D (v01 INTEL  DH61AG   0000006A INTL 20091112)
[    0.000000] ACPI: SSDT 00000000d631cde0 009AA (v01 INTEL  DH61AG   0000006A INTL 20051117)
[    0.000000] ACPI: SSDT 00000000d631d790 00A92 (v01 INTEL  DH61AG   0000006A INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000011f5fffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x11f5fffff]
[    0.000000]   NODE_DATA [mem 0x11f5f7000-0x11f5fbfff]
[    0.000000]  [ffffea0000000000-ffffea00047fffff] PMD -> [ffff88011ae00000-ffff88011ebfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x11f5fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
[    0.000000]   node   0: [mem 0x20200000-0x40003fff]
[    0.000000]   node   0: [mem 0x40005000-0xd5c0ffff]
[    0.000000]   node   0: [mem 0xd670d000-0xd670dfff]
[    0.000000]   node   0: [mem 0xd6751000-0xd6ffffff]
[    0.000000]   node   0: [mem 0x100000000-0x11f5fffff]
[    0.000000] On node 0 totalpages: 1005659
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 13643 pages used for memmap
[    0.000000]   DMA32 zone: 873151 pages, LIFO batch:31
[    0.000000]   Normal zone: 2008 pages used for memmap
[    0.000000]   Normal zone: 128512 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009dfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x20000000-0x201fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x40004000-0x40004fff]
[    0.000000] PM: Registered nosave memory: [mem 0xd5c10000-0xd630efff]
[    0.000000] PM: Registered nosave memory: [mem 0xd630f000-0xd631efff]
[    0.000000] PM: Registered nosave memory: [mem 0xd631f000-0xd6429fff]
[    0.000000] PM: Registered nosave memory: [mem 0xd642a000-0xd670cfff]
[    0.000000] PM: Registered nosave memory: [mem 0xd670e000-0xd6750fff]
[    0.000000] PM: Registered nosave memory: [mem 0xd7000000-0xd77fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xd7800000-0xdf9fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdfa00000-0xf7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfbffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfecfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed03fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed04000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0xdfa00000-0xf7ffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88011f200000 s86592 r8192 d24000 u524288
[    0.000000] pcpu-alloc: s86592 r8192 d24000 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 989923
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.12.1-031201-generic root=UUID=7f1378fa-0837-48fa-aa07-74ee97a6170a ro quiet splash vt.handoff=7
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 3858416K/4022636K available (7539K kernel code, 1118K rwdata, 3516K rodata, 1340K init, 1416K bss, 164220K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=4.
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-255.
[    0.000000] NR_IRQS:16640 nr_irqs:712 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 16252928 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.004000] tsc: Detected 3392.301 MHz processor
[    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 6784.60 BogoMIPS (lpj=13569204)
[    0.000004] pid_max: default: 32768 minimum: 301
[    0.000019] Security Framework initialized
[    0.000033] AppArmor: AppArmor initialized
[    0.000033] Yama: becoming mindful.
[    0.000254] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.001199] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.001619] Mount-cache hash table entries: 256
[    0.001755] Initializing cgroup subsys memory
[    0.001763] Initializing cgroup subsys devices
[    0.001765] Initializing cgroup subsys freezer
[    0.001766] Initializing cgroup subsys blkio
[    0.001767] Initializing cgroup subsys perf_event
[    0.001769] Initializing cgroup subsys hugetlb
[    0.001786] CPU: Physical Processor ID: 0
[    0.001786] CPU: Processor Core ID: 0
[    0.001790] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.001790] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.001793] mce: CPU supports 7 MCE banks
[    0.001802] CPU0: Thermal monitoring enabled (TM1)
[    0.001809] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
[    0.001809] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
[    0.001809] tlb_flushall_shift: 1
[    0.001903] Freeing SMP alternatives memory: 28K (ffffffff81e68000 - ffffffff81e6f000)
[    0.002755] ACPI: Core revision 20130725
[    0.006175] ACPI: All ACPI Tables successfully acquired
[    0.016819] ftrace: allocating 31049 entries in 122 pages
[    0.027790] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.067492] smpboot: CPU0: Intel(R) Core(TM) i3-3240 CPU @ 3.40GHz (fam: 06, model: 3a, stepping: 09)
[    0.067499] TSC deadline timer enabled
[    0.069039] Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge events, full-width counters, Intel PMU driver.
[    0.069045] ... version:                3
[    0.069046] ... bit width:              48
[    0.069046] ... generic registers:      4
[    0.069047] ... value mask:             0000ffffffffffff
[    0.069048] ... max period:             0000ffffffffffff
[    0.069048] ... fixed-purpose events:   3
[    0.069049] ... event mask:             000000070000000f
[    0.083140] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.070059] smpboot: Booting Node   0, Processors  #   1 #   2 #   3 OK
[    0.109487] Brought up 4 CPUs
[    0.109490] smpboot: Total of 4 processors activated (27138.40 BogoMIPS)
[    0.112180] devtmpfs: initialized
[    0.115376] EVM: security.selinux
[    0.115377] EVM: security.SMACK64
[    0.115377] EVM: security.capability
[    0.115409] PM: Registering ACPI NVS region [mem 0xd631f000-0xd6429fff] (1093632 bytes)
[    0.115420] PM: Registering ACPI NVS region [mem 0xd670e000-0xd6750fff] (274432 bytes)
[    0.115942] pinctrl core: initialized pinctrl subsystem
[    0.115981] regulator-dummy: no parameters
[    0.116009] RTC time: 17:47:24, date: 01/14/14
[    0.116031] NET: Registered protocol family 16
[    0.116096] cpuidle: using governor ladder
[    0.116097] cpuidle: using governor menu
[    0.116120] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.116121] ACPI: bus type PCI registered
[    0.116122] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.116155] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.116157] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.120807] PCI: Using configuration type 1 for base access
[    0.121374] bio: create slab <bio-0> at 0
[    0.121484] ACPI: Added _OSI(Module Device)
[    0.121485] ACPI: Added _OSI(Processor Device)
[    0.121486] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.121487] ACPI: Added _OSI(Processor Aggregator Device)
[    0.122652] ACPI: EC: Look up EC in DSDT
[    0.123818] ACPI: Executed 1 blocks of module-level executable AML code
[    0.129798] ACPI: SSDT 00000000d62bb018 0083B (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    0.130079] ACPI: Dynamic OEM Table Load:
[    0.130080] ACPI: SSDT           (null) 0083B (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    0.133685] ACPI: SSDT 00000000d62bca98 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
[    0.133983] ACPI: Dynamic OEM Table Load:
[    0.133984] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
[    0.137603] ACPI: SSDT 00000000d62bdc18 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
[    0.137879] ACPI: Dynamic OEM Table Load:
[    0.137880] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
[    0.141902] ACPI: Interpreter enabled
[    0.141906] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130725/hwxface-571)
[    0.141909] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130725/hwxface-571)
[    0.141919] ACPI: (supports S0 S3 S4 S5)
[    0.141919] ACPI: Using IOAPIC for interrupt routing
[    0.141937] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.142046] ACPI: No dock devices found.
[    0.146621] ACPI: Power Resource [FN00] (off)
[    0.146673] ACPI: Power Resource [FN01] (off)
[    0.146723] ACPI: Power Resource [FN02] (off)
[    0.146774] ACPI: Power Resource [FN03] (off)
[    0.146824] ACPI: Power Resource [FN04] (off)
[    0.147257] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.147406] acpi PNP0A08:00: Requesting ACPI _OSC control (0x1d)
[    0.147537] acpi PNP0A08:00: ACPI _OSC control (0x18) granted
[    0.147866] ACPI: \_SB_.PCI0.TPMX: can't evaluate _ADR (0x5)
[    0.147990] ACPI: \_SB_.PCI0.PDRC: can't evaluate _ADR (0x5)
[    0.147991] ACPI: \_SB_.PCI0.DOCK: can't evaluate _ADR (0x5)
[    0.147992] PCI host bridge to bus 0000:00
[    0.147994] pci_bus 0000:00: root bus resource [bus 00-3e]
[    0.147995] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.147996] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.147997] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.147999] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
[    0.148000] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.148001] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.148002] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    0.148003] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
[    0.148004] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
[    0.148006] pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xfeafffff]
[    0.148011] pci 0000:00:00.0: [8086:0150] type 00 class 0x060000
[    0.148079] pci 0000:00:02.0: [8086:0152] type 00 class 0x030000
[    0.148087] pci 0000:00:02.0: reg 0x10: [mem 0xf7800000-0xf7bfffff 64bit]
[    0.148092] pci 0000:00:02.0: reg 0x18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.148095] pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
[    0.148178] pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
[    0.148200] pci 0000:00:16.0: reg 0x10: [mem 0xf7d2b000-0xf7d2b00f 64bit]
[    0.148272] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.148340] pci 0000:00:19.0: [8086:1503] type 00 class 0x020000
[    0.148357] pci 0000:00:19.0: reg 0x10: [mem 0xf7d00000-0xf7d1ffff]
[    0.148365] pci 0000:00:19.0: reg 0x14: [mem 0xf7d29000-0xf7d29fff]
[    0.148373] pci 0000:00:19.0: reg 0x18: [io  0xf080-0xf09f]
[    0.148437] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.148501] pci 0000:00:1a.0: [8086:1c2d] type 00 class 0x0c0320
[    0.148521] pci 0000:00:1a.0: reg 0x10: [mem 0xf7d28000-0xf7d283ff]
[    0.148607] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.148657] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.148683] pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
[    0.148697] pci 0000:00:1b.0: reg 0x10: [mem 0xf7d20000-0xf7d23fff 64bit]
[    0.148761] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.148802] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.148826] pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
[    0.148901] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.148944] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.148966] pci 0000:00:1c.1: [8086:1c12] type 01 class 0x060400
[    0.149041] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.149084] pci 0000:00:1c.1: System wakeup disabled by ACPI
[    0.149115] pci 0000:00:1d.0: [8086:1c26] type 00 class 0x0c0320
[    0.149135] pci 0000:00:1d.0: reg 0x10: [mem 0xf7d27000-0xf7d273ff]
[    0.149220] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.149269] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.149296] pci 0000:00:1f.0: [8086:1c5c] type 00 class 0x060100
[    0.149451] pci 0000:00:1f.2: [8086:1c02] type 00 class 0x010601
[    0.149468] pci 0000:00:1f.2: reg 0x10: [io  0xf0d0-0xf0d7]
[    0.149476] pci 0000:00:1f.2: reg 0x14: [io  0xf0c0-0xf0c3]
[    0.149483] pci 0000:00:1f.2: reg 0x18: [io  0xf0b0-0xf0b7]
[    0.149491] pci 0000:00:1f.2: reg 0x1c: [io  0xf0a0-0xf0a3]
[    0.149498] pci 0000:00:1f.2: reg 0x20: [io  0xf060-0xf07f]
[    0.149506] pci 0000:00:1f.2: reg 0x24: [mem 0xf7d26000-0xf7d267ff]
[    0.149549] pci 0000:00:1f.2: PME# supported from D3hot
[    0.149605] pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
[    0.149620] pci 0000:00:1f.3: reg 0x10: [mem 0xf7d25000-0xf7d250ff 64bit]
[    0.149639] pci 0000:00:1f.3: reg 0x20: [io  0xf040-0xf05f]
[    0.149760] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.149856] pci 0000:02:00.0: [1033:0194] type 00 class 0x0c0330
[    0.149896] pci 0000:02:00.0: reg 0x10: [mem 0xf7c00000-0xf7c01fff 64bit]
[    0.150076] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.150132] pci 0000:02:00.0: System wakeup disabled by ACPI
[    0.160442] pci 0000:00:1c.1: PCI bridge to [bus 02]
[    0.160453] pci 0000:00:1c.1:   bridge window [mem 0xf7c00000-0xf7cfffff]
[    0.160494] acpi PNP0A08:00: Disabling ASPM (FADT indicates it is unsupported)
[    0.160940] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.160978] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 *4 5 6 10 11 12 14 15)
[    0.161017] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.161053] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.161089] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 10 11 12 14 15)
[    0.161126] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.161163] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 10 11 12 14 15)
[    0.161198] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.161382] ACPI: Enabled 7 GPEs in block 00 to 3F
[    0.161386] ACPI: \_SB_.PCI0: notify handler is installed
[    0.161427] Found 1 acpi root devices
[    0.161496] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.161498] vgaarb: loaded
[    0.161499] vgaarb: bridge control possible 0000:00:02.0
[    0.161603] SCSI subsystem initialized
[    0.161642] libata version 3.00 loaded.
[    0.161664] ACPI: bus type USB registered
[    0.161676] usbcore: registered new interface driver usbfs
[    0.161682] usbcore: registered new interface driver hub
[    0.161701] usbcore: registered new device driver usb
[    0.161769] PCI: Using ACPI for IRQ routing
[    0.163226] PCI: pci_cache_line_size set to 64 bytes
[    0.163261] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
[    0.163262] e820: reserve RAM buffer [mem 0x40004000-0x43ffffff]
[    0.163263] e820: reserve RAM buffer [mem 0xd5c10000-0xd7ffffff]
[    0.163265] e820: reserve RAM buffer [mem 0xd670e000-0xd7ffffff]
[    0.163266] e820: reserve RAM buffer [mem 0xd7000000-0xd7ffffff]
[    0.163267] e820: reserve RAM buffer [mem 0x11f600000-0x11fffffff]
[    0.163329] NetLabel: Initializing
[    0.163330] NetLabel:  domain hash size = 128
[    0.163331] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.163337] NetLabel:  unlabeled traffic allowed by default
[    0.163380] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.163384] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.165413] Switched to clocksource hpet
[    0.168766] AppArmor: AppArmor Filesystem Enabled
[    0.168788] pnp: PnP ACPI init
[    0.168797] ACPI: bus type PNP registered
[    0.168879] system 00:00: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.168882] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.168892] pnp 00:01: [dma 4]
[    0.168901] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.168913] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    0.168979] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.169003] system 00:04: [io  0x0680-0x069f] has been reserved
[    0.169006] system 00:04: [io  0x1000-0x100f] has been reserved
[    0.169007] system 00:04: [io  0xffff] has been reserved
[    0.169008] system 00:04: [io  0xffff] has been reserved
[    0.169010] system 00:04: [io  0x0400-0x0453] could not be reserved
[    0.169011] system 00:04: [io  0x0458-0x047f] has been reserved
[    0.169012] system 00:04: [io  0x0500-0x057f] has been reserved
[    0.169013] system 00:04: [io  0x164e-0x164f] has been reserved
[    0.169015] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.169037] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.169065] system 00:06: [io  0x0454-0x0457] has been reserved
[    0.169066] system 00:06: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.169153] system 00:07: [io  0x0a00-0x0a0f] has been reserved
[    0.169155] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.169184] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    0.169215] pnp 00:09: Plug and Play ACPI device, IDs PNP0f03 PNP0f13 (active)
[    0.169343] system 00:0a: [io  0x04d0-0x04d1] has been reserved
[    0.169345] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.169360] pnp 00:0b: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.169535] system 00:0c: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.169537] system 00:0c: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.169538] system 00:0c: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.169540] system 00:0c: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.169541] system 00:0c: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.169542] system 00:0c: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.169544] system 00:0c: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.169545] system 00:0c: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.169546] system 00:0c: [mem 0xff000000-0xffffffff] has been reserved
[    0.169548] system 00:0c: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.169549] system 00:0c: [mem 0xdfa00000-0xdfa00fff] has been reserved
[    0.169551] system 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.169655] system 00:0d: [mem 0x20000000-0x201fffff] has been reserved
[    0.169656] system 00:0d: [mem 0x40004000-0x40004fff] has been reserved
[    0.169658] system 00:0d: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.169671] pnp: PnP ACPI: found 14 devices
[    0.169672] ACPI: bus type PNP unregistered
[    0.175672] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.175684] pci 0000:00:1c.1: PCI bridge to [bus 02]
[    0.175688] pci 0000:00:1c.1:   bridge window [mem 0xf7c00000-0xf7cfffff]
[    0.175696] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.175698] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.175699] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.175700] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.175701] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.175703] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.175704] pci_bus 0000:00: resource 10 [mem 0x000dc000-0x000dffff]
[    0.175705] pci_bus 0000:00: resource 11 [mem 0x000e0000-0x000e3fff]
[    0.175706] pci_bus 0000:00: resource 12 [mem 0x000e4000-0x000e7fff]
[    0.175707] pci_bus 0000:00: resource 13 [mem 0xdfa00000-0xfeafffff]
[    0.175709] pci_bus 0000:02: resource 1 [mem 0xf7c00000-0xf7cfffff]
[    0.175730] NET: Registered protocol family 2
[    0.175842] TCP established hash table entries: 32768 (order: 7, 524288 bytes)
[    0.175968] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
[    0.176060] TCP: Hash tables configured (established 32768 bind 32768)
[    0.176075] TCP: reno registered
[    0.176081] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.176096] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.176139] NET: Registered protocol family 1
[    0.176147] pci 0000:00:02.0: Boot video device
[    0.213656] PCI: CLS 64 bytes, default 64
[    0.213689] Trying to unpack rootfs image as initramfs...
[    0.413428] Freeing initrd memory: 17616K (ffff880035d88000 - ffff880036ebc000)
[    0.413432] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.413434] software IO TLB [mem 0xd1c10000-0xd5c10000] (64MB) mapped at [ffff8800d1c10000-ffff8800d5c0ffff]
[    0.413637] Scanning for low memory corruption every 60 seconds
[    0.413852] Initialise module verification
[    0.413883] audit: initializing netlink socket (disabled)
[    0.413893] type=2000 audit(1389721644.404:1): initialized
[    0.433969] bounce pool size: 64 pages
[    0.433979] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.434686] zbud: loaded
[    0.434784] VFS: Disk quotas dquot_6.5.2
[    0.434807] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.435091] fuse init (API version 7.22)
[    0.435137] msgmni has been set to 7570
[    0.435531] Key type asymmetric registered
[    0.435533] Asymmetric key parser 'x509' registered
[    0.435550] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.435580] io scheduler noop registered
[    0.435581] io scheduler deadline registered (default)
[    0.435596] io scheduler cfq registered
[    0.435815] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.435824] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.450862] Console: switching to colour frame buffer device 80x30
[    0.465722] simple-framebuffer simple-framebuffer.0: fb0: simplefb registered!
[    0.465727] intel_idle: MWAIT substates: 0x1120
[    0.465728] intel_idle: v0.4 model 0x3A
[    0.465729] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.465839] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    0.465843] ACPI: Power Button [PWRB]
[    0.465864] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.465866] ACPI: Power Button [PWRF]
[    0.465907] ACPI: Fan [FAN0] (off)
[    0.465925] ACPI: Fan [FAN1] (off)
[    0.465942] ACPI: Fan [FAN2] (off)
[    0.465956] ACPI: Fan [FAN3] (off)
[    0.465974] ACPI: Fan [FAN4] (off)
[    0.466009] ACPI: Requesting acpi_cpufreq
[    0.473792] thermal LNXTHERM:00: registered as thermal_zone0
[    0.473794] ACPI: Thermal Zone [TZ00] (28 C)
[    0.473927] thermal LNXTHERM:01: registered as thermal_zone1
[    0.473928] ACPI: Thermal Zone [TZ01] (30 C)
[    0.473947] GHES: HEST is not enabled!
[    0.474002] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    0.475161] Linux agpgart interface v0.103
[    0.475958] brd: module loaded
[    0.476328] loop: module loaded
[    0.476529] libphy: Fixed MDIO Bus: probed
[    0.476577] tun: Universal TUN/TAP device driver, 1.6
[    0.476578] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.476607] PPP generic driver version 2.4.2
[    0.476636] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.476638] ehci-pci: EHCI PCI platform driver
[    0.476721] ehci-pci 0000:00:1a.0: setting latency timer to 64
[    0.476727] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    0.476731] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    0.476743] ehci-pci 0000:00:1a.0: debug port 2
[    0.480631] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    0.480645] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf7d28000
[    0.489574] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    0.489607] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.489608] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.489609] usb usb1: Product: EHCI Host Controller
[    0.489611] usb usb1: Manufacturer: Linux 3.12.1-031201-generic ehci_hcd
[    0.489612] usb usb1: SerialNumber: 0000:00:1a.0
[    0.489681] hub 1-0:1.0: USB hub found
[    0.489686] hub 1-0:1.0: 2 ports detected
[    0.489828] ehci-pci 0000:00:1d.0: setting latency timer to 64
[    0.489832] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    0.489835] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    0.489846] ehci-pci 0000:00:1d.0: debug port 2
[    0.493760] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    0.493774] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf7d27000
[    0.505605] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    0.505663] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.505665] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.505666] usb usb2: Product: EHCI Host Controller
[    0.505667] usb usb2: Manufacturer: Linux 3.12.1-031201-generic ehci_hcd
[    0.505668] usb usb2: SerialNumber: 0000:00:1d.0
[    0.505794] hub 2-0:1.0: USB hub found
[    0.505802] hub 2-0:1.0: 2 ports detected
[    0.505880] ehci-platform: EHCI generic platform driver
[    0.505885] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.505886] ohci-platform: OHCI generic platform driver
[    0.505890] uhci_hcd: USB Universal Host Controller Interface driver
[    0.505940] xhci_hcd 0000:02:00.0: xHCI Host Controller
[    0.505945] xhci_hcd 0000:02:00.0: new USB bus registered, assigned bus number 3
[    0.506118] xhci_hcd 0000:02:00.0: irq 40 for MSI/MSI-X
[    0.506121] xhci_hcd 0000:02:00.0: irq 41 for MSI/MSI-X
[    0.506124] xhci_hcd 0000:02:00.0: irq 42 for MSI/MSI-X
[    0.506128] xhci_hcd 0000:02:00.0: irq 43 for MSI/MSI-X
[    0.506131] xhci_hcd 0000:02:00.0: irq 44 for MSI/MSI-X
[    0.506244] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    0.506245] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.506246] usb usb3: Product: xHCI Host Controller
[    0.506247] usb usb3: Manufacturer: Linux 3.12.1-031201-generic xhci_hcd
[    0.506248] usb usb3: SerialNumber: 0000:02:00.0
[    0.506363] hub 3-0:1.0: USB hub found
[    0.506374] hub 3-0:1.0: 2 ports detected
[    0.506429] xhci_hcd 0000:02:00.0: xHCI Host Controller
[    0.506431] xhci_hcd 0000:02:00.0: new USB bus registered, assigned bus number 4
[    0.509548] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
[    0.509549] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.509550] usb usb4: Product: xHCI Host Controller
[    0.509551] usb usb4: Manufacturer: Linux 3.12.1-031201-generic xhci_hcd
[    0.509552] usb usb4: SerialNumber: 0000:02:00.0
[    0.509640] hub 4-0:1.0: USB hub found
[    0.509651] hub 4-0:1.0: 2 ports detected
[    0.517680] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    0.520591] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.520598] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.520741] mousedev: PS/2 mouse device common for all mice
[    0.520988] rtc_cmos 00:05: RTC can wake from S4
[    0.521138] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    0.521166] rtc_cmos 00:05: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    0.521208] device-mapper: uevent: version 1.0.3
[    0.521299] device-mapper: ioctl: 4.26.0-ioctl (2013-08-15) initialised: dm-devel@redhat.com
[    0.521303] Intel P-state driver initializing.
[    0.521311] Intel pstate controlling: cpu 0
[    0.521324] Intel pstate controlling: cpu 1
[    0.521331] Intel pstate controlling: cpu 2
[    0.521338] Intel pstate controlling: cpu 3
[    0.521352] ledtrig-cpu: registered to indicate activity on CPUs
[    0.521404] TCP: cubic registered
[    0.521451] NET: Registered protocol family 10
[    0.521566] NET: Registered protocol family 17
[    0.521572] Key type dns_resolver registered
[    0.521832] Loading module verification certificates
[    0.522401] MODSIGN: Loaded cert 'Magrathea: Glacier signing key: b1d410877cfeae5f9ffc8f10def18d7693a99d6c'
[    0.522408] registered taskstats version 1
[    0.524197] Key type trusted registered
[    0.525602] Key type encrypted registered
[    0.526970] AppArmor: AppArmor sha1 policy hashing enabled
[    0.527198]   Magic number: 14:60:795
[    0.527282] rtc_cmos 00:05: setting system clock to 2014-01-14 17:47:24 UTC (1389721644)
[    0.527324] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    0.527325] EDD information not available.
[    0.527360] PM: Hibernation image not present or could not be loaded.
[    0.528119] Freeing unused kernel memory: 1340K (ffffffff81d19000 - ffffffff81e68000)
[    0.528120] Write protecting the kernel read-only data: 12288k
[    0.529146] Freeing unused kernel memory: 640K (ffff880001760000 - ffff880001800000)
[    0.530004] Freeing unused kernel memory: 580K (ffff880001b6f000 - ffff880001c00000)
[    0.540342] systemd-udevd[115]: starting version 204
[    0.559325] pps_core: LinuxPPS API ver. 1 registered
[    0.559328] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.560144] PTP clock support registered
[    0.563605] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    0.563607] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[    0.563745] e1000e 0000:00:19.0: setting latency timer to 64
[    0.563807] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    0.563826] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[    0.801804] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    0.828675] e1000e 0000:00:19.0 eth0: registered PHC clock
[    0.828678] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) e0:cb:4e:28:cb:a8
[    0.828679] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[    0.828713] e1000e 0000:00:19.0 eth0: MAC: 10, PHY: 11, PBA No: FFFFFF-0FF
[    0.828733] ahci 0000:00:1f.2: version 3.0
[    0.828887] ahci 0000:00:1f.2: irq 46 for MSI/MSI-X
[    0.828932] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 4 ports 3 Gbps 0x3 impl SATA mode
[    0.828934] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part ems apst 
[    0.828938] ahci 0000:00:1f.2: setting latency timer to 64
[    0.834018] scsi0 : ahci
[    0.834088] scsi1 : ahci
[    0.834152] scsi2 : ahci
[    0.834209] scsi3 : ahci
[    0.834245] ata1: SATA max UDMA/133 abar m2048@0xf7d26000 port 0xf7d26100 irq 46
[    0.834248] ata2: SATA max UDMA/133 abar m2048@0xf7d26000 port 0xf7d26180 irq 46
[    0.834248] ata3: DUMMY
[    0.834249] ata4: DUMMY
[    0.934205] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[    0.934209] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    0.934559] hub 1-1:1.0: USB hub found
[    0.934646] hub 1-1:1.0: 4 ports detected
[    1.045902] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    1.153923] ata1: SATA link down (SStatus 0 SControl 300)
[    1.157931] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.169400] ata2.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    1.169405] ata2.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[    1.169408] ata2.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
[    1.178316] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[    1.178320] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.178705] hub 2-1:1.0: USB hub found
[    1.178765] hub 2-1:1.0: 6 ports detected
[    1.179806] ata2.00: ATA-8: MKNSSDCR60GB, 502ABBF0, max UDMA/133
[    1.179811] ata2.00: 117231408 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.189330] ata2.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    1.189335] ata2.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[    1.189348] ata2.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
[    1.199842] ata2.00: configured for UDMA/133
[    1.200082] scsi 1:0:0:0: Direct-Access     ATA      MKNSSDCR60GB     502A PQ: 0 ANSI: 5
[    1.200212] sd 1:0:0:0: [sda] 117231408 512-byte logical blocks: (60.0 GB/55.8 GiB)
[    1.200215] sd 1:0:0:0: Attached scsi generic sg0 type 0
[    1.200349] sd 1:0:0:0: [sda] Write Protect is off
[    1.200352] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.200489] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.201512]  sda: sda1 sda2
[    1.201617] sda: p2 size 16384000 extends beyond EOD, enabling native capacity
[    1.202398]  sda: sda1 sda2
[    1.202467] sda: p2 size 16384000 extends beyond EOD, truncated
[    1.202759] sd 1:0:0:0: [sda] Attached SCSI disk
[    1.290002] usb 3-1: new full-speed USB device number 2 using xhci_hcd
[    1.356016] usb 3-1: New USB device found, idVendor=147a, idProduct=e03e
[    1.356019] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    1.356021] usb 3-1: Product: eHome Infrared Transceiver
[    1.356022] usb 3-1: Manufacturer: Formosa21
[    1.356024] usb 3-1: SerialNumber: 0000A590
[    1.356217] usb 3-1: ep 0x83 - rounding interval to 64 microframes, ep desc says 80 microframes
[    1.361216] hidraw: raw HID events driver (C) Jiri Kosina
[    1.375124] usbcore: registered new interface driver usbhid
[    1.375127] usbhid: USB HID core driver
[    1.376673] hid-generic 0003:147A:E03E.0001: hiddev0,hidraw0: USB HID v1.00 Device [Formosa21 eHome Infrared Transceiver] on usb-0000:02:00.0-1/input1
[    1.410036] tsc: Refined TSC clocksource calibration: 3392.294 MHz
[    1.430189] usb 1-1.1: new full-speed USB device number 3 using ehci-pci
[    1.526147] usb 1-1.1: New USB device found, idVendor=046d, idProduct=c52f
[    1.526151] usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.526153] usb 1-1.1: Product: USB Receiver
[    1.526155] usb 1-1.1: Manufacturer: Logitech
[    1.528410] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.1/1-1.1:1.0/input/input4
[    1.528719] hid-generic 0003:046D:C52F.0002: input,hidraw1: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:1a.0-1.1/input0
[    1.530780] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.1/1-1.1:1.1/input/input5
[    1.531057] hid-generic 0003:046D:C52F.0003: input,hiddev0,hidraw2: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:1a.0-1.1/input1
[    1.602247] usb 1-1.2: new full-speed USB device number 4 using ehci-pci
[    1.697668] usb 1-1.2: New USB device found, idVendor=046d, idProduct=c52b
[    1.697672] usb 1-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.697675] usb 1-1.2: Product: USB Receiver
[    1.697677] usb 1-1.2: Manufacturer: Logitech
[    1.705994] logitech-djreceiver 0003:046D:C52B.0006: hiddev0,hidraw3: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:1a.0-1.2/input2
[    1.708938] input: Logitech Unifying Device. Wireless PID:2007 as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.2/0003:046D:C52B.0006/input/input6
[    1.709039] logitech-djdevice 0003:046D:C52B.0007: input,hidraw4: USB HID v1.11 Keyboard [Logitech Unifying Device. Wireless PID:2007] on usb-0000:00:1a.0-1.2:1
[    2.410644] Switched to clocksource tsc
[    6.242027] EXT4-fs (sda1): INFO: recovery required on readonly filesystem
[    6.242030] EXT4-fs (sda1): write access will be enabled during recovery
[    6.262227] EXT4-fs (sda1): recovery complete
[    6.262671] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    6.355795] init: ureadahead main process (181) terminated with status 5
[    6.415654] Adding 7673748k swap on /dev/sda2.  Priority:-1 extents:1 across:7673748k SSFS
[    6.472965] EXT4-fs (sda1): re-mounted. Opts: discard,errors=remount-ro
[    6.481342] systemd-udevd[299]: starting version 204
[    6.510952] lp: driver loaded but no devices found
[    6.555012] mei_me 0000:00:16.0: setting latency timer to 64
[    6.555052] mei_me 0000:00:16.0: irq 47 for MSI/MSI-X
[    6.566608] [drm] Initialized drm 1.1.0 20060810
[    6.594604] [drm] Memory usable by graphics device = 2048M
[    6.594609] checking generic (e0000000 12c000) vs hw (e0000000 10000000)
[    6.594611] fb: conflicting fb hw usage inteldrmfb vs simple - removing generic driver
[    6.594629] Console: switching to colour dummy device 80x25
[    6.596698] i915 0000:00:02.0: setting latency timer to 64
[    6.620657] microcode: CPU0 sig=0x306a9, pf=0x2, revision=0x17
[    6.627638] i915 0000:00:02.0: irq 48 for MSI/MSI-X
[    6.627649] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    6.627651] [drm] Driver supports precise vblank timestamp query.
[    6.630213] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    6.656427] Registered IR keymap rc-rc6-mce
[    6.656668] input: Media Center Ed. eHome Infrared Remote Transceiver (147a:e03e) as /devices/pci0000:00/0000:00:1c.1/0000:02:00.0/usb3/3-1/3-1:1.0/rc/rc0/input8
[    6.656721] rc0: Media Center Ed. eHome Infrared Remote Transceiver (147a:e03e) as /devices/pci0000:00/0000:00:1c.1/0000:02:00.0/usb3/3-1/3-1:1.0/rc/rc0
[    6.660878] IR NEC protocol handler initialized
[    6.663737] IR RC5(x) protocol handler initialized
[    6.665722] IR RC6 protocol handler initialized
[    6.667118] IR JVC protocol handler initialized
[    6.667726] IR Sony protocol handler initialized
[    6.671745] IR SANYO protocol handler initialized
[    6.675147] IR MCE Keyboard/mouse protocol handler initialized
[    6.675589] input: MCE IR Keyboard/Mouse (mceusb) as /devices/virtual/input/input9
[    6.677033] lirc_dev: IR Remote Control driver registered, major 248 
[    6.678365] rc rc0: lirc_dev: driver ir-lirc-codec (mceusb) registered at minor = 0
[    6.678368] IR LIRC bridge handler initialized
[    6.715309] Bluetooth: Core ver 2.16
[    6.715329] NET: Registered protocol family 31
[    6.715331] Bluetooth: HCI device and connection manager initialized
[    6.715339] Bluetooth: HCI socket layer initialized
[    6.715341] Bluetooth: L2CAP socket layer initialized
[    6.715347] Bluetooth: SCO socket layer initialized
[    6.728599] Bluetooth: RFCOMM TTY layer initialized
[    6.728611] Bluetooth: RFCOMM socket layer initialized
[    6.728613] Bluetooth: RFCOMM ver 1.11
[    6.741028] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    6.741032] Bluetooth: BNEP filters: protocol multicast
[    6.741041] Bluetooth: BNEP socket layer initialized
[    6.759591] ppdev: user-space parallel port driver
[    6.765988] init: avahi-cups-reload main process (523) terminated with status 1
[    6.812689] microcode: CPU1 sig=0x306a9, pf=0x2, revision=0x17
[    6.822132] microcode: CPU2 sig=0x306a9, pf=0x2, revision=0x17
[    6.823038] microcode: CPU3 sig=0x306a9, pf=0x2, revision=0x17
[    6.823995] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    6.832515] mceusb 3-1:1.0: Registered Formosa21 eHome Infrared Transceiver with mce emulator interface version 2
[    6.832518] mceusb 3-1:1.0: 0 tx ports (0x0 cabled) and 1 rx sensors (0x1 active)
[    6.832564] usbcore: registered new interface driver mceusb
[    6.973606] type=1400 audit(1389721650.941:2): apparmor="STATUS" operation="profile_load" name="/sbin/dhclient" pid=594 comm="apparmor_parser"
[    6.973612] type=1400 audit(1389721650.941:3): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=594 comm="apparmor_parser"
[    6.973616] type=1400 audit(1389721650.941:4): apparmor="STATUS" operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" pid=594 comm="apparmor_parser"
[    6.974049] type=1400 audit(1389721650.941:5): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=594 comm="apparmor_parser"
[    6.974054] type=1400 audit(1389721650.941:6): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=594 comm="apparmor_parser"
[    6.974280] type=1400 audit(1389721650.941:7): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=594 comm="apparmor_parser"
[    6.978976] type=1400 audit(1389721650.945:8): apparmor="STATUS" operation="profile_load" name="/usr/sbin/ntpd" pid=596 comm="apparmor_parser"
[    7.068209] type=1400 audit(1389721651.033:9): apparmor="STATUS" operation="profile_load" name="/usr/lib/cups/backend/cups-pdf" pid=591 comm="apparmor_parser"
[    7.068216] type=1400 audit(1389721651.033:10): apparmor="STATUS" operation="profile_load" name="/usr/sbin/cupsd" pid=591 comm="apparmor_parser"
[    7.069006] type=1400 audit(1389721651.037:11): apparmor="STATUS" operation="profile_replace" name="/usr/sbin/cupsd" pid=591 comm="apparmor_parser"
[    7.121535] init: failsafe main process (610) killed by TERM signal
[    7.183104] fbcon: inteldrmfb (fb0) is primary device
[    7.388588] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[    7.488822] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[    7.488904] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[    7.829284] [drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp off
[    9.117654] Console: switching to colour frame buffer device 240x67
[    9.217903] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    9.217904] i915 0000:00:02.0: registered panic notifier
[    9.226308] acpi device:4b: registered as cooling_device10
[    9.226403] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    9.226440] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input10
[    9.226502] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    9.226576] ACPI Warning: 0x0000000000000428-0x000000000000042f SystemIO conflicts with Region \PMIO 1 (20130725/utaddress-251)
[    9.226583] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    9.226589] ACPI Warning: 0x0000000000000540-0x000000000000054f SystemIO conflicts with Region \GPIO 1 (20130725/utaddress-251)
[    9.226592] ACPI Warning: 0x0000000000000540-0x000000000000054f SystemIO conflicts with Region \_GPE.GPS0 2 (20130725/utaddress-251)
[    9.226595] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    9.226597] ACPI Warning: 0x0000000000000530-0x000000000000053f SystemIO conflicts with Region \GPIO 1 (20130725/utaddress-251)
[    9.226600] ACPI Warning: 0x0000000000000530-0x000000000000053f SystemIO conflicts with Region \_GPE.GPS0 2 (20130725/utaddress-251)
[    9.226602] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    9.226603] ACPI Warning: 0x0000000000000500-0x000000000000052f SystemIO conflicts with Region \GPIO 1 (20130725/utaddress-251)
[    9.226606] ACPI Warning: 0x0000000000000500-0x000000000000052f SystemIO conflicts with Region \_GPE.GPS0 2 (20130725/utaddress-251)
[    9.226609] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    9.226610] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    9.226934] snd_hda_intel 0000:00:1b.0: irq 49 for MSI/MSI-X
[    9.239866] autoconfig: line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:line
[    9.239869]    speaker_outs=1 (0x1a/0x0/0x0/0x0/0x0)
[    9.239870]    hp_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    9.239870]    mono: mono_out=0x0
[    9.239871]    dig-out=0x1e/0x0
[    9.239872]    inputs:
[    9.239873]      Mic=0x18
[    9.239874]      Internal Mic=0x12
[    9.257716] input: HDA Intel PCH HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input15
[    9.257780] input: HDA Intel PCH HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input14
[    9.257830] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[    9.257882] input: HDA Intel PCH Line Out as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[    9.257925] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[   10.843310] e1000e: eth1 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[   10.843347] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready

--MP_/kfv9i6UDJpGDGa5kkhzZwR5
Content-Type: text/x-log
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=kernel_3.12.7.log

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.12.7-031207-generic (apw@gomeisa) (gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #201401091657 SMP Thu Jan 9 21:59:37 UTC 2014
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.12.7-031207-generic root=UUID=7f1378fa-0837-48fa-aa07-74ee97a6170a ro quiet splash vt.handoff=7
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x0000000040003fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000040004000-0x0000000040004fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000040005000-0x00000000d5c0ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000d5c10000-0x00000000d630efff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000d630f000-0x00000000d631efff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000d631f000-0x00000000d6429fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000d642a000-0x00000000d670cfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000d670d000-0x00000000d670dfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000d670e000-0x00000000d6750fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000d6751000-0x00000000d6ffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000d7800000-0x00000000df9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011f5fffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI:                  /DH61AG, BIOS AGH6110H.86A.0106.2013.0509.1441 05/09/2013
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x11f600 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F00000000 write-back
[    0.000000]   1 base 100000000 mask FE0000000 write-back
[    0.000000]   2 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   3 base 0D8000000 mask FF8000000 uncachable
[    0.000000]   4 base 0D7800000 mask FFF800000 uncachable
[    0.000000]   5 base 11F800000 mask FFF800000 uncachable
[    0.000000]   6 base 11F600000 mask FFFE00000 uncachable
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 4GB, type WB
[    0.000000] reg 1, base: 4GB, range: 512MB, type WB
[    0.000000] reg 2, base: 3584MB, range: 512MB, type UC
[    0.000000] reg 3, base: 3456MB, range: 128MB, type UC
[    0.000000] reg 4, base: 3448MB, range: 8MB, type UC
[    0.000000] reg 5, base: 4600MB, range: 8MB, type UC
[    0.000000] reg 6, base: 4598MB, range: 2MB, type UC
[    0.000000] total RAM covered: 3950M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 16M 	num_reg: 8  	lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 3GB, range: 256MB, type WB
[    0.000000] reg 3, base: 3328MB, range: 128MB, type WB
[    0.000000] reg 4, base: 3448MB, range: 8MB, type UC
[    0.000000] reg 5, base: 4GB, range: 512MB, type WB
[    0.000000] reg 6, base: 4598MB, range: 2MB, type UC
[    0.000000] reg 7, base: 4600MB, range: 8MB, type UC
[    0.000000] e820: update [mem 0xd7800000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xd7000 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fd6e0-0x000fd6ef] mapped at [ffff8800000fd6e0]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01fd3000, 0x01fd3fff] PGTABLE
[    0.000000] BRK [0x01fd4000, 0x01fd4fff] PGTABLE
[    0.000000] BRK [0x01fd5000, 0x01fd5fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11f400000-0x11f5fffff]
[    0.000000]  [mem 0x11f400000-0x11f5fffff] page 2M
[    0.000000] BRK [0x01fd6000, 0x01fd6fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11c000000-0x11f3fffff]
[    0.000000]  [mem 0x11c000000-0x11f3fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x100000000-0x11bffffff]
[    0.000000]  [mem 0x100000000-0x11bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x1fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x1fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x20200000-0x40003fff]
[    0.000000]  [mem 0x20200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x40003fff] page 4k
[    0.000000] BRK [0x01fd7000, 0x01fd7fff] PGTABLE
[    0.000000] BRK [0x01fd8000, 0x01fd8fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x40005000-0xd5c0ffff]
[    0.000000]  [mem 0x40005000-0x401fffff] page 4k
[    0.000000]  [mem 0x40200000-0xd5bfffff] page 2M
[    0.000000]  [mem 0xd5c00000-0xd5c0ffff] page 4k
[    0.000000] init_memory_mapping: [mem 0xd670d000-0xd670dfff]
[    0.000000]  [mem 0xd670d000-0xd670dfff] page 4k
[    0.000000] init_memory_mapping: [mem 0xd6751000-0xd6ffffff]
[    0.000000]  [mem 0xd6751000-0xd67fffff] page 4k
[    0.000000]  [mem 0xd6800000-0xd6ffffff] page 2M
[    0.000000] RAMDISK: [mem 0x35da8000-0x36ecbfff]
[    0.000000] ACPI: RSDP 00000000000f0490 00024 (v02  INTEL)
[    0.000000] ACPI: XSDT 00000000d6313070 00064 (v01 INTEL  DH61AG   0000006A AMI  00010013)
[    0.000000] ACPI: FACP 00000000d631c828 0010C (v05 INTEL  DH61AG   0000006A AMI  00010013)
[    0.000000] ACPI: DSDT 00000000d6313168 096BF (v02 INTEL  DH61AG   0000006A INTL 20051117)
[    0.000000] ACPI: FACS 00000000d6428080 00040
[    0.000000] ACPI: APIC 00000000d631c938 00072 (v03 INTEL  DH61AG   0000006A AMI  00010013)
[    0.000000] ACPI: FPDT 00000000d631c9b0 00044 (v01 INTEL  DH61AG   0000006A AMI  00010013)
[    0.000000] ACPI: MCFG 00000000d631c9f8 0003C (v01 INTEL  DH61AG   0000006A MSFT 00000097)
[    0.000000] ACPI: HPET 00000000d631ca38 00038 (v01 INTEL  DH61AG   0000006A AMI. 00000005)
[    0.000000] ACPI: SSDT 00000000d631ca70 0036D (v01 INTEL  DH61AG   0000006A INTL 20091112)
[    0.000000] ACPI: SSDT 00000000d631cde0 009AA (v01 INTEL  DH61AG   0000006A INTL 20051117)
[    0.000000] ACPI: SSDT 00000000d631d790 00A92 (v01 INTEL  DH61AG   0000006A INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000011f5fffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x11f5fffff]
[    0.000000]   NODE_DATA [mem 0x11f5f7000-0x11f5fbfff]
[    0.000000]  [ffffea0000000000-ffffea00047fffff] PMD -> [ffff88011ae00000-ffff88011ebfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x11f5fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
[    0.000000]   node   0: [mem 0x20200000-0x40003fff]
[    0.000000]   node   0: [mem 0x40005000-0xd5c0ffff]
[    0.000000]   node   0: [mem 0xd670d000-0xd670dfff]
[    0.000000]   node   0: [mem 0xd6751000-0xd6ffffff]
[    0.000000]   node   0: [mem 0x100000000-0x11f5fffff]
[    0.000000] On node 0 totalpages: 1005659
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 13643 pages used for memmap
[    0.000000]   DMA32 zone: 873151 pages, LIFO batch:31
[    0.000000]   Normal zone: 2008 pages used for memmap
[    0.000000]   Normal zone: 128512 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009dfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x20000000-0x201fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x40004000-0x40004fff]
[    0.000000] PM: Registered nosave memory: [mem 0xd5c10000-0xd630efff]
[    0.000000] PM: Registered nosave memory: [mem 0xd630f000-0xd631efff]
[    0.000000] PM: Registered nosave memory: [mem 0xd631f000-0xd6429fff]
[    0.000000] PM: Registered nosave memory: [mem 0xd642a000-0xd670cfff]
[    0.000000] PM: Registered nosave memory: [mem 0xd670e000-0xd6750fff]
[    0.000000] PM: Registered nosave memory: [mem 0xd7000000-0xd77fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xd7800000-0xdf9fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdfa00000-0xf7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfbffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfecfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed03fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed04000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0xdfa00000-0xf7ffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88011f200000 s86592 r8192 d24000 u524288
[    0.000000] pcpu-alloc: s86592 r8192 d24000 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 989923
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.12.7-031207-generic root=UUID=7f1378fa-0837-48fa-aa07-74ee97a6170a ro quiet splash vt.handoff=7
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 3858480K/4022636K available (7539K kernel code, 1118K rwdata, 3472K rodata, 1340K init, 1416K bss, 164156K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=4.
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-255.
[    0.000000] NR_IRQS:16640 nr_irqs:712 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 16252928 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.004000] tsc: Detected 3392.585 MHz processor
[    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 6785.17 BogoMIPS (lpj=13570340)
[    0.000004] pid_max: default: 32768 minimum: 301
[    0.000019] Security Framework initialized
[    0.000033] AppArmor: AppArmor initialized
[    0.000033] Yama: becoming mindful.
[    0.000249] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.001234] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.001679] Mount-cache hash table entries: 256
[    0.001820] Initializing cgroup subsys memory
[    0.001829] Initializing cgroup subsys devices
[    0.001830] Initializing cgroup subsys freezer
[    0.001831] Initializing cgroup subsys blkio
[    0.001832] Initializing cgroup subsys perf_event
[    0.001834] Initializing cgroup subsys hugetlb
[    0.001851] CPU: Physical Processor ID: 0
[    0.001852] CPU: Processor Core ID: 0
[    0.001856] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.001856] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.001859] mce: CPU supports 7 MCE banks
[    0.001868] CPU0: Thermal monitoring enabled (TM1)
[    0.001875] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
[    0.001875] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
[    0.001875] tlb_flushall_shift: 1
[    0.001971] Freeing SMP alternatives memory: 28K (ffffffff81e68000 - ffffffff81e6f000)
[    0.002832] ACPI: Core revision 20130725
[    0.006426] ACPI: All ACPI Tables successfully acquired
[    0.017368] ftrace: allocating 31012 entries in 122 pages
[    0.028791] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.068497] smpboot: CPU0: Intel(R) Core(TM) i3-3240 CPU @ 3.40GHz (fam: 06, model: 3a, stepping: 09)
[    0.068504] TSC deadline timer enabled
[    0.070046] Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge events, full-width counters, Intel PMU driver.
[    0.070052] ... version:                3
[    0.070053] ... bit width:              48
[    0.070054] ... generic registers:      4
[    0.070054] ... value mask:             0000ffffffffffff
[    0.070055] ... max period:             0000ffffffffffff
[    0.070056] ... fixed-purpose events:   3
[    0.070056] ... event mask:             000000070000000f
[    0.084278] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.071195] smpboot: Booting Node   0, Processors  #   1 #   2 #   3 OK
[    0.110531] Brought up 4 CPUs
[    0.110535] smpboot: Total of 4 processors activated (27140.68 BogoMIPS)
[    0.113202] devtmpfs: initialized
[    0.116245] EVM: security.selinux
[    0.116246] EVM: security.SMACK64
[    0.116247] EVM: security.capability
[    0.116279] PM: Registering ACPI NVS region [mem 0xd631f000-0xd6429fff] (1093632 bytes)
[    0.116290] PM: Registering ACPI NVS region [mem 0xd670e000-0xd6750fff] (274432 bytes)
[    0.116819] pinctrl core: initialized pinctrl subsystem
[    0.116859] regulator-dummy: no parameters
[    0.116887] RTC time: 16:15:30, date: 01/14/14
[    0.116909] NET: Registered protocol family 16
[    0.116974] cpuidle: using governor ladder
[    0.116975] cpuidle: using governor menu
[    0.116998] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.116999] ACPI: bus type PCI registered
[    0.117001] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.117035] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.117037] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.121676] PCI: Using configuration type 1 for base access
[    0.122240] bio: create slab <bio-0> at 0
[    0.122348] ACPI: Added _OSI(Module Device)
[    0.122349] ACPI: Added _OSI(Processor Device)
[    0.122350] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.122351] ACPI: Added _OSI(Processor Aggregator Device)
[    0.123484] ACPI: EC: Look up EC in DSDT
[    0.124661] ACPI: Executed 1 blocks of module-level executable AML code
[    0.126822] ACPI: SSDT 00000000d62bb018 0083B (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    0.127105] ACPI: Dynamic OEM Table Load:
[    0.127107] ACPI: SSDT           (null) 0083B (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    0.130740] ACPI: SSDT 00000000d62bca98 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
[    0.131041] ACPI: Dynamic OEM Table Load:
[    0.131043] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
[    0.134645] ACPI: SSDT 00000000d62bdc18 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
[    0.134924] ACPI: Dynamic OEM Table Load:
[    0.134925] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
[    0.138948] ACPI: Interpreter enabled
[    0.138952] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130725/hwxface-571)
[    0.138955] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130725/hwxface-571)
[    0.138964] ACPI: (supports S0 S3 S4 S5)
[    0.138965] ACPI: Using IOAPIC for interrupt routing
[    0.138983] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.139094] ACPI: No dock devices found.
[    0.143707] ACPI: Power Resource [FN00] (off)
[    0.143759] ACPI: Power Resource [FN01] (off)
[    0.143811] ACPI: Power Resource [FN02] (off)
[    0.143863] ACPI: Power Resource [FN03] (off)
[    0.143912] ACPI: Power Resource [FN04] (off)
[    0.144347] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.144496] acpi PNP0A08:00: Requesting ACPI _OSC control (0x1d)
[    0.144630] acpi PNP0A08:00: ACPI _OSC control (0x18) granted
[    0.145085] PCI host bridge to bus 0000:00
[    0.145087] pci_bus 0000:00: root bus resource [bus 00-3e]
[    0.145088] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.145090] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.145091] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.145092] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
[    0.145093] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.145094] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.145095] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    0.145097] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
[    0.145098] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
[    0.145099] pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xfeafffff]
[    0.145105] pci 0000:00:00.0: [8086:0150] type 00 class 0x060000
[    0.145175] pci 0000:00:02.0: [8086:0152] type 00 class 0x030000
[    0.145184] pci 0000:00:02.0: reg 0x10: [mem 0xf7800000-0xf7bfffff 64bit]
[    0.145188] pci 0000:00:02.0: reg 0x18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.145191] pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
[    0.145275] pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
[    0.145296] pci 0000:00:16.0: reg 0x10: [mem 0xf7d2b000-0xf7d2b00f 64bit]
[    0.145368] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.145440] pci 0000:00:19.0: [8086:1503] type 00 class 0x020000
[    0.145457] pci 0000:00:19.0: reg 0x10: [mem 0xf7d00000-0xf7d1ffff]
[    0.145465] pci 0000:00:19.0: reg 0x14: [mem 0xf7d29000-0xf7d29fff]
[    0.145473] pci 0000:00:19.0: reg 0x18: [io  0xf080-0xf09f]
[    0.145533] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.145600] pci 0000:00:1a.0: [8086:1c2d] type 00 class 0x0c0320
[    0.145619] pci 0000:00:1a.0: reg 0x10: [mem 0xf7d28000-0xf7d283ff]
[    0.145705] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.145757] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.145784] pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
[    0.145799] pci 0000:00:1b.0: reg 0x10: [mem 0xf7d20000-0xf7d23fff 64bit]
[    0.145862] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.145904] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.145927] pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
[    0.146002] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.146046] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.146068] pci 0000:00:1c.1: [8086:1c12] type 01 class 0x060400
[    0.146142] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.146185] pci 0000:00:1c.1: System wakeup disabled by ACPI
[    0.146219] pci 0000:00:1d.0: [8086:1c26] type 00 class 0x0c0320
[    0.146238] pci 0000:00:1d.0: reg 0x10: [mem 0xf7d27000-0xf7d273ff]
[    0.146323] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.146374] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.146399] pci 0000:00:1f.0: [8086:1c5c] type 00 class 0x060100
[    0.146557] pci 0000:00:1f.2: [8086:1c02] type 00 class 0x010601
[    0.146574] pci 0000:00:1f.2: reg 0x10: [io  0xf0d0-0xf0d7]
[    0.146582] pci 0000:00:1f.2: reg 0x14: [io  0xf0c0-0xf0c3]
[    0.146589] pci 0000:00:1f.2: reg 0x18: [io  0xf0b0-0xf0b7]
[    0.146596] pci 0000:00:1f.2: reg 0x1c: [io  0xf0a0-0xf0a3]
[    0.146604] pci 0000:00:1f.2: reg 0x20: [io  0xf060-0xf07f]
[    0.146611] pci 0000:00:1f.2: reg 0x24: [mem 0xf7d26000-0xf7d267ff]
[    0.146653] pci 0000:00:1f.2: PME# supported from D3hot
[    0.146710] pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
[    0.146724] pci 0000:00:1f.3: reg 0x10: [mem 0xf7d25000-0xf7d250ff 64bit]
[    0.146743] pci 0000:00:1f.3: reg 0x20: [io  0xf040-0xf05f]
[    0.146863] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.146974] pci 0000:02:00.0: [1033:0194] type 00 class 0x0c0330
[    0.147001] pci 0000:02:00.0: reg 0x10: [mem 0xf7c00000-0xf7c01fff 64bit]
[    0.147174] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.147229] pci 0000:02:00.0: System wakeup disabled by ACPI
[    0.157486] pci 0000:00:1c.1: PCI bridge to [bus 02]
[    0.157497] pci 0000:00:1c.1:   bridge window [mem 0xf7c00000-0xf7cfffff]
[    0.157535] acpi PNP0A08:00: Disabling ASPM (FADT indicates it is unsupported)
[    0.157980] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.158018] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 *4 5 6 10 11 12 14 15)
[    0.158055] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.158091] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.158127] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 10 11 12 14 15)
[    0.158165] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.158202] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 10 11 12 14 15)
[    0.158239] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.158421] ACPI: Enabled 7 GPEs in block 00 to 3F
[    0.158426] ACPI: \_SB_.PCI0: notify handler is installed
[    0.158468] Found 1 acpi root devices
[    0.158536] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.158538] vgaarb: loaded
[    0.158539] vgaarb: bridge control possible 0000:00:02.0
[    0.158646] SCSI subsystem initialized
[    0.158685] libata version 3.00 loaded.
[    0.158707] ACPI: bus type USB registered
[    0.158719] usbcore: registered new interface driver usbfs
[    0.158725] usbcore: registered new interface driver hub
[    0.158744] usbcore: registered new device driver usb
[    0.158812] PCI: Using ACPI for IRQ routing
[    0.160269] PCI: pci_cache_line_size set to 64 bytes
[    0.160303] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
[    0.160305] e820: reserve RAM buffer [mem 0x40004000-0x43ffffff]
[    0.160306] e820: reserve RAM buffer [mem 0xd5c10000-0xd7ffffff]
[    0.160307] e820: reserve RAM buffer [mem 0xd670e000-0xd7ffffff]
[    0.160308] e820: reserve RAM buffer [mem 0xd7000000-0xd7ffffff]
[    0.160309] e820: reserve RAM buffer [mem 0x11f600000-0x11fffffff]
[    0.160373] NetLabel: Initializing
[    0.160374] NetLabel:  domain hash size = 128
[    0.160375] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.160381] NetLabel:  unlabeled traffic allowed by default
[    0.160426] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.160430] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.162459] Switched to clocksource hpet
[    0.165824] AppArmor: AppArmor Filesystem Enabled
[    0.165847] pnp: PnP ACPI init
[    0.165857] ACPI: bus type PNP registered
[    0.165944] system 00:00: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.165947] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.165957] pnp 00:01: [dma 4]
[    0.165965] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.165978] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    0.166043] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.166068] system 00:04: [io  0x0680-0x069f] has been reserved
[    0.166070] system 00:04: [io  0x1000-0x100f] has been reserved
[    0.166072] system 00:04: [io  0xffff] has been reserved
[    0.166073] system 00:04: [io  0xffff] has been reserved
[    0.166074] system 00:04: [io  0x0400-0x0453] could not be reserved
[    0.166076] system 00:04: [io  0x0458-0x047f] has been reserved
[    0.166077] system 00:04: [io  0x0500-0x057f] has been reserved
[    0.166078] system 00:04: [io  0x164e-0x164f] has been reserved
[    0.166080] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.166102] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.166130] system 00:06: [io  0x0454-0x0457] has been reserved
[    0.166132] system 00:06: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.166219] system 00:07: [io  0x0a00-0x0a0f] has been reserved
[    0.166221] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.166251] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    0.166282] pnp 00:09: Plug and Play ACPI device, IDs PNP0f03 PNP0f13 (active)
[    0.166415] system 00:0a: [io  0x04d0-0x04d1] has been reserved
[    0.166417] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.166433] pnp 00:0b: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.166611] system 00:0c: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.166613] system 00:0c: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.166614] system 00:0c: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.166615] system 00:0c: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.166617] system 00:0c: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.166618] system 00:0c: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.166619] system 00:0c: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.166621] system 00:0c: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.166622] system 00:0c: [mem 0xff000000-0xffffffff] has been reserved
[    0.166624] system 00:0c: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.166625] system 00:0c: [mem 0xdfa00000-0xdfa00fff] has been reserved
[    0.166627] system 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.166731] system 00:0d: [mem 0x20000000-0x201fffff] has been reserved
[    0.166733] system 00:0d: [mem 0x40004000-0x40004fff] has been reserved
[    0.166735] system 00:0d: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.166749] pnp: PnP ACPI: found 14 devices
[    0.166750] ACPI: bus type PNP unregistered
[    0.172769] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.172780] pci 0000:00:1c.1: PCI bridge to [bus 02]
[    0.172785] pci 0000:00:1c.1:   bridge window [mem 0xf7c00000-0xf7cfffff]
[    0.172793] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.172794] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.172795] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.172796] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.172798] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.172799] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.172800] pci_bus 0000:00: resource 10 [mem 0x000dc000-0x000dffff]
[    0.172801] pci_bus 0000:00: resource 11 [mem 0x000e0000-0x000e3fff]
[    0.172802] pci_bus 0000:00: resource 12 [mem 0x000e4000-0x000e7fff]
[    0.172803] pci_bus 0000:00: resource 13 [mem 0xdfa00000-0xfeafffff]
[    0.172805] pci_bus 0000:02: resource 1 [mem 0xf7c00000-0xf7cfffff]
[    0.172826] NET: Registered protocol family 2
[    0.172938] TCP established hash table entries: 32768 (order: 7, 524288 bytes)
[    0.173070] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
[    0.173167] TCP: Hash tables configured (established 32768 bind 32768)
[    0.173182] TCP: reno registered
[    0.173188] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.173203] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.173247] NET: Registered protocol family 1
[    0.173255] pci 0000:00:02.0: Boot video device
[    0.210701] PCI: CLS 64 bytes, default 64
[    0.210734] Trying to unpack rootfs image as initramfs...
[    0.410617] Freeing initrd memory: 17552K (ffff880035da8000 - ffff880036ecc000)
[    0.410622] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.410624] software IO TLB [mem 0xd1c10000-0xd5c10000] (64MB) mapped at [ffff8800d1c10000-ffff8800d5c0ffff]
[    0.410808] Scanning for low memory corruption every 60 seconds
[    0.411029] Initialise module verification
[    0.411061] audit: initializing netlink socket (disabled)
[    0.411070] type=2000 audit(1389716130.400:1): initialized
[    0.431243] bounce pool size: 64 pages
[    0.431253] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.431975] zbud: loaded
[    0.432073] VFS: Disk quotas dquot_6.5.2
[    0.432099] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.432400] fuse init (API version 7.22)
[    0.432447] msgmni has been set to 7570
[    0.432849] Key type asymmetric registered
[    0.432850] Asymmetric key parser 'x509' registered
[    0.432868] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.432897] io scheduler noop registered
[    0.432898] io scheduler deadline registered (default)
[    0.432912] io scheduler cfq registered
[    0.433127] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.433136] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.534399] Console: switching to colour frame buffer device 240x67
[    0.634568] simple-framebuffer simple-framebuffer.0: fb0: simplefb registered!
[    0.634573] intel_idle: MWAIT substates: 0x1120
[    0.634574] intel_idle: v0.4 model 0x3A
[    0.634575] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.634694] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    0.634698] ACPI: Power Button [PWRB]
[    0.634719] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.634720] ACPI: Power Button [PWRF]
[    0.634761] ACPI: Fan [FAN0] (off)
[    0.634778] ACPI: Fan [FAN1] (off)
[    0.634793] ACPI: Fan [FAN2] (off)
[    0.634811] ACPI: Fan [FAN3] (off)
[    0.634827] ACPI: Fan [FAN4] (off)
[    0.634858] ACPI: Requesting acpi_cpufreq
[    0.650916] thermal LNXTHERM:00: registered as thermal_zone0
[    0.650917] ACPI: Thermal Zone [TZ00] (28 C)
[    0.651053] thermal LNXTHERM:01: registered as thermal_zone1
[    0.651054] ACPI: Thermal Zone [TZ01] (30 C)
[    0.651073] GHES: HEST is not enabled!
[    0.651132] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    0.652102] Linux agpgart interface v0.103
[    0.652876] brd: module loaded
[    0.653239] loop: module loaded
[    0.653435] libphy: Fixed MDIO Bus: probed
[    0.653483] tun: Universal TUN/TAP device driver, 1.6
[    0.653484] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.653510] PPP generic driver version 2.4.2
[    0.653538] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.653540] ehci-pci: EHCI PCI platform driver
[    0.653624] ehci-pci 0000:00:1a.0: setting latency timer to 64
[    0.653631] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    0.653634] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    0.653646] ehci-pci 0000:00:1a.0: debug port 2
[    0.657547] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    0.657560] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf7d28000
[    0.666705] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    0.666737] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.666738] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.666740] usb usb1: Product: EHCI Host Controller
[    0.666741] usb usb1: Manufacturer: Linux 3.12.7-031207-generic ehci_hcd
[    0.666742] usb usb1: SerialNumber: 0000:00:1a.0
[    0.666813] hub 1-0:1.0: USB hub found
[    0.666818] hub 1-0:1.0: 2 ports detected
[    0.666952] ehci-pci 0000:00:1d.0: setting latency timer to 64
[    0.666957] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    0.666959] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    0.666970] ehci-pci 0000:00:1d.0: debug port 2
[    0.670859] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    0.670870] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf7d27000
[    0.682712] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    0.682734] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.682735] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.682736] usb usb2: Product: EHCI Host Controller
[    0.682737] usb usb2: Manufacturer: Linux 3.12.7-031207-generic ehci_hcd
[    0.682738] usb usb2: SerialNumber: 0000:00:1d.0
[    0.682885] hub 2-0:1.0: USB hub found
[    0.682893] hub 2-0:1.0: 2 ports detected
[    0.682971] ehci-platform: EHCI generic platform driver
[    0.682976] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.682977] ohci-platform: OHCI generic platform driver
[    0.682980] uhci_hcd: USB Universal Host Controller Interface driver
[    0.683031] xhci_hcd 0000:02:00.0: xHCI Host Controller
[    0.683034] xhci_hcd 0000:02:00.0: new USB bus registered, assigned bus number 3
[    0.683211] xhci_hcd 0000:02:00.0: irq 40 for MSI/MSI-X
[    0.683214] xhci_hcd 0000:02:00.0: irq 41 for MSI/MSI-X
[    0.683218] xhci_hcd 0000:02:00.0: irq 42 for MSI/MSI-X
[    0.683221] xhci_hcd 0000:02:00.0: irq 43 for MSI/MSI-X
[    0.683224] xhci_hcd 0000:02:00.0: irq 44 for MSI/MSI-X
[    0.683334] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    0.683335] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.683336] usb usb3: Product: xHCI Host Controller
[    0.683337] usb usb3: Manufacturer: Linux 3.12.7-031207-generic xhci_hcd
[    0.683338] usb usb3: SerialNumber: 0000:02:00.0
[    0.683480] hub 3-0:1.0: USB hub found
[    0.683490] hub 3-0:1.0: 2 ports detected
[    0.683542] xhci_hcd 0000:02:00.0: xHCI Host Controller
[    0.683545] xhci_hcd 0000:02:00.0: new USB bus registered, assigned bus number 4
[    0.686638] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
[    0.686639] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.686640] usb usb4: Product: xHCI Host Controller
[    0.686642] usb usb4: Manufacturer: Linux 3.12.7-031207-generic xhci_hcd
[    0.686643] usb usb4: SerialNumber: 0000:02:00.0
[    0.686760] hub 4-0:1.0: USB hub found
[    0.686772] hub 4-0:1.0: 2 ports detected
[    0.694880] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    0.697789] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.697795] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.697944] mousedev: PS/2 mouse device common for all mice
[    0.698196] rtc_cmos 00:05: RTC can wake from S4
[    0.698357] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    0.698387] rtc_cmos 00:05: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    0.698426] device-mapper: uevent: version 1.0.3
[    0.698481] device-mapper: ioctl: 4.26.0-ioctl (2013-08-15) initialised: dm-devel@redhat.com
[    0.698485] Intel P-state driver initializing.
[    0.698492] Intel pstate controlling: cpu 0
[    0.698506] Intel pstate controlling: cpu 1
[    0.698514] Intel pstate controlling: cpu 2
[    0.698521] Intel pstate controlling: cpu 3
[    0.698535] ledtrig-cpu: registered to indicate activity on CPUs
[    0.698586] TCP: cubic registered
[    0.698636] NET: Registered protocol family 10
[    0.698761] NET: Registered protocol family 17
[    0.698767] Key type dns_resolver registered
[    0.699001] Loading module verification certificates
[    0.699571] MODSIGN: Loaded cert 'Magrathea: Glacier signing key: 43ccd1524d27446e21ecbca9f9432d403105c555'
[    0.699580] registered taskstats version 1
[    0.701445] Key type trusted registered
[    0.702863] Key type encrypted registered
[    0.704279] AppArmor: AppArmor sha1 policy hashing enabled
[    0.704490]   Magic number: 14:436:287
[    0.704513] tty tty20: hash matches
[    0.704578] rtc_cmos 00:05: setting system clock to 2014-01-14 16:15:31 UTC (1389716131)
[    0.704619] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    0.704620] EDD information not available.
[    0.704655] PM: Hibernation image not present or could not be loaded.
[    0.705395] Freeing unused kernel memory: 1340K (ffffffff81d19000 - ffffffff81e68000)
[    0.705396] Write protecting the kernel read-only data: 12288k
[    0.706366] Freeing unused kernel memory: 644K (ffff88000175f000 - ffff880001800000)
[    0.707778] Freeing unused kernel memory: 624K (ffff880001b64000 - ffff880001c00000)
[    0.720832] systemd-udevd[115]: starting version 204
[    0.743147] pps_core: LinuxPPS API ver. 1 registered
[    0.743151] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.744325] PTP clock support registered
[    0.745227] ahci 0000:00:1f.2: version 3.0
[    0.745376] ahci 0000:00:1f.2: irq 45 for MSI/MSI-X
[    0.745425] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 4 ports 3 Gbps 0x3 impl SATA mode
[    0.745429] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part ems apst 
[    0.745433] ahci 0000:00:1f.2: setting latency timer to 64
[    0.748684] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    0.748686] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[    0.751259] scsi0 : ahci
[    0.751333] scsi1 : ahci
[    0.751400] scsi2 : ahci
[    0.751445] scsi3 : ahci
[    0.751473] ata1: SATA max UDMA/133 abar m2048@0xf7d26000 port 0xf7d26100 irq 45
[    0.751475] ata2: SATA max UDMA/133 abar m2048@0xf7d26000 port 0xf7d26180 irq 45
[    0.751476] ata3: DUMMY
[    0.751477] ata4: DUMMY
[    0.751762] e1000e 0000:00:19.0: setting latency timer to 64
[    0.751827] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    0.751850] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[    0.978881] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    1.015199] e1000e 0000:00:19.0 eth0: registered PHC clock
[    1.015203] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) e0:cb:4e:28:cb:a8
[    1.015206] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[    1.015249] e1000e 0000:00:19.0 eth0: MAC: 10, PHY: 11, PBA No: FFFFFF-0FF
[    1.070934] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.070958] ata1: SATA link down (SStatus 0 SControl 300)
[    1.082454] ata2.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    1.082460] ata2.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[    1.082464] ata2.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
[    1.092772] ata2.00: ATA-8: MKNSSDCR60GB, 502ABBF0, max UDMA/133
[    1.092776] ata2.00: 117231408 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.102348] ata2.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    1.102353] ata2.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[    1.102357] ata2.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
[    1.111356] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[    1.111370] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.111619] hub 1-1:1.0: USB hub found
[    1.111699] hub 1-1:1.0: 4 ports detected
[    1.112748] ata2.00: configured for UDMA/133
[    1.112934] scsi 1:0:0:0: Direct-Access     ATA      MKNSSDCR60GB     502A PQ: 0 ANSI: 5
[    1.113111] sd 1:0:0:0: [sda] 117231408 512-byte logical blocks: (60.0 GB/55.8 GiB)
[    1.113125] sd 1:0:0:0: Attached scsi generic sg0 type 0
[    1.113287] sd 1:0:0:0: [sda] Write Protect is off
[    1.113291] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.113399] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.114211]  sda: sda1 sda2
[    1.114263] sda: p2 size 16384000 extends beyond EOD, enabling native capacity
[    1.114935]  sda: sda1 sda2
[    1.114985] sda: p2 size 16384000 extends beyond EOD, truncated
[    1.115246] sd 1:0:0:0: [sda] Attached SCSI disk
[    1.223030] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    1.355506] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[    1.355510] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.355856] hub 2-1:1.0: USB hub found
[    1.355928] hub 2-1:1.0: 6 ports detected
[    1.411087] tsc: Refined TSC clocksource calibration: 3392.293 MHz
[    1.467150] usb 3-1: new full-speed USB device number 2 using xhci_hcd
[    1.533118] usb 3-1: New USB device found, idVendor=147a, idProduct=e03e
[    1.533122] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    1.533124] usb 3-1: Product: eHome Infrared Transceiver
[    1.533126] usb 3-1: Manufacturer: Formosa21
[    1.533128] usb 3-1: SerialNumber: 0000A590
[    1.533274] usb 3-1: ep 0x83 - rounding interval to 64 microframes, ep desc says 80 microframes
[    1.538322] hidraw: raw HID events driver (C) Jiri Kosina
[    1.552204] usbcore: registered new interface driver usbhid
[    1.552206] usbhid: USB HID core driver
[    1.553912] hid-generic 0003:147A:E03E.0001: hiddev0,hidraw0: USB HID v1.00 Device [Formosa21 eHome Infrared Transceiver] on usb-0000:02:00.0-1/input1
[    1.607356] usb 1-1.1: new full-speed USB device number 3 using ehci-pci
[    1.703151] usb 1-1.1: New USB device found, idVendor=046d, idProduct=c52f
[    1.703156] usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.703168] usb 1-1.1: Product: USB Receiver
[    1.703182] usb 1-1.1: Manufacturer: Logitech
[    1.705501] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.1/1-1.1:1.0/input/input4
[    1.705654] hid-generic 0003:046D:C52F.0002: input,hidraw1: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:1a.0-1.1/input0
[    1.708251] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.1/1-1.1:1.1/input/input5
[    1.708525] hid-generic 0003:046D:C52F.0003: input,hiddev0,hidraw2: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:1a.0-1.1/input1
[    1.779416] usb 1-1.2: new full-speed USB device number 4 using ehci-pci
[    1.875107] usb 1-1.2: New USB device found, idVendor=046d, idProduct=c52b
[    1.875111] usb 1-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.875113] usb 1-1.2: Product: USB Receiver
[    1.875115] usb 1-1.2: Manufacturer: Logitech
[    1.883227] logitech-djreceiver 0003:046D:C52B.0006: hiddev0,hidraw3: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:1a.0-1.2/input2
[    1.885676] input: Logitech Unifying Device. Wireless PID:2007 as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.2/0003:046D:C52B.0006/input/input6
[    1.885814] logitech-djdevice 0003:046D:C52B.0007: input,hidraw4: USB HID v1.11 Keyboard [Logitech Unifying Device. Wireless PID:2007] on usb-0000:00:1a.0-1.2:1
[    2.411720] Switched to clocksource tsc
[    6.155432] EXT4-fs (sda1): INFO: recovery required on readonly filesystem
[    6.155435] EXT4-fs (sda1): write access will be enabled during recovery
[    6.235803] EXT4-fs (sda1): recovery complete
[    6.236238] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    6.323530] init: ureadahead main process (181) terminated with status 5
[    6.384842] Adding 7673748k swap on /dev/sda2.  Priority:-1 extents:1 across:7673748k SSFS
[    6.438364] EXT4-fs (sda1): re-mounted. Opts: discard,errors=remount-ro
[    6.445655] systemd-udevd[301]: starting version 204
[    6.479208] lp: driver loaded but no devices found
[    6.530291] mei_me 0000:00:16.0: setting latency timer to 64
[    6.530334] mei_me 0000:00:16.0: irq 47 for MSI/MSI-X
[    6.543740] [drm] Initialized drm 1.1.0 20060810
[    6.547405] ACPI Warning: 0x0000000000000428-0x000000000000042f SystemIO conflicts with Region \PMIO 1 (20130725/utaddress-251)
[    6.547416] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    6.547423] ACPI Warning: 0x0000000000000540-0x000000000000054f SystemIO conflicts with Region \GPIO 1 (20130725/utaddress-251)
[    6.547427] ACPI Warning: 0x0000000000000540-0x000000000000054f SystemIO conflicts with Region \_GPE.GPS0 2 (20130725/utaddress-251)
[    6.547430] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    6.547432] ACPI Warning: 0x0000000000000530-0x000000000000053f SystemIO conflicts with Region \GPIO 1 (20130725/utaddress-251)
[    6.547434] ACPI Warning: 0x0000000000000530-0x000000000000053f SystemIO conflicts with Region \_GPE.GPS0 2 (20130725/utaddress-251)
[    6.547437] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    6.547439] ACPI Warning: 0x0000000000000500-0x000000000000052f SystemIO conflicts with Region \GPIO 1 (20130725/utaddress-251)
[    6.547441] ACPI Warning: 0x0000000000000500-0x000000000000052f SystemIO conflicts with Region \_GPE.GPS0 2 (20130725/utaddress-251)
[    6.547444] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    6.547445] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    6.569950] [drm] Memory usable by graphics device = 2048M
[    6.570052] checking generic (e0000000 7e9000) vs hw (e0000000 10000000)
[    6.570054] fb: conflicting fb hw usage inteldrmfb vs simple - removing generic driver
[    6.570082] Console: switching to colour dummy device 80x25
[    6.570288] i915 0000:00:02.0: setting latency timer to 64
[    6.582578] microcode: CPU0 sig=0x306a9, pf=0x2, revision=0x17
[    6.599471] i915 0000:00:02.0: irq 48 for MSI/MSI-X
[    6.599482] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    6.599483] [drm] Driver supports precise vblank timestamp query.
[    6.599540] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    6.641464] Registered IR keymap rc-rc6-mce
[    6.641587] input: Media Center Ed. eHome Infrared Remote Transceiver (147a:e03e) as /devices/pci0000:00/0000:00:1c.1/0000:02:00.0/usb3/3-1/3-1:1.0/rc/rc0/input8
[    6.641634] rc0: Media Center Ed. eHome Infrared Remote Transceiver (147a:e03e) as /devices/pci0000:00/0000:00:1c.1/0000:02:00.0/usb3/3-1/3-1:1.0/rc/rc0
[    6.646339] IR NEC protocol handler initialized
[    6.649507] IR RC5(x) protocol handler initialized
[    6.652959] IR RC6 protocol handler initialized
[    6.657904] IR Sony protocol handler initialized
[    6.658400] IR JVC protocol handler initialized
[    6.659799] IR SANYO protocol handler initialized
[    6.665384] IR MCE Keyboard/mouse protocol handler initialized
[    6.670425] input: MCE IR Keyboard/Mouse (mceusb) as /devices/virtual/input/input9
[    6.670945] lirc_dev: IR Remote Control driver registered, major 248 
[    6.672481] rc rc0: lirc_dev: driver ir-lirc-codec (mceusb) registered at minor = 0
[    6.672483] IR LIRC bridge handler initialized
[    6.729946] Bluetooth: Core ver 2.16
[    6.729984] NET: Registered protocol family 31
[    6.729986] Bluetooth: HCI device and connection manager initialized
[    6.729994] Bluetooth: HCI socket layer initialized
[    6.729996] Bluetooth: L2CAP socket layer initialized
[    6.730001] Bluetooth: SCO socket layer initialized
[    6.754391] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    6.754395] Bluetooth: BNEP filters: protocol multicast
[    6.754404] Bluetooth: BNEP socket layer initialized
[    6.757264] Bluetooth: RFCOMM TTY layer initialized
[    6.757279] Bluetooth: RFCOMM socket layer initialized
[    6.757281] Bluetooth: RFCOMM ver 1.11
[    6.762291] microcode: CPU1 sig=0x306a9, pf=0x2, revision=0x17
[    6.782090] microcode: CPU2 sig=0x306a9, pf=0x2, revision=0x17
[    6.783709] microcode: CPU3 sig=0x306a9, pf=0x2, revision=0x17
[    6.785511] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    6.801245] ppdev: user-space parallel port driver
[    6.805877] init: avahi-cups-reload main process (560) terminated with status 1
[    6.842916] mceusb 3-1:1.0: Registered Formosa21 eHome Infrared Transceiver with mce emulator interface version 2
[    6.842920] mceusb 3-1:1.0: 0 tx ports (0x0 cabled) and 1 rx sensors (0x1 active)
[    6.842965] usbcore: registered new interface driver mceusb
[    6.987558] type=1400 audit(1389716137.774:2): apparmor="STATUS" operation="profile_load" name="/sbin/dhclient" pid=448 comm="apparmor_parser"
[    6.987684] type=1400 audit(1389716137.774:3): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=448 comm="apparmor_parser"
[    6.987795] type=1400 audit(1389716137.774:4): apparmor="STATUS" operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" pid=448 comm="apparmor_parser"
[    7.174740] type=1400 audit(1389716137.962:5): apparmor="STATUS" operation="profile_load" name="/usr/sbin/ntpd" pid=593 comm="apparmor_parser"
[    7.199962] type=1400 audit(1389716137.986:6): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=586 comm="apparmor_parser"
[    7.200075] type=1400 audit(1389716137.986:7): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=586 comm="apparmor_parser"
[    7.200173] type=1400 audit(1389716137.986:8): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=586 comm="apparmor_parser"
[    7.264348] fbcon: inteldrmfb (fb0) is primary device
[    7.334827] type=1400 audit(1389716138.122:9): apparmor="STATUS" operation="profile_load" name="/usr/lib/cups/backend/cups-pdf" pid=589 comm="apparmor_parser"
[    7.335018] type=1400 audit(1389716138.122:10): apparmor="STATUS" operation="profile_load" name="/usr/sbin/cupsd" pid=589 comm="apparmor_parser"
[    7.353648] type=1400 audit(1389716138.138:11): apparmor="STATUS" operation="profile_replace" name="/usr/sbin/ntpd" pid=599 comm="apparmor_parser"
[    7.806295] [drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp off
[    7.886143] Console: switching to colour frame buffer device 240x67
[    7.986470] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    7.986471] i915 0000:00:02.0: registered panic notifier
[    7.996328] acpi device:4b: registered as cooling_device10
[    7.996599] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    7.996648] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input10
[    7.997027] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    7.997446] snd_hda_intel 0000:00:1b.0: irq 49 for MSI/MSI-X
[    8.015874] autoconfig: line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:line
[    8.015879]    speaker_outs=1 (0x1a/0x0/0x0/0x0/0x0)
[    8.015880]    hp_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    8.015881]    mono: mono_out=0x0
[    8.015883]    dig-out=0x1e/0x0
[    8.015883]    inputs:
[    8.015885]      Mic=0x18
[    8.015887]      Internal Mic=0x12
[    8.036513] input: HDA Intel PCH HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input15
[    8.036654] input: HDA Intel PCH HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input14
[    8.037142] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[    8.037285] input: HDA Intel PCH Line Out as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[    8.037389] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[    8.051745] init: failsafe main process (634) killed by TERM signal
[    8.322427] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[    8.426343] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[    8.426466] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[   11.776716] e1000e: eth1 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[   11.776751] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[   12.536825] audit_printk_skb: 54 callbacks suppressed
[   12.536829] type=1400 audit(1389716143.322:30): apparmor="STATUS" operation="profile_load" name="/usr/bin/evince" pid=903 comm="apparmor_parser"
[   12.537299] type=1400 audit(1389716143.322:31): apparmor="STATUS" operation="profile_load" name="sanitized_helper" pid=903 comm="apparmor_parser"
[   12.538233] type=1400 audit(1389716143.322:32): apparmor="STATUS" operation="profile_load" name="/usr/bin/evince-previewer" pid=903 comm="apparmor_parser"
[   12.538520] type=1400 audit(1389716143.322:33): apparmor="STATUS" operation="profile_load" name="sanitized_helper" pid=903 comm="apparmor_parser"
[   12.539107] type=1400 audit(1389716143.322:34): apparmor="STATUS" operation="profile_load" name="/usr/bin/evince-thumbnailer" pid=903 comm="apparmor_parser"
[   12.539361] type=1400 audit(1389716143.322:35): apparmor="STATUS" operation="profile_load" name="sanitized_helper" pid=903 comm="apparmor_parser"

--MP_/kfv9i6UDJpGDGa5kkhzZwR5--
