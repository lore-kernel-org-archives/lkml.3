Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab3BPGm3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 01:42:29 -0500
Received: from mail-vb0-f47.google.com ([209.85.212.47]:49039 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab3BPGm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 01:42:28 -0500
Date: Sat, 16 Feb 2013 01:42:22 -0500
From: tmhikaru@gmail.com
To: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: 3.2.38 most of the time has 100% cpu use reported
Message-ID: <20130216064222.GA2116@roll>
References: <1360160863.32217.30.camel@deadeye.wl.decadent.org.uk>
 <20130207173630.GA8355@roll>
 <20130208190819.GA16894@roll>
 <20130210151140.GA2307@roll>
 <20130212050116.GA2146@roll>
 <1360818247.5374.300.camel@deadeye.wl.decadent.org.uk>
 <20130216032327.GA2094@roll>
 <1360991890.5374.414.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <1360991890.5374.414.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 16, 2013 at 05:18:10AM +0000, Ben Hutchings wrote:
> Don't worry about it - I think the log messages are a pretty good clue.
>=20
> Does this patch fix the log messages and/or the other issues?
>=20

Yes! In fact after a quick reboot, the log lines look to me like they exist
properly, acpi looks like it's working properly, and most importantly my cpu
usage is normal.

One thing though:
> If not, can you report back the 'SMBIOS entry:' and 'DMI entry:' log
> lines this produces.

I don't see an SMBIOS entry line in the dmesg log output, though there IS a
DMI entry.  I take it that I should have seen an SMBIOS entry of some
kind...  I've included the entire output of dmesg just in case you would
find it useful below.  For all I know I missed something.

Tim McGrath

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.2.38 (root@roll) (gcc version 4.7.1 (GCC) ) =
#3 Sat Feb 16 01:12:31 EST 2013
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e8000 - 00000000000ea000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000005fff0000 (usable)
[    0.000000]  BIOS-e820: 000000005fff0000 - 000000005fff8000 (ACPI data)
[    0.000000]  BIOS-e820: 000000005fff8000 - 0000000060000000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffee0000 - 00000000fff00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
[    0.000000] Notice: NX (Execute Disable) protection missing in CPU!
[    0.000000] DMI entry: 5f 44 4d 49 5f 73 51 03 50 06 0f 00 19 00 23
[    0.000000] Legacy DMI 2.3 present.
[    0.000000] DMI: ECS M848A/M848A, BIOS 07.00T 04/02/01
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usab=
le) =3D=3D> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usab=
le)
[    0.000000] last_pfn =3D 0x5fff0 max_arch_pfn =3D 0x1000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask FC0000000 write-back
[    0.000000]   1 base 040000000 mask FE0000000 write-back
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 base 0D0000000 mask FF8000000 write-combining
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] initial memory mapped : 0 - 01c00000
[    0.000000] Base memory trampoline at [c009c000] 9c000 size 12288
[    0.000000] init_memory_mapping: 0000000000000000-0000000037bfe000
[    0.000000]  0000000000 - 0000200000 page 4k
[    0.000000]  0000200000 - 0037a00000 page 2M
[    0.000000]  0037a00000 - 0037bfe000 page 4k
[    0.000000] kernel direct mapping tables up to 37bfe000 @ 1bfa000-1c00000
[    0.000000] RAMDISK: 5fc59000 - 5fff0000
[    0.000000] Allocated new RAMDISK: 37867000 - 37bfd6a3
[    0.000000] Move RAMDISK from 000000005fc59000 - 000000005ffef6a2 to 378=
67000 - 37bfd6a2
[    0.000000] ACPI: RSDP 000fa260 00014 (v00 AMI   )
[    0.000000] ACPI: RSDT 5fff0000 0002C (v01 AMIINT SiS740XX 00001000 MSFT=
 0100000B)
[    0.000000] ACPI: FACP 5fff0030 00081 (v01 AMIINT SiS740XX 00000011 MSFT=
 0100000B)
[    0.000000] ACPI: DSDT 5fff0110 034D2 (v01    SiS      740 00000100 MSFT=
 0100000D)
[    0.000000] ACPI: FACS 5fff8000 00040
[    0.000000] ACPI: APIC 5fff00c0 00050 (v01 AMIINT SiS740XX 00001000 MSFT=
 0100000B)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 643MB HIGHMEM available.
[    0.000000] 891MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 37bfe000
[    0.000000]   low ram: 0 - 37bfe000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x00037bfe
[    0.000000]   HighMem  0x00037bfe -> 0x0005fff0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0005fff0
[    0.000000] On node 0 totalpages: 393087
[    0.000000] free_area_init_node: node 0, pgdat c14e7a08, node_mem_map f6=
c66200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3951 pages, LIFO batch:0
[    0.000000]   Normal zone: 1752 pages used for memmap
[    0.000000]   Normal zone: 222502 pages, LIFO batch:31
[    0.000000]   HighMem zone: 1288 pages used for memmap
[    0.000000]   HighMem zone: 163562 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000=
a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000=
e8000
[    0.000000] PM: Registered nosave memory: 00000000000e8000 - 00000000000=
ea000
[    0.000000] PM: Registered nosave memory: 00000000000ea000 - 00000000000=
f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 00000000001=
00000
[    0.000000] Allocating PCI resources starting at 60000000 (gap: 60000000=
:9ec00000)
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 390015
[    0.000000] Kernel command line: BOOT_IMAGE=3DLinuxOld ro root=3D801 vt.=
default_utf8=3D0
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 by=
tes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] allocated 6290944 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] Initializing HighMem for node 0 (00037bfe:0005fff0)
[    0.000000] Memory: 1543180k/1572800k available (3374k kernel code, 2916=
8k reserved, 1672k data, 472k init, 659400k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffa3000 - 0xfffff000   ( 368 kB)
[    0.000000]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
[    0.000000]     vmalloc : 0xf83fe000 - 0xffbfe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf7bfe000   ( 891 MB)
[    0.000000]       .init : 0xc14ee000 - 0xc1564000   ( 472 kB)
[    0.000000]       .data : 0xc134b83d - 0xc14edac0   (1672 kB)
[    0.000000]       .text : 0xc1000000 - 0xc134b83d   (3374 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: Genslabs=3D15, HWalign=3D32, Order=3D0-3, MinObjects=
=3D0, CPUs=3D1, Nodes=3D1
[    0.000000] NR_IRQS:2304 nr_irqs:256 16
[    0.000000] CPU 0 irqstacks, hard=3Df6008000 soft=3Df600a000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2083.129 MHz processor.
[    0.001002] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 4166.25 BogoMIPS (lpj=3D2083129)
[    0.002003] pid_max: default: 32768 minimum: 301
[    0.002116] Security Framework initialized
[    0.002226] Mount-cache hash table entries: 512
[    0.002519] Initializing cgroup subsys cpuacct
[    0.002596] Initializing cgroup subsys memory
[    0.002682] Initializing cgroup subsys devices
[    0.002756] Initializing cgroup subsys freezer
[    0.002829] Initializing cgroup subsys net_cls
[    0.002902] Initializing cgroup subsys blkio
[    0.003013] Initializing cgroup subsys perf_event
[    0.003124] CPU: CLK_CTL MSR was 6003d22f. Reprogramming to 2003d22f
[    0.003216] CPU: AMD Athlon(tm) XP 2800+ stepping 00
[    0.003368] ACPI: Core revision 20110623
[    0.006412] ftrace: allocating 19401 entries in 38 pages
[    0.008129] Performance Events: AMD PMU driver.
[    0.008250] ... version:                0
[    0.008320] ... bit width:              48
[    0.008390] ... generic registers:      4
[    0.008459] ... value mask:             0000ffffffffffff
[    0.008531] ... max period:             00007fffffffffff
[    0.009003] ... fixed-purpose events:   0
[    0.009072] ... event mask:             000000000000000f
[    0.009468] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.009843] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.019998] devtmpfs: initialized
[    0.019998] PM: Registering ACPI NVS region at 5fff8000 (32768 bytes)
[    0.019998] xor: automatically using best checksumming function: pIII_sse
[    0.024002]    pIII_sse  :  2264.000 MB/sec
[    0.024072] xor: using function: pIII_sse (2264.000 MB/sec)
[    0.024153] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.024510] print_constraints: dummy:=20
[    0.024691] NET: Registered protocol family 16
[    0.025197] ACPI: bus type pci registered
[    0.026630] PCI: PCI BIOS revision 2.10 entry at 0xfdb01, last bus=3D2
[    0.026705] PCI: Using configuration type 1 for base access
[    0.035580] bio: create slab <bio-0> at 0
[    0.052136] raid6: int32x1    441 MB/s
[    0.069083] raid6: int32x2    507 MB/s
[    0.086068] raid6: int32x4    570 MB/s
[    0.103008] raid6: int32x8    339 MB/s
[    0.119993] raid6: mmxx1     1457 MB/s
[    0.136989] raid6: mmxx2     2648 MB/s
[    0.154009] raid6: sse1x1    1562 MB/s
[    0.170993] raid6: sse1x2    2570 MB/s
[    0.171062] raid6: using algorithm sse1x2 (2570 MB/s)
[    0.171203] ACPI: Added _OSI(Module Device)
[    0.171275] ACPI: Added _OSI(Processor Device)
[    0.171346] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.171417] ACPI: Added _OSI(Processor Aggregator Device)
[    0.171998] ACPI: EC: Look up EC in DSDT
[    0.175424] ACPI: Interpreter enabled
[    0.175500] ACPI: (supports S0 S1 S4 S5)
[    0.175702] ACPI: Using IOAPIC for interrupt routing
[    0.177305] ACPI: Power Resource [FDDP] (off)
[    0.177745] ACPI: Power Resource [URP1] (off)
[    0.178267] ACPI: Power Resource [URP2] (off)
[    0.178933] ACPI: Power Resource [LPTP] (off)
[    0.182363] ACPI: No dock devices found.
[    0.182435] HEST: Table not found.
[    0.182507] PCI: Ignoring host bridge windows from ACPI; if necessary, u=
se "pci=3Duse_crs" and report a bug
[    0.182958] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.183177] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] =
(ignored)
[    0.183182] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] =
(ignored)
[    0.183187] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x00=
0bffff] (ignored)
[    0.183191] pci_root PNP0A03:00: host bridge window [mem 0x000cb000-0x00=
0dffff] (ignored)
[    0.183195] pci_root PNP0A03:00: host bridge window [mem 0x60000000-0xff=
dfffff] (ignored)
[    0.183199] pci_root PNP0A03:00: host bridge window [mem 0xfee01000-0xff=
dfffff] (ignored)
[    0.183222] pci 0000:00:00.0: [1039:0746] type 0 class 0x000600
[    0.183236] pci 0000:00:00.0: reg 10: [mem 0xd0000000-0xd7ffffff]
[    0.183312] pci 0000:00:01.0: [1039:0002] type 1 class 0x000604
[    0.183359] pci 0000:00:02.0: [1039:0008] type 0 class 0x000601
[    0.183427] pci 0000:00:02.0: Enabling SiS 96x SMBus
[    0.183520] pci 0000:00:02.1: [1039:0016] type 0 class 0x000c05
[    0.183566] pci 0000:00:02.1: reg 20: [io  0x0c00-0x0c1f]
[    0.183609] pci 0000:00:02.5: [1039:5513] type 0 class 0x000101
[    0.183659] pci 0000:00:02.5: reg 20: [io  0xff00-0xff0f]
[    0.183701] pci 0000:00:03.0: [1039:7001] type 0 class 0x000c03
[    0.183716] pci 0000:00:03.0: reg 10: [mem 0xcfffd000-0xcfffdfff]
[    0.183783] pci 0000:00:03.1: [1039:7001] type 0 class 0x000c03
[    0.183797] pci 0000:00:03.1: reg 10: [mem 0xcfffe000-0xcfffefff]
[    0.183870] pci 0000:00:03.2: [1039:7002] type 0 class 0x000c03
[    0.183888] pci 0000:00:03.2: reg 10: [mem 0xcffdf000-0xcffdffff]
[    0.184020] pci 0000:00:03.2: PME# supported from D0 D3hot D3cold
[    0.184026] pci 0000:00:03.2: PME# disabled
[    0.184054] pci 0000:00:04.0: [1039:0900] type 0 class 0x000200
[    0.184072] pci 0000:00:04.0: reg 10: [io  0xc800-0xc8ff]
[    0.184084] pci 0000:00:04.0: reg 14: [mem 0xcfffc000-0xcfffcfff]
[    0.184127] pci 0000:00:04.0: reg 30: [mem 0xcffa0000-0xcffbffff pref]
[    0.184155] pci 0000:00:04.0: supports D1 D2
[    0.184159] pci 0000:00:04.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.184164] pci 0000:00:04.0: PME# disabled
[    0.184191] pci 0000:00:0a.0: [1113:1211] type 0 class 0x000200
[    0.184209] pci 0000:00:0a.0: reg 10: [io  0xc400-0xc4ff]
[    0.184221] pci 0000:00:0a.0: reg 14: [mem 0xcffffd00-0xcffffdff]
[    0.184263] pci 0000:00:0a.0: reg 30: [mem 0xcffe0000-0xcffeffff pref]
[    0.184292] pci 0000:00:0a.0: supports D1 D2
[    0.184295] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.184301] pci 0000:00:0a.0: PME# disabled
[    0.184321] pci 0000:00:0b.0: [1095:3512] type 0 class 0x000106
[    0.184339] pci 0000:00:0b.0: reg 10: [io  0xdc00-0xdc07]
[    0.184350] pci 0000:00:0b.0: reg 14: [io  0xd800-0xd803]
[    0.184361] pci 0000:00:0b.0: reg 18: [io  0xd400-0xd407]
[    0.184372] pci 0000:00:0b.0: reg 1c: [io  0xd000-0xd003]
[    0.184383] pci 0000:00:0b.0: reg 20: [io  0xcc00-0xcc0f]
[    0.184394] pci 0000:00:0b.0: reg 24: [mem 0xcffffe00-0xcfffffff]
[    0.184405] pci 0000:00:0b.0: reg 30: [mem 0xcff00000-0xcff7ffff pref]
[    0.184433] pci 0000:00:0b.0: supports D1 D2
[    0.184454] pci 0000:00:0c.0: [1274:5880] type 0 class 0x000401
[    0.184472] pci 0000:00:0c.0: reg 10: [io  0xc000-0xc03f]
[    0.184547] pci 0000:00:0c.0: supports D2
[    0.184608] pci 0000:01:00.0: [1002:7142] type 0 class 0x000300
[    0.184637] pci 0000:01:00.0: reg 10: [mem 0xb0000000-0xbfffffff 64bit p=
ref]
[    0.184652] pci 0000:01:00.0: reg 18: [mem 0xcfdf0000-0xcfdfffff 64bit]
[    0.184663] pci 0000:01:00.0: reg 20: [io  0x8800-0x88ff]
[    0.184682] pci 0000:01:00.0: reg 30: [mem 0xcfdc0000-0xcfddffff pref]
[    0.184732] pci 0000:01:00.0: supports D1 D2
[    0.184759] pci 0000:01:00.1: [1002:7162] type 0 class 0x000380
[    0.184781] pci 0000:01:00.1: reg 10: [mem 0xcfde0000-0xcfdeffff 64bit]
[    0.184845] pci 0000:01:00.1: supports D1 D2
[    0.184888] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    0.184964] pci 0000:00:01.0:   bridge window [io  0x8000-0x8fff]
[    0.184970] pci 0000:00:01.0:   bridge window [mem 0xcfc00000-0xcfdfffff]
[    0.184976] pci 0000:00:01.0:   bridge window [mem 0xaf900000-0xcfafffff=
 pref]
[    0.184990] pci_bus 0000:00: on NUMA node 0
[    0.184995] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.185175]  pci0000:00: Unable to request _OSC control (_OSC support ma=
sk: 0x1e)
[    0.187666] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 10 *11 12 14 1=
5)
[    0.188111] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 7 10 11 12 14 1=
5)
[    0.188560] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 10 *11 12 14 1=
5)
[    0.189029] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 7 10 11 12 14 1=
5)
[    0.189476] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 7 10 11 12 14 1=
5)
[    0.189922] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 *5 7 10 11 12 14 1=
5)
[    0.190368] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 10 11 12 14 15=
) *0, disabled.
[    0.190917] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 *10 11 12 14 1=
5)
[    0.191575] vgaarb: device added: PCI:0000:01:00.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.191687] vgaarb: loaded
[    0.191755] vgaarb: bridge control possible 0000:01:00.0
[    0.192086] SCSI subsystem initialized
[    0.192318] libata version 3.00 loaded.
[    0.192449] usbcore: registered new interface driver usbfs
[    0.192583] usbcore: registered new interface driver hub
[    0.192714] usbcore: registered new device driver usb
[    0.193103] PCI: Using ACPI for IRQ routing
[    0.193205] PCI: pci_cache_line_size set to 32 bytes
[    0.193266] reserve RAM buffer: 000000000009fc00 - 000000000009ffff=20
[    0.193271] reserve RAM buffer: 000000005fff0000 - 000000005fffffff=20
[    0.195832] pnp: PnP ACPI init
[    0.195938] ACPI: bus type pnp registered
[    0.196163] pnp 00:00: [bus 00-ff]
[    0.196168] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.196172] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.196175] pnp 00:00: [io  0x0d00-0xffff window]
[    0.196179] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.196182] pnp 00:00: [mem 0x000cb000-0x000dffff window]
[    0.196186] pnp 00:00: [mem 0x60000000-0xffdfffff window]
[    0.196189] pnp 00:00: [mem 0xfee01000-0xffdfffff window]
[    0.196322] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.196430] pnp 00:01: [io  0x0010-0x001f]
[    0.196435] pnp 00:01: [io  0x0020-0x003f]
[    0.196445] pnp 00:01: [io  0x0044-0x005f]
[    0.196448] pnp 00:01: [io  0x0062-0x0063]
[    0.196451] pnp 00:01: [io  0x0065-0x006f]
[    0.196454] pnp 00:01: [io  0x0072-0x007f]
[    0.196457] pnp 00:01: [io  0x0080]
[    0.196459] pnp 00:01: [io  0x0084-0x0086]
[    0.196462] pnp 00:01: [io  0x0088]
[    0.196465] pnp 00:01: [io  0x008c-0x008e]
[    0.196468] pnp 00:01: [io  0x0090-0x009f]
[    0.196471] pnp 00:01: [io  0x00a0-0x00bf]
[    0.196473] pnp 00:01: [io  0x00e0-0x00ef]
[    0.196476] pnp 00:01: [io  0x0290-0x0297]
[    0.196479] pnp 00:01: [io  0x0480-0x048f]
[    0.196482] pnp 00:01: [io  0x04d0-0x04d1]
[    0.196485] pnp 00:01: [io  0x0c00-0x0c1f]
[    0.196488] pnp 00:01: [io  0x03f0-0x03f1]
[    0.196491] pnp 00:01: [mem 0xfee00000-0xfeefffff]
[    0.196618] system 00:01: [io  0x0290-0x0297] has been reserved
[    0.196694] system 00:01: [io  0x0480-0x048f] has been reserved
[    0.196768] system 00:01: [io  0x04d0-0x04d1] has been reserved
[    0.196842] system 00:01: [io  0x0c00-0x0c1f] has been reserved
[    0.196916] system 00:01: [io  0x03f0-0x03f1] has been reserved
[    0.196985] system 00:01: [mem 0xfee00000-0xfeefffff] could not be reser=
ved
[    0.197062] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.197096] pnp 00:02: [dma 4]
[    0.197099] pnp 00:02: [io  0x0000-0x000f]
[    0.197102] pnp 00:02: [io  0x0081-0x0083]
[    0.197105] pnp 00:02: [io  0x0087]
[    0.197108] pnp 00:02: [io  0x0089-0x008b]
[    0.197111] pnp 00:02: [io  0x008f]
[    0.197114] pnp 00:02: [io  0x00c0-0x00df]
[    0.197185] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.197204] pnp 00:03: [io  0x0070-0x0071]
[    0.197225] pnp 00:03: [irq 8]
[    0.197298] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.197313] pnp 00:04: [io  0x0061]
[    0.197390] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.197406] pnp 00:05: [io  0x00f0-0x00ff]
[    0.197413] pnp 00:05: [irq 13]
[    0.197484] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.197630] pnp 00:06: [io  0x03f2-0x03f3]
[    0.197634] pnp 00:06: [io  0x03f4-0x03f5]
[    0.197637] pnp 00:06: [io  0x03f7]
[    0.197643] pnp 00:06: [irq 6]
[    0.197646] pnp 00:06: [dma 2]
[    0.197749] pnp 00:06: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.198060] pnp 00:07: [io  0x03f8-0x03ff]
[    0.198067] pnp 00:07: [irq 4]
[    0.198207] pnp 00:07: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.198461] pnp 00:08: [io  0x02f8-0x02ff]
[    0.198468] pnp 00:08: [irq 3]
[    0.198600] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.199076] pnp 00:09: [io  0x0378-0x037f]
[    0.199080] pnp 00:09: [io  0x0778-0x077b]
[    0.199086] pnp 00:09: [irq 7]
[    0.199089] pnp 00:09: [dma 3]
[    0.199250] pnp 00:09: Plug and Play ACPI device, IDs PNP0401 (active)
[    0.199674] pnp: PnP ACPI: found 10 devices
[    0.199745] ACPI: ACPI bus type pnp unregistered
[    0.239952] Switching to clocksource acpi_pm
[    0.239993] PCI: max bus depth: 1 pci_try_num: 2
[    0.240012] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    0.240087] pci 0000:00:01.0:   bridge window [io  0x8000-0x8fff]
[    0.240164] pci 0000:00:01.0:   bridge window [mem 0xcfc00000-0xcfdfffff]
[    0.240242] pci 0000:00:01.0:   bridge window [mem 0xaf900000-0xcfafffff=
 pref]
[    0.240367] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    0.240370] pci_bus 0000:00: resource 1 [mem 0x00000000-0x3ffffffff]
[    0.240375] pci_bus 0000:01: resource 0 [io  0x8000-0x8fff]
[    0.240378] pci_bus 0000:01: resource 1 [mem 0xcfc00000-0xcfdfffff]
[    0.240382] pci_bus 0000:01: resource 2 [mem 0xaf900000-0xcfafffff pref]
[    0.240447] NET: Registered protocol family 2
[    0.240582] IP route cache hash table entries: 32768 (order: 5, 131072 b=
ytes)
[    0.241061] TCP established hash table entries: 131072 (order: 8, 104857=
6 bytes)
[    0.243887] TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
[    0.244492] TCP: Hash tables configured (established 131072 bind 65536)
[    0.244567] TCP reno registered
[    0.244638] UDP hash table entries: 512 (order: 1, 8192 bytes)
[    0.244727] UDP-Lite hash table entries: 512 (order: 1, 8192 bytes)
[    0.244949] NET: Registered protocol family 1
[    0.245189] RPC: Registered named UNIX socket transport module.
[    0.245263] RPC: Registered udp transport module.
[    0.245333] RPC: Registered tcp transport module.
[    0.245404] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.245540] pci 0000:00:03.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.318023] pci 0000:00:03.0: PCI INT A disabled
[    0.318110] pci 0000:00:03.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.380016] pci 0000:00:03.1: PCI INT B disabled
[    0.380102] pci 0000:00:03.2: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    0.380190] pci 0000:00:03.2: PCI INT D disabled
[    0.380279] pci 0000:01:00.0: Boot video device
[    0.380287] PCI: CLS 32 bytes, default 32
[    0.380390] Trying to unpack rootfs image as initramfs...
[    0.503728] Freeing initrd memory: 3676k freed
[    0.510694] Intel AES-NI instructions are not detected.
[    0.511180] audit: initializing netlink socket (disabled)
[    0.511273] type=3D2000 audit(1360995336.510:1): initialized
[    0.512020] highmem bounce pool size: 64 pages
[    0.517362] VFS: Disk quotas dquot_6.5.2
[    0.517545] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.518076] ROMFS MTD (C) 2007 Red Hat, Inc.
[    0.518234] msgmni has been set to 1733
[    0.519465] async_tx: api initialized (async)
[    0.519687] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 253)
[    0.519823] io scheduler noop registered
[    0.519894] io scheduler deadline registered
[    0.519972] io scheduler cfq registered (default)
[    0.520398] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.520865] ERST: Table is not found!
[    0.520936] GHES: HEST is not enabled!
[    0.521029] isapnp: Scanning for PnP cards...
[    0.877240] isapnp: No Plug & Play device found
[    0.881869] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.146094] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    1.410092] serial8250: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
[    1.431095] 00:07: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    1.451778] 00:08: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
[    1.452563] Floppy drive(s): fd0 is 1.44M
[    1.467184] FDC 0 is a post-1991 82077
[    1.471893] brd: module loaded
[    1.473553] sata_sil 0000:00:0b.0: version 2.4
[    1.473623] sata_sil 0000:00:0b.0: PCI INT A -> GSI 17 (level, low) -> I=
RQ 17
[    1.474270] scsi0 : sata_sil
[    1.474497] scsi1 : sata_sil
[    1.474696] ata1: SATA max UDMA/100 mmio m512@0xcffffe00 tf 0xcffffe80 i=
rq 17
[    1.474773] ata2: SATA max UDMA/100 mmio m512@0xcffffe00 tf 0xcffffec0 i=
rq 17
[    1.477233] pata_sis 0000:00:02.5: version 0.5.2
[    1.477275] pata_sis 0000:00:02.5: SiS 962/963 MuTIOL IDE UDMA133 contro=
ller
[    1.478085] scsi2 : pata_sis
[    1.478308] scsi3 : pata_sis
[    1.479177] ata3: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq=
 14
[    1.479254] ata4: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xff08 irq=
 15
[    1.480621] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    1.517382] Refined TSC clocksource calibration: 2083.095 MHz.
[    1.517461] Switching to clocksource tsc
[    1.517562] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.517914] mousedev: PS/2 mouse device common for all mice
[    1.518080] rtc_cmos 00:03: RTC can wake from S4
[    1.518355] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    1.518448] rtc0: alarms up to one month, 114 bytes nvram
[    1.518572] md: linear personality registered for level -1
[    1.518645] md: raid0 personality registered for level 0
[    1.518718] md: raid1 personality registered for level 1
[    1.518790] md: raid10 personality registered for level 10
[    1.518862] md: raid6 personality registered for level 6
[    1.518933] md: raid5 personality registered for level 5
[    1.519011] md: raid4 personality registered for level 4
[    1.519083] md: multipath personality registered for level -4
[    1.519283] device-mapper: uevent: version 1.0.3
[    1.519518] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised:=
 dm-devel@redhat.com
[    1.519724] cpuidle: using governor ladder
[    1.519796] cpuidle: using governor menu
[    1.519952] TCP cubic registered
[    1.520027] Initializing XFRM netlink socket
[    1.520112] NET: Registered protocol family 17
[    1.520200] Registering the dns_resolver key type
[    1.520286] Using IPI Shortcut mode
[    1.779017] ata1: SATA link down (SStatus 0 SControl 310)
[    2.084024] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[    2.103273] ata2.00: ATA-7: SAMSUNG HD103SI, 1AG01118, max UDMA7
[    2.103348] ata2.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.122260] ata2.00: configured for UDMA/100
[    2.122511] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD103SI  1A=
G0 PQ: 0 ANSI: 5
[    2.122930] sd 1:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 =
TB/931 GiB)
[    2.123114] sd 1:0:0:0: [sda] Write Protect is off
[    2.123187] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.123219] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    2.129162]  sda: sda1
[    2.129572] sd 1:0:0:0: [sda] Attached SCSI disk
[    2.277302] ata4.00: ATAPI: HL-DT-STDVD-RAM GSA-H55N, 1.03, max UDMA/66
[    2.283298] ata4.00: configured for UDMA/66
[    2.285822] scsi 3:0:0:0: CD-ROM            HL-DT-ST DVD-RAM GSA-H55N 1.=
03 PQ: 0 ANSI: 5
[    2.288553] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 =
cdda tray
[    2.288665] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.288940] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    2.289215] registered taskstats version 1
[    2.289846] rtc_cmos 00:03: setting system clock to 2013-02-16 06:15:39 =
UTC (1360995339)
[    2.290167] Freeing unused kernel memory: 472k freed
[    2.290926] Write protecting the kernel text: 3376k
[    2.291055] Write protecting the kernel read-only data: 1372k
[    2.312430] udevd[838]: starting version 182
[    3.613920] EXT4-fs (sda1): mounted filesystem with ordered data mode. O=
pts: (null)
[    4.477792] loop: module loaded
[    4.696030] udevd[1001]: starting version 182
[    5.384147] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0=
C0C:00/input/input0
[    5.384273] ACPI: Power Button [PWRB]
[    5.384450] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0=
C0E:00/input/input1
[    5.384565] ACPI: Sleep Button [SLPB]
[    5.384714] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input2
[    5.384825] ACPI: Power Button [PWRF]
[    5.441843] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    5.444628] parport_pc 00:09: reported by Plug and Play ACPI
[    5.444787] parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE]
[    5.536495] sis900.c: v1.08.10 Apr. 2 2006
[    5.536637] sis900 0000:00:04.0: PCI INT A -> GSI 19 (level, low) -> IRQ=
 19
[    5.537869] 0000:00:04.0: VIA 6103 PHY transceiver found at address 1.
[    5.547133] 0000:00:04.0: Using transceiver found at address 1 as default
[    5.548152] 8139too: 8139too Fast Ethernet driver 0.9.28
[    5.549135] eth0: SiS 900 PCI Fast Ethernet at 0xc800, IRQ 19, 00:19:21:=
9b:5b:e7
[    5.549303] 8139too 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IR=
Q 18
[    5.549787] 8139too 0000:00:0a.0: eth1: RealTek RTL8139 at 0xc400, 00:e0=
:29:9b:1a:15, IRQ 18
[    5.556584] udevd[1010]: renamed network interface eth0 to eth1
[    5.558537] udevd[1008]: renamed network interface eth1 to rename3
[    5.608959] udevd[1008]: renamed network interface rename3 to eth0
[    5.685731] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.685876] ehci_hcd 0000:00:03.2: PCI INT D -> GSI 23 (level, low) -> I=
RQ 23
[    5.685982] ehci_hcd 0000:00:03.2: EHCI Host Controller
[    5.686649] ehci_hcd 0000:00:03.2: new USB bus registered, assigned bus =
number 1
[    5.686838] ehci_hcd 0000:00:03.2: irq 23, io mem 0xcffdf000
[    5.692014] ehci_hcd 0000:00:03.2: USB 2.0 started, EHCI 1.00
[    5.692141] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    5.692217] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    5.692327] usb usb1: Product: EHCI Host Controller
[    5.692399] usb usb1: Manufacturer: Linux 3.2.38 ehci_hcd
[    5.692471] usb usb1: SerialNumber: 0000:00:03.2
[    5.692798] hub 1-0:1.0: USB hub found
[    5.692876] hub 1-0:1.0: 6 ports detected
[    5.699268] Linux agpgart interface v0.103
[    5.726032] sis96x_smbus 0000:00:02.1: SiS96x SMBus base address: 0x0c00
[    5.726165] ACPI: resource 0000:00:02.1 [io  0x0c00-0x0c1f] conflicts wi=
th ACPI region SMRG [io 0xc00-0xc1f]
[    5.726321] ACPI: If an ACPI driver is available for this device, you sh=
ould use it instead of the native driver
[    5.759065] ppdev: user-space parallel port driver
[    5.777400] agpgart-sis 0000:00:00.0: SiS chipset [1039/0746]
[    5.788180] agpgart-sis 0000:00:00.0: AGP aperture is 128M @ 0xd0000000
[    6.015994] [drm] Initialized drm 1.1.0 20060810
[    6.109638] [drm] radeon kernel modesetting enabled.
[    6.109875] radeon 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ=
 16
[    6.110320] [drm] initializing kernel modesetting (RV515 0x1002:0x7142 0=
x1002:0x030B).
[    6.110464] [drm] register mmio base: 0xCFDF0000
[    6.110536] [drm] register mmio size: 65536
[    6.112414] ATOM BIOS: PCP
[    6.112519] agpgart-sis 0000:00:00.0: AGP 3.0 bridge
[    6.112607] agpgart-sis 0000:00:00.0: putting AGP V3 device at 0000:00:0=
0.0 into 8x mode
[    6.112720] agpgart-sis 0000:00:00.0: SiS delay workaround: giving bridg=
e time to recover
[    6.130768] snd_ens1371 0000:00:0c.0: PCI INT A -> GSI 16 (level, low) -=
> IRQ 16
[    6.175076] agpgart-sis 0000:00:00.0: putting AGP V3 device at 0000:01:0=
0.0 into 8x mode
[    6.175209] radeon 0000:01:00.0: GTT: 128M 0xD0000000 - 0xD7FFFFFF
[    6.175289] [drm] Generation 2 PCI interface, using max accessible memory
[    6.175368] radeon 0000:01:00.0: VRAM: 256M 0x0000000000000000 - 0x00000=
0000FFFFFFF (256M used)
[    6.175531] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    6.175605] [drm] Driver supports precise vblank timestamp query.
[    6.175704] [drm] radeon: irq initialized.
[    6.176063] [drm] Detected VRAM RAM=3D256M, BAR=3D256M
[    6.176144] [drm] RAM width 128bits DDR
[    6.189066] [TTM] Zone  kernel: Available graphics memory: 443964 kiB.
[    6.189150] [TTM] Zone highmem: Available graphics memory: 773664 kiB.
[    6.189224] [TTM] Initializing pool allocator.
[    6.189344] [drm] radeon: 256M of VRAM memory ready
[    6.189416] [drm] radeon: 128M of GTT memory ready.
[    6.189513] [drm] GART: num cpu pages 32768, num gpu pages 32768
[    6.198099] [drm] radeon: 1 quad pipes, 1 z pipes initialized.
[    6.206853] radeon 0000:01:00.0: WB disabled
[    6.208639] [drm] Loading R500 Microcode
[    6.269861] [drm] radeon: ring at 0x00000000D0001000
[    6.269970] [drm] ring test succeeded in 9 usecs
[    6.270412] [drm] radeon: ib pool ready.
[    6.270739] [drm] ib test succeeded in 0 usecs
[    6.272668] [drm] Radeon Display Connectors
[    6.272741] [drm] Connector 0:
[    6.272810] [drm]   VGA
[    6.272879] [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4=
c 0x7e4c
[    6.272987] [drm]   Encoders:
[    6.273063] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    6.273134] [drm] Connector 1:
[    6.273202] [drm]   S-video
[    6.273270] [drm]   Encoders:
[    6.273337] [drm]     TV1: INTERNAL_KLDSCP_DAC2
[    6.273408] [drm] Connector 2:
[    6.273475] [drm]   DVI-I
[    6.273542] [drm]   HPD2
[    6.273610] [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5=
c 0x7e5c
[    6.273719] [drm]   Encoders:
[    6.273786] [drm]     CRT2: INTERNAL_KLDSCP_DAC2
[    6.273857] [drm]     DFP3: INTERNAL_LVTM1
[    6.415356] [drm] fb mappable at 0xB0060000
[    6.415435] [drm] vram apper at 0xB0000000
[    6.415505] [drm] size 5300224
[    6.415573] [drm] fb depth is 24
[    6.415641] [drm]    pitch is 5888
[    6.415978] fbcon: radeondrmfb (fb0) is primary device
[    6.450268] Console: switching to colour frame buffer device 180x56
[    6.479613] fb0: radeondrmfb frame buffer device
[    6.479766] drm: registered panic notifier
[    6.480059] [drm] Initialized radeon 2.12.0 20080528 for 0000:01:00.0 on=
 minor 0
[    6.488621] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    7.479485] ohci_hcd 0000:00:03.0: PCI INT A -> GSI 20 (level, low) -> I=
RQ 20
[    7.479772] ohci_hcd 0000:00:03.0: OHCI Host Controller
[    7.480018] ohci_hcd 0000:00:03.0: new USB bus registered, assigned bus =
number 2
[    7.480302] ohci_hcd 0000:00:03.0: irq 20, io mem 0xcfffd000
[    7.533062] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    7.533307] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    7.533550] usb usb2: Product: OHCI Host Controller
[    7.533712] usb usb2: Manufacturer: Linux 3.2.38 ohci_hcd
[    7.533892] usb usb2: SerialNumber: 0000:00:03.0
[    7.534636] hub 2-0:1.0: USB hub found
[    7.534774] hub 2-0:1.0: 3 ports detected
[    7.535025] ohci_hcd 0000:00:03.1: PCI INT B -> GSI 21 (level, low) -> I=
RQ 21
[    7.535301] ohci_hcd 0000:00:03.1: OHCI Host Controller
[    7.536252] ohci_hcd 0000:00:03.1: new USB bus registered, assigned bus =
number 3
[    7.536543] ohci_hcd 0000:00:03.1: irq 21, io mem 0xcfffe000
[    7.589098] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    7.589340] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    7.589582] usb usb3: Product: OHCI Host Controller
[    7.589744] usb usb3: Manufacturer: Linux 3.2.38 ohci_hcd
[    7.589924] usb usb3: SerialNumber: 0000:00:03.1
[    7.593795] hub 3-0:1.0: USB hub found
[    7.593946] hub 3-0:1.0: 3 ports detected
[    7.891029] usb 2-2: new full-speed USB device number 2 using ohci_hcd
[    7.948908] fuse init (API version 7.17)
[    8.081010] usb 2-2: New USB device found, idVendor=3D058f, idProduct=3D=
9254
[    8.087947] usb 2-2: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D0
[    8.095230] usb 2-2: Product: Generic USB Hub
[    8.102430] usb 2-2: Manufacturer: ALCOR
[    8.113141] hub 2-2:1.0: USB hub found
[    8.123018] hub 2-2:1.0: 4 ports detected
[    8.415246] EXT4-fs (sda1): re-mounted. Opts: acl,user_xattr
[    8.434999] usb 2-2.1: new low-speed USB device number 3 using ohci_hcd
[    8.541985] usb 2-2.1: New USB device found, idVendor=3D046d, idProduct=
=3Dc31c
[    8.550002] usb 2-2.1: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[    8.558076] usb 2-2.1: Product: USB Keyboard
[    8.566110] usb 2-2.1: Manufacturer: Logitech
[    8.656008] usb 2-2.2: new full-speed USB device number 4 using ohci_hcd
[    8.770981] usb 2-2.2: New USB device found, idVendor=3D046d, idProduct=
=3Dc245
[    8.779340] usb 2-2.2: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[    8.787731] usb 2-2.2: Product: Gaming Mouse G400
[    8.796090] usb 2-2.2: Manufacturer: Logitech
[    8.879018] usb 2-2.3: new low-speed USB device number 5 using ohci_hcd
[    8.990003] usb 2-2.3: New USB device found, idVendor=3D10d5, idProduct=
=3D55a2
[    8.998435] usb 2-2.3: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D3
[    9.006773] usb 2-2.3: Product: 2Port KVMSwicther
[    9.015012] usb 2-2.3: Manufacturer: No brand
[    9.023154] usb 2-2.3: SerialNumber: 0=12=C2=92
[    9.393689] input: Logitech USB Keyboard as /devices/pci0000:00/0000:00:=
03.0/usb2/2-2/2-2.1/2-2.1:1.0/input/input3
[    9.404196] generic-usb 0003:046D:C31C.0001: input,hidraw0: USB HID v1.1=
0 Keyboard [Logitech USB Keyboard] on usb-0000:00:03.0-2.1/input0
[    9.431130] input: Logitech USB Keyboard as /devices/pci0000:00/0000:00:=
03.0/usb2/2-2/2-2.1/2-2.1:1.1/input/input4
[    9.441179] generic-usb 0003:046D:C31C.0002: input,hidraw1: USB HID v1.1=
0 Device [Logitech USB Keyboard] on usb-0000:00:03.0-2.1/input1
[    9.456519] input: Logitech Gaming Mouse G400 as /devices/pci0000:00/000=
0:00:03.0/usb2/2-2/2-2.2/2-2.2:1.0/input/input5
[    9.466711] generic-usb 0003:046D:C245.0003: input,hidraw2: USB HID v1.1=
0 Mouse [Logitech Gaming Mouse G400] on usb-0000:00:03.0-2.2/input0
[    9.491314] generic-usb 0003:046D:C245.0004: hiddev0,hidraw3: USB HID v1=
=2E10 Device [Logitech Gaming Mouse G400] on usb-0000:00:03.0-2.2/input1
[    9.515102] input: No brand 2Port KVMSwicther as /devices/pci0000:00/000=
0:00:03.0/usb2/2-2/2-2.3/2-2.3:1.0/input/input6
[    9.528845] generic-usb 0003:10D5:55A2.0005: input,hidraw4: USB HID v1.1=
0 Keyboard [No brand 2Port KVMSwicther] on usb-0000:00:03.0-2.3/input0
[    9.542171] usbhid 2-2.3:1.1: couldn't find an input interrupt endpoint
[    9.553382] usbcore: registered new interface driver usbhid
[    9.563851] usbhid: USB HID core driver
[   13.373287] PPP generic driver version 2.4.2
[   13.447110] usbcore: registered new interface driver snd-usb-audio
[   13.469967] uhci_hcd: USB Universal Host Controller Interface driver
[   13.497923] input: PC Speaker as /devices/platform/pcspkr/input/input7
[   13.961435] it87: Found IT8705F chip at 0x290, revision 3
[   19.304901] Adding 2047996k swap on /swap.  Priority:-1 extents:33 acros=
s:63414268k=20
[   22.074116] 8139too 0000:00:0a.0: eth0: link down
[   31.781442] NET: Registered protocol family 10
[   31.781849] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   36.958602] eth1: Media Link On 100mbps full-duplex
[   38.333024] PPP BSD Compression module registered
[   39.361044] ip_tables: (C) 2000-2006 Netfilter Core Team
[   39.373091] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   44.178023] eth1: no IPv6 routers present

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEVAwUBUR8qTpEncCrqzVruAQIGKwgAuZhP+Zhi3yLWlaU1taM6sVQXG6Cywh7z
1oIltOyQeteUOsRdX/NYFPneoGzM3881IZhkvcY1VKrMmLnDMu3x+3VobGTJrhxG
Qd+gXwqIAfjinis3NfXWZaS9aNuCtRrJ30vM4lAeoK/mxbV3UjA9GdezhXNck+xO
HzkVIbYFslZs+rdFSssJsCjMdeoNWuF+cqmPKGiHfa6MbKmVVqwdsfAxZSh3qr0R
6w1Gsxh/Y3Qg+HEJqopEWNhbvU3g0gqic6Ub2qWQCxg+90Fo4GjtqCoGZWYJW+vq
eRnvHQkYIWb1pA6KI140X2ee0+n72RttA5+QCIIbS8ueJptptfdmgQ==
=iYAp
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
