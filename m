Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab3GaJ6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 05:58:37 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:3903 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775Ab3GaJ6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 05:58:30 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
Message-ID: <51F8DFAB.2000405@broadcom.com>
Date: Wed, 31 Jul 2013 11:58:03 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Ben Skeggs" <bskeggs@redhat.com>
cc: "David Airlie" <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: 3.11-rc2: lockdep warning in nouveau driver
X-WSS-ID: 7DE6015931W71658267-01-01
Content-Type: multipart/mixed;
 boundary=------------030307030104090500060202
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--------------030307030104090500060202
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit

I am getting used to getting a lockdep splat after every kernel merge 
window. If I recall it I have seen this in -rc1 as well. The lockdep 
warning in the attached log is seen upon shutting down the kernel and it 
completes it so it probably just needs proper lockdep annotation.

Regards,
Arend

--------------030307030104090500060202
Content-Type: text/plain;
 name=lpdev.log
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename=lpdev.log

=1C=1C=1C=E0=1C=FC=E0=1C=FC=1C=E0=E0=1C=FC=1C=1C=FC=1C=1C=1C=1C=1C=1C=1C=FC=
=E0=E0=1C=E0=1C=1C=1C=1C=1C=1C=1C=1C=1C=1C=1C=FC=1C=E0=FC=1C=E0=1C=E0=1C=E0=
=FC=E0=1C=1C=1C=1C=FC=1C=1C=1C=1C=1C=FC=1C=E0=1C=E0=1C=1C=1C=1C=1C=1C=1C=FC=
=1C=E0=1C=1C=1C=E0=1C=1C=1C=1C=FC=E0=1C=E0=1C=1C=1C=1C=E0=E0=1C=1C=1C=E0=FC=
=1C=1C=1C=1C=1C=1C=1C=FC=E0=1C=E0=FC=1C=E0=E0=E0=1C=E0=FC=1C=1C=1C=E0=1C=1C=
=1C=1C=1C=1C=1C=1C=1C=FC=1C=E0=1C=1C=FC=FC=E0=FC=1C=FC=FC=1C=1C=1C=FC=E0=1C=
=1C=E0=FC=1C=FC=1C=FC=FC=FC=E0=1C=1C=E0=1C=1C=FC=1C=1C=E0=FC=1C=FC=1C=FC=FC=
=E0=FC=1C=1C=E0=E0=FC=1C=E0=1C=1C=E0=1C=1C=1C=E0=1C=E0=FC=E0=FC=1C=1C=FC=E0=
=FC=E0=1C=1C=FC=FC=E0=1C=E0=1C=E0=FC=1C=FC=1C=1C=1C=1C=E0=1C=1C=E0=1C=E0=E0=
=FC=1C=1C=1C=1C=FC=1C=E0=FC=1C=FC=1C=1C=1C=1C=E0=1C=1C=E0=1C=E0=E0=FC=1C=1C=
=1C=1C=1C=FC=1C=E0=FC=1C=FC=1C=1C=1C=1C=E0=1C=1C=E0=1C=E0=E0=FC=1C=1C=1C=1C=
=1C=FC=1C=E0=FC=1C=FC=1C=1C=1C=1C=E0=1C=1C=E0=1C=E0=E0=FC=1C=E0=1C=1C=1C=FC=
=1C=E0=FC=1C=FC=1C=1C=1C=1C=E0=1C=1C=E0=1C=E0=E0=FC=1C=FC=1C=1C=1C=FC=1C=E0=
=FC=1C=FC=1C=1C=1C=1C=E0=1C=1C=E0=1C=E0=E0=FC=1C=E0=FC=E0=1C=E0=1C=E0=FC=1C=
=FC=1C=1C=1C=1C=E0=1C=1C=E0=1C=E0=E0=FC=1C=1C=E0=FC=E0=1C=E0=1C=E0=FC=1C=FC=
=1C=1C=1C=1C=E0=1C=1C=E0=1C=E0=E0=FC=1C=E0=E0=FC=E0=1C=E0=1C=E0=FC=1C=FC=1C=
=1C=1C=1C=E0=1C=1C=E0=1C=E0=E0=FC=1C=E0=FC=FC=E0=1C=E0=1C=E0=FC=1C=FC=1C=1C=
=1C=1C=E0=1C=1C=E0=1C=E0=E0=FC=1C=FC=FC=E0=1C=E0=1C=E0=FC=1C=FC=1C=1C=1C=1C=
=E0=1C=1C=E0=1C=E0=E0=FC=FC=1C=1C=1C=FC=1C=E0=FC=1C=FC=1C=1C=1C=1C=E0=1C=1C=
=E0=1C=E0=E0=FC=FC=FC=FC=E0=FC=1C=1C=1C=E0=1C=FC=E0=1C=FC=1C=E0=E0=1C=FC=1C=
=1C=FC=1C=1C=1C=1C=1C=1C=1C=FC=E0=E0=1C=E0=1C=1C=1C=1C=1C=1C=1C=1C=1C=1C=1C=
=FC=1C=E0=FC=1C=E0=1C=E0=1C=E0=FC=E0=1C=1C=1C=1C=FC=1C=1C=1C=1C=1C=FC=1C=E0=
=1C=E0=1C=1C=1C=1C=1C=1C=1C=FC=1C=E0=1C=1C=1C=E0=1C=1C=1C=1C=FC=E0=1C=E0=1C=
=1C=1C=1C=E0=E0=1C=1C=1C=E0=FC=1C=1C=1C=1C=1C=1C=1C=FC=E0=1C=E0=FC=1C=E0=E0=
=E0=1C=E0=FC=1C=1C=1C=E0=1C=1C=1C=1C=1C=1C=1C=1C=1C=FC=1C=E0=1C=1C=FC=FC=E0=
=FC=1C=FC=FC=1C=1C=1C=FC=E0=1C=1C=E0=FC=1C=FC=1C=FC=FC=FC=E0=1C=1C=E0=1C=1C=
=FC=1C=1C=E0=FC=1C=FC=1C=FC=FC=E0=FC=1C=1C=E0=E0=FC=1C=E0=1C=1C=E0=1C=1C=1C=
=E0=1C=E0=FC=E0=FC=1C=1C=FC=E0=FC=E0=1C=1C=FC=FC=E0=1C=E0=1C=E0=FC=1C=FC=1C=
=1C=1C=1C=E0=1C=1C=E0=1C=E0=E0=FC=1C=1C=1C=1C=FC=1C=E0=FC=1C=FC=1C=1C=1C=1C=
=E0=1C=1C=E0=1C=E0=E0=FC=1C=1C=1C=1C=1C=FC=1C=E0=FC=1C=FC=1C=1C=1C=1C=E0=1C=
=1C=E0=1C=E0=E0=FC=1C=1C=1C=1C=1C=FC=1C=E0=FC=1C=FC=1C=1C=1C=1C=E0=1C=1C=E0=
=1C=E0=E0=FC=1C=E0=1C=1C=1C=FC=1C=E0=FC=1C=FC=1C=1C=1C=1C=E0=1C=1C=E0=1C=E0=
=E0=FC=1C=FC=1C=1C=1C=FC=1C=E0=FC=1C=FC=1C=1C=1C=1C=E0=1C=1C=E0=1C=E0=E0=FC=
=1C=E0=FC=E0=1C=E0=1C=E0=FC=1C=FC=1C=1C=1C=1C=E0=1C=1C=E0=1C=E0=E0=FC=1C=1C=
=E0=FC=E0=1C=E0=1C=E0=FC=1C=FC=1C=1C=1C=1C=E0=1C=1C=E0=1C=E0=E0=FC=1C=E0=E0=
=FC=E0=1C=E0=1C=E0=FC=1C=FC=1C=1C=1C=1C=E0=1C=1C=E0=1C=E0=E0=FC=1C=E0=FC=FC=
=E0=1C=E0=1C=E0=FC=1C=FC=1C=1C=1C=1C=E0=1C=1C=E0=1C=E0=E0=FC=1C=FC=FC=E0=1C=
=E0=1C=E0=FC=1C=FC=1C=1C=1C=1C=E0=1C=1C=E0=1C=E0=E0=FC=FC=1C=1C=1C=FC=1C=E0=
=FC=1C=FC=1C=1C=1C=1C=E0=1C=1C=E0=1C=E0=E0=FC=FC=FC=FC=E0=FC[    0.000000=
] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.11.0-rc2-wl-testing-lockdep-00001-gbf7b638=
-dirty (root@arend-ubuntu-1) (gcc version 4.7.2 (Ubuntu/Linaro 4.7.2-2ubu=
ntu1) ) #2 SMP Thu Jul 25 10:16:26 CEST 2013
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009abff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x000000000009ac00-0x000000000009ffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000cf65efff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x00000000cf65f000-0x00000000cf67efff] ACP=
I data
[    0.000000] BIOS-e820: [mem 0x00000000cf67f000-0x00000000cf76efff] ACP=
I NVS
[    0.000000] BIOS-e820: [mem 0x00000000cf76f000-0x00000000cfffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed13fff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fed18000-0x00000000fed19fff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000012bffffff] usa=
ble
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled:=
 non-PAE kernel!
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI: Dell Inc. Latitude E6410/07XJP9, BIOS A07 02/15/2011
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> re=
served
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xcf65f max_arch_pfn =3D 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 base 0C0000000 mask FF0000000 write-back
[    0.000000]   3 base 100000000 mask FE0000000 write-back
[    0.000000]   4 base 120000000 mask FF0000000 write-back
[    0.000000]   5 base 12C000000 mask FFC000000 uncachable
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600=
070106
[    0.000000] e820: update [mem 0xd0000000-0xffffffff] usable =3D=3D> re=
served
[    0.000000] found SMP MP-table at [mem 0x000f2200-0x000f220f] mapped a=
t [c00f2200]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x023fffff]
[    0.000000] Base memory trampoline at [c0096000] 96000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x36800000-0x36bfffff]
[    0.000000]  [mem 0x36800000-0x36bfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x30000000-0x367fffff]
[    0.000000]  [mem 0x30000000-0x367fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x2fffffff]
[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x2fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x36c00000-0x377fdfff]
[    0.000000]  [mem 0x36c00000-0x373fffff] page 2M
[    0.000000]  [mem 0x37400000-0x377fdfff] page 4k
[    0.000000] BRK [0x01ded000, 0x01dedfff] PGTABLE
[    0.000000] RAMDISK: [mem 0x36c92000-0x37640fff]
[    0.000000] ACPI: RSDP 000fe300 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT cf67de18 00064 (v01 DELL    E2      06222004 MS=
FT 00010013)
[    0.000000] ACPI: FACP cf75fc18 000F4 (v04 DELL    E2      06222004 MS=
FT 00010013)
[    0.000000] ACPI Warning: 32/64 FACS address mismatch in FADT - two FA=
CS tables! (20130517/tbfadt-395)
[    0.000000] ACPI BIOS Warning (bug): 32/64X FACS address mismatch in F=
ADT - 0xCF76BF40/0x00000000CF76ED40, using 32 (20130517/tbfadt-522)
[    0.000000] ACPI: DSDT cf73e018 0A24E (v01 DELL    E2      00001001 IN=
TL 20080729)
[    0.000000] ACPI: FACS cf76bf40 00040
[    0.000000] ACPI: APIC cf67cf18 0008C (v02 DELL    E2      06222004 MS=
FT 00010013)
[    0.000000] ACPI: TCPA cf76dd18 00032 (v02                 00000000   =
   00000000)
[    0.000000] ACPI: MCFG cf76dc98 0003C (v01 A M I  GMCH945. 06222004 MS=
FT 00000097)
[    0.000000] ACPI: HPET cf76dc18 00038 (v01 DELL    E2      00000001 AS=
L  00000061)
[    0.000000] ACPI: BOOT cf76db98 00028 (v01 DELL   E2       06222004 AM=
I  00010013)
[    0.000000] ACPI: SLIC cf766818 00176 (v03 DELL    E2      06222004 MS=
FT 00010013)
[    0.000000] ACPI: SSDT cf74d018 009F1 (v01  PmRef    CpuPm 00003000 IN=
TL 20080729)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 2430MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000] BRK [0x01dee000, 0x01deefff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x377fdfff]
[    0.000000]   HighMem  [mem 0x377fe000-0xcf65efff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x00099fff]
[    0.000000]   node   0: [mem 0x00100000-0xcf65efff]
[    0.000000] On node 0 totalpages: 849400
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3993 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 223230 pages, LIFO batch:31
[    0.000000]   HighMem zone: 4861 pages used for memmap
[    0.000000]   HighMem zone: 622177 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x04] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x06] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI =
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level=
)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009a000-0x0009afff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009b000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] e820: [mem 0xd0000000-0xf7ffffff] available for PCI device=
s
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_=
node_ids:1
[    0.000000] PERCPU: Embedded 14 pages/cpu @f53a2000 s34112 r0 d23232 u=
57344
[    0.000000] pcpu-alloc: s34112 r0 d23232 u57344 alloc=3D14*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 [0] 4 [0] 5 [0] 6 [0] =
7=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  To=
tal pages: 847624
[    0.000000] Kernel command line: BOOT_IMAGE=3D/boot/vmlinuz-3.11.0-rc2=
-wl-testing-lockdep-00001-gbf7b638-dirty root=3DUUID=3D7051116f-03ec-4df3=
-a8ff-813fb03aec9f ro ignore_loglevel console=3Dtty0 console=3DttyS0,1152=
00
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 =
bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 by=
tes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (000377fe:000cf65f)
[    0.000000] Memory: 3345268K/3397600K available (5315K kernel code, 49=
6K rwdata, 2160K rodata, 612K init, 5608K bss, 52332K reserved, 2488708K =
highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff16000 - 0xfffff000   ( 932 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc17cb000 - 0xc1864000   ( 612 kB)
[    0.000000]       .data : 0xc1531128 - 0xc17ca260   (2660 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1531128   (5316 kB)
[    0.000000] Checking if this processor honours the WP bit even in supe=
rvisor mode...Ok.
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D8,=
 Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:2304 nr_irqs:744 16
[    0.000000] CPU 0 irqstacks, hard=3Df4c0c000 soft=3Df4c0e000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc=
=2E, Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3567 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.004000] tsc: Detected 2793.069 MHz processor
[    0.000001] Calibrating delay loop (skipped), value calculated using t=
imer frequency.. 5586.13 BogoMIPS (lpj=3D11172276)
[    0.010711] pid_max: default: 32768 minimum: 301
[    0.015404] Security Framework initialized
[    0.019513] AppArmor: AppArmor initialized
[    0.023626] Mount-cache hash table entries: 512
[    0.028850] Initializing cgroup subsys devices
[    0.033326] Initializing cgroup subsys freezer
[    0.037790] Initializing cgroup subsys net_cls
[    0.042278] CPU: Physical Processor ID: 0
[    0.046294] CPU: Processor Core ID: 0
[    0.049965] mce: CPU supports 9 MCE banks
[    0.053986] CPU0: Thermal monitoring handled by SMI
[    0.058883] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
[    0.058883] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
[    0.058883] tlb_flushall_shift: 6
[    0.073488] Freeing SMP alternatives memory: 20K (c1864000 - c1869000)=

[    0.080022] ACPI: Core revision 20130517
[    0.091124] ACPI: All ACPI Tables successfully acquired
[    0.097365] ftrace: allocating 21924 entries in 43 pages
[    0.110992] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.116823] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D0 pin2=3D=
0
[    0.162378] smpboot: CPU0: Intel(R) Core(TM) i7 CPU       M 640  @ 2.8=
0GHz (fam: 06, model: 25, stepping: 05)
[    0.279569] Performance Events: PEBS fmt1+, 16-deep LBR, Westmere even=
ts, Intel PMU driver.
[    0.287974] perf_event_intel: CPUID marked event: 'bus cycles' unavail=
able
[    0.294852] ... version:                3
[    0.298860] ... bit width:              48
[    0.302952] ... generic registers:      4
[    0.306960] ... value mask:             0000ffffffffffff
[    0.312270] ... max period:             000000007fffffff
[    0.317579] ... fixed-purpose events:   3
[    0.321585] ... event mask:             000000070000000f
[    0.328192] SMP alternatives: lockdep: fixing up alternatives
[    0.333955] CPU 1 irqstacks, hard=3Df4cf2000 soft=3Df4cf4000
[    0.339263] smpboot: Booting Node   0, Processors  #1[    0.354447] In=
itializing CPU#1
[    0.357534] CPU1: Thermal monitoring handled by SMI

[    0.364685] SMP alternatives: lockdep: fixing up alternatives
[    0.370620] CPU 2 irqstacks, hard=3Df4d0e000 soft=3Df4d10000
[    0.375930]  #2[    0.387675] Initializing CPU#2
[    0.390765] CPU2: Thermal monitoring handled by SMI

[    0.397940] SMP alternatives: lockdep: fixing up alternatives
[    0.403878] CPU 3 irqstacks, hard=3Df4d42000 soft=3Df4d44000
[    0.409187]  #3[    0.420931] Initializing CPU#3
[    0.424018] CPU3: Thermal monitoring handled by SMI

[    0.431039] Brought up 4 CPUs
[    0.434196] smpboot: Total of 4 processors activated (22344.55 BogoMIP=
S)
[    0.443384] devtmpfs: initialized
[    0.447081] PM: Registering ACPI NVS region [mem 0xcf67f000-0xcf76efff=
] (983040 bytes)
[    0.456414] regulator-dummy: no parameters
[    0.460594] RTC time:  9:47:40, date: 07/31/13
[    0.465197] NET: Registered protocol family 16
[    0.469847] ACPI FADT declares the system doesn't support PCIe ASPM, s=
o disable it
[    0.477425] ACPI: bus type PCI registered
[    0.481559] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf80000=
00-0xfbffffff] (base 0xf8000000)
[    0.490862] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E=
820
[    0.497646] PCI: Using MMCONFIG for extended config space
[    0.503040] PCI: Using configuration type 1 for base access
[    0.508618] dmi type 0xB1 record - unknown flag
[    0.514571] bio: create slab <bio-0> at 0
[    0.518770] ACPI: Added _OSI(Module Device)
[    0.522956] ACPI: Added _OSI(Processor Device)
[    0.527398] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.532099] ACPI: Added _OSI(Processor Aggregator Device)
[    0.541496] ACPI: EC: Look up EC in DSDT
[    0.572760] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.632396] ACPI: SSDT cf7eaa18 004B6 (v01  PmRef  Cpu0Ist 00003000 IN=
TL 20080729)
[    0.640980] ACPI: Dynamic OEM Table Load:
[    0.645013] ACPI: SSDT   (null) 004B6 (v01  PmRef  Cpu0Ist 00003000 IN=
TL 20080729)
[    0.652875] ACPI: SSDT cf7e8018 00891 (v01  PmRef  Cpu0Cst 00003001 IN=
TL 20080729)
[    0.661428] ACPI: Dynamic OEM Table Load:
[    0.665465] ACPI: SSDT   (null) 00891 (v01  PmRef  Cpu0Cst 00003001 IN=
TL 20080729)
[    0.696345] ACPI: SSDT cf7e9a98 00303 (v01  PmRef    ApIst 00003000 IN=
TL 20080729)
[    0.705009] ACPI: Dynamic OEM Table Load:
[    0.709046] ACPI: SSDT   (null) 00303 (v01  PmRef    ApIst 00003000 IN=
TL 20080729)
[    0.725025] ACPI: SSDT cf7e7d98 00119 (v01  PmRef    ApCst 00003000 IN=
TL 20080729)
[    0.733629] ACPI: Dynamic OEM Table Load:
[    0.737666] ACPI: SSDT   (null) 00119 (v01  PmRef    ApCst 00003000 IN=
TL 20080729)
[    0.820265] ACPI: Interpreter enabled
[    0.823936] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State=
 [\_S1_] (20130517/hwxface-571)
[    0.833183] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State=
 [\_S2_] (20130517/hwxface-571)
[    0.842455] ACPI: (supports S0 S3 S4 S5)
[    0.846378] ACPI: Using IOAPIC for interrupt routing
[    0.851375] PCI: Using host bridge windows from ACPI; if necessary, us=
e "pci=3Dnocrs" and report a bug
[    0.880360] ACPI: No dock devices found.
[    1.683823] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    1.690113] \_SB_.PCI0:_OSC invalid UUID
[    1.694035] _OSC request data:1 8 0=20
[    1.698778] PCI host bridge to bus 0000:00
[    1.702878] pci_bus 0000:00: root bus resource [bus 00-3e]
[    1.708362] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.714540] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    1.720718] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bf=
fff]
[    1.727589] pci_bus 0000:00: root bus resource [mem 0xd0000000-0xfeaff=
fff]
[    1.734499] pci 0000:00:00.0: [8086:0044] type 00 class 0x060000
[    1.740729] pci 0000:00:01.0: [8086:0045] type 01 class 0x060400
[    1.746782] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    1.752941] pci 0000:00:01.0: System wakeup disabled by ACPI
[    1.758733] pci 0000:00:19.0: [8086:10ea] type 00 class 0x020000
[    1.764767] pci 0000:00:19.0: reg 0x10: [mem 0xe9600000-0xe961ffff]
[    1.771041] pci 0000:00:19.0: reg 0x14: [mem 0xe9680000-0xe9680fff]
[    1.777317] pci 0000:00:19.0: reg 0x18: [io  0x8040-0x805f]
[    1.782989] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    1.789144] pci 0000:00:19.0: System wakeup disabled by ACPI
[    1.794856] pci 0000:00:1a.0: [8086:3b3c] type 00 class 0x0c0320
[    1.800887] pci 0000:00:1a.0: reg 0x10: [mem 0xe9670000-0xe96703ff]
[    1.807275] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    1.813465] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    1.819177] pci 0000:00:1b.0: [8086:3b56] type 00 class 0x040300
[    1.825205] pci 0000:00:1b.0: reg 0x10: [mem 0xe9660000-0xe9663fff 64b=
it]
[    1.832101] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    1.838236] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    1.843943] pci 0000:00:1c.0: [8086:3b42] type 01 class 0x060400
[    1.850066] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.856207] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    1.861911] pci 0000:00:1c.1: [8086:3b44] type 01 class 0x060400
[    1.868032] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    1.874175] pci 0000:00:1c.1: System wakeup disabled by ACPI
[    1.879879] pci 0000:00:1c.2: [8086:3b46] type 01 class 0x060400
[    1.886000] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    1.892142] pci 0000:00:1c.2: System wakeup disabled by ACPI
[    1.897848] pci 0000:00:1c.3: [8086:3b48] type 01 class 0x060400
[    1.903968] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    1.910117] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    1.915836] pci 0000:00:1d.0: [8086:3b34] type 00 class 0x0c0320
[    1.921870] pci 0000:00:1d.0: reg 0x10: [mem 0xe9650000-0xe96503ff]
[    1.928257] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    1.934451] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    1.940154] pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
[    1.946265] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    1.951970] pci 0000:00:1f.0: [8086:3b07] type 00 class 0x060100
[    1.958169] pci 0000:00:1f.2: [8086:3b2f] type 00 class 0x010601
[    1.964205] pci 0000:00:1f.2: reg 0x10: [io  0x8090-0x8097]
[    1.969785] pci 0000:00:1f.2: reg 0x14: [io  0x8080-0x8083]
[    1.975365] pci 0000:00:1f.2: reg 0x18: [io  0x8070-0x8077]
[    1.980946] pci 0000:00:1f.2: reg 0x1c: [io  0x8060-0x8063]
[    1.986526] pci 0000:00:1f.2: reg 0x20: [io  0x8020-0x803f]
[    1.992108] pci 0000:00:1f.2: reg 0x24: [mem 0xe9640000-0xe96407ff]
[    1.998449] pci 0000:00:1f.2: PME# supported from D3hot
[    2.003810] pci 0000:00:1f.3: [8086:3b30] type 00 class 0x0c0500
[    2.009837] pci 0000:00:1f.3: reg 0x10: [mem 0xe9630000-0xe96300ff 64b=
it]
[    2.016656] pci 0000:00:1f.3: reg 0x20: [io  0x8000-0x801f]
[    2.022384] pci 0000:00:1f.6: [8086:3b32] type 00 class 0x118000
[    2.028419] pci 0000:00:1f.6: reg 0x10: [mem 0xe9620000-0xe9620fff 64b=
it]
[    2.035493] pci 0000:01:00.0: [10de:0a6c] type 00 class 0x030000
[    2.041511] pci 0000:01:00.0: reg 0x10: [mem 0xe2000000-0xe2ffffff]
[    2.047789] pci 0000:01:00.0: reg 0x14: [mem 0xd0000000-0xdfffffff 64b=
it pref]
[    2.055021] pci 0000:01:00.0: reg 0x1c: [mem 0xe0000000-0xe1ffffff 64b=
it pref]
[    2.062252] pci 0000:01:00.0: reg 0x24: [io  0x7000-0x707f]
[    2.067830] pci 0000:01:00.0: reg 0x30: [mem 0xe3000000-0xe307ffff pre=
f]
[    2.074634] pci 0000:01:00.1: [10de:0be3] type 00 class 0x040300
[    2.080652] pci 0000:01:00.1: reg 0x10: [mem 0xe3080000-0xe3083fff]
[    2.087108] pci 0000:00:01.0: PCI bridge to [bus 01]
[    2.092074] pci 0000:00:01.0:   bridge window [io  0x7000-0x7fff]
[    2.098168] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xe30fff=
ff]
[    2.105042] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    2.110007] pci 0000:00:1c.0:   bridge window [io  0x6000-0x6fff]
[    2.116101] pci 0000:00:1c.0:   bridge window [mem 0xe8200000-0xe95fff=
ff]
[    2.123052] pci 0000:03:00.0: [14e4:4353] type 00 class 0x028000
[    2.129130] pci 0000:03:00.0: reg 0x10: [mem 0xe6e00000-0xe6e03fff 64b=
it]
[    2.136189] pci 0000:03:00.0: supports D1 D2
[    2.140458] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    2.146647] pci 0000:03:00.0: System wakeup disabled by ACPI
[    2.152406] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    2.157375] pci 0000:00:1c.1:   bridge window [io  0x5000-0x5fff]
[    2.163469] pci 0000:00:1c.1:   bridge window [mem 0xe6e00000-0xe81fff=
ff]
[    2.170426] pci 0000:04:00.0: [1180:e476] type 02 class 0x060700
[    2.176502] pci 0000:04:00.0: reg 0x10: [mem 0xe5940000-0xe5940fff]
[    2.182897] pci 0000:04:00.0: supports D1 D2
[    2.187164] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3col=
d
[    2.193865] pci 0000:04:00.0: System wakeup disabled by ACPI
[    2.199631] pci 0000:04:00.1: [1180:e822] type 00 class 0x080501
[    2.205707] pci 0000:04:00.1: reg 0x10: [mem 0xe5930000-0xe59300ff]
[    2.212193] pci 0000:04:00.1: supports D1 D2
[    2.216462] pci 0000:04:00.1: PME# supported from D0 D1 D2 D3hot D3col=
d
[    2.223269] pci 0000:04:00.4: [1180:e832] type 00 class 0x0c0010
[    2.229345] pci 0000:04:00.4: reg 0x10: [mem 0xe5900000-0xe59007ff]
[    2.235831] pci 0000:04:00.4: supports D1 D2
[    2.240100] pci 0000:04:00.4: PME# supported from D0 D1 D2 D3hot D3col=
d
[    2.256881] pci 0000:00:1c.2: PCI bridge to [bus 04-05]
[    2.262112] pci 0000:00:1c.2:   bridge window [io  0x2000-0x3fff]
[    2.268205] pci 0000:00:1c.2:   bridge window [mem 0xe3100000-0xe59fff=
ff]
[    2.275151] pci_bus 0000:05: busn_res: can not insert [bus 05-ff] unde=
r [bus 04-05] (conflicts with (null) [bus 04-05])
[    2.285980] pci_bus 0000:05: busn_res: [bus 05-ff] end is updated to 0=
8
[    2.292592] pci_bus 0000:05: busn_res: can not insert [bus 05-08] unde=
r [bus 04-05] (conflicts with (null) [bus 04-05])
[    2.303417] pci_bus 0000:05: [bus 05-08] partially hidden behind bridg=
e 0000:04 [bus 04-05]
[    2.311900] pci 0000:00:1c.3: PCI bridge to [bus 06-0b]
[    2.317125] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    2.323218] pci 0000:00:1c.3:   bridge window [mem 0xe5a00000-0xe6dfff=
ff]
[    2.330118] pci 0000:00:1e.0: PCI bridge to [bus 0c] (subtractive deco=
de)
[    2.336914] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (sub=
tractive decode)
[    2.344828] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (sub=
tractive decode)
[    2.352741] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bff=
ff] (subtractive decode)
[    2.361348] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xfeafff=
ff] (subtractive decode)
[    2.369989] pci_bus 0000:00: on NUMA node 0
[    2.374233] \_SB_.PCI0:_OSC invalid UUID
[    2.378155] _OSC request data:1 1f 0=20
[    2.381870] acpi PNP0A08:00: ACPI _OSC support notification failed, di=
sabling PCIe ASPM
[    2.389870] acpi PNP0A08:00: Unable to request _OSC control (_OSC supp=
ort mask: 0x08)
[    2.507593] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14=
 15) *11
[    2.515078] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14=
 15) *10
[    2.522560] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 *5 6 7 10 12 1=
4 15)
[    2.529768] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14=
 15) *10
[    2.537246] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 *3 4 5 6 7 10 12 1=
4 15)
[    2.544453] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14=
 15) *0, disabled.
[    2.552808] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14=
 15) *11
[    2.560285] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14=
 15) *0, disabled.
[    2.618028] ACPI: PCI Root Bridge [CPBG] (domain 0000 [bus 3f])
[    2.624036] PCI host bridge to bus 0000:3f
[    2.628133] pci_bus 0000:3f: root bus resource [bus 3f]
[    2.633359] pci 0000:3f:00.0: [8086:2c62] type 00 class 0x060000
[    2.639425] pci 0000:3f:00.1: [8086:2d01] type 00 class 0x060000
[    2.645609] pci 0000:3f:02.0: [8086:2d10] type 00 class 0x060000
[    2.651672] pci 0000:3f:02.1: [8086:2d11] type 00 class 0x060000
[    2.657736] pci 0000:3f:02.2: [8086:2d12] type 00 class 0x060000
[    2.663798] pci 0000:3f:02.3: [8086:2d13] type 00 class 0x060000
[    2.669875] pci_bus 0000:3f: on NUMA node 0
[    2.674059] acpi PNP0A03:00: ACPI _OSC support notification failed, di=
sabling PCIe ASPM
[    2.682060] acpi PNP0A03:00: Unable to request _OSC control (_OSC supp=
ort mask: 0x08)
[    2.739840] ACPI: Enabled 3 GPEs in block 00 to 3F
[    2.744663] ACPI: \_SB_.PCI0: notify handler is installed
[    2.750168] ACPI: \_SB_.CPBG: notify handler is installed
[    2.755578] Found 2 acpi root devices
[    2.759349] ACPI: EC: GPE =3D 0x10, I/O: command/status =3D 0x934, dat=
a =3D 0x930
[    2.766628] vgaarb: device added: PCI:0000:01:00.0,decodes=3Dio+mem,ow=
ns=3Dio+mem,locks=3Dnone
[    2.774721] vgaarb: loaded
[    2.777428] vgaarb: bridge control possible 0000:01:00.0
[    2.782839] SCSI subsystem initialized
[    2.786590] ACPI: bus type ATA registered
[    2.790671] libata version 3.00 loaded.
[    2.794536] ACPI: bus type USB registered
[    2.798566] usbcore: registered new interface driver usbfs
[    2.804059] usbcore: registered new interface driver hub
[    2.809398] usbcore: registered new device driver usb
[    2.814701] wmi: Mapper loaded
[    2.817755] PCI: Using ACPI for IRQ routing
[    2.824208] PCI: pci_cache_line_size set to 64 bytes
[    2.829386] e820: reserve RAM buffer [mem 0x0009ac00-0x0009ffff]
[    2.835394] e820: reserve RAM buffer [mem 0xcf65f000-0xcfffffff]
[    2.841721] NetLabel: Initializing
[    2.845126] NetLabel:  domain hash size =3D 128
[    2.849479] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    2.854485] NetLabel:  unlabeled traffic allowed by default
[    2.860186] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    2.866481] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    2.874362] Switched to clocksource hpet
[    2.895229] AppArmor: AppArmor Filesystem Enabled
[    2.899980] pnp: PnP ACPI init
[    2.903069] ACPI: bus type PNP registered
[    2.907153] pnp 00:00: [dma 4]
[    2.910258] pnp 00:00: Plug and Play ACPI device, IDs PNP0200 (active)=

[    2.916824] pnp 00:01: Plug and Play ACPI device, IDs INT0800 (active)=

[    2.923478] pnp 00:02: Plug and Play ACPI device, IDs PNP0103 (active)=

[    2.930055] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)=

[    2.936666] system 00:04: [io  0x0680-0x069f] has been reserved
[    2.942593] system 00:04: [io  0x1000-0x1003] has been reserved
[    2.948518] system 00:04: [io  0x1004-0x1013] has been reserved
[    2.954447] system 00:04: [io  0xffff] has been reserved
[    2.959763] system 00:04: [io  0x0400-0x047f] could not be reserved
[    2.966033] system 00:04: [io  0x0500-0x057f] has been reserved
[    2.971958] system 00:04: [io  0x164e-0x164f] has been reserved
[    2.977885] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    2.984717] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)=

[    2.991288] pnp 00:06: Plug and Play ACPI device, IDs PNP0303 (active)=

[    3.247079] pnp 00:07: Plug and Play ACPI device, IDs PNP0501 (active)=

[    3.439250] pnp 00:08: Plug and Play ACPI device, IDs PNP0401 (active)=

[    3.445825] pnp 00:09: Plug and Play ACPI device, IDs DLL040a PNP0f13 =
(active)
[    3.453407] system 00:0a: [mem 0xfed1c000-0xfed1ffff] has been reserve=
d
[    3.460028] system 00:0a: [mem 0xfed10000-0xfed13fff] has been reserve=
d
[    3.466644] system 00:0a: [mem 0xfed18000-0xfed18fff] has been reserve=
d
[    3.473260] system 00:0a: [mem 0xfed19000-0xfed19fff] has been reserve=
d
[    3.479879] system 00:0a: [mem 0xf8000000-0xfbffffff] has been reserve=
d
[    3.486495] system 00:0a: [mem 0xfed20000-0xfed3ffff] has been reserve=
d
[    3.493112] system 00:0a: [mem 0xfed45000-0xfed8ffff] has been reserve=
d
[    3.499728] system 00:0a: [mem 0xff000000-0xffffffff] could not be res=
erved
[    3.506692] system 00:0a: [mem 0xfee00000-0xfeefffff] could not be res=
erved
[    3.513658] system 00:0a: [mem 0xe96c0000-0xe96c0fff] has been reserve=
d
[    3.520276] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    3.527196] pnp 00:0b: Plug and Play ACPI device, IDs SMO8800 (active)=

[    3.839937] pnp: PnP ACPI: found 12 devices
[    3.844136] ACPI: bus type PNP unregistered
[    3.886154] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff=
 64bit pref] to [bus 02] add_size 200000
[    3.896169] pci 0000:00:1c.1: bridge window [mem 0x00100000-0x000fffff=
 64bit pref] to [bus 03] add_size 200000
[    3.906239] pci 0000:04:00.0: res[15]=3D[mem 0x04000000-0x03ffffff pre=
f] get_res_add_size add_size 4000000
[    3.915721] pci 0000:00:1c.2: bridge window [mem 0x04000000-0x03ffffff=
 pref] to [bus 04-05] add_size 4000000
[    3.925560] pci 0000:00:1c.3: bridge window [mem 0x00100000-0x000fffff=
 64bit pref] to [bus 06-0b] add_size 200000
[    3.935833] pci 0000:00:1c.2: res[15]=3D[mem 0x04000000-0x03ffffff pre=
f] get_res_add_size add_size 4000000
[    3.945314] pci 0000:00:1c.0: res[15]=3D[mem 0x00100000-0x000fffff 64b=
it pref] get_res_add_size add_size 200000
[    3.955229] pci 0000:00:1c.1: res[15]=3D[mem 0x00100000-0x000fffff 64b=
it pref] get_res_add_size add_size 200000
[    3.965143] pci 0000:00:1c.3: res[15]=3D[mem 0x00100000-0x000fffff 64b=
it pref] get_res_add_size add_size 200000
[    3.975062] pci 0000:00:1c.2: BAR 15: assigned [mem 0xec000000-0xeffff=
fff pref]
[    3.982376] pci 0000:00:1c.0: BAR 15: assigned [mem 0xe9700000-0xe98ff=
fff 64bit pref]
[    3.990211] pci 0000:00:1c.1: BAR 15: assigned [mem 0xe9900000-0xe9aff=
fff 64bit pref]
[    3.998044] pci 0000:00:1c.3: BAR 15: assigned [mem 0xe9b00000-0xe9cff=
fff 64bit pref]
[    4.005878] pci 0000:00:01.0: PCI bridge to [bus 01]
[    4.010849] pci 0000:00:01.0:   bridge window [io  0x7000-0x7fff]
[    4.016947] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xe30fff=
ff]
[    4.023741] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    4.028711] pci 0000:00:1c.0:   bridge window [io  0x6000-0x6fff]
[    4.034811] pci 0000:00:1c.0:   bridge window [mem 0xe8200000-0xe95fff=
ff]
[    4.041605] pci 0000:00:1c.0:   bridge window [mem 0xe9700000-0xe98fff=
ff 64bit pref]
[    4.049357] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    4.054328] pci 0000:00:1c.1:   bridge window [io  0x5000-0x5fff]
[    4.060428] pci 0000:00:1c.1:   bridge window [mem 0xe6e00000-0xe81fff=
ff]
[    4.067221] pci 0000:00:1c.1:   bridge window [mem 0xe9900000-0xe9afff=
ff 64bit pref]
[    4.074976] pci 0000:04:00.0: res[15]=3D[mem 0x04000000-0x03ffffff pre=
f] get_res_add_size add_size 4000000
[    4.084458] pci 0000:04:00.0: res[16]=3D[mem 0x04000000-0x03ffffff] ge=
t_res_add_size add_size 4000000
[    4.093505] pci 0000:04:00.0: res[13]=3D[io  0x0100-0x00ff] get_res_ad=
d_size add_size 100
[    4.101512] pci 0000:04:00.0: res[14]=3D[io  0x0100-0x00ff] get_res_ad=
d_size add_size 100
[    4.109520] pci 0000:04:00.0: BAR 15: assigned [mem 0xec000000-0xeffff=
fff pref]
[    4.116831] pci 0000:04:00.0: BAR 16: can't assign mem (size 0x4000000=
)
[    4.123456] pci 0000:04:00.0: BAR 13: assigned [io  0x2000-0x20ff]
[    4.129639] pci 0000:04:00.0: BAR 14: assigned [io  0x2400-0x24ff]
[    4.135825] pci 0000:04:00.0: BAR 16: can't assign mem (size 0x4000000=
)
[    4.142444] pci 0000:04:00.0: BAR 15: assigned [mem 0xec000000-0xeffff=
fff pref]
[    4.149756] pci 0000:04:00.0: BAR 14: assigned [io  0x2000-0x20ff]
[    4.155940] pci 0000:04:00.0: BAR 13: assigned [io  0x2400-0x24ff]
[    4.162123] pci 0000:04:00.0: CardBus bridge to [bus 05-08]
[    4.167698] pci 0000:04:00.0:   bridge window [io  0x2400-0x24ff]
[    4.173847] pci 0000:04:00.0:   bridge window [io  0x2000-0x20ff]
[    4.179996] pci 0000:04:00.0:   bridge window [mem 0xec000000-0xefffff=
ff pref]
[    4.187271] pci 0000:00:1c.2: PCI bridge to [bus 04-05]
[    4.192502] pci 0000:00:1c.2:   bridge window [io  0x2000-0x3fff]
[    4.198602] pci 0000:00:1c.2:   bridge window [mem 0xe3100000-0xe59fff=
ff]
[    4.205396] pci 0000:00:1c.2:   bridge window [mem 0xec000000-0xefffff=
ff pref]
[    4.212626] pci 0000:00:1c.3: PCI bridge to [bus 06-0b]
[    4.217855] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    4.223958] pci 0000:00:1c.3:   bridge window [mem 0xe5a00000-0xe6dfff=
ff]
[    4.230753] pci 0000:00:1c.3:   bridge window [mem 0xe9b00000-0xe9cfff=
ff 64bit pref]
[    4.238505] pci 0000:00:1e.0: PCI bridge to [bus 0c]
[    4.336479] pci 0000:00:1e.0: setting latency timer to 64
[    4.341889] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    4.347464] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    4.353040] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    4.359311] pci_bus 0000:00: resource 7 [mem 0xd0000000-0xfeafffff]
[    4.365583] pci_bus 0000:01: resource 0 [io  0x7000-0x7fff]
[    4.371160] pci_bus 0000:01: resource 1 [mem 0xd0000000-0xe30fffff]
[    4.377431] pci_bus 0000:02: resource 0 [io  0x6000-0x6fff]
[    4.383007] pci_bus 0000:02: resource 1 [mem 0xe8200000-0xe95fffff]
[    4.389278] pci_bus 0000:02: resource 2 [mem 0xe9700000-0xe98fffff 64b=
it pref]
[    4.396501] pci_bus 0000:03: resource 0 [io  0x5000-0x5fff]
[    4.402075] pci_bus 0000:03: resource 1 [mem 0xe6e00000-0xe81fffff]
[    4.408344] pci_bus 0000:03: resource 2 [mem 0xe9900000-0xe9afffff 64b=
it pref]
[    4.415571] pci_bus 0000:04: resource 0 [io  0x2000-0x3fff]
[    4.421145] pci_bus 0000:04: resource 1 [mem 0xe3100000-0xe59fffff]
[    4.427414] pci_bus 0000:04: resource 2 [mem 0xec000000-0xefffffff pre=
f]
[    4.434116] pci_bus 0000:05: resource 0 [io  0x2400-0x24ff]
[    4.439692] pci_bus 0000:05: resource 1 [io  0x2000-0x20ff]
[    4.445267] pci_bus 0000:05: resource 2 [mem 0xec000000-0xefffffff pre=
f]
[    4.451970] pci_bus 0000:06: resource 0 [io  0x4000-0x4fff]
[    4.457547] pci_bus 0000:06: resource 1 [mem 0xe5a00000-0xe6dfffff]
[    4.463815] pci_bus 0000:06: resource 2 [mem 0xe9b00000-0xe9cfffff 64b=
it pref]
[    4.471041] pci_bus 0000:0c: resource 4 [io  0x0000-0x0cf7]
[    4.476618] pci_bus 0000:0c: resource 5 [io  0x0d00-0xffff]
[    4.482195] pci_bus 0000:0c: resource 6 [mem 0x000a0000-0x000bffff]
[    4.488466] pci_bus 0000:0c: resource 7 [mem 0xd0000000-0xfeafffff]
[    4.494773] NET: Registered protocol family 2
[    4.499476] TCP established hash table entries: 8192 (order: 4, 65536 =
bytes)
[    4.506565] TCP bind hash table entries: 8192 (order: 6, 294912 bytes)=

[    4.513480] TCP: Hash tables configured (established 8192 bind 8192)
[    4.519887] TCP: reno registered
[    4.523126] UDP hash table entries: 512 (order: 3, 40960 bytes)
[    4.529098] UDP-Lite hash table entries: 512 (order: 3, 40960 bytes)
[    4.535666] NET: Registered protocol family 1
[    4.540867] pci 0000:01:00.0: Boot video device
[    4.545517] PCI: CLS 64 bytes, default 64
[    4.549667] Trying to unpack rootfs image as initramfs...
[    4.724289] Freeing initrd memory: 9916K (f6c92000 - f7641000)
[    4.730182] Simple Boot Flag at 0xf1 set to 0x1
[    4.734993] Scanning for low memory corruption every 60 seconds
[    4.741465] audit: initializing netlink socket (disabled)
[    4.746907] type=3D2000 audit(1375264062.536:1): initialized
[    4.771228] bounce pool size: 64 pages
[    4.774989] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    4.783334] VFS: Disk quotas dquot_6.5.2
[    4.787318] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)=

[    4.794540] fuse init (API version 7.22)
[    4.798584] msgmni has been set to 1692
[    4.803019] Block layer SCSI generic (bsg) driver version 0.4 loaded (=
major 252)
[    4.810446] io scheduler noop registered
[    4.814373] io scheduler deadline registered
[    4.818681] io scheduler cfq registered (default)
[    4.823608] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    4.829190] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    4.834853] pciehp: PCI Express Hot Plug Controller Driver version: 0.=
4
[    4.841582] vesafb: mode is 1360x768x32, linelength=3D5440, pages=3D0
[    4.847680] vesafb: scrolling: redraw
[    4.851350] vesafb: Truecolor: size=3D8:8:8:8, shift=3D24:16:8:0
[    4.857244] vesafb: framebuffer at 0xe1000000, mapped to 0xf8180000, u=
sing 4096k, total 4096k
[    4.978560] Console: switching to colour frame buffer device 170x48
[    5.098333] fb0: VESA VGA frame buffer device
[    5.103422] intel_idle: MWAIT substates: 0x1120
[    5.108678] intel_idle: v0.4 model 0x25
[    5.113124] intel_idle: lapic_timer_reliable_states 0xffffffff
[    5.120529] ACPI: Deprecated procfs I/F for AC is loaded, please retry=
 with CONFIG_ACPI_PROCFS_POWER cleared
[    5.132441] ACPI: AC Adapter [AC] (on-line)
[    5.137912] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0=
D:00/input/input0
[    5.147938] ACPI: Lid Switch [LID]
[    5.151939] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0=
C0C:00/input/input1
[    5.161442] ACPI: Power Button [PBTN]
[    5.165733] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0=
C0E:00/input/input2
[    5.175206] ACPI: Sleep Button [SBTN]
[    5.179492] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/in=
put/input3
[    5.188062] ACPI: Power Button [PWRF]
[    5.192398] ACPI: Requesting acpi_cpufreq
[    5.198061] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
=FF[    5.226282] 00:07: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    5.238221] brd: module loaded
[    5.243225] loop: module loaded
[    5.247765] libphy: Fixed MDIO Bus: probed
[    5.252567] tun: Universal TUN/TAP device driver, 1.6
[    5.258451] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    5.265704] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver=

[    5.281076] ACPI: Deprecated procfs I/F for battery is loaded, please =
retry with CONFIG_ACPI_PROCFS_POWER cleared
[    5.281085] ACPI: Battery Slot [BAT0] (battery present)
[    5.405386] ehci-pci: EHCI PCI platform driver
[    5.465312] ehci-pci 0000:00:1a.0: setting latency timer to 64
[    5.510608] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    5.554990] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bu=
s number 1
[    5.601702] ehci-pci 0000:00:1a.0: debug port 2
[    5.649160] ehci-pci 0000:00:1a.0: cache line size of 64 is not suppor=
ted
[    5.694795] ehci-pci 0000:00:1a.0: irq 16, io mem 0xe9670000
[    5.733265] tsc: Refined TSC clocksource calibration: 2792.980 MHz
[    5.793300] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    5.842008] hub 1-0:1.0: USB hub found
[    5.883865] hub 1-0:1.0: 3 ports detected
[    5.954193] ACPI: Deprecated procfs I/F for battery is loaded, please =
retry with CONFIG_ACPI_PROCFS_POWER cleared
[    5.954218] ehci-pci 0000:00:1d.0: setting latency timer to 64
[    5.954230] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    5.954237] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bu=
s number 2
[    5.954265] ehci-pci 0000:00:1d.0: debug port 2
[    5.958217] ehci-pci 0000:00:1d.0: cache line size of 64 is not suppor=
ted
[    5.958238] ehci-pci 0000:00:1d.0: irq 17, io mem 0xe9650000
[    5.969467] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    5.969654] hub 2-0:1.0: USB hub found
[    5.969658] hub 2-0:1.0: 3 ports detected
[    5.969843] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    5.969844] ohci-pci: OHCI PCI platform driver
[    5.969859] uhci_hcd: USB Universal Host Controller Interface driver
[    5.969930] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at=
 0x60,0x64 irq 1,12
[    5.970330] i8042: Warning: Keylock active
[    5.971532] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.971568] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.971891] mousedev: PS/2 mouse device common for all mice
[    5.972245] rtc_cmos 00:05: RTC can wake from S4
[    5.972632] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    5.972672] rtc_cmos 00:05: alarms up to one year, y3k, 242 bytes nvra=
m, hpet irqs
[    5.972854] cpuidle: using governor ladder
[    6.265786] usb 1-1: new high-speed USB device number 2 using ehci-pci=

[    6.967039] Switched to clocksource tsc
[    6.967085] ACPI: Battery Slot [BAT1] (battery absent)
[    6.967466] cpuidle: using governor menu
[    6.967591] TCP: cubic registered
[    6.967731] NET: Registered protocol family 10
[    6.968099] NET: Registered protocol family 17
[    6.968187] Key type dns_resolver registered
[    6.968412] Using IPI No-Shortcut mode
[    6.968543] PM: Hibernation image not present or could not be loaded.
[    6.968562] registered taskstats version 1
[    6.970581]   Magic number: 5:525:779
[    7.015288] rtc_cmos 00:05: setting system clock to 2013-07-31 09:47:4=
6 UTC (1375264066)
[    7.064420] hub 1-1:1.0: USB hub found
[    7.064585] hub 1-1:1.0: 6 ports detected
[    7.148481] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    7.148482] EDD information not available.
[    7.258797] usb 2-1: new high-speed USB device number 2 using ehci-pci=

[    7.449754] hub 2-1:1.0: USB hub found
[    7.449871] hub 2-1:1.0: 8 ports detected
[    7.627295] usb 1-1.1: new high-speed USB device number 3 using ehci-p=
ci
[  7.745290] hub 1-1.1:1.0: USB hub found
[    7.781572] hub 1-1.1:1.0: 3 ports detected
[    7.781624] Freeing unused kernel memory: 612K (c17cb000 - c1864000)
[    7.856462] Write protecting the kernel text: 5320k
[    7.893692] Write protecting the kernel read-only data: 2160k
Loading, please wait...
[    7.950632] udevd[76]: starting version 175
[    7.999647] usb 1-1.2: new high-speed USB device number 4 using ehci-p=
ci
[    8.010427] Linux agpgart interface v0.103
[    8.035268] ahci 0000:00:1f.2: version 3.0
[    8.035659] ahci 0000:00:1f.2: irq 41 for MSI/MSI-X
[    8.035828] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps =
0x33 impl SATA mode
[    8.035830] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio sl=
um part ems sxs apst=20
[    8.035836] ahci 0000:00:1f.2: setting latency timer to 64
[    8.040012] pps_core: LinuxPPS API ver. 1 registered
[    8.040013] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolf=
o Giometti <giometti@linux.it>
[    8.040324] PTP clock support registered
[    8.041452] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    8.041452] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[    8.069609] scsi0 : ahci
[    8.080282] scsi1 : ahci
[    8.094792] scsi2 : ahci
[    8.096988] scsi3 : ahci
[    8.097525] scsi4 : ahci
[    8.102172] scsi5 : ahci
[    8.102399] ata1: SATA max UDMA/133 abar m2048@0xe9640000 port 0xe9640=
100 irq 41
[    8.102401] ata2: SATA max UDMA/133 abar m2048@0xe9640000 port 0xe9640=
180 irq 41
[    8.102402] ata3: DUMMY
[    8.102403] ata4: DUMMY
[    8.102405] ata5: SATA max UDMA/133 abar m2048@0xe9640000 port 0xe9640=
300 irq 41
[    8.102408] ata6: SATA max UDMA/133 abar m2048@0xe9640000 port 0xe9640=
380 irq 41
[    8.115067] sdhci: Secure Digital Host Controller Interface driver
[    8.115068] sdhci: Copyright(c) Pierre Ossman
[    8.423966] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    8.424020] ata5: SATA link down (SStatus 0 SControl 300)
[    8.424089] ata6: SATA link down (SStatus 0 SControl 300)
[    8.424159] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    9.114366] e1000e 0000:00:19.0: setting latency timer to 64
[    9.149620] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) =
set to dynamic conservative mode
[    9.164844] firewire_ohci 0000:04:00.4: added OHCI v1.0 device as card=
 0, 4 IR + 4 IT contexts, quirks 0x11
[    9.164888] sdhci-pci 0000:04:00.1: SDHCI controller found [1180:e822]=
 (rev 3)
[    9.268216] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
[    9.304803] mmc0: no vqmmc regulator found
[    9.305169] hub 1-1.2:1.0: USB hub found
[    9.374183] hub 1-1.2:1.0: 3 ports detected
[    9.374229] mmc0: no vmmc regulator found
[    9.374690] mmc0: SDHCI controller on PCI [0000:04:00.1] using DMA
[    9.539291] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 5=
c:26:0a:4b:44:22
[    9.578194] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connec=
tion
[    9.616216] usb 1-1.4: new high-speed USB device number 5 using ehci-p=
ci
[    9.616373] e1000e 0000:00:19.0 eth0: MAC: 9, PHY: 10, PBA No: 3041FF-=
0FF
[    9.617575] ata2.00: ATAPI: HL-DT-ST DVD-ROM DU30N, A100, max UDMA/133=

[    9.618865] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by d=
evice (Stat=3D0x51 Err=3D0x04)
[    9.665592] firewire_core 0000:04:00.4: created device fw0: GUID 06531=
6c1314fc000, S400
[    9.833791] ata2.00: configured for UDMA/133
[    9.870741] ata1.00: ATA-8: ST9250410AS, D005SDM1, max UDMA/133
[    9.909443] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/=
32)
[   10.008525] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by d=
evice (Stat=3D0x51 Err=3D0x04)
[   10.045698] usb 2-1.7: new full-speed USB device number 3 using ehci-p=
ci
[   10.092857] ata1.00: configured for UDMA/133
[   10.131668] scsi 0:0:0:0: Direct-Access     ATA      ST9250410AS      =
D005 PQ: 0 ANSI: 5
[   10.204267] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 =
GB/232 GiB)
[   10.204464] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   10.286337] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVD-ROM DU30N    =
A100 PQ: 0 ANSI: 5
[   10.286379] sd 0:0:0:0: [sda] Write Protect is off
[   10.286380] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   10.286400] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
[   10.466108]  sda: sda1 sda2 < sda5 sda6 sda7 >
[   10.506189] usb 2-1.8: new full-speed USB device number 4 using ehci-p=
ci
[   10.506691] sd 0:0:0:0: [sda] Attached SCSI disk
[   10.534993] sr0: scsi3-mmc drive: 24x/24x cd/rw xa/form2 cdda tray
[   10.534995] cdrom: Uniform CD-ROM driver Revision: 3.20
[   10.535496] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   10.535644] sr 1:0:0:0: Attached scsi generic sg1 type 5
[   10.881628] usb 2-1.8: config 0 descriptor??
[   10.934602] acpi device:03: registered as cooling_device4
[   11.015174] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: =
no)
[   11.060597] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08=
:00/device:01/LNXVIDEO:00/input/input4
[   11.163066] [drm] Initialized drm 1.1.0 20060810
[   11.211567] ACPI Warning: \_SB_.PCI0.AGP_.VID_._DSM: Argument #4 type =
mismatch - Found [Integer], ACPI requires [Package] (20130517/nsarguments=
-95)
[   11.267496] ACPI Warning: \_SB_.PCI0.AGP_.VID_._DSM: Argument #4 type =
mismatch - Found [Buffer], ACPI requires [Package] (20130517/nsarguments-=
95)
[   11.323410] checking generic (e1000000 400000) vs hw (d0000000 1000000=
0)
[   11.372796] checking generic (e1000000 400000) vs hw (e0000000 2000000=
)
[   11.422200] fb: conflicting fb hw usage nouveaufb vs VESA VGA - removi=
ng generic driver
[   11.473848] Console: switching to colour dummy device 80x25
[   11.482325] nouveau  [  DEVICE][0000:01:00.0] BOOT0  : 0x0a8600b1
[   11.488450] nouveau  [  DEVICE][0000:01:00.0] Chipset: GT218 (NVA8)
[   11.494738] nouveau  [  DEVICE][0000:01:00.0] Family : NV50
[   11.501194] nouveau  [   VBIOS][0000:01:00.0] checking PRAMIN for imag=
e...
[   11.582712] nouveau  [   VBIOS][0000:01:00.0] ... appears to be valid
[   11.589184] nouveau  [   VBIOS][0000:01:00.0] using image from PRAMIN
[   11.595750] nouveau  [   VBIOS][0000:01:00.0] BIT signature found
[   11.601876] nouveau  [   VBIOS][0000:01:00.0] version 70.18.53.00.04
[   11.608957] nouveau  [     PFB][0000:01:00.0] RAM type: DDR3
[   11.614644] nouveau  [     PFB][0000:01:00.0] RAM size: 512 MiB
[   11.620605] nouveau  [     PFB][0000:01:00.0]    ZCOMP: 960 tags
[   11.653571] nouveau  [  PTHERM][0000:01:00.0] FAN control: none / exte=
rnal
[   11.660450] nouveau  [  PTHERM][0000:01:00.0] fan management: disabled=

[   11.667013] nouveau  [  PTHERM][0000:01:00.0] internal sensor: yes
[   11.673898] [TTM] Zone  kernel: Available graphics memory: 433554 kiB
[   11.680341] [TTM] Zone highmem: Available graphics memory: 1677908 kiB=

[   11.686866] [TTM] Initializing pool allocator
[   11.691334] nouveau  [     DRM] VRAM: 512 MiB
[   11.695690] nouveau  [     DRM] GART: 1048576 MiB
[   11.700396] nouveau  [     DRM] TMDS table version 2.0
[   11.705532] nouveau  [     DRM] DCB version 4.0
[   11.710062] nouveau  [     DRM] DCB outp 00: 048003b6 0f200014
[   11.715895] nouveau  [     DRM] DCB outp 01: 02033300 00000000
[   11.721726] nouveau  [     DRM] DCB outp 02: 088223a6 0f220010
[   11.727555] nouveau  [     DRM] DCB outp 03: 08022362 00020010
[   11.733386] nouveau  [     DRM] DCB outp 04: 028113c6 0f220010
[   11.739225] nouveau  [     DRM] DCB outp 05: 02011382 00020010
[   11.745054] nouveau  [     DRM] DCB conn 00: 00002047
[   11.750116] nouveau  [     DRM] DCB conn 01: 00101146
[   11.755178] nouveau  [     DRM] DCB conn 02: 00410246
[   11.760238] nouveau  [     DRM] DCB conn 03: 00000300
[   11.795443] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010)=
=2E
[   11.802059] [drm] No driver support for vblank timestamp query.
[   11.807978] nouveau  [     DRM] ACPI backlight interface available, no=
t registering our own
[   11.816470] nouveau  [     DRM] 3 available performance level(s)
[   11.822478] nouveau  [     DRM] 0: core 135MHz shader 270MHz memory 13=
5MHz voltage 850mV
[   11.830563] nouveau  [     DRM] 1: core 405MHz shader 810MHz memory 40=
5MHz voltage 850mV
[   11.838652] nouveau  [     DRM] 3: core 606MHz shader 1468MHz memory 7=
90MHz voltage 1000mV
[   11.846913] nouveau  [     DRM] c: core 405MHz shader 810MHz memory 40=
5MHz voltage 1000mV
[   11.886101] nouveau  [     DRM] MM: using COPY for buffer copies
[   12.070930] nouveau  [     DRM] allocated 1920x1080 fb: 0x70000, bo f4=
eebe00
[   12.078357] fbcon: nouveaufb (fb0) is primary device
[   12.428309] Console: switching to colour frame buffer device 180x56
[   12.704589] nouveau 0000:01:00.0: fb0: nouveaufb frame buffer device
[   12.710943] nouveau 0000:01:00.0: registered panic notifier
[   12.716534] [drm] Initialized nouveau 1.1.1 20120801 for 0000:01:00.0 =
on minor 0
Begin: Loading essential drivers ... done.
Begin: Running /scripts/init-premount ... done.
Begin: Mounting root file system ... Begin: Running /scripts/local-top ..=
=2E done.
Begin: Running /scripts/local-premount ... done.
[   12.890445] EXT4-fs (sda5): mounted filesystem with ordered data mode.=
 Opts: (null)
Begin: Running /scripts/local-bottom ... done.
done.
Begin: Running /scripts/init-bottom ... done.
[   14.957644] init: ureadahead main process (343) terminated with status=
 5
fsck from util-linux 2.20.1
fsck from util-linux 2.20.1
[   16.059557] Adding 5915644k swap on /dev/sda1.  Priority:-1 extents:1 =
across:5915644k=20
[   17.400406] udevd[422]: starting version 175
[   18.961366] intel ips 0000:00:1f.6: CPU TDP doesn't match expected val=
ue (found 25, expected 29)
[   18.970484] intel ips 0000:00:1f.6: failed to get i915 symbols, graphi=
cs turbo disabled until i915 loads
[   18.980086] intel ips 0000:00:1f.6: IPS driver initialized, MCP temp l=
imit 90
[   19.226430] input: Dell WMI hotkeys as /devices/virtual/input/input5
[   19.313416] ACPI Warning: 0x00000428-0x0000042f SystemIO conflicts wit=
h Region \PMIO 1 (20130517/utaddress-251)
[   19.323581] ACPI: If an ACPI driver is available for this device, you =
should use it instead of the native driver
[   19.333772] ACPI Warning: [   19.336270] dcdbas dcdbas: Dell Systems M=
anagement Base Driver (version 5.6.0-3.2)
0x00000540-0x0000054f SystemIO conflicts with Region \GPIO 1 (20130517/ut=
address-251)
[   19.351486] ACPI: If an ACPI driver is available for this device, you =
should use it instead of the native driver
[   19.361660] ACPI Warning: 0x00000530-0x0000053f SystemIO conflicts wit=
h Region \GPIO 1 (20130517/utaddress-251)
[   19.371838] ACPI: If an ACPI driver is available for this device, you =
should use it instead of the native driver
[   19.382110] ACPI Warning: 0x00000500-0x0000052f SystemIO conflicts wit=
h Region \GPIO 1 (20130517/utaddress-251)
[   19.392250] ACPI: If an ACPI driver is available for this device, you =
should use it instead of the native driver
[   19.402421] lpc_ich: Resource conflict(s) found affecting gpio_ich
[   19.766935] snd_hda_intel 0000:00:1b.0: irq 43 for MSI/MSI-X
[   19.899696] input: HDA Intel MID Headphone as /devices/pci0000:00/0000=
:00:1b.0/sound/card0/input6
[   19.908690] input: HDA Intel MID Dock Line Out as /devices/pci0000:00/=
0000:00:1b.0/sound/card0/input7
[   19.918075] input: HDA Intel MID Mic as /devices/pci0000:00/0000:00:1b=
=2E0/sound/card0/input8
[   19.926555] input: HDA Intel MID Dock Mic as /devices/pci0000:00/0000:=
00:1b.0/sound/card0/input9
[   19.936798] hda_intel: Disabling MSI
[   19.940391] hda-intel 0000:01:00.1: Handle VGA-switcheroo audio client=

[   20.126759] type=3D1400 audit(1375264079.637:2): apparmor=3D"STATUS" o=
peration=3D"profile_load" name=3D"/sbin/dhclient" pid=3D739 comm=3D"appar=
mor_parser"
[   20.139555] type=3D1400 audit(1375264079.649:3): apparmor=3D"STATUS" o=
peration=3D"profile_replace" name=3D"/sbin/dhclient" pid=3D740 comm=3D"ap=
parmor_parser"
[   20.152621] type=3D1400 audit(1375264079.665:4): apparmor=3D"STATUS" o=
peration=3D"profile_load" name=3D"/usr/lib/NetworkManager/nm-dhcp-client.=
action" pid=3D739 comm=3D"apparmor_parser"
[   20.168124] type=3D1400 audit(1375264079.681:5): apparmor=3D"STATUS" o=
peration=3D"profile_replace" name=3D"/usr/lib/NetworkManager/nm-dhcp-clie=
nt.action" pid=3D740 comm=3D"apparmor_parser"
[   20.183876] type=3D1400 audit(1375264079.697:6): apparmor=3D"STATUS" o=
peration=3D"profile_load" name=3D"/usr/lib/connman/scripts/dhclient-scrip=
t" pid=3D739 comm=3D"apparmor_parser"
[   20.198966] type=3D1400 audit(1375264079.709:7): apparmor=3D"STATUS" o=
peration=3D"profile_replace" name=3D"/usr/lib/connman/scripts/dhclient-sc=
ript" pid=3D740 comm=3D"apparmor_parser"
[   20.563763] input: DualPoint Stick as /devices/platform/i8042/serio1/i=
nput/input10
[   20.584683] input: AlpsPS/2 ALPS DualPoint TouchPad as /devices/platfo=
rm/i8042/serio1/input/input11
[   20.832530] input: HDA NVidia HDMI/DP,pcm=3D9 as /devices/pci0000:00/0=
000:00:01.0/0000:01:00.1/sound/card1/input12
[   20.842927] input: HDA NVidia HDMI/DP,pcm=3D8 as /devices/pci0000:00/0=
000:00:01.0/0000:01:00.1/sound/card1/input13
[   20.853233] input: HDA NVidia HDMI/DP,pcm=3D7 as /devices/pci0000:00/0=
000:00:01.0/0000:01:00.1/sound/card1/input14
[   20.863567] input: HDA NVidia HDMI/DP,pcm=3D3 as /devices/pci0000:00/0=
000:00:01.0/0000:01:00.1/sound/card1/input15
/dev/sda5: clean, 256845/6111232 files, 1521202/24413696 blocks[   22.563=
500] EXT4-fs (sda5): re-mounted. Opts: errors=3Dremount-ro

/dev/sda6: clean, 179754/2686976 files, 1520070/10742016 blocks
[   23.000278] EXT4-fs (sda6): mounted filesystem with ordered data mode.=
 Opts: (null)
[   23.272722] init: failsafe main process (915) killed by TERM signal
[   24.975400] type=3D1400 audit(1375264084.481:8): apparmor=3D"STATUS" o=
peration=3D"profile_replace" name=3D"/sbin/dhclient" pid=3D981 comm=3D"ap=
parmor_parser"
[   24.988884] type=3D1400 audit(1375264084.497:9): apparmor=3D"STATUS" o=
peration=3D"profile_replace" name=3D"/usr/lib/NetworkManager/nm-dhcp-clie=
nt.action" pid=3D981 comm=3D"apparmor_parser"
[   25.004840] type=3D1400 audit(1375264084.513:10): apparmor=3D"STATUS" =
operation=3D"profile_replace" name=3D"/usr/lib/connman/scripts/dhclient-s=
cript" pid=3D981 comm=3D"apparmor_parser"
Skipping profile in /etc/apparmor.d/disable: usr.bin.firefox
[   25.039071] type=3D1400 audit(1375264084.545:11): apparmor=3D"STATUS" =
operation=3D"profile_load" name=3D"/usr/share/gdm/guest-session/Xsession"=
 pid=3D979 comm=3D"apparmor_parser"
Skipping profile in /etc/apparmor.d/disable: usr.sbin.rsyslogd
[   25.305154] audit_printk_skb: 6 callbacks suppressed
[   25.310412] type=3D1400 audit(1375264084.813:14): apparmor=3D"STATUS" =
operation=3D"profile_load" name=3D"/usr/sbin/tcpdump" pid=3D986 comm=3D"a=
pparmor_parser"
[   25.325848] type=3D1400 audit(1375264084.833:15): apparmor=3D"STATUS" =
operation=3D"profile_load" name=3D"/usr/lib/telepathy/mission-control-5" =
pid=3D984 comm=3D"apparmor_parser"
[   25.341272] type=3D1400 audit(1375264084.849:16): apparmor=3D"STATUS" =
operation=3D"profile_load" name=3D"/usr/lib/telepathy/telepathy-*" pid=3D=
984 comm=3D"apparmor_parser"
[   25.439835] type=3D1400 audit(1375264084.945:17): apparmor=3D"STATUS" =
operation=3D"profile_load" name=3D"/usr/bin/evince" pid=3D982 comm=3D"app=
armor_parser"
[   25.456668] type=3D1400 audit(1375264084.961:18): apparmor=3D"STATUS" =
operation=3D"profile_load" name=3D"/usr/bin/evince//launchpad_integration=
" pid=3D982 comm=3D"apparmor_parser"
[   25.472678] type=3D1400 audit(1375264084.981:19): apparmor=3D"STATUS" =
operation=3D"profile_load" name=3D"/usr/bin/evince//sanitized_helper" pid=
=3D982 comm=3D"apparmor_parser"
[   25.488115] type=3D1400 audit(1375264084.997:20): apparmor=3D"STATUS" =
operation=3D"profile_load" name=3D"/usr/bin/evince-previewer" pid=3D982 c=
omm=3D"apparmor_parser"
[   25.504579] type=3D1400 audit(1375264085.009:21): apparmor=3D"STATUS" =
operation=3D"profile_load" name=3D"/usr/bin/evince-previewer//launchpad_i=
ntegration" pid=3D982 comm=3D"apparmor_parser"
[   25.521383] type=3D1400 audit(1375264085.029:22): apparmor=3D"STATUS" =
operation=3D"profile_load" name=3D"/usr/bin/evince-previewer//sanitized_h=
elper" pid=3D982 comm=3D"apparmor_parser"
[   25.537533] type=3D1400 audit(1375264085.045:23): apparmor=3D"STATUS" =
operation=3D"profile_load" name=3D"/usr/bin/evince-thumbnailer" pid=3D982=
 comm=3D"apparmor_parser"
 * Starting AppArmor profiles        [ OK ]
 * Setting sensors limits        [ OK ]
 * Starting System V runlevel compatibility[ OK ]
 * Stopping eCryptfs[ OK ]
 * Starting regular background program processing daemon[ OK ]
 * Starting deferred execution scheduler[ OK ]
[   26.464943] init: gdm main process (1071) killed by TERM signal
 * Stopping GNOME Display Manager[ OK ]
 * Starting automatic crash report generation[ OK ]
speech-dispatcher disabled; edit /etc/default/speech-dispatcher
udhcpd: Disabled. Edit /etc/default/udhcpd to enable it.
[   27.150506] init: qemu-kvm pre-start process (1038) terminated with st=
atus 1
 * Starting KVM[fail]
 * Starting bluetooth daemon[ OK ]
 * Stopping save kernel messages[ OK ]
 * Starting LightDM Display Manager[ OK ]
 * Starting mDNS[   27.357177] init: qemu-kvm post-stop process (1113) te=
rminated with status 1
/DNS-SD daemon[ OK ]
 * Starting CPU interrupts balancing daemon[ OK ]
 * Stopping Send an event to indicate plymouth is up[ OK ]
saned disabled; edit /etc/default/saned
[   27.756014] init: bluetooth main process (1062) terminated with status=
 1
[   27.763012] init: bluetooth main process ended, respawning
[   29.501737] init: bluetooth main process (1202) terminated with status=
 1
[   29.508736] init: bluetooth main process ended, respawning
[   29.529999] init: bluetooth main process (1225) terminated with status=
 1
[   29.537038] init: bluetooth main process ended, respawning
[   29.558779] init: bluetooth main process (1252) terminated with status=
 1
[   29.565771] init: bluetooth main process ended, respawning
[   29.587082] init: bluetooth main process (1275) terminated with status=
 1
[   29.594102] init: bluetooth main process ended, respawning
[   29.617187] init: bluetooth main process (1298) terminated with status=
 1
[   29.624206] init: bluetooth main process ended, respawning
[   29.646708] init: bluetooth main process (1321) terminated with status=
 1
[   29.653732] init: bluetooth main process ended, respawning
[   29.675910] init: bluetooth main process (1346) terminated with status=
 1
[   29.682900] init: bluetooth main process ended, respawning
[   29.709397] init: bluetooth main process (1370) terminated with status=
 1
[   29.716393] init: bluetooth main process ended, respawning
[   29.738265] init: bluetooth main process (1393) terminated with status=
 1
[   29.745259] init: bluetooth main process ended, respawning
[   29.769381] init: bluetooth main process (1417) terminated with status=
 1
[   29.776385] init: bluetooth respawning too fast, stopped
[   30.133987] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
[ OK ]
[   30.241809] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
[   30.247154] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   30.471616] init: plymouth-stop pre-start process (1549) terminated wi=
th status 1

Ubuntu 12.04.2 LTS arend-lp-dev ttyS0

arend-lp-dev login: [   33.471609] e1000e: eth0 NIC Link is Up 1000 Mbps =
Full Duplex, Flow Control: Rx
[   33.479185] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   51.370512] input: AT Translated Set 2 keyboard as /devices/platform/i=
8042/serio0/input/input16
acpid: exiting
[   85.813454] init: tty4 main process (1040) killed by TERM signal
[   85.819992] init: tty5 main process (1047) killed by TERM signal
[   85.826502] init: tty2 main process (1056) killed by TERM signal
[   85.833048] init: tty3 main process (1057) killed by TERM signal
[   85.839572] init: tty6 main process (1059) killed by TERM signal
[   85.846130] init: anacron main process (1068) killed by TERM signal
[   85.853385] init: cron main process (1076) killed by TERM signal
[   85.860713] init: irqbalance main process (1115) killed by TERM signal=

udhcpd: Disabled[   85.868422] init: tty1 main process (1550) killed by T=
ERM signal
=2E Edit /etc/defa[   85.875207] init: ttyS0 main process (1551) killed b=
y TERM signal
ult/udhcpd to enable it.
[   85.884795] init: plymouth-upstart-bridge main process (2450) terminat=
ed with status 1
Checking for running unattended-upgrades:=20
[   86.385303] ------------[ cut here ]------------
[   86.390206] WARNING: CPU: 1 PID: 1169 at drivers/gpu/drm/nouveau/nouve=
au_gem.c:54 nouveau_gem_object_del+0x90/0xa0 [nouveau]()
[   86.401817] Modules linked in: binfmt_misc snd_hda_codec_hdmi snd_hda_=
codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm dell_laptop dcdba=
s lpc_ich snd_seq_midi dell_wmi mfd_core snd_rawmidi snd_seq_midi_event s=
nd_seq psmouse serio_raw sparse_keymap intel_ips snd_timer snd_seq_device=
 snd soundcore snd_page_alloc nouveau ttm drm_kms_helper drm i2c_algo_bit=
 mxm_wmi sdhci_pci sdhci mmc_core firewire_ohci firewire_core video crc_i=
tu_t e1000e ptp pps_core ahci libahci intel_agp intel_gtt agpgart
[   86.447012] CPU: 1 PID: 1169 Comm: Xorg Not tainted 3.11.0-rc2-wl-test=
ing-lockdep-00001-gbf7b638-dirty #2
[   86.456796] Hardware name: Dell Inc. Latitude E6410/07XJP9, BIOS A07 0=
2/15/2011
[   86.464323]  00000000 00000000 f70edde8 c1521a01 00000000 f70ede18 c10=
3f754 c16a7d48
[   86.472395]  00000001 00000491 f89e1dc0 00000036 f89a8960 f89a8960 f46=
67400 f4ff1ba0
[   86.480465]  f4418800 f70ede28 c103f792 00000009 00000000 f70ede3c f89=
a8960 f4667400
[   86.488540] Call Trace:
[   86.491213]  [<c1521a01>] dump_stack+0x4b/0x66
[   86.495883]  [<c103f754>] warn_slowpath_common+0x84/0xa0
[   86.501429]  [<f89a8960>] ? nouveau_gem_object_del+0x90/0xa0 [nouveau]=

[   86.508191]  [<f89a8960>] ? nouveau_gem_object_del+0x90/0xa0 [nouveau]=

[   86.514939]  [<c103f792>] warn_slowpath_null+0x22/0x30
[   86.520308]  [<f89a8960>] nouveau_gem_object_del+0x90/0xa0 [nouveau]
[   86.526891]  [<f87ae182>] drm_gem_object_free+0x22/0x30 [drm]
[   86.532863]  [<f87aea9f>] drm_gem_object_release_handle+0x8f/0xb0 [drm=
]
[   86.539698]  [<f87aea10>] ? drm_gem_handle_create+0x100/0x100 [drm]
[   86.546184]  [<c12b0b84>] idr_for_each+0xa4/0x100
[   86.551107]  [<f87aea10>] ? drm_gem_handle_create+0x100/0x100 [drm]
[   86.557592]  [<c1524fad>] ? mutex_unlock+0xd/0x10
[   86.562520]  [<f87bbf94>] ? drm_fb_release+0xa4/0xb0 [drm]
[   86.568225]  [<f87aeeaa>] drm_gem_release+0x1a/0x30 [drm]
[   86.573844]  [<f87ad649>] drm_release+0x4f9/0x570 [drm]
[   86.579286]  [<c106a75b>] ? lg_local_unlock+0x1b/0x40
[   86.584550]  [<c1142f9d>] __fput+0xdd/0x200
[   86.588946]  [<c11430fd>] ____fput+0xd/0x10
[   86.593346]  [<c105f301>] task_work_run+0x81/0xb0
[   86.598268]  [<c10451b9>] do_exit+0x269/0x920
[   86.602838]  [<c1528536>] ? restore_all+0xf/0xf
[   86.607582]  [<c152bf80>] ? __do_page_fault+0x520/0x520
[   86.613017]  [<c1045974>] do_group_exit+0x34/0xa0
[   86.617928]  [<c10459f8>] SyS_exit_group+0x18/0x20
[   86.622928]  [<c152fc61>] sysenter_do_call+0x12/0x32
[   86.628099] ---[ end trace cde437a9274b752e ]---
[   86.632935]=20
[   86.634629] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   86.641006] [ INFO: possible circular locking dependency detected ]
[   86.647468] 3.11.0-rc2-wl-testing-lockdep-00001-gbf7b638-dirty #2 Tain=
ted: G        W  =20
[   86.655754] -------------------------------------------------------
[   86.662227] Xorg/1169 is trying to acquire lock:
[   86.667042]  (reservation_ww_class_mutex){+.+.+.}, at: [<f89a6d73>] no=
uveau_bo_unpin+0x33/0x100 [nouveau]
[   86.676873]=20
[   86.676873] but task is already holding lock:
[   86.683262]  (&dev->struct_mutex){+.+.+.}, at: [<f87aea71>] drm_gem_ob=
ject_release_handle+0x61/0xb0 [drm]
[   86.693087]=20
[   86.693087] which lock already depends on the new lock.
[   86.693087]=20
[   86.702514]=20
[   86.702514] the existing dependency chain (in reverse order) is:
[   86.710592]=20
-> #1 (&dev->struct_mutex){+.+.+.}:
[   86.715754]        [<c109ea59>] lock_acquire+0x79/0x100
[   86.721193]        [<c15235c6>] mutex_lock_nested+0x66/0x390
[   86.727066]        [<f89a87ef>] validate_fini_list.isra.7+0xaf/0xf0 [n=
ouveau]
[   86.734429]        [<f89a884a>] validate_fini_no_ticket+0x1a/0x40 [nou=
veau]
[   86.741607]        [<f89a8880>] validate_fini+0x10/0x50 [nouveau]
[   86.747916]        [<f89a91a4>] nouveau_gem_ioctl_pushbuf+0x304/0x1370=
 [nouveau]
[   86.755523]        [<f87acd7a>] drm_ioctl+0x4aa/0x550 [drm]
[   86.761299]        [<c1151f77>] do_vfs_ioctl+0x77/0x5a0
[   86.766722]        [<c1152518>] SyS_ioctl+0x78/0x90
[   86.771795]        [<c152fc61>] sysenter_do_call+0x12/0x32
[   86.777474]=20
-> #0 (reservation_ww_class_mutex){+.+.+.}:
[   86.783277]        [<c109e47f>] __lock_acquire+0x183f/0x1910
[   86.789122]        [<c109ea59>] lock_acquire+0x79/0x100
[   86.794536]        [<c15235c6>] mutex_lock_nested+0x66/0x390
[   86.800384]        [<f89a6d73>] nouveau_bo_unpin+0x33/0x100 [nouveau]
[   86.807030]        [<f89a894f>] nouveau_gem_object_del+0x7f/0xa0 [nouv=
eau]
[   86.814107]        [<f87ae182>] drm_gem_object_free+0x22/0x30 [drm]
[   86.820572]        [<f87aea9f>] drm_gem_object_release_handle+0x8f/0xb=
0 [drm]
[   86.827897]        [<c12b0b84>] idr_for_each+0xa4/0x100
[   86.833309]        [<f87aeeaa>] drm_gem_release+0x1a/0x30 [drm]
[   86.839422]        [<f87ad649>] drm_release+0x4f9/0x570 [drm]
[   86.845374]        [<c1142f9d>] __fput+0xdd/0x200
[   86.850267]        [<c11430fd>] ____fput+0xd/0x10
[   86.855158]        [<c105f301>] task_work_run+0x81/0xb0
[   86.860587]        [<c10451b9>] do_exit+0x269/0x920
[   86.865653]        [<c1045974>] do_group_exit+0x34/0xa0
[   86.871084]        [<c10459f8>] SyS_exit_group+0x18/0x20
[   86.876597]        [<c152fc61>] sysenter_do_call+0x12/0x32
[   86.882296]=20
[   86.882296] other info that might help us debug this:
[   86.882296]=20
 * Asking all re[   86.891156]  Possible unsafe locking scenario:
[   86.891156]=20
[   86.897984]        CPU0                    CPU1
maining processe[   86.902774]        ----                    ----
[   86.908622]   lock(&dev->struct_mutexs to terminate..);
=2E        [   86.914179]                                lock(reservation=
_ww_class_mutex);
[   86.922385]                                lock(&dev->struct_mutex);
[   86.928938]   lock(reservation_ww_class_mutex);
[   86.933667]=20
[   86.933667]  *** DEADLOCK ***
[   86.933667]=20
[   86.940372] 2 locks held by Xorg/1169:
[   86.944291]  #0:  (drm_global_mutex){+.+.+.}, at: [<f87ad17e>] drm_rel=
ease+0x2e/0x570 [drm]
[   86.952887]  #1:  (&dev->struct_mutex){+.+.+.}, at: [<f87aea71>] drm_g=
em_object_release_handle+0x61/0xb0 [drm]
[   86.963122]=20
[   86.963122] stack backtrace:
[   86.967815] CPU: 1 PID: 1169 Comm: Xorg Tainted: G        W    3.11.0-=
rc2-wl-testing-lockdep-00001-gbf7b638-dirty #2
[   86.978497] Hardware name: Dell Inc. Latitude E6410/07XJP9, BIOS A07 0=
2/15/2011
[   86.985967]  00000000 00000000 f70edce4 c1521a01 c1a60850 f70edd04 c15=
1e9cc c16b5b45
[   86.993973]  f70edd68 f343a3c0 f343a870 00000002 f343a888 f70edd98 c10=
9e47f f343a870
[   87.001985]  c109f33c f70edd28 c10cda47 000002b4 00000001 00000024 000=
00001 00000000
[   87.010006] Call Trace:
[   87.012629]  [<c1521a01>] dump_stack+0x4b/0x66
[   87.017249]  [<c151e9cc>] print_circular_bug+0x1af/0x1b9
[   87.022745]  [<c109e47f>] __lock_acquire+0x183f/0x1910
[   87.028057]  [<c109f33c>] ? trace_hardirqs_on_caller+0xec/0x1b0
[   87.034151]  [<c10cda47>] ? rcu_irq_exit+0x67/0xb0
[   87.039116]  [<c12bb1c8>] ? trace_hardirqs_on_thunk+0xc/0x10
[   87.044949]  [<c109ea59>] lock_acquire+0x79/0x100
[   87.049845]  [<f89a6d73>] ? nouveau_bo_unpin+0x33/0x100 [nouveau]
[   87.056111]  [<c15235c6>] mutex_lock_nested+0x66/0x390
[   87.061442]  [<f89a6d73>] ? nouveau_bo_unpin+0x33/0x100 [nouveau]
[   87.067712]  [<c103f763>] ? warn_slowpath_common+0x93/0xa0
[   87.073387]  [<f89a8960>] ? nouveau_gem_object_del+0x90/0xa0 [nouveau]=

[   87.080109]  [<f89a6d73>] nouveau_bo_unpin+0x33/0x100 [nouveau]
[   87.086222]  [<f89a894f>] nouveau_gem_object_del+0x7f/0xa0 [nouveau]
[   87.092760]  [<f87ae182>] drm_gem_object_free+0x22/0x30 [drm]
[   87.098689]  [<f87aea9f>] drm_gem_object_release_handle+0x8f/0xb0 [drm=
]
[   87.105489]  [<f87aea10>] ? drm_gem_handle_create+0x100/0x100 [drm]
[   87.111932]  [<c12b0b84>] idr_for_each+0xa4/0x100
[   87.116819]  [<f87aea10>] ? drm_gem_handle_create+0x100/0x100 [drm]
[   87.123264]  [<c1524fad>] ? mutex_unlock+0xd/0x10
[   87.128152]  [<f87bbf94>] ? drm_fb_release+0xa4/0xb0 [drm]
[   87.133820]  [<f87aeeaa>] drm_gem_release+0x1a/0x30 [drm]
[   87.139398]  [<f87ad649>] drm_release+0x4f9/0x570 [drm]
[   87.144801]  [<c106a75b>] ? lg_local_unlock+0x1b/0x40
[   87.150031]  [<c1142f9d>] __fput+0xdd/0x200
[   87.154391]  [<c11430fd>] ____fput+0xd/0x10
[   87.158754]  [<c105f301>] task_work_run+0x81/0xb0
[   87.163638]  [<c10451b9>] do_exit+0x269/0x920
[   87.168170]  [<c1528536>] ? restore_all+0xf/0xf
[   87.172875]  [<c152bf80>] ? __do_page_fault+0x520/0x520
[   87.178276]  [<c1045974>] do_group_exit+0x34/0xa0
[   87.183158]  [<c10459f8>] SyS_exit_group+0x18/0x20
[   87.188126]  [<c152fc61>] sysenter_do_call+0x12/0x32
[ OK ]

--------------030307030104090500060202--

