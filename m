Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508AbaCVGmV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 02:42:21 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:48784 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbaCVGmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 02:42:17 -0400
Message-ID: <532D30B7.3030301@gmail.com>
Date: Sat, 22 Mar 2014 00:41:59 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Branimir Maksimovic <branimir.maksimovic@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: 15995MB available under Linux but 16329MB available under Win
 7
References: <532D131B.1050606@gmail.com> <532D27C3.10907@gmail.com> <532D2AAB.1020902@gmail.com>
In-Reply-To: <532D2AAB.1020902@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/03/14 12:16 AM, Branimir Maksimovic wrote:
> On 03/22/2014 07:03 AM, Robert Hancock wrote:
>> On 21/03/14 10:35 PM, Branimir Maksimovic wrote:
>>> This really puzzles me.
>>>
>>> bmaxa@maxa:~$ lspci -v -s 01:00.0
>>> 01:00.0 VGA compatible controller: NVIDIA Corporation GF114 [GeForce GTX
>>> 560 Ti] (rev a1) (prog-if 00 [VGA controller])
>>>      Subsystem: CardExpert Technology Device 0801
>>>      Flags: bus master, fast devsel, latency 0, IRQ 52
>>>      Memory at f4000000 (32-bit, non-prefetchable) [size=32M]
>>>      Memory at e8000000 (64-bit, prefetchable) [size=128M]
>>>      Memory at f0000000 (64-bit, prefetchable) [size=64M]
>>>      I/O ports at e000 [size=128]
>>>      [virtual] Expansion ROM at f6000000 [disabled] [size=512K]
>>>      Capabilities: <access denied>
>>>      Kernel driver in use: nvidia
>>>
>>> bmaxa@maxa:~$ dmesg | grep Mem
>>> [    0.000000] Memory: 16358808K/16721316K available (7232K kernel code,
>>> 1106K rwdata, 3456K rodata, 1324K init, 1432K bss, 362508K reserved)
>>
>> Can you post your full dmesg output?
>>
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Initializing cgroup subsys cpuacct
> [    0.000000] Linux version 3.14.0-rc7-core2-custom (bmaxa@maxa) (gcc
> version 4.8.2 (Ubuntu/Linaro 4.8.2-1ubuntu1) ) #126 SMP Fri Mar 21
> 02:19:04 CET 2014
> [    0.000000] Command line:
> BOOT_IMAGE=/boot/vmlinuz-3.14.0-rc7-core2-custom
> root=UUID=2e3c458f-cb2e-4789-8e70-68bccb5bafd9 ro zswap.enabled=1
> transparent_hugepage=always
> resume=UUID=ee90e063-6256-44f2-8bb9-a20d75e9a078 resume_offset=808960
> [    0.000000] KERNEL supported cpus:
> [    0.000000]   Intel GenuineIntel
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff]
> usable
> [    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000dd588fff]
> usable
> [    0.000000] BIOS-e820: [mem 0x00000000dd589000-0x00000000dd8e1fff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000dd8e2000-0x00000000dd8f1fff]
> ACPI data
> [    0.000000] BIOS-e820: [mem 0x00000000dd8f2000-0x00000000dda14fff]
> ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x00000000dda15000-0x00000000de7c6fff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000de7c7000-0x00000000de7c7fff]
> usable
> [    0.000000] BIOS-e820: [mem 0x00000000de7c8000-0x00000000de80afff]
> ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x00000000de80b000-0x00000000dec41fff]
> usable
> [    0.000000] BIOS-e820: [mem 0x00000000dec42000-0x00000000deff3fff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000deff4000-0x00000000deffffff]
> usable
> [    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000041effffff]
> usable

So the 16329MB is the total amount reported as usable by the BIOS, 
(that's the 16721316K number) so I don't think there's any issue with 
the memory sizing. I'm a bit confused about what the reserved size 
actually consists of, but I suspect that may just be all of the kernel's 
memory allocations (page tables, slab allocations, etc.) as well as the 
kernel code and static data.

> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] SMBIOS 2.7 present.
> [    0.000000] DMI: System manufacturer System Product Name/MAXIMUS V
> GENE, BIOS 1903 08/19/2013
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] e820: last_pfn = 0x41f000 max_arch_pfn = 0x400000000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-CFFFF write-protect
> [    0.000000]   D0000-E7FFF uncachable
> [    0.000000]   E8000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 000000000 mask C00000000 write-back
> [    0.000000]   1 base 400000000 mask FF0000000 write-back
> [    0.000000]   2 base 410000000 mask FF8000000 write-back
> [    0.000000]   3 base 418000000 mask FFC000000 write-back
> [    0.000000]   4 base 41C000000 mask FFE000000 write-back
> [    0.000000]   5 base 41E000000 mask FFF000000 write-back
> [    0.000000]   6 base 0E0000000 mask FE0000000 uncachable
> [    0.000000]   7 disabled
> [    0.000000]   8 disabled
> [    0.000000]   9 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new
> 0x7010600070106
> [    0.000000] original variable MTRRs
> [    0.000000] reg 0, base: 0GB, range: 16GB, type WB
> [    0.000000] reg 1, base: 16GB, range: 256MB, type WB
> [    0.000000] reg 2, base: 16640MB, range: 128MB, type WB
> [    0.000000] reg 3, base: 16768MB, range: 64MB, type WB
> [    0.000000] reg 4, base: 16832MB, range: 32MB, type WB
> [    0.000000] reg 5, base: 16864MB, range: 16MB, type WB
> [    0.000000] reg 6, base: 3584MB, range: 512MB, type UC
> [    0.000000] total RAM covered: 16368M
> [    0.000000] Found optimal setting for mtrr clean up
> [    0.000000]  gran_size: 64K     chunk_size: 32M     num_reg: 7 lose
> cover RAM: 0G
> [    0.000000] New variable MTRRs
> [    0.000000] reg 0, base: 0GB, range: 2GB, type WB
> [    0.000000] reg 1, base: 2GB, range: 1GB, type WB
> [    0.000000] reg 2, base: 3GB, range: 512MB, type WB
> [    0.000000] reg 3, base: 4GB, range: 4GB, type WB
> [    0.000000] reg 4, base: 8GB, range: 8GB, type WB
> [    0.000000] reg 5, base: 16GB, range: 512MB, type WB
> [    0.000000] reg 6, base: 16880MB, range: 16MB, type UC
> [    0.000000] e820: update [mem 0xe0000000-0xffffffff] usable ==> reserved
> [    0.000000] e820: last_pfn = 0xdf000 max_arch_pfn = 0x400000000
> [    0.000000] found SMP MP-table at [mem 0x000fd7d0-0x000fd7df] mapped
> at [ffff8800000fd7d0]
> [    0.000000] Scanning 1 areas for low memory corruption
> [    0.000000] Base memory trampoline at [ffff880000097000] 97000 size
> 24576
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] BRK [0x01fd0000, 0x01fd0fff] PGTABLE
> [    0.000000] BRK [0x01fd1000, 0x01fd1fff] PGTABLE
> [    0.000000] BRK [0x01fd2000, 0x01fd2fff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x41ee00000-0x41effffff]
> [    0.000000]  [mem 0x41ee00000-0x41effffff] page 2M
> [    0.000000] BRK [0x01fd3000, 0x01fd3fff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x41c000000-0x41edfffff]
> [    0.000000]  [mem 0x41c000000-0x41edfffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x400000000-0x41bffffff]
> [    0.000000]  [mem 0x400000000-0x41bffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x00100000-0xdd588fff]
> [    0.000000]  [mem 0x00100000-0x001fffff] page 4k
> [    0.000000]  [mem 0x00200000-0xdd3fffff] page 2M
> [    0.000000]  [mem 0xdd400000-0xdd588fff] page 4k
> [    0.000000] init_memory_mapping: [mem 0xde7c7000-0xde7c7fff]
> [    0.000000]  [mem 0xde7c7000-0xde7c7fff] page 4k
> [    0.000000] BRK [0x01fd4000, 0x01fd4fff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0xde80b000-0xdec41fff]
> [    0.000000]  [mem 0xde80b000-0xde9fffff] page 4k
> [    0.000000]  [mem 0xdea00000-0xdebfffff] page 2M
> [    0.000000]  [mem 0xdec00000-0xdec41fff] page 4k
> [    0.000000] BRK [0x01fd5000, 0x01fd5fff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0xdeff4000-0xdeffffff]
> [    0.000000]  [mem 0xdeff4000-0xdeffffff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x100000000-0x3ffffffff]
> [    0.000000]  [mem 0x100000000-0x3ffffffff] page 2M
> [    0.000000] RAMDISK: [mem 0x35e58000-0x36f23fff]
> [    0.000000] ACPI: RSDP 00000000000f0490 000024 (v02 ALASKA)
> [    0.000000] ACPI: XSDT 00000000dd8e5078 000064 (v01 ALASKA    A M I
> 01072009 AMI  00010013)
> [    0.000000] ACPI: FACP 00000000dd8f0040 00010C (v05 ALASKA    A M I
> 01072009 AMI  00010013)
> [    0.000000] ACPI: DSDT 00000000dd8e5170 00AECE (v02 ALASKA    A M I
> 00000022 INTL 20051117)
> [    0.000000] ACPI: FACS 00000000dda13080 000040
> [    0.000000] ACPI: APIC 00000000dd8f0150 000072 (v03 ALASKA    A M I
> 01072009 AMI  00010013)
> [    0.000000] ACPI: FPDT 00000000dd8f01c8 000044 (v01 ALASKA    A M I
> 01072009 AMI  00010013)
> [    0.000000] ACPI: MCFG 00000000dd8f0210 00003C (v01 ALASKA    A M I
> 01072009 MSFT 00000097)
> [    0.000000] ACPI: HPET 00000000dd8f0250 000038 (v01 ALASKA    A M I
> 01072009 AMI. 00000005)
> [    0.000000] ACPI: SSDT 00000000dd8f0288 00036D (v01 SataRe SataTabl
> 00001000 INTL 20091112)
> [    0.000000] ACPI: SSDT 00000000dd8f1000 000A92 (v01  PmRef CpuPm
> 00003000 INTL 20051117)
> [    0.000000] ACPI: SSDT 00000000dd8f0650 0009AA (v01  PmRef Cpu0Ist
> 00003000 INTL 20051117)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] No NUMA configuration found
> [    0.000000] Faking a node at [mem 0x0000000000000000-0x000000041effffff]
> [    0.000000] Initmem setup node 0 [mem 0x00000000-0x41effffff]
> [    0.000000]   NODE_DATA [mem 0x41efe9000-0x41efedfff]
> [    0.000000]  [ffffea0000000000-ffffea00107fffff] PMD ->
> [ffff88040e600000-ffff88041e5fffff] on node 0
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
> [    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
> [    0.000000]   Normal   [mem 0x100000000-0x41effffff]
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x0009cfff]
> [    0.000000]   node   0: [mem 0x00100000-0xdd588fff]
> [    0.000000]   node   0: [mem 0xde7c7000-0xde7c7fff]
> [    0.000000]   node   0: [mem 0xde80b000-0xdec41fff]
> [    0.000000]   node   0: [mem 0xdeff4000-0xdeffffff]
> [    0.000000]   node   0: [mem 0x100000000-0x41effffff]
> [    0.000000] On node 0 totalpages: 4180329
> [    0.000000]   DMA zone: 64 pages used for memmap
> [    0.000000]   DMA zone: 21 pages reserved
> [    0.000000]   DMA zone: 3996 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 14120 pages used for memmap
> [    0.000000]   DMA32 zone: 903629 pages, LIFO batch:31
> [    0.000000]   Normal zone: 51136 pages used for memmap
> [    0.000000]   Normal zone: 3272704 pages, LIFO batch:31
> [    0.000000] ACPI: PM-Timer IO Port: 0x408
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI
> 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
> [    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009dfff]
> [    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
> [    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
> [    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xdd589000-0xdd8e1fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xdd8e2000-0xdd8f1fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xdd8f2000-0xdda14fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xdda15000-0xde7c6fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xde7c8000-0xde80afff]
> [    0.000000] PM: Registered nosave memory: [mem 0xdec42000-0xdeff3fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xdf000000-0xf7ffffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfbffffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfebfffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfecfffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed03fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfed04000-0xfed1bfff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfeffffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
> [    0.000000] e820: [mem 0xdf000000-0xf7ffffff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on bare hardware
> [    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256
> nr_cpu_ids:4 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88041ec00000 s86528
> r8192 d24064 u524288
> [    0.000000] pcpu-alloc: s86528 r8192 d24064 u524288 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 1 2 3
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
> Total pages: 4114988
> [    0.000000] Policy zone: Normal
> [    0.000000] Kernel command line:
> BOOT_IMAGE=/boot/vmlinuz-3.14.0-rc7-core2-custom
> root=UUID=2e3c458f-cb2e-4789-8e70-68bccb5bafd9 ro zswap.enabled=1
> transparent_hugepage=always
> resume=UUID=ee90e063-6256-44f2-8bb9-a20d75e9a078 resume_offset=808960
> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
> [    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
> [    0.000000] Calgary: detecting Calgary via BIOS EBDA area
> [    0.000000] Calgary: Unable to locate Rio Grande table in EBDA -
> bailing!
> [    0.000000] Memory: 16358808K/16721316K available (7232K kernel code,
> 1106K rwdata, 3456K rodata, 1324K init, 1432K bss, 362508K reserved)
> [    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000]     RCU dyntick-idle grace-period acceleration is enabled.
> [    0.000000]     RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=4.
> [    0.000000]     Offload RCU callbacks from all CPUs
> [    0.000000]     Offload RCU callbacks from CPUs: 0-3.
> [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
> [    0.000000] NR_IRQS:16640 nr_irqs:712 16
> [    0.000000] Console: colour VGA+ 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] allocated 67108864 bytes of page_cgroup
> [    0.000000] please try 'cgroup_disable=memory' option if you don't
> want memory cgroups
> [    0.000000] hpet clockevent registered
> [    0.000000] tsc: Fast TSC calibration using PIT
> [    0.000000] tsc: Detected 3400.117 MHz processor
> [    0.000024] Calibrating delay loop (skipped), value calculated using
> timer frequency.. 6800.23 BogoMIPS (lpj=13600468)
> [    0.000160] pid_max: default: 32768 minimum: 301
> [    0.000228] ACPI: Core revision 20131218
> [    0.003936] ACPI: All ACPI Tables successfully acquired
> [    0.072141] Security Framework initialized
> [    0.072213] AppArmor: AppArmor initialized
> [    0.072276] Yama: becoming mindful.
> [    0.073096] Dentry cache hash table entries: 2097152 (order: 12,
> 16777216 bytes)
> [    0.076053] Inode-cache hash table entries: 1048576 (order: 11,
> 8388608 bytes)
> [    0.077409] Mount-cache hash table entries: 256
> [    0.077580] Initializing cgroup subsys memory
> [    0.077647] Initializing cgroup subsys devices
> [    0.077712] Initializing cgroup subsys freezer
> [    0.077777] Initializing cgroup subsys net_cls
> [    0.077841] Initializing cgroup subsys blkio
> [    0.077906] Initializing cgroup subsys perf_event
> [    0.077972] Initializing cgroup subsys hugetlb
> [    0.078052] CPU: Physical Processor ID: 0
> [    0.078116] CPU: Processor Core ID: 0
> [    0.078181] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
> [    0.078181] ENERGY_PERF_BIAS: View and update with
> x86_energy_perf_policy(8)
> [    0.078553] mce: CPU supports 9 MCE banks
> [    0.078625] CPU0: Thermal monitoring enabled (TM1)
> [    0.078696] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
> [    0.078696] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
> [    0.078696] tlb_flushall_shift: 2
> [    0.078918] Freeing SMP alternatives memory: 28K (ffffffff81e61000 -
> ffffffff81e68000)
> [    0.079808] ftrace: allocating 28103 entries in 110 pages
> [    0.089293] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.129023] smpboot: CPU0: Intel(R) Core(TM) i5-3570K CPU @ 3.40GHz
> (fam: 06, model: 3a, stepping: 09)
> [    0.129215] TSC deadline timer enabled
> [    0.130778] Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge
> events, full-width counters, Intel PMU driver.
> [    0.131032] ... version:                3
> [    0.131095] ... bit width:              48
> [    0.131159] ... generic registers:      8
> [    0.131222] ... value mask:             0000ffffffffffff
> [    0.131290] ... max period:             0000ffffffffffff
> [    0.131357] ... fixed-purpose events:   3
> [    0.131420] ... event mask:             00000007000000ff
> [    0.132559] x86: Booting SMP configuration:
> [    0.132624] .... node  #0, CPUs:      #1
> [    0.145989] NMI watchdog: enabled on all CPUs, permanently consumes
> one hw-PMU counter.
> [    0.153386]  #2 #3
> [    0.180378] x86: Booted up 1 node, 4 CPUs
> [    0.180493] smpboot: Total of 4 processors activated (27200.93 BogoMIPS)
> [    0.182960] devtmpfs: initialized
> [    0.185541] EVM: security.selinux
> [    0.185601] EVM: security.SMACK64
> [    0.185661] EVM: security.ima
> [    0.185720] EVM: security.capability
> [    0.185812] PM: Registering ACPI NVS region [mem
> 0xdd8f2000-0xdda14fff] (1191936 bytes)
> [    0.185918] PM: Registering ACPI NVS region [mem
> 0xde7c8000-0xde80afff] (274432 bytes)
> [    0.186541] pinctrl core: initialized pinctrl subsystem
> [    0.186649] regulator-dummy: no parameters
> [    0.186737] RTC time:  6:09:46, date: 03/22/14
> [    0.186823] NET: Registered protocol family 16
> [    0.186968] cpuidle: using governor ladder
> [    0.187031] cpuidle: using governor menu
> [    0.187120] ACPI FADT declares the system doesn't support PCIe ASPM,
> so disable it
> [    0.187215] ACPI: bus type PCI registered
> [    0.187316] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem
> 0xf8000000-0xfbffffff] (base 0xf8000000)
> [    0.187417] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in
> E820
> [    0.191760] PCI: Using configuration type 1 for base access
> [    0.192653] bio: create slab <bio-0> at 0
> [    0.192809] ACPI: Added _OSI(Module Device)
> [    0.192872] ACPI: Added _OSI(Processor Device)
> [    0.192935] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    0.193001] ACPI: Added _OSI(Processor Aggregator Device)
> [    0.195269] ACPI: Executed 1 blocks of module-level executable AML code
> [    0.200628] ACPI: SSDT 00000000dd88f018 00083B (v01  PmRef Cpu0Cst
> 00003001 INTL 20051117)
> [    0.201070] ACPI: Dynamic OEM Table Load:
> [    0.201191] ACPI: SSDT           (null) 00083B (v01  PmRef Cpu0Cst
> 00003001 INTL 20051117)
> [    0.204493] ACPI: SSDT 00000000dd890a98 000303 (v01  PmRef ApIst
> 00003000 INTL 20051117)
> [    0.204950] ACPI: Dynamic OEM Table Load:
> [    0.205071] ACPI: SSDT           (null) 000303 (v01  PmRef ApIst
> 00003000 INTL 20051117)
> [    0.208407] ACPI: SSDT 00000000dd891c18 000119 (v01  PmRef ApCst
> 00003000 INTL 20051117)
> [    0.208842] ACPI: Dynamic OEM Table Load:
> [    0.208964] ACPI: SSDT           (null) 000119 (v01  PmRef ApCst
> 00003000 INTL 20051117)
> [    0.212705] ACPI: Interpreter enabled
> [    0.212770] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep
> State [\_S1_] (20131218/hwxface-580)
> [    0.212930] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep
> State [\_S2_] (20131218/hwxface-580)
> [    0.213095] ACPI: (supports S0 S3 S4 S5)
> [    0.213157] ACPI: Using IOAPIC for interrupt routing
> [    0.213238] PCI: Using host bridge windows from ACPI; if necessary,
> use "pci=nocrs" and report a bug
> [    0.213453] ACPI: No dock devices found.
> [    0.218056] ACPI: Power Resource [FN00] (off)
> [    0.218175] ACPI: Power Resource [FN01] (off)
> [    0.218291] ACPI: Power Resource [FN02] (off)
> [    0.218407] ACPI: Power Resource [FN03] (off)
> [    0.218523] ACPI: Power Resource [FN04] (off)
> [    0.218854] ACPI: \_PR_.CPU4: failed to get CPU APIC ID.
> [    0.218856] ACPI: \_PR_.CPU5: failed to get CPU APIC ID.
> [    0.218858] ACPI: \_PR_.CPU6: failed to get CPU APIC ID.
> [    0.218860] ACPI: \_PR_.CPU7: failed to get CPU APIC ID.
> [    0.219006] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
> [    0.219078] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM
> ClockPM Segments MSI]
> [    0.219314] acpi PNP0A08:00: _OSC: platform does not support
> [PCIeHotplug PME]
> [    0.219491] acpi PNP0A08:00: _OSC: OS now controls [AER PCIeCapability]
> [    0.219879] PCI host bridge to bus 0000:00
> [    0.219942] pci_bus 0000:00: root bus resource [bus 00-3e]
> [    0.220009] pci_bus 0000:00: root bus resource [io 0x0000-0x0cf7]
> [    0.220078] pci_bus 0000:00: root bus resource [io 0x0d00-0xffff]
> [    0.220147] pci_bus 0000:00: root bus resource [mem
> 0x000a0000-0x000bffff]
> [    0.220218] pci_bus 0000:00: root bus resource [mem
> 0x000d0000-0x000d3fff]
> [    0.220289] pci_bus 0000:00: root bus resource [mem
> 0x000d4000-0x000d7fff]
> [    0.220360] pci_bus 0000:00: root bus resource [mem
> 0x000d8000-0x000dbfff]
> [    0.220431] pci_bus 0000:00: root bus resource [mem
> 0x000dc000-0x000dffff]
> [    0.220502] pci_bus 0000:00: root bus resource [mem
> 0x000e0000-0x000e3fff]
> [    0.220573] pci_bus 0000:00: root bus resource [mem
> 0x000e4000-0x000e7fff]
> [    0.220643] pci_bus 0000:00: root bus resource [mem
> 0xe0000000-0xfeafffff]
> [    0.220719] pci 0000:00:00.0: [8086:0150] type 00 class 0x060000
> [    0.220782] pci 0000:00:01.0: [8086:0151] type 01 class 0x060400
> [    0.220807] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
> [    0.220836] pci 0000:00:01.0: System wakeup disabled by ACPI
> [    0.220951] pci 0000:00:14.0: [8086:1e31] type 00 class 0x0c0330
> [    0.220971] pci 0000:00:14.0: reg 0x10: [mem 0xf6320000-0xf632ffff
> 64bit]
> [    0.221035] pci 0000:00:14.0: PME# supported from D3hot D3cold
> [    0.221067] pci 0000:00:14.0: System wakeup disabled by ACPI
> [    0.221162] pci 0000:00:16.0: [8086:1e3a] type 00 class 0x078000
> [    0.221183] pci 0000:00:16.0: reg 0x10: [mem 0xf633b000-0xf633b00f
> 64bit]
> [    0.221253] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
> [    0.221316] pci 0000:00:19.0: [8086:1503] type 00 class 0x020000
> [    0.221332] pci 0000:00:19.0: reg 0x10: [mem 0xf6300000-0xf631ffff]
> [    0.221339] pci 0000:00:19.0: reg 0x14: [mem 0xf6339000-0xf6339fff]
> [    0.221347] pci 0000:00:19.0: reg 0x18: [io  0xf040-0xf05f]
> [    0.221404] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
> [    0.221436] pci 0000:00:19.0: System wakeup disabled by ACPI
> [    0.221532] pci 0000:00:1a.0: [8086:1e2d] type 00 class 0x0c0320
> [    0.221551] pci 0000:00:1a.0: reg 0x10: [mem 0xf6338000-0xf63383ff]
> [    0.221633] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
> [    0.221676] pci 0000:00:1a.0: System wakeup disabled by ACPI
> [    0.221771] pci 0000:00:1b.0: [8086:1e20] type 00 class 0x040300
> [    0.221784] pci 0000:00:1b.0: reg 0x10: [mem 0xf6330000-0xf6333fff
> 64bit]
> [    0.221851] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
> [    0.221885] pci 0000:00:1b.0: System wakeup disabled by ACPI
> [    0.221983] pci 0000:00:1c.0: [8086:1e10] type 01 class 0x060400
> [    0.222112] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> [    0.222158] pci 0000:00:1c.0: System wakeup disabled by ACPI
> [    0.222252] pci 0000:00:1c.4: [8086:1e18] type 01 class 0x060400
> [    0.222326] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
> [    0.222362] pci 0000:00:1c.4: System wakeup disabled by ACPI
> [    0.222456] pci 0000:00:1c.7: [8086:1e1e] type 01 class 0x060400
> [    0.222530] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
> [    0.222567] pci 0000:00:1c.7: System wakeup disabled by ACPI
> [    0.222663] pci 0000:00:1d.0: [8086:1e26] type 00 class 0x0c0320
> [    0.222681] pci 0000:00:1d.0: reg 0x10: [mem 0xf6337000-0xf63373ff]
> [    0.222764] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
> [    0.222806] pci 0000:00:1d.0: System wakeup disabled by ACPI
> [    0.222903] pci 0000:00:1f.0: [8086:1e44] type 00 class 0x060100
> [    0.223053] pci 0000:00:1f.2: [8086:1e02] type 00 class 0x010601
> [    0.223068] pci 0000:00:1f.2: reg 0x10: [io  0xf090-0xf097]
> [    0.223075] pci 0000:00:1f.2: reg 0x14: [io  0xf080-0xf083]
> [    0.223081] pci 0000:00:1f.2: reg 0x18: [io  0xf070-0xf077]
> [    0.223087] pci 0000:00:1f.2: reg 0x1c: [io  0xf060-0xf063]
> [    0.223094] pci 0000:00:1f.2: reg 0x20: [io  0xf020-0xf03f]
> [    0.223100] pci 0000:00:1f.2: reg 0x24: [mem 0xf6336000-0xf63367ff]
> [    0.223139] pci 0000:00:1f.2: PME# supported from D3hot
> [    0.223192] pci 0000:00:1f.3: [8086:1e22] type 00 class 0x0c0500
> [    0.223205] pci 0000:00:1f.3: reg 0x10: [mem 0xf6335000-0xf63350ff
> 64bit]
> [    0.223223] pci 0000:00:1f.3: reg 0x20: [io  0xf000-0xf01f]
> [    0.223313] pci 0000:01:00.0: [10de:1200] type 00 class 0x030000
> [    0.223320] pci 0000:01:00.0: reg 0x10: [mem 0xf4000000-0xf5ffffff]
> [    0.223327] pci 0000:01:00.0: reg 0x14: [mem 0xe8000000-0xefffffff
> 64bit pref]
> [    0.223335] pci 0000:01:00.0: reg 0x1c: [mem 0xf0000000-0xf3ffffff
> 64bit pref]
> [    0.223340] pci 0000:01:00.0: reg 0x24: [io  0xe000-0xe07f]
> [    0.223345] pci 0000:01:00.0: reg 0x30: [mem 0xf6000000-0xf607ffff pref]
> [    0.223406] pci 0000:01:00.1: [10de:0e0c] type 00 class 0x040300
> [    0.223413] pci 0000:01:00.1: reg 0x10: [mem 0xf6080000-0xf6083fff]
> [    0.230883] pci 0000:00:01.0: PCI bridge to [bus 01]
> [    0.230949] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
> [    0.230951] pci 0000:00:01.0:   bridge window [mem
> 0xf4000000-0xf60fffff]
> [    0.230953] pci 0000:00:01.0:   bridge window [mem
> 0xe8000000-0xf3ffffff 64bit pref]
> [    0.231029] pci 0000:00:1c.0: PCI bridge to [bus 02]
> [    0.231179] pci 0000:03:00.0: [1b21:1042] type 00 class 0x0c0330
> [    0.231206] pci 0000:03:00.0: reg 0x10: [mem 0xf6200000-0xf6207fff
> 64bit]
> [    0.231359] pci 0000:03:00.0: PME# supported from D3hot D3cold
> [    0.231389] pci 0000:03:00.0: System wakeup disabled by ACPI
> [    0.238883] pci 0000:00:1c.4: PCI bridge to [bus 03]
> [    0.238952] pci 0000:00:1c.4:   bridge window [mem
> 0xf6200000-0xf62fffff]
> [    0.239022] pci 0000:04:00.0: [1b21:0612] type 00 class 0x010601
> [    0.239040] pci 0000:04:00.0: reg 0x10: [io  0xd050-0xd057]
> [    0.239052] pci 0000:04:00.0: reg 0x14: [io  0xd040-0xd043]
> [    0.239065] pci 0000:04:00.0: reg 0x18: [io  0xd030-0xd037]
> [    0.239077] pci 0000:04:00.0: reg 0x1c: [io  0xd020-0xd023]
> [    0.239090] pci 0000:04:00.0: reg 0x20: [io  0xd000-0xd01f]
> [    0.239102] pci 0000:04:00.0: reg 0x24: [mem 0xf6100000-0xf61001ff]
> [    0.239202] pci 0000:04:00.0: System wakeup disabled by ACPI
> [    0.246879] pci 0000:00:1c.7: PCI bridge to [bus 04]
> [    0.246946] pci 0000:00:1c.7:   bridge window [io  0xd000-0xdfff]
> [    0.246949] pci 0000:00:1c.7:   bridge window [mem
> 0xf6100000-0xf61fffff]
> [    0.246978] acpi PNP0A08:00: Disabling ASPM (FADT indicates it is
> unsupported)
> [    0.247187] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12
> 14 15)
> [    0.247603] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *10 11 12
> 14 15)
> [    0.248016] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *10 11 12
> 14 15)
> [    0.248429] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 10 11 12
> 14 15)
> [    0.248842] ACPI: PCI Interrupt Link [LNKE] (IRQs *3 4 5 6 10 11 12
> 14 15)
> [    0.249255] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14
> 15) *0, disabled.
> [    0.249752] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 *4 5 6 10 11 12
> 14 15)
> [    0.250165] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 *11 12
> 14 15)
> [    0.250617] ACPI: Enabled 4 GPEs in block 00 to 3F
> [    0.250752] ACPI : EC: GPE = 0x18, I/O: command/status = 0x66, data =
> 0x62
> [    0.250897] vgaarb: device added:
> PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
> [    0.250994] vgaarb: loaded
> [    0.251053] vgaarb: bridge control possible 0000:01:00.0
> [    0.251233] SCSI subsystem initialized
> [    0.251323] libata version 3.00 loaded.
> [    0.251341] ACPI: bus type USB registered
> [    0.251416] usbcore: registered new interface driver usbfs
> [    0.251488] usbcore: registered new interface driver hub
> [    0.251565] usbcore: registered new device driver usb
> [    0.251696] PCI: Using ACPI for IRQ routing
> [    0.253126] PCI: pci_cache_line_size set to 64 bytes
> [    0.253168] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
> [    0.253170] e820: reserve RAM buffer [mem 0xdd589000-0xdfffffff]
> [    0.253171] e820: reserve RAM buffer [mem 0xde7c8000-0xdfffffff]
> [    0.253172] e820: reserve RAM buffer [mem 0xdec42000-0xdfffffff]
> [    0.253173] e820: reserve RAM buffer [mem 0xdf000000-0xdfffffff]
> [    0.253174] e820: reserve RAM buffer [mem 0x41f000000-0x41fffffff]
> [    0.253234] NetLabel: Initializing
> [    0.253294] NetLabel:  domain hash size = 128
> [    0.253357] NetLabel:  protocols = UNLABELED CIPSOv4
> [    0.253428] NetLabel:  unlabeled traffic allowed by default
> [    0.253538] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
> [    0.253866] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
> [    0.255951] Switched to clocksource hpet
> [    0.259735] AppArmor: AppArmor Filesystem Enabled
> [    0.259815] pnp: PnP ACPI init
> [    0.259883] ACPI: bus type PNP registered
> [    0.260012] system 00:00: [mem 0xfed40000-0xfed44fff] has been reserved
> [    0.260084] system 00:00: Plug and Play ACPI device, IDs PNP0c01
> (active)
> [    0.260092] pnp 00:01: [dma 4]
> [    0.260103] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
> [    0.260118] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
> [    0.260178] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
> [    0.260207] system 00:04: [io  0x0680-0x069f] has been reserved
> [    0.260277] system 00:04: [io  0x1000-0x100f] has been reserved
> [    0.260345] system 00:04: [io  0xffff] has been reserved
> [    0.260412] system 00:04: [io  0xffff] has been reserved
> [    0.260478] system 00:04: [io  0x0400-0x0453] could not be reserved
> [    0.260547] system 00:04: [io  0x0458-0x047f] has been reserved
> [    0.260616] system 00:04: [io  0x0500-0x057f] has been reserved
> [    0.260684] system 00:04: [io  0x164e-0x164f] has been reserved
> [    0.260752] system 00:04: Plug and Play ACPI device, IDs PNP0c02
> (active)
> [    0.260774] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    0.260805] system 00:06: [io  0x0454-0x0457] has been reserved
> [    0.260874] system 00:06: Plug and Play ACPI device, IDs INT3f0d
> PNP0c02 (active)
> [    0.260928] system 00:07: [io  0x0290-0x029f] has been reserved
> [    0.260997] system 00:07: Plug and Play ACPI device, IDs PNP0c02
> (active)
> [    0.261031] system 00:08: [io  0x04d0-0x04d1] has been reserved
> [    0.261099] system 00:08: Plug and Play ACPI device, IDs PNP0c02
> (active)
> [    0.261118] pnp 00:09: Plug and Play ACPI device, IDs PNP0c04 (active)
> [    0.261290] system 00:0a: [mem 0xfed1c000-0xfed1ffff] has been reserved
> [    0.261360] system 00:0a: [mem 0xfed10000-0xfed17fff] has been reserved
> [    0.261432] system 00:0a: [mem 0xfed18000-0xfed18fff] has been reserved
> [    0.261503] system 00:0a: [mem 0xfed19000-0xfed19fff] has been reserved
> [    0.261576] system 00:0a: [mem 0xf8000000-0xfbffffff] has been reserved
> [    0.261646] system 00:0a: [mem 0xfed20000-0xfed3ffff] has been reserved
> [    0.261716] system 00:0a: [mem 0xfed90000-0xfed93fff] has been reserved
> [    0.261786] system 00:0a: [mem 0xfed45000-0xfed8ffff] has been reserved
> [    0.261857] system 00:0a: [mem 0xff000000-0xffffffff] has been reserved
> [    0.261927] system 00:0a: [mem 0xfee00000-0xfeefffff] could not be
> reserved
> [    0.261998] system 00:0a: [mem 0xe0000000-0xe0000fff] has been reserved
> [    0.262069] system 00:0a: Plug and Play ACPI device, IDs PNP0c02
> (active)
> [    0.262145] pnp: PnP ACPI: found 11 devices
> [    0.262207] ACPI: bus type PNP unregistered
> [    0.268057] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to
> [bus 02] add_size 1000
> [    0.268060] pci 0000:00:1c.0: bridge window [mem
> 0x00100000-0x000fffff 64bit pref] to [bus 02] add_size 200000
> [    0.268061] pci 0000:00:1c.0: bridge window [mem
> 0x00100000-0x000fffff] to [bus 02] add_size 200000
> [    0.268076] pci 0000:00:1c.0: res[14]=[mem 0x00100000-0x000fffff]
> get_res_add_size add_size 200000
> [    0.268077] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff
> 64bit pref] get_res_add_size add_size 200000
> [    0.268078] pci 0000:00:1c.0: res[13]=[io  0x1000-0x0fff]
> get_res_add_size add_size 1000
> [    0.268082] pci 0000:00:1c.0: BAR 14: assigned [mem
> 0xe0100000-0xe02fffff]
> [    0.268157] pci 0000:00:1c.0: BAR 15: assigned [mem
> 0xe0300000-0xe04fffff 64bit pref]
> [    0.268254] pci 0000:00:1c.0: BAR 13: assigned [io 0x2000-0x2fff]
> [    0.268323] pci 0000:00:01.0: PCI bridge to [bus 01]
> [    0.268389] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
> [    0.268459] pci 0000:00:01.0:   bridge window [mem
> 0xf4000000-0xf60fffff]
> [    0.268530] pci 0000:00:01.0:   bridge window [mem
> 0xe8000000-0xf3ffffff 64bit pref]
> [    0.268627] pci 0000:00:1c.0: PCI bridge to [bus 02]
> [    0.268693] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
> [    0.268767] pci 0000:00:1c.0:   bridge window [mem
> 0xe0100000-0xe02fffff]
> [    0.268840] pci 0000:00:1c.0:   bridge window [mem
> 0xe0300000-0xe04fffff 64bit pref]
> [    0.268943] pci 0000:00:1c.4: PCI bridge to [bus 03]
> [    0.269011] pci 0000:00:1c.4:   bridge window [mem
> 0xf6200000-0xf62fffff]
> [    0.269087] pci 0000:00:1c.7: PCI bridge to [bus 04]
> [    0.269153] pci 0000:00:1c.7:   bridge window [io  0xd000-0xdfff]
> [    0.269224] pci 0000:00:1c.7:   bridge window [mem
> 0xf6100000-0xf61fffff]
> [    0.269301] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
> [    0.269302] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
> [    0.269303] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
> [    0.269304] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
> [    0.269306] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
> [    0.269307] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
> [    0.269308] pci_bus 0000:00: resource 10 [mem 0x000dc000-0x000dffff]
> [    0.269309] pci_bus 0000:00: resource 11 [mem 0x000e0000-0x000e3fff]
> [    0.269310] pci_bus 0000:00: resource 12 [mem 0x000e4000-0x000e7fff]
> [    0.269311] pci_bus 0000:00: resource 13 [mem 0xe0000000-0xfeafffff]
> [    0.269312] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
> [    0.269313] pci_bus 0000:01: resource 1 [mem 0xf4000000-0xf60fffff]
> [    0.269315] pci_bus 0000:01: resource 2 [mem 0xe8000000-0xf3ffffff
> 64bit pref]
> [    0.269316] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
> [    0.269317] pci_bus 0000:02: resource 1 [mem 0xe0100000-0xe02fffff]
> [    0.269318] pci_bus 0000:02: resource 2 [mem 0xe0300000-0xe04fffff
> 64bit pref]
> [    0.269319] pci_bus 0000:03: resource 1 [mem 0xf6200000-0xf62fffff]
> [    0.269321] pci_bus 0000:04: resource 0 [io  0xd000-0xdfff]
> [    0.269322] pci_bus 0000:04: resource 1 [mem 0xf6100000-0xf61fffff]
> [    0.269337] NET: Registered protocol family 2
> [    0.269512] TCP established hash table entries: 131072 (order: 8,
> 1048576 bytes)
> [    0.269767] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
> [    0.269932] TCP: Hash tables configured (established 131072 bind 65536)
> [    0.270010] TCP: reno registered
> [    0.270082] UDP hash table entries: 8192 (order: 6, 262144 bytes)
> [    0.276541] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
> [    0.276661] NET: Registered protocol family 1
> [    0.315987] pci 0000:01:00.0: Boot video device
> [    0.316109] PCI: CLS 64 bytes, default 64
> [    0.316141] Trying to unpack rootfs image as initramfs...
> [    0.510049] Freeing initrd memory: 17200K (ffff880035e58000 -
> ffff880036f24000)
> [    0.510148] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> [    0.510218] software IO TLB [mem 0xd9589000-0xdd589000] (64MB) mapped
> at [ffff8800d9589000-ffff8800dd588fff]
> [    0.510463] RAPL PMU detected, hw unit 2^-16 Joules, API unit is
> 2^-32 Joules, 3 fixed counters 163840 ms ovfl timer
> [    0.510593] Scanning for low memory corruption every 60 seconds
> [    0.510856] futex hash table entries: 1024 (order: 4, 65536 bytes)
> [    0.510933] Initialise system trusted keyring
> [    0.511022] audit: initializing netlink subsys (disabled)
> [    0.511097] audit: type=2000 audit(1395468585.440:1): initialized
> [    0.529253] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    0.530203] zbud: loaded
> [    0.530351] VFS: Disk quotas dquot_6.5.2
> [    0.530440] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    0.530814] fuse init (API version 7.22)
> [    0.530928] msgmni has been set to 31984
> [    0.531022] Key type big_key registered
> [    0.531349] Key type asymmetric registered
> [    0.531412] Asymmetric key parser 'x509' registered
> [    0.531502] Block layer SCSI generic (bsg) driver version 0.4 loaded
> (major 252)
> [    0.535803] io scheduler noop registered
> [    0.535866] io scheduler deadline registered (default)
> [    0.535950] io scheduler cfq registered
> [    0.536134] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
> [    0.536447] intel_idle: MWAIT substates: 0x1120
> [    0.536449] intel_idle: v0.4 model 0x3A
> [    0.536449] intel_idle: lapic_timer_reliable_states 0xffffffff
> [    0.536575] input: Power Button as
> /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
> [    0.536675] ACPI: Power Button [PWRB]
> [    0.536760] input: Power Button as
> /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
> [    0.536855] ACPI: Power Button [PWRF]
> [    0.536953] ACPI: Fan [FAN0] (off)
> [    0.537031] ACPI: Fan [FAN1] (off)
> [    0.537108] ACPI: Fan [FAN2] (off)
> [    0.537186] ACPI: Fan [FAN3] (off)
> [    0.537262] ACPI: Fan [FAN4] (off)
> [    0.544013] thermal LNXTHERM:00: registered as thermal_zone0
> [    0.544081] ACPI: Thermal Zone [TZ00] (28 C)
> [    0.544277] thermal LNXTHERM:01: registered as thermal_zone1
> [    0.544344] ACPI: Thermal Zone [TZ01] (30 C)
> [    0.544424] GHES: HEST is not enabled!
> [    0.544537] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
> [    0.545834] Linux agpgart interface v0.103
> [    0.546796] brd: module loaded
> [    0.547314] loop: module loaded
> [    0.547607] libphy: Fixed MDIO Bus: probed
> [    0.547727] tun: Universal TUN/TAP device driver, 1.6
> [    0.547800] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
> [    0.547897] PPP generic driver version 2.4.2
> [    0.547984] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    0.548055] ehci-pci: EHCI PCI platform driver
> [    0.548198] ehci-pci 0000:00:1a.0: EHCI Host Controller
> [    0.548267] ehci-pci 0000:00:1a.0: new USB bus registered, assigned
> bus number 1
> [    0.548371] ehci-pci 0000:00:1a.0: debug port 2
> [    0.552337] ehci-pci 0000:00:1a.0: cache line size of 64 is not
> supported
> [    0.552352] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf6338000
> [    0.563782] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
> [    0.563875] usb usb1: New USB device found, idVendor=1d6b,
> idProduct=0002
> [    0.563946] usb usb1: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    0.564041] usb usb1: Product: EHCI Host Controller
> [    0.564105] usb usb1: Manufacturer: Linux 3.14.0-rc7-core2-custom
> ehci_hcd
> [    0.564176] usb usb1: SerialNumber: 0000:00:1a.0
> [    0.564316] hub 1-0:1.0: USB hub found
> [    0.564382] hub 1-0:1.0: 2 ports detected
> [    0.564584] ehci-pci 0000:00:1d.0: EHCI Host Controller
> [    0.564653] ehci-pci 0000:00:1d.0: new USB bus registered, assigned
> bus number 2
> [    0.564756] ehci-pci 0000:00:1d.0: debug port 2
> [    0.568714] ehci-pci 0000:00:1d.0: cache line size of 64 is not
> supported
> [    0.568727] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf6337000
> [    0.579773] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
> [    0.579865] usb usb2: New USB device found, idVendor=1d6b,
> idProduct=0002
> [    0.579936] usb usb2: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    0.580030] usb usb2: Product: EHCI Host Controller
> [    0.580095] usb usb2: Manufacturer: Linux 3.14.0-rc7-core2-custom
> ehci_hcd
> [    0.580166] usb usb2: SerialNumber: 0000:00:1d.0
> [    0.580305] hub 2-0:1.0: USB hub found
> [    0.580371] hub 2-0:1.0: 2 ports detected
> [    0.580504] ehci-platform: EHCI generic platform driver
> [    0.580573] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    0.580643] ohci-pci: OHCI PCI platform driver
> [    0.580711] ohci-platform: OHCI generic platform driver
> [    0.580781] uhci_hcd: USB Universal Host Controller Interface driver
> [    0.580928] xhci_hcd 0000:00:14.0: xHCI Host Controller
> [    0.580996] xhci_hcd 0000:00:14.0: new USB bus registered, assigned
> bus number 3
> [    0.581164] xhci_hcd 0000:00:14.0: cache line size of 64 is not
> supported
> [    0.581178] xhci_hcd 0000:00:14.0: irq 41 for MSI/MSI-X
> [    0.581224] usb usb3: New USB device found, idVendor=1d6b,
> idProduct=0002
> [    0.581295] usb usb3: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    0.581389] usb usb3: Product: xHCI Host Controller
> [    0.581454] usb usb3: Manufacturer: Linux 3.14.0-rc7-core2-custom
> xhci_hcd
> [    0.581524] usb usb3: SerialNumber: 0000:00:14.0
> [    0.581711] hub 3-0:1.0: USB hub found
> [    0.581781] hub 3-0:1.0: 4 ports detected
> [    0.582058] xhci_hcd 0000:00:14.0: xHCI Host Controller
> [    0.582125] xhci_hcd 0000:00:14.0: new USB bus registered, assigned
> bus number 4
> [    0.582244] usb usb4: New USB device found, idVendor=1d6b,
> idProduct=0003
> [    0.582315] usb usb4: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    0.582409] usb usb4: Product: xHCI Host Controller
> [    0.582474] usb usb4: Manufacturer: Linux 3.14.0-rc7-core2-custom
> xhci_hcd
> [    0.582544] usb usb4: SerialNumber: 0000:00:14.0
> [    0.582729] hub 4-0:1.0: USB hub found
> [    0.582800] hub 4-0:1.0: 4 ports detected
> [    0.583113] xhci_hcd 0000:03:00.0: xHCI Host Controller
> [    0.583182] xhci_hcd 0000:03:00.0: new USB bus registered, assigned
> bus number 5
> [    0.644486] xhci_hcd 0000:03:00.0: irq 42 for MSI/MSI-X
> [    0.644490] xhci_hcd 0000:03:00.0: irq 43 for MSI/MSI-X
> [    0.644493] xhci_hcd 0000:03:00.0: irq 44 for MSI/MSI-X
> [    0.644496] xhci_hcd 0000:03:00.0: irq 45 for MSI/MSI-X
> [    0.644499] xhci_hcd 0000:03:00.0: irq 46 for MSI/MSI-X
> [    0.644590] usb usb5: New USB device found, idVendor=1d6b,
> idProduct=0002
> [    0.644661] usb usb5: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    0.644756] usb usb5: Product: xHCI Host Controller
> [    0.644821] usb usb5: Manufacturer: Linux 3.14.0-rc7-core2-custom
> xhci_hcd
> [    0.644892] usb usb5: SerialNumber: 0000:03:00.0
> [    0.645078] hub 5-0:1.0: USB hub found
> [    0.645150] hub 5-0:1.0: 2 ports detected
> [    0.645269] xhci_hcd 0000:03:00.0: xHCI Host Controller
> [    0.645336] xhci_hcd 0000:03:00.0: new USB bus registered, assigned
> bus number 6
> [    0.645486] usb usb6: New USB device found, idVendor=1d6b,
> idProduct=0003
> [    0.645557] usb usb6: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    0.645651] usb usb6: Product: xHCI Host Controller
> [    0.645716] usb usb6: Manufacturer: Linux 3.14.0-rc7-core2-custom
> xhci_hcd
> [    0.645787] usb usb6: SerialNumber: 0000:03:00.0
> [    0.645972] hub 6-0:1.0: USB hub found
> [    0.646042] hub 6-0:1.0: 2 ports detected
> [    0.646183] i8042: PNP: No PS/2 controller found. Probing ports
> directly.
> [    0.648502] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    0.648571] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    0.648843] mousedev: PS/2 mouse device common for all mice
> [    0.649105] rtc_cmos 00:05: RTC can wake from S4
> [    0.649296] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
> [    0.649388] rtc_cmos 00:05: alarms up to one month, y3k, 242 bytes
> nvram, hpet irqs
> [    0.649524] device-mapper: uevent: version 1.0.3
> [    0.649651] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30)
> initialised: dm-devel@redhat.com
> [    0.649751] Intel P-state driver initializing.
> [    0.649822] Intel pstate controlling: cpu 0
> [    0.649894] Intel pstate controlling: cpu 1
> [    0.649971] Intel pstate controlling: cpu 2
> [    0.650039] Intel pstate controlling: cpu 3
> [    0.650114] ledtrig-cpu: registered to indicate activity on CPUs
> [    0.650229] TCP: cubic registered
> [    0.650342] NET: Registered protocol family 10
> [    0.650484] NET: Registered protocol family 17
> [    0.650550] Key type dns_resolver registered
> [    0.650881] Loading compiled-in X.509 certificates
> [    0.651446] Loaded X.509 cert 'Magrathea: Glacier signing key:
> f89562611143a4f77a9dcf6557ce653bd7356fe2'
> [    0.651550] registered taskstats version 1
> [    0.651613] zswap: loading zswap
> [    0.651674] zswap: using lzo compressor
> [    0.653644] Key type trusted registered
> [    0.655538] Key type encrypted registered
> [    0.657470] AppArmor: AppArmor sha1 policy hashing enabled
> [    0.657539] IMA: No TPM chip found, activating TPM-bypass!
> [    0.657832] regulator-dummy: disabling
> [    0.658041]   Magic number: 6:883:165
> [    0.658212] rtc_cmos 00:05: setting system clock to 2014-03-22
> 06:09:46 UTC (1395468586)
> [    0.658379] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
> [    0.658449] EDD information not available.
> [    0.658551] PM: Checking hibernation image partition
> UUID=ee90e063-6256-44f2-8bb9-a20d75e9a078
> [    0.875672] usb 1-1: new high-speed USB device number 2 using ehci-pci
> [    0.979321] PM: Hibernation image not present or could not be loaded.
> [    0.979933] Freeing unused kernel memory: 1324K (ffffffff81d16000 -
> ffffffff81e61000)
> [    0.980031] Write protecting the kernel read-only data: 12288k
> [    0.981774] Freeing unused kernel memory: 948K (ffff880001713000 -
> ffff880001800000)
> [    0.982998] Freeing unused kernel memory: 640K (ffff880001b60000 -
> ffff880001c00000)
> [    0.992321] systemd-udevd[114]: starting version 204
> [    1.007257] pps_core: LinuxPPS API ver. 1 registered
> [    1.007257] pps_core: Software ver. 5.3.6 - Copyright 2005-2007
> Rodolfo Giometti <giometti@linux.it>
> [    1.008027] PTP clock support registered
> [    1.010464] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
> [    1.010536] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
> [    1.010743] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec)
> set to dynamic conservative mode
> [    1.010857] e1000e 0000:00:19.0: irq 47 for MSI/MSI-X
> [    1.022045] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
> [    1.022120] usb 1-1: New USB device strings: Mfr=0, Product=0,
> SerialNumber=0
> [    1.022696] hub 1-1:1.0: USB hub found
> [    1.022806] hub 1-1:1.0: 6 ports detected
> [    1.135521] usb 2-1: new high-speed USB device number 2 using ehci-pci
> [    1.267686] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
> [    1.267767] usb 2-1: New USB device strings: Mfr=0, Product=0,
> SerialNumber=0
> [    1.268068] hub 2-1:1.0: USB hub found
> [    1.268309] hub 2-1:1.0: 8 ports detected
> [    1.270213] e1000e 0000:00:19.0 eth0: registered PHC clock
> [    1.270301] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1)
> 10:bf:48:88:f7:57
> [    1.270406] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network
> Connection
> [    1.270505] e1000e 0000:00:19.0 eth0: MAC: 10, PHY: 11, PBA No:
> FFFFFF-0FF
> [    1.270620] ahci 0000:00:1f.2: version 3.0
> [    1.270763] ahci 0000:00:1f.2: irq 48 for MSI/MSI-X
> [    1.270778] ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
> [    1.283405] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps
> 0x13 impl SATA mode
> [    1.283515] ahci 0000:00:1f.2: flags: 64bit ncq stag led clo pio slum
> part ems sxs apst
> [    1.299950] scsi0 : ahci
> [    1.300284] scsi1 : ahci
> [    1.300581] scsi2 : ahci
> [    1.300829] scsi3 : ahci
> [    1.301038] scsi4 : ahci
> [    1.301233] scsi5 : ahci
> [    1.301326] ata1: SATA max UDMA/133 abar m2048@0xf6336000 port
> 0xf6336100 irq 48
> [    1.301424] ata2: SATA max UDMA/133 abar m2048@0xf6336000 port
> 0xf6336180 irq 48
> [    1.301518] ata3: DUMMY
> [    1.301575] ata4: DUMMY
> [    1.301632] ata5: SATA max UDMA/133 abar m2048@0xf6336000 port
> 0xf6336300 irq 48
> [    1.301727] ata6: DUMMY
> [    1.301904] ahci 0000:04:00.0: irq 49 for MSI/MSI-X
> [    1.301918] ahci 0000:04:00.0: SSS flag set, parallel bus scan disabled
> [    1.302101] ahci 0000:04:00.0: AHCI 0001.0200 32 slots 2 ports 6 Gbps
> 0x3 impl SATA mode
> [    1.302234] ahci 0000:04:00.0: flags: 64bit ncq sntf stag led clo pmp
> pio slum part ccc sxs
> [    1.302539] scsi6 : ahci
> [    1.302692] scsi7 : ahci
> [    1.302780] ata7: SATA max UDMA/133 abar m512@0xf6100000 port
> 0xf6100100 irq 49
> [    1.302878] ata8: SATA max UDMA/133 abar m512@0xf6100000 port
> 0xf6100180 irq 49
> [    1.435347] usb 5-1: new full-speed USB device number 2 using xhci_hcd
> [    1.507262] tsc: Refined TSC clocksource calibration: 3400.024 MHz
> [    1.619204] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [    1.620108] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND
> (20131218/psargs-359)
> [    1.620325] ACPI Error: Method parse/execution failed
> [\_SB_.PCI0.SAT0.SPT0._GTF] (Node ffff88040e039708), AE_NOT_FOUND
> (20131218/psparse-536)
> [    1.620662] usb 5-1: New USB device found, idVendor=046d, idProduct=092c
> [    1.620737] usb 5-1: New USB device strings: Mfr=1, Product=2,
> SerialNumber=0
> [    1.620809] usb 5-1: Product: Camera
> [    1.620869] usb 5-1: Manufacturer:
> [    1.663186] ata1.00: ATA-7: MAXTOR STM3250820AS, 3.AAE, max UDMA/133
> [    1.663268] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth
> 31/32)
> [    1.688498] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND
> (20131218/psargs-359)
> [    1.688691] ACPI Error: Method parse/execution failed
> [\_SB_.PCI0.SAT0.SPT0._GTF] (Node ffff88040e039708), AE_NOT_FOUND
> (20131218/psparse-536)
> [    1.721461] ata1.00: configured for UDMA/133
> [    1.721712] scsi 0:0:0:0: Direct-Access     ATA      MAXTOR STM325082
> 3.AA PQ: 0 ANSI: 5
> [    1.721941] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250
> GB/232 GiB)
> [    1.721952] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    1.722157] sd 0:0:0:0: [sda] Write Protect is off
> [    1.722229] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    1.722239] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    1.761169]  sda: sda1 sda2
> [    1.761516] sd 0:0:0:0: [sda] Attached SCSI disk
> [    1.787143] usb 5-2: new high-speed USB device number 3 using xhci_hcd
> [    1.791113] ata7: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [    1.791837] ata7.00: ATA-9: ST2000VN000-1H3164, SC42, max UDMA/133
> [    1.791919] ata7.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth
> 31/32), AA
> [    1.792635] ata7.00: configured for UDMA/133
> [    1.971569] usb 5-2: New USB device found, idVendor=03f0, idProduct=002a
> [    1.971652] usb 5-2: New USB device strings: Mfr=1, Product=2,
> SerialNumber=3
> [    1.971723] usb 5-2: Product: HP LaserJet Professional P1102
> [    1.971790] usb 5-2: Manufacturer: Hewlett-Packard
> [    1.971854] usb 5-2: SerialNumber: 000000000QN06A3BPR1a
> [    2.038959] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    2.039708] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND
> (20131218/psargs-359)
> [    2.039906] ACPI Error: Method parse/execution failed
> [\_SB_.PCI0.SAT0.SPT1._GTF] (Node ffff88040e039780), AE_NOT_FOUND
> (20131218/psparse-536)
> [    2.043125] usb 2-1.5: new low-speed USB device number 3 using ehci-pci
> [    2.060998] ata2.00: ATA-7: WDC WD5000AAKS-00TMA0, 12.01C01, max
> UDMA/133
> [    2.061082] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth
> 31/32), AA
> [    2.061885] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND
> (20131218/psargs-359)
> [    2.062078] ACPI Error: Method parse/execution failed
> [\_SB_.PCI0.SAT0.SPT1._GTF] (Node ffff88040e039780), AE_NOT_FOUND
> (20131218/psparse-536)
> [    2.062566] ata2.00: configured for UDMA/133
> [    2.062805] scsi 1:0:0:0: Direct-Access     ATA      WDC WD5000AAKS-0
> 12.0 PQ: 0 ANSI: 5
> [    2.063066] sd 1:0:0:0: [sdb] 976773168 512-byte logical blocks: (500
> GB/465 GiB)
> [    2.063080] sd 1:0:0:0: Attached scsi generic sg1 type 0
> [    2.063292] sd 1:0:0:0: [sdb] Write Protect is off
> [    2.063357] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> [    2.063367] sd 1:0:0:0: [sdb] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    2.082616]  sdb: sdb1 sdb2 < sdb5 >
> [    2.083087] sd 1:0:0:0: [sdb] Attached SCSI disk
> [    2.138945] usb 2-1.5: New USB device found, idVendor=046d,
> idProduct=c077
> [    2.139029] usb 2-1.5: New USB device strings: Mfr=1, Product=2,
> SerialNumber=0
> [    2.139123] usb 2-1.5: Product: USB Optical Mouse
> [    2.139187] usb 2-1.5: Manufacturer: Logitech
> [    2.141876] hidraw: raw HID events driver (C) Jiri Kosina
> [    2.145099] usbcore: registered new interface driver usbhid
> [    2.145173] usbhid: USB HID core driver
> [    2.146251] input: Logitech USB Optical Mouse as
> /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.5/2-1.5:1.0/0003:046D:C077.0001/input/input4
>
> [    2.146459] hid-generic 0003:046D:C077.0001: input,hidraw0: USB HID
> v1.11 Mouse [Logitech USB Optical Mouse] on usb-0000:00:1d.0-1.5/input0
> [    2.210863] usb 2-1.6: new low-speed USB device number 4 using ehci-pci
> [    2.325554] usb 2-1.6: New USB device found, idVendor=045e,
> idProduct=00b4
> [    2.325639] usb 2-1.6: New USB device strings: Mfr=1, Product=2,
> SerialNumber=0
> [    2.325733] usb 2-1.6: Product:
> Microsoft\xffffffc2\xffffffae\xffffffae Digital Media Keyboard
> [    2.325801] usb 2-1.6: Manufacturer: Microsoft
> [    2.334078] input: Microsoft Microsoft\xffffffc2\xffffffae\xffffffae
> Digital Media Keyboard as
> /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.6/2-1.6:1.0/0003:045E:00B4.0002/input/input5
>
> [    2.334350] hid-generic 0003:045E:00B4.0002: input,hidraw1: USB HID
> v1.11 Keyboard [Microsoft Microsoft\xffffffc2\xffffffae\xffffffae
> Digital Media Keyboard] on usb-0000:00:1d.0-1.6/input0
> [    2.348387] input: Microsoft Microsoft\xffffffc2\xffffffae\xffffffae
> Digital Media Keyboard as
> /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.6/2-1.6:1.1/0003:045E:00B4.0003/input/input6
>
> [    2.348647] hid-generic 0003:045E:00B4.0003: input,hidraw2: USB HID
> v1.11 Device [Microsoft Microsoft\xffffffc2\xffffffae\xffffffae Digital
> Media Keyboard] on usb-0000:00:1d.0-1.6/input1
> [    2.382761] ata5: SATA link down (SStatus 0 SControl 300)
> [    2.383139] scsi 6:0:0:0: Direct-Access     ATA ST2000VN000-1H31 SC42
> PQ: 0 ANSI: 5
> [    2.383389] sd 6:0:0:0: Attached scsi generic sg2 type 0
> [    2.383404] sd 6:0:0:0: [sdc] 3907029168 512-byte logical blocks:
> (2.00 TB/1.81 TiB)
> [    2.383405] sd 6:0:0:0: [sdc] 4096-byte physical blocks
> [    2.383634] sd 6:0:0:0: [sdc] Write Protect is off
> [    2.383635] sd 6:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> [    2.383744] sd 6:0:0:0: [sdc] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    2.407023]  sdc: sdc1 sdc2 sdc3 sdc4
> [    2.407886] sd 6:0:0:0: [sdc] Attached SCSI disk
> [    2.418984] usb 2-1.7: new low-speed USB device number 5 using ehci-pci
> [    2.506827] Switched to clocksource tsc
> [    2.608127] usb 2-1.7: New USB device found, idVendor=051d,
> idProduct=0002
> [    2.608200] usb 2-1.7: New USB device strings: Mfr=3, Product=1,
> SerialNumber=2
> [    2.608294] usb 2-1.7: Product: Back-UPS CS 500 FW:808.q8.I USB FW:q8
> [    2.608364] usb 2-1.7: Manufacturer: American Power Conversion
> [    2.608432] usb 2-1.7: SerialNumber: AB0952291626
> [    2.874523] ata8: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [    2.877616] ata8.00: ATAPI: HL-DT-ST DVDRAM GH22NS40, NL02, max UDMA/100
> [    2.881404] ata8.00: configured for UDMA/100
> [    2.889992] scsi 7:0:0:0: CD-ROM            HL-DT-ST DVDRAM GH22NS40
> NL02 PQ: 0 ANSI: 5
> [    2.906305] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw
> xa/form2 cdda tray
> [    2.906414] cdrom: Uniform CD-ROM driver Revision: 3.20
> [    2.906632] sr 7:0:0:0: Attached scsi CD-ROM sr0
> [    2.906741] sr 7:0:0:0: Attached scsi generic sg3 type 5
> [    3.133122] random: nonblocking pool is initialized
> [    4.081736] raid6: sse2x1    9343 MB/s
> [    4.126787] hid-generic 0003:051D:0002.0004: hiddev0,hidraw3: USB HID
> v1.10 Device [American Power Conversion Back-UPS CS 500 FW:808.q8.I USB
> FW:q8] on usb-0000:00:1d.0-1.7/input0
> [    4.149698] raid6: sse2x2   11678 MB/s
> [    4.201837] usb 2-1.8: new full-speed USB device number 6 using ehci-pci
> [    4.217659] raid6: sse2x4   13434 MB/s
> [    4.217721] raid6: using algorithm sse2x4 (13434 MB/s)
> [    4.217787] raid6: using ssse3x2 recovery algorithm
> [    4.218689] xor: automatically using best checksumming function:
> [    4.257635]    avx       : 25698.000 MB/sec
> [    4.264869] bio: create slab <bio-1> at 1
> [    4.265062] Btrfs loaded
> [    4.295174] usb 2-1.8: New USB device found, idVendor=04a9,
> idProduct=2220
> [    4.295258] usb 2-1.8: New USB device strings: Mfr=1, Product=2,
> SerialNumber=0
> [    4.295353] usb 2-1.8: Product: CanoScan
> [    4.295414] usb 2-1.8: Manufacturer: Canon
> [    4.361849] BTRFS: device label Linux devid 1 transid 26704 /dev/sdb1
> [    4.380633] BTRFS: device label Dodatni devid 1 transid 28882 /dev/sdb5
> [    4.610547] PM: Marking nosave pages: [mem 0x0009d000-0x000fffff]
> [    4.610550] PM: Marking nosave pages: [mem 0xdd589000-0xde7c6fff]
> [    4.610594] PM: Marking nosave pages: [mem 0xde7c8000-0xde80afff]
> [    4.610595] PM: Marking nosave pages: [mem 0xdec42000-0xdeff3fff]
> [    4.610604] PM: Marking nosave pages: [mem 0xdf000000-0xffffffff]
> [    4.610835] PM: Basic memory bitmaps created
> [    4.659024] PM: Basic memory bitmaps freed
> [    4.976692] EXT4-fs (sdc4): mounted filesystem with ordered data
> mode. Opts: (null)
> [    7.954891] systemd-udevd[365]: starting version 204
> [    8.871425] lp: driver loaded but no devices found
> [    9.013039] [drm] Initialized drm 1.1.0 20060810
> [    9.950770] nvidia: module license 'NVIDIA' taints kernel.
> [    9.950773] Disabling lock debugging due to kernel taint
> [    9.952886] nvidia: module verification failed: signature and/or
> required key missing - tainting kernel
> [    9.955393] vgaarb: device changed decodes:
> PCI:0000:01:00.0,olddecodes=io+mem,decodes=none:owns=none
> [    9.955506] [drm] Initialized nvidia-drm 0.0.0 20130102 for
> 0000:01:00.0 on minor 0
> [    9.955510] NVRM: loading NVIDIA UNIX x86_64 Kernel Module 331.49 Wed
> Feb 12 20:42:50 PST 2014
> [   10.194881] wmi: Mapper loaded
> [   10.263413] nct6775: Found NCT6779D or compatible chip at 0x2e:0x290
> [   10.288184] ACPI Warning: SystemIO range
> 0x0000000000000428-0x000000000000042f conflicts with OpRegion
> 0x0000000000000400-0x000000000000047f (\PMIO) (20131218/utaddress-258)
> [   10.288188] ACPI: If an ACPI driver is available for this device, you
> should use it instead of the native driver
> [   10.288191] ACPI Warning: SystemIO range
> 0x0000000000000530-0x000000000000053f conflicts with OpRegion
> 0x0000000000000500-0x0000000000000563 (\GPIO) (20131218/utaddress-258)
> [   10.288193] ACPI Warning: SystemIO range
> 0x0000000000000530-0x000000000000053f conflicts with OpRegion
> 0x0000000000000500-0x000000000000057f (\_SB_.PCI0.LPCB.GPBX)
> (20131218/utaddress-258)
> [   10.288195] ACPI: If an ACPI driver is available for this device, you
> should use it instead of the native driver
> [   10.288196] ACPI Warning: SystemIO range
> 0x0000000000000500-0x000000000000052f conflicts with OpRegion
> 0x0000000000000500-0x0000000000000563 (\GPIO) (20131218/utaddress-258)
> [   10.288198] ACPI Warning: SystemIO range
> 0x0000000000000500-0x000000000000052f conflicts with OpRegion
> 0x0000000000000500-0x000000000000057f (\_SB_.PCI0.LPCB.GPBX)
> (20131218/utaddress-258)
> [   10.288200] ACPI: If an ACPI driver is available for this device, you
> should use it instead of the native driver
> [   10.288200] lpc_ich: Resource conflict(s) found affecting gpio_ich
> [   10.362897] mei_me 0000:00:16.0: irq 50 for MSI/MSI-X
> [   10.634144] microcode: CPU0 sig=0x306a9, pf=0x2, revision=0x17
> [   10.681102] device-mapper: multipath: version 1.6.0 loaded
> [   10.687634] microcode: CPU1 sig=0x306a9, pf=0x2, revision=0x17
> [   10.687644] microcode: CPU2 sig=0x306a9, pf=0x2, revision=0x17
> [   10.687652] microcode: CPU3 sig=0x306a9, pf=0x2, revision=0x17
> [   10.687687] microcode: Microcode Update Driver: v2.00
> <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> [   10.837201] WARNING! power/level is deprecated; use power/control
> instead
> [   11.231390] AVX version of gcm_enc/dec engaged.
> [   11.232826] hda-intel 0000:00:1b.0: Applying patch firmware
> 'hda-jack-retask.fw'
> [   11.233051] hda_intel: Disabling MSI
> [   11.233056] hda-intel 0000:01:00.1: Handle VGA-switcheroo audio client
> [   11.233058] hda-intel 0000:01:00.1: Applying patch firmware
> 'hda-jack-retask.fw'
> [   11.284538] snd_hda_intel 0000:00:1b.0: irq 51 for MSI/MSI-X
> [   11.284588] hda-intel 0000:01:00.1: Disabling 64bit DMA
> [   11.287685] hda-intel 0000:01:00.1: Enable delay in RIRB handling
> [   11.297297] SKU: Nid=0x0 sku_cfg=0x0000846b
> [   11.297298] SKU: port_connectivity=0x0
> [   11.297299] SKU: enable_pcbeep=0x1
> [   11.297299] SKU: check_sum=0x00000000
> [   11.297300] SKU: customization=0x00000000
> [   11.297300] SKU: external_amp=0x5
> [   11.297301] SKU: platform_type=0x0
> [   11.297301] SKU: swap=0x1
> [   11.297302] SKU: override=0x1
> [   11.297708] autoconfig: line_outs=4 (0x14/0x15/0x16/0x17/0x0) type:line
> [   11.297709]    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
> [   11.297709]    hp_outs=0 (0x0/0x0/0x0/0x0/0x0)
> [   11.297710]    mono: mono_out=0x0
> [   11.297710]    dig-out=0x11/0x1e
> [   11.297711]    inputs:
> [   11.297712]      Front Mic=0x19
> [   11.297713]      Rear Mic=0x18
> [   11.297714]      Line=0x1a
> [   11.297714] realtek: Enabling init ASM_ID=0x846b CODEC_ID=10ec0899
> [   11.308769] input: HDA Intel PCH Line Out Side as
> /devices/pci0000:00/0000:00:1b.0/sound/card0/input14
> [   11.308829] input: HDA Intel PCH Line Out CLFE as
> /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
> [   11.308865] input: HDA Intel PCH Line Out Surround as
> /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
> [   11.308899] input: HDA Intel PCH Line Out Front as
> /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
> [   11.308932] input: HDA Intel PCH Line as
> /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
> [   11.308965] input: HDA Intel PCH Rear Mic as
> /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
> [   11.309000] input: HDA Intel PCH Front Mic as
> /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
> [   11.812368] Linux video capture interface: v2.00
> [   11.927644] gspca_main: v2.14.0 registered
> [   11.999928] gspca_main: spca561-2.14.0 probing 046d:092c
> [   12.002489] input: spca561 as
> /devices/pci0000:00/0000:00:1c.4/0000:03:00.0/usb5/5-1/input/input15
> [   12.002552] usbcore: registered new interface driver spca561
> [   12.065197] input: HDA NVidia HDMI/DP,pcm=9 as
> /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input19
> [   12.065248] input: HDA NVidia HDMI/DP,pcm=8 as
> /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input18
> [   12.065298] input: HDA NVidia HDMI/DP,pcm=7 as
> /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input17
> [   12.065343] input: HDA NVidia HDMI/DP,pcm=3 as
> /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input16
> [   12.237160] intel_rapl: domain uncore energy ctr 0:0 not working, skip
> [   12.456130] BTRFS: device label Linux devid 1 transid 26704 /dev/sdb1
> [   12.457469] BTRFS: device label Dodatni devid 1 transid 28882 /dev/sdb5
> [   14.857831] EXT4-fs (sdc4): re-mounted. Opts: (null)
> [   14.934461] BTRFS: device label Linux devid 1 transid 26704 /dev/sdb1
> [   14.934883] BTRFS info (device sdb1): enabling auto defrag
> [   14.934885] BTRFS info (device sdb1): disk space caching is enabled
> [   15.808999] BTRFS: device label Dodatni devid 1 transid 28882 /dev/sdb5
> [   15.809631] BTRFS info (device sdb5): enabling auto defrag
> [   15.809634] BTRFS info (device sdb5): disk space caching is enabled
> [   16.976003] EXT4-fs (sdc1): mounted filesystem with ordered data
> mode. Opts: (null)
> [   17.069728] EXT4-fs (sdc2): mounted filesystem with ordered data
> mode. Opts: (null)
> [   17.121125] EXT4-fs (sdc3): mounted filesystem with ordered data
> mode. Opts: (null)
> [   17.512685] Adding 16777212k swap on /media/LinuxNAS/swapfile.
> Priority:-1 extents:20 across:21618684k FS
> [   17.801507] init: failsafe main process (922) killed by TERM signal
> [   21.640364] init: Failed to spawn connman main process: unable to
> execute: No such file or directory
> [   22.233132] init: avahi-cups-reload main process (1000) terminated
> with status 1
> [   22.727019] ppdev: user-space parallel port driver
> [   22.830329] Bluetooth: Core ver 2.18
> [   22.830342] NET: Registered protocol family 31
> [   22.830343] Bluetooth: HCI device and connection manager initialized
> [   22.830348] Bluetooth: HCI socket layer initialized
> [   22.830349] Bluetooth: L2CAP socket layer initialized
> [   22.830355] Bluetooth: SCO socket layer initialized
> [   22.833975] Bluetooth: RFCOMM TTY layer initialized
> [   22.833980] Bluetooth: RFCOMM socket layer initialized
> [   22.833983] Bluetooth: RFCOMM ver 1.11
> [   22.948316] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> [   22.948318] Bluetooth: BNEP filters: protocol multicast
> [   22.948325] Bluetooth: BNEP socket layer initialized
> [   25.936539] e1000e 0000:00:19.0: irq 47 for MSI/MSI-X
> [   26.037060] e1000e 0000:00:19.0: irq 47 for MSI/MSI-X
> [   26.037154] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
> [   26.996128] Ebtables v2.0 registered
> [   27.037559] ip_tables: (C) 2000-2006 Netfilter Core Team
> [   27.048690] ip6_tables: (C) 2000-2006 Netfilter Core Team
> [   27.537972] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow
> Control: Rx/Tx
> [   27.537980] e1000e 0000:00:19.0 eth0: 10/100 speed: disabling TSO
> [   27.538020] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> [   28.513374] postgres (1556): /proc/1556/oom_adj is deprecated, please
> use /proc/1556/oom_score_adj instead.
> [   31.549525] vboxdrv: Found 4 processor cores.
> [   31.550317] vboxdrv: fAsync=0 offMin=0x374 offMax=0x7a5a
> [   31.550423] vboxdrv: TSC mode is 'synchronous', kernel timer mode is
> 'normal'.
> [   31.550425] vboxdrv: Successfully loaded version 4.3.8 (interface
> 0x001a0007).
> [   31.793405] vboxpci: IOMMU not found (not registered)
> [   46.647928] usblp 5-2:1.0: usblp1: USB Bidirectional printer dev 3 if
> 0 alt 0 proto 2 vid 0x03F0 pid 0x002A
> [   46.647968] usbcore: registered new interface driver usblp
> [   46.672277] init: udev-fallback-graphics main process (4105)
> terminated with status 1
> [   48.330900] init: cryptdisks-enable main process (4106) killed by
> TERM signal
> [   48.360407] init: plymouth-splash main process (4314) terminated with
> status 1
> [   51.386738] init: kdm main process (4458) killed by TERM signal
> [   55.413140] nvidia 0000:01:00.0: irq 52 for MSI/MSI-X
>
>>>
>>> Everything is clear most of reserved RAM goes to VGA mapping?
>>>
>>> But, Windows resource monitor and task manager says just around 50MB
>>> hardware reserved?
>>>
>>> So I have tried different kernel boot parameters to no avail.
>>> So question is: Does Windows magically maps VGA to upper addresses
>>> (beyond 16GB)
>>> or simply Windows does not reports all reserved RAM?
>>>
>>> When I disable memory remap in BIOS Windows reports 500MB more reserved,
>>> but Linux adds this 500MB to 300MB reserved giving around 800MB.
>>>
>>> CPU is i5 3570k, motherboard z77, 16GB of DD3 RAM, AMI BIOS.
>>>
>>> Branimir.
>>>
>>
>

