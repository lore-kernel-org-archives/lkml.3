Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbaLULlZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 06:41:25 -0500
Received: from mail.sf-mail.de ([78.47.74.12]:46064 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbaLULlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 06:41:10 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Dec 2014 06:41:09 EST
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: linux-kernel@vger.kernel.org
Subject: [3.18 regression]: machine hangs on s2ram
Date: Sun, 21 Dec 2014 12:34:11 +0100
Message-ID: <1729079.GxnV52A97m@caliban.sf-tec.de>
User-Agent: KMail/4.14.3 (Linux/3.18.1-1.g5f2f35e-desktop; KDE/4.14.3; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4565825.pnHNep04Hh"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart4565825.pnHNep04Hh
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Since I upgraded to 3.18 my machine (W740SU based laptop) hangs when I do 
s2ram. For me it looks like the preparations work, but the machine is then not 
switched off. The only way to recover is a hard powercycle. Since the machine 
has no serial port I can't look what's happening then, but the logs do not 
contain anything suspicious until the point when the machine locks up.

Greetings,

Eike

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.18.1-1.g5f2f35e-desktop (geeko@buildhost) (gcc version 4.8.3 20141208 [gcc-4_8-branch revision 218481] (SUSE Linux) ) #1 SMP PREEMPT Wed Dec 17 18:20:30 UTC 2014 (5f2f35e)
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.18.1-1.g5f2f35e-desktop root=/dev/md0 resume=/dev/system/swap splash=silent quiet acpi_osi=Linux acpi_backlight=vendor showopts
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000057fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000058000-0x0000000000058fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000059000-0x000000000009dfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000cb65bfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cb65c000-0x00000000cb662fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000cb663000-0x00000000cbe26fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cbe27000-0x00000000cc0d6fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000cc0d7000-0x00000000db4e2fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000db4e3000-0x00000000db841fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000db842000-0x00000000db89efff] usable
[    0.000000] BIOS-e820: [mem 0x00000000db89f000-0x00000000db9d3fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000db9d4000-0x00000000dbffefff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dbfff000-0x00000000dbffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dd000000-0x00000000df1fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000021fdfffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] efi: EFI v2.31 by American Megatrends
[    0.000000] efi:  ACPI 2.0=0xdb9a7000  ACPI=0xdb9a7000  SMBIOS=0xdbf88598 
[    0.000000] efi: mem00: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000000000-0x0000000000058000) (0MB)
[    0.000000] efi: mem01: [Reserved           |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000058000-0x0000000000059000) (0MB)
[    0.000000] efi: mem02: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000059000-0x000000000009e000) (0MB)
[    0.000000] efi: mem03: [Reserved           |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000000009e000-0x00000000000a0000) (0MB)
[    0.000000] efi: mem04: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000100000-0x00000000015be000) (20MB)
[    0.000000] efi: mem05: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000015be000-0x0000000002000000) (10MB)
[    0.000000] efi: mem06: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000002000000-0x00000000034be000) (20MB)
[    0.000000] efi: mem07: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000034be000-0x00000000350dc000) (796MB)
[    0.000000] efi: mem08: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000350dc000-0x0000000036866000) (23MB)
[    0.000000] efi: mem09: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000036866000-0x0000000091f07000) (1462MB)
[    0.000000] efi: mem10: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000091f07000-0x00000000c81f4000) (866MB)
[    0.000000] efi: mem11: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000c81f4000-0x00000000cb63e000) (52MB)
[    0.000000] efi: mem12: [Loader Code        |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000cb63e000-0x00000000cb65c000) (0MB)
[    0.000000] efi: mem13: [ACPI Memory NVS    |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000cb65c000-0x00000000cb663000) (0MB)
[    0.000000] efi: mem14: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000cb663000-0x00000000cb7b4000) (1MB)
[    0.000000] efi: mem15: [Boot Code          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000cb7b4000-0x00000000cbde7000) (6MB)
[    0.000000] efi: mem16: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000cbde7000-0x00000000cbe04000) (0MB)
[    0.000000] efi: mem17: [Boot Code          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000cbe04000-0x00000000cbe1e000) (0MB)
[    0.000000] efi: mem18: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000cbe1e000-0x00000000cbe27000) (0MB)
[    0.000000] efi: mem19: [Runtime Data       |RUN|  |  |  |   |WB|WT|WC|UC] range=[0x00000000cbe27000-0x00000000cc0d7000) (2MB)
[    0.000000] efi: mem20: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000cc0d7000-0x00000000cc0e4000) (0MB)
[    0.000000] efi: mem21: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000cc0e4000-0x00000000d8a9c000) (201MB)
[    0.000000] efi: mem22: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000d8a9c000-0x00000000d8e6c000) (3MB)
[    0.000000] efi: mem23: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000d8e6c000-0x00000000d8eca000) (0MB)
[    0.000000] efi: mem24: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000d8eca000-0x00000000d8f46000) (0MB)
[    0.000000] efi: mem25: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000d8f46000-0x00000000d8f4b000) (0MB)
[    0.000000] efi: mem26: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000d8f4b000-0x00000000d8f92000) (0MB)
[    0.000000] efi: mem27: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000d8f92000-0x00000000d8f99000) (0MB)
[    0.000000] efi: mem28: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000d8f99000-0x00000000da948000) (25MB)
[    0.000000] efi: mem29: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000da948000-0x00000000db247000) (8MB)
[    0.000000] efi: mem30: [Boot Code          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000db247000-0x00000000db4e3000) (2MB)
[    0.000000] efi: mem31: [Reserved           |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000db4e3000-0x00000000db5a0000) (0MB)
[    0.000000] efi: mem32: [Reserved           |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000db5a0000-0x00000000db842000) (2MB)
[    0.000000] efi: mem33: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000db842000-0x00000000db895000) (0MB)
[    0.000000] efi: mem34: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000db895000-0x00000000db89f000) (0MB)
[    0.000000] efi: mem35: [ACPI Memory NVS    |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000db89f000-0x00000000db9bd000) (1MB)
[    0.000000] efi: mem36: [ACPI Memory NVS    |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000db9bd000-0x00000000db9c4000) (0MB)
[    0.000000] efi: mem37: [ACPI Memory NVS    |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000db9c4000-0x00000000db9d4000) (0MB)
[    0.000000] efi: mem38: [Runtime Data       |RUN|  |  |  |   |WB|WT|WC|UC] range=[0x00000000db9d4000-0x00000000dbda7000) (3MB)
[    0.000000] efi: mem39: [Runtime Data       |RUN|  |  |  |   |WB|WT|WC|UC] range=[0x00000000dbda7000-0x00000000dbf8a000) (1MB)
[    0.000000] efi: mem40: [Runtime Code       |RUN|  |  |  |   |WB|WT|WC|UC] range=[0x00000000dbf8a000-0x00000000dbfa1000) (0MB)
[    0.000000] efi: mem41: [Runtime Code       |RUN|  |  |  |   |WB|WT|WC|UC] range=[0x00000000dbfa1000-0x00000000dbfff000) (0MB)
[    0.000000] efi: mem42: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000dbfff000-0x00000000dc000000) (0MB)
[    0.000000] efi: mem43: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000100000000-0x000000021fe00000) (4606MB)
[    0.000000] efi: mem44: [Reserved           |   |  |  |  |   |  |  |  |  ] range=[0x00000000dd000000-0x00000000df200000) (34MB)
[    0.000000] efi: mem45: [Memory Mapped I/O  |RUN|  |  |  |   |  |  |  |UC] range=[0x00000000f8000000-0x00000000fc000000) (64MB)
[    0.000000] efi: mem46: [Memory Mapped I/O  |RUN|  |  |  |   |  |  |  |UC] range=[0x00000000fec00000-0x00000000fec01000) (0MB)
[    0.000000] efi: mem47: [Memory Mapped I/O  |RUN|  |  |  |   |  |  |  |UC] range=[0x00000000fed00000-0x00000000fed04000) (0MB)
[    0.000000] efi: mem48: [Memory Mapped I/O  |RUN|  |  |  |   |  |  |  |UC] range=[0x00000000fed1c000-0x00000000fed20000) (0MB)
[    0.000000] efi: mem49: [Memory Mapped I/O  |RUN|  |  |  |   |  |  |  |UC] range=[0x00000000fee00000-0x00000000fee01000) (0MB)
[    0.000000] efi: mem50: [Memory Mapped I/O  |RUN|  |  |  |   |  |  |  |UC] range=[0x00000000ff000000-0x0000000100000000) (16MB)
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Notebook                         W740SU                          /W740SU                          , BIOS 4.6.5 07/05/2013
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x21fe00 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask 7E00000000 write-back
[    0.000000]   1 base 0200000000 mask 7FE0000000 write-back
[    0.000000]   2 base 00E0000000 mask 7FE0000000 uncachable
[    0.000000]   3 base 00DE000000 mask 7FFE000000 uncachable
[    0.000000]   4 base 00DD000000 mask 7FFF000000 uncachable
[    0.000000]   5 base 021FE00000 mask 7FFFE00000 uncachable
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xdd000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xdc000 max_arch_pfn = 0x400000000
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x03212000, 0x03212fff] PGTABLE
[    0.000000] BRK [0x03213000, 0x03213fff] PGTABLE
[    0.000000] BRK [0x03214000, 0x03214fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x21fc00000-0x21fdfffff]
[    0.000000]  [mem 0x21fc00000-0x21fdfffff] page 2M
[    0.000000] BRK [0x03215000, 0x03215fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x21c000000-0x21fbfffff]
[    0.000000]  [mem 0x21c000000-0x21fbfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x200000000-0x21bffffff]
[    0.000000]  [mem 0x200000000-0x21bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xcb65bfff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0xbfffffff] page 1G
[    0.000000]  [mem 0xc0000000-0xcb5fffff] page 2M
[    0.000000]  [mem 0xcb600000-0xcb65bfff] page 4k
[    0.000000] init_memory_mapping: [mem 0xcb663000-0xcbe26fff]
[    0.000000]  [mem 0xcb663000-0xcb7fffff] page 4k
[    0.000000]  [mem 0xcb800000-0xcbdfffff] page 2M
[    0.000000]  [mem 0xcbe00000-0xcbe26fff] page 4k
[    0.000000] BRK [0x03216000, 0x03216fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xcc0d7000-0xdb4e2fff]
[    0.000000]  [mem 0xcc0d7000-0xcc1fffff] page 4k
[    0.000000]  [mem 0xcc200000-0xdb3fffff] page 2M
[    0.000000]  [mem 0xdb400000-0xdb4e2fff] page 4k
[    0.000000] BRK [0x03217000, 0x03217fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xdb842000-0xdb89efff]
[    0.000000]  [mem 0xdb842000-0xdb89efff] page 4k
[    0.000000] init_memory_mapping: [mem 0xdbfff000-0xdbffffff]
[    0.000000]  [mem 0xdbfff000-0xdbffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x1ffffffff]
[    0.000000]  [mem 0x100000000-0x1ffffffff] page 1G
[    0.000000] RAMDISK: [mem 0x350dc000-0x36865fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000DB9A7000 000024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 0x00000000DB9A7080 000084 (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x00000000DB9B3B90 00010C (v05 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: DSDT 0x00000000DB9A71A0 00C9EA (v02 ALASKA A M I    00000024 INTL 20091112)
[    0.000000] ACPI: FACS 0x00000000DB9D2080 000040
[    0.000000] ACPI: APIC 0x00000000DB9B3CA0 000092 (v03 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: FPDT 0x00000000DB9B3D38 000044 (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: SSDT 0x00000000DB9B3D80 0015C2 (v01 TrmRef PtidDevc 00001000 INTL 20091112)
[    0.000000] ACPI: SSDT 0x00000000DB9B5348 0004F7 (v01 PmRef  Cpu0Ist  00003000 INTL 20051117)
[    0.000000] ACPI: SSDT 0x00000000DB9B5840 000AD8 (v01 PmRef  CpuPm    00003000 INTL 20051117)
[    0.000000] ACPI: MCFG 0x00000000DB9B6318 00003C (v01 ALASKA A M I    01072009 MSFT 00000097)
[    0.000000] ACPI: HPET 0x00000000DB9B6358 000038 (v01 ALASKA A M I    01072009 AMI. 00000005)
[    0.000000] ACPI: SSDT 0x00000000DB9B6390 000315 (v01 SataRe SataTabl 00001000 INTL 20091112)
[    0.000000] ACPI: SSDT 0x00000000DB9B66A8 001917 (v01 SaSsdt SaSsdt   00003000 INTL 20091112)
[    0.000000] ACPI: DMAR 0x00000000DB9B7FC0 0000B8 (v01 INTEL  HSW      00000001 INTL 00000001)
[    0.000000] ACPI: BGRT 0x00000000DB9B8078 000038 (v00 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000021fdfffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x21fde7000-0x21fdfafff]
[    0.000000]  [ffffea0000000000-ffffea00077fffff] PMD -> [ffff880217400000-ffff88021e5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x21fdfffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x00057fff]
[    0.000000]   node   0: [mem 0x00059000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0xcb65bfff]
[    0.000000]   node   0: [mem 0xcb663000-0xcbe26fff]
[    0.000000]   node   0: [mem 0xcc0d7000-0xdb4e2fff]
[    0.000000]   node   0: [mem 0xdb842000-0xdb89efff]
[    0.000000]   node   0: [mem 0xdbfff000-0xdbffffff]
[    0.000000]   node   0: [mem 0x100000000-0x21fdfffff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x21fdfffff]
[    0.000000] On node 0 totalpages: 2076710
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 22 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 12217 pages used for memmap
[    0.000000]   DMA32 zone: 893578 pages, LIFO batch:31
[    0.000000]   Normal zone: 16121 pages used for memmap
[    0.000000]   Normal zone: 1179136 pages, LIFO batch:31
[    0.000000] Reserving Intel graphics stolen memory at 0xdd200000-0xdf1fffff
[    0.000000] ACPI: PM-Timer IO Port: 0x1808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x00058000-0x00058fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xcb65c000-0xcb662fff]
[    0.000000] PM: Registered nosave memory: [mem 0xcbe27000-0xcc0d6fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdb4e3000-0xdb841fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdb89f000-0xdb9d3fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdb9d4000-0xdbffefff]
[    0.000000] PM: Registered nosave memory: [mem 0xdc000000-0xdcffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdd000000-0xdf1fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdf200000-0xf7ffffff]
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
[    0.000000] e820: [mem 0xdf200000-0xf7ffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88021fa00000 s79872 r8192 d30720 u262144
[    0.000000] pcpu-alloc: s79872 r8192 d30720 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 2048294
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.18.1-1.g5f2f35e-desktop root=/dev/md0 resume=/dev/system/swap splash=silent quiet acpi_osi=Linux acpi_backlight=vendor showopts
[    0.000000] log_buf_len individual max cpu contribution: 32768 bytes
[    0.000000] log_buf_len total cpu_extra contributions: 229376 bytes
[    0.000000] log_buf_len min size: 262144 bytes
[    0.000000] log_buf_len: 524288 bytes
[    0.000000] early log buf free: 242044(92%)
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standard form
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 8037876K/8306840K available (6545K kernel code, 1047K rwdata, 4896K rodata, 1540K init, 1544K bss, 268964K reserved)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=8.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=8
[    0.000000] NR_IRQS:33024 nr_irqs:488 0
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-7.
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 33554432 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 1995.322 MHz processor
[    0.000033] Calibrating delay loop (skipped), value calculated using timer frequency.. 3990.64 BogoMIPS (lpj=1995322)
[    0.000036] pid_max: default: 32768 minimum: 301
[    0.000044] ACPI: Core revision 20140926
[    0.015538] ACPI: All ACPI Tables successfully acquired
[    0.017276] Security Framework initialized
[    0.017289] AppArmor: AppArmor initialized
[    0.017867] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.019777] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.020585] Mount-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.020596] Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.020853] Initializing cgroup subsys memory
[    0.020860] Initializing cgroup subsys devices
[    0.020863] Initializing cgroup subsys freezer
[    0.020865] Initializing cgroup subsys net_cls
[    0.020868] Initializing cgroup subsys blkio
[    0.020871] Initializing cgroup subsys perf_event
[    0.020873] Initializing cgroup subsys net_prio
[    0.020875] Initializing cgroup subsys hugetlb
[    0.020901] CPU: Physical Processor ID: 0
[    0.020902] CPU: Processor Core ID: 0
[    0.020907] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.022051] mce: CPU supports 10 MCE banks
[    0.022070] CPU0: Thermal monitoring enabled (TM1)
[    0.022087] Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 1024
Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 1024, 1GB 4
[    0.022196] Freeing SMP alternatives memory: 24K (ffffffff82088000 - ffffffff8208e000)
[    0.022997] Ignoring BGRT: invalid status 0 (expected 1)
[    0.024204] ftrace: allocating 24968 entries in 98 pages
[    0.035020] dmar: Host address width 39
[    0.035023] dmar: DRHD base: 0x000000fed90000 flags: 0x0
[    0.035029] dmar: IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c0000020660462 ecap f0101a
[    0.035030] dmar: DRHD base: 0x000000fed91000 flags: 0x1
[    0.035035] dmar: IOMMU 1: reg_base_addr fed91000 ver 1:0 cap d2008020660462 ecap f010da
[    0.035036] dmar: RMRR base: 0x000000dbecd000 end: 0x000000dbedbfff
[    0.035038] dmar: RMRR base: 0x000000dd000000 end: 0x000000df1fffff
[    0.035105] IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
[    0.035106] HPET id 0 under DRHD base 0xfed91000
[    0.035107] Queued invalidation will be enabled to support x2apic and Intr-remapping.
[    0.035332] Enabled IRQ remapping in x2apic mode
[    0.035333] Enabling x2apic
[    0.035334] Enabled x2apic
[    0.035339] Switched APIC routing to cluster x2apic.
[    0.035775] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.045773] smpboot: CPU0: Intel(R) Core(TM) i7-4750HQ CPU @ 2.00GHz (fam: 06, model: 46, stepping: 01)
[    0.045780] TSC deadline timer enabled
[    0.045805] Performance Events: PEBS fmt2+, 16-deep LBR, Haswell events, full-width counters, Intel PMU driver.
[    0.045826] ... version:                3
[    0.045827] ... bit width:              48
[    0.045828] ... generic registers:      4
[    0.045829] ... value mask:             0000ffffffffffff
[    0.045830] ... max period:             0000ffffffffffff
[    0.045831] ... fixed-purpose events:   3
[    0.045832] ... event mask:             000000070000000f
[    0.056964] x86: Booting SMP configuration:
[    0.056966] .... node  #0, CPUs:      #1
[    0.078191] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.080220]  #2 #3 #4 #5 #6 #7
[    0.217368] x86: Booted up 1 node, 8 CPUs
[    0.217372] smpboot: Total of 8 processors activated (31925.15 BogoMIPS)
[    0.343693] devtmpfs: initialized
[    0.346908] PM: Registering ACPI NVS region [mem 0xcb65c000-0xcb662fff] (28672 bytes)
[    0.346911] PM: Registering ACPI NVS region [mem 0xdb89f000-0xdb9d3fff] (1265664 bytes)
[    0.347893] pinctrl core: initialized pinctrl subsystem
[    0.347934] RTC time: 11:05:51, date: 12/21/14
[    0.348068] NET: Registered protocol family 16
[    0.350470] cpuidle: using governor ladder
[    0.353477] cpuidle: using governor menu
[    0.353545] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.353547] ACPI: bus type PCI registered
[    0.353549] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.353631] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.353633] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.353718] PCI: Using configuration type 1 for base access
[    0.357955] ACPI: Added _OSI(Module Device)
[    0.357957] ACPI: Added _OSI(Processor Device)
[    0.357959] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.357960] ACPI: Added _OSI(Processor Aggregator Device)
[    0.357962] ACPI: Added _OSI(Linux)
[    0.361912] ACPI: Executed 1 blocks of module-level executable AML code
[    0.365570] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query honored via cmdline
[    0.369656] ACPI: Dynamic OEM Table Load:
[    0.369663] ACPI: SSDT 0xFFFF880214B12800 0003D3 (v01 PmRef  Cpu0Cst  00003001 INTL 20051117)
[    0.373897] ACPI: Dynamic OEM Table Load:
[    0.373903] ACPI: SSDT 0xFFFF880214B0E000 0005AA (v01 PmRef  ApIst    00003000 INTL 20051117)
[    0.378629] ACPI: Dynamic OEM Table Load:
[    0.378634] ACPI: SSDT 0xFFFF880214B17A00 000119 (v01 PmRef  ApCst    00003000 INTL 20051117)
[    1.200245] ACPI: Interpreter enabled
[    1.200256] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140926/hwxface-580)
[    1.200262] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140926/hwxface-580)
[    1.200281] ACPI: (supports S0 S3 S4 S5)
[    1.200283] ACPI: Using IOAPIC for interrupt routing
[    1.200318] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.213561] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    1.213567] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    1.213833] acpi PNP0A08:00: _OSC: platform does not support [PCIeHotplug PME]
[    1.214052] acpi PNP0A08:00: _OSC: OS now controls [AER PCIeCapability]
[    1.214850] PCI host bridge to bus 0000:00
[    1.214854] pci_bus 0000:00: root bus resource [bus 00-3e]
[    1.214856] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.214857] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    1.214859] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    1.214861] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000c3fff]
[    1.214862] pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000c7fff]
[    1.214864] pci_bus 0000:00: root bus resource [mem 0x000c8000-0x000cbfff]
[    1.214865] pci_bus 0000:00: root bus resource [mem 0x000cc000-0x000cffff]
[    1.214868] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
[    1.214869] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    1.214871] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    1.214872] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    1.214874] pci_bus 0000:00: root bus resource [mem 0xdf200000-0xfeafffff]
[    1.214882] pci 0000:00:00.0: [8086:0d04] type 00 class 0x060000
[    1.214984] pci 0000:00:02.0: [8086:0d26] type 00 class 0x030000
[    1.214996] pci 0000:00:02.0: reg 0x10: [mem 0xf7800000-0xf7bfffff 64bit]
[    1.215004] pci 0000:00:02.0: reg 0x18: [mem 0xe0000000-0xefffffff 64bit pref]
[    1.215009] pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
[    1.215106] pci 0000:00:03.0: [8086:0d0c] type 00 class 0x040300
[    1.215114] pci 0000:00:03.0: reg 0x10: [mem 0xf7e34000-0xf7e37fff 64bit]
[    1.215234] pci 0000:00:14.0: [8086:8c31] type 00 class 0x0c0330
[    1.215257] pci 0000:00:14.0: reg 0x10: [mem 0xf7e20000-0xf7e2ffff 64bit]
[    1.215323] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    1.215370] pci 0000:00:14.0: System wakeup disabled by ACPI
[    1.215414] pci 0000:00:16.0: [8086:8c3a] type 00 class 0x078000
[    1.215434] pci 0000:00:16.0: reg 0x10: [mem 0xf7e3f000-0xf7e3f00f 64bit]
[    1.215502] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    1.215592] pci 0000:00:19.0: [8086:153b] type 00 class 0x020000
[    1.215610] pci 0000:00:19.0: reg 0x10: [mem 0xf7e00000-0xf7e1ffff]
[    1.215618] pci 0000:00:19.0: reg 0x14: [mem 0xf7e3d000-0xf7e3dfff]
[    1.215626] pci 0000:00:19.0: reg 0x18: [io  0xf080-0xf09f]
[    1.215690] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    1.215736] pci 0000:00:19.0: System wakeup disabled by ACPI
[    1.215782] pci 0000:00:1a.0: [8086:8c2d] type 00 class 0x0c0320
[    1.215802] pci 0000:00:1a.0: reg 0x10: [mem 0xf7e3c000-0xf7e3c3ff]
[    1.215897] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    1.215964] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    1.216009] pci 0000:00:1b.0: [8086:8c20] type 00 class 0x040300
[    1.216024] pci 0000:00:1b.0: reg 0x10: [mem 0xf7e30000-0xf7e33fff 64bit]
[    1.216089] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    1.216136] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    1.216176] pci 0000:00:1c.0: [8086:8c10] type 01 class 0x060400
[    1.216252] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.216300] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    1.216341] pci 0000:00:1c.1: [8086:8c12] type 01 class 0x060400
[    1.216414] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    1.216461] pci 0000:00:1c.1: System wakeup disabled by ACPI
[    1.216503] pci 0000:00:1c.3: [8086:8c16] type 01 class 0x060400
[    1.216575] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    1.216622] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    1.216672] pci 0000:00:1d.0: [8086:8c26] type 00 class 0x0c0320
[    1.216693] pci 0000:00:1d.0: reg 0x10: [mem 0xf7e3b000-0xf7e3b3ff]
[    1.216787] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    1.216852] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    1.216897] pci 0000:00:1f.0: [8086:8c4b] type 00 class 0x060100
[    1.217077] pci 0000:00:1f.2: [8086:8c03] type 00 class 0x010601
[    1.217093] pci 0000:00:1f.2: reg 0x10: [io  0xf0d0-0xf0d7]
[    1.217100] pci 0000:00:1f.2: reg 0x14: [io  0xf0c0-0xf0c3]
[    1.217108] pci 0000:00:1f.2: reg 0x18: [io  0xf0b0-0xf0b7]
[    1.217115] pci 0000:00:1f.2: reg 0x1c: [io  0xf0a0-0xf0a3]
[    1.217123] pci 0000:00:1f.2: reg 0x20: [io  0xf060-0xf07f]
[    1.217130] pci 0000:00:1f.2: reg 0x24: [mem 0xf7e3a000-0xf7e3a7ff]
[    1.217171] pci 0000:00:1f.2: PME# supported from D3hot
[    1.217254] pci 0000:00:1f.3: [8086:8c22] type 00 class 0x0c0500
[    1.217270] pci 0000:00:1f.3: reg 0x10: [mem 0xf7e39000-0xf7e390ff 64bit]
[    1.217290] pci 0000:00:1f.3: reg 0x20: [io  0xf040-0xf05f]
[    1.217460] acpiphp: Slot [1] registered
[    1.217465] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    1.217562] pci 0000:02:00.0: [10ec:5229] type 00 class 0xff0000
[    1.217580] pci 0000:02:00.0: reg 0x10: [mem 0xf7d00000-0xf7d00fff]
[    1.217701] pci 0000:02:00.0: supports D1 D2
[    1.217703] pci 0000:02:00.0: PME# supported from D1 D2 D3hot
[    1.217733] pci 0000:02:00.0: System wakeup disabled by ACPI
[    1.220268] pci 0000:00:1c.1: PCI bridge to [bus 02]
[    1.220273] pci 0000:00:1c.1:   bridge window [mem 0xf7d00000-0xf7dfffff]
[    1.220381] pci 0000:03:00.0: [8086:08b1] type 00 class 0x028000
[    1.220416] pci 0000:03:00.0: reg 0x10: [mem 0xf7c00000-0xf7c01fff 64bit]
[    1.220590] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    1.220633] pci 0000:03:00.0: System wakeup disabled by ACPI
[    1.223273] pci 0000:00:1c.3: PCI bridge to [bus 03]
[    1.223278] pci 0000:00:1c.3:   bridge window [mem 0xf7c00000-0xf7cfffff]
[    1.223305] acpi PNP0A08:00: Disabling ASPM (FADT indicates it is unsupported)
[    1.224237] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.224318] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.224388] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.224460] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.224529] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.224597] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.224666] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.224734] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.225092] ACPI: Enabled 4 GPEs in block 00 to 3F
[    1.225135] ACPI : EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    1.225213] vgaarb: setting as boot device: PCI:0000:00:02.0
[    1.225215] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    1.225218] vgaarb: loaded
[    1.225219] vgaarb: bridge control possible 0000:00:02.0
[    1.225311] SCSI subsystem initialized
[    1.225358] libata version 3.00 loaded.
[    1.225364] ACPI: bus type USB registered
[    1.225385] usbcore: registered new interface driver usbfs
[    1.225395] usbcore: registered new interface driver hub
[    1.225423] usbcore: registered new device driver usb
[    1.225547] PCI: Using ACPI for IRQ routing
[    1.227020] PCI: pci_cache_line_size set to 64 bytes
[    1.227071] e820: reserve RAM buffer [mem 0x00058000-0x0005ffff]
[    1.227073] e820: reserve RAM buffer [mem 0x0009e000-0x0009ffff]
[    1.227074] e820: reserve RAM buffer [mem 0xcb65c000-0xcbffffff]
[    1.227075] e820: reserve RAM buffer [mem 0xcbe27000-0xcbffffff]
[    1.227077] e820: reserve RAM buffer [mem 0xdb4e3000-0xdbffffff]
[    1.227078] e820: reserve RAM buffer [mem 0xdb89f000-0xdbffffff]
[    1.227080] e820: reserve RAM buffer [mem 0x21fe00000-0x21fffffff]
[    1.227203] NetLabel: Initializing
[    1.227204] NetLabel:  domain hash size = 128
[    1.227205] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.227219] NetLabel:  unlabeled traffic allowed by default
[    1.227255] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    1.227260] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    1.229299] Switched to clocksource hpet
[    1.235319] AppArmor: AppArmor Filesystem Enabled
[    1.235353] pnp: PnP ACPI init
[    1.235453] system 00:00: [mem 0xfed40000-0xfed44fff] has been reserved
[    1.235456] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.235820] system 00:01: [io  0x0680-0x069f] has been reserved
[    1.235822] system 00:01: [io  0xffff] has been reserved
[    1.235824] system 00:01: [io  0xffff] has been reserved
[    1.235826] system 00:01: [io  0xffff] has been reserved
[    1.235828] system 00:01: [io  0x1c00-0x1cfe] has been reserved
[    1.235829] system 00:01: [io  0x1d00-0x1dfe] has been reserved
[    1.235831] system 00:01: [io  0x1e00-0x1efe] has been reserved
[    1.235833] system 00:01: [io  0x1f00-0x1ffe] has been reserved
[    1.235835] system 00:01: [io  0x1800-0x18fe] could not be reserved
[    1.235836] system 00:01: [io  0x164e-0x164f] has been reserved
[    1.235838] system 00:01: [io  0x3322-0x3323] has been reserved
[    1.235840] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.235876] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.235934] system 00:03: [io  0x1854-0x1857] has been reserved
[    1.235937] system 00:03: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    1.235975] pnp 00:04: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.236086] pnp 00:05: Plug and Play ACPI device, IDs SYN1213 PNP0f13 (active)
[    1.236143] system 00:06: [io  0x04d0-0x04d1] has been reserved
[    1.236146] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.236582] system 00:07: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.236584] system 00:07: [mem 0xfed10000-0xfed17fff] has been reserved
[    1.236586] system 00:07: [mem 0xfed18000-0xfed18fff] has been reserved
[    1.236588] system 00:07: [mem 0xfed19000-0xfed19fff] has been reserved
[    1.236590] system 00:07: [mem 0xf8000000-0xfbffffff] has been reserved
[    1.236592] system 00:07: [mem 0xfed20000-0xfed3ffff] has been reserved
[    1.236594] system 00:07: [mem 0xfed90000-0xfed93fff] could not be reserved
[    1.236596] system 00:07: [mem 0xfed45000-0xfed8ffff] has been reserved
[    1.236598] system 00:07: [mem 0xff000000-0xffffffff] has been reserved
[    1.236600] system 00:07: [mem 0xfee00000-0xfeefffff] could not be reserved
[    1.236602] system 00:07: [mem 0xf7ffe000-0xf7ffefff] has been reserved
[    1.236603] system 00:07: [mem 0xf7fe0000-0xf7fe0fff] has been reserved
[    1.236605] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.236892] pnp: PnP ACPI: found 8 devices
[    1.243507] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    1.243519] pci 0000:00:1c.1: PCI bridge to [bus 02]
[    1.243523] pci 0000:00:1c.1:   bridge window [mem 0xf7d00000-0xf7dfffff]
[    1.243531] pci 0000:00:1c.3: PCI bridge to [bus 03]
[    1.243535] pci 0000:00:1c.3:   bridge window [mem 0xf7c00000-0xf7cfffff]
[    1.243543] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.243545] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.243547] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.243548] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000c3fff]
[    1.243550] pci_bus 0000:00: resource 8 [mem 0x000c4000-0x000c7fff]
[    1.243551] pci_bus 0000:00: resource 9 [mem 0x000c8000-0x000cbfff]
[    1.243553] pci_bus 0000:00: resource 10 [mem 0x000cc000-0x000cffff]
[    1.243554] pci_bus 0000:00: resource 11 [mem 0x000d0000-0x000d3fff]
[    1.243556] pci_bus 0000:00: resource 12 [mem 0x000d4000-0x000d7fff]
[    1.243557] pci_bus 0000:00: resource 13 [mem 0x000d8000-0x000dbfff]
[    1.243558] pci_bus 0000:00: resource 14 [mem 0x000dc000-0x000dffff]
[    1.243560] pci_bus 0000:00: resource 15 [mem 0xdf200000-0xfeafffff]
[    1.243562] pci_bus 0000:02: resource 1 [mem 0xf7d00000-0xf7dfffff]
[    1.243563] pci_bus 0000:03: resource 1 [mem 0xf7c00000-0xf7cfffff]
[    1.243631] NET: Registered protocol family 2
[    1.243849] TCP established hash table entries: 65536 (order: 7, 524288 bytes)
[    1.244003] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.244186] TCP: Hash tables configured (established 65536 bind 65536)
[    1.244204] TCP: reno registered
[    1.244215] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    1.244247] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    1.244339] NET: Registered protocol family 1
[    1.244356] pci 0000:00:02.0: Video device with shadowed ROM
[    1.244852] PCI: CLS 64 bytes, default 64
[    1.244906] Unpacking initramfs...
[    1.512573] Freeing initrd memory: 24104K (ffff8800350dc000 - ffff880036866000)
[    1.512602] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.512605] software IO TLB [mem 0xd4a9c000-0xd8a9c000] (64MB) mapped at [ffff8800d4a9c000-ffff8800d8a9bfff]
[    1.513082] microcode: CPU0 sig=0x40661, pf=0x20, revision=0xa
[    1.513090] microcode: CPU1 sig=0x40661, pf=0x20, revision=0xa
[    1.513099] microcode: CPU2 sig=0x40661, pf=0x20, revision=0xa
[    1.513107] microcode: CPU3 sig=0x40661, pf=0x20, revision=0xa
[    1.513115] microcode: CPU4 sig=0x40661, pf=0x20, revision=0xa
[    1.513124] microcode: CPU5 sig=0x40661, pf=0x20, revision=0xa
[    1.513131] microcode: CPU6 sig=0x40661, pf=0x20, revision=0xa
[    1.513139] microcode: CPU7 sig=0x40661, pf=0x20, revision=0xa
[    1.513191] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    1.513226] Scanning for low memory corruption every 60 seconds
[    1.513589] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    1.513623] Initialise system trusted keyring
[    1.513658] audit: initializing netlink subsys (disabled)
[    1.513675] audit: type=2000 audit(1419159952.367:1): initialized
[    1.513958] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.513989] zpool: loaded
[    1.513991] zbud: loaded
[    1.514154] VFS: Disk quotas dquot_6.5.2
[    1.514177] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.514420] msgmni has been set to 15827
[    1.514467] Key type big_key registered
[    1.514783] Key type asymmetric registered
[    1.514785] Asymmetric key parser 'x509' registered
[    1.514809] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    1.514864] io scheduler noop registered
[    1.514867] io scheduler deadline registered
[    1.514883] io scheduler cfq registered (default)
[    1.515357] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.515375] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.515426] efifb: probing for efifb
[    1.515450] efifb: framebuffer at 0xe0000000, mapped to 0xffffc90004e80000, using 8128k, total 8128k
[    1.515451] efifb: mode is 1920x1080x32, linelength=7680, pages=1
[    1.515452] efifb: scrolling: redraw
[    1.515453] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    1.520291] Console: switching to colour frame buffer device 240x67
[    1.525027] fb0: EFI VGA frame buffer device
[    1.525037] intel_idle: MWAIT substates: 0x42120
[    1.525039] intel_idle: v0.4 model 0x46
[    1.525040] intel_idle: lapic_timer_reliable_states 0xffffffff
[    1.525421] GHES: HEST is not enabled!
[    1.525465] Serial: 8250/16550 driver, 32 ports, IRQ sharing disabled
[    1.527121] Non-volatile memory driver v1.3
[    1.527124] Linux agpgart interface v0.103
[    1.527264] ahci 0000:00:1f.2: version 3.0
[    1.527374] ahci 0000:00:1f.2: irq 26 for MSI/MSI-X
[    1.527401] ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
[    1.527422] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x3 impl SATA mode
[    1.527425] ahci 0000:00:1f.2: flags: 64bit ncq stag led clo pio slum part ems apst 
[    1.529849] scsi host0: ahci
[    1.529985] scsi host1: ahci
[    1.530097] scsi host2: ahci
[    1.530213] scsi host3: ahci
[    1.530318] scsi host4: ahci
[    1.530423] scsi host5: ahci
[    1.530473] ata1: SATA max UDMA/133 abar m2048@0xf7e3a000 port 0xf7e3a100 irq 26
[    1.530475] ata2: SATA max UDMA/133 abar m2048@0xf7e3a000 port 0xf7e3a180 irq 26
[    1.530476] ata3: DUMMY
[    1.530477] ata4: DUMMY
[    1.530478] ata5: DUMMY
[    1.530479] ata6: DUMMY
[    1.530506] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.530516] ehci-pci: EHCI PCI platform driver
[    1.530623] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    1.530630] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    1.530643] ehci-pci 0000:00:1a.0: debug port 2
[    1.534558] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    1.534576] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf7e3c000
[    1.540197] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    1.540236] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.540238] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.540240] usb usb1: Product: EHCI Host Controller
[    1.540241] usb usb1: Manufacturer: Linux 3.18.1-1.g5f2f35e-desktop ehci_hcd
[    1.540242] usb usb1: SerialNumber: 0000:00:1a.0
[    1.540384] hub 1-0:1.0: USB hub found
[    1.540391] hub 1-0:1.0: 2 ports detected
[    1.540674] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    1.540680] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    1.540693] ehci-pci 0000:00:1d.0: debug port 2
[    1.544595] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    1.544610] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf7e3b000
[    1.550193] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    1.550232] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    1.550234] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.550235] usb usb2: Product: EHCI Host Controller
[    1.550237] usb usb2: Manufacturer: Linux 3.18.1-1.g5f2f35e-desktop ehci_hcd
[    1.550238] usb usb2: SerialNumber: 0000:00:1d.0
[    1.550381] hub 2-0:1.0: USB hub found
[    1.550387] hub 2-0:1.0: 2 ports detected
[    1.550530] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.550536] uhci_hcd: USB Universal Host Controller Interface driver
[    1.550591] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:SYNM] at 0x60,0x64 irq 1,12
[    1.554913] i8042: Detected active multiplexing controller, rev 1.1
[    1.556711] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.556739] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    1.556760] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    1.556779] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    1.556798] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    1.556942] mousedev: PS/2 mouse device common for all mice
[    1.557046] rtc_cmos 00:02: RTC can wake from S4
[    1.557217] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    1.557246] rtc_cmos 00:02: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    1.557262] Intel P-state driver initializing.
[    1.557548] ledtrig-cpu: registered to indicate activity on CPUs
[    1.557559] EFI Variables Facility v0.08 2004-May-17
[    1.560336] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    1.565688] hidraw: raw HID events driver (C) Jiri Kosina
[    1.565981] usbcore: registered new interface driver usbhid
[    1.565984] usbhid: USB HID core driver
[    1.566138] TCP: cubic registered
[    1.566302] NET: Registered protocol family 10
[    1.568625] Loading compiled-in X.509 certificates
[    1.568654] registered taskstats version 1
[    1.568737] AppArmor: AppArmor sha1 policy hashing enabled
[    1.570273]   Magic number: 10:294:75
[    1.570462] rtc_cmos 00:02: setting system clock to 2014-12-21 11:05:53 UTC (1419159953)
[    1.570682] PM: Checking hibernation image partition /dev/system/swap
[    1.835119] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.836235] ata1.00: ATA-8: HGST HTS725050A7E630, GH2OA420, max UDMA/133
[    1.836239] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.837400] ata1.00: configured for UDMA/133
[    1.837498] scsi 0:0:0:0: Direct-Access     ATA      HGST HTS725050A7 A420 PQ: 0 ANSI: 5
[    1.837635] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    1.837638] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    1.837657] sd 0:0:0:0: [sda] Write Protect is off
[    1.837659] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.837668] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.870350]  sda: sda1 sda2 sda3 sda4
[    1.870769] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.903150] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    1.903161] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    2.142029] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    2.144709] ata2.00: ATA-8: PLEXTOR PX-64M5M, 1.03, max UDMA/133
[    2.144713] ata2.00: 125045424 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    2.145419] ata2.00: configured for UDMA/133
[    2.145556] scsi 1:0:0:0: Direct-Access     ATA      PLEXTOR PX-64M5M 1.03 PQ: 0 ANSI: 5
[    2.145720] sd 1:0:0:0: [sdb] 125045424 512-byte logical blocks: (64.0 GB/59.6 GiB)
[    2.145738] sd 1:0:0:0: [sdb] Write Protect is off
[    2.145740] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.145747] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.146296]  sdb: sdb1 sdb2 sdb3 sdb4
[    2.146569] sd 1:0:0:0: [sdb] Attached SCSI disk
[    2.148430] usb 2-1: New USB device found, idVendor=8087, idProduct=8000
[    2.148433] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.148447] usb 1-1: New USB device found, idVendor=8087, idProduct=8008
[    2.148449] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.148704] hub 2-1:1.0: USB hub found
[    2.148734] hub 1-1:1.0: USB hub found
[    2.148769] hub 1-1:1.0: 6 ports detected
[    2.148776] hub 2-1:1.0: 8 ports detected
[    2.513860] tsc: Refined TSC clocksource calibration: 1995.379 MHz
[    3.020319] psmouse serio2: synaptics: Touchpad model: 1, fw: 8.1, id: 0x1e2b1, caps: 0xd00123/0x840300/0x126c00, board id: 2439, fw id: 1215751
[    3.061807] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio2/input/input6
[    3.106815] PM: Hibernation image not present or could not be loaded.
[    3.107826] Freeing unused kernel memory: 1540K (ffffffff81f07000 - ffffffff82088000)
[    3.107828] Write protecting the kernel read-only data: 14336k
[    3.114481] Freeing unused kernel memory: 1636K (ffff880002667000 - ffff880002800000)
[    3.121053] Freeing unused kernel memory: 1248K (ffff880002cc8000 - ffff880002e00000)
[    3.156848] device-mapper: uevent: version 1.0.3
[    3.156956] device-mapper: ioctl: 4.28.0-ioctl (2014-09-17) initialised: dm-devel@redhat.com
[    3.164040] md: raid0 personality registered for level 0
[    3.165367] md: raid1 personality registered for level 1
[    3.166751] md: raid10 personality registered for level 10
[    3.167930] async_tx: api initialized (async)
[    3.168306] xor: automatically using best checksumming function:
[    3.177595]    avx       : 19864.000 MB/sec
[    3.194590] raid6: sse2x1    6371 MB/s
[    3.211587] raid6: sse2x2    8062 MB/s
[    3.228581] raid6: sse2x4    9238 MB/s
[    3.245569] raid6: avx2x1   12296 MB/s
[    3.262563] raid6: avx2x2   14503 MB/s
[    3.279559] raid6: avx2x4   16449 MB/s
[    3.279560] raid6: using algorithm avx2x4 (16449 MB/s)
[    3.279561] raid6: using avx2x2 recovery algorithm
[    3.280674] md: raid6 personality registered for level 6
[    3.280676] md: raid5 personality registered for level 5
[    3.280677] md: raid4 personality registered for level 4
[    3.285375] rdac: device handler registered
[    3.286593] hp_sw: device handler registered
[    3.287750] emc: device handler registered
[    3.288915] alua: device handler registered
[    3.292213] systemd-udevd[200]: starting version 208
[    3.300731] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input9
[    3.300808] ACPI: Power Button [PWRB]
[    3.300897] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input10
[    3.300962] ACPI: Sleep Button [SLPB]
[    3.301041] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input11
[    3.301155] ACPI: Lid Switch [LID0]
[    3.301226] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input12
[    3.301279] ACPI: Power Button [PWRF]
[    3.302028] thermal LNXTHERM:00: registered as thermal_zone0
[    3.302034] ACPI: Thermal Zone [TZ0] (14 C)
[    3.310716] [drm] Initialized drm 1.1.0 20060810
[    3.316770] [drm] Found 128MB of eLLC
[    3.316810] [drm] Memory usable by graphics device = 2048M
[    3.316813] checking generic (e0000000 7f0000) vs hw (e0000000 10000000)
[    3.316814] fb: switching to inteldrmfb from EFI VGA
[    3.316832] Console: switching to colour dummy device 80x25
[    3.316916] [drm] Replacing VGA console driver
[    3.323671] i915 0000:00:02.0: irq 27 for MSI/MSI-X
[    3.323686] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    3.323687] [drm] Driver supports precise vblank timestamp query.
[    3.323717] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    3.327753] md: bind<sdb3>
[    3.352162] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    3.352268] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input13
[    3.352394] [drm] Initialized i915 1.6.0 20140905 for 0000:00:02.0 on minor 0
[    3.413553] [drm] GMBUS [i915 gmbus vga] timed out, falling back to bit banging on pin 2
[    3.422932] fbcon: inteldrmfb (fb0) is primary device
[    3.513670] Switched to clocksource tsc
[    4.453134] Console: switching to colour frame buffer device 240x67
[    4.458045] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    4.458047] i915 0000:00:02.0: registered panic notifier
[    5.207721] md: linear personality registered for level -1
[    5.214893] random: vgchange urandom read with 38 bits of entropy available
[    6.015852] PM: Marking nosave pages: [mem 0x00000000-0x00000fff]
[    6.015855] PM: Marking nosave pages: [mem 0x00058000-0x00058fff]
[    6.015857] PM: Marking nosave pages: [mem 0x0009e000-0x000fffff]
[    6.015860] PM: Marking nosave pages: [mem 0xcb65c000-0xcb662fff]
[    6.015861] PM: Marking nosave pages: [mem 0xcbe27000-0xcc0d6fff]
[    6.015873] PM: Marking nosave pages: [mem 0xdb4e3000-0xdb841fff]
[    6.015888] PM: Marking nosave pages: [mem 0xdb89f000-0xdbffefff]
[    6.015920] PM: Marking nosave pages: [mem 0xdc000000-0xffffffff]
[    6.016449] PM: Basic memory bitmaps created
[    6.016879] PM: Basic memory bitmaps freed
[    6.078363] PM: Starting manual resume from disk
[    6.078369] PM: Hibernation image partition 254:3 present
[    6.078371] PM: Looking for hibernation image.
[    6.078458] PM: Image not found (code -22)
[    6.078462] PM: Hibernation image not present or could not be loaded.
[    6.143907] md: array md0 already has disks!
[    6.143990] md: bind<dm-2>
[    6.145807] md/raid1:md0: not clean -- starting background reconstruction
[    6.145811] md/raid1:md0: active with 2 out of 2 mirrors
[    6.145852] md0: detected capacity change from 0 to 21457928192
[    6.146241]  md0: unknown partition table
[    6.148014] EXT4-fs (md0): INFO: recovery required on readonly filesystem
[    6.148017] EXT4-fs (md0): write access will be enabled during recovery
[    6.259492] md: resync of RAID array md0
[    6.259495] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[    6.259497] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for resync.
[    6.259500] md: using 128k window, over a total of 20955008k.
[    6.590554] random: nonblocking pool is initialized
[    7.061242] EXT4-fs (md0): orphan cleanup on readonly fs
[    7.061340] EXT4-fs (md0): 6 orphan inodes deleted
[    7.061342] EXT4-fs (md0): recovery complete
[    7.160993] EXT4-fs (md0): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[    7.169591] EXT4-fs (md0): re-mounted. Opts: acl,user_xattr
[    7.288832] systemd[1]: systemd 208 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX -IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[    7.289390] systemd[1]: Set hostname to <caliban>.
[    7.313660] LVM: Logical Volume autoactivation enabled.
[    7.313679] LVM: Activation generator successfully completed.
[    7.350732] systemd[1]: Starting Collect Read-Ahead Data...
[    7.351320] systemd[1]: Starting Replay Read-Ahead Data...
[    7.351646] systemd[1]: Starting Remote File Systems (Pre).
[    7.351686] systemd[1]: Reached target Remote File Systems (Pre).
[    7.351704] systemd[1]: Starting Remote File Systems.
[    7.351734] systemd[1]: Reached target Remote File Systems.
[    7.351747] systemd[1]: Starting Syslog Socket.
[    7.351802] systemd[1]: Listening on Syslog Socket.
[    7.351816] systemd[1]: Starting /dev/initctl Compatibility Named Pipe.
[    7.351855] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
[    7.351864] systemd[1]: Starting Delayed Shutdown Socket.
[    7.351904] systemd[1]: Listening on Delayed Shutdown Socket.
[    7.351913] systemd[1]: Starting LVM2 metadata daemon socket.
[    7.351963] systemd[1]: Listening on LVM2 metadata daemon socket.
[    7.351980] systemd[1]: Starting udev Kernel Socket.
[    7.352020] systemd[1]: Listening on udev Kernel Socket.
[    7.352032] systemd[1]: Starting udev Control Socket.
[    7.352078] systemd[1]: Listening on udev Control Socket.
[    7.352098] systemd[1]: Starting Journal Socket.
[    7.352167] systemd[1]: Listening on Journal Socket.
[    7.352240] systemd[1]: Starting Create list of required static device nodes for the current kernel...
[    7.352545] systemd[1]: Mounting POSIX Message Queue File System...
[    7.352855] systemd[1]: Starting Create dynamic rule for /dev/root link...
[    7.353214] systemd[1]: Mounting Huge Pages File System...
[    7.353605] systemd[1]: Starting LSB: Set default boot entry if called...
[    7.353890] systemd[1]: Starting Journal Service...
[    7.354248] systemd[1]: Started Journal Service.
[    7.367542] systemd-journald[420]: Vacuuming done, freed 0 bytes
[    7.410084] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    7.410122] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    7.412976] systemd-udevd[449]: starting version 208
[    7.435825] EXT4-fs (md0): re-mounted. Opts: acl,user_xattr
[    7.509213] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    7.509274] ACPI: AC Adapter [AC] (off-line)
[    7.511806] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    7.511815] ACPI: Battery Slot [BAT0] (battery present)
[    7.512742] wmi: Mapper loaded
[    7.564985] pps_core: LinuxPPS API ver. 1 registered
[    7.564990] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    7.565149] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    7.565591] PTP clock support registered
[    7.566132] mei_me 0000:00:16.0: irq 28 for MSI/MSI-X
[    7.566798] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    7.566800] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[    7.569056] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    7.569069] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 3
[    7.569628] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    7.569681] xhci_hcd 0000:00:14.0: irq 29 for MSI/MSI-X
[    7.569808] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    7.569812] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.569815] usb usb3: Product: xHCI Host Controller
[    7.569818] usb usb3: Manufacturer: Linux 3.18.1-1.g5f2f35e-desktop xhci-hcd
[    7.569820] usb usb3: SerialNumber: 0000:00:14.0
[    7.571862] hub 3-0:1.0: USB hub found
[    7.571890] hub 3-0:1.0: 14 ports detected
[    7.572709] rtsx_pci 0000:02:00.0: enabling device (0000 -> 0002)
[    7.573014] rtsx_pci 0000:02:00.0: irq 30 for MSI/MSI-X
[    7.573036] rtsx_pci 0000:02:00.0: rtsx_pci_acquire_irq: pcr->msi_en = 1, pci->irq = 30
[    7.577365] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    7.577371] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 4
[    7.577414] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
[    7.577416] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.577418] usb usb4: Product: xHCI Host Controller
[    7.577420] usb usb4: Manufacturer: Linux 3.18.1-1.g5f2f35e-desktop xhci-hcd
[    7.577421] usb usb4: SerialNumber: 0000:00:14.0
[    7.577642] hub 4-0:1.0: USB hub found
[    7.577661] hub 4-0:1.0: 6 ports detected
[    7.579580] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    7.579601] e1000e 0000:00:19.0: irq 31 for MSI/MSI-X
[    7.581135] cfg80211: Calling CRDA to update world regulatory domain
[    7.581528] input: PC Speaker as /devices/platform/pcspkr/input/input14
[    7.582716] Intel(R) Wireless WiFi driver for Linux, in-tree:d
[    7.582718] Copyright(c) 2003- 2014 Intel Corporation
[    7.582756] iwlwifi 0000:03:00.0: enabling device (0000 -> 0002)
[    7.582886] iwlwifi 0000:03:00.0: irq 32 for MSI/MSI-X
[    7.592120] AVX2 version of gcm_enc/dec engaged.
[    7.592123] AES CTR mode by8 optimization enabled
[    7.630069] iwlwifi 0000:03:00.0: Direct firmware load for iwlwifi-7260-10.ucode failed with error -2
[    7.633091] iwlwifi 0000:03:00.0: loaded firmware version 25.222.9.0 op_mode iwlmvm
[    7.641012] iwlwifi 0000:03:00.0: Detected Intel(R) Dual Band Wireless AC 7260, REV=0x144
[    7.641063] iwlwifi 0000:03:00.0: L1 Disabled - LTR Enabled
[    7.641286] iwlwifi 0000:03:00.0: L1 Disabled - LTR Enabled
[    7.709511] cfg80211: World regulatory domain updated:
[    7.709515] cfg80211:  DFS Master region: unset
[    7.709517] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[    7.709519] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
[    7.709521] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
[    7.709522] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm), (N/A)
[    7.709524] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
[    7.709525] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
[    7.750593] e1000e 0000:00:19.0 eth0: registered PHC clock
[    7.750597] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 00:90:f5:ec:24:86
[    7.750599] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[    7.750634] e1000e 0000:00:19.0 eth0: MAC: 11, PHY: 12, PBA No: FFFFFF-0FF
[    7.751548] ACPI Warning: SystemIO range 0x000000000000f040-0x000000000000f05f conflicts with OpRegion 0x000000000000f040-0x000000000000f04f (\_SB_.PCI0.SBUS.SMBI) (20140926/utaddress-258)
[    7.751557] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    7.751600] snd_hda_intel 0000:00:03.0: enabling device (0000 -> 0002)
[    7.751834] snd_hda_intel 0000:00:1b.0: enabling device (0000 -> 0002)
[    7.751835] iTCO_vendor_support: vendor-support=0
[    7.752000] snd_hda_intel 0000:00:1b.0: irq 33 for MSI/MSI-X
[    7.752213] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    7.752256] iTCO_wdt: Found a Lynx Point TCO device (Version=2, TCOBASE=0x1860)
[    7.752389] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    7.752984] snd_hda_intel 0000:00:03.0: irq 34 for MSI/MSI-X
[    7.764097] sound hdaudioC1D0: autoconfig: line_outs=1 (0x24/0x0/0x0/0x0/0x0) type:speaker
[    7.764102] sound hdaudioC1D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    7.764103] sound hdaudioC1D0:    hp_outs=1 (0x25/0x0/0x0/0x0/0x0)
[    7.764105] sound hdaudioC1D0:    mono: mono_out=0x0
[    7.764106] sound hdaudioC1D0:    inputs:
[    7.764108] sound hdaudioC1D0:      Internal Mic=0x30
[    7.764110] sound hdaudioC1D0:      Mic=0x2b
[    7.768329] input: HDA Intel HDMI HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:03.0/sound/card0/input15
[    7.768446] input: HDA Intel HDMI HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:03.0/sound/card0/input16
[    7.768538] input: HDA Intel HDMI HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:03.0/sound/card0/input17
[    7.768995] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card1/input18
[    7.769126] input: HDA Intel PCH Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card1/input19
[    7.843953] ieee80211 phy0: Selected rate control algorithm 'iwl-mvm-rs'
[    7.929894] usb 3-2: new low-speed USB device number 2 using xhci_hcd
[    8.106523] usb 3-2: New USB device found, idVendor=046a, idProduct=0023
[    8.106527] usb 3-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    8.106623] usb 3-2: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
[    8.106627] usb 3-2: ep 0x82 - rounding interval to 64 microframes, ep desc says 80 microframes
[    8.115613] input: HID 046a:0023 as /devices/pci0000:00/0000:00:14.0/usb3/3-2/3-2:1.0/0003:046A:0023.0001/input/input20
[    8.115699] cherry 0003:046A:0023.0001: input,hidraw0: USB HID v1.11 Keyboard [HID 046a:0023] on usb-0000:00:14.0-2/input0
[    8.124866] input: HID 046a:0023 as /devices/pci0000:00/0000:00:14.0/usb3/3-2/3-2:1.1/0003:046A:0023.0002/input/input21
[    8.124949] cherry 0003:046A:0023.0002: input,hidraw1: USB HID v1.11 Device [HID 046a:0023] on usb-0000:00:14.0-2/input1
[    8.277794] usb 3-3: new low-speed USB device number 3 using xhci_hcd
[    8.359174] Adding 8388604k swap on /dev/mapper/system-swap.  Priority:-1 extents:1 across:8388604k FS
[    8.448083] usb 3-3: New USB device found, idVendor=046d, idProduct=c050
[    8.448088] usb 3-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    8.448089] usb 3-3: Product: USB-PS/2 Optical Mouse
[    8.448091] usb 3-3: Manufacturer: Logitech
[    8.448203] usb 3-3: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
[    8.453284] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:14.0/usb3/3-3/3-3:1.0/0003:046D:C050.0003/input/input22
[    8.453395] hid-generic 0003:046D:C050.0003: input,hidraw2: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:14.0-3/input0
[    8.605679] usb 3-4: new full-speed USB device number 4 using xhci_hcd
[    8.770680] usb 3-4: New USB device found, idVendor=8087, idProduct=07dc
[    8.770685] usb 3-4: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    8.774701] Bluetooth: Core ver 2.19
[    8.774717] NET: Registered protocol family 31
[    8.774718] Bluetooth: HCI device and connection manager initialized
[    8.774724] Bluetooth: HCI socket layer initialized
[    8.774726] Bluetooth: L2CAP socket layer initialized
[    8.774732] Bluetooth: SCO socket layer initialized
[    8.775394] usbcore: registered new interface driver btusb
[    8.788603] Bluetooth: hci0: read Intel version: 370710018002030d00
[    8.788990] Bluetooth: hci0: Intel Bluetooth firmware file: intel/ibt-hw-37.7.10-fw-1.80.2.3.d.bseq
[    8.922601] Bluetooth: hci0: Intel Bluetooth firmware patch completed and activated
[    9.199451] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[    9.823023] FAT-fs (sda1): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
[   10.503658] EXT4-fs (dm-4): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[   13.982986] EXT4-fs (dm-5): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[   14.221430] EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[   14.226359] systemd-journald[420]: Received request to flush runtime journal from PID 1
[   14.397029] audit: type=1400 audit(1419159966.329:2): apparmor="STATUS" operation="profile_load" name="/{usr/,}bin/ping" pid=893 comm="apparmor_parser"
[   14.407365] audit: type=1400 audit(1419159966.339:3): apparmor="STATUS" operation="profile_load" name="/sbin/klogd" pid=904 comm="apparmor_parser"
[   14.412616] audit: type=1400 audit(1419159966.345:4): apparmor="STATUS" operation="profile_load" name="/sbin/syslog-ng" pid=908 comm="apparmor_parser"
[   14.417659] audit: type=1400 audit(1419159966.350:5): apparmor="STATUS" operation="profile_load" name="/sbin/syslogd" pid=912 comm="apparmor_parser"
[   14.450148] audit: type=1400 audit(1419159966.382:6): apparmor="STATUS" operation="profile_load" name="/usr/lib/apache2/mpm-prefork/apache2" pid=917 comm="apparmor_parser"
[   14.450156] audit: type=1400 audit(1419159966.382:7): apparmor="STATUS" operation="profile_load" name="DEFAULT_URI" pid=917 comm="apparmor_parser"
[   14.450161] audit: type=1400 audit(1419159966.382:8): apparmor="STATUS" operation="profile_load" name="HANDLING_UNTRUSTED_INPUT" pid=917 comm="apparmor_parser"
[   14.450166] audit: type=1400 audit(1419159966.382:9): apparmor="STATUS" operation="profile_load" name="phpsysinfo" pid=917 comm="apparmor_parser"
[   14.454832] audit: type=1400 audit(1419159966.387:10): apparmor="STATUS" operation="profile_load" name="/usr/lib/dovecot/anvil" pid=921 comm="apparmor_parser"
[   14.459990] audit: type=1400 audit(1419159966.392:11): apparmor="STATUS" operation="profile_load" name="/usr/lib/dovecot/auth" pid=925 comm="apparmor_parser"
[   20.072793] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   20.072794] Bluetooth: BNEP filters: protocol multicast
[   20.072801] Bluetooth: BNEP socket layer initialized
[   20.091759] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   20.097008] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   20.099263] ip_tables: (C) 2000-2006 Netfilter Core Team
[   20.611494] e1000e 0000:00:19.0: irq 31 for MSI/MSI-X
[   20.662788] EXT4-fs (dm-7): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[   20.712306] e1000e 0000:00:19.0: irq 31 for MSI/MSI-X
[   20.712381] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   20.714552] iwlwifi 0000:03:00.0: L1 Disabled - LTR Enabled
[   20.714776] iwlwifi 0000:03:00.0: L1 Disabled - LTR Enabled
[   20.726116] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   20.729737] NET: Registered protocol family 17

--nextPart4565825.pnHNep04Hh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEABECAAYFAlSWsDoACgkQXKSJPmm5/E5LHQCglKMqnhXJw166isejLEmMElAT
kFoAoI6ArfnDWG6tWIfRcYSsQ7n468IB
=2cXI
-----END PGP SIGNATURE-----

--nextPart4565825.pnHNep04Hh--

