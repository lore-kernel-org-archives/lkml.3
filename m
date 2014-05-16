Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665AbaEPIoF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 04:44:05 -0400
Received: from mx1.emlix.com ([88.198.240.195]:48449 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755537AbaEPIn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 04:43:56 -0400
From: Rolf Eike Beer <eb@emlix.com>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: wsa@the-dreams.de, rjw@rjwysocki.net, mika.westerberg@linux.intel.com,
        awilliam@redhat.com, lenb@kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [Patch V2 0/9] I2C ACPI operation region handler support
Date: Fri, 16 May 2014 10:43:34 +0200
Message-ID: <10532278.SlmyFe4oRp@devpool02>
Organization: Emlix GmbH
User-Agent: KMail/4.13 (Linux/3.14.3-1.g2a280a3-desktop; KDE/4.13.0; x86_64; ; )
In-Reply-To: <5374D401.2010608@intel.com>
References: <1398147855-9868-1-git-send-email-tianyu.lan@intel.com> <2676258.HXv5hGZIFG@devpool02> <5374D401.2010608@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1781176.YgsH4mdxu6"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1781176.YgsH4mdxu6
Content-Type: multipart/mixed; boundary="nextPart9796051.zhVmkHVF2l"
Content-Transfer-Encoding: quoted-printable

This is a multi-part message in MIME format.

=2D-nextPart9796051.zhVmkHVF2l
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Am Donnerstag, 15. Mai 2014, 22:49:37 schrieb Lan Tianyu:
> On 05/15/2014 03:50 PM, Rolf Eike Beer wrote:
> > Lan Tianyu wrote:
> >> On 05/13/2014 09:09 PM, Rolf Eike Beer wrote:
> >>> Am Montag, 28. April 2014, 22:27:39 schrieb Lan Tianyu:
> >>>> ACPI 5.0 spec(5.5.2.4.5) defines GenericSerialBus(i2c, spi, uart=
)
> >>>> operation
> >>>> region. It allows ACPI aml code able to access such kind of devi=
ces to
> >>>> implement some ACPI standard method.
> >>>>=20
> >>>> On the Asus T100TA, Bios use GenericSerialBus operation region t=
o
> >>>> access
> >>>> i2c device to get battery info. So battery function depends on t=
he I2C
> >>>> operation region support. Here is the bug link.
> >>>> https://bugzilla.kernel.org/show_bug.cgi?id=3D69011
> >>>=20
> >>> Hi all,
> >>>=20
> >>> I have tested this series and got some errors, but no additional
> >=20
> > functionality:
> >> Hi Rolf:
> >> =09Thanks for test. Could you attach the output of dmesg and acpid=
ump?
> >>=20
> >> Which machine you are testing on?
> >=20
> > Hi,
> >=20
> > this is an Aava Inari 8 tablet (pre-release hardware). Please find =
the
> > DSDT
> > and the dmesg.log attached.
> >=20
> > In case of any further questions don't hesitate to ask, I'll try to=
 be
> > more
> > responsible.
>=20
> Hi Eike:
> =09Could you apply the patch in the attachment and attach the output =
of
> =09dmesg?

Sure, here it is.

Regards,

Eike
=2D-=20
Rolf Eike Beer, emlix GmbH, http://www.emlix.com
Fon +49 551 30664-0, Fax +49 551 30664-11
Bertha-von-Suttner-Str. 9, 37085 G=F6ttingen, Germany
Sitz der Gesellschaft: G=F6ttingen, Amtsgericht G=F6ttingen HR B 3160
Gesch=E4ftsf=FChrung: Dr. Uwe Kracke, Ust-IdNr.: DE 205 198 055

emlix - smart embedded open source

=2D-nextPart9796051.zhVmkHVF2l
Content-Disposition: attachment; filename="dmesg.debug"
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"; name="dmesg.debug"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.15.0-rc5-Inari (root@devpool02) (gcc version 4.8.2 (Emlix Linux Inari) ) #1 SMP Fri May 16 08:25:11 UTC 2014
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000008efff] usable
[    0.000000] BIOS-e820: [mem 0x000000000008f000-0x000000000008ffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000000090000-0x000000000009dfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000200fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020100000-0x0000000078345fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000078346000-0x0000000078c45fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000078c46000-0x0000000078d45fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000078d46000-0x0000000078d85fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000078d86000-0x00000000794c7fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000794c8000-0x0000000079dc7fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000079dc8000-0x0000000079ffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000e00f8000-0x00000000e00f8fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed01000-0x00000000fed01fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffd00000-0x00000000ffffffff] reserved
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] efi: EFI v2.31 by INSYDE Corp.
[    0.000000] efi:  ACPI 2.0=0x78d85014  SMBIOS=0x78c45000 
[    0.000000] efi: mem00: type=7, attr=0xf, range=[0x0000000000000000-0x0000000000001000) (0MB)
[    0.000000] efi: mem01: type=2, attr=0xf, range=[0x0000000000001000-0x0000000000007000) (0MB)
[    0.000000] efi: mem02: type=7, attr=0xf, range=[0x0000000000007000-0x000000000008f000) (0MB)
[    0.000000] efi: mem03: type=10, attr=0xf, range=[0x000000000008f000-0x0000000000090000) (0MB)
[    0.000000] efi: mem04: type=7, attr=0xf, range=[0x0000000000090000-0x000000000009e000) (0MB)
[    0.000000] efi: mem05: type=0, attr=0xf, range=[0x000000000009e000-0x00000000000a0000) (0MB)
[    0.000000] efi: mem06: type=7, attr=0xf, range=[0x0000000000100000-0x0000000001000000) (15MB)
[    0.000000] efi: mem07: type=2, attr=0xf, range=[0x0000000001000000-0x000000000257f000) (21MB)
[    0.000000] efi: mem08: type=7, attr=0xf, range=[0x000000000257f000-0x0000000020000000) (474MB)
[    0.000000] efi: mem09: type=0, attr=0xf, range=[0x0000000020000000-0x0000000020100000) (1MB)
[    0.000000] efi: mem10: type=7, attr=0xf, range=[0x0000000020100000-0x0000000071dc0000) (1308MB)
[    0.000000] efi: mem11: type=4, attr=0xf, range=[0x0000000071dc0000-0x0000000071de0000) (0MB)
[    0.000000] efi: mem12: type=7, attr=0xf, range=[0x0000000071de0000-0x0000000072bca000) (13MB)
[    0.000000] efi: mem13: type=2, attr=0xf, range=[0x0000000072bca000-0x0000000072bcc000) (0MB)
[    0.000000] efi: mem14: type=1, attr=0xf, range=[0x0000000072bcc000-0x0000000073b46000) (15MB)
[    0.000000] efi: mem15: type=7, attr=0xf, range=[0x0000000073b46000-0x0000000076a92000) (47MB)
[    0.000000] efi: mem16: type=4, attr=0xf, range=[0x0000000076a92000-0x00000000774ec000) (10MB)
[    0.000000] efi: mem17: type=7, attr=0xf, range=[0x00000000774ec000-0x00000000774f9000) (0MB)
[    0.000000] efi: mem18: type=4, attr=0xf, range=[0x00000000774f9000-0x0000000077d46000) (8MB)
[    0.000000] efi: mem19: type=7, attr=0xf, range=[0x0000000077d46000-0x0000000078161000) (4MB)
[    0.000000] efi: mem20: type=3, attr=0xf, range=[0x0000000078161000-0x0000000078346000) (1MB)
[    0.000000] efi: mem21: type=5, attr=0x800000000000000f, range=[0x0000000078346000-0x0000000078546000) (2MB)
[    0.000000] efi: mem22: type=6, attr=0x800000000000000f, range=[0x0000000078546000-0x0000000078846000) (3MB)
[    0.000000] efi: mem23: type=0, attr=0xf, range=[0x0000000078846000-0x0000000078c46000) (4MB)
[    0.000000] efi: mem24: type=10, attr=0xf, range=[0x0000000078c46000-0x0000000078d46000) (1MB)
[    0.000000] efi: mem25: type=9, attr=0xf, range=[0x0000000078d46000-0x0000000078d86000) (0MB)
[    0.000000] efi: mem26: type=4, attr=0xf, range=[0x0000000078d86000-0x00000000794c8000) (7MB)
[    0.000000] efi: mem27: type=10, attr=0xf, range=[0x00000000794c8000-0x0000000079dc8000) (9MB)
[    0.000000] efi: mem28: type=4, attr=0xf, range=[0x0000000079dc8000-0x000000007a000000) (2MB)
[    0.000000] efi: mem29: type=11, attr=0x8000000000000001, range=[0x00000000e00f8000-0x00000000e00f9000) (0MB)
[    0.000000] efi: mem30: type=11, attr=0x8000000000000000, range=[0x00000000fed01000-0x00000000fed02000) (0MB)
[    0.000000] efi: mem31: type=11, attr=0x8000000000000000, range=[0x00000000ffd00000-0x0000000100000000) (3MB)
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Aava Mobile Oy Inari 8 2GB/Type2 - Board Product Name, BIOS BYT.5.03.47.0033-022 01/16/2014
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x7a000 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0FFD00000 mask FFFC00000 write-protect
[    0.000000]   1 base 000000000 mask FC0000000 write-back
[    0.000000]   2 base 040000000 mask FE0000000 write-back
[    0.000000]   3 base 060000000 mask FF0000000 write-back
[    0.000000]   4 base 070000000 mask FF8000000 write-back
[    0.000000]   5 base 078000000 mask FFC000000 write-back
[    0.000000]   6 base 07B000000 mask FFF000000 uncachable
[    0.000000]   7 base 07AE00000 mask FFFE00000 uncachable
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x027fffff]
[    0.000000] Base memory trampoline at [c009a000] 9a000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x37000000-0x373fffff]
[    0.000000]  [mem 0x37000000-0x373fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x30000000-0x36ffffff]
[    0.000000]  [mem 0x30000000-0x36ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x1fffffff]
[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x1fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x20100000-0x2fffffff]
[    0.000000]  [mem 0x20100000-0x203fffff] page 4k
[    0.000000]  [mem 0x20400000-0x2fffffff] page 2M
[    0.000000] BRK [0x02464000, 0x02464fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x37400000-0x377fdfff]
[    0.000000]  [mem 0x37400000-0x377fdfff] page 4k
[    0.000000] BRK [0x02465000, 0x02465fff] PGTABLE
[    0.000000] ACPI: RSDP 0x78D85014 000024 (v02 INSYDE)
[    0.000000] ACPI: XSDT 0x78D61188 0000D4 (v01 INSYDE INSYDE   00000003      01000013)
[    0.000000] ACPI: FACP 0x78D7F000 00010C (v05 INSYDE INSYDE   00000003 ACPI 00040000)
[    0.000000] ACPI: DSDT 0x78D6E000 00BAEC (v02 INSYDE INSYDE   00000003 ACPI 00040000)
[    0.000000] ACPI: UEFI 0x78D84000 000236 (v01 INSYDE INSYDE   00000001 ACPI 00040000)
[    0.000000] ACPI: TCPA 0x78D83000 000032 (v02 INSYDE INSYDE   00000000 ACPI 00040000)
[    0.000000] ACPI: UEFI 0x78D81000 000042 (v01 INSYDE INSYDE   00000000 ACPI 00040000)
[    0.000000] ACPI: DBG2 0x78D80000 000072 (v00 INSYDE INSYDE   00000003 ACPI 00040000)
[    0.000000] ACPI: HPET 0x78D7E000 000038 (v01 INSYDE INSYDE   00000003 ACPI 00040000)
[    0.000000] ACPI: LPIT 0x78D7D000 000104 (v01 INSYDE INSYDE   00000003 ACPI 00040000)
[    0.000000] ACPI: APIC 0x78D7C000 00006C (v03 INSYDE INSYDE   00000003 ACPI 00040000)
[    0.000000] ACPI: MCFG 0x78D7B000 00003C (v01 INSYDE INSYDE   00000003 ACPI 00040000)
[    0.000000] ACPI: SLIC 0x78D7A000 000176 (v01 INSYDE INSYDE   00000003 ACPI 00040000)
[    0.000000] ACPI: SSDT 0x78D6D000 0005FB (v01 INSYDE CpuDptf  00000003 ACPI 00040000)
[    0.000000] ACPI: SSDT 0x78D6B000 0018C2 (v01 INSYDE DptfTab  00000003 ACPI 00040000)
[    0.000000] ACPI: SSDT 0x78D6A000 000058 (v01 INSYDE LowPwrM  00000003 ACPI 00040000)
[    0.000000] ACPI: SSDT 0x78D69000 0000FF (v01 INSYDE SoCDptf  00000003 ACPI 00040000)
[    0.000000] ACPI: SSDT 0x78D68000 00043A (v01 INSYDE Tpm2Tabl 00001000 ACPI 00040000)
[    0.000000] ACPI: TPM2 0x78D67000 000034 (v03 INSYDE INSYDE   00000000 ACPI 00040000)
[    0.000000] ACPI: SSDT 0x78D66000 000763 (v01 INSYDE CpuPm    00003000 ACPI 00040000)
[    0.000000] ACPI: SSDT 0x78D65000 000290 (v01 INSYDE Cpu0Tst  00003000 ACPI 00040000)
[    0.000000] ACPI: SSDT 0x78D64000 00017A (v01 INSYDE ApTst    00003000 ACPI 00040000)
[    0.000000] ACPI: FPDT 0x78D63000 000044 (v01 INSYDE INSYDE   00000001 ACPI 00040000)
[    0.000000] ACPI: CSRT 0x78D62000 00014C (v00 INSYDE INSYDE   00000005 ACPI 00040000)
[    0.000000] ACPI: BGRT 0x78D60000 000038 (v01 INSYDE INSYDE   00000001 ACPI 00040000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 1064MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000] BRK [0x02466000, 0x02466fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x377fdfff]
[    0.000000]   HighMem  [mem 0x377fe000-0x79ffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0008efff]
[    0.000000]   node   0: [mem 0x00090000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
[    0.000000]   node   0: [mem 0x20100000-0x78345fff]
[    0.000000]   node   0: [mem 0x78d86000-0x794c7fff]
[    0.000000]   node   0: [mem 0x79dc8000-0x79ffffff]
[    0.000000] On node 0 totalpages: 494428
[    0.000000] free_area_init_node: node 0, pgdat c17401c0, node_mem_map f68be020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 222974 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2129 pages used for memmap
[    0.000000]   HighMem zone: 267458 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] x86/hpet: Will disable the HPET for this platform because it's not reliable
[    0.000000] Reserving Intel graphics stolen memory at 0x7af00000-0x7eefffff
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-86
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 103
[    0.000000] PM: Registered nosave memory: [mem 0x0008f000-0x0008ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x20000000-0x200fffff]
[    0.000000] e820: [mem 0x7ef00000-0xe00f7fff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 12 pages/cpu @f6882000 s27264 r0 d21888 u49152
[    0.000000] pcpu-alloc: s27264 r0 d21888 u49152 alloc=12*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 492652
[    0.000000] Kernel command line: root=/dev/sda2 video=HDMI-A-1:1200x1920e drm_kms_helper.edid_firmware=HDMI-A-1:edid/1200x1920.bin 
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (000377fe:0007a000)
[    0.000000] Initializing Movable for node 0 (00000000:00000000)
[    0.000000] Memory: 1909220K/1977712K available (5505K kernel code, 331K rwdata, 1640K rodata, 12092K init, 1236K bss, 68492K reserved, 1038956K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff66000 - 0xfffff000   ( 612 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc1750000 - 0xc231f000   (12092 kB)
[    0.000000]       .data : 0xc1560b12 - 0xc174efc0   (1977 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1560b12   (5506 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:2304 nr_irqs:1024 16
[    0.000000] CPU 0 irqstacks, hard=f600c000 soft=f600e000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Maximum core-clock to bus-clock ratio: 0xa
[    0.000000] Resolved frequency ID: 2, frequency: 133200 KHz
[    0.000000] TSC runs at 1332000 KHz
[    0.000000] lapic_timer_frequency = 133200
[    0.000000] tsc: Detected 1332.000 MHz processor
[    0.000037] Calibrating delay loop (skipped), value calculated using timer frequency.. 2664.00 BogoMIPS (lpj=1332000)
[    0.000054] pid_max: default: 32768 minimum: 301
[    0.000071] ACPI: Core revision 20140214
[    0.044032] ACPI: All ACPI Tables successfully acquired
[    0.046878] Mount-cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.046898] Mountpoint-cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.047248] Initializing cgroup subsys freezer
[    0.047290] CPU: Physical Processor ID: 0
[    0.047300] CPU: Processor Core ID: 0
[    0.047311] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.047311] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.059441] mce: CPU supports 6 MCE banks
[    0.059460] CPU0: Thermal monitoring enabled (TM1)
[    0.059480] Last level iTLB entries: 4KB 48, 2MB 0, 4MB 0
[    0.059480] Last level dTLB entries: 4KB 128, 2MB 16, 4MB 16, 1GB 0
[    0.059480] tlb_flushall_shift: 6
[    0.059673] Freeing SMP alternatives memory: 20K (c231f000 - c2324000)
[    0.059708] ------------[ cut here ]------------
[    0.059727] WARNING: CPU: 0 PID: 0 at /tmp/e2/build/linux-git/mm/early_ioremap.c:136 __early_ioremap+0xee/0x1a6()
[    0.059739] Modules linked in:
[    0.059752] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.15.0-rc5-Inari #1
[    0.059762] Hardware name: Aava Mobile Oy Inari 8 2GB/Type2 - Board Product Name, BIOS BYT.5.03.47.0033-022 01/16/2014
[    0.059775]  00000000 00000000 c16fdf0c c155483e 00000000 c16fdf3c c103d194 c164be20
[    0.059797]  00000000 00000000 c16539b8 00000088 c176cc03 c176cc03 00000042 77526000
[    0.059819]  00000000 c16fdf4c c103d22d 00000009 00000000 c16fdfa0 c176cc03 c1740ec0
[    0.059840] Call Trace:
[    0.059854]  [<c155483e>] dump_stack+0x41/0x52
[    0.059867]  [<c103d194>] warn_slowpath_common+0x74/0x90
[    0.059880]  [<c176cc03>] ? __early_ioremap+0xee/0x1a6
[    0.059892]  [<c176cc03>] ? __early_ioremap+0xee/0x1a6
[    0.059903]  [<c103d22d>] warn_slowpath_null+0x1d/0x20
[    0.059915]  [<c176cc03>] __early_ioremap+0xee/0x1a6
[    0.059928]  [<c10368df>] ? __native_set_fixmap+0x1f/0x30
[    0.059941]  [<c176ce70>] early_memremap+0xd/0xf
[    0.059953]  [<c1763743>] efi_bgrt_init+0xe6/0x129
[    0.059965]  [<c1763067>] efi_late_init+0x8/0xa
[    0.059978]  [<c1750a3b>] start_kernel+0x34f/0x35f
[    0.059990]  [<c1750523>] ? repair_env_string+0x51/0x51
[    0.060003]  [<c1750369>] i386_start_kernel+0x137/0x13a
[    0.060040] ---[ end trace 27ffb688a5381019 ]---
[    0.062989] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.064018] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.074045] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[    0.074054] ...trying to set up timer (IRQ0) through the 8259A ...
[    0.074063] ..... (found apic 0 pin 2) ...
[    0.084079] ....... works.
[    0.084087] smpboot: CPU0: Intel(R) Atom(TM) CPU  Z3745  @ 1.33GHz (fam: 06, model: 37, stepping: 08)
[    0.084126] TSC deadline timer enabled
[    0.084141] Performance Events: PEBS fmt2+, 8-deep LBR, Silvermont events, full-width counters, Intel PMU driver.
[    0.084168] ... version:                3
[    0.084176] ... bit width:              40
[    0.084183] ... generic registers:      2
[    0.084191] ... value mask:             000000ffffffffff
[    0.084199] ... max period:             000000ffffffffff
[    0.084207] ... fixed-purpose events:   3
[    0.084214] ... event mask:             0000000700000003
[    0.085792] CPU 1 irqstacks, hard=f60a6000 soft=f60b0000
[    0.085798] x86: Booting SMP configuration:
[    0.085809] .... node  #0, CPUs:      #1
[    0.095924] Initializing CPU#1
[    0.111134] CPU 2 irqstacks, hard=f60ba000 soft=f60bc000
[    0.111153]  #2
[    0.121206] Initializing CPU#2
[    0.136519] CPU 3 irqstacks, hard=f60c6000 soft=f60c8000
[    0.136533]  #3
[    0.146587] Initializing CPU#3
[    0.161772] x86: Booted up 1 node, 4 CPUs
[    0.161791] smpboot: Total of 4 processors activated (10656.00 BogoMIPS)
[    0.162741] devtmpfs: initialized
[    0.163227] PM: Registering ACPI NVS region [mem 0x0008f000-0x0008ffff] (4096 bytes)
[    0.163242] PM: Registering ACPI NVS region [mem 0x78c46000-0x78d45fff] (1048576 bytes)
[    0.163294] PM: Registering ACPI NVS region [mem 0x794c8000-0x79dc7fff] (9437184 bytes)
[    0.163841] pinctrl core: initialized pinctrl subsystem
[    0.163902] RTC time:  0:40:53, date: 05/16/14
[    0.163989] NET: Registered protocol family 16
[    0.164313] cpuidle: using governor ladder
[    0.164324] cpuidle: using governor menu
[    0.164398] ACPI: bus type PCI registered
[    0.164551] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
[    0.164568] PCI: not using MMCONFIG
[    0.164920] PCI: Using configuration type 1 for base access
[    0.170069] ACPI: Added _OSI(Module Device)
[    0.170084] ACPI: Added _OSI(Processor Device)
[    0.170094] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.170103] ACPI: Added _OSI(Processor Aggregator Device)
[    0.204674] ACPI: SSDT 0x78BCAA90 000353 (v01 PmRef  Cpu0Ist  00003000 INTL 20130117)
[    0.206249] ACPI: Dynamic OEM Table Load:
[    0.206264] ACPI: SSDT 0x00000000 000353 (v01 PmRef  Cpu0Ist  00003000 INTL 20130117)
[    0.206799] ACPI: SSDT 0x78BC9910 000433 (v01 PmRef  Cpu0Cst  00003001 INTL 20130117)
[    0.208647] ACPI: Dynamic OEM Table Load:
[    0.208661] ACPI: SSDT 0x00000000 000433 (v01 PmRef  Cpu0Cst  00003001 INTL 20130117)
[    0.215236] ACPI: SSDT 0x78BCBD90 00015F (v01 PmRef  ApIst    00003000 INTL 20130117)
[    0.216837] ACPI: Dynamic OEM Table Load:
[    0.216851] ACPI: SSDT 0x00000000 00015F (v01 PmRef  ApIst    00003000 INTL 20130117)
[    0.219400] ACPI: SSDT 0x78BCBF10 00008D (v01 PmRef  ApCst    00003000 INTL 20130117)
[    0.220819] ACPI: Dynamic OEM Table Load:
[    0.220832] ACPI: SSDT 0x00000000 00008D (v01 PmRef  ApCst    00003000 INTL 20130117)
[    0.226624] ACPI: Interpreter enabled
[    0.226659] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140214/hwxface-580)
[    0.226683] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140214/hwxface-580)
[    0.226705] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S3_] (20140214/hwxface-580)
[    0.226726] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S4_] (20140214/hwxface-580)
[    0.226746] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S5_] (20140214/hwxface-580)
[    0.226764] ACPI: (supports S0)
[    0.226773] ACPI: Using IOAPIC for interrupt routing
[    0.226862] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
[    0.234470] [Firmware Info]: PCI: MMCONFIG at [mem 0xe0000000-0xe3ffffff] not reserved in ACPI motherboard resources
[    0.234487] PCI: not using MMCONFIG
[    0.234540] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.237741] ACPI: Power Resource [USBC] (on)
[    0.241990] ACPI: Power Resource [WWPR] (off)
[    0.252641] ACPI: Power Resource [PLPE] (on)
[    0.264429] ACPI: Power Resource [CLK0] (on)
[    0.264566] ACPI: Power Resource [CLK1] (on)
[    0.264924] ACPI: Power Resource [P28X] (off)
[    0.265067] ACPI: Power Resource [P18X] (off)
[    0.267582] ACPI: Power Resource [TCPR] (off)
[    0.274577] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.274601] acpi PNP0A08:00: _OSC: OS supports [ASPM ClockPM Segments MSI]
[    0.274806] \_SB_.PCI0:_OSC invalid UUID
[    0.274811] _OSC request data:1 1e 0 
[    0.274824] acpi PNP0A08:00: _OSC failed (AE_ERROR); disabling ASPM
[    0.276129] acpi PNP0A08:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.276204] PCI host bridge to bus 0000:00
[    0.276218] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.276231] pci_bus 0000:00: root bus resource [io  0x0000-0x006f]
[    0.276242] pci_bus 0000:00: root bus resource [io  0x0078-0x0cf7]
[    0.276254] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.276266] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.276277] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff]
[    0.276289] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000fffff]
[    0.276301] pci_bus 0000:00: root bus resource [mem 0x90c00000-0x90ffffff]
[    0.276313] pci_bus 0000:00: root bus resource [mem 0x7af00001-0x7ef00000]
[    0.276325] pci_bus 0000:00: root bus resource [mem 0x80000000-0x908ffffe]
[    0.276337] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed40fff]
[    0.276361] pci 0000:00:00.0: [8086:0f00] type 00 class 0x060000
[    0.276562] pci 0000:00:02.0: [8086:0f31] type 00 class 0x030000
[    0.276588] pci 0000:00:02.0: reg 0x10: [mem 0x90000000-0x903fffff]
[    0.276607] pci 0000:00:02.0: reg 0x18: [mem 0x80000000-0x8fffffff pref]
[    0.276625] pci 0000:00:02.0: reg 0x20: [io  0x1000-0x1007]
[    0.276833] pci 0000:00:14.0: [8086:0f35] type 00 class 0x0c0330
[    0.276864] pci 0000:00:14.0: reg 0x10: [mem 0x90800000-0x9080ffff 64bit]
[    0.276943] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.277123] pci 0000:00:1a.0: [8086:0f18] type 00 class 0x108000
[    0.277154] pci 0000:00:1a.0: reg 0x10: [mem 0x90700000-0x907fffff]
[    0.277171] pci 0000:00:1a.0: reg 0x14: [mem 0x90600000-0x906fffff]
[    0.277272] pci 0000:00:1a.0: PME# supported from D0 D3hot
[    0.277437] pci 0000:00:1f.0: [8086:0f1c] type 00 class 0x060100
[    0.277671] pci_bus 0000:00: on NUMA node 0
[    0.278783] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.279101] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.279417] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.279746] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.280062] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.280378] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.280706] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.281031] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.293311] dw_dmac INTL9C60:00: DesignWare DMA Controller, 8 channels
[    0.294019] dw_dmac INTL9C60:01: DesignWare DMA Controller, 8 channels
[    0.294793] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.294809] vgaarb: loaded
[    0.294817] vgaarb: bridge control possible 0000:00:02.0
[    0.295019] SCSI subsystem initialized
[    0.295037] ACPI: bus type USB registered
[    0.295110] usbcore: registered new interface driver usbfs
[    0.295156] usbcore: registered new interface driver hub
[    0.295258] usbcore: registered new device driver usb
[    0.302206] pps_core: LinuxPPS API ver. 1 registered
[    0.302219] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.302246] PTP clock support registered
[    0.302485] Advanced Linux Sound Architecture Driver Initialized.
[    0.302497] PCI: Using ACPI for IRQ routing
[    0.302507] PCI: pci_cache_line_size set to 64 bytes
[    0.302532] Expanded resource reserved due to conflict with PCI Bus 0000:00
[    0.302544] e820: reserve RAM buffer [mem 0x0008f000-0x0008ffff]
[    0.302549] e820: reserve RAM buffer [mem 0x0009e000-0x0009ffff]
[    0.302554] e820: reserve RAM buffer [mem 0x78346000-0x7bffffff]
[    0.302559] e820: reserve RAM buffer [mem 0x794c8000-0x7bffffff]
[    0.302564] e820: reserve RAM buffer [mem 0x7a000000-0x7bffffff]
[    0.303000] cfg80211: Calling CRDA to update world regulatory domain
[    0.303235] Switched to clocksource refined-jiffies
[    0.303367] pnp: PnP ACPI init
[    0.303389] ACPI: bus type PNP registered
[    0.303499] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.303670] pnp 00:01: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.303776] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    0.303895] system 00:03: [io  0x0680-0x069f] has been reserved
[    0.303911] system 00:03: [io  0x0400-0x047f] has been reserved
[    0.303923] system 00:03: [io  0x0500-0x05fe] has been reserved
[    0.303935] system 00:03: [io  0x0600-0x061f] has been reserved
[    0.303947] system 00:03: [io  0x164e-0x164f] has been reserved
[    0.303961] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.304307] pnp 00:04: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.305812] pnp 00:05: Plug and Play ACPI device, IDs INT0002 (active)
[    0.305988] pnp 00:06: Plug and Play ACPI device, IDs INT33fc (active)
[    0.306155] pnp 00:07: Plug and Play ACPI device, IDs INT33fc (active)
[    0.306328] pnp 00:08: Plug and Play ACPI device, IDs INT33fc (active)
[    0.307495] pnp 00:09: unknown resource type 19 in _CRS
[    0.307509] pnp 00:09: can't evaluate _CRS: 1
[    0.307579] pnp 00:09: Plug and Play ACPI device, IDs BCM2e3a (active)
[    0.314223] pnp 00:0a: unknown resource type 17 in _CRS
[    0.314237] pnp 00:0a: can't evaluate _CRS: 1
[    0.314321] pnp 00:0a: Plug and Play ACPI device, IDs INTcfd9 PNP0c40 (active)
[    0.314481] pnp 00:0b: Plug and Play ACPI device, IDs INT33bd (active)
[    0.314809] pnp 00:0c: Plug and Play ACPI device, IDs INT3401 (active)
[    0.315136] pnp 00:0d: unknown resource type 17 in _CRS
[    0.315150] pnp 00:0d: can't evaluate _CRS: 1
[    0.315224] pnp 00:0d: Plug and Play ACPI device, IDs INT3403 (active)
[    0.315362] pnp 00:0e: unknown resource type 17 in _CRS
[    0.315375] pnp 00:0e: can't evaluate _CRS: 1
[    0.315448] pnp 00:0e: Plug and Play ACPI device, IDs INT3403 (active)
[    0.315643] pnp 00:0f: unknown resource type 17 in _CRS
[    0.315656] pnp 00:0f: can't evaluate _CRS: 1
[    0.315730] pnp 00:0f: Plug and Play ACPI device, IDs INT3409 (active)
[    0.316029] pnp: PnP ACPI: found 16 devices
[    0.316040] ACPI: bus type PNP unregistered
[    0.321422] pci_bus 0000:00: resource 4 [io  0x0000-0x006f]
[    0.321433] pci_bus 0000:00: resource 5 [io  0x0078-0x0cf7]
[    0.321440] pci_bus 0000:00: resource 6 [io  0x0d00-0xffff]
[    0.321446] pci_bus 0000:00: resource 7 [mem 0x000a0000-0x000bffff]
[    0.321453] pci_bus 0000:00: resource 8 [mem 0x000c0000-0x000dffff]
[    0.321459] pci_bus 0000:00: resource 9 [mem 0x000e0000-0x000fffff]
[    0.321466] pci_bus 0000:00: resource 10 [mem 0x90c00000-0x90ffffff]
[    0.321472] pci_bus 0000:00: resource 11 [mem 0x7af00001-0x7ef00000]
[    0.321479] pci_bus 0000:00: resource 12 [mem 0x80000000-0x908ffffe]
[    0.321485] pci_bus 0000:00: resource 13 [mem 0xfed40000-0xfed40fff]
[    0.321549] NET: Registered protocol family 2
[    0.321890] TCP established hash table entries: 8192 (order: 3, 32768 bytes)
[    0.321938] TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
[    0.322013] TCP: Hash tables configured (established 8192 bind 8192)
[    0.322056] TCP: reno registered
[    0.322068] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.322090] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.322183] NET: Registered protocol family 1
[    0.322218] pci 0000:00:02.0: Boot video device
[    0.322632] PCI: CLS 0 bytes, default 64
[    0.800023] microcode: CPU0 sig=0x30678, pf=0x2, revision=0x808
[    0.800048] microcode: CPU1 sig=0x30678, pf=0x2, revision=0x808
[    0.800075] microcode: CPU2 sig=0x30678, pf=0x2, revision=0x808
[    0.800104] microcode: CPU3 sig=0x30678, pf=0x2, revision=0x808
[    0.800208] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.800940] Scanning for low memory corruption every 60 seconds
[    0.801569] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    0.801616] audit: initializing netlink subsys (disabled)
[    0.801648] audit: type=2000 audit(1400200853.766:1): initialized
[    0.837558] bounce pool size: 64 pages
[    0.837578] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.843189] msgmni has been set to 1760
[    0.843903] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
[    0.843919] io scheduler noop registered
[    0.843928] io scheduler deadline registered
[    0.844106] io scheduler cfq registered (default)
[    0.844447] intel_idle: MWAIT substates: 0x33000020
[    0.844452] intel_idle: v0.4 model 0x37
[    0.844457] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.852001] ACPI: AC Adapter [ADP1] (on-line)
[    0.852326] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.852347] ACPI: Power Button [PWRF]
[    0.852359] ACPI Warning: Could not enable fixed event - PowerButton (2) (20140214/evxface-628)
[    0.858350] button: probe of LNXPWRBN:00 failed with error -22
[    0.864025] [Firmware Bug]: No valid trip found
[    0.864273] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.884668] 00:04: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    0.885698] 80860F0A:00: ttyS1 at MMIO 0x9091d000 (irq = 39, base_baud = 2764800) is a 16550A
[    0.885954] 80860F0A:01: ttyS2 at MMIO 0x9091f000 (irq = 40, base_baud = 2764800) is a 16550A
[    0.886308] hpet: number irqs doesn't agree with number of timers
[    0.886438] Non-volatile memory driver v1.3
[    0.886514] [drm] Initialized drm 1.1.0 20060810
[    0.888432] [drm] Memory usable by graphics device = 2048M
[    0.893120] ACPI: \_SB_.PCI0.GFX0: Error attaching device data 7
[    0.893372] ACPI: \_SB_.PCI0.GFX0: Error attaching device data 7
[    0.893636] ACPI: \_SB_.PCI0.GFX0: Error attaching device data 7
[    0.893887] ACPI: \_SB_.PCI0.GFX0: Error attaching device data 7
[    0.894138] ACPI: \_SB_.PCI0.GFX0: Error attaching device data 7
[    0.896821] i915 0000:00:02.0: irq 103 for MSI/MSI-X
[    0.896839] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    0.896849] [drm] Driver supports precise vblank timestamp query.
[    0.949327] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    0.950125] ACPI: \_SB_.PCI0.GFX0: Error attaching device data 7
[    0.950523] ACPI: \_SB_.PCI0.GFX0: Error attaching device data 7
[    1.478205] [drm] forcing HDMI-A-1 connector ON
[    1.554441] [drm] GMBUS [i915 gmbus vga] timed out, falling back to bit banging on pin 2
[    1.575805] [drm] Got external EDID base block and 0 extensions from "edid/1200x1920.bin" for connector "HDMI-A-1"
[    1.722033] [drm] GMBUS [i915 gmbus dpc] timed out, falling back to bit banging on pin 4
[    1.818338] fbcon: inteldrmfb (fb0) is primary device
[    1.955080] Switched to clocksource tsc
[    2.331727] Console: switching to colour frame buffer device 150x120
[    2.365253] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    2.365400] i915 0000:00:02.0: registered panic notifier
[    2.369617] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    2.371353] acpi device:1a: registered as cooling_device4
[    2.372792] acpi device:21: registered as cooling_device5
[    2.373108] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input1
[    2.373395] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    2.373911] brd: module loaded
[    2.374464] loop: module loaded
[    2.375205] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    2.375451] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
[    2.375778] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    2.375815] xhci_hcd 0000:00:14.0: irq 104 for MSI/MSI-X
[    2.375961] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.376124] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.376295] usb usb1: Product: xHCI Host Controller
[    2.376412] usb usb1: Manufacturer: Linux 3.15.0-rc5-Inari xhci_hcd
[    2.376568] usb usb1: SerialNumber: 0000:00:14.0
[    2.376973] hub 1-0:1.0: USB hub found
[    2.377087] hub 1-0:1.0: 6 ports detected
[    2.378757] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    2.378979] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
[    2.379241] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
[    2.379405] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.379583] usb usb2: Product: xHCI Host Controller
[    2.379702] usb usb2: Manufacturer: Linux 3.15.0-rc5-Inari xhci_hcd
[    2.379850] usb usb2: SerialNumber: 0000:00:14.0
[    2.380239] hub 2-0:1.0: USB hub found
[    2.380351] hub 2-0:1.0: 1 port detected
[    2.380860] usbcore: registered new interface driver usb-storage
[    2.381142] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    3.425347] i8042: No controller found
[    3.425565] mousedev: PS/2 mouse device common for all mice
[    3.425675] [drm] Enabling RC6 states: RC6 off, RC6p off, RC6pp off
[    3.426041] ACPI Warning: Could not enable fixed event - RealTimeClock (4) (20140214/evxface-628)
[    3.426464] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    3.426649] rtc_cmos 00:00: alarms up to one day, 242 bytes nvram
[    3.426883] i2c /dev entries driver
[    3.428313] Intel P-state driver initializing.
[    3.428446] Intel pstate controlling: cpu 0
[    3.428587] Intel pstate controlling: cpu 1
[    3.428725] Intel pstate controlling: cpu 2
[    3.428886] Intel pstate controlling: cpu 3
[    3.429124] sdhci: Secure Digital Host Controller Interface driver
[    3.429272] sdhci: Copyright(c) Pierre Ossman
[    3.430578] mmc0: no vqmmc regulator found
[    3.430681] mmc0: no vmmc regulator found
[    3.431936] mmc0: SDHCI controller on ACPI [80860F14:00] using ADMA
[    3.433476] mmc1: no vqmmc regulator found
[    3.433579] mmc1: no vmmc regulator found
[    3.434830] mmc1: SDHCI controller on ACPI [INT33BB:00] using ADMA
[    3.435453] sdhci-acpi 80860F14:01: failed to setup card detect gpio
[    3.436623] mmc2: no vqmmc regulator found
[    3.436724] mmc2: no vmmc regulator found
[    3.437966] mmc2: SDHCI controller on ACPI [80860F14:01] using ADMA
[    3.438148] sdhci-pltfm: SDHCI platform and OF driver helper
[    3.438273] EFI Variables Facility v0.08 2004-May-17
[    3.448100] hidraw: raw HID events driver (C) Jiri Kosina
[    3.448546] usbcore: registered new interface driver usbhid
[    3.448660] usbhid: USB HID core driver
[    3.449146] TCP: cubic registered
[    3.449218] Initializing XFRM netlink socket
[    3.449576] NET: Registered protocol family 10
[    3.450087] sit: IPv6 over IPv4 tunneling driver
[    3.450438] NET: Registered protocol family 17
[    3.450890] Using IPI No-Shortcut mode
[    3.451197] registered taskstats version 1
[    3.451596]   Magic number: 14:324:658
[    3.451761] console [netcon0] enabled
[    3.451837] netconsole: network logging started
[    3.452124] PM: Hibernation image not present or could not be loaded.
[    3.452133] ALSA device list:
[    3.452195]   No soundcards found.
[    3.452325] Warning: unable to open an initial console.
[    3.458742] Freeing unused kernel memory: 12092K (c1750000 - c231f000)
[    3.472576] udevd[949]: starting version 173
[    3.545752] mmc0: BKOPS_EN bit is not set
[    3.622230] mmc0: new HS200 MMC card at address 0001
[    3.624057] mmcblk0: mmc0:0001 HCG8e 58.2 GiB 
[    3.624598] mmcblk0boot0: mmc0:0001 HCG8e partition 1 4.00 MiB
[    3.624750] mmcblk0boot1: mmc0:0001 HCG8e partition 2 4.00 MiB
[    3.625057] mmcblk0rpmb: mmc0:0001 HCG8e partition 3 4.00 MiB
[    3.625994]  mmcblk0: p1 p2
[    3.630611]  mmcblk0boot1: unknown partition table
[    3.633735]  mmcblk0boot0:
[    3.640096] usb 2-1: new SuperSpeed USB device number 2 using xhci_hcd
[    3.651068] usb 2-1: New USB device found, idVendor=0451, idProduct=8046
[    3.651186] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.651671] hub 2-1:1.0: USB hub found
[    3.651758] hub 2-1:1.0: 4 ports detected
[    3.779948] usb 1-1: new high-speed USB device number 2 using xhci_hcd
[    3.943266] usb 1-1: New USB device found, idVendor=0451, idProduct=8044
[    3.969159] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=1
[    3.994984] usb 1-1: SerialNumber: 420208698DA1
[    4.021771] hub 1-1:1.0: USB hub found
[    4.047612] hub 1-1:1.0: 4 ports detected
[    4.094961] Clocksource tsc unstable (delta = 139070527 ns)
[    4.120773] Switched to clocksource refined-jiffies
[    4.143425] usb 1-3: new high-speed USB device number 3 using xhci_hcd
[    4.235688] usb 1-3: New USB device found, idVendor=12d1, idProduct=1570
[    4.262187] usb 1-3: New USB device strings: Mfr=5, Product=4, SerialNumber=0
[    4.288823] usb 1-3: Product: HUAWEI Mobile Broadband Module
[    4.315372] usb 1-3: Manufacturer: Huawei Technologies Co., Ltd.
[    4.454809] usb 1-4: new high-speed USB device number 4 using xhci_hcd
[    4.615088] usb 1-4: New USB device found, idVendor=0951, idProduct=1603
[    4.641469] usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    4.667779] usb 1-4: Product: DataTraveler 2.0
[    4.694205] usb 1-4: Manufacturer: Kingston
[    4.720492] usb 1-4: SerialNumber: 89900000000000000000017E
[    4.747830] usb-storage 1-4:1.0: USB Mass Storage device detected
[    4.774449] scsi0 : usb-storage 1-4:1.0
[    4.833239] usb 1-1.1: new low-speed USB device number 5 using xhci_hcd
[    4.904523] usb 1-1.1: New USB device found, idVendor=046d, idProduct=c03e
[    4.930590] usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.956550] usb 1-1.1: Product: USB-PS/2 Optical Mouse
[    4.982418] usb 1-1.1: Manufacturer: Logitech
[    5.008663] usb 1-1.1: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
[    5.039453] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:14.0/usb1/1-1/1-1.1/1-1.1:1.0/0003:046D:C03E.0001/input/input2
[    5.067114] hid-generic 0003:046D:C03E.0001: input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:14.0-1.1/input0
[    5.132430] usb 1-1.2: new high-speed USB device number 6 using xhci_hcd
[    5.203734] usb 1-1.2: New USB device found, idVendor=0424, idProduct=7500
[    5.230739] usb 1-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    5.257917] usb 1-1.2: Product: LAN7500
[    5.284761] usb 1-1.2: Manufacturer: SMSC
[    5.311315] usb 1-1.2: SerialNumber: 00800f11700e
[    5.381679] usb 1-1.3: new low-speed USB device number 7 using xhci_hcd
[    5.462341] usb 1-1.3: New USB device found, idVendor=046d, idProduct=c312
[    5.489081] usb 1-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.515839] usb 1-1.3: Product: USB Multimedia Keyboard
[    5.542443] usb 1-1.3: Manufacturer: LITEON Technology
[    5.569572] usb 1-1.3: ep 0x81 - rounding interval to 128 microframes, ep desc says 192 microframes
[    5.600996] input: LITEON Technology USB Multimedia Keyboard as /devices/pci0000:00/0000:00:14.0/usb1/1-1/1-1.3/1-1.3:1.0/0003:046D:C312.0002/input/input3
[    5.656590] hid-generic 0003:046D:C312.0002: input,hidraw1: USB HID v1.10 Keyboard [LITEON Technology USB Multimedia Keyboard] on usb-0000:00:14.0-1.3/input0
[    5.768892] scsi 0:0:0:0: Direct-Access     Kingston DataTraveler 2.0 1.00 PQ: 0 ANSI: 2
[    5.799079] sd 0:0:0:0: [sda] 7856128 512-byte logical blocks: (4.02 GB/3.74 GiB)
[    5.799096] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    5.857532] sd 0:0:0:0: [sda] Write Protect is off
[    5.886444] sd 0:0:0:0: [sda] Mode Sense: 23 00 00 00
[    5.886816] sd 0:0:0:0: [sda] No Caching mode page found
[    5.915622] sd 0:0:0:0: [sda] Assuming drive cache: write through
[    5.947408]  sda: sda1 sda2
[    5.986433] sd 0:0:0:0: [sda] Attached SCSI removable disk
[    6.043333] EXT4-fs (sda2): couldn't mount as ext3 due to feature incompatibilities
[    6.076814] EXT4-fs (sda2): couldn't mount as ext2 due to feature incompatibilities
[    6.119661] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[    6.280069] random: nonblocking pool is initialized
[    7.357011] udevd[1689]: starting version 173
[    7.477008] sst-acpi 80860F28:00: Direct firmware load failed with error -2
[    7.484948] sst-acpi 80860F28:00: Falling back to user helper
[    7.577743] sst-acpi 80860F28:00: Cannot load firmware intel/fw_sst_0f28.bin-i2s_master
[    7.586076] byt-rt5640 byt-rt5640: ASoC: CPU DAI Front-cpu-dai not registered
[    7.592798] smsc75xx v1.0.0
[    7.601973] platform byt-rt5640: Driver byt-rt5640 requests probe deferral
[    7.629938] smsc75xx 1-1.2:1.0 eth0: register 'smsc75xx' at usb-0000:00:14.0-1.2, smsc75xx USB 2.0 Gigabit Ethernet, 70:2f:97:00:22:4f
[    7.660544] usbcore: registered new interface driver smsc75xx
[    7.660554] byt-rt5640 byt-rt5640: ASoC: CPU DAI Front-cpu-dai not registered
[    7.660598] platform byt-rt5640: Driver byt-rt5640 requests probe deferral
[   15.786357] mmc0: Got data interrupt 0x00000002 even though no data operation was in progress.
[   15.819492] mmcblk0rpmb: error -110 transferring data, sector 8064, nr 8, cmd response 0x900, card status 0xb00
[   15.850882] mmcblk0rpmb: retrying using single block read
[   15.884298] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   15.917928] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   15.951471] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   15.984802] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   16.017890] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   16.050737] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   16.081372] end_request: I/O error, dev mmcblk0rpmb, sector 8064
[   16.112006] Buffer I/O error on device mmcblk0rpmb, logical block 1008
[   24.373945] mmc0: Got data interrupt 0x00000002 even though no data operation was in progress.
[   24.407032] mmcblk0rpmb: error -110 transferring data, sector 8064, nr 8, cmd response 0x900, card status 0xb00
[   24.438318] mmcblk0rpmb: retrying using single block read
[   24.471644] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   24.505126] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   24.538515] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   24.571758] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   24.604838] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   24.637751] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   24.668398] end_request: I/O error, dev mmcblk0rpmb, sector 8064
[   24.699120] Buffer I/O error on device mmcblk0rpmb, logical block 1008
[   32.940422] mmc0: Got data interrupt 0x00000002 even though no data operation was in progress.
[   32.973781] mmcblk0rpmb: error -110 transferring data, sector 0, nr 16, cmd response 0x900, card status 0xb00
[   33.005431] mmcblk0rpmb: retrying using single block read
[   33.039167] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   33.073116] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   33.106965] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   33.140652] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   33.174081] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   33.207244] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   33.238143] end_request: I/O error, dev mmcblk0rpmb, sector 0
[   33.269079] Buffer I/O error on device mmcblk0rpmb, logical block 0
[   33.300138] end_request: I/O error, dev mmcblk0rpmb, sector 8
[   33.331221] Buffer I/O error on device mmcblk0rpmb, logical block 1
[   41.566672] mmc0: Got data interrupt 0x00000002 even though no data operation was in progress.
[   41.600468] mmcblk0rpmb: error -110 transferring data, sector 0, nr 8, cmd response 0x900, card status 0xb00
[   41.632451] mmcblk0rpmb: retrying using single block read
[   41.666526] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   41.700864] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   41.734945] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   41.768811] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   41.802498] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   41.835947] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   41.867201] end_request: I/O error, dev mmcblk0rpmb, sector 0
[   41.898423] Buffer I/O error on device mmcblk0rpmb, logical block 0
[   45.972615] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   47.603164] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   47.634111] smsc75xx 1-1.2:1.0 eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
[   47.668901] smsc75xx 1-1.2:1.0 eth0: link up, 100Mbps, full-duplex, lpa 0x45E1

=2D-nextPart9796051.zhVmkHVF2l--
This is a multi-part message in MIME format.

--nextPart9796051.zhVmkHVF2l
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Am Donnerstag, 15. Mai 2014, 22:49:37 schrieb Lan Tianyu:
> On 05/15/2014 03:50 PM, Rolf Eike Beer wrote:
> > Lan Tianyu wrote:
> >> On 05/13/2014 09:09 PM, Rolf Eike Beer wrote:
> >>> Am Montag, 28. April 2014, 22:27:39 schrieb Lan Tianyu:
> >>>> ACPI 5.0 spec(5.5.2.4.5) defines GenericSerialBus(i2c, spi, uart=
)
> >>>> operation
> >>>> region. It allows ACPI aml code able to access such kind of devi=
ces to
> >>>> implement some ACPI standard method.
> >>>>=20
> >>>> On the Asus T100TA, Bios use GenericSerialBus operation region t=
o
> >>>> access
> >>>> i2c device to get battery info. So battery function depends on t=
he I2C
> >>>> operation region support. Here is the bug link.
> >>>> https://bugzilla.kernel.org/show_bug.cgi?id=3D69011
> >>>=20
> >>> Hi all,
> >>>=20
> >>> I have tested this series and got some errors, but no additional
> >=20
> > functionality:
> >> Hi Rolf:
> >> =09Thanks for test. Could you attach the output of dmesg and acpid=
ump?
> >>=20
> >> Which machine you are testing on?
> >=20
> > Hi,
> >=20
> > this is an Aava Inari 8 tablet (pre-release hardware). Please find =
the
> > DSDT
> > and the dmesg.log attached.
> >=20
> > In case of any further questions don't hesitate to ask, I'll try to=
 be
> > more
> > responsible.
>=20
> Hi Eike:
> =09Could you apply the patch in the attachment and attach the output =
of
> =09dmesg?

Sure, here it is.

Regards,

Eike
--=20
Rolf Eike Beer, emlix GmbH, http://www.emlix.com
Fon +49 551 30664-0, Fax +49 551 30664-11
Bertha-von-Suttner-Str. 9, 37085 G=F6ttingen, Germany
Sitz der Gesellschaft: G=F6ttingen, Amtsgericht G=F6ttingen HR B 3160
Gesch=E4ftsf=FChrung: Dr. Uwe Kracke, Ust-IdNr.: DE 205 198 055

emlix - smart embedded open source

--nextPart9796051.zhVmkHVF2l
Content-Disposition: attachment; filename="dmesg.debug"
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"; name="dmesg.debug"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.15.0-rc5-Inari (root@devpool02) (gcc version 4.8.2 (Emlix Linux Inari) ) #1 SMP Fri May 16 08:25:11 UTC 2014
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000008efff] usable
[    0.000000] BIOS-e820: [mem 0x000000000008f000-0x000000000008ffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000000090000-0x000000000009dfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000200fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020100000-0x0000000078345fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000078346000-0x0000000078c45fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000078c46000-0x0000000078d45fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000078d46000-0x0000000078d85fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000078d86000-0x00000000794c7fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000794c8000-0x0000000079dc7fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000079dc8000-0x0000000079ffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000e00f8000-0x00000000e00f8fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed01000-0x00000000fed01fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffd00000-0x00000000ffffffff] reserved
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] efi: EFI v2.31 by INSYDE Corp.
[    0.000000] efi:  ACPI 2.0=0x78d85014  SMBIOS=0x78c45000 
[    0.000000] efi: mem00: type=7, attr=0xf, range=[0x0000000000000000-0x0000000000001000) (0MB)
[    0.000000] efi: mem01: type=2, attr=0xf, range=[0x0000000000001000-0x0000000000007000) (0MB)
[    0.000000] efi: mem02: type=7, attr=0xf, range=[0x0000000000007000-0x000000000008f000) (0MB)
[    0.000000] efi: mem03: type=10, attr=0xf, range=[0x000000000008f000-0x0000000000090000) (0MB)
[    0.000000] efi: mem04: type=7, attr=0xf, range=[0x0000000000090000-0x000000000009e000) (0MB)
[    0.000000] efi: mem05: type=0, attr=0xf, range=[0x000000000009e000-0x00000000000a0000) (0MB)
[    0.000000] efi: mem06: type=7, attr=0xf, range=[0x0000000000100000-0x0000000001000000) (15MB)
[    0.000000] efi: mem07: type=2, attr=0xf, range=[0x0000000001000000-0x000000000257f000) (21MB)
[    0.000000] efi: mem08: type=7, attr=0xf, range=[0x000000000257f000-0x0000000020000000) (474MB)
[    0.000000] efi: mem09: type=0, attr=0xf, range=[0x0000000020000000-0x0000000020100000) (1MB)
[    0.000000] efi: mem10: type=7, attr=0xf, range=[0x0000000020100000-0x0000000071dc0000) (1308MB)
[    0.000000] efi: mem11: type=4, attr=0xf, range=[0x0000000071dc0000-0x0000000071de0000) (0MB)
[    0.000000] efi: mem12: type=7, attr=0xf, range=[0x0000000071de0000-0x0000000072bca000) (13MB)
[    0.000000] efi: mem13: type=2, attr=0xf, range=[0x0000000072bca000-0x0000000072bcc000) (0MB)
[    0.000000] efi: mem14: type=1, attr=0xf, range=[0x0000000072bcc000-0x0000000073b46000) (15MB)
[    0.000000] efi: mem15: type=7, attr=0xf, range=[0x0000000073b46000-0x0000000076a92000) (47MB)
[    0.000000] efi: mem16: type=4, attr=0xf, range=[0x0000000076a92000-0x00000000774ec000) (10MB)
[    0.000000] efi: mem17: type=7, attr=0xf, range=[0x00000000774ec000-0x00000000774f9000) (0MB)
[    0.000000] efi: mem18: type=4, attr=0xf, range=[0x00000000774f9000-0x0000000077d46000) (8MB)
[    0.000000] efi: mem19: type=7, attr=0xf, range=[0x0000000077d46000-0x0000000078161000) (4MB)
[    0.000000] efi: mem20: type=3, attr=0xf, range=[0x0000000078161000-0x0000000078346000) (1MB)
[    0.000000] efi: mem21: type=5, attr=0x800000000000000f, range=[0x0000000078346000-0x0000000078546000) (2MB)
[    0.000000] efi: mem22: type=6, attr=0x800000000000000f, range=[0x0000000078546000-0x0000000078846000) (3MB)
[    0.000000] efi: mem23: type=0, attr=0xf, range=[0x0000000078846000-0x0000000078c46000) (4MB)
[    0.000000] efi: mem24: type=10, attr=0xf, range=[0x0000000078c46000-0x0000000078d46000) (1MB)
[    0.000000] efi: mem25: type=9, attr=0xf, range=[0x0000000078d46000-0x0000000078d86000) (0MB)
[    0.000000] efi: mem26: type=4, attr=0xf, range=[0x0000000078d86000-0x00000000794c8000) (7MB)
[    0.000000] efi: mem27: type=10, attr=0xf, range=[0x00000000794c8000-0x0000000079dc8000) (9MB)
[    0.000000] efi: mem28: type=4, attr=0xf, range=[0x0000000079dc8000-0x000000007a000000) (2MB)
[    0.000000] efi: mem29: type=11, attr=0x8000000000000001, range=[0x00000000e00f8000-0x00000000e00f9000) (0MB)
[    0.000000] efi: mem30: type=11, attr=0x8000000000000000, range=[0x00000000fed01000-0x00000000fed02000) (0MB)
[    0.000000] efi: mem31: type=11, attr=0x8000000000000000, range=[0x00000000ffd00000-0x0000000100000000) (3MB)
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Aava Mobile Oy Inari 8 2GB/Type2 - Board Product Name, BIOS BYT.5.03.47.0033-022 01/16/2014
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x7a000 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0FFD00000 mask FFFC00000 write-protect
[    0.000000]   1 base 000000000 mask FC0000000 write-back
[    0.000000]   2 base 040000000 mask FE0000000 write-back
[    0.000000]   3 base 060000000 mask FF0000000 write-back
[    0.000000]   4 base 070000000 mask FF8000000 write-back
[    0.000000]   5 base 078000000 mask FFC000000 write-back
[    0.000000]   6 base 07B000000 mask FFF000000 uncachable
[    0.000000]   7 base 07AE00000 mask FFFE00000 uncachable
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x027fffff]
[    0.000000] Base memory trampoline at [c009a000] 9a000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x37000000-0x373fffff]
[    0.000000]  [mem 0x37000000-0x373fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x30000000-0x36ffffff]
[    0.000000]  [mem 0x30000000-0x36ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x1fffffff]
[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x1fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x20100000-0x2fffffff]
[    0.000000]  [mem 0x20100000-0x203fffff] page 4k
[    0.000000]  [mem 0x20400000-0x2fffffff] page 2M
[    0.000000] BRK [0x02464000, 0x02464fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x37400000-0x377fdfff]
[    0.000000]  [mem 0x37400000-0x377fdfff] page 4k
[    0.000000] BRK [0x02465000, 0x02465fff] PGTABLE
[    0.000000] ACPI: RSDP 0x78D85014 000024 (v02 INSYDE)
[    0.000000] ACPI: XSDT 0x78D61188 0000D4 (v01 INSYDE INSYDE   00000003      01000013)
[    0.000000] ACPI: FACP 0x78D7F000 00010C (v05 INSYDE INSYDE   00000003 ACPI 00040000)
[    0.000000] ACPI: DSDT 0x78D6E000 00BAEC (v02 INSYDE INSYDE   00000003 ACPI 00040000)
[    0.000000] ACPI: UEFI 0x78D84000 000236 (v01 INSYDE INSYDE   00000001 ACPI 00040000)
[    0.000000] ACPI: TCPA 0x78D83000 000032 (v02 INSYDE INSYDE   00000000 ACPI 00040000)
[    0.000000] ACPI: UEFI 0x78D81000 000042 (v01 INSYDE INSYDE   00000000 ACPI 00040000)
[    0.000000] ACPI: DBG2 0x78D80000 000072 (v00 INSYDE INSYDE   00000003 ACPI 00040000)
[    0.000000] ACPI: HPET 0x78D7E000 000038 (v01 INSYDE INSYDE   00000003 ACPI 00040000)
[    0.000000] ACPI: LPIT 0x78D7D000 000104 (v01 INSYDE INSYDE   00000003 ACPI 00040000)
[    0.000000] ACPI: APIC 0x78D7C000 00006C (v03 INSYDE INSYDE   00000003 ACPI 00040000)
[    0.000000] ACPI: MCFG 0x78D7B000 00003C (v01 INSYDE INSYDE   00000003 ACPI 00040000)
[    0.000000] ACPI: SLIC 0x78D7A000 000176 (v01 INSYDE INSYDE   00000003 ACPI 00040000)
[    0.000000] ACPI: SSDT 0x78D6D000 0005FB (v01 INSYDE CpuDptf  00000003 ACPI 00040000)
[    0.000000] ACPI: SSDT 0x78D6B000 0018C2 (v01 INSYDE DptfTab  00000003 ACPI 00040000)
[    0.000000] ACPI: SSDT 0x78D6A000 000058 (v01 INSYDE LowPwrM  00000003 ACPI 00040000)
[    0.000000] ACPI: SSDT 0x78D69000 0000FF (v01 INSYDE SoCDptf  00000003 ACPI 00040000)
[    0.000000] ACPI: SSDT 0x78D68000 00043A (v01 INSYDE Tpm2Tabl 00001000 ACPI 00040000)
[    0.000000] ACPI: TPM2 0x78D67000 000034 (v03 INSYDE INSYDE   00000000 ACPI 00040000)
[    0.000000] ACPI: SSDT 0x78D66000 000763 (v01 INSYDE CpuPm    00003000 ACPI 00040000)
[    0.000000] ACPI: SSDT 0x78D65000 000290 (v01 INSYDE Cpu0Tst  00003000 ACPI 00040000)
[    0.000000] ACPI: SSDT 0x78D64000 00017A (v01 INSYDE ApTst    00003000 ACPI 00040000)
[    0.000000] ACPI: FPDT 0x78D63000 000044 (v01 INSYDE INSYDE   00000001 ACPI 00040000)
[    0.000000] ACPI: CSRT 0x78D62000 00014C (v00 INSYDE INSYDE   00000005 ACPI 00040000)
[    0.000000] ACPI: BGRT 0x78D60000 000038 (v01 INSYDE INSYDE   00000001 ACPI 00040000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 1064MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000] BRK [0x02466000, 0x02466fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x377fdfff]
[    0.000000]   HighMem  [mem 0x377fe000-0x79ffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0008efff]
[    0.000000]   node   0: [mem 0x00090000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
[    0.000000]   node   0: [mem 0x20100000-0x78345fff]
[    0.000000]   node   0: [mem 0x78d86000-0x794c7fff]
[    0.000000]   node   0: [mem 0x79dc8000-0x79ffffff]
[    0.000000] On node 0 totalpages: 494428
[    0.000000] free_area_init_node: node 0, pgdat c17401c0, node_mem_map f68be020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 222974 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2129 pages used for memmap
[    0.000000]   HighMem zone: 267458 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] x86/hpet: Will disable the HPET for this platform because it's not reliable
[    0.000000] Reserving Intel graphics stolen memory at 0x7af00000-0x7eefffff
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-86
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 103
[    0.000000] PM: Registered nosave memory: [mem 0x0008f000-0x0008ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x20000000-0x200fffff]
[    0.000000] e820: [mem 0x7ef00000-0xe00f7fff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 12 pages/cpu @f6882000 s27264 r0 d21888 u49152
[    0.000000] pcpu-alloc: s27264 r0 d21888 u49152 alloc=12*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 492652
[    0.000000] Kernel command line: root=/dev/sda2 video=HDMI-A-1:1200x1920e drm_kms_helper.edid_firmware=HDMI-A-1:edid/1200x1920.bin 
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (000377fe:0007a000)
[    0.000000] Initializing Movable for node 0 (00000000:00000000)
[    0.000000] Memory: 1909220K/1977712K available (5505K kernel code, 331K rwdata, 1640K rodata, 12092K init, 1236K bss, 68492K reserved, 1038956K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff66000 - 0xfffff000   ( 612 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc1750000 - 0xc231f000   (12092 kB)
[    0.000000]       .data : 0xc1560b12 - 0xc174efc0   (1977 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1560b12   (5506 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:2304 nr_irqs:1024 16
[    0.000000] CPU 0 irqstacks, hard=f600c000 soft=f600e000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Maximum core-clock to bus-clock ratio: 0xa
[    0.000000] Resolved frequency ID: 2, frequency: 133200 KHz
[    0.000000] TSC runs at 1332000 KHz
[    0.000000] lapic_timer_frequency = 133200
[    0.000000] tsc: Detected 1332.000 MHz processor
[    0.000037] Calibrating delay loop (skipped), value calculated using timer frequency.. 2664.00 BogoMIPS (lpj=1332000)
[    0.000054] pid_max: default: 32768 minimum: 301
[    0.000071] ACPI: Core revision 20140214
[    0.044032] ACPI: All ACPI Tables successfully acquired
[    0.046878] Mount-cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.046898] Mountpoint-cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.047248] Initializing cgroup subsys freezer
[    0.047290] CPU: Physical Processor ID: 0
[    0.047300] CPU: Processor Core ID: 0
[    0.047311] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.047311] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.059441] mce: CPU supports 6 MCE banks
[    0.059460] CPU0: Thermal monitoring enabled (TM1)
[    0.059480] Last level iTLB entries: 4KB 48, 2MB 0, 4MB 0
[    0.059480] Last level dTLB entries: 4KB 128, 2MB 16, 4MB 16, 1GB 0
[    0.059480] tlb_flushall_shift: 6
[    0.059673] Freeing SMP alternatives memory: 20K (c231f000 - c2324000)
[    0.059708] ------------[ cut here ]------------
[    0.059727] WARNING: CPU: 0 PID: 0 at /tmp/e2/build/linux-git/mm/early_ioremap.c:136 __early_ioremap+0xee/0x1a6()
[    0.059739] Modules linked in:
[    0.059752] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.15.0-rc5-Inari #1
[    0.059762] Hardware name: Aava Mobile Oy Inari 8 2GB/Type2 - Board Product Name, BIOS BYT.5.03.47.0033-022 01/16/2014
[    0.059775]  00000000 00000000 c16fdf0c c155483e 00000000 c16fdf3c c103d194 c164be20
[    0.059797]  00000000 00000000 c16539b8 00000088 c176cc03 c176cc03 00000042 77526000
[    0.059819]  00000000 c16fdf4c c103d22d 00000009 00000000 c16fdfa0 c176cc03 c1740ec0
[    0.059840] Call Trace:
[    0.059854]  [<c155483e>] dump_stack+0x41/0x52
[    0.059867]  [<c103d194>] warn_slowpath_common+0x74/0x90
[    0.059880]  [<c176cc03>] ? __early_ioremap+0xee/0x1a6
[    0.059892]  [<c176cc03>] ? __early_ioremap+0xee/0x1a6
[    0.059903]  [<c103d22d>] warn_slowpath_null+0x1d/0x20
[    0.059915]  [<c176cc03>] __early_ioremap+0xee/0x1a6
[    0.059928]  [<c10368df>] ? __native_set_fixmap+0x1f/0x30
[    0.059941]  [<c176ce70>] early_memremap+0xd/0xf
[    0.059953]  [<c1763743>] efi_bgrt_init+0xe6/0x129
[    0.059965]  [<c1763067>] efi_late_init+0x8/0xa
[    0.059978]  [<c1750a3b>] start_kernel+0x34f/0x35f
[    0.059990]  [<c1750523>] ? repair_env_string+0x51/0x51
[    0.060003]  [<c1750369>] i386_start_kernel+0x137/0x13a
[    0.060040] ---[ end trace 27ffb688a5381019 ]---
[    0.062989] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.064018] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.074045] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[    0.074054] ...trying to set up timer (IRQ0) through the 8259A ...
[    0.074063] ..... (found apic 0 pin 2) ...
[    0.084079] ....... works.
[    0.084087] smpboot: CPU0: Intel(R) Atom(TM) CPU  Z3745  @ 1.33GHz (fam: 06, model: 37, stepping: 08)
[    0.084126] TSC deadline timer enabled
[    0.084141] Performance Events: PEBS fmt2+, 8-deep LBR, Silvermont events, full-width counters, Intel PMU driver.
[    0.084168] ... version:                3
[    0.084176] ... bit width:              40
[    0.084183] ... generic registers:      2
[    0.084191] ... value mask:             000000ffffffffff
[    0.084199] ... max period:             000000ffffffffff
[    0.084207] ... fixed-purpose events:   3
[    0.084214] ... event mask:             0000000700000003
[    0.085792] CPU 1 irqstacks, hard=f60a6000 soft=f60b0000
[    0.085798] x86: Booting SMP configuration:
[    0.085809] .... node  #0, CPUs:      #1
[    0.095924] Initializing CPU#1
[    0.111134] CPU 2 irqstacks, hard=f60ba000 soft=f60bc000
[    0.111153]  #2
[    0.121206] Initializing CPU#2
[    0.136519] CPU 3 irqstacks, hard=f60c6000 soft=f60c8000
[    0.136533]  #3
[    0.146587] Initializing CPU#3
[    0.161772] x86: Booted up 1 node, 4 CPUs
[    0.161791] smpboot: Total of 4 processors activated (10656.00 BogoMIPS)
[    0.162741] devtmpfs: initialized
[    0.163227] PM: Registering ACPI NVS region [mem 0x0008f000-0x0008ffff] (4096 bytes)
[    0.163242] PM: Registering ACPI NVS region [mem 0x78c46000-0x78d45fff] (1048576 bytes)
[    0.163294] PM: Registering ACPI NVS region [mem 0x794c8000-0x79dc7fff] (9437184 bytes)
[    0.163841] pinctrl core: initialized pinctrl subsystem
[    0.163902] RTC time:  0:40:53, date: 05/16/14
[    0.163989] NET: Registered protocol family 16
[    0.164313] cpuidle: using governor ladder
[    0.164324] cpuidle: using governor menu
[    0.164398] ACPI: bus type PCI registered
[    0.164551] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
[    0.164568] PCI: not using MMCONFIG
[    0.164920] PCI: Using configuration type 1 for base access
[    0.170069] ACPI: Added _OSI(Module Device)
[    0.170084] ACPI: Added _OSI(Processor Device)
[    0.170094] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.170103] ACPI: Added _OSI(Processor Aggregator Device)
[    0.204674] ACPI: SSDT 0x78BCAA90 000353 (v01 PmRef  Cpu0Ist  00003000 INTL 20130117)
[    0.206249] ACPI: Dynamic OEM Table Load:
[    0.206264] ACPI: SSDT 0x00000000 000353 (v01 PmRef  Cpu0Ist  00003000 INTL 20130117)
[    0.206799] ACPI: SSDT 0x78BC9910 000433 (v01 PmRef  Cpu0Cst  00003001 INTL 20130117)
[    0.208647] ACPI: Dynamic OEM Table Load:
[    0.208661] ACPI: SSDT 0x00000000 000433 (v01 PmRef  Cpu0Cst  00003001 INTL 20130117)
[    0.215236] ACPI: SSDT 0x78BCBD90 00015F (v01 PmRef  ApIst    00003000 INTL 20130117)
[    0.216837] ACPI: Dynamic OEM Table Load:
[    0.216851] ACPI: SSDT 0x00000000 00015F (v01 PmRef  ApIst    00003000 INTL 20130117)
[    0.219400] ACPI: SSDT 0x78BCBF10 00008D (v01 PmRef  ApCst    00003000 INTL 20130117)
[    0.220819] ACPI: Dynamic OEM Table Load:
[    0.220832] ACPI: SSDT 0x00000000 00008D (v01 PmRef  ApCst    00003000 INTL 20130117)
[    0.226624] ACPI: Interpreter enabled
[    0.226659] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140214/hwxface-580)
[    0.226683] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140214/hwxface-580)
[    0.226705] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S3_] (20140214/hwxface-580)
[    0.226726] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S4_] (20140214/hwxface-580)
[    0.226746] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S5_] (20140214/hwxface-580)
[    0.226764] ACPI: (supports S0)
[    0.226773] ACPI: Using IOAPIC for interrupt routing
[    0.226862] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
[    0.234470] [Firmware Info]: PCI: MMCONFIG at [mem 0xe0000000-0xe3ffffff] not reserved in ACPI motherboard resources
[    0.234487] PCI: not using MMCONFIG
[    0.234540] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.237741] ACPI: Power Resource [USBC] (on)
[    0.241990] ACPI: Power Resource [WWPR] (off)
[    0.252641] ACPI: Power Resource [PLPE] (on)
[    0.264429] ACPI: Power Resource [CLK0] (on)
[    0.264566] ACPI: Power Resource [CLK1] (on)
[    0.264924] ACPI: Power Resource [P28X] (off)
[    0.265067] ACPI: Power Resource [P18X] (off)
[    0.267582] ACPI: Power Resource [TCPR] (off)
[    0.274577] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.274601] acpi PNP0A08:00: _OSC: OS supports [ASPM ClockPM Segments MSI]
[    0.274806] \_SB_.PCI0:_OSC invalid UUID
[    0.274811] _OSC request data:1 1e 0 
[    0.274824] acpi PNP0A08:00: _OSC failed (AE_ERROR); disabling ASPM
[    0.276129] acpi PNP0A08:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.276204] PCI host bridge to bus 0000:00
[    0.276218] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.276231] pci_bus 0000:00: root bus resource [io  0x0000-0x006f]
[    0.276242] pci_bus 0000:00: root bus resource [io  0x0078-0x0cf7]
[    0.276254] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.276266] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.276277] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff]
[    0.276289] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000fffff]
[    0.276301] pci_bus 0000:00: root bus resource [mem 0x90c00000-0x90ffffff]
[    0.276313] pci_bus 0000:00: root bus resource [mem 0x7af00001-0x7ef00000]
[    0.276325] pci_bus 0000:00: root bus resource [mem 0x80000000-0x908ffffe]
[    0.276337] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed40fff]
[    0.276361] pci 0000:00:00.0: [8086:0f00] type 00 class 0x060000
[    0.276562] pci 0000:00:02.0: [8086:0f31] type 00 class 0x030000
[    0.276588] pci 0000:00:02.0: reg 0x10: [mem 0x90000000-0x903fffff]
[    0.276607] pci 0000:00:02.0: reg 0x18: [mem 0x80000000-0x8fffffff pref]
[    0.276625] pci 0000:00:02.0: reg 0x20: [io  0x1000-0x1007]
[    0.276833] pci 0000:00:14.0: [8086:0f35] type 00 class 0x0c0330
[    0.276864] pci 0000:00:14.0: reg 0x10: [mem 0x90800000-0x9080ffff 64bit]
[    0.276943] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.277123] pci 0000:00:1a.0: [8086:0f18] type 00 class 0x108000
[    0.277154] pci 0000:00:1a.0: reg 0x10: [mem 0x90700000-0x907fffff]
[    0.277171] pci 0000:00:1a.0: reg 0x14: [mem 0x90600000-0x906fffff]
[    0.277272] pci 0000:00:1a.0: PME# supported from D0 D3hot
[    0.277437] pci 0000:00:1f.0: [8086:0f1c] type 00 class 0x060100
[    0.277671] pci_bus 0000:00: on NUMA node 0
[    0.278783] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.279101] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.279417] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.279746] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.280062] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.280378] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.280706] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.281031] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.293311] dw_dmac INTL9C60:00: DesignWare DMA Controller, 8 channels
[    0.294019] dw_dmac INTL9C60:01: DesignWare DMA Controller, 8 channels
[    0.294793] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.294809] vgaarb: loaded
[    0.294817] vgaarb: bridge control possible 0000:00:02.0
[    0.295019] SCSI subsystem initialized
[    0.295037] ACPI: bus type USB registered
[    0.295110] usbcore: registered new interface driver usbfs
[    0.295156] usbcore: registered new interface driver hub
[    0.295258] usbcore: registered new device driver usb
[    0.302206] pps_core: LinuxPPS API ver. 1 registered
[    0.302219] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.302246] PTP clock support registered
[    0.302485] Advanced Linux Sound Architecture Driver Initialized.
[    0.302497] PCI: Using ACPI for IRQ routing
[    0.302507] PCI: pci_cache_line_size set to 64 bytes
[    0.302532] Expanded resource reserved due to conflict with PCI Bus 0000:00
[    0.302544] e820: reserve RAM buffer [mem 0x0008f000-0x0008ffff]
[    0.302549] e820: reserve RAM buffer [mem 0x0009e000-0x0009ffff]
[    0.302554] e820: reserve RAM buffer [mem 0x78346000-0x7bffffff]
[    0.302559] e820: reserve RAM buffer [mem 0x794c8000-0x7bffffff]
[    0.302564] e820: reserve RAM buffer [mem 0x7a000000-0x7bffffff]
[    0.303000] cfg80211: Calling CRDA to update world regulatory domain
[    0.303235] Switched to clocksource refined-jiffies
[    0.303367] pnp: PnP ACPI init
[    0.303389] ACPI: bus type PNP registered
[    0.303499] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.303670] pnp 00:01: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.303776] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    0.303895] system 00:03: [io  0x0680-0x069f] has been reserved
[    0.303911] system 00:03: [io  0x0400-0x047f] has been reserved
[    0.303923] system 00:03: [io  0x0500-0x05fe] has been reserved
[    0.303935] system 00:03: [io  0x0600-0x061f] has been reserved
[    0.303947] system 00:03: [io  0x164e-0x164f] has been reserved
[    0.303961] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.304307] pnp 00:04: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.305812] pnp 00:05: Plug and Play ACPI device, IDs INT0002 (active)
[    0.305988] pnp 00:06: Plug and Play ACPI device, IDs INT33fc (active)
[    0.306155] pnp 00:07: Plug and Play ACPI device, IDs INT33fc (active)
[    0.306328] pnp 00:08: Plug and Play ACPI device, IDs INT33fc (active)
[    0.307495] pnp 00:09: unknown resource type 19 in _CRS
[    0.307509] pnp 00:09: can't evaluate _CRS: 1
[    0.307579] pnp 00:09: Plug and Play ACPI device, IDs BCM2e3a (active)
[    0.314223] pnp 00:0a: unknown resource type 17 in _CRS
[    0.314237] pnp 00:0a: can't evaluate _CRS: 1
[    0.314321] pnp 00:0a: Plug and Play ACPI device, IDs INTcfd9 PNP0c40 (active)
[    0.314481] pnp 00:0b: Plug and Play ACPI device, IDs INT33bd (active)
[    0.314809] pnp 00:0c: Plug and Play ACPI device, IDs INT3401 (active)
[    0.315136] pnp 00:0d: unknown resource type 17 in _CRS
[    0.315150] pnp 00:0d: can't evaluate _CRS: 1
[    0.315224] pnp 00:0d: Plug and Play ACPI device, IDs INT3403 (active)
[    0.315362] pnp 00:0e: unknown resource type 17 in _CRS
[    0.315375] pnp 00:0e: can't evaluate _CRS: 1
[    0.315448] pnp 00:0e: Plug and Play ACPI device, IDs INT3403 (active)
[    0.315643] pnp 00:0f: unknown resource type 17 in _CRS
[    0.315656] pnp 00:0f: can't evaluate _CRS: 1
[    0.315730] pnp 00:0f: Plug and Play ACPI device, IDs INT3409 (active)
[    0.316029] pnp: PnP ACPI: found 16 devices
[    0.316040] ACPI: bus type PNP unregistered
[    0.321422] pci_bus 0000:00: resource 4 [io  0x0000-0x006f]
[    0.321433] pci_bus 0000:00: resource 5 [io  0x0078-0x0cf7]
[    0.321440] pci_bus 0000:00: resource 6 [io  0x0d00-0xffff]
[    0.321446] pci_bus 0000:00: resource 7 [mem 0x000a0000-0x000bffff]
[    0.321453] pci_bus 0000:00: resource 8 [mem 0x000c0000-0x000dffff]
[    0.321459] pci_bus 0000:00: resource 9 [mem 0x000e0000-0x000fffff]
[    0.321466] pci_bus 0000:00: resource 10 [mem 0x90c00000-0x90ffffff]
[    0.321472] pci_bus 0000:00: resource 11 [mem 0x7af00001-0x7ef00000]
[    0.321479] pci_bus 0000:00: resource 12 [mem 0x80000000-0x908ffffe]
[    0.321485] pci_bus 0000:00: resource 13 [mem 0xfed40000-0xfed40fff]
[    0.321549] NET: Registered protocol family 2
[    0.321890] TCP established hash table entries: 8192 (order: 3, 32768 bytes)
[    0.321938] TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
[    0.322013] TCP: Hash tables configured (established 8192 bind 8192)
[    0.322056] TCP: reno registered
[    0.322068] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.322090] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.322183] NET: Registered protocol family 1
[    0.322218] pci 0000:00:02.0: Boot video device
[    0.322632] PCI: CLS 0 bytes, default 64
[    0.800023] microcode: CPU0 sig=0x30678, pf=0x2, revision=0x808
[    0.800048] microcode: CPU1 sig=0x30678, pf=0x2, revision=0x808
[    0.800075] microcode: CPU2 sig=0x30678, pf=0x2, revision=0x808
[    0.800104] microcode: CPU3 sig=0x30678, pf=0x2, revision=0x808
[    0.800208] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.800940] Scanning for low memory corruption every 60 seconds
[    0.801569] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    0.801616] audit: initializing netlink subsys (disabled)
[    0.801648] audit: type=2000 audit(1400200853.766:1): initialized
[    0.837558] bounce pool size: 64 pages
[    0.837578] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.843189] msgmni has been set to 1760
[    0.843903] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
[    0.843919] io scheduler noop registered
[    0.843928] io scheduler deadline registered
[    0.844106] io scheduler cfq registered (default)
[    0.844447] intel_idle: MWAIT substates: 0x33000020
[    0.844452] intel_idle: v0.4 model 0x37
[    0.844457] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.852001] ACPI: AC Adapter [ADP1] (on-line)
[    0.852326] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.852347] ACPI: Power Button [PWRF]
[    0.852359] ACPI Warning: Could not enable fixed event - PowerButton (2) (20140214/evxface-628)
[    0.858350] button: probe of LNXPWRBN:00 failed with error -22
[    0.864025] [Firmware Bug]: No valid trip found
[    0.864273] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.884668] 00:04: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    0.885698] 80860F0A:00: ttyS1 at MMIO 0x9091d000 (irq = 39, base_baud = 2764800) is a 16550A
[    0.885954] 80860F0A:01: ttyS2 at MMIO 0x9091f000 (irq = 40, base_baud = 2764800) is a 16550A
[    0.886308] hpet: number irqs doesn't agree with number of timers
[    0.886438] Non-volatile memory driver v1.3
[    0.886514] [drm] Initialized drm 1.1.0 20060810
[    0.888432] [drm] Memory usable by graphics device = 2048M
[    0.893120] ACPI: \_SB_.PCI0.GFX0: Error attaching device data 7
[    0.893372] ACPI: \_SB_.PCI0.GFX0: Error attaching device data 7
[    0.893636] ACPI: \_SB_.PCI0.GFX0: Error attaching device data 7
[    0.893887] ACPI: \_SB_.PCI0.GFX0: Error attaching device data 7
[    0.894138] ACPI: \_SB_.PCI0.GFX0: Error attaching device data 7
[    0.896821] i915 0000:00:02.0: irq 103 for MSI/MSI-X
[    0.896839] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    0.896849] [drm] Driver supports precise vblank timestamp query.
[    0.949327] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    0.950125] ACPI: \_SB_.PCI0.GFX0: Error attaching device data 7
[    0.950523] ACPI: \_SB_.PCI0.GFX0: Error attaching device data 7
[    1.478205] [drm] forcing HDMI-A-1 connector ON
[    1.554441] [drm] GMBUS [i915 gmbus vga] timed out, falling back to bit banging on pin 2
[    1.575805] [drm] Got external EDID base block and 0 extensions from "edid/1200x1920.bin" for connector "HDMI-A-1"
[    1.722033] [drm] GMBUS [i915 gmbus dpc] timed out, falling back to bit banging on pin 4
[    1.818338] fbcon: inteldrmfb (fb0) is primary device
[    1.955080] Switched to clocksource tsc
[    2.331727] Console: switching to colour frame buffer device 150x120
[    2.365253] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    2.365400] i915 0000:00:02.0: registered panic notifier
[    2.369617] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    2.371353] acpi device:1a: registered as cooling_device4
[    2.372792] acpi device:21: registered as cooling_device5
[    2.373108] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input1
[    2.373395] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    2.373911] brd: module loaded
[    2.374464] loop: module loaded
[    2.375205] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    2.375451] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
[    2.375778] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    2.375815] xhci_hcd 0000:00:14.0: irq 104 for MSI/MSI-X
[    2.375961] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.376124] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.376295] usb usb1: Product: xHCI Host Controller
[    2.376412] usb usb1: Manufacturer: Linux 3.15.0-rc5-Inari xhci_hcd
[    2.376568] usb usb1: SerialNumber: 0000:00:14.0
[    2.376973] hub 1-0:1.0: USB hub found
[    2.377087] hub 1-0:1.0: 6 ports detected
[    2.378757] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    2.378979] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
[    2.379241] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
[    2.379405] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.379583] usb usb2: Product: xHCI Host Controller
[    2.379702] usb usb2: Manufacturer: Linux 3.15.0-rc5-Inari xhci_hcd
[    2.379850] usb usb2: SerialNumber: 0000:00:14.0
[    2.380239] hub 2-0:1.0: USB hub found
[    2.380351] hub 2-0:1.0: 1 port detected
[    2.380860] usbcore: registered new interface driver usb-storage
[    2.381142] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    3.425347] i8042: No controller found
[    3.425565] mousedev: PS/2 mouse device common for all mice
[    3.425675] [drm] Enabling RC6 states: RC6 off, RC6p off, RC6pp off
[    3.426041] ACPI Warning: Could not enable fixed event - RealTimeClock (4) (20140214/evxface-628)
[    3.426464] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    3.426649] rtc_cmos 00:00: alarms up to one day, 242 bytes nvram
[    3.426883] i2c /dev entries driver
[    3.428313] Intel P-state driver initializing.
[    3.428446] Intel pstate controlling: cpu 0
[    3.428587] Intel pstate controlling: cpu 1
[    3.428725] Intel pstate controlling: cpu 2
[    3.428886] Intel pstate controlling: cpu 3
[    3.429124] sdhci: Secure Digital Host Controller Interface driver
[    3.429272] sdhci: Copyright(c) Pierre Ossman
[    3.430578] mmc0: no vqmmc regulator found
[    3.430681] mmc0: no vmmc regulator found
[    3.431936] mmc0: SDHCI controller on ACPI [80860F14:00] using ADMA
[    3.433476] mmc1: no vqmmc regulator found
[    3.433579] mmc1: no vmmc regulator found
[    3.434830] mmc1: SDHCI controller on ACPI [INT33BB:00] using ADMA
[    3.435453] sdhci-acpi 80860F14:01: failed to setup card detect gpio
[    3.436623] mmc2: no vqmmc regulator found
[    3.436724] mmc2: no vmmc regulator found
[    3.437966] mmc2: SDHCI controller on ACPI [80860F14:01] using ADMA
[    3.438148] sdhci-pltfm: SDHCI platform and OF driver helper
[    3.438273] EFI Variables Facility v0.08 2004-May-17
[    3.448100] hidraw: raw HID events driver (C) Jiri Kosina
[    3.448546] usbcore: registered new interface driver usbhid
[    3.448660] usbhid: USB HID core driver
[    3.449146] TCP: cubic registered
[    3.449218] Initializing XFRM netlink socket
[    3.449576] NET: Registered protocol family 10
[    3.450087] sit: IPv6 over IPv4 tunneling driver
[    3.450438] NET: Registered protocol family 17
[    3.450890] Using IPI No-Shortcut mode
[    3.451197] registered taskstats version 1
[    3.451596]   Magic number: 14:324:658
[    3.451761] console [netcon0] enabled
[    3.451837] netconsole: network logging started
[    3.452124] PM: Hibernation image not present or could not be loaded.
[    3.452133] ALSA device list:
[    3.452195]   No soundcards found.
[    3.452325] Warning: unable to open an initial console.
[    3.458742] Freeing unused kernel memory: 12092K (c1750000 - c231f000)
[    3.472576] udevd[949]: starting version 173
[    3.545752] mmc0: BKOPS_EN bit is not set
[    3.622230] mmc0: new HS200 MMC card at address 0001
[    3.624057] mmcblk0: mmc0:0001 HCG8e 58.2 GiB 
[    3.624598] mmcblk0boot0: mmc0:0001 HCG8e partition 1 4.00 MiB
[    3.624750] mmcblk0boot1: mmc0:0001 HCG8e partition 2 4.00 MiB
[    3.625057] mmcblk0rpmb: mmc0:0001 HCG8e partition 3 4.00 MiB
[    3.625994]  mmcblk0: p1 p2
[    3.630611]  mmcblk0boot1: unknown partition table
[    3.633735]  mmcblk0boot0:
[    3.640096] usb 2-1: new SuperSpeed USB device number 2 using xhci_hcd
[    3.651068] usb 2-1: New USB device found, idVendor=0451, idProduct=8046
[    3.651186] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.651671] hub 2-1:1.0: USB hub found
[    3.651758] hub 2-1:1.0: 4 ports detected
[    3.779948] usb 1-1: new high-speed USB device number 2 using xhci_hcd
[    3.943266] usb 1-1: New USB device found, idVendor=0451, idProduct=8044
[    3.969159] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=1
[    3.994984] usb 1-1: SerialNumber: 420208698DA1
[    4.021771] hub 1-1:1.0: USB hub found
[    4.047612] hub 1-1:1.0: 4 ports detected
[    4.094961] Clocksource tsc unstable (delta = 139070527 ns)
[    4.120773] Switched to clocksource refined-jiffies
[    4.143425] usb 1-3: new high-speed USB device number 3 using xhci_hcd
[    4.235688] usb 1-3: New USB device found, idVendor=12d1, idProduct=1570
[    4.262187] usb 1-3: New USB device strings: Mfr=5, Product=4, SerialNumber=0
[    4.288823] usb 1-3: Product: HUAWEI Mobile Broadband Module
[    4.315372] usb 1-3: Manufacturer: Huawei Technologies Co., Ltd.
[    4.454809] usb 1-4: new high-speed USB device number 4 using xhci_hcd
[    4.615088] usb 1-4: New USB device found, idVendor=0951, idProduct=1603
[    4.641469] usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    4.667779] usb 1-4: Product: DataTraveler 2.0
[    4.694205] usb 1-4: Manufacturer: Kingston
[    4.720492] usb 1-4: SerialNumber: 89900000000000000000017E
[    4.747830] usb-storage 1-4:1.0: USB Mass Storage device detected
[    4.774449] scsi0 : usb-storage 1-4:1.0
[    4.833239] usb 1-1.1: new low-speed USB device number 5 using xhci_hcd
[    4.904523] usb 1-1.1: New USB device found, idVendor=046d, idProduct=c03e
[    4.930590] usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.956550] usb 1-1.1: Product: USB-PS/2 Optical Mouse
[    4.982418] usb 1-1.1: Manufacturer: Logitech
[    5.008663] usb 1-1.1: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
[    5.039453] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:14.0/usb1/1-1/1-1.1/1-1.1:1.0/0003:046D:C03E.0001/input/input2
[    5.067114] hid-generic 0003:046D:C03E.0001: input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:14.0-1.1/input0
[    5.132430] usb 1-1.2: new high-speed USB device number 6 using xhci_hcd
[    5.203734] usb 1-1.2: New USB device found, idVendor=0424, idProduct=7500
[    5.230739] usb 1-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    5.257917] usb 1-1.2: Product: LAN7500
[    5.284761] usb 1-1.2: Manufacturer: SMSC
[    5.311315] usb 1-1.2: SerialNumber: 00800f11700e
[    5.381679] usb 1-1.3: new low-speed USB device number 7 using xhci_hcd
[    5.462341] usb 1-1.3: New USB device found, idVendor=046d, idProduct=c312
[    5.489081] usb 1-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.515839] usb 1-1.3: Product: USB Multimedia Keyboard
[    5.542443] usb 1-1.3: Manufacturer: LITEON Technology
[    5.569572] usb 1-1.3: ep 0x81 - rounding interval to 128 microframes, ep desc says 192 microframes
[    5.600996] input: LITEON Technology USB Multimedia Keyboard as /devices/pci0000:00/0000:00:14.0/usb1/1-1/1-1.3/1-1.3:1.0/0003:046D:C312.0002/input/input3
[    5.656590] hid-generic 0003:046D:C312.0002: input,hidraw1: USB HID v1.10 Keyboard [LITEON Technology USB Multimedia Keyboard] on usb-0000:00:14.0-1.3/input0
[    5.768892] scsi 0:0:0:0: Direct-Access     Kingston DataTraveler 2.0 1.00 PQ: 0 ANSI: 2
[    5.799079] sd 0:0:0:0: [sda] 7856128 512-byte logical blocks: (4.02 GB/3.74 GiB)
[    5.799096] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    5.857532] sd 0:0:0:0: [sda] Write Protect is off
[    5.886444] sd 0:0:0:0: [sda] Mode Sense: 23 00 00 00
[    5.886816] sd 0:0:0:0: [sda] No Caching mode page found
[    5.915622] sd 0:0:0:0: [sda] Assuming drive cache: write through
[    5.947408]  sda: sda1 sda2
[    5.986433] sd 0:0:0:0: [sda] Attached SCSI removable disk
[    6.043333] EXT4-fs (sda2): couldn't mount as ext3 due to feature incompatibilities
[    6.076814] EXT4-fs (sda2): couldn't mount as ext2 due to feature incompatibilities
[    6.119661] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[    6.280069] random: nonblocking pool is initialized
[    7.357011] udevd[1689]: starting version 173
[    7.477008] sst-acpi 80860F28:00: Direct firmware load failed with error -2
[    7.484948] sst-acpi 80860F28:00: Falling back to user helper
[    7.577743] sst-acpi 80860F28:00: Cannot load firmware intel/fw_sst_0f28.bin-i2s_master
[    7.586076] byt-rt5640 byt-rt5640: ASoC: CPU DAI Front-cpu-dai not registered
[    7.592798] smsc75xx v1.0.0
[    7.601973] platform byt-rt5640: Driver byt-rt5640 requests probe deferral
[    7.629938] smsc75xx 1-1.2:1.0 eth0: register 'smsc75xx' at usb-0000:00:14.0-1.2, smsc75xx USB 2.0 Gigabit Ethernet, 70:2f:97:00:22:4f
[    7.660544] usbcore: registered new interface driver smsc75xx
[    7.660554] byt-rt5640 byt-rt5640: ASoC: CPU DAI Front-cpu-dai not registered
[    7.660598] platform byt-rt5640: Driver byt-rt5640 requests probe deferral
[   15.786357] mmc0: Got data interrupt 0x00000002 even though no data operation was in progress.
[   15.819492] mmcblk0rpmb: error -110 transferring data, sector 8064, nr 8, cmd response 0x900, card status 0xb00
[   15.850882] mmcblk0rpmb: retrying using single block read
[   15.884298] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   15.917928] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   15.951471] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   15.984802] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   16.017890] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   16.050737] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   16.081372] end_request: I/O error, dev mmcblk0rpmb, sector 8064
[   16.112006] Buffer I/O error on device mmcblk0rpmb, logical block 1008
[   24.373945] mmc0: Got data interrupt 0x00000002 even though no data operation was in progress.
[   24.407032] mmcblk0rpmb: error -110 transferring data, sector 8064, nr 8, cmd response 0x900, card status 0xb00
[   24.438318] mmcblk0rpmb: retrying using single block read
[   24.471644] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   24.505126] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   24.538515] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   24.571758] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   24.604838] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   24.637751] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   24.668398] end_request: I/O error, dev mmcblk0rpmb, sector 8064
[   24.699120] Buffer I/O error on device mmcblk0rpmb, logical block 1008
[   32.940422] mmc0: Got data interrupt 0x00000002 even though no data operation was in progress.
[   32.973781] mmcblk0rpmb: error -110 transferring data, sector 0, nr 16, cmd response 0x900, card status 0xb00
[   33.005431] mmcblk0rpmb: retrying using single block read
[   33.039167] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   33.073116] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   33.106965] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   33.140652] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   33.174081] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   33.207244] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   33.238143] end_request: I/O error, dev mmcblk0rpmb, sector 0
[   33.269079] Buffer I/O error on device mmcblk0rpmb, logical block 0
[   33.300138] end_request: I/O error, dev mmcblk0rpmb, sector 8
[   33.331221] Buffer I/O error on device mmcblk0rpmb, logical block 1
[   41.566672] mmc0: Got data interrupt 0x00000002 even though no data operation was in progress.
[   41.600468] mmcblk0rpmb: error -110 transferring data, sector 0, nr 8, cmd response 0x900, card status 0xb00
[   41.632451] mmcblk0rpmb: retrying using single block read
[   41.666526] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   41.700864] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   41.734945] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   41.768811] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   41.802498] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   41.835947] mmcblk0rpmb: timed out sending r/w cmd command, card status 0x400900
[   41.867201] end_request: I/O error, dev mmcblk0rpmb, sector 0
[   41.898423] Buffer I/O error on device mmcblk0rpmb, logical block 0
[   45.972615] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   47.603164] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   47.634111] smsc75xx 1-1.2:1.0 eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
[   47.668901] smsc75xx 1-1.2:1.0 eth0: link up, 100Mbps, full-duplex, lpa 0x45E1

--nextPart9796051.zhVmkHVF2l--

--nextPart1781176.YgsH4mdxu6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iJwEAAECAAYFAlN1z8gACgkQq+RR+17trfwQZQQAu/R3no+OK4+sK6k9pkN4a7dv
j3GT3k/R/utiR8669ABDb4uzcPrsJSfZGmlcDivn0XgePulC0BC22vIiIcMYwWEY
EhawkfJzgwf1ydeVX0zx6Kfd0zMBEiT2Fu1aBc5UeylnFrQUg95Ypj1Zl80Yz9jB
SaW/a56qWNjiwr+Hh3s=
=NqUG
-----END PGP SIGNATURE-----

--nextPart1781176.YgsH4mdxu6--

