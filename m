Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777Ab3I0RhY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 13:37:24 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.182]:52713 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753324Ab3I0RhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 13:37:19 -0400
X-Greylist: delayed 591 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Sep 2013 13:37:17 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgEFABK/CFEY1KI3/2dsb2JhbABEFr54F3OCHgEBBRoBDC8GEgoBEAsLDQkWDwkDAgECAQ8CFh4GDQEFAgKHegEDDgEMryKBNIYfChknDVmIfIwSdxcFg2UDiw2DfIEigi+BXYFWgRyEUoVLhRKDE4FL
X-IPAS-Result: AgEFABK/CFEY1KI3/2dsb2JhbABEFr54F3OCHgEBBRoBDC8GEgoBEAsLDQkWDwkDAgECAQ8CFh4GDQEFAgKHegEDDgEMryKBNIYfChknDVmIfIwSdxcFg2UDiw2DfIEigi+BXYFWgRyEUoVLhRKDE4FL
X-IronPort-AV: E=Sophos;i="4.84,565,1355115600"; 
   d="log'?scan'208";a="29251774"
Message-ID: <5245C004.7070907@gmail.com>
Date: Fri, 27 Sep 2013 13:27:32 -0400
From: Woody Suwalski <terraluna977@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Firefox/24.0 SeaMonkey/2.21
MIME-Version: 1.0
To: Daniel Vetter <daniel.vetter@ffwll.ch>
CC: intel-gfx <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.12 regression: i915 warnings
References: <52442A3C.3010407@gmail.com> <CAKMK7uFvP7zisHL4UFjRqBX8mxS4DtosF2AFnwZDSdMgnDf4Lw@mail.gmail.com>
In-Reply-To: <CAKMK7uFvP7zisHL4UFjRqBX8mxS4DtosF2AFnwZDSdMgnDf4Lw@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------060100010207040902090104"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060100010207040902090104
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Daniel Vetter wrote:
> On Thu, Sep 26, 2013 at 2:36 PM, Woody Suwalski <terraluna977@gmail.com> wrote:
>> Daniel, I have noticed these warnings on 3.12-rc1, did not go away on
>> 3.12-rc2.
>> I see it only on EeePC with i915,not on ThinkPad with Radeon.
>> It is a 32-bit kernel with overlayfs and TuxOnIce patches, so not perfectly
>> clean, however same config and patches on 3.11 do not show these issues.
>> No,sorry, did not have time to investigate further or bisect.If you have a
>> quick test in mind - I will try ;-)
>
> a) Please always cc: relevant mailing lists, not just your maintainer.
> b) Please retest with latest drm-intel-fixes from
> http://cgit.freedesktop.org/~danvet/drm-intel/
> c) If that doesn't help please boot with drm.debug=0xe, reproduce the
> issue once and attach the complete dmesg. Please make sure that it
> contains everything from boot-up to the WARN.
>
> Thanks, Daniel
For now I can do the last - a complete dmesg with drm.debug attached...
I have hoped that you were to reply "Yawn, an old issue..." 8-)

Woody


--------------060100010207040902090104
Content-Type: text/x-log;
 name="dmesg_3.12_i915.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg_3.12_i915.log"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.12-pingu (root@MINI-b009) (gcc version 4.7.1 (Debian 4.7.1-7) ) #1 SMP PREEMPT Tue Sep 24 19:53:05 EDT 2013
[    0.000000] Atom PSE erratum detected, BIOS microcode update recommended
[    0.000000] Disabled fast string operations
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e2000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000003f79ffff] usable
[    0.000000] BIOS-e820: [mem 0x000000003f7a0000-0x000000003f7adfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000003f7ae000-0x000000003f7effff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000003f7f0000-0x000000003f7fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fff80000-0x00000000ffffffff] reserved
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] SMBIOS 2.5 present.
[    0.000000] DMI: ASUSTeK Computer INC. 903/903, BIOS 0101    05/18/2008
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x3f7a0 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-DFFFF uncachable
[    0.000000]   E0000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask 0C0000000 write-back
[    0.000000]   1 base 03F800000 mask 0FF800000 uncachable
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 1GB, type WB
[    0.000000] reg 1, base: 1016MB, range: 8MB, type UC
[    0.000000] total RAM covered: 1016M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 16M 	num_reg: 2  	lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 1GB, type WB
[    0.000000] reg 1, base: 1016MB, range: 8MB, type UC
[    0.000000] found SMP MP-table at [mem 0x000ff780-0x000ff78f] mapped at [c00ff780]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x01ffffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x37000000-0x373fffff]
[    0.000000]  [mem 0x37000000-0x373fffff] page 4k
[    0.000000] BRK [0x01a58000, 0x01a58fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x30000000-0x36ffffff]
[    0.000000]  [mem 0x30000000-0x36ffffff] page 4k
[    0.000000] BRK [0x01a59000, 0x01a59fff] PGTABLE
[    0.000000] BRK [0x01a5a000, 0x01a5afff] PGTABLE
[    0.000000] BRK [0x01a5b000, 0x01a5bfff] PGTABLE
[    0.000000] BRK [0x01a5c000, 0x01a5cfff] PGTABLE
[    0.000000] BRK [0x01a5d000, 0x01a5dfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x2fffffff]
[    0.000000]  [mem 0x00100000-0x2fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x37400000-0x377fdfff]
[    0.000000]  [mem 0x37400000-0x377fdfff] page 4k
[    0.000000] log_buf_len: 1048576
[    0.000000] early log buf free: 12500(76%)
[    0.000000] RAMDISK: [mem 0x3f61e000-0x3f78ffff]
[    0.000000] Allocated new RAMDISK: [mem 0x3758c000-0x376fd041]
[    0.000000] Move RAMDISK from [mem 0x3f61e000-0x3f78f041] to [mem 0x3758c000-0x376fd041]
[    0.000000] ACPI: RSDP 000fb9e0 00014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 3f7a0000 0003C (v01 A_M_I_ OEMRSDT  05000818 MSFT 00000097)
[    0.000000] ACPI: FACP 3f7a0200 00084 (v02 A_M_I_ OEMFACP  05000818 MSFT 00000097)
[    0.000000] ACPI BIOS Warning (bug): Optional FADT field Pm2ControlBlock has zero address or length: 0x0000000000000820/0x0 (20130725/tbfadt-603)
[    0.000000] ACPI BIOS Warning (bug): Invalid length for FADT/Pm2ControlBlock: 0, using default 8 (20130725/tbfadt-653)
[    0.000000] ACPI: DSDT 3f7a05b0 04DCC (v01  A1054 A1054000 00000000 INTL 20051117)
[    0.000000] ACPI: FACS 3f7ae000 00040
[    0.000000] ACPI: APIC 3f7a0390 0005C (v01 A_M_I_ OEMAPIC  05000818 MSFT 00000097)
[    0.000000] ACPI: MCFG 3f7a03f0 0003C (v01 A_M_I_ OEMMCFG  05000818 MSFT 00000097)
[    0.000000] ACPI: OEMB 3f7ae040 00061 (v01 A_M_I_ AMI_OEM  05000818 MSFT 00000097)
[    0.000000] ACPI: HPET 3f7a5380 00038 (v01 A_M_I_ OEMHPET  05000818 MSFT 00000097)
[    0.000000] ACPI: SSDT 3f7aeb80 004F0 (v01  PmRef    CpuPm 00003000 INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 127MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x377fdfff]
[    0.000000]   HighMem  [mem 0x377fe000-0x3f79ffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x3f79ffff]
[    0.000000] On node 0 totalpages: 259902
[    0.000000] free_area_init_node: node 0, pgdat c19b0b80, node_mem_map f6b40020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 223230 pages, LIFO batch:31
[    0.000000]   HighMem zone: 256 pages used for memmap
[    0.000000]   HighMem zone: 32674 pages, LIFO batch:7
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0xffffffff base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000e1fff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e2000-0x000fffff]
[    0.000000] e820: [mem 0x40000000-0xfedfffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 12 pages/cpu @f756d000 s26752 r0 d22400 u49152
[    0.000000] pcpu-alloc: s26752 r0 d22400 u49152 alloc=12*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 258126
[    0.000000] Kernel command line: BUILDNAME=PINGU PINGULIVE=y drm.debug=0xe log_buf_len=1M
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (000377fe:0003f7a0)
[    0.000000] Memory: 1016548K/1039608K available (6571K kernel code, 393K rwdata, 2968K rodata, 392K init, 196K bss, 23060K reserved, 130696K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff66000 - 0xfffff000   ( 612 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc19b6000 - 0xc1a18000   ( 392 kB)
[    0.000000]       .data : 0xc166b170 - 0xc19b5480   (3368 kB)
[    0.000000]       .text : 0xc1000000 - 0xc166b170   (6572 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=4 to nr_cpu_ids=2.
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=f6408000 soft=f640a000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 1595.932 MHz processor
[    0.004006] Calibrating delay loop (skipped), value calculated using timer frequency.. 3191.86 BogoMIPS (lpj=6383728)
[    0.004160] pid_max: default: 32768 minimum: 301
[    0.004319] Mount-cache hash table entries: 512
[    0.004844] Initializing cgroup subsys devices
[    0.004927] Initializing cgroup subsys freezer
[    0.005003] Initializing cgroup subsys perf_event
[    0.005107] Atom PSE erratum detected, BIOS microcode update recommended
[    0.005187] Disabled fast string operations
[    0.005267] CPU: Physical Processor ID: 0
[    0.005340] CPU: Processor Core ID: 0
[    0.005414] mce: CPU supports 5 MCE banks
[    0.005500] CPU0: Thermal monitoring enabled (TM2)
[    0.008036] Last level iTLB entries: 4KB 32, 2MB 0, 4MB 0
[    0.008036] Last level dTLB entries: 4KB 64, 2MB 0, 4MB 8
[    0.008036] tlb_flushall_shift: 6
[    0.008372] Freeing SMP alternatives memory: 24K (c1a18000 - c1a1e000)
[    0.008455] ACPI: Core revision 20130725
[    0.015112] ACPI: All ACPI Tables successfully acquired
[    0.016145] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.020430] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.060204] smpboot: CPU0: Intel(R) Atom(TM) CPU N270   @ 1.60GHz (fam: 06, model: 1c, stepping: 02)
[    0.064000] Performance Events: PEBS fmt0+, LBR disabled due to erratumAtom events, Intel PMU driver.
[    0.064000] ... version:                3
[    0.064000] ... bit width:              40
[    0.064000] ... generic registers:      2
[    0.064000] ... value mask:             000000ffffffffff
[    0.064000] ... max period:             000000007fffffff
[    0.064000] ... fixed-purpose events:   3
[    0.064000] ... event mask:             0000000700000003
[    0.084143] CPU 1 irqstacks, hard=f647e000 soft=f6488000
[    0.084151] smpboot: Booting Node   0, Processors  #   1 OK
[    0.008000] Initializing CPU#1
[    0.008000] Atom PSE erratum detected, BIOS microcode update recommended
[    0.008000] Disabled fast string operations
[    0.096099] Brought up 2 CPUs
[    0.096403] smpboot: Total of 2 processors activated (6383.72 BogoMIPS)
[    0.097018] devtmpfs: initialized
[    0.097018] PM: Registering ACPI NVS region [mem 0x3f7ae000-0x3f7effff] (270336 bytes)
[    0.097018] xor: measuring software checksum speed
[    0.134678]    pIII_sse  :  4941.000 MB/sec
[    0.174677]    prefetch64-sse:  5505.000 MB/sec
[    0.174756] xor: using function: prefetch64-sse (5505.000 MB/sec)
[    0.174955] NET: Registered protocol family 16
[    0.176097] cpuidle: using governor ladder
[    0.176115] cpuidle: using governor menu
[    0.176274] ACPI: bus type PCI registered
[    0.176377] dca service started, version 1.12.1
[    0.176377] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.176377] PCI: not using MMCONFIG
[    0.176574] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=5
[    0.176653] PCI: Using configuration type 1 for base access
[    0.192214] bio: create slab <bio-0> at 0
[    0.260687] raid6: mmxx1      355 MB/s
[    0.328095] raid6: mmxx2      721 MB/s
[    0.396056] raid6: sse1x1     293 MB/s
[    0.464045] raid6: sse1x2     546 MB/s
[    0.532031] raid6: sse2x1     583 MB/s
[    0.600060] raid6: sse2x2    1081 MB/s
[    0.600134] raid6: using algorithm sse2x2 (1081 MB/s)
[    0.600210] raid6: using ssse3x1 recovery algorithm
[    0.600371] ACPI: Added _OSI(Module Device)
[    0.600371] ACPI: Added _OSI(Processor Device)
[    0.600371] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.600371] ACPI: Added _OSI(Processor Aggregator Device)
[    0.601697] ACPI: EC: Look up EC in DSDT
[    0.604037] ACPI: Executed 1 blocks of module-level executable AML code
[    0.608676] ACPI: SSDT 3f7ae180 0023C (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
[    0.609440] ACPI: Dynamic OEM Table Load:
[    0.609605] ACPI: SSDT   (null) 0023C (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
[    0.610092] ACPI: SSDT 3f7ae450 00724 (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    0.616448] ACPI: Dynamic OEM Table Load:
[    0.616611] ACPI: SSDT   (null) 00724 (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    0.617300] ACPI: SSDT 3f7ae0b0 000CC (v01  PmRef  Cpu1Ist 00003000 INTL 20051117)
[    0.618037] ACPI: Dynamic OEM Table Load:
[    0.618201] ACPI: SSDT   (null) 000CC (v01  PmRef  Cpu1Ist 00003000 INTL 20051117)
[    0.619657] ACPI: SSDT 3f7ae3c0 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20051117)
[    0.620378] ACPI: Dynamic OEM Table Load:
[    0.620543] ACPI: SSDT   (null) 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20051117)
[    0.621353] ACPI: Interpreter enabled
[    0.621448] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130725/hwxface-571)
[    0.621646] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130725/hwxface-571)
[    0.621867] ACPI: (supports S0 S3 S4 S5)
[    0.621942] ACPI: Using IOAPIC for interrupt routing
[    0.622078] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.625753] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    0.625862] PCI: MMCONFIG for 0000 [bus00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000) (size reduced!)
[    0.625967] PCI: Using MMCONFIG for extended config space
[    0.626081] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.626081] ACPI: No dock devices found.
[    0.644314] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.644314] acpi PNP0A08:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.644396] acpi PNP0A08:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.644777] acpi PNP0A08:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.644984] PCI host bridge to bus 0000:00
[    0.644984] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.644984] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.644984] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.644984] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.644984] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000dffff]
[    0.644984] pci_bus 0000:00: root bus resource [mem 0x3f800000-0xffffffff]
[    0.644984] pci 0000:00:00.0: [8086:27ac] type 00 class 0x060000
[    0.644984] pci 0000:00:02.0: [8086:27ae] type 00 class 0x030000
[    0.644984] pci 0000:00:02.0: reg 0x10: [mem 0xf7e00000-0xf7e7ffff]
[    0.644984] pci 0000:00:02.0: reg 0x14: [io  0xdc00-0xdc07]
[    0.644984] pci 0000:00:02.0: reg 0x18: [mem 0xd0000000-0xdfffffff pref]
[    0.644984] pci 0000:00:02.0: reg 0x1c: [mem 0xf7dc0000-0xf7dfffff]
[    0.644984] pci 0000:00:02.1: [8086:27a6] type 00 class 0x038000
[    0.644984] pci 0000:00:02.1: reg 0x10: [mem 0xf7e80000-0xf7efffff]
[    0.644984] pci 0000:00:1b.0: [8086:27d8] type 00 class 0x040300
[    0.644984] pci 0000:00:1b.0: reg 0x10: [mem 0xf7db8000-0xf7dbbfff 64bit]
[    0.644984] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.644984] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.648062] pci 0000:00:1c.0: [8086:27d0] type 01 class 0x060400
[    0.648189] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.648320] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.648487] pci 0000:00:1c.1: [8086:27d2] type 01 class 0x060400
[    0.648487] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.648487] pci 0000:00:1c.1: System wakeup disabled by ACPI
[    0.648487] pci 0000:00:1c.3: [8086:27d6] type 01 class 0x060400
[    0.648490] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.648625] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    0.648805] pci 0000:00:1d.0: [8086:27c8] type 00 class 0x0c0300
[    0.648805] pci 0000:00:1d.0: reg 0x20: [io  0xd400-0xd41f]
[    0.648805] pci 0000:00:1d.1: [8086:27c9] type 00 class 0x0c0300
[    0.648805] pci 0000:00:1d.1: reg 0x20: [io  0xd480-0xd49f]
[    0.648805] pci 0000:00:1d.2: [8086:27ca] type 00 class 0x0c0300
[    0.648805] pci 0000:00:1d.2: reg 0x20: [io  0xd800-0xd81f]
[    0.648805] pci 0000:00:1d.3: [8086:27cb] type 00 class 0x0c0300
[    0.648805] pci 0000:00:1d.3: reg 0x20: [io  0xd880-0xd89f]
[    0.648805] pci 0000:00:1d.7: [8086:27cc] type 00 class 0x0c0320
[    0.648805] pci 0000:00:1d.7: reg 0x10: [mem 0xf7db7c00-0xf7db7fff]
[    0.648805] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.652031] pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
[    0.652230] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    0.652398] pci 0000:00:1f.0: [8086:27b9] type 00 class 0x060100
[    0.652398] pci 0000:00:1f.0: address space collision: [io  0x0800-0x087f] conflicts with ACPI CPU throttle [??? 0x00000810-0x00000815 flags 0x80000000]
[    0.652398] pci 0000:00:1f.0: quirk: [io  0x0480-0x04bf] claimed by ICH6 GPIO
[    0.652398] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0380 (mask 0003)
[    0.652496] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0290 (mask 0007)
[    0.652600] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0068 (mask 0003)
[    0.652600] pci 0000:00:1f.2: [8086:27c4] type 00 class 0x010180
[    0.652600] pci 0000:00:1f.2: reg 0x10: [io  0x0000-0x0007]
[    0.652600] pci 0000:00:1f.2: reg 0x14: [io  0x0000-0x0003]
[    0.652600] pci 0000:00:1f.2: reg 0x18: [io  0x0000-0x0007]
[    0.652600] pci 0000:00:1f.2: reg 0x1c: [io  0x0000-0x0003]
[    0.652600] pci 0000:00:1f.2: reg 0x20: [io  0xffa0-0xffaf]
[    0.652600] pci 0000:00:1f.2: PME# supported from D3hot
[    0.652600] pci 0000:00:1c.0: PCI bridge to [bus 04]
[    0.652600] pci 0000:02:00.0: [168c:001c] type 00 class 0x020000
[    0.652600] pci 0000:02:00.0: reg 0x10: [mem 0xfbff0000-0xfbffffff 64bit]
[    0.652600] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.652600] pci 0000:00:1c.1: PCI bridge to [bus 02-03]
[    0.652600] pci 0000:00:1c.1:   bridge window [mem 0xf8000000-0xfbffffff]
[    0.652600] pci 0000:00:1c.1:   bridge window [mem 0xf0000000-0xf6ffffff 64bit pref]
[    0.652600] pci 0000:01:00.0: [1969:1026] type 00 class 0x020000
[    0.652600] pci 0000:01:00.0: reg 0x10: [mem 0xf7fc0000-0xf7ffffff 64bit]
[    0.652600] pci 0000:01:00.0: reg 0x18: [io  0xec00-0xec7f]
[    0.652600] pci 0000:01:00.0: PME# supported from D3hot D3cold
[    0.652600] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.652600] pci 0000:00:1c.3: PCI bridge to [bus 01]
[    0.652600] pci 0000:00:1c.3:   bridge window [io  0xe000-0xefff]
[    0.652600] pci 0000:00:1c.3:   bridge window [mem 0xf7f00000-0xf7ffffff]
[    0.652600] pci 0000:00:1e.0: PCI bridge to [bus 05] (subtractive decode)
[    0.652600] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.652600] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.652600] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.652600] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
[    0.652600] pci 0000:00:1e.0:   bridge window [mem 0x3f800000-0xffffffff] (subtractive decode)
[    0.652600] pci_bus 0000:00: on NUMA node 0
[    0.653246] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.656639] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.657400] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[    0.658161] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.658929] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.659794] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.660719] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.661586] ACPI: PCI Interrupt Link [LNKH] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.662477] ACPI: \_SB_.PCI0: notify handler is installed
[    0.664031] Found 1 acpi root devices
[    0.664031] ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
[    0.664096] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.664155] vgaarb: loaded
[    0.664226] vgaarb: bridge control possible 0000:00:02.0
[    0.664472] SCSI subsystem initialized
[    0.664472] libata version 3.00 loaded.
[    0.664472] wmi: Mapper loaded
[    0.664472] PCI: Using ACPI for IRQ routing
[    0.664472] PCI: pci_cache_line_size set to 64 bytes
[    0.664472] Expanded resource reserved due to conflict with PCI Bus 0000:00
[    0.664472] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.664472] e820: reserve RAM buffer [mem 0x3f7a0000-0x3fffffff]
[    0.664494] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.664494] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.664526] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.670070] Switched to clocksource hpet
[    0.670070] pnp: PnP ACPI init
[    0.670070] ACPI: bus type PNP registered
[    0.670070] system 00:00: [mem 0xfed13000-0xfed19fff] has been reserved
[    0.670070] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.670070] pnp 00:01: [dma 4]
[    0.670070] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.670070] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.670070] pnp 00:03: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    0.670070] pnp 00:04: Plug and Play ACPI device, IDs SYN0a04 SYN0a00 SYN0002 PNP0f13 (active)
[    0.670070] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.670070] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.670404] system 00:07: [io  0x025c-0x025f] has been reserved
[    0.670493] system 00:07: [io  0x0380-0x0383] has been reserved
[    0.670575] system 00:07: [io  0x0400-0x041f] has been reserved
[    0.670657] system 00:07: [io  0x04d0-0x04d1] has been reserved
[    0.670739] system 00:07: [io  0x0800-0x087f] could not be reserved
[    0.670822] system 00:07: [io  0x0480-0x04bf] has been reserved
[    0.670905] system 00:07: [mem 0x8c000000-0x8c01ffff] has been reserved
[    0.670988] system 00:07: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.671072] system 00:07: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.671168] system 00:07: [mem 0xfed50000-0xfed8ffff] has been reserved
[    0.671252] system 00:07: [mem 0xffb00000-0xffbfffff] has been reserved
[    0.671334] system 00:07: [mem 0xfff00000-0xffffffff] could not be reserved
[    0.671420] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.671721] pnp 00:08: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.672038] system 00:09: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.672133] system 00:09: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.672220] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.672484] system 00:0a: [mem 0xe0000000-0xe3ffffff] has been reserved
[    0.672573] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.673171] system 00:0b: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.673260] system 00:0b: [mem 0x000c0000-0x000cffff] could not be reserved
[    0.673345] system 00:0b: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.673429] system 00:0b: [mem 0x00100000-0x3f7fffff] could not be reserved
[    0.673516] system 00:0b: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.673877] pnp: PnP ACPI: found 12 devices
[    0.673954] ACPI: bus type PNP unregistered
[    0.719991] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus 04] add_size 1000
[    0.720006] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 04] add_size 200000
[    0.720032] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff] to [bus 04] add_size 200000
[    0.720055] pci 0000:00:1c.1: bridge window [io  0x1000-0x0fff] to [bus 02-03] add_size 1000
[    0.720075] pci 0000:00:1c.3: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 01] add_size 200000
[    0.720100] pci 0000:00:1f.0: BAR 7: [io  0x0800-0x087f] has bogus alignment
[    0.720193] pci 0000:00:1c.0: res[8]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[    0.720200] pci 0000:00:1c.0: res[9]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.720208] pci 0000:00:1c.3: res[9]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.720214] pci 0000:00:1c.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.720221] pci 0000:00:1c.1: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.720236] pci 0000:00:1c.0: BAR 8: assigned [mem 0x40000000-0x401fffff]
[    0.720322] pci 0000:00:1c.0: BAR 9: assigned [mem 0x40200000-0x403fffff 64bit pref]
[    0.720427] pci 0000:00:1c.3: BAR 9: assigned [mem 0x40400000-0x405fffff 64bit pref]
[    0.720534] pci 0000:00:1c.0: BAR 7: assigned [io  0x1000-0x1fff]
[    0.720616] pci 0000:00:1c.1: BAR 7: assigned [io  0x2000-0x2fff]
[    0.720698] pci 0000:00:1c.0: PCI bridge to [bus 04]
[    0.720779] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    0.720864] pci 0000:00:1c.0:   bridge window [mem 0x40000000-0x401fffff]
[    0.720949] pci 0000:00:1c.0:   bridge window [mem 0x40200000-0x403fffff 64bit pref]
[    0.721057] pci 0000:00:1c.1: PCI bridge to [bus 02-03]
[    0.721137] pci 0000:00:1c.1:   bridge window [io  0x2000-0x2fff]
[    0.721223] pci 0000:00:1c.1:   bridge window [mem 0xf8000000-0xfbffffff]
[    0.721309] pci 0000:00:1c.1:   bridge window [mem 0xf0000000-0xf6ffffff 64bit pref]
[    0.721418] pci 0000:00:1c.3: PCI bridge to [bus 01]
[    0.721497] pci 0000:00:1c.3:   bridge window [io  0xe000-0xefff]
[    0.721583] pci 0000:00:1c.3:   bridge window [mem 0xf7f00000-0xf7ffffff]
[    0.721669] pci 0000:00:1c.3:   bridge window [mem 0x40400000-0x405fffff 64bit pref]
[    0.721777] pci 0000:00:1e.0: PCI bridge to [bus 05]
[    0.721871] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.721877] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.721883] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.721890] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    0.721896] pci_bus 0000:00: resource 8 [mem 0x3f800000-0xffffffff]
[    0.721902] pci_bus 0000:04: resource 0 [io  0x1000-0x1fff]
[    0.721908] pci_bus 0000:04: resource 1 [mem 0x40000000-0x401fffff]
[    0.721915] pci_bus 0000:04: resource 2 [mem 0x40200000-0x403fffff 64bit pref]
[    0.721921] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.721927] pci_bus 0000:02: resource 1 [mem 0xf8000000-0xfbffffff]
[    0.721934] pci_bus 0000:02: resource 2 [mem 0xf0000000-0xf6ffffff 64bit pref]
[    0.721940] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.721946] pci_bus 0000:01: resource 1 [mem 0xf7f00000-0xf7ffffff]
[    0.721952] pci_bus 0000:01: resource 2 [mem 0x40400000-0x405fffff 64bit pref]
[    0.721959] pci_bus 0000:05: resource 4 [io  0x0000-0x0cf7]
[    0.721965] pci_bus 0000:05: resource 5 [io  0x0d00-0xffff]
[    0.721971] pci_bus 0000:05: resource 6 [mem 0x000a0000-0x000bffff]
[    0.721977] pci_bus 0000:05: resource 7 [mem 0x000d0000-0x000dffff]
[    0.721983] pci_bus 0000:05: resource 8 [mem 0x3f800000-0xffffffff]
[    0.722066] NET: Registered protocol family 2
[    0.722450] TCP established hash table entries: 8192 (order: 4, 65536 bytes)
[    0.722594] TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
[    0.722729] TCP: Hash tables configured (established 8192 bind 8192)
[    0.722863] TCP: reno registered
[    0.722942] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.723036] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.723246] NET: Registered protocol family 1
[    0.723359] pci 0000:00:02.0: Boot video device
[    0.724667] PCI: CLS 32 bytes, default 64
[    0.724791] Trying to unpack rootfs image as initramfs...
[    1.292804] Freeing initrd memory: 1480K (f758c000 - f76fe000)
[    1.293466] Scanning for low memory corruption every 60 seconds
[    1.295574] bounce pool size: 64 pages
[    1.305505] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    1.305625] fuse init (API version 7.22)
[    1.306566] bio: create slab <bio-1> at 1
[    1.307575] Btrfs loaded
[    1.307679] msgmni has been set to 1733
[    1.308717] io scheduler noop registered
[    1.309115] io scheduler cfq registered (default)
[    1.309436] pcieport 0000:00:1c.0: enabling device (0104 -> 0107)
[    1.309731] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    1.309956] pcieport 0000:00:1c.1: enabling device (0106 -> 0107)
[    1.310199] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
[    1.310553] pcieport 0000:00:1c.3: irq 42 for MSI/MSI-X
[    1.311340] intel_idle: MWAIT substates: 0x20220
[    1.311357] intel_idle: v0.4 model 0x1C
[    1.311362] intel_idle: lapic_timer_reliable_states 0x2
[    1.311367] tsc: Marking TSC unstable due to TSC halts in idle states deeper than C2
[    1.311881] ACPI: AC Adapter [AC0] (off-line)
[    1.312435] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    1.317399] ACPI: Lid Switch [LID]
[    1.317739] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    1.317850] ACPI: Sleep Button [SLPB]
[    1.318130] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
[    1.318238] ACPI: Power Button [PWRB]
[    1.318504] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    1.318612] ACPI: Power Button [PWRF]
[    1.319146] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
[    1.319459] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input4
[    1.320327] GHES: HEST is not enabled!
[    1.320412] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    1.407440] Linux agpgart interface v0.103
[    1.408426] agpgart-intel 0000:00:00.0: Intel 945GME Chipset
[    1.408600] agpgart-intel 0000:00:00.0: detected gtt size: 262144K total, 262144K mappable
[    1.408850] agpgart-intel 0000:00:00.0: detected 8192K stolen memory
[    1.409321] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    1.410100] [drm] Initialized drm 1.1.0 20060810
[    1.410352] [drm] radeon kernel modesetting enabled.
[    1.411510] [drm:i915_dump_device_info], i915 device info: gen=3, pciid=0x27ae flags=is_mobile,is_i945gm,has_hotplug,cursor_needs_physical,has_overlay,overlay_needs_physical,supports_tv,
[    1.411612] [drm] Memory usable by graphics device = 256M
[    1.412846] [drm:i915_gem_gtt_init], GMADR size = 256M
[    1.412854] [drm:i915_gem_gtt_init], GTT stolen size = 8M
[    1.412873] i915 0000:00:02.0: setting latency timer to 64
[    1.412908] [drm:intel_detect_pch], No PCH found?
[    1.414025] [drm:intel_opregion_setup], graphic opregion physical addr: 0x0
[    1.414035] [drm:intel_opregion_setup], ACPI OpRegion not supported!
[    1.414074] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    1.414158] [drm] Driver supports precise vblank timestamp query.
[    1.414238] [drm:init_vbt_defaults], Set default to SSC at 100MHz
[    1.414703] [drm:parse_general_features], BDB_GENERAL_FEATURES int_tv_support 1 int_crt_support 1 lvds_use_ssc 1 lvds_ssc_freq 100 display_clock_mode 0 fdi_rx_polarity_inverted 0
[    1.414712] [drm:parse_general_definitions], crt_ddc_bus_pin: 2
[    1.414748] [drm:parse_lfp_panel_data], Found panel mode in BIOS VBT tables:
[    1.414752] [drm:drm_mode_debug_printmodeline], Modeline 0:"1024x600" 0 49180 1024 1044 1054 1344 600 602 605 625 0x8 0xa
[    1.414790] [drm:parse_sdvo_panel_data], Found SDVO panel mode in BIOS VBT tables:
[    1.414794] [drm:drm_mode_debug_printmodeline], Modeline 0:"1600x1200" 0 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x8 0xa
[    1.414805] [drm:parse_sdvo_device_mapping], No SDVO device info is found in VBT
[    1.414839] [drm:intel_dsm_pci_probe], no _DSM method for intel device
[    1.414857] [drm:i915_gem_init_stolen], found 8388608 bytes of stolen memory at 3f800000
[    1.414924] [drm:intel_modeset_init], 2 display pipes available.
[    1.414939] [drm:intel_crtc_init], swapping pipes & planes for FBC
[    1.414944] [drm:intel_modeset_init], pipe A sprite A init failed: -19
[    1.414957] [drm:intel_crtc_init], swapping pipes & planes for FBC
[    1.414961] [drm:intel_modeset_init], pipe B sprite B init failed: -19
[    1.414966] [drm:intel_shared_dpll_init], 0 shared PLLs initialized
[    1.414977] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    1.416062] [drm:gmbus_xfer], GMBUS [i915 gmbus panel] NAK for addr: 0050 r(1)
[    1.416071] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus panel
[    1.416077] [drm:intel_lvds_init], using mode from VBT: 
[    1.416081] [drm:drm_mode_debug_printmodeline], Modeline 0:"1024x600" 0 49180 1024 1044 1054 1344 600 602 605 625 0x8 0xa
[    1.416172] [drm:intel_lvds_init], detected single-link lvds configuration
[    1.416436] [drm:intel_panel_get_backlight], get backlight PWM = 140
[    1.416444] [drm:intel_panel_get_max_backlight], max backlight PWM = 140
[    1.417065] [drm:i915_gem_setup_global_gtt], clearing unused GTT space: [0, ffff000]
[    1.417831] [drm:i915_gem_object_create_stolen], creating stolen object: size=20000
[    1.417839] [drm:i915_pages_create_for_stolen], offset=0x0, size=131072
[    1.417896] [drm:i915_gem_context_init], Disabling HW Contexts; old hardware
[    1.417987] [drm] initialized overlay support
[    1.418069] [drm:intel_modeset_readout_hw_state], [CRTC:3] hw state readout: disabled
[    1.418082] [drm:intel_modeset_readout_hw_state], [CRTC:4] hw state readout: enabled
[    1.418089] [drm:intel_modeset_readout_hw_state], [ENCODER:6:LVDS-6] hw state readout: enabled, pipe=1
[    1.418095] [drm:intel_modeset_readout_hw_state], [ENCODER:10:DAC-10] hw state readout: disabled, pipe=0
[    1.418102] [drm:intel_modeset_readout_hw_state], [ENCODER:12:TV-12] hw state readout: disabled, pipe=0
[    1.418110] [drm:intel_modeset_readout_hw_state], [CONNECTOR:5:LVDS-1] hw state readout: enabled
[    1.418116] [drm:intel_modeset_readout_hw_state], [CONNECTOR:9:VGA-1] hw state readout: disabled
[    1.418122] [drm:intel_modeset_readout_hw_state], [CONNECTOR:11:SVIDEO-1] hw state readout: disabled
[    1.418130] [drm:intel_dump_pipe_config], [CRTC:3][setup_hw_state] config for pipe A
[    1.418135] [drm:intel_dump_pipe_config], cpu_transcoder: A
[    1.418139] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
[    1.418144] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    1.418149] [drm:intel_dump_pipe_config], requested mode:
[    1.418154] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[    1.418161] [drm:intel_dump_pipe_config], adjusted mode:
[    1.418165] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[    1.418172] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    1.418177] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[    1.418182] [drm:intel_dump_pipe_config], ips: 0
[    1.418187] [drm:intel_dump_pipe_config], [CRTC:4][setup_hw_state] config for pipe B
[    1.418192] [drm:intel_dump_pipe_config], cpu_transcoder: B
[    1.418196] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
[    1.418200] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    1.418206] [drm:intel_dump_pipe_config], requested mode:
[    1.418210] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 640 0 0 0 400 0 0 0 0x0 0x0
[    1.418217] [drm:intel_dump_pipe_config], adjusted mode:
[    1.418221] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 47238 0 0 0 0 0 0 0 0 0x0 0xa
[    1.418228] [drm:intel_dump_pipe_config], gmch pfit: control: 0x80002668, ratios: 0x00000000, lvds border: 0x00000000
[    1.418233] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[    1.418238] [drm:intel_dump_pipe_config], ips: 0
[    1.418244] [drm:intel_connector_check_state], [CONNECTOR:5:LVDS-1]
[    1.418250] [drm:check_encoder_state], [ENCODER:6:LVDS-6]
[    1.418255] [drm:check_encoder_state], [ENCODER:10:DAC-10]
[    1.418261] [drm:check_encoder_state], [ENCODER:12:TV-12]
[    1.418266] [drm:check_crtc_state], [CRTC:3]
[    1.418272] [drm:check_crtc_state], [CRTC:4]
[    1.418298] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[    1.418303] [drm:intel_lvds_detect], [CONNECTOR:5:LVDS-1]
[    1.418313] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
[    1.418318] [drm:drm_mode_debug_printmodeline], Modeline 26:"1024x600" 59 49180 1024 1044 1054 1344 600 602 605 625 0x8 0xa
[    1.418327] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[    1.418332] [drm:intel_crt_detect], [CONNECTOR:9:VGA-1] force=1
[    1.436178] [drm:intel_crt_detect], CRT not detected via hotplug
[    1.440113] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[    1.440138] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    1.440149] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[    1.440157] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[    1.440465] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    1.440470] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[    1.440476] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    1.440483] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[    1.440491] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:11:SVIDEO-1]
[    1.440497] [drm:intel_tv_detect], [CONNECTOR:11:SVIDEO-1] force=1
[    1.440504] [drm:intel_get_load_detect_pipe], [CONNECTOR:11:SVIDEO-1], [ENCODER:12:TV-12]
[    1.440510] [drm:intel_get_load_detect_pipe], creating tmp fb for load-detection
[    1.440539] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 1, prepare: 1, disable: 0
[    1.440548] [drm:connected_sink_compute_bpp], [CONNECTOR:11:SVIDEO-1] checking for sink bpp constrains
[    1.440555] [drm:intel_tv_compute_config], forcing bpc to 8 for TV
[    1.440559] [drm:intel_modeset_pipe_config], plane bpp: 24, pipe bpp: 24, dithering: 0
[    1.440565] [drm:intel_dump_pipe_config], [CRTC:3][modeset] config for pipe A
[    1.440570] [drm:intel_dump_pipe_config], cpu_transcoder: A
[    1.440574] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[    1.440578] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    1.440584] [drm:intel_dump_pipe_config], requested mode:
[    1.440588] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[    1.440596] [drm:intel_dump_pipe_config], adjusted mode:
[    1.440600] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 108000 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0xa
[    1.440608] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    1.440613] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[    1.440618] [drm:intel_dump_pipe_config], ips: 0
[    1.450793] [drm:i9xx_update_plane], Writing base 00020000 00000000 0 0 5120
[    1.450809] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    1.450816] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    1.450821] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 29
[    1.450826] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 29, C: 2, SR 1
[    1.450832] [drm:i9xx_update_wm], memory self refresh disabled
[    1.450839] [drm:intel_crtc_mode_set], [ENCODER:12:TV-12] set [MODE:0:NTSC 480i]
[    1.455852] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    1.455859] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    1.455865] [drm:intel_calculate_wm], FIFO entries required for mode: 34
[    1.455869] [drm:intel_calculate_wm], FIFO watermark level: -5
[    1.455874] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 1
[    1.455878] [drm:i9xx_update_wm], self-refresh entries: 80
[    1.455883] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 1, C: 2, SR 47
[    1.455888] [drm:i9xx_update_wm], memory self refresh enabled
[    1.475169] ACPI: Battery Slot [BAT0] (battery present)
[    1.480056] [drm:intel_connector_check_state], [CONNECTOR:5:LVDS-1]
[    1.480069] [drm:intel_connector_check_state], [CONNECTOR:11:SVIDEO-1]
[    1.480075] [drm:check_encoder_state], [ENCODER:6:LVDS-6]
[    1.480081] [drm:check_encoder_state], [ENCODER:10:DAC-10]
[    1.480087] [drm:check_encoder_state], [ENCODER:12:TV-12]
[    1.480093] [drm:check_crtc_state], [CRTC:3]
[    1.480109] [drm:intel_pipe_config_compare] *ERROR* mismatch in adjusted_mode.flags(DRM_MODE_FLAG_NHSYNC) (expected 2, found 0)
[    1.480220] ------------[ cut here ]------------
[    1.480305] WARNING: CPU: 1 PID: 1 at drivers/gpu/drm/i915/intel_display.c:8769 check_crtc_state+0x5f8/0xbe0()
[    1.480409] pipe state doesn't match!
[    1.480481] Modules linked in:
[    1.480602] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.12-pingu #1
[    1.480680] Hardware name: ASUSTeK Computer INC. 903/903, BIOS 0101    05/18/2008
[    1.480778]  00000009 c1663e65 f64517c0 c1038e15 c18e08e9 f64517d8 00000001 c1901e08
[    1.481232]  00002241 c1468a98 c1468a98 f64b9000 f64b964c 00000002 f661e678 c1038ed3
[    1.481687]  00000009 f64517c0 c18e08e9 f64517d8 c1468a98 c1901e08 00002241 c18e08e9
[    1.482140] Call Trace:
[    1.482218]  [<c1663e65>] ? dump_stack+0x48/0x6f
[    1.482298]  [<c1038e15>] ? warn_slowpath_common+0x85/0xb0
[    1.482378]  [<c1468a98>] ? check_crtc_state+0x5f8/0xbe0
[    1.482457]  [<c1468a98>] ? check_crtc_state+0x5f8/0xbe0
[    1.482537]  [<c1038ed3>] ? warn_slowpath_fmt+0x33/0x40
[    1.482617]  [<c1468a98>] ? check_crtc_state+0x5f8/0xbe0
[    1.482703]  [<c1473d3b>] ? intel_modeset_check_state+0x28b/0x780
[    1.482786]  [<c1474260>] ? intel_set_mode+0x30/0x40
[    1.482865]  [<c14755bf>] ? intel_get_load_detect_pipe+0x22f/0x3b0
[    1.482949]  [<c1497303>] ? intel_tv_detect+0x133/0x4e0
[    1.483031]  [<c1081f01>] ? log_store+0x111/0x260
[    1.483114]  [<c134d9f8>] ? drm_helper_probe_single_connector_modes+0x288/0x340
[    1.483215]  [<c134b64c>] ? drm_fb_helper_probe_connector_modes.isra.7+0x3c/0x60
[    1.483317]  [<c134c2ea>] ? drm_fb_helper_initial_config+0x16a/0x4a0
[    1.483399]  [<c135ba13>] ? drm_mode_config_reset+0x93/0xb0
[    1.483479]  [<c147713c>] ? intel_modeset_setup_hw_state+0x8ec/0xb60
[    1.483562]  [<c14a17cd>] ? i915_write32+0x7d/0xe0
[    1.483641]  [<c144c14d>] ? intel_hpd_init+0xad/0xc0
[    1.483721]  [<c144550f>] ? i915_driver_load+0xf3f/0xf80
[    1.483800]  [<c1442c80>] ? i915_switcheroo_set_state+0xa0/0xa0
[    1.483883]  [<c154c0eb>] ? device_add+0x15b/0x670
[    1.483965]  [<c13591ea>] ? drm_get_pci_dev+0x10a/0x2c0
[    1.484084]  [<c12c894d>] ? pci_device_probe+0x7d/0xc0
[    1.484171]  [<c154ea50>] ? driver_probe_device+0x1e0/0x1e0
[    1.484251]  [<c154e8c4>] ? driver_probe_device+0x54/0x1e0
[    1.484331]  [<c12c801f>] ? pci_match_device+0x8f/0xa0
[    1.484410]  [<c154eac9>] ? __driver_attach+0x79/0x80
[    1.484488]  [<c154d088>] ? bus_for_each_dev+0x38/0x70
[    1.484569]  [<c154e4e6>] ? driver_attach+0x16/0x20
[    1.484647]  [<c154ea50>] ? driver_probe_device+0x1e0/0x1e0
[    1.484726]  [<c154e09c>] ? bus_add_driver+0xcc/0x250
[    1.484805]  [<c154f021>] ? driver_register+0x51/0xd0
[    1.484886]  [<c19d981a>] ? radeon_init+0xb0/0xb0
[    1.484963]  [<c19d981a>] ? radeon_init+0xb0/0xb0
[    1.485041]  [<c100042a>] ? do_one_initcall+0xda/0x120
[    1.485123]  [<c104fe61>] ? parameq+0x11/0x70
[    1.485201]  [<c19b64a2>] ? do_early_param+0x77/0x77
[    1.485279]  [<c19b6400>] ? rdinit_setup+0x1e/0x1e
[    1.485357]  [<c19b64a2>] ? do_early_param+0x77/0x77
[    1.485436]  [<c10500ce>] ? parse_args+0x20e/0x350
[    1.485515]  [<c19b6aaa>] ? kernel_init_freeable+0x111/0x1ae
[    1.485596]  [<c19b64a2>] ? do_early_param+0x77/0x77
[    1.485674]  [<c165c9a8>] ? kernel_init+0x8/0xc0
[    1.485752]  [<c1669fa2>] ? ret_from_kernel_thread+0x6/0x28
[    1.485832]  [<c1669fb7>] ? ret_from_kernel_thread+0x1b/0x28
[    1.485912]  [<c165c9a0>] ? rest_init+0x70/0x70
[    1.485997] ---[ end trace 247144411d041a1c ]---
[    1.486073] [drm:intel_dump_pipe_config], [CRTC:3][hw state] config for pipe A
[    1.486078] [drm:intel_dump_pipe_config], cpu_transcoder: A
[    1.486082] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
[    1.486087] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    1.486093] [drm:intel_dump_pipe_config], requested mode:
[    1.486097] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 1280 0 0 0 1024 0 0 0 0x0 0x0
[    1.486105] [drm:intel_dump_pipe_config], adjusted mode:
[    1.486109] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 108000 0 0 0 0 0 0 0 0 0x0 0x0
[    1.486116] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    1.486121] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[    1.486126] [drm:intel_dump_pipe_config], ips: 0
[    1.486130] [drm:intel_dump_pipe_config], [CRTC:3][sw state] config for pipe A
[    1.486135] [drm:intel_dump_pipe_config], cpu_transcoder: A
[    1.486138] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[    1.486143] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    1.486148] [drm:intel_dump_pipe_config], requested mode:
[    1.486152] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[    1.486160] [drm:intel_dump_pipe_config], adjusted mode:
[    1.486164] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 108000 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0xa
[    1.486172] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    1.486177] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[    1.486181] [drm:intel_dump_pipe_config], ips: 0
[    1.486186] [drm:check_crtc_state], [CRTC:4]
[    1.516148] [drm:intel_tv_detect_type], TV detected: c0017, 7f0000aa
[    1.516167] [drm:intel_tv_detect_type], Unrecognised TV connection
[    1.532171] [drm:intel_release_load_detect_pipe], [CONNECTOR:11:SVIDEO-1], [ENCODER:12:TV-12]
[    1.532194] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 0, prepare: 0, disable: 1
[    1.572972] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    1.572984] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    1.572989] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 29
[    1.572994] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 29, C: 2, SR 1
[    1.573000] [drm:i9xx_update_wm], memory self refresh disabled
[    1.573015] [drm:intel_connector_check_state], [CONNECTOR:5:LVDS-1]
[    1.573023] [drm:check_encoder_state], [ENCODER:6:LVDS-6]
[    1.573028] [drm:check_encoder_state], [ENCODER:10:DAC-10]
[    1.573034] [drm:check_encoder_state], [ENCODER:12:TV-12]
[    1.573039] [drm:check_crtc_state], [CRTC:3]
[    1.573046] [drm:i9xx_crtc_clock_get], Unknown DPLL mode 00000000 in programmed mode
[    1.573051] [drm:check_crtc_state], [CRTC:4]
[    1.574209] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:11:SVIDEO-1] disconnected
[    1.574218] [drm:drm_setup_crtcs], 
[    1.574224] [drm:drm_enable_connectors], connector 5 enabled? yes
[    1.574229] [drm:drm_enable_connectors], connector 9 enabled? no
[    1.574233] [drm:drm_enable_connectors], connector 11 enabled? no
[    1.574238] [drm:drm_target_preferred], looking for cmdline mode on connector 5
[    1.574243] [drm:drm_target_preferred], looking for preferred mode on connector 5
[    1.574248] [drm:drm_target_preferred], found mode 1024x600
[    1.574252] [drm:drm_setup_crtcs], picking CRTCs for 4096x4096 config
[    1.574259] [drm:drm_setup_crtcs], desired mode 1024x600 set on crtc 4
[    1.574268] [drm:i915_gem_object_create_stolen], creating stolen object: size=258000
[    1.574275] [drm:i915_pages_create_for_stolen], offset=0x20000, size=2457600
[    1.576998] [drm:intelfb_create], allocated 1024x600 fb: 0x00020000, bo f5c43300
[    1.577293] fbcon: inteldrmfb (fb0) is primary device
[    1.578309] [drm:intel_crtc_set_config], [CRTC:3] [NOFB]
[    1.578315] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[    1.578321] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:4]
[    1.578327] [drm:intel_crtc_set_config], [CRTC:4] [FB:28] #connectors=1 (x y) (0 0)
[    1.578330] [drm:intel_set_config_compute_mode_changes], inactive crtc, full mode set
[    1.578333] [drm:intel_set_config_compute_mode_changes], modes are different, full mode set
[    1.578340] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[    1.578347] [drm:drm_mode_debug_printmodeline], Modeline 27:"1024x600" 59 49180 1024 1044 1054 1344 600 602 605 625 0x8 0xa
[    1.578350] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:4], mode_changed=1, fb_changed=0
[    1.578354] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:4]
[    1.578359] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 2, prepare: 2, disable: 0
[    1.578366] [drm:connected_sink_compute_bpp], [CONNECTOR:5:LVDS-1] checking for sink bpp constrains
[    1.578372] [drm:intel_lvds_compute_config], forcing display bpp (was 24) to LVDS (18)
[    1.578377] [drm:intel_modeset_pipe_config], plane bpp: 24, pipe bpp: 18, dithering: 1
[    1.578381] [drm:intel_dump_pipe_config], [CRTC:4][modeset] config for pipe B
[    1.578383] [drm:intel_dump_pipe_config], cpu_transcoder: B
[    1.578386] [drm:intel_dump_pipe_config], pipe bpp: 18, dithering: 1
[    1.578390] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    1.578392] [drm:intel_dump_pipe_config], requested mode:
[    1.578399] [drm:drm_mode_debug_printmodeline], Modeline 0:"1024x600" 59 49180 1024 1044 1054 1344 600 602 605 625 0x8 0xa
[    1.578401] [drm:intel_dump_pipe_config], adjusted mode:
[    1.578407] [drm:drm_mode_debug_printmodeline], Modeline 0:"1024x600" 0 49180 1024 1044 1054 1344 600 602 605 625 0x8 0xa
[    1.578411] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000008, ratios: 0x00000000, lvds border: 0x00000000
[    1.578415] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[    1.578417] [drm:intel_dump_pipe_config], ips: 0
[    1.578422] [drm:intel_panel_actually_set_backlight], set backlight PWM = 0
[    1.852059] [drm:i9xx_pfit_disable], disabling pfit, current: 0x80002668
[    1.852067] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    1.852071] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    1.852074] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 29
[    1.852078] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 29, C: 2, SR 1
[    1.852081] [drm:i9xx_update_wm], memory self refresh disabled
[    1.852090] [drm:i9xx_get_refclk], using SSC reference clock of 100 MHz
[    1.852320] [drm:i9xx_update_plane], Writing base 00020000 00000000 0 0 4096
[    1.852326] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    1.852329] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    1.852332] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 29
[    1.852336] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 29, C: 2, SR 1
[    1.852339] [drm:i9xx_update_wm], memory self refresh disabled
[    1.852345] [drm:intel_crtc_mode_set], [ENCODER:6:LVDS-6] set [MODE:0:1024x600]
[    1.852349] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    1.852352] [drm:intel_calculate_wm], FIFO entries required for mode: 16
[    1.852355] [drm:intel_calculate_wm], FIFO watermark level: 10
[    1.852358] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    1.852361] [drm:i9xx_update_wm], FIFO watermarks - A: 10, B: 29
[    1.852364] [drm:i9xx_update_wm], self-refresh entries: 64
[    1.852368] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 10, B: 29, C: 2, SR 63
[    1.852371] [drm:i9xx_update_wm], memory self refresh enabled
[    2.236181] [drm:intel_panel_actually_set_backlight], set backlight PWM = 140
[    2.236203] [drm:intel_connector_check_state], [CONNECTOR:5:LVDS-1]
[    2.236215] [drm:check_encoder_state], [ENCODER:6:LVDS-6]
[    2.236223] [drm:check_encoder_state], [ENCODER:10:DAC-10]
[    2.236231] [drm:check_encoder_state], [ENCODER:12:TV-12]
[    2.236238] [drm:check_crtc_state], [CRTC:3]
[    2.236249] [drm:i9xx_crtc_clock_get], Unknown DPLL mode 00000000 in programmed mode
[    2.236254] [drm:check_crtc_state], [CRTC:4]
[    2.236351] [drm:intel_crtc_set_config], [CRTC:4] [FB:28] #connectors=1 (x y) (0 0)
[    2.236362] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:4], mode_changed=0, fb_changed=0
[    2.236371] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:4]
[    2.244221] [drm:intel_crtc_set_config], [CRTC:4] [FB:28] #connectors=1 (x y) (0 0)
[    2.244226] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:4], mode_changed=0, fb_changed=0
[    2.244230] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:4]
[    2.251834] Console: switching to colour frame buffer device 128x37
[    2.251846] [drm:intel_crtc_set_config], [CRTC:4] [FB:28] #connectors=1 (x y) (0 0)
[    2.251850] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:4], mode_changed=0, fb_changed=0
[    2.251854] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:4]
[    2.260138] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    2.260271] i915 0000:00:02.0: registered panic notifier
[    2.260403] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    2.266982] brd: module loaded
[    2.270334] loop: module loaded
[    2.271022] ata_piix 0000:00:1f.2: version 2.13
[    2.271200] ata_piix 0000:00:1f.2: MAP [
[    2.271291]  P0 P2 IDE IDE ]
[    2.271450] ata_piix 0000:00:1f.2: setting latency timer to 64
[    2.274516] scsi0 : ata_piix
[    2.274925] scsi1 : ata_piix
[    2.275245] ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[    2.275388] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[    2.278343] tun: Universal TUN/TAP device driver, 1.6
[    2.280739] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    2.283710] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    2.321640] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.324180] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.327205] mousedev: PS/2 mouse device common for all mice
[    2.331010] rtc_cmos 00:02: RTC can wake from S4
[    2.333872] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    2.336450] rtc_cmos 00:02: alarms up to one month, 114 bytes nvram, hpet irqs
[    2.339322] hidraw: raw HID events driver (C) Jiri Kosina
[    2.343207] TCP: cubic registered
[    2.345897] NET: Registered protocol family 17
[    2.348591] Key type dns_resolver registered
[    2.352139] Using IPI No-Shortcut mode
[    2.354790] TuxOnIce 3.3 (http://tuxonice.net)
[    2.358171] TuxOnIce: Ignoring late initcall, as requested.
[    2.361708] rtc_cmos 00:02: setting system clock to 2013-09-27 17:20:02 UTC (1380302402)
[    2.364751] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
[    2.452577] ata2.00: CFA: ASUS-PHISON SSD, TST2.04P, max UDMA/66
[    2.455559] ata2.00: 15761088 sectors, multi 0: LBA 
[    2.464443] ata2.00: configured for UDMA/66
[    2.468096] scsi 1:0:0:0: Direct-Access     ATA      ASUS-PHISON SSD  TST2 PQ: 0 ANSI: 5
[    2.473936] sd 1:0:0:0: [sda] 15761088 512-byte logical blocks: (8.06 GB/7.51 GiB)
[    2.477166] sd 1:0:0:0: [sda] Write Protect is off
[    2.480445] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.480510] sd 1:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.487329]  sda: sda1 sda2
[    2.493639] sd 1:0:0:0: [sda] Attached SCSI disk
[    2.497014] Freeing unused kernel memory: 392K (c19b6000 - c1a18000)
[    2.501563] fastinit: initramfs starting
[    2.529891] ACPI: bus type USB registered
[    2.530165] usbcore: registered new interface driver usbfs
[    2.530286] usbcore: registered new interface driver hub
[    2.530481] usbcore: registered new device driver usb
[    2.535711] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.536946] ehci-pci: EHCI PCI platform driver
[    2.537179] ehci-pci 0000:00:1d.7: setting latency timer to 64
[    2.537199] ehci-pci 0000:00:1d.7: EHCI Host Controller
[    2.537214] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    2.537241] ehci-pci 0000:00:1d.7: debug port 1
[    2.541171] ehci-pci 0000:00:1d.7: cache line size of 32 is not supported
[    2.541218] ehci-pci 0000:00:1d.7: irq 23, io mem 0xf7db7c00
[    2.552143] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    2.552357] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.552371] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.552383] usb usb1: Product: EHCI Host Controller
[    2.552394] usb usb1: Manufacturer: Linux 3.12-pingu ehci_hcd
[    2.552404] usb usb1: SerialNumber: 0000:00:1d.7
[    2.554479] hub 1-0:1.0: USB hub found
[    2.554522] hub 1-0:1.0: 8 ports detected
[    2.556680] uhci_hcd: USB Universal Host Controller Interface driver
[    2.556907] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.556916] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.556933] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    2.556982] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000d400
[    2.557247] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    2.557255] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.557261] usb usb2: Product: UHCI Host Controller
[    2.557266] usb usb2: Manufacturer: Linux 3.12-pingu uhci_hcd
[    2.557272] usb usb2: SerialNumber: 0000:00:1d.0
[    2.557758] hub 2-0:1.0: USB hub found
[    2.557794] hub 2-0:1.0: 2 ports detected
[    2.558225] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    2.558234] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.558248] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    2.558320] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000d480
[    2.558543] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    2.558551] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.558557] usb usb3: Product: UHCI Host Controller
[    2.558562] usb usb3: Manufacturer: Linux 3.12-pingu uhci_hcd
[    2.558567] usb usb3: SerialNumber: 0000:00:1d.1
[    2.559042] hub 3-0:1.0: USB hub found
[    2.559076] hub 3-0:1.0: 2 ports detected
[    2.559558] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    2.559568] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.559591] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    2.559675] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000d800
[    2.559863] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    2.559872] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.559880] usb usb4: Product: UHCI Host Controller
[    2.559887] usb usb4: Manufacturer: Linux 3.12-pingu uhci_hcd
[    2.559894] usb usb4: SerialNumber: 0000:00:1d.2
[    2.562155] hub 4-0:1.0: USB hub found
[    2.562197] hub 4-0:1.0: 2 ports detected
[    2.562620] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    2.562630] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    2.562644] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    2.562694] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000d880
[    2.562919] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    2.562927] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.562932] usb usb5: Product: UHCI Host Controller
[    2.562938] usb usb5: Manufacturer: Linux 3.12-pingu uhci_hcd
[    2.562943] usb usb5: SerialNumber: 0000:00:1d.3
[    2.563409] hub 5-0:1.0: USB hub found
[    2.563445] hub 5-0:1.0: 2 ports detected
[    2.565193] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.567001] usbcore: registered new interface driver usbhid
[    2.567009] usbhid: USB HID core driver
[    2.574208] usbcore: registered new interface driver usb-storage
[    2.575702] usbcore: registered new interface driver ums-alauda
[    2.578165] usbcore: registered new interface driver ums-cypress
[    2.579408] usbcore: registered new interface driver ums-datafab
[    2.580671] usbcore: registered new interface driver ums-freecom
[    2.581933] usbcore: registered new interface driver ums-isd200
[    2.584429] usbcore: registered new interface driver ums-jumpshot
[    2.585705] usbcore: registered new interface driver ums-karma
[    2.587011] usbcore: registered new interface driver ums-onetouch
[    2.589587] usbcore: registered new interface driver ums-sddr09
[    2.590856] usbcore: registered new interface driver ums-sddr55
[    2.592191] usbcore: registered new interface driver ums-usbat
[    2.868095] usb 1-2: new high-speed USB device number 2 using ehci-pci
[    3.029408] usb 1-2: New USB device found, idVendor=093a, idProduct=2700
[    3.029419] usb 1-2: New USB device strings: Mfr=16, Product=96, SerialNumber=0
[    3.029426] usb 1-2: Product: Digital_Camera
[    3.029431] usb 1-2: Manufacturer: PixArt Imaging Inc.
[    3.148084] usb 1-6: new high-speed USB device number 3 using ehci-pci
[    3.306549] usb 1-6: New USB device found, idVendor=090c, idProduct=1000
[    3.306563] usb 1-6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    3.306572] usb 1-6: Product: USB DISK
[    3.306580] usb 1-6: Manufacturer: SMI Corporation
[    3.306588] usb 1-6: SerialNumber: AA00000000000137
[    3.307229] usb-storage 1-6:1.0: USB Mass Storage device detected
[    3.307372] scsi2 : usb-storage 1-6:1.0
[    3.534267] psmouse serio1: elantech: assuming hardware version 1 (with firmware version 0x020022)
[    3.608755] psmouse serio1: elantech: Synaptics capabilities query result 0x10, 0x02, 0x64.
[    4.132780] input: ETPS/2 Elantech Touchpad as /devices/platform/i8042/serio1/input/input6
[    4.627369] scsi 2:0:0:0: Direct-Access     SMI      USB DISK         1100 PQ: 0 ANSI: 0 CCS
[    4.628953] sd 2:0:0:0: [sdb] 7913472 512-byte logical blocks: (4.05 GB/3.77 GiB)
[    4.629815] sd 2:0:0:0: [sdb] Write Protect is off
[    4.629828] sd 2:0:0:0: [sdb] Mode Sense: 43 00 00 00
[    4.630688] sd 2:0:0:0: [sdb] No Caching mode page found
[    4.630699] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[    4.634441] sd 2:0:0:0: [sdb] No Caching mode page found
[    4.634452] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[    4.635762]  sdb: sdb1
[    4.639065] sd 2:0:0:0: [sdb] No Caching mode page found
[    4.639077] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[    4.639090] sd 2:0:0:0: [sdb] Attached SCSI removable disk
[    4.846004] fastinit: live starting
[    5.998230] fastinit: live squashfs mounted
[    6.004437] fastinit: live user mounted
[    6.006179] fastinit: live overlayfs/aufs mounted
[    6.206707] fastinit: system start
[    8.618023] [drm:intel_crtc_set_config], [CRTC:4] [FB:28] #connectors=1 (x y) (0 0)
[    8.618034] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:4], mode_changed=0, fb_changed=0
[    8.618042] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:4]
[    8.653674] [drm:i915_driver_open], 
[    8.653830] [drm:intel_crtc_cursor_set], cursor off
[    8.653841] [drm:intel_crtc_set_config], [CRTC:3] [NOFB]
[    8.653853] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[    8.653864] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:4]
[    8.653874] [drm:intel_crtc_cursor_set], cursor off
[    8.653881] [drm:intel_crtc_set_config], [CRTC:4] [FB:28] #connectors=1 (x y) (0 0)
[    8.653891] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:4], mode_changed=0, fb_changed=0
[    8.653900] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:4]
[    8.654007] [drm:i915_driver_open], 
[    8.656698] [drm:drm_mode_getresources], CRTC[2] CONNECTORS[3] ENCODERS[3]
[    8.656719] [drm:drm_mode_getresources], CRTC[2] CONNECTORS[3] ENCODERS[3]
[    8.656905] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[    8.656918] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[    8.656927] [drm:intel_lvds_detect], [CONNECTOR:5:LVDS-1]
[    8.656945] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
[    8.656954] [drm:drm_mode_debug_printmodeline], Modeline 26:"1024x600" 59 49180 1024 1044 1054 1344 600 602 605 625 0x8 0xa
[    8.656974] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[    8.657396] [drm:intel_panel_get_backlight], get backlight PWM = 140
[    8.657462] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[    8.657474] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[    8.657481] [drm:intel_crt_detect], [CONNECTOR:9:VGA-1] force=1
[    8.672096] [drm:intel_crt_detect], CRT not detected via hotplug
[    8.676134] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[    8.676150] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    8.676158] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[    8.676165] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[    8.676462] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    8.676470] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[    8.676477] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    8.676487] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[    8.676512] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[    8.676522] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[    8.676529] [drm:intel_crt_detect], [CONNECTOR:9:VGA-1] force=1
[    8.692068] [drm:intel_crt_detect], CRT not detected via hotplug
[    8.696064] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[    8.696078] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    8.696086] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[    8.696092] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[    8.696392] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    8.696401] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[    8.696409] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    8.696419] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[    8.696564] [drm:drm_mode_getconnector], [CONNECTOR:11:?]
[    8.696577] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:11:SVIDEO-1]
[    8.696585] [drm:intel_tv_detect], [CONNECTOR:11:SVIDEO-1] force=1
[    8.696596] [drm:intel_get_load_detect_pipe], [CONNECTOR:11:SVIDEO-1], [ENCODER:12:TV-12]
[    8.696605] [drm:intel_get_load_detect_pipe], creating tmp fb for load-detection
[    8.696636] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 1, prepare: 1, disable: 0
[    8.696653] [drm:connected_sink_compute_bpp], [CONNECTOR:11:SVIDEO-1] checking for sink bpp constrains
[    8.696663] [drm:intel_tv_compute_config], forcing bpc to 8 for TV
[    8.696669] [drm:intel_modeset_pipe_config], plane bpp: 24, pipe bpp: 24, dithering: 0
[    8.696677] [drm:intel_dump_pipe_config], [CRTC:3][modeset] config for pipe A
[    8.696684] [drm:intel_dump_pipe_config], cpu_transcoder: A
[    8.696690] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[    8.696697] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    8.696705] [drm:intel_dump_pipe_config], requested mode:
[    8.696712] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[    8.696725] [drm:intel_dump_pipe_config], adjusted mode:
[    8.696730] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 108000 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0xa
[    8.696742] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    8.696750] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[    8.696757] [drm:intel_dump_pipe_config], ips: 0
[    8.708202] [drm:i9xx_update_plane], Writing base 00280000 00000000 0 0 5120
[    8.708223] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    8.708233] [drm:intel_calculate_wm], FIFO entries required for mode: 16
[    8.708239] [drm:intel_calculate_wm], FIFO watermark level: 10
[    8.708246] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    8.708254] [drm:i9xx_update_wm], FIFO watermarks - A: 10, B: 29
[    8.708262] [drm:i9xx_update_wm], self-refresh entries: 64
[    8.708268] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 10, B: 29, C: 2, SR 63
[    8.708277] [drm:i9xx_update_wm], memory self refresh enabled
[    8.708286] [drm:intel_crtc_mode_set], [ENCODER:12:TV-12] set [MODE:0:NTSC 480i]
[    8.713314] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    8.713327] [drm:intel_calculate_wm], FIFO entries required for mode: 16
[    8.713333] [drm:intel_calculate_wm], FIFO watermark level: 10
[    8.713340] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    8.713348] [drm:intel_calculate_wm], FIFO entries required for mode: 34
[    8.713354] [drm:intel_calculate_wm], FIFO watermark level: -5
[    8.713360] [drm:i9xx_update_wm], FIFO watermarks - A: 10, B: 1
[    8.713367] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 10, B: 1, C: 2, SR 1
[    8.713376] [drm:i9xx_update_wm], memory self refresh disabled
[    8.736767] [drm:intel_connector_check_state], [CONNECTOR:5:LVDS-1]
[    8.736785] [drm:intel_connector_check_state], [CONNECTOR:11:SVIDEO-1]
[    8.736794] [drm:check_encoder_state], [ENCODER:6:LVDS-6]
[    8.736802] [drm:check_encoder_state], [ENCODER:10:DAC-10]
[    8.736809] [drm:check_encoder_state], [ENCODER:12:TV-12]
[    8.736817] [drm:check_crtc_state], [CRTC:3]
[    8.736839] [drm:intel_pipe_config_compare] *ERROR* mismatch in adjusted_mode.flags(DRM_MODE_FLAG_NHSYNC) (expected 2, found 0)
[    8.736847] ------------[ cut here ]------------
[    8.736864] WARNING: CPU: 0 PID: 1616 at drivers/gpu/drm/i915/intel_display.c:8769 check_crtc_state+0x5f8/0xbe0()
[    8.736870] pipe state doesn't match!
[    8.736874] Modules linked in: ata_generic sata_vsc sata_sil24 pata_mpiix pata_oldpiix nls_iso8859_1 nls_cp850 vfat fat ums_usbat ums_sddr55 ums_sddr09 ums_onetouch ums_karma ums_jumpshot ums_isd200 ums_freecom ums_datafab ums_cypress ums_alauda usb_storage isofs sr_mod cdrom usbhid ohci_hcd uhci_hcd ehci_pci ehci_hcd xhci_hcd usbcore usb_common
[    8.736949] CPU: 0 PID: 1616 Comm: Xorg Tainted: G        W    3.12-pingu #1
[    8.736956] Hardware name: ASUSTeK Computer INC. 903/903, BIOS 0101    05/18/2008
[    8.736963]  00000009 c1663e65 f498f8f8 c1038e15 c18e08e9 f498f910 00000650 c1901e08
[    8.736980]  00002241 c1468a98 c1468a98 f64b9000 f64b964c 00000002 f661e678 c1038ed3
[    8.736997]  00000009 f498f8f8 c18e08e9 f498f910 c1468a98 c1901e08 00002241 c18e08e9
[    8.737014] Call Trace:
[    8.737030]  [<c1663e65>] ? dump_stack+0x48/0x6f
[    8.737044]  [<c1038e15>] ? warn_slowpath_common+0x85/0xb0
[    8.737057]  [<c1468a98>] ? check_crtc_state+0x5f8/0xbe0
[    8.737068]  [<c1468a98>] ? check_crtc_state+0x5f8/0xbe0
[    8.737080]  [<c1038ed3>] ? warn_slowpath_fmt+0x33/0x40
[    8.737091]  [<c1468a98>] ? check_crtc_state+0x5f8/0xbe0
[    8.737113]  [<c1473d3b>] ? intel_modeset_check_state+0x28b/0x780
[    8.737125]  [<c1474260>] ? intel_set_mode+0x30/0x40
[    8.737136]  [<c14755bf>] ? intel_get_load_detect_pipe+0x22f/0x3b0
[    8.737150]  [<c1497303>] ? intel_tv_detect+0x133/0x4e0
[    8.737162]  [<c1081f01>] ? log_store+0x111/0x260
[    8.737179]  [<c134d9f8>] ? drm_helper_probe_single_connector_modes+0x288/0x340
[    8.737192]  [<c135ecda>] ? drm_mode_getconnector+0x31a/0x370
[    8.737206]  [<c10b9a4b>] ? find_lock_page+0x1b/0x70
[    8.737218]  [<c135e9c0>] ? drm_mode_getcrtc+0xb0/0xb0
[    8.737229]  [<c13521b6>] ? drm_ioctl+0x426/0x4b0
[    8.737240]  [<c135e9c0>] ? drm_mode_getcrtc+0xb0/0xb0
[    8.737252]  [<c10bae26>] ? generic_file_aio_write+0x86/0xb0
[    8.737263]  [<c1351d90>] ? drm_copy_field+0x70/0x70
[    8.737275]  [<c10fc237>] ? do_vfs_ioctl+0x77/0x560
[    8.737288]  [<c10ee879>] ? __sb_end_write+0x29/0x60
[    8.737300]  [<c10ed1f5>] ? vfs_write+0x165/0x1a0
[    8.737311]  [<c10fc76b>] ? SyS_ioctl+0x4b/0x80
[    8.737323]  [<c16698bc>] ? syscall_call+0x7/0xb
[    8.737336]  [<c1660000>] ? refill_pi_state_cache.part.14+0x4b/0x4c
[    8.737344] ---[ end trace 247144411d041a1e ]---
[    8.737350] [drm:intel_dump_pipe_config], [CRTC:3][hw state] config for pipe A
[    8.737359] [drm:intel_dump_pipe_config], cpu_transcoder: A
[    8.737365] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
[    8.737372] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    8.737381] [drm:intel_dump_pipe_config], requested mode:
[    8.737387] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 1280 0 0 0 1024 0 0 0 0x0 0x0
[    8.737399] [drm:intel_dump_pipe_config], adjusted mode:
[    8.737405] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 108000 0 0 0 0 0 0 0 0 0x0 0x0
[    8.737417] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    8.737425] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[    8.737432] [drm:intel_dump_pipe_config], ips: 0
[    8.737439] [drm:intel_dump_pipe_config], [CRTC:3][sw state] config for pipe A
[    8.737446] [drm:intel_dump_pipe_config], cpu_transcoder: A
[    8.737452] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[    8.737459] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    8.737468] [drm:intel_dump_pipe_config], requested mode:
[    8.737474] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[    8.737486] [drm:intel_dump_pipe_config], adjusted mode:
[    8.737492] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 108000 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0xa
[    8.737503] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    8.737511] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[    8.737518] [drm:intel_dump_pipe_config], ips: 0
[    8.737524] [drm:check_crtc_state], [CRTC:4]
[    8.784114] [drm:intel_tv_detect_type], TV detected: c0017, 7f0000aa
[    8.784129] [drm:intel_tv_detect_type], Unrecognised TV connection
[    8.820121] [drm:intel_release_load_detect_pipe], [CONNECTOR:11:SVIDEO-1], [ENCODER:12:TV-12]
[    8.820151] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 0, prepare: 0, disable: 1
[    8.860993] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    8.861006] [drm:intel_calculate_wm], FIFO entries required for mode: 16
[    8.861010] [drm:intel_calculate_wm], FIFO watermark level: 10
[    8.861015] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    8.861020] [drm:i9xx_update_wm], FIFO watermarks - A: 10, B: 29
[    8.861025] [drm:i9xx_update_wm], self-refresh entries: 64
[    8.861029] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 10, B: 29, C: 2, SR 63
[    8.861035] [drm:i9xx_update_wm], memory self refresh enabled
[    8.861051] [drm:intel_connector_check_state], [CONNECTOR:5:LVDS-1]
[    8.861058] [drm:check_encoder_state], [ENCODER:6:LVDS-6]
[    8.861064] [drm:check_encoder_state], [ENCODER:10:DAC-10]
[    8.861070] [drm:check_encoder_state], [ENCODER:12:TV-12]
[    8.861075] [drm:check_crtc_state], [CRTC:3]
[    8.861082] [drm:i9xx_crtc_clock_get], Unknown DPLL mode 00000000 in programmed mode
[    8.861086] [drm:check_crtc_state], [CRTC:4]
[    8.861199] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:11:SVIDEO-1] disconnected
[    8.862252] [drm:drm_mode_getconnector], [CONNECTOR:11:?]
[    8.862260] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:11:SVIDEO-1]
[    8.862265] [drm:intel_tv_detect], [CONNECTOR:11:SVIDEO-1] force=1
[    8.862272] [drm:intel_get_load_detect_pipe], [CONNECTOR:11:SVIDEO-1], [ENCODER:12:TV-12]
[    8.862277] [drm:intel_get_load_detect_pipe], creating tmp fb for load-detection
[    8.862299] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 1, prepare: 1, disable: 0
[    8.862309] [drm:connected_sink_compute_bpp], [CONNECTOR:11:SVIDEO-1] checking for sink bpp constrains
[    8.862315] [drm:intel_tv_compute_config], forcing bpc to 8 for TV
[    8.862319] [drm:intel_modeset_pipe_config], plane bpp: 24, pipe bpp: 24, dithering: 0
[    8.862325] [drm:intel_dump_pipe_config], [CRTC:3][modeset] config for pipe A
[    8.862330] [drm:intel_dump_pipe_config], cpu_transcoder: A
[    8.862334] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[    8.862338] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    8.862344] [drm:intel_dump_pipe_config], requested mode:
[    8.862348] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[    8.862356] [drm:intel_dump_pipe_config], adjusted mode:
[    8.862360] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 108000 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0xa
[    8.862368] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    8.862373] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[    8.862378] [drm:intel_dump_pipe_config], ips: 0
[    8.872537] [drm:i9xx_update_plane], Writing base 00280000 00000000 0 0 5120
[    8.872554] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    8.872561] [drm:intel_calculate_wm], FIFO entries required for mode: 16
[    8.872565] [drm:intel_calculate_wm], FIFO watermark level: 10
[    8.872570] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    8.872575] [drm:i9xx_update_wm], FIFO watermarks - A: 10, B: 29
[    8.872580] [drm:i9xx_update_wm], self-refresh entries: 64
[    8.872584] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 10, B: 29, C: 2, SR 63
[    8.872590] [drm:i9xx_update_wm], memory self refresh enabled
[    8.872597] [drm:intel_crtc_mode_set], [ENCODER:12:TV-12] set [MODE:0:NTSC 480i]
[    8.877609] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    8.877615] [drm:intel_calculate_wm], FIFO entries required for mode: 16
[    8.877619] [drm:intel_calculate_wm], FIFO watermark level: 10
[    8.877624] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    8.877629] [drm:intel_calculate_wm], FIFO entries required for mode: 34
[    8.877633] [drm:intel_calculate_wm], FIFO watermark level: -5
[    8.877637] [drm:i9xx_update_wm], FIFO watermarks - A: 10, B: 1
[    8.877642] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 10, B: 1, C: 2, SR 1
[    8.877647] [drm:i9xx_update_wm], memory self refresh disabled
[    8.900202] [drm:intel_connector_check_state], [CONNECTOR:5:LVDS-1]
[    8.900222] [drm:intel_connector_check_state], [CONNECTOR:11:SVIDEO-1]
[    8.900234] [drm:check_encoder_state], [ENCODER:6:LVDS-6]
[    8.900245] [drm:check_encoder_state], [ENCODER:10:DAC-10]
[    8.900256] [drm:check_encoder_state], [ENCODER:12:TV-12]
[    8.900267] [drm:check_crtc_state], [CRTC:3]
[    8.900291] [drm:intel_pipe_config_compare] *ERROR* mismatch in adjusted_mode.flags(DRM_MODE_FLAG_NHSYNC) (expected 2, found 0)
[    8.900300] ------------[ cut here ]------------
[    8.900323] WARNING: CPU: 1 PID: 1616 at drivers/gpu/drm/i915/intel_display.c:8769 check_crtc_state+0x5f8/0xbe0()
[    8.900330] pipe state doesn't match!
[    8.900336] Modules linked in: ata_generic sata_vsc sata_sil24 pata_mpiix pata_oldpiix nls_iso8859_1 nls_cp850 vfat fat ums_usbat ums_sddr55 ums_sddr09 ums_onetouch ums_karma ums_jumpshot ums_isd200 ums_freecom ums_datafab ums_cypress ums_alauda usb_storage isofs sr_mod cdrom usbhid ohci_hcd uhci_hcd ehci_pci ehci_hcd xhci_hcd usbcore usb_common
[    8.900434] CPU: 1 PID: 1616 Comm: Xorg Tainted: G        W    3.12-pingu #1
[    8.900442] Hardware name: ASUSTeK Computer INC. 903/903, BIOS 0101    05/18/2008
[    8.900450]  00000009 c1663e65 f498f8f8 c1038e15 c18e08e9 f498f910 00000650 c1901e08
[    8.900472]  00002241 c1468a98 c1468a98 f64b9000 f64b964c 00000002 f661e678 c1038ed3
[    8.900492]  00000009 f498f8f8 c18e08e9 f498f910 c1468a98 c1901e08 00002241 c18e08e9
[    8.900513] Call Trace:
[    8.900533]  [<c1663e65>] ? dump_stack+0x48/0x6f
[    8.900550]  [<c1038e15>] ? warn_slowpath_common+0x85/0xb0
[    8.900565]  [<c1468a98>] ? check_crtc_state+0x5f8/0xbe0
[    8.900578]  [<c1468a98>] ? check_crtc_state+0x5f8/0xbe0
[    8.900592]  [<c1038ed3>] ? warn_slowpath_fmt+0x33/0x40
[    8.900605]  [<c1468a98>] ? check_crtc_state+0x5f8/0xbe0
[    8.900633]  [<c1473d3b>] ? intel_modeset_check_state+0x28b/0x780
[    8.900649]  [<c1474260>] ? intel_set_mode+0x30/0x40
[    8.900664]  [<c14755bf>] ? intel_get_load_detect_pipe+0x22f/0x3b0
[    8.900682]  [<c1497303>] ? intel_tv_detect+0x133/0x4e0
[    8.900698]  [<c1081f01>] ? log_store+0x111/0x260
[    8.900718]  [<c134d9f8>] ? drm_helper_probe_single_connector_modes+0x288/0x340
[    8.900744]  [<c135ecda>] ? drm_mode_getconnector+0x31a/0x370
[    8.900753]  [<c135e9c0>] ? drm_mode_getcrtc+0xb0/0xb0
[    8.900760]  [<c13521b6>] ? drm_ioctl+0x426/0x4b0
[    8.900767]  [<c135e9c0>] ? drm_mode_getcrtc+0xb0/0xb0
[    8.900775]  [<c1351d90>] ? drm_copy_field+0x70/0x70
[    8.900783]  [<c10fc237>] ? do_vfs_ioctl+0x77/0x560
[    8.900791]  [<c10e8985>] ? kmem_cache_free+0xd5/0x100
[    8.900798]  [<c1100216>] ? d_kill+0xb6/0x100
[    8.900805]  [<c1100216>] ? d_kill+0xb6/0x100
[    8.900812]  [<c1100216>] ? d_kill+0xb6/0x100
[    8.900819]  [<c11007e0>] ? dput+0x170/0x1a0
[    8.900826]  [<c10ee0cd>] ? __fput+0xed/0x1e0
[    8.900833]  [<c10fc76b>] ? SyS_ioctl+0x4b/0x80
[    8.900840]  [<c16698bc>] ? syscall_call+0x7/0xb
[    8.900848]  [<c1660000>] ? refill_pi_state_cache.part.14+0x4b/0x4c
[    8.900852] ---[ end trace 247144411d041a1f ]---
[    8.900857] [drm:intel_dump_pipe_config], [CRTC:3][hw state] config for pipe A
[    8.900862] [drm:intel_dump_pipe_config], cpu_transcoder: A
[    8.900884] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
[    8.900890] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    8.900898] [drm:intel_dump_pipe_config], requested mode:
[    8.900904] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 1280 0 0 0 1024 0 0 0 0x0 0x0
[    8.900913] [drm:intel_dump_pipe_config], adjusted mode:
[    8.900918] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 108000 0 0 0 0 0 0 0 0 0x0 0x0
[    8.900927] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    8.900934] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[    8.900940] [drm:intel_dump_pipe_config], ips: 0
[    8.900945] [drm:intel_dump_pipe_config], [CRTC:3][sw state] config for pipe A
[    8.900951] [drm:intel_dump_pipe_config], cpu_transcoder: A
[    8.900956] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[    8.900962] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    8.900969] [drm:intel_dump_pipe_config], requested mode:
[    8.900975] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[    8.900984] [drm:intel_dump_pipe_config], adjusted mode:
[    8.900988] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 108000 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0xa
[    8.900996] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    8.901001] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[    8.901006] [drm:intel_dump_pipe_config], ips: 0
[    8.901010] [drm:check_crtc_state], [CRTC:4]
[    8.940191] [drm:intel_tv_detect_type], TV detected: c0017, 7f0000aa
[    8.940209] [drm:intel_tv_detect_type], Unrecognised TV connection
[    8.956195] [drm:intel_release_load_detect_pipe], [CONNECTOR:11:SVIDEO-1], [ENCODER:12:TV-12]
[    8.956218] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 0, prepare: 0, disable: 1
[    8.997012] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    8.997024] [drm:intel_calculate_wm], FIFO entries required for mode: 16
[    8.997029] [drm:intel_calculate_wm], FIFO watermark level: 10
[    8.997034] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    8.997039] [drm:i9xx_update_wm], FIFO watermarks - A: 10, B: 29
[    8.997044] [drm:i9xx_update_wm], self-refresh entries: 64
[    8.997048] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 10, B: 29, C: 2, SR 63
[    8.997054] [drm:i9xx_update_wm], memory self refresh enabled
[    8.997070] [drm:intel_connector_check_state], [CONNECTOR:5:LVDS-1]
[    8.997078] [drm:check_encoder_state], [ENCODER:6:LVDS-6]
[    8.997083] [drm:check_encoder_state], [ENCODER:10:DAC-10]
[    8.997089] [drm:check_encoder_state], [ENCODER:12:TV-12]
[    8.997094] [drm:check_crtc_state], [CRTC:3]
[    8.997101] [drm:i9xx_crtc_clock_get], Unknown DPLL mode 00000000 in programmed mode
[    8.997106] [drm:check_crtc_state], [CRTC:4]
[    8.997225] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:11:SVIDEO-1] disconnected
[    8.998388] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[    8.998398] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[    8.998404] [drm:intel_lvds_detect], [CONNECTOR:5:LVDS-1]
[    8.998417] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
[    8.998422] [drm:drm_mode_debug_printmodeline], Modeline 26:"1024x600" 59 49180 1024 1044 1054 1344 600 602 605 625 0x8 0xa
[    8.998435] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[    9.003387] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[    9.003404] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[    9.003411] [drm:intel_crt_detect], [CONNECTOR:9:VGA-1] force=1
[    9.016036] [drm:intel_crt_detect], CRT not detected via hotplug
[    9.020132] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[    9.020149] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    9.020159] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[    9.020167] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[    9.020480] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    9.020488] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[    9.020498] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    9.020509] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[    9.020532] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[    9.020543] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[    9.020553] [drm:intel_crt_detect], [CONNECTOR:9:VGA-1] force=1
[    9.036164] [drm:intel_crt_detect], CRT not detected via hotplug
[    9.040187] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[    9.040210] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    9.040221] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[    9.040230] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[    9.040544] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    9.040552] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[    9.040562] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    9.040577] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[    9.040759] [drm:drm_mode_getconnector], [CONNECTOR:11:?]
[    9.040769] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:11:SVIDEO-1]
[    9.040775] [drm:intel_tv_detect], [CONNECTOR:11:SVIDEO-1] force=1
[    9.040782] [drm:intel_get_load_detect_pipe], [CONNECTOR:11:SVIDEO-1], [ENCODER:12:TV-12]
[    9.040788] [drm:intel_get_load_detect_pipe], creating tmp fb for load-detection
[    9.040817] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 1, prepare: 1, disable: 0
[    9.040827] [drm:connected_sink_compute_bpp], [CONNECTOR:11:SVIDEO-1] checking for sink bpp constrains
[    9.040834] [drm:intel_tv_compute_config], forcing bpc to 8 for TV
[    9.040838] [drm:intel_modeset_pipe_config], plane bpp: 24, pipe bpp: 24, dithering: 0
[    9.040844] [drm:intel_dump_pipe_config], [CRTC:3][modeset] config for pipe A
[    9.040849] [drm:intel_dump_pipe_config], cpu_transcoder: A
[    9.040853] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[    9.040857] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    9.040863] [drm:intel_dump_pipe_config], requested mode:
[    9.040867] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[    9.040876] [drm:intel_dump_pipe_config], adjusted mode:
[    9.040879] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 108000 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0xa
[    9.040887] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    9.040892] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[    9.040897] [drm:intel_dump_pipe_config], ips: 0
[    9.051060] [drm:i9xx_update_plane], Writing base 00280000 00000000 0 0 5120
[    9.051076] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    9.051083] [drm:intel_calculate_wm], FIFO entries required for mode: 16
[    9.051087] [drm:intel_calculate_wm], FIFO watermark level: 10
[    9.051092] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    9.051097] [drm:i9xx_update_wm], FIFO watermarks - A: 10, B: 29
[    9.051102] [drm:i9xx_update_wm], self-refresh entries: 64
[    9.051106] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 10, B: 29, C: 2, SR 63
[    9.051112] [drm:i9xx_update_wm], memory self refresh enabled
[    9.051119] [drm:intel_crtc_mode_set], [ENCODER:12:TV-12] set [MODE:0:NTSC 480i]
[    9.056129] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    9.056135] [drm:intel_calculate_wm], FIFO entries required for mode: 16
[    9.056139] [drm:intel_calculate_wm], FIFO watermark level: 10
[    9.056144] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    9.056149] [drm:intel_calculate_wm], FIFO entries required for mode: 34
[    9.056153] [drm:intel_calculate_wm], FIFO watermark level: -5
[    9.056157] [drm:i9xx_update_wm], FIFO watermarks - A: 10, B: 1
[    9.056162] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 10, B: 1, C: 2, SR 1
[    9.056167] [drm:i9xx_update_wm], memory self refresh disabled
[    9.080212] [drm:intel_connector_check_state], [CONNECTOR:5:LVDS-1]
[    9.080232] [drm:intel_connector_check_state], [CONNECTOR:11:SVIDEO-1]
[    9.080244] [drm:check_encoder_state], [ENCODER:6:LVDS-6]
[    9.080255] [drm:check_encoder_state], [ENCODER:10:DAC-10]
[    9.080265] [drm:check_encoder_state], [ENCODER:12:TV-12]
[    9.080276] [drm:check_crtc_state], [CRTC:3]
[    9.080301] [drm:intel_pipe_config_compare] *ERROR* mismatch in adjusted_mode.flags(DRM_MODE_FLAG_NHSYNC) (expected 2, found 0)
[    9.080310] ------------[ cut here ]------------
[    9.080333] WARNING: CPU: 1 PID: 1616 at drivers/gpu/drm/i915/intel_display.c:8769 check_crtc_state+0x5f8/0xbe0()
[    9.080340] pipe state doesn't match!
[    9.080346] Modules linked in: ata_generic sata_vsc sata_sil24 pata_mpiix pata_oldpiix nls_iso8859_1 nls_cp850 vfat fat ums_usbat ums_sddr55 ums_sddr09 ums_onetouch ums_karma ums_jumpshot ums_isd200 ums_freecom ums_datafab ums_cypress ums_alauda usb_storage isofs sr_mod cdrom usbhid ohci_hcd uhci_hcd ehci_pci ehci_hcd xhci_hcd usbcore usb_common
[    9.080444] CPU: 1 PID: 1616 Comm: Xorg Tainted: G        W    3.12-pingu #1
[    9.080452] Hardware name: ASUSTeK Computer INC. 903/903, BIOS 0101    05/18/2008
[    9.080460]  00000009 c1663e65 f498f8f8 c1038e15 c18e08e9 f498f910 00000650 c1901e08
[    9.080482]  00002241 c1468a98 c1468a98 f64b9000 f64b964c 00000002 f661e678 c1038ed3
[    9.080502]  00000009 f498f8f8 c18e08e9 f498f910 c1468a98 c1901e08 00002241 c18e08e9
[    9.080524] Call Trace:
[    9.080544]  [<c1663e65>] ? dump_stack+0x48/0x6f
[    9.080560]  [<c1038e15>] ? warn_slowpath_common+0x85/0xb0
[    9.080575]  [<c1468a98>] ? check_crtc_state+0x5f8/0xbe0
[    9.080588]  [<c1468a98>] ? check_crtc_state+0x5f8/0xbe0
[    9.080602]  [<c1038ed3>] ? warn_slowpath_fmt+0x33/0x40
[    9.080616]  [<c1468a98>] ? check_crtc_state+0x5f8/0xbe0
[    9.080643]  [<c1473d3b>] ? intel_modeset_check_state+0x28b/0x780
[    9.080659]  [<c1474260>] ? intel_set_mode+0x30/0x40
[    9.080674]  [<c14755bf>] ? intel_get_load_detect_pipe+0x22f/0x3b0
[    9.080692]  [<c1497303>] ? intel_tv_detect+0x133/0x4e0
[    9.080708]  [<c1081f01>] ? log_store+0x111/0x260
[    9.080739]  [<c134d9f8>] ? drm_helper_probe_single_connector_modes+0x288/0x340
[    9.080751]  [<c135ecda>] ? drm_mode_getconnector+0x31a/0x370
[    9.080759]  [<c10b9a4b>] ? find_lock_page+0x1b/0x70
[    9.080767]  [<c135e9c0>] ? drm_mode_getcrtc+0xb0/0xb0
[    9.080773]  [<c13521b6>] ? drm_ioctl+0x426/0x4b0
[    9.080781]  [<c135e9c0>] ? drm_mode_getcrtc+0xb0/0xb0
[    9.080789]  [<c10bae26>] ? generic_file_aio_write+0x86/0xb0
[    9.080795]  [<c1351d90>] ? drm_copy_field+0x70/0x70
[    9.080803]  [<c10fc237>] ? do_vfs_ioctl+0x77/0x560
[    9.080812]  [<c10ee879>] ? __sb_end_write+0x29/0x60
[    9.080818]  [<c10ed1f5>] ? vfs_write+0x165/0x1a0
[    9.080826]  [<c10fc76b>] ? SyS_ioctl+0x4b/0x80
[    9.080833]  [<c16698bc>] ? syscall_call+0x7/0xb
[    9.080841]  [<c1660000>] ? refill_pi_state_cache.part.14+0x4b/0x4c
[    9.080845] ---[ end trace 247144411d041a20 ]---
[    9.080850] [drm:intel_dump_pipe_config], [CRTC:3][hw state] config for pipe A
[    9.080855] [drm:intel_dump_pipe_config], cpu_transcoder: A
[    9.080859] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
[    9.080863] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    9.080869] [drm:intel_dump_pipe_config], requested mode:
[    9.080873] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 1280 0 0 0 1024 0 0 0 0x0 0x0
[    9.080881] [drm:intel_dump_pipe_config], adjusted mode:
[    9.080884] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 108000 0 0 0 0 0 0 0 0 0x0 0x0
[    9.080892] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    9.080897] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[    9.080902] [drm:intel_dump_pipe_config], ips: 0
[    9.080906] [drm:intel_dump_pipe_config], [CRTC:3][sw state] config for pipe A
[    9.080910] [drm:intel_dump_pipe_config], cpu_transcoder: A
[    9.080914] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[    9.080918] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    9.080924] [drm:intel_dump_pipe_config], requested mode:
[    9.080928] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[    9.080936] [drm:intel_dump_pipe_config], adjusted mode:
[    9.080939] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 108000 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0xa
[    9.080947] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    9.080952] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[    9.080957] [drm:intel_dump_pipe_config], ips: 0
[    9.080961] [drm:check_crtc_state], [CRTC:4]
[    9.112206] [drm:intel_tv_detect_type], TV detected: c0017, 7f0000aa
[    9.112224] [drm:intel_tv_detect_type], Unrecognised TV connection
[    9.144207] [drm:intel_release_load_detect_pipe], [CONNECTOR:11:SVIDEO-1], [ENCODER:12:TV-12]
[    9.144229] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 0, prepare: 0, disable: 1
[    9.183072] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    9.183084] [drm:intel_calculate_wm], FIFO entries required for mode: 16
[    9.183089] [drm:intel_calculate_wm], FIFO watermark level: 10
[    9.183094] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    9.183098] [drm:i9xx_update_wm], FIFO watermarks - A: 10, B: 29
[    9.183103] [drm:i9xx_update_wm], self-refresh entries: 64
[    9.183108] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 10, B: 29, C: 2, SR 63
[    9.183114] [drm:i9xx_update_wm], memory self refresh enabled
[    9.183130] [drm:intel_connector_check_state], [CONNECTOR:5:LVDS-1]
[    9.183137] [drm:check_encoder_state], [ENCODER:6:LVDS-6]
[    9.183143] [drm:check_encoder_state], [ENCODER:10:DAC-10]
[    9.183148] [drm:check_encoder_state], [ENCODER:12:TV-12]
[    9.183154] [drm:check_crtc_state], [CRTC:3]
[    9.183161] [drm:i9xx_crtc_clock_get], Unknown DPLL mode 00000000 in programmed mode
[    9.183165] [drm:check_crtc_state], [CRTC:4]
[    9.183288] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:11:SVIDEO-1] disconnected
[    9.184361] [drm:drm_mode_getconnector], [CONNECTOR:11:?]
[    9.184370] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:11:SVIDEO-1]
[    9.184375] [drm:intel_tv_detect], [CONNECTOR:11:SVIDEO-1] force=1
[    9.184382] [drm:intel_get_load_detect_pipe], [CONNECTOR:11:SVIDEO-1], [ENCODER:12:TV-12]
[    9.184388] [drm:intel_get_load_detect_pipe], creating tmp fb for load-detection
[    9.184410] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 1, prepare: 1, disable: 0
[    9.184420] [drm:connected_sink_compute_bpp], [CONNECTOR:11:SVIDEO-1] checking for sink bpp constrains
[    9.184426] [drm:intel_tv_compute_config], forcing bpc to 8 for TV
[    9.184431] [drm:intel_modeset_pipe_config], plane bpp: 24, pipe bpp: 24, dithering: 0
[    9.184436] [drm:intel_dump_pipe_config], [CRTC:3][modeset] config for pipe A
[    9.184441] [drm:intel_dump_pipe_config], cpu_transcoder: A
[    9.184445] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[    9.184449] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    9.184455] [drm:intel_dump_pipe_config], requested mode:
[    9.184459] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[    9.184467] [drm:intel_dump_pipe_config], adjusted mode:
[    9.184471] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 108000 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0xa
[    9.184479] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    9.184484] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[    9.184489] [drm:intel_dump_pipe_config], ips: 0
[    9.194619] [drm:i9xx_update_plane], Writing base 00280000 00000000 0 0 5120
[    9.194636] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    9.194643] [drm:intel_calculate_wm], FIFO entries required for mode: 16
[    9.194647] [drm:intel_calculate_wm], FIFO watermark level: 10
[    9.194652] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    9.194657] [drm:i9xx_update_wm], FIFO watermarks - A: 10, B: 29
[    9.194662] [drm:i9xx_update_wm], self-refresh entries: 64
[    9.194666] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 10, B: 29, C: 2, SR 63
[    9.194672] [drm:i9xx_update_wm], memory self refresh enabled
[    9.194679] [drm:intel_crtc_mode_set], [ENCODER:12:TV-12] set [MODE:0:NTSC 480i]
[    9.199692] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    9.199699] [drm:intel_calculate_wm], FIFO entries required for mode: 16
[    9.199703] [drm:intel_calculate_wm], FIFO watermark level: 10
[    9.199708] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    9.199713] [drm:intel_calculate_wm], FIFO entries required for mode: 34
[    9.199717] [drm:intel_calculate_wm], FIFO watermark level: -5
[    9.199721] [drm:i9xx_update_wm], FIFO watermarks - A: 10, B: 1
[    9.199725] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 10, B: 1, C: 2, SR 1
[    9.199731] [drm:i9xx_update_wm], memory self refresh disabled
[    9.224208] [drm:intel_connector_check_state], [CONNECTOR:5:LVDS-1]
[    9.224228] [drm:intel_connector_check_state], [CONNECTOR:11:SVIDEO-1]
[    9.224240] [drm:check_encoder_state], [ENCODER:6:LVDS-6]
[    9.224251] [drm:check_encoder_state], [ENCODER:10:DAC-10]
[    9.224262] [drm:check_encoder_state], [ENCODER:12:TV-12]
[    9.224273] [drm:check_crtc_state], [CRTC:3]
[    9.224296] [drm:intel_pipe_config_compare] *ERROR* mismatch in adjusted_mode.flags(DRM_MODE_FLAG_NHSYNC) (expected 2, found 0)
[    9.224305] ------------[ cut here ]------------
[    9.224327] WARNING: CPU: 1 PID: 1616 at drivers/gpu/drm/i915/intel_display.c:8769 check_crtc_state+0x5f8/0xbe0()
[    9.224334] pipe state doesn't match!
[    9.224340] Modules linked in: ata_generic sata_vsc sata_sil24 pata_mpiix pata_oldpiix nls_iso8859_1 nls_cp850 vfat fat ums_usbat ums_sddr55 ums_sddr09 ums_onetouch ums_karma ums_jumpshot ums_isd200 ums_freecom ums_datafab ums_cypress ums_alauda usb_storage isofs sr_mod cdrom usbhid ohci_hcd uhci_hcd ehci_pci ehci_hcd xhci_hcd usbcore usb_common
[    9.224438] CPU: 1 PID: 1616 Comm: Xorg Tainted: G        W    3.12-pingu #1
[    9.224445] Hardware name: ASUSTeK Computer INC. 903/903, BIOS 0101    05/18/2008
[    9.224453]  00000009 c1663e65 f498f8f8 c1038e15 c18e08e9 f498f910 00000650 c1901e08
[    9.224475]  00002241 c1468a98 c1468a98 f64b9000 f64b964c 00000002 f661e678 c1038ed3
[    9.224496]  00000009 f498f8f8 c18e08e9 f498f910 c1468a98 c1901e08 00002241 c18e08e9
[    9.224517] Call Trace:
[    9.224537]  [<c1663e65>] ? dump_stack+0x48/0x6f
[    9.224553]  [<c1038e15>] ? warn_slowpath_common+0x85/0xb0
[    9.224568]  [<c1468a98>] ? check_crtc_state+0x5f8/0xbe0
[    9.224581]  [<c1468a98>] ? check_crtc_state+0x5f8/0xbe0
[    9.224595]  [<c1038ed3>] ? warn_slowpath_fmt+0x33/0x40
[    9.224608]  [<c1468a98>] ? check_crtc_state+0x5f8/0xbe0
[    9.224636]  [<c1473d3b>] ? intel_modeset_check_state+0x28b/0x780
[    9.224652]  [<c1474260>] ? intel_set_mode+0x30/0x40
[    9.224666]  [<c14755bf>] ? intel_get_load_detect_pipe+0x22f/0x3b0
[    9.224684]  [<c1497303>] ? intel_tv_detect+0x133/0x4e0
[    9.224699]  [<c1081f01>] ? log_store+0x111/0x260
[    9.224720]  [<c134d9f8>] ? drm_helper_probe_single_connector_modes+0x288/0x340
[    9.224745]  [<c135ecda>] ? drm_mode_getconnector+0x31a/0x370
[    9.224755]  [<c10bf1f8>] ? free_pages_prepare+0xc8/0x100
[    9.224762]  [<c135e9c0>] ? drm_mode_getcrtc+0xb0/0xb0
[    9.224769]  [<c13521b6>] ? drm_ioctl+0x426/0x4b0
[    9.224776]  [<c135e9c0>] ? drm_mode_getcrtc+0xb0/0xb0
[    9.224785]  [<c10cb482>] ? shmem_truncate_range+0x32/0x50
[    9.224792]  [<c1351d90>] ? drm_copy_field+0x70/0x70
[    9.224799]  [<c10fc237>] ? do_vfs_ioctl+0x77/0x560
[    9.224807]  [<c1100216>] ? d_kill+0xb6/0x100
[    9.224814]  [<c1100216>] ? d_kill+0xb6/0x100
[    9.224821]  [<c11007e0>] ? dput+0x170/0x1a0
[    9.224828]  [<c10ee0cd>] ? __fput+0xed/0x1e0
[    9.224835]  [<c10fc76b>] ? SyS_ioctl+0x4b/0x80
[    9.224843]  [<c16698bc>] ? syscall_call+0x7/0xb
[    9.224850]  [<c1660000>] ? refill_pi_state_cache.part.14+0x4b/0x4c
[    9.224855] ---[ end trace 247144411d041a21 ]---
[    9.224859] [drm:intel_dump_pipe_config], [CRTC:3][hw state] config for pipe A
[    9.224864] [drm:intel_dump_pipe_config], cpu_transcoder: A
[    9.224868] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
[    9.224873] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    9.224878] [drm:intel_dump_pipe_config], requested mode:
[    9.224883] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 1280 0 0 0 1024 0 0 0 0x0 0x0
[    9.224890] [drm:intel_dump_pipe_config], adjusted mode:
[    9.224894] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 108000 0 0 0 0 0 0 0 0 0x0 0x0
[    9.224901] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    9.224906] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[    9.224911] [drm:intel_dump_pipe_config], ips: 0
[    9.224915] [drm:intel_dump_pipe_config], [CRTC:3][sw state] config for pipe A
[    9.224920] [drm:intel_dump_pipe_config], cpu_transcoder: A
[    9.224924] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[    9.224928] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    9.224934] [drm:intel_dump_pipe_config], requested mode:
[    9.224937] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[    9.224945] [drm:intel_dump_pipe_config], adjusted mode:
[    9.224949] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 108000 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0xa
[    9.224957] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    9.224962] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[    9.224966] [drm:intel_dump_pipe_config], ips: 0
[    9.224971] [drm:check_crtc_state], [CRTC:4]
[    9.272173] [drm:intel_tv_detect_type], TV detected: c0017, 7f0000aa
[    9.272190] [drm:intel_tv_detect_type], Unrecognised TV connection
[    9.296206] [drm:intel_release_load_detect_pipe], [CONNECTOR:11:SVIDEO-1], [ENCODER:12:TV-12]
[    9.296229] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 0, prepare: 0, disable: 1
[    9.336988] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    9.337000] [drm:intel_calculate_wm], FIFO entries required for mode: 16
[    9.337005] [drm:intel_calculate_wm], FIFO watermark level: 10
[    9.337010] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    9.337015] [drm:i9xx_update_wm], FIFO watermarks - A: 10, B: 29
[    9.337020] [drm:i9xx_update_wm], self-refresh entries: 64
[    9.337024] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 10, B: 29, C: 2, SR 63
[    9.337030] [drm:i9xx_update_wm], memory self refresh enabled
[    9.337047] [drm:intel_connector_check_state], [CONNECTOR:5:LVDS-1]
[    9.337055] [drm:check_encoder_state], [ENCODER:6:LVDS-6]
[    9.337060] [drm:check_encoder_state], [ENCODER:10:DAC-10]
[    9.337066] [drm:check_encoder_state], [ENCODER:12:TV-12]
[    9.337071] [drm:check_crtc_state], [CRTC:3]
[    9.337078] [drm:i9xx_crtc_clock_get], Unknown DPLL mode 00000000 in programmed mode
[    9.337082] [drm:check_crtc_state], [CRTC:4]
[    9.337206] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:11:SVIDEO-1] disconnected
[    9.356575] [drm:intel_panel_get_max_backlight], max backlight PWM = 140
[    9.356587] [drm:intel_panel_actually_set_backlight], set backlight PWM = 140
[    9.356731] [drm:intel_panel_get_max_backlight], max backlight PWM = 140
[    9.356740] [drm:intel_panel_actually_set_backlight], set backlight PWM = 140
[    9.358085] [drm:drm_mode_addfb], [FB:29]
[    9.358267] [drm:drm_mode_setcrtc], [CRTC:4]
[    9.358286] [drm:drm_mode_setcrtc], [CONNECTOR:5:LVDS-1]
[    9.358293] [drm:intel_crtc_set_config], [CRTC:4] [FB:29] #connectors=1 (x y) (0 0)
[    9.358306] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:4], mode_changed=0, fb_changed=1
[    9.358316] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:4]
[    9.363441] [drm:i9xx_update_plane], Writing base 00400000 00000000 0 0 4096
[   11.197992] fastinit: init.d start
[   11.670513] ACPI: Requesting acpi_cpufreq
[   11.748364] thermal LNXTHERM:00: registered as thermal_zone0
[   11.748375] ACPI: Thermal Zone [TZ00] (52 C)
[   11.757065] intel_rng: FWH not detected
[   11.809729] ACPI Warning: 0x00000828-0x0000082f SystemIO conflicts with Region \PMIO 1 (20130725/utaddress-251)
[   11.809751] ACPI Warning: 0x00000828-0x0000082f SystemIO conflicts with Region \_SB_.PCI0.SBRG.PMS0 2 (20130725/utaddress-251)
[   11.809783] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   11.809795] ACPI Warning: 0x000004b0-0x000004bf SystemIO conflicts with Region \_SB_.PCI0.SBRG.GPBX 1 (20130725/utaddress-251)
[   11.809807] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   11.809814] ACPI Warning: 0x00000480-0x000004af SystemIO conflicts with Region \_SB_.PCI0.SBRG.GPBX 1 (20130725/utaddress-251)
[   11.809825] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   11.809831] lpc_ich: Resource conflict(s) found affecting gpio_ich
[   12.022932] cfg80211: Calling CRDA to update world regulatory domain
[   12.279538] snd_hda_intel 0000:00:1b.0: irq 43 for MSI/MSI-X
[   12.286761] ath5k 0000:02:00.0: can't disable ASPM; OS doesn't have ASPM control
[   12.287000] ath5k 0000:02:00.0: registered as 'phy0'
[   12.288058] [drm:intel_tv_detect], [CONNECTOR:11:SVIDEO-1] force=0
[   12.335253] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
[   12.340327] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[   12.978730] ath: EEPROM regdomain: 0x60
[   12.978739] ath: EEPROM indicates we should expect a direct regpair map
[   12.978750] ath: Country alpha2 being used: 00
[   12.978755] ath: Regpair used: 0x60
[   13.081812] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[   13.082659] ath5k: phy0: Atheros AR2425 chip found (MAC: 0xe2, PHY: 0x70)
[   13.699615] media: Linux media interface: v0.10
[   13.998565] Linux video capture interface: v2.00
[   14.170623] uvcvideo: Found UVC 1.00 device Digital_Camera (093a:2700)
[   14.201010] input: Digital_Camera as /devices/pci0000:00/0000:00:1d.7/usb1/1-2/1-2:1.0/input/input9
[   14.201310] usbcore: registered new interface driver uvcvideo
[   14.201318] USB Video Class driver (1.1.1)
[   17.748346] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   17.748365] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   17.748373] [drm:intel_lvds_detect], [CONNECTOR:5:LVDS-1]
[   17.748392] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
[   17.748400] [drm:drm_mode_debug_printmodeline], Modeline 26:"1024x600" 59 49180 1024 1044 1054 1344 600 602 605 625 0x8 0xa
[   17.748422] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   17.749103] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[   17.749115] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[   17.749123] [drm:intel_crt_detect], [CONNECTOR:9:VGA-1] force=1
[   17.764783] [drm:intel_crt_detect], CRT not detected via hotplug
[   17.768078] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[   17.768097] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   17.768105] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[   17.768111] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[   17.768424] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   17.768432] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[   17.768439] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   17.768449] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[   17.768496] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[   17.768506] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[   17.768513] [drm:intel_crt_detect], [CONNECTOR:9:VGA-1] force=1
[   17.784082] [drm:intel_crt_detect], CRT not detected via hotplug
[   17.788106] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[   17.788124] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   17.788132] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[   17.788138] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[   17.788448] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   17.788457] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[   17.788465] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   17.788474] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[   17.788539] [drm:drm_mode_getconnector], [CONNECTOR:11:?]
[   17.788550] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:11:SVIDEO-1]
[   17.788558] [drm:intel_tv_detect], [CONNECTOR:11:SVIDEO-1] force=1
[   17.788567] [drm:intel_get_load_detect_pipe], [CONNECTOR:11:SVIDEO-1], [ENCODER:12:TV-12]
[   17.788576] [drm:intel_get_load_detect_pipe], creating tmp fb for load-detection
[   17.788609] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 1, prepare: 1, disable: 0
[   17.788623] [drm:connected_sink_compute_bpp], [CONNECTOR:11:SVIDEO-1] checking for sink bpp constrains
[   17.788632] [drm:intel_tv_compute_config], forcing bpc to 8 for TV
[   17.788638] [drm:intel_modeset_pipe_config], plane bpp: 24, pipe bpp: 24, dithering: 0
[   17.788645] [drm:intel_dump_pipe_config], [CRTC:3][modeset] config for pipe A
[   17.788652] [drm:intel_dump_pipe_config], cpu_transcoder: A
[   17.788658] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[   17.788664] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[   17.788672] [drm:intel_dump_pipe_config], requested mode:
[   17.788677] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   17.788689] [drm:intel_dump_pipe_config], adjusted mode:
[   17.788695] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 108000 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0xa
[   17.788706] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[   17.788713] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[   17.788720] [drm:intel_dump_pipe_config], ips: 0
[   17.807220] [drm:i9xx_update_plane], Writing base 01810000 00000000 0 0 5120
[   17.807242] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[   17.807251] [drm:intel_calculate_wm], FIFO entries required for mode: 16
[   17.807258] [drm:intel_calculate_wm], FIFO watermark level: 10
[   17.807264] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[   17.807271] [drm:i9xx_update_wm], FIFO watermarks - A: 10, B: 29
[   17.807278] [drm:i9xx_update_wm], self-refresh entries: 64
[   17.807284] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 10, B: 29, C: 2, SR 63
[   17.807292] [drm:i9xx_update_wm], memory self refresh enabled
[   17.807302] [drm:intel_crtc_mode_set], [ENCODER:12:TV-12] set [MODE:0:NTSC 480i]
[   17.816199] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[   17.816216] [drm:intel_calculate_wm], FIFO entries required for mode: 16
[   17.816222] [drm:intel_calculate_wm], FIFO watermark level: 10
[   17.816229] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[   17.816236] [drm:intel_calculate_wm], FIFO entries required for mode: 34
[   17.816242] [drm:intel_calculate_wm], FIFO watermark level: -5
[   17.816248] [drm:i9xx_update_wm], FIFO watermarks - A: 10, B: 1
[   17.816256] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 10, B: 1, C: 2, SR 1
[   17.816264] [drm:i9xx_update_wm], memory self refresh disabled
[   17.840082] [drm:intel_connector_check_state], [CONNECTOR:5:LVDS-1]
[   17.840100] [drm:intel_connector_check_state], [CONNECTOR:11:SVIDEO-1]
[   17.840110] [drm:check_encoder_state], [ENCODER:6:LVDS-6]
[   17.840118] [drm:check_encoder_state], [ENCODER:10:DAC-10]
[   17.840126] [drm:check_encoder_state], [ENCODER:12:TV-12]
[   17.840135] [drm:check_crtc_state], [CRTC:3]
[   17.840155] [drm:intel_pipe_config_compare] *ERROR* mismatch in adjusted_mode.flags(DRM_MODE_FLAG_NHSYNC) (expected 2, found 0)
[   17.840162] ------------[ cut here ]------------
[   17.840180] WARNING: CPU: 0 PID: 1616 at drivers/gpu/drm/i915/intel_display.c:8769 check_crtc_state+0x5f8/0xbe0()
[   17.840186] pipe state doesn't match!
[   17.840190] Modules linked in: uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core videodev media arc4 snd_hda_codec_realtek ath5k snd_hda_intel snd_hda_codec ath mac80211 cfg80211 snd_hwdep snd_pcm snd_page_alloc rfkill snd_timer snd soundcore atl1e lpc_ich mfd_core rng_core acpi_cpufreq thermal processor ata_generic sata_vsc sata_sil24 pata_mpiix pata_oldpiix nls_iso8859_1 nls_cp850 vfat fat ums_usbat ums_sddr55 ums_sddr09 ums_onetouch ums_karma ums_jumpshot ums_isd200 ums_freecom ums_datafab ums_cypress ums_alauda usb_storage isofs sr_mod cdrom usbhid ohci_hcd uhci_hcd ehci_pci ehci_hcd xhci_hcd usbcore usb_common
[   17.840315] CPU: 0 PID: 1616 Comm: Xorg Tainted: G        W    3.12-pingu #1
[   17.840322] Hardware name: ASUSTeK Computer INC. 903/903, BIOS 0101    05/18/2008
[   17.840328]  00000009 c1663e65 f498f8f8 c1038e15 c18e08e9 f498f910 00000650 c1901e08
[   17.840343]  00002241 c1468a98 c1468a98 f64b9000 f64b964c 00000002 f661e678 c1038ed3
[   17.840358]  00000009 f498f8f8 c18e08e9 f498f910 c1468a98 c1901e08 00002241 c18e08e9
[   17.840373] Call Trace:
[   17.840391]  [<c1663e65>] ? dump_stack+0x48/0x6f
[   17.840404]  [<c1038e15>] ? warn_slowpath_common+0x85/0xb0
[   17.840415]  [<c1468a98>] ? check_crtc_state+0x5f8/0xbe0
[   17.840426]  [<c1468a98>] ? check_crtc_state+0x5f8/0xbe0
[   17.840436]  [<c1038ed3>] ? warn_slowpath_fmt+0x33/0x40
[   17.840446]  [<c1468a98>] ? check_crtc_state+0x5f8/0xbe0
[   17.840466]  [<c1473d3b>] ? intel_modeset_check_state+0x28b/0x780
[   17.840478]  [<c1474260>] ? intel_set_mode+0x30/0x40
[   17.840488]  [<c14755bf>] ? intel_get_load_detect_pipe+0x22f/0x3b0
[   17.840501]  [<c1497303>] ? intel_tv_detect+0x133/0x4e0
[   17.840513]  [<c1081f01>] ? log_store+0x111/0x260
[   17.840529]  [<c134d9f8>] ? drm_helper_probe_single_connector_modes+0x288/0x340
[   17.840543]  [<c135ecda>] ? drm_mode_getconnector+0x31a/0x370
[   17.840554]  [<c135e9c0>] ? drm_mode_getcrtc+0xb0/0xb0
[   17.840563]  [<c13521b6>] ? drm_ioctl+0x426/0x4b0
[   17.840572]  [<c135e9c0>] ? drm_mode_getcrtc+0xb0/0xb0
[   17.840586]  [<c100a53d>] ? fpu_finit+0x4d/0x60
[   17.840596]  [<c100b81a>] ? __restore_xstate_sig+0x35a/0x580
[   17.840607]  [<c1351d90>] ? drm_copy_field+0x70/0x70
[   17.840618]  [<c10fc237>] ? do_vfs_ioctl+0x77/0x560
[   17.840628]  [<c10fc76b>] ? SyS_ioctl+0x4b/0x80
[   17.840639]  [<c16698bc>] ? syscall_call+0x7/0xb
[   17.840648] ---[ end trace 247144411d041a22 ]---
[   17.840655] [drm:intel_dump_pipe_config], [CRTC:3][hw state] config for pipe A
[   17.840662] [drm:intel_dump_pipe_config], cpu_transcoder: A
[   17.840668] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
[   17.840674] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[   17.840682] [drm:intel_dump_pipe_config], requested mode:
[   17.840689] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 1280 0 0 0 1024 0 0 0 0x0 0x0
[   17.840699] [drm:intel_dump_pipe_config], adjusted mode:
[   17.840703] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 108000 0 0 0 0 0 0 0 0 0x0 0x0
[   17.840714] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[   17.840723] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[   17.840730] [drm:intel_dump_pipe_config], ips: 0
[   17.840736] [drm:intel_dump_pipe_config], [CRTC:3][sw state] config for pipe A
[   17.840742] [drm:intel_dump_pipe_config], cpu_transcoder: A
[   17.840748] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[   17.840754] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[   17.840762] [drm:intel_dump_pipe_config], requested mode:
[   17.840767] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   17.840778] [drm:intel_dump_pipe_config], adjusted mode:
[   17.840783] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 108000 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0xa
[   17.840794] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[   17.840801] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[   17.840807] [drm:intel_dump_pipe_config], ips: 0
[   17.840813] [drm:check_crtc_state], [CRTC:4]
[   17.880089] [drm:intel_tv_detect_type], TV detected: c0017, 7f0000aa
[   17.880103] [drm:intel_tv_detect_type], Unrecognised TV connection
[   17.896071] [drm:intel_release_load_detect_pipe], [CONNECTOR:11:SVIDEO-1], [ENCODER:12:TV-12]
[   17.896090] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 0, prepare: 0, disable: 1
[   17.938737] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[   17.938755] [drm:intel_calculate_wm], FIFO entries required for mode: 16
[   17.938762] [drm:intel_calculate_wm], FIFO watermark level: 10
[   17.938769] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[   17.938777] [drm:i9xx_update_wm], FIFO watermarks - A: 10, B: 29
[   17.938785] [drm:i9xx_update_wm], self-refresh entries: 64
[   17.938791] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 10, B: 29, C: 2, SR 63
[   17.938800] [drm:i9xx_update_wm], memory self refresh enabled
[   17.938822] [drm:intel_connector_check_state], [CONNECTOR:5:LVDS-1]
[   17.938833] [drm:check_encoder_state], [ENCODER:6:LVDS-6]
[   17.938842] [drm:check_encoder_state], [ENCODER:10:DAC-10]
[   17.938851] [drm:check_encoder_state], [ENCODER:12:TV-12]
[   17.938859] [drm:check_crtc_state], [CRTC:3]
[   17.938869] [drm:i9xx_crtc_clock_get], Unknown DPLL mode 00000000 in programmed mode
[   17.938876] [drm:check_crtc_state], [CRTC:4]
[   17.939031] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:11:SVIDEO-1] disconnected
[   17.942330] [drm:drm_mode_getconnector], [CONNECTOR:11:?]
[   17.942349] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:11:SVIDEO-1]
[   17.942359] [drm:intel_tv_detect], [CONNECTOR:11:SVIDEO-1] force=1
[   17.942370] [drm:intel_get_load_detect_pipe], [CONNECTOR:11:SVIDEO-1], [ENCODER:12:TV-12]
[   17.942380] [drm:intel_get_load_detect_pipe], creating tmp fb for load-detection
[   17.942414] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 1, prepare: 1, disable: 0
[   17.942430] [drm:connected_sink_compute_bpp], [CONNECTOR:11:SVIDEO-1] checking for sink bpp constrains
[   17.942441] [drm:intel_tv_compute_config], forcing bpc to 8 for TV
[   17.942447] [drm:intel_modeset_pipe_config], plane bpp: 24, pipe bpp: 24, dithering: 0
[   17.942455] [drm:intel_dump_pipe_config], [CRTC:3][modeset] config for pipe A
[   17.942462] [drm:intel_dump_pipe_config], cpu_transcoder: A
[   17.942469] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[   17.942475] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[   17.942484] [drm:intel_dump_pipe_config], requested mode:
[   17.942490] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   17.942503] [drm:intel_dump_pipe_config], adjusted mode:
[   17.942509] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 108000 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0xa
[   17.942521] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[   17.942529] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[   17.942537] [drm:intel_dump_pipe_config], ips: 0
[   17.967640] [drm:i9xx_update_plane], Writing base 01810000 00000000 0 0 5120
[   17.967665] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[   17.967675] [drm:intel_calculate_wm], FIFO entries required for mode: 16
[   17.967682] [drm:intel_calculate_wm], FIFO watermark level: 10
[   17.967690] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[   17.967697] [drm:i9xx_update_wm], FIFO watermarks - A: 10, B: 29
[   17.967705] [drm:i9xx_update_wm], self-refresh entries: 64
[   17.967711] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 10, B: 29, C: 2, SR 63
[   17.967721] [drm:i9xx_update_wm], memory self refresh enabled
[   17.967730] [drm:intel_crtc_mode_set], [ENCODER:12:TV-12] set [MODE:0:NTSC 480i]
[   17.972766] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[   17.972783] [drm:intel_calculate_wm], FIFO entries required for mode: 16
[   17.972790] [drm:intel_calculate_wm], FIFO watermark level: 10
[   17.972798] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[   17.972806] [drm:intel_calculate_wm], FIFO entries required for mode: 34
[   17.972812] [drm:intel_calculate_wm], FIFO watermark level: -5
[   17.972819] [drm:i9xx_update_wm], FIFO watermarks - A: 10, B: 1
[   17.972827] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 10, B: 1, C: 2, SR 1
[   17.972835] [drm:i9xx_update_wm], memory self refresh disabled
[   17.996100] [drm:intel_connector_check_state], [CONNECTOR:5:LVDS-1]
[   17.996115] [drm:intel_connector_check_state], [CONNECTOR:11:SVIDEO-1]
[   17.996122] [drm:check_encoder_state], [ENCODER:6:LVDS-6]
[   17.996128] [drm:check_encoder_state], [ENCODER:10:DAC-10]
[   17.996133] [drm:check_encoder_state], [ENCODER:12:TV-12]
[   17.996139] [drm:check_crtc_state], [CRTC:3]
[   17.996155] [drm:intel_pipe_config_compare] *ERROR* mismatch in adjusted_mode.flags(DRM_MODE_FLAG_NHSYNC) (expected 2, found 0)
[   17.996160] ------------[ cut here ]------------
[   17.996176] WARNING: CPU: 0 PID: 1616 at drivers/gpu/drm/i915/intel_display.c:8769 check_crtc_state+0x5f8/0xbe0()
[   17.996179] pipe state doesn't match!
[   17.996182] Modules linked in: uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core videodev media arc4 snd_hda_codec_realtek ath5k snd_hda_intel snd_hda_codec ath mac80211 cfg80211 snd_hwdep snd_pcm snd_page_alloc rfkill snd_timer snd soundcore atl1e lpc_ich mfd_core rng_core acpi_cpufreq thermal processor ata_generic sata_vsc sata_sil24 pata_mpiix pata_oldpiix nls_iso8859_1 nls_cp850 vfat fat ums_usbat ums_sddr55 ums_sddr09 ums_onetouch ums_karma ums_jumpshot ums_isd200 ums_freecom ums_datafab ums_cypress ums_alauda usb_storage isofs sr_mod cdrom usbhid ohci_hcd uhci_hcd ehci_pci ehci_hcd xhci_hcd usbcore usb_common
[   17.996276] CPU: 0 PID: 1616 Comm: Xorg Tainted: G        W    3.12-pingu #1
[   17.996280] Hardware name: ASUSTeK Computer INC. 903/903, BIOS 0101    05/18/2008
[   17.996284]  00000009 c1663e65 f498f8f8 c1038e15 c18e08e9 f498f910 00000650 c1901e08
[   17.996295]  00002241 c1468a98 c1468a98 f64b9000 f64b964c 00000002 f661e678 c1038ed3
[   17.996306]  00000009 f498f8f8 c18e08e9 f498f910 c1468a98 c1901e08 00002241 c18e08e9
[   17.996317] Call Trace:
[   17.996329]  [<c1663e65>] ? dump_stack+0x48/0x6f
[   17.996338]  [<c1038e15>] ? warn_slowpath_common+0x85/0xb0
[   17.996345]  [<c1468a98>] ? check_crtc_state+0x5f8/0xbe0
[   17.996352]  [<c1468a98>] ? check_crtc_state+0x5f8/0xbe0
[   17.996359]  [<c1038ed3>] ? warn_slowpath_fmt+0x33/0x40
[   17.996366]  [<c1468a98>] ? check_crtc_state+0x5f8/0xbe0
[   17.996380]  [<c1473d3b>] ? intel_modeset_check_state+0x28b/0x780
[   17.996388]  [<c1474260>] ? intel_set_mode+0x30/0x40
[   17.996396]  [<c14755bf>] ? intel_get_load_detect_pipe+0x22f/0x3b0
[   17.996405]  [<c1497303>] ? intel_tv_detect+0x133/0x4e0
[   17.996414]  [<c1081f01>] ? log_store+0x111/0x260
[   17.996425]  [<c134d9f8>] ? drm_helper_probe_single_connector_modes+0x288/0x340
[   17.996434]  [<c135ecda>] ? drm_mode_getconnector+0x31a/0x370
[   17.996443]  [<c135e9c0>] ? drm_mode_getcrtc+0xb0/0xb0
[   17.996449]  [<c13521b6>] ? drm_ioctl+0x426/0x4b0
[   17.996457]  [<c135e9c0>] ? drm_mode_getcrtc+0xb0/0xb0
[   17.996466]  [<c100a53d>] ? fpu_finit+0x4d/0x60
[   17.996474]  [<c100b81a>] ? __restore_xstate_sig+0x35a/0x580
[   17.996481]  [<c1351d90>] ? drm_copy_field+0x70/0x70
[   17.996489]  [<c10fc237>] ? do_vfs_ioctl+0x77/0x560
[   17.996497]  [<c10fc76b>] ? SyS_ioctl+0x4b/0x80
[   17.996505]  [<c16698bc>] ? syscall_call+0x7/0xb
[   17.996510] ---[ end trace 247144411d041a23 ]---
[   17.996514] [drm:intel_dump_pipe_config], [CRTC:3][hw state] config for pipe A
[   17.996520] [drm:intel_dump_pipe_config], cpu_transcoder: A
[   17.996524] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
[   17.996528] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[   17.996534] [drm:intel_dump_pipe_config], requested mode:
[   17.996538] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 1280 0 0 0 1024 0 0 0 0x0 0x0
[   17.996546] [drm:intel_dump_pipe_config], adjusted mode:
[   17.996550] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 108000 0 0 0 0 0 0 0 0 0x0 0x0
[   17.996557] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[   17.996562] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[   17.996567] [drm:intel_dump_pipe_config], ips: 0
[   17.996571] [drm:intel_dump_pipe_config], [CRTC:3][sw state] config for pipe A
[   17.996576] [drm:intel_dump_pipe_config], cpu_transcoder: A
[   17.996580] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[   17.996584] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[   17.996590] [drm:intel_dump_pipe_config], requested mode:
[   17.996594] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   17.996602] [drm:intel_dump_pipe_config], adjusted mode:
[   17.996605] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 108000 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0xa
[   17.996613] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[   17.996618] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[   17.996623] [drm:intel_dump_pipe_config], ips: 0
[   17.996627] [drm:check_crtc_state], [CRTC:4]
[   18.032076] [drm:intel_tv_detect_type], TV detected: c0017, 7f0000aa
[   18.032091] [drm:intel_tv_detect_type], Unrecognised TV connection
[   18.052094] [drm:intel_release_load_detect_pipe], [CONNECTOR:11:SVIDEO-1], [ENCODER:12:TV-12]
[   18.052113] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 0, prepare: 0, disable: 1
[   18.092899] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[   18.092915] [drm:intel_calculate_wm], FIFO entries required for mode: 16
[   18.092921] [drm:intel_calculate_wm], FIFO watermark level: 10
[   18.092928] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[   18.092935] [drm:i9xx_update_wm], FIFO watermarks - A: 10, B: 29
[   18.092942] [drm:i9xx_update_wm], self-refresh entries: 64
[   18.092948] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 10, B: 29, C: 2, SR 63
[   18.092956] [drm:i9xx_update_wm], memory self refresh enabled
[   18.092973] [drm:intel_connector_check_state], [CONNECTOR:5:LVDS-1]
[   18.092983] [drm:check_encoder_state], [ENCODER:6:LVDS-6]
[   18.092991] [drm:check_encoder_state], [ENCODER:10:DAC-10]
[   18.092998] [drm:check_encoder_state], [ENCODER:12:TV-12]
[   18.093702] [drm:check_crtc_state], [CRTC:3]
[   18.093722] [drm:i9xx_crtc_clock_get], Unknown DPLL mode 00000000 in programmed mode
[   18.093729] [drm:check_crtc_state], [CRTC:4]
[   18.093954] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:11:SVIDEO-1] disconnected
[   18.129858] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   18.129876] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   18.129886] [drm:intel_lvds_detect], [CONNECTOR:5:LVDS-1]
[   18.129905] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
[   18.129914] [drm:drm_mode_debug_printmodeline], Modeline 26:"1024x600" 59 49180 1024 1044 1054 1344 600 602 605 625 0x8 0xa
[   18.129937] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   18.130702] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[   18.130715] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[   18.130723] [drm:intel_crt_detect], [CONNECTOR:9:VGA-1] force=1
[   18.144087] [drm:intel_crt_detect], CRT not detected via hotplug
[   18.148101] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[   18.148125] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   18.148172] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[   18.148180] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[   18.148500] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   18.148510] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[   18.148518] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   18.148529] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[   18.148560] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[   18.148571] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[   18.148579] [drm:intel_crt_detect], [CONNECTOR:9:VGA-1] force=1
[   18.164093] [drm:intel_crt_detect], CRT not detected via hotplug
[   18.168111] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[   18.168134] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   18.168143] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[   18.168150] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[   18.168676] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   18.168689] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[   18.168697] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   18.168707] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[   18.168815] [drm:drm_mode_getconnector], [CONNECTOR:11:?]
[   18.168826] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:11:SVIDEO-1]
[   18.168835] [drm:intel_tv_detect], [CONNECTOR:11:SVIDEO-1] force=1
[   18.168844] [drm:intel_get_load_detect_pipe], [CONNECTOR:11:SVIDEO-1], [ENCODER:12:TV-12]
[   18.168853] [drm:intel_get_load_detect_pipe], creating tmp fb for load-detection
[   18.168892] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 1, prepare: 1, disable: 0
[   18.168907] [drm:connected_sink_compute_bpp], [CONNECTOR:11:SVIDEO-1] checking for sink bpp constrains
[   18.168916] [drm:intel_tv_compute_config], forcing bpc to 8 for TV
[   18.168922] [drm:intel_modeset_pipe_config], plane bpp: 24, pipe bpp: 24, dithering: 0
[   18.168929] [drm:intel_dump_pipe_config], [CRTC:3][modeset] config for pipe A
[   18.168936] [drm:intel_dump_pipe_config], cpu_transcoder: A
[   18.168942] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[   18.168948] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[   18.168956] [drm:intel_dump_pipe_config], requested mode:
[   18.168962] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   18.168973] [drm:intel_dump_pipe_config], adjusted mode:
[   18.168979] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 108000 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0xa
[   18.168990] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[   18.168997] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[   18.169004] [drm:intel_dump_pipe_config], ips: 0
[   18.180339] [drm:i9xx_update_plane], Writing base 01810000 00000000 0 0 5120
[   18.180360] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[   18.180369] [drm:intel_calculate_wm], FIFO entries required for mode: 16
[   18.180375] [drm:intel_calculate_wm], FIFO watermark level: 10
[   18.180382] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[   18.180389] [drm:i9xx_update_wm], FIFO watermarks - A: 10, B: 29
[   18.180396] [drm:i9xx_update_wm], self-refresh entries: 64
[   18.180402] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 10, B: 29, C: 2, SR 63
[   18.180410] [drm:i9xx_update_wm], memory self refresh enabled
[   18.180419] [drm:intel_crtc_mode_set], [ENCODER:12:TV-12] set [MODE:0:NTSC 480i]
[   18.185460] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[   18.185477] [drm:intel_calculate_wm], FIFO entries required for mode: 16
[   18.185483] [drm:intel_calculate_wm], FIFO watermark level: 10
[   18.185490] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[   18.185497] [drm:intel_calculate_wm], FIFO entries required for mode: 34
[   18.185503] [drm:intel_calculate_wm], FIFO watermark level: -5
[   18.185508] [drm:i9xx_update_wm], FIFO watermarks - A: 10, B: 1
[   18.185515] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 10, B: 1, C: 2, SR 1
[   18.185523] [drm:i9xx_update_wm], memory self refresh disabled
[   18.204085] [drm:intel_connector_check_state], [CONNECTOR:5:LVDS-1]
[   18.204101] [drm:intel_connector_check_state], [CONNECTOR:11:SVIDEO-1]
[   18.204109] [drm:check_encoder_state], [ENCODER:6:LVDS-6]
[   18.204117] [drm:check_encoder_state], [ENCODER:10:DAC-10]
[   18.204125] [drm:check_encoder_state], [ENCODER:12:TV-12]
[   18.204133] [drm:check_crtc_state], [CRTC:3]
[   18.204155] [drm:intel_pipe_config_compare] *ERROR* mismatch in adjusted_mode.flags(DRM_MODE_FLAG_NHSYNC) (expected 2, found 0)
[   18.204161] ------------[ cut here ]------------
[   18.204178] WARNING: CPU: 1 PID: 1616 at drivers/gpu/drm/i915/intel_display.c:8769 check_crtc_state+0x5f8/0xbe0()
[   18.204183] pipe state doesn't match!
[   18.204187] Modules linked in: uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core videodev media arc4 snd_hda_codec_realtek ath5k snd_hda_intel snd_hda_codec ath mac80211 cfg80211 snd_hwdep snd_pcm snd_page_alloc rfkill snd_timer snd soundcore atl1e lpc_ich mfd_core rng_core acpi_cpufreq thermal processor ata_generic sata_vsc sata_sil24 pata_mpiix pata_oldpiix nls_iso8859_1 nls_cp850 vfat fat ums_usbat ums_sddr55 ums_sddr09 ums_onetouch ums_karma ums_jumpshot ums_isd200 ums_freecom ums_datafab ums_cypress ums_alauda usb_storage isofs sr_mod cdrom usbhid ohci_hcd uhci_hcd ehci_pci ehci_hcd xhci_hcd usbcore usb_common
[   18.204308] CPU: 1 PID: 1616 Comm: Xorg Tainted: G        W    3.12-pingu #1
[   18.204314] Hardware name: ASUSTeK Computer INC. 903/903, BIOS 0101    05/18/2008
[   18.204320]  00000009 c1663e65 f498f8f8 c1038e15 c18e08e9 f498f910 00000650 c1901e08
[   18.204335]  00002241 c1468a98 c1468a98 f64b9000 f64b964c 00000002 f661e678 c1038ed3
[   18.204349]  00000009 f498f8f8 c18e08e9 f498f910 c1468a98 c1901e08 00002241 c18e08e9
[   18.204364] Call Trace:
[   18.204380]  [<c1663e65>] ? dump_stack+0x48/0x6f
[   18.204393]  [<c1038e15>] ? warn_slowpath_common+0x85/0xb0
[   18.204405]  [<c1468a98>] ? check_crtc_state+0x5f8/0xbe0
[   18.204415]  [<c1468a98>] ? check_crtc_state+0x5f8/0xbe0
[   18.204426]  [<c1038ed3>] ? warn_slowpath_fmt+0x33/0x40
[   18.204436]  [<c1468a98>] ? check_crtc_state+0x5f8/0xbe0
[   18.204450]  [<c10607e0>] ? wakeup_preempt_entity.isra.54+0x80/0x90
[   18.204470]  [<c1473d3b>] ? intel_modeset_check_state+0x28b/0x780
[   18.204483]  [<c1474260>] ? intel_set_mode+0x30/0x40
[   18.204495]  [<c14755bf>] ? intel_get_load_detect_pipe+0x22f/0x3b0
[   18.204508]  [<c1497303>] ? intel_tv_detect+0x133/0x4e0
[   18.204520]  [<c1081f01>] ? log_store+0x111/0x260
[   18.204537]  [<c134d9f8>] ? drm_helper_probe_single_connector_modes+0x288/0x340
[   18.204551]  [<c135ecda>] ? drm_mode_getconnector+0x31a/0x370
[   18.204566]  [<c135e9c0>] ? drm_mode_getcrtc+0xb0/0xb0
[   18.204577]  [<c13521b6>] ? drm_ioctl+0x426/0x4b0
[   18.204589]  [<c135e9c0>] ? drm_mode_getcrtc+0xb0/0xb0
[   18.204604]  [<c100a53d>] ? fpu_finit+0x4d/0x60
[   18.204616]  [<c100b81a>] ? __restore_xstate_sig+0x35a/0x580
[   18.204628]  [<c1351d90>] ? drm_copy_field+0x70/0x70
[   18.204640]  [<c10fc237>] ? do_vfs_ioctl+0x77/0x560
[   18.204653]  [<c10fc76b>] ? SyS_ioctl+0x4b/0x80
[   18.204663]  [<c16698bc>] ? syscall_call+0x7/0xb
[   18.204672] ---[ end trace 247144411d041a24 ]---
[   18.204678] [drm:intel_dump_pipe_config], [CRTC:3][hw state] config for pipe A
[   18.204686] [drm:intel_dump_pipe_config], cpu_transcoder: A
[   18.204691] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
[   18.204696] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[   18.204704] [drm:intel_dump_pipe_config], requested mode:
[   18.204710] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 1280 0 0 0 1024 0 0 0 0x0 0x0
[   18.204721] [drm:intel_dump_pipe_config], adjusted mode:
[   18.204726] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 108000 0 0 0 0 0 0 0 0 0x0 0x0
[   18.204737] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[   18.204745] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[   18.204752] [drm:intel_dump_pipe_config], ips: 0
[   18.204759] [drm:intel_dump_pipe_config], [CRTC:3][sw state] config for pipe A
[   18.204767] [drm:intel_dump_pipe_config], cpu_transcoder: A
[   18.204773] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[   18.204780] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[   18.204789] [drm:intel_dump_pipe_config], requested mode:
[   18.204795] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   18.204806] [drm:intel_dump_pipe_config], adjusted mode:
[   18.204812] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 108000 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0xa
[   18.204824] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[   18.204833] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[   18.204841] [drm:intel_dump_pipe_config], ips: 0
[   18.204847] [drm:check_crtc_state], [CRTC:4]
[   18.260114] [drm:intel_tv_detect_type], TV detected: c0017, 7f0000aa
[   18.260138] [drm:intel_tv_detect_type], Unrecognised TV connection
[   18.276097] [drm:intel_release_load_detect_pipe], [CONNECTOR:11:SVIDEO-1], [ENCODER:12:TV-12]
[   18.276117] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 0, prepare: 0, disable: 1
[   18.318871] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[   18.318889] [drm:intel_calculate_wm], FIFO entries required for mode: 16
[   18.318895] [drm:intel_calculate_wm], FIFO watermark level: 10
[   18.318902] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[   18.318908] [drm:i9xx_update_wm], FIFO watermarks - A: 10, B: 29
[   18.318915] [drm:i9xx_update_wm], self-refresh entries: 64
[   18.318921] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 10, B: 29, C: 2, SR 63
[   18.318930] [drm:i9xx_update_wm], memory self refresh enabled
[   18.318955] [drm:intel_connector_check_state], [CONNECTOR:5:LVDS-1]
[   18.318966] [drm:check_encoder_state], [ENCODER:6:LVDS-6]
[   18.318974] [drm:check_encoder_state], [ENCODER:10:DAC-10]
[   18.318983] [drm:check_encoder_state], [ENCODER:12:TV-12]
[   18.318991] [drm:check_crtc_state], [CRTC:3]
[   18.319001] [drm:i9xx_crtc_clock_get], Unknown DPLL mode 00000000 in programmed mode
[   18.319008] [drm:check_crtc_state], [CRTC:4]
[   18.319411] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:11:SVIDEO-1] disconnected
[   18.320893] [drm:drm_mode_getconnector], [CONNECTOR:11:?]
[   18.320906] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:11:SVIDEO-1]
[   18.320914] [drm:intel_tv_detect], [CONNECTOR:11:SVIDEO-1] force=1
[   18.320924] [drm:intel_get_load_detect_pipe], [CONNECTOR:11:SVIDEO-1], [ENCODER:12:TV-12]
[   18.320932] [drm:intel_get_load_detect_pipe], creating tmp fb for load-detection
[   18.320964] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 1, prepare: 1, disable: 0
[   18.320978] [drm:connected_sink_compute_bpp], [CONNECTOR:11:SVIDEO-1] checking for sink bpp constrains
[   18.320987] [drm:intel_tv_compute_config], forcing bpc to 8 for TV
[   18.320993] [drm:intel_modeset_pipe_config], plane bpp: 24, pipe bpp: 24, dithering: 0
[   18.321001] [drm:intel_dump_pipe_config], [CRTC:3][modeset] config for pipe A
[   18.321008] [drm:intel_dump_pipe_config], cpu_transcoder: A
[   18.321014] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[   18.321020] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[   18.321028] [drm:intel_dump_pipe_config], requested mode:
[   18.321034] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   18.321046] [drm:intel_dump_pipe_config], adjusted mode:
[   18.321051] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 108000 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0xa
[   18.321062] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[   18.321069] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[   18.321076] [drm:intel_dump_pipe_config], ips: 0
[   18.333376] [drm:i9xx_update_plane], Writing base 01810000 00000000 0 0 5120
[   18.333397] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[   18.333407] [drm:intel_calculate_wm], FIFO entries required for mode: 16
[   18.333413] [drm:intel_calculate_wm], FIFO watermark level: 10
[   18.333419] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[   18.333426] [drm:i9xx_update_wm], FIFO watermarks - A: 10, B: 29
[   18.333433] [drm:i9xx_update_wm], self-refresh entries: 64
[   18.333439] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 10, B: 29, C: 2, SR 63
[   18.333447] [drm:i9xx_update_wm], memory self refresh enabled
[   18.333456] [drm:intel_crtc_mode_set], [ENCODER:12:TV-12] set [MODE:0:NTSC 480i]
[   18.338495] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[   18.338510] [drm:intel_calculate_wm], FIFO entries required for mode: 16
[   18.338517] [drm:intel_calculate_wm], FIFO watermark level: 10
[   18.338523] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[   18.338531] [drm:intel_calculate_wm], FIFO entries required for mode: 34
[   18.338537] [drm:intel_calculate_wm], FIFO watermark level: -5
[   18.338542] [drm:i9xx_update_wm], FIFO watermarks - A: 10, B: 1
[   18.338550] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 10, B: 1, C: 2, SR 1
[   18.338558] [drm:i9xx_update_wm], memory self refresh disabled
[   18.360123] [drm:intel_connector_check_state], [CONNECTOR:5:LVDS-1]
[   18.360140] [drm:intel_connector_check_state], [CONNECTOR:11:SVIDEO-1]
[   18.360149] [drm:check_encoder_state], [ENCODER:6:LVDS-6]
[   18.360158] [drm:check_encoder_state], [ENCODER:10:DAC-10]
[   18.360167] [drm:check_encoder_state], [ENCODER:12:TV-12]
[   18.360176] [drm:check_crtc_state], [CRTC:3]
[   18.360196] [drm:intel_pipe_config_compare] *ERROR* mismatch in adjusted_mode.flags(DRM_MODE_FLAG_NHSYNC) (expected 2, found 0)
[   18.360203] ------------[ cut here ]------------
[   18.360223] WARNING: CPU: 1 PID: 1616 at drivers/gpu/drm/i915/intel_display.c:8769 check_crtc_state+0x5f8/0xbe0()
[   18.360229] pipe state doesn't match!
[   18.360233] Modules linked in: uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core videodev media arc4 snd_hda_codec_realtek ath5k snd_hda_intel snd_hda_codec ath mac80211 cfg80211 snd_hwdep snd_pcm snd_page_alloc rfkill snd_timer snd soundcore atl1e lpc_ich mfd_core rng_core acpi_cpufreq thermal processor ata_generic sata_vsc sata_sil24 pata_mpiix pata_oldpiix nls_iso8859_1 nls_cp850 vfat fat ums_usbat ums_sddr55 ums_sddr09 ums_onetouch ums_karma ums_jumpshot ums_isd200 ums_freecom ums_datafab ums_cypress ums_alauda usb_storage isofs sr_mod cdrom usbhid ohci_hcd uhci_hcd ehci_pci ehci_hcd xhci_hcd usbcore usb_common
[   18.360360] CPU: 1 PID: 1616 Comm: Xorg Tainted: G        W    3.12-pingu #1
[   18.360368] Hardware name: ASUSTeK Computer INC. 903/903, BIOS 0101    05/18/2008
[   18.360374]  00000009 c1663e65 f498f8f8 c1038e15 c18e08e9 f498f910 00000650 c1901e08
[   18.360390]  00002241 c1468a98 c1468a98 f64b9000 f64b964c 00000002 f661e678 c1038ed3
[   18.360405]  00000009 f498f8f8 c18e08e9 f498f910 c1468a98 c1901e08 00002241 c18e08e9
[   18.360421] Call Trace:
[   18.360437]  [<c1663e65>] ? dump_stack+0x48/0x6f
[   18.360452]  [<c1038e15>] ? warn_slowpath_common+0x85/0xb0
[   18.360464]  [<c1468a98>] ? check_crtc_state+0x5f8/0xbe0
[   18.360473]  [<c1468a98>] ? check_crtc_state+0x5f8/0xbe0
[   18.360484]  [<c1038ed3>] ? warn_slowpath_fmt+0x33/0x40
[   18.360493]  [<c1468a98>] ? check_crtc_state+0x5f8/0xbe0
[   18.360514]  [<c1473d3b>] ? intel_modeset_check_state+0x28b/0x780
[   18.360526]  [<c1474260>] ? intel_set_mode+0x30/0x40
[   18.360538]  [<c14755bf>] ? intel_get_load_detect_pipe+0x22f/0x3b0
[   18.360552]  [<c1497303>] ? intel_tv_detect+0x133/0x4e0
[   18.360565]  [<c1081f01>] ? log_store+0x111/0x260
[   18.360581]  [<c134d9f8>] ? drm_helper_probe_single_connector_modes+0x288/0x340
[   18.360593]  [<c135ecda>] ? drm_mode_getconnector+0x31a/0x370
[   18.360605]  [<c135e9c0>] ? drm_mode_getcrtc+0xb0/0xb0
[   18.360613]  [<c13521b6>] ? drm_ioctl+0x426/0x4b0
[   18.360622]  [<c135e9c0>] ? drm_mode_getcrtc+0xb0/0xb0
[   18.360634]  [<c100a53d>] ? fpu_finit+0x4d/0x60
[   18.360644]  [<c100b81a>] ? __restore_xstate_sig+0x35a/0x580
[   18.360653]  [<c1351d90>] ? drm_copy_field+0x70/0x70
[   18.360664]  [<c10fc237>] ? do_vfs_ioctl+0x77/0x560
[   18.360675]  [<c10fc76b>] ? SyS_ioctl+0x4b/0x80
[   18.360687]  [<c16698bc>] ? syscall_call+0x7/0xb
[   18.360694] ---[ end trace 247144411d041a25 ]---
[   18.360702] [drm:intel_dump_pipe_config], [CRTC:3][hw state] config for pipe A
[   18.360709] [drm:intel_dump_pipe_config], cpu_transcoder: A
[   18.360714] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
[   18.360719] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[   18.360727] [drm:intel_dump_pipe_config], requested mode:
[   18.360733] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 1280 0 0 0 1024 0 0 0 0x0 0x0
[   18.360744] [drm:intel_dump_pipe_config], adjusted mode:
[   18.360749] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 108000 0 0 0 0 0 0 0 0 0x0 0x0
[   18.360761] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[   18.360768] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[   18.360776] [drm:intel_dump_pipe_config], ips: 0
[   18.360781] [drm:intel_dump_pipe_config], [CRTC:3][sw state] config for pipe A
[   18.360788] [drm:intel_dump_pipe_config], cpu_transcoder: A
[   18.360793] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[   18.360800] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[   18.360808] [drm:intel_dump_pipe_config], requested mode:
[   18.360814] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   18.360826] [drm:intel_dump_pipe_config], adjusted mode:
[   18.360831] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 108000 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0xa
[   18.360843] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[   18.360851] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[   18.360858] [drm:intel_dump_pipe_config], ips: 0
[   18.360865] [drm:check_crtc_state], [CRTC:4]
[   18.400096] [drm:intel_tv_detect_type], TV detected: c0017, 7f0000aa
[   18.400112] [drm:intel_tv_detect_type], Unrecognised TV connection
[   18.416104] [drm:intel_release_load_detect_pipe], [CONNECTOR:11:SVIDEO-1], [ENCODER:12:TV-12]
[   18.416122] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 0, prepare: 0, disable: 1
[   18.457518] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[   18.457535] [drm:intel_calculate_wm], FIFO entries required for mode: 16
[   18.457542] [drm:intel_calculate_wm], FIFO watermark level: 10
[   18.457548] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[   18.457555] [drm:i9xx_update_wm], FIFO watermarks - A: 10, B: 29
[   18.457562] [drm:i9xx_update_wm], self-refresh entries: 64
[   18.457569] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 10, B: 29, C: 2, SR 63
[   18.457577] [drm:i9xx_update_wm], memory self refresh enabled
[   18.457597] [drm:intel_connector_check_state], [CONNECTOR:5:LVDS-1]
[   18.457607] [drm:check_encoder_state], [ENCODER:6:LVDS-6]
[   18.457615] [drm:check_encoder_state], [ENCODER:10:DAC-10]
[   18.457623] [drm:check_encoder_state], [ENCODER:12:TV-12]
[   18.457631] [drm:check_crtc_state], [CRTC:3]
[   18.457640] [drm:i9xx_crtc_clock_get], Unknown DPLL mode 00000000 in programmed mode
[   18.457646] [drm:check_crtc_state], [CRTC:4]
[   18.457815] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:11:SVIDEO-1] disconnected
[   22.304198] [drm:intel_tv_detect], [CONNECTOR:11:SVIDEO-1] force=0
[   32.320185] [drm:intel_tv_detect], [CONNECTOR:11:SVIDEO-1] force=0
[   42.336142] [drm:intel_tv_detect], [CONNECTOR:11:SVIDEO-1] force=0

--------------060100010207040902090104--
