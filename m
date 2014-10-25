Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbaJYTLG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 15:11:06 -0400
Received: from pindarots.xs4all.nl ([82.161.210.87]:37180 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbaJYTLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 15:11:02 -0400
Message-ID: <544BBF55.6070701@xs4all.nl>
Date: Sat, 25 Oct 2014 17:18:45 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: CRASH during boot 3.16.3+
References: <543A88E4.4060707@xs4all.nl> <543ABD7D.5010308@hurleysoftware.com> <543BA610.8010001@xs4all.nl> <543BC242.7020304@hurleysoftware.com>
In-Reply-To: <543BC242.7020304@hurleysoftware.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Here's a 3.16.2 dmesg that is a tad m ore complete but still the usb
errors fill up the buffer.
I want to try a bisect and cloned Linus' tree but need commit numbers
for 3.16.2 and .3 to start the bisect process.
Where can I find these?

Do we have a suspect 3.16.3 commit that I could try to revert?

[    0.743433] pci 0000:01:00.0: supports D1 D2
[    0.743434] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.749719] pci 0000:00:04.0: PCI bridge to [bus 01]
[    0.749788] pci 0000:00:04.0:   bridge window [io  0xe000-0xefff]
[    0.749792] pci 0000:00:04.0:   bridge window [mem
0xd0000000-0xd00fffff 64bit pref]
[    0.749850] pci 0000:02:00.0: [1b6f:7023] type 00 class 0x0c0330
[    0.749869] pci 0000:02:00.0: reg 0x10: [mem 0xfea00000-0xfea07fff 64bit]
[    0.749941] pci 0000:02:00.0: supports D1 D2
[    0.749943] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.759086] pci 0000:00:07.0: PCI bridge to [bus 02]
[    0.759155] pci 0000:00:07.0:   bridge window [mem 0xfea00000-0xfeafffff]
[    0.759205] pci 0000:03:06.0: [9710:9835] type 00 class 0x070002
[    0.759221] pci 0000:03:06.0: reg 0x10: [io  0xd050-0xd057]
[    0.759231] pci 0000:03:06.0: reg 0x14: [io  0xd040-0xd047]
[    0.759241] pci 0000:03:06.0: reg 0x18: [io  0xd030-0xd037]
[    0.759251] pci 0000:03:06.0: reg 0x1c: [io  0xd020-0xd027]
[    0.759261] pci 0000:03:06.0: reg 0x20: [io  0xd010-0xd017]
[    0.759271] pci 0000:03:06.0: reg 0x24: [io  0xd000-0xd00f]
[    0.759344] pci 0000:00:14.4: PCI bridge to [bus 03] (subtractive decode)
[    0.759408] pci 0000:00:14.4:   bridge window [io  0xd000-0xdfff]
[    0.759413] pci 0000:00:14.4:   bridge window [io  0x0000-0x03af]
(subtractive decode)
[    0.759415] pci 0000:00:14.4:   bridge window [io  0x03e0-0x0cf7]
(subtractive decode)
[    0.759416] pci 0000:00:14.4:   bridge window [io  0x03b0-0x03df]
(subtractive decode)
[    0.759417] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff]
(subtractive decode)
[    0.759419] pci 0000:00:14.4:   bridge window [mem
0x000a0000-0x000bffff] (subtractive decode)
[    0.759420] pci 0000:00:14.4:   bridge window [mem
0x000c0000-0x000dffff] (subtractive decode)
[    0.759421] pci 0000:00:14.4:   bridge window [mem
0xc0000000-0xffffffff] (subtractive decode)
[    0.759434] pci_bus 0000:00: on NUMA node 0
[    0.759732] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 5 7 10 11 14 15) *0
[    0.760141] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 5 7 10 11 14 15) *0
[    0.760545] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 5 7 10 11 14 15) *0
[    0.760947] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 5 7 10 11 14 15) *0
[    0.761341] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 5 7 10 11 14 15) *0
[    0.761749] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 5 7 10 11 14 15) *0
[    0.762135] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 5 7 10 11 14 15) *0
[    0.762521] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 5 7 10 11 14 15) *0
[    0.763029] vgaarb: device added:
PCI:0000:00:01.0,decodes=io+mem,owns=io+mem,locks=none
[    0.763124] vgaarb: loaded
[    0.763185] vgaarb: bridge control possible 0000:00:01.0
[    0.763348] SCSI subsystem initialized
[    0.763461] libata version 3.00 loaded.
[    0.763468] ACPI: bus type USB registered
[    0.763547] usbcore: registered new interface driver usbfs
[    0.763615] usbcore: registered new interface driver hub
[    0.763728] usbcore: registered new device driver usb
[    0.763805] pps_core: LinuxPPS API ver. 1 registered
[    0.763866] pps_core: Software ver. 5.3.6 - Copyright 2005-2007
Rodolfo Giometti <giometti@linux.it>
[    0.764037] PCI: Using ACPI for IRQ routing
[    0.770694] PCI: pci_cache_line_size set to 64 bytes
[    0.770740] e820: reserve RAM buffer [mem 0x0009e800-0x0009ffff]
[    0.770742] e820: reserve RAM buffer [mem 0x8d41d000-0x8fffffff]
[    0.770743] e820: reserve RAM buffer [mem 0x8e9d0000-0x8fffffff]
[    0.770744] e820: reserve RAM buffer [mem 0x8f04c000-0x8fffffff]
[    0.770745] e820: reserve RAM buffer [mem 0x8f800000-0x8fffffff]
[    0.770746] e820: reserve RAM buffer [mem 0x43f000000-0x43fffffff]
[    0.770865] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.771058] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    0.773208] Switched to clocksource hpet
[    0.773385] pnp: PnP ACPI init
[    0.773448] ACPI: bus type PNP registered
[    0.773561] system 00:00: [mem 0xe0000000-0xefffffff] has been reserved
[    0.773641] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.773692] system 00:01: [mem 0x90000000-0xbfffffff] has been reserved
[    0.773754] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.773806] system 00:02: [mem 0xfeb80000-0xfebfffff] could not be
reserved
[    0.773869] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.774057] system 00:03: [io  0x04d0-0x04d1] has been reserved
[    0.774126] system 00:03: [io  0x040b] has been reserved
[    0.774188] system 00:03: [io  0x04d6] has been reserved
[    0.774249] system 00:03: [io  0x0c00-0x0c01] has been reserved
[    0.774311] system 00:03: [io  0x0c14] has been reserved
[    0.774373] system 00:03: [io  0x0c50-0x0c51] has been reserved
[    0.774435] system 00:03: [io  0x0c52] has been reserved
[    0.774497] system 00:03: [io  0x0c6c] has been reserved
[    0.774559] system 00:03: [io  0x0c6f] has been reserved
[    0.774620] system 00:03: [io  0x0cd0-0x0cd1] has been reserved
[    0.774681] system 00:03: [io  0x0cd2-0x0cd3] has been reserved
[    0.774743] system 00:03: [io  0x0cd4-0x0cd5] has been reserved
[    0.774805] system 00:03: [io  0x0cd6-0x0cd7] has been reserved
[    0.774873] system 00:03: [io  0x0cd8-0x0cdf] has been reserved
[    0.774937] system 00:03: [io  0x0800-0x089f] could not be reserved
[    0.775008] system 00:03: [io  0x0b20-0x0b3f] has been reserved
[    0.775070] system 00:03: [io  0x0900-0x090f] has been reserved
[    0.775132] system 00:03: [io  0x0910-0x091f] has been reserved
[    0.775194] system 00:03: [io  0xfe00-0xfefe] has been reserved
[    0.775257] system 00:03: [mem 0xfec00000-0xfec00fff] could not be
reserved
[    0.775319] system 00:03: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.775382] system 00:03: [mem 0xfed80000-0xfed8ffff] has been reserved
[    0.775444] system 00:03: [mem 0xfed61000-0xfed70fff] has been reserved
[    0.775507] system 00:03: [mem 0xfec10000-0xfec10fff] has been reserved
[    0.775569] system 00:03: [mem 0xfed00000-0xfed00fff] could not be
reserved
[    0.775632] system 00:03: [mem 0xff000000-0xffffffff] has been reserved
[    0.775695] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.775795] system 00:04: [io  0x0220-0x0227] has been reserved
[    0.775858] system 00:04: [io  0x0228-0x0237] has been reserved
[    0.775926] system 00:04: [io  0x0a20-0x0a2f] has been reserved
[    0.775988] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.776017] pnp 00:05: Plug and Play ACPI device, IDs PNP0303 PNP030b
(active)
[    0.776181] pnp 00:06: [dma 0 disabled]
[    0.776211] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.776237] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.776258] pnp 00:08: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.776295] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    0.776357] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.776468] pnp: PnP ACPI: found 10 devices
[    0.776529] ACPI: bus type PNP unregistered
[    0.782528] pci 0000:00:04.0: PCI bridge to [bus 01]
[    0.782591] pci 0000:00:04.0:   bridge window [io  0xe000-0xefff]
[    0.782655] pci 0000:00:04.0:   bridge window [mem
0xd0000000-0xd00fffff 64bit pref]
[    0.782749] pci 0000:00:07.0: PCI bridge to [bus 02]
[    0.782811] pci 0000:00:07.0:   bridge window [mem 0xfea00000-0xfeafffff]
[    0.782876] pci 0000:00:14.4: PCI bridge to [bus 03]
[    0.782938] pci 0000:00:14.4:   bridge window [io  0xd000-0xdfff]
[    0.783007] pci_bus 0000:00: resource 4 [io  0x0000-0x03af]
[    0.783008] pci_bus 0000:00: resource 5 [io  0x03e0-0x0cf7]
[    0.783010] pci_bus 0000:00: resource 6 [io  0x03b0-0x03df]
[    0.783011] pci_bus 0000:00: resource 7 [io  0x0d00-0xffff]
[    0.783012] pci_bus 0000:00: resource 8 [mem 0x000a0000-0x000bffff]
[    0.783013] pci_bus 0000:00: resource 9 [mem 0x000c0000-0x000dffff]
[    0.783015] pci_bus 0000:00: resource 10 [mem 0xc0000000-0xffffffff]
[    0.783016] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.783018] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xd00fffff
64bit pref]
[    0.783019] pci_bus 0000:02: resource 1 [mem 0xfea00000-0xfeafffff]
[    0.783021] pci_bus 0000:03: resource 0 [io  0xd000-0xdfff]
[    0.783022] pci_bus 0000:03: resource 4 [io  0x0000-0x03af]
[    0.783023] pci_bus 0000:03: resource 5 [io  0x03e0-0x0cf7]
[    0.783024] pci_bus 0000:03: resource 6 [io  0x03b0-0x03df]
[    0.783026] pci_bus 0000:03: resource 7 [io  0x0d00-0xffff]
[    0.783027] pci_bus 0000:03: resource 8 [mem 0x000a0000-0x000bffff]
[    0.783028] pci_bus 0000:03: resource 9 [mem 0x000c0000-0x000dffff]
[    0.783029] pci_bus 0000:03: resource 10 [mem 0xc0000000-0xffffffff]
[    0.783139] NET: Registered protocol family 2
[    0.783382] TCP established hash table entries: 131072 (order: 8,
1048576 bytes)
[    0.783669] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.783908] TCP: Hash tables configured (established 131072 bind 65536)
[    0.783996] TCP: reno registered
[    0.784066] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.784177] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    0.784395] NET: Registered protocol family 1
[    0.784470] pci 0000:00:01.0: Boot video device
[    1.025136] PCI: CLS 64 bytes, default 64
[    1.025182] Trying to unpack rootfs image as initramfs...
[    1.178885] Freeing initrd memory: 13688K (ffff880037292000 -
ffff880037ff0000)
[    1.179209] AMD-Vi: Found IOMMU at 0000:00:00.2 cap 0x40
[    1.179271] AMD-Vi:  Extended features:  PreF PPR GT IA
[    1.179481] AMD-Vi: Interrupt remapping enabled
[    1.179552] pci 0000:00:00.2: irq 40 for MSI/MSI-X
[    1.185609] AMD-Vi: Lazy IO/TLB flushing enabled
[    1.186062] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.186125] software IO TLB [mem 0x8941d000-0x8d41d000] (64MB) mapped
at [ffff88008941d000-ffff88008d41cfff]
[    1.186456] perf: AMD NB counters detected
[    1.186534] LVT offset 0 assigned for vector 0x400
[    1.186604] perf: AMD IBS detected (0x000000ff)
[    1.186684] Scanning for low memory corruption every 60 seconds
[    1.189419] sha1_ssse3: Using AVX optimized SHA-1 implementation
[    1.189563] alg: No test for crc32 (crc32-pclmul)
[    1.189630] sha256_ssse3: Using AVX optimized SHA-256 implementation
[    1.189851] sha512_ssse3: Using AVX optimized SHA-512 implementation
[    1.191887] AVX2 instructions are not detected.
[    1.192078] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    1.192157] audit: initializing netlink subsys (disabled)
[    1.192231] audit: type=2000 audit(1414249806.996:1): initialized
[    1.192473] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.192700] VFS: Disk quotas dquot_6.5.2
[    1.192773] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.193019] msgmni has been set to 30368
[    1.193701] alg: No test for stdrng (krng)
[    1.193772] NET: Registered protocol family 38
[    1.193852] Block layer SCSI generic (bsg) driver version 0.4 loaded
(major 253)
[    1.193945] io scheduler noop registered (default)
[    1.194166] pcieport 0000:00:04.0: irq 41 for MSI/MSI-X
[    1.194208] pcieport 0000:00:07.0: irq 42 for MSI/MSI-X
[    1.194355] ACPI: acpi_idle registered with cpuidle
[    1.194632] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.214974] 00:06: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200)
is a 16550A
[    1.235631] 0000:03:06.0: ttyS1 at I/O 0xd050 (irq = 20, base_baud =
115200) is a 16550A
[    1.256068] 0000:03:06.0: ttyS2 at I/O 0xd040 (irq = 20, base_baud =
115200) is a 16550A
[    1.257193] brd: module loaded
[    1.257683] loop: module loaded
[    1.257780] ahci 0000:00:11.0: version 3.0
[    1.257877] ahci 0000:00:11.0: irq 43 for MSI/MSI-X
[    1.257881] ahci 0000:00:11.0: irq 44 for MSI/MSI-X
[    1.257885] ahci 0000:00:11.0: irq 45 for MSI/MSI-X
[    1.257888] ahci 0000:00:11.0: irq 46 for MSI/MSI-X
[    1.257892] ahci 0000:00:11.0: irq 47 for MSI/MSI-X
[    1.257895] ahci 0000:00:11.0: irq 48 for MSI/MSI-X
[    1.257898] ahci 0000:00:11.0: irq 49 for MSI/MSI-X
[    1.257902] ahci 0000:00:11.0: irq 50 for MSI/MSI-X
[    1.257989] ahci 0000:00:11.0: AHCI 0001.0300 32 slots 8 ports 6 Gbps
0xff impl SATA mode
[    1.258087] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo
pmp pio slum part sxs
[    1.259136] scsi0 : ahci
[    1.259325] scsi1 : ahci
[    1.259471] scsi2 : ahci
[    1.262120] scsi3 : ahci
[    1.262268] scsi4 : ahci
[    1.262416] scsi5 : ahci
[    1.262566] scsi6 : ahci
[    1.262712] scsi7 : ahci
[    1.262801] ata1: SATA max UDMA/133 abar m2048@0xfeb51000 port
0xfeb51100 irq 43
[    1.262894] ata2: SATA max UDMA/133 abar m2048@0xfeb51000 port
0xfeb51180 irq 44
[    1.262987] ata3: SATA max UDMA/133 abar m2048@0xfeb51000 port
0xfeb51200 irq 45
[    1.263086] ata4: SATA max UDMA/133 abar m2048@0xfeb51000 port
0xfeb51280 irq 46
[    1.263178] ata5: SATA max UDMA/133 abar m2048@0xfeb51000 port
0xfeb51300 irq 47
[    1.263271] ata6: SATA max UDMA/133 abar m2048@0xfeb51000 port
0xfeb51380 irq 48
[    1.263363] ata7: SATA max UDMA/133 abar m2048@0xfeb51000 port
0xfeb51400 irq 49
[    1.263455] ata8: SATA max UDMA/133 abar m2048@0xfeb51000 port
0xfeb51480 irq 50
[    1.263618] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    1.263939] r8169 0000:01:00.0: irq 51 for MSI/MSI-X
[    1.264047] r8169 0000:01:00.0 eth0: RTL8168evl/8111evl at
0xffffc9000001c000, 90:2b:34:a1:03:8b, XID 0c900800 IRQ 51
[    1.264140] r8169 0000:01:00.0 eth0: jumbo features [frames: 9200
bytes, tx checksumming: ko]
[    1.264252] usbcore: registered new interface driver cdc_subset
[    1.264325] usbcore: registered new interface driver cdc_ncm
[    1.264425] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    1.264494] i8042: PNP: PS/2 appears to have AUX port disabled, if
this is incorrect please boot with i8042.nopnp
[    1.264748] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.264875] mousedev: PS/2 mouse device common for all mice
[    1.265045] input: PC Speaker as /devices/platform/pcspkr/input/input1
[    1.265114] pps_ldisc: PPS line discipline registered
[    1.265176] md: raid1 personality registered for level 1
[    1.265238] md: raid10 personality registered for level 10
[    1.265418] md: raid6 personality registered for level 6
[    1.265479] md: raid5 personality registered for level 5
[    1.265540] md: raid4 personality registered for level 4
[    1.265638] device-mapper: uevent: version 1.0.3
[    1.265755] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30)
initialised: dm-devel@redhat.com
[    1.265974] TCP: cubic registered
[    1.266119] NET: Registered protocol family 10
[    1.266339] NET: Registered protocol family 17
[    1.266408] Key type dns_resolver registered
[    1.266848] registered taskstats version 1
[    1.286242] input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input0
[    1.579997] ata4: SATA link down (SStatus 0 SControl 300)
[    1.580086] ata7: SATA link down (SStatus 0 SControl 300)
[    1.580190] ata8: SATA link down (SStatus 0 SControl 300)
[    1.751658] ata3: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.751742] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.751820] ata5: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.751905] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.751982] ata6: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.752887] ata3.00: ATA-8: ST2000DM001-1CH164, CC26, max UDMA/133
[    1.752977] ata3.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth
31/32), AA
[    1.753081] ata5.00: ATA-8: ST2000DM001-1CH164, CC24, max UDMA/133
[    1.753149] ata5.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth
31/32), AA
[    1.753269] ata6.00: ATA-8: ST2000DM001-1CH164, CC26, max UDMA/133
[    1.753334] ata6.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth
31/32), AA
[    1.753448] ata2.00: ATA-8: ST2000DM001-1CH164, CC24, max UDMA/133
[    1.753511] ata2.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth
31/32), AA
[    1.753953] ata3.00: configured for UDMA/133
[    1.754106] ata5.00: configured for UDMA/133
[    1.754388] ata6.00: configured for UDMA/133
[    1.754478] ata1.00: ATAPI: PLEXTOR DVDR   PX-891SA, 1.04, max UDMA/100
[    1.754548] ata2.00: configured for UDMA/133
[    1.755551] ata1.00: configured for UDMA/100
[    1.757985] scsi 0:0:0:0: CD-ROM            PLEXTOR  DVDR   PX-891SA
 1.04 PQ: 0 ANSI: 5
[    1.764615] scsi 1:0:0:0: Direct-Access     ATA      ST2000DM001-1CH1
CC24 PQ: 0 ANSI: 5
[    1.764876] sd 1:0:0:0: [sda] 3907029168 512-byte logical blocks:
(2.00 TB/1.81 TiB)
[    1.764961] scsi 2:0:0:0: Direct-Access     ATA      ST2000DM001-1CH1
CC26 PQ: 0 ANSI: 5
[    1.765096] sd 1:0:0:0: [sda] 4096-byte physical blocks
[    1.765119] sd 2:0:0:0: [sdb] 3907029168 512-byte logical blocks:
(2.00 TB/1.81 TiB)
[    1.765120] sd 2:0:0:0: [sdb] 4096-byte physical blocks
[    1.765207] sd 2:0:0:0: [sdb] Write Protect is off
[    1.765208] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.765258] sd 2:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.765261] scsi 4:0:0:0: Direct-Access     ATA      ST2000DM001-1CH1
CC24 PQ: 0 ANSI: 5
[    1.765418] sd 4:0:0:0: [sdc] 3907029168 512-byte logical blocks:
(2.00 TB/1.81 TiB)
[    1.765420] sd 4:0:0:0: [sdc] 4096-byte physical blocks
[    1.765493] sd 4:0:0:0: [sdc] Write Protect is off
[    1.765494] sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    1.765517] sd 4:0:0:0: [sdc] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.765518] scsi 5:0:0:0: Direct-Access     ATA      ST2000DM001-1CH1
CC26 PQ: 0 ANSI: 5
[    1.765660] sd 5:0:0:0: [sdd] 3907029168 512-byte logical blocks:
(2.00 TB/1.81 TiB)
[    1.765661] sd 5:0:0:0: [sdd] 4096-byte physical blocks
[    1.765791] sd 5:0:0:0: [sdd] Write Protect is off
[    1.765792] sd 5:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    1.765837] sd 5:0:0:0: [sdd] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.766631] sd 1:0:0:0: [sda] Write Protect is off
[    1.766691] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.766723] sd 1:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.775631]  sda: sda1 sda2 sda4
[    1.776007] sd 1:0:0:0: [sda] Attached SCSI disk
[    1.780077]  sdc: sdc1 sdc2 sdc4
[    1.780515] sd 4:0:0:0: [sdc] Attached SCSI disk
[    1.780670]  sdd: sdd1 sdd2 sdd4
[    1.780998] sd 5:0:0:0: [sdd] Attached SCSI disk
[    1.786591]  sdb: sdb1 sdb2 sdb4
[    1.786967] sd 2:0:0:0: [sdb] Attached SCSI disk
[    1.787259] Freeing unused kernel memory: 832K (ffffffff9173a000 -
ffffffff9180a000)
[    1.789072] systemd[1]: systemd 208 running in system mode. (+PAM
+LIBWRAP +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[    1.789275] systemd[1]: Running in initial RAM disk.
[    1.789805] systemd[1]: Failed to insert module 'autofs4'
[    1.789899] systemd[1]: Set hostname to <surfplank2.hierzo>.
[    1.790297] random: systemd urandom read with 45 bits of entropy
available
[    1.794697] systemd[1]: Expecting device
dev-disk-by\x2duuid-1b97d8cb\x2d9875\x2d49cd\x2db2be\x2d0ce534c1b125.device...
[    1.794983] systemd[1]: Expecting device
dev-mapper-myvg\x2dusrlv.device...
[    1.795215] systemd[1]: Expecting device
dev-mapper-myvg\x2drootlv.device...
[    1.795446] systemd[1]: Expecting device dev-myvg-rootlv.device...
[    1.795718] systemd[1]: Starting -.slice.
[    1.796063] systemd[1]: Created slice -.slice.
[    1.796131] systemd[1]: Starting System Slice.
[    1.796465] systemd[1]: Created slice System Slice.
[    1.796533] systemd[1]: Starting Slices.
[    1.796825] systemd[1]: Reached target Slices.
[    1.796891] systemd[1]: Starting Timers.
[    1.797183] systemd[1]: Reached target Timers.
[    1.797250] systemd[1]: Starting Journal Socket.
[    1.797571] systemd[1]: Listening on Journal Socket.
[    1.797702] systemd[1]: Starting dracut cmdline hook...
[    1.800530] systemd[1]: Starting Journal Service...
[    1.801286] systemd[1]: Started Journal Service.
[    1.941979] systemd-udevd[277]: starting version 208
[    2.009062] QUIRK: Enable AMD PLL fix
[    2.009079] xhci_hcd 0000:00:10.0: xHCI Host Controller
[    2.009188] xhci_hcd 0000:00:10.0: new USB bus registered, assigned
bus number 1
[    2.009586] xhci_hcd 0000:00:10.0: irq 52 for MSI/MSI-X
[    2.009595] xhci_hcd 0000:00:10.0: irq 53 for MSI/MSI-X
[    2.009603] xhci_hcd 0000:00:10.0: irq 54 for MSI/MSI-X
[    2.009611] xhci_hcd 0000:00:10.0: irq 55 for MSI/MSI-X
[    2.009616] xhci_hcd 0000:00:10.0: irq 56 for MSI/MSI-X
[    2.009654] [drm] Initialized drm 1.1.0 20060810
[    2.010272] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.010345] usb usb1: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    2.010441] usb usb1: Product: xHCI Host Controller
[    2.010505] usb usb1: Manufacturer: Linux 3.16.2 xhci_hcd
[    2.010570] usb usb1: SerialNumber: 0000:00:10.0
[    2.010767] hub 1-0:1.0: USB hub found
[    2.010841] hub 1-0:1.0: 2 ports detected
[    2.010981] xhci_hcd 0000:00:10.0: xHCI Host Controller
[    2.011048] xhci_hcd 0000:00:10.0: new USB bus registered, assigned
bus number 2
[    2.012967] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
[    2.013031] usb usb2: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    2.013124] usb usb2: Product: xHCI Host Controller
[    2.013187] usb usb2: Manufacturer: Linux 3.16.2 xhci_hcd
[    2.013250] usb usb2: SerialNumber: 0000:00:10.0
[    2.013761] hub 2-0:1.0: USB hub found
[    2.013839] hub 2-0:1.0: 2 ports detected
[    2.014087] xhci_hcd 0000:00:10.1: xHCI Host Controller
[    2.014156] xhci_hcd 0000:00:10.1: new USB bus registered, assigned
bus number 3
[    2.014478] xhci_hcd 0000:00:10.1: irq 57 for MSI/MSI-X
[    2.014490] xhci_hcd 0000:00:10.1: irq 58 for MSI/MSI-X
[    2.014496] xhci_hcd 0000:00:10.1: irq 59 for MSI/MSI-X
[    2.014503] xhci_hcd 0000:00:10.1: irq 60 for MSI/MSI-X
[    2.014509] xhci_hcd 0000:00:10.1: irq 61 for MSI/MSI-X
[    2.015154] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    2.015226] usb usb3: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    2.015324] usb usb3: Product: xHCI Host Controller
[    2.015393] usb usb3: Manufacturer: Linux 3.16.2 xhci_hcd
[    2.015457] usb usb3: SerialNumber: 0000:00:10.1
[    2.015618] hub 3-0:1.0: USB hub found
[    2.015698] hub 3-0:1.0: 2 ports detected
[    2.015822] xhci_hcd 0000:00:10.1: xHCI Host Controller
[    2.015888] xhci_hcd 0000:00:10.1: new USB bus registered, assigned
bus number 4
[    2.018995] [drm] radeon kernel modesetting enabled.
[    2.019750] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
[    2.019766] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.019886] usb usb4: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    2.019981] usb usb4: Product: xHCI Host Controller
[    2.020048] usb usb4: Manufacturer: Linux 3.16.2 xhci_hcd
[    2.020118] usb usb4: SerialNumber: 0000:00:10.1
[    2.020236] ohci-pci: OHCI PCI platform driver
[    2.020329] hub 4-0:1.0: USB hub found
[    2.020399] hub 4-0:1.0: 2 ports detected
[    2.020853] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.020918] Warning! ehci_hcd should always be loaded before uhci_hcd
and ohci_hcd, not after
[    2.021156] ehci-pci: EHCI PCI platform driver
[    2.021386] xhci_hcd 0000:02:00.0: xHCI Host Controller
[    2.021456] xhci_hcd 0000:02:00.0: new USB bus registered, assigned
bus number 5
[    2.021663] xhci_hcd 0000:02:00.0: irq 62 for MSI/MSI-X
[    2.021759] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
[    2.021830] usb usb5: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    2.021929] usb usb5: Product: xHCI Host Controller
[    2.021997] usb usb5: Manufacturer: Linux 3.16.2 xhci_hcd
[    2.022080] usb usb5: SerialNumber: 0000:02:00.0
[    2.022179] [drm] initializing kernel modesetting (ARUBA
0x1002:0x9901 0x1002:0x9901).
[    2.022284] [drm] register mmio base: 0xFEB00000
[    2.022351] [drm] register mmio size: 262144
[    2.022450] ATOM BIOS: 113
[    2.022575] radeon 0000:00:01.0: VRAM: 768M 0x0000000000000000 -
0x000000002FFFFFFF (768M used)
[    2.022679] radeon 0000:00:01.0: GTT: 1024M 0x0000000030000000 -
0x000000006FFFFFFF
[    2.022776] [drm] Detected VRAM RAM=768M, BAR=256M
[    2.022841] [drm] RAM width 64bits DDR
[    2.022947] [TTM] Zone  kernel: Available graphics memory: 7774866 kiB
[    2.023013] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[    2.023079] [TTM] Initializing pool allocator
[    2.023193] [TTM] Initializing DMA pool allocator
[    2.023254] systemd-udevd[320]: renamed network interface eth0 to enp1s0
[    2.023355] [drm] radeon: 768M of VRAM memory ready
[    2.023423] [drm] radeon: 1024M of GTT memory ready.
[    2.023499] [drm] Loading ARUBA Microcode
[    2.023618] [drm] Internal thermal controller without fan control
[    2.023713] == power state 0 ==
[    2.023785] 	ui class: none
[    2.023898] 	internal class: uvd
[    2.024034] 	caps:
[    2.024139] 	uvd    vclk: 72381 dclk: 60800
[    2.024205] 		power level 0    sclk: 80000 vddc: 1199
[    2.024273] 		power level 1    sclk: 80000 vddc: 1199
[    2.024338] 	status:
[    2.024450] == power state 1 ==
[    2.024543] 	ui class: none
[    2.024652] 	internal class: uvd_mvc
[    2.024801] 	caps:
[    2.024912] 	uvd    vclk: 72381 dclk: 60800
[    2.024991] 		power level 0    sclk: 80000 vddc: 1199
[    2.025057] 		power level 1    sclk: 80000 vddc: 1199
[    2.025121] 	status:
[    2.025217] == power state 2 ==
[    2.025281] 	ui class: performance
[    2.025378] 	internal class: none
[    2.025506] 	caps:
[    2.025610] 	uvd    vclk: 0 dclk: 0
[    2.025674] 		power level 0    sclk: 80000 vddc: 1199
[    2.025739] 		power level 1    sclk: 80000 vddc: 1199
[    2.025805] 		power level 2    sclk: 80000 vddc: 1199
[    2.025867] 	status:
[    2.025959] == power state 3 ==
[    2.026023] 	ui class: none
[    2.026118] 	internal class: boot
[    2.026243] 	caps:
[    2.026338] 	uvd    vclk: 0 dclk: 0
[    2.026403] 		power level 0    sclk: 20000 vddc: 1274
[    2.026472] 	status: c r b
[    2.026596] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw
xa/form2 cdda tray
[    2.026598] cdrom: Uniform CD-ROM driver Revision: 3.20

[    2.026835] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    2.026911] == power state 4 ==
[    2.026978] 	ui class: none
[    2.027086] 	internal class: thermal
[    2.027254] 	caps:
[    2.027348] 	uvd    vclk: 0 dclk: 0
[    2.027415] 		power level 0    sclk: 20000 vddc: 937
[    2.027483] 	status:
[    2.027977] [drm] radeon: dpm initialized
[    2.028172] [drm] GART: num cpu pages 262144, num gpu pages 262144
[    2.031232] hub 5-0:1.0: USB hub found
[    2.031310] hub 5-0:1.0: 2 ports detected
[    2.031446] xhci_hcd 0000:02:00.0: xHCI Host Controller
[    2.031514] xhci_hcd 0000:02:00.0: new USB bus registered, assigned
bus number 6
[    2.031671] usb usb6: New USB device found, idVendor=1d6b, idProduct=0003
[    2.031741] usb usb6: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    2.031841] usb usb6: Product: xHCI Host Controller
[    2.031906] usb usb6: Manufacturer: Linux 3.16.2 xhci_hcd
[    2.031970] usb usb6: SerialNumber: 0000:02:00.0
[    2.032122] hub 6-0:1.0: USB hub found
[    2.032197] hub 6-0:1.0: 2 ports detected
[    2.050821] [drm] PCIE GART of 1024M enabled (table at
0x0000000000276000).
[    2.051016] radeon 0000:00:01.0: WB enabled
[    2.051115] radeon 0000:00:01.0: fence driver on ring 0 use gpu addr
0x0000000030000c00 and cpu addr 0xffff880088e55c00
[    2.051928] radeon 0000:00:01.0: fence driver on ring 5 use gpu addr
0x0000000000075a18 and cpu addr 0xffffc900102b5a18
[    2.052029] radeon 0000:00:01.0: fence driver on ring 1 use gpu addr
0x0000000030000c04 and cpu addr 0xffff880088e55c04
[    2.052132] radeon 0000:00:01.0: fence driver on ring 2 use gpu addr
0x0000000030000c08 and cpu addr 0xffff880088e55c08
[    2.052241] radeon 0000:00:01.0: fence driver on ring 3 use gpu addr
0x0000000030000c0c and cpu addr 0xffff880088e55c0c
[    2.052349] radeon 0000:00:01.0: fence driver on ring 4 use gpu addr
0x0000000030000c10 and cpu addr 0xffff880088e55c10
[    2.052452] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    2.052526] [drm] Driver supports precise vblank timestamp query.
[    2.052616] radeon 0000:00:01.0: irq 63 for MSI/MSI-X
[    2.052627] radeon 0000:00:01.0: radeon: using MSI.
[    2.053026] [drm] radeon: irq initialized.
[    2.072498] [drm] ring test on 0 succeeded in 2 usecs
[    2.072623] [drm] ring test on 3 succeeded in 2 usecs
[    2.072710] [drm] ring test on 4 succeeded in 1 usecs
[    2.108526] [drm] ring test on 5 succeeded in 2 usecs
[    2.128423] [drm] UVD initialized successfully.
[    2.130583] [drm] ib test on ring 0 succeeded in 0 usecs
[    2.131198] [drm] ib test on ring 3 succeeded in 0 usecs
[    2.131810] [drm] ib test on ring 4 succeeded in 1 usecs
[    2.146847] md: bind<sdd1>
[    2.153034] [drm] ib test on ring 5 succeeded
[    2.163687] md: bind<sdb1>
[    2.173418] [drm] Radeon Display Connectors
[    2.173494] [drm] Connector 0:
[    2.173560] [drm]   HDMI-A-1
[    2.173627] [drm]   HPD1
[    2.173696] [drm]   DDC: 0x6530 0x6530 0x6534 0x6534 0x6538 0x6538
0x653c 0x653c
[    2.173800] [drm]   Encoders:
[    2.173866] [drm]     DFP1: INTERNAL_UNIPHY2
[    2.173938] [drm] Connector 1:
[    2.174005] [drm]   VGA-1
[    2.174071] [drm]   HPD2
[    2.174143] [drm]   DDC: 0x6540 0x6540 0x6544 0x6544 0x6548 0x6548
0x654c 0x654c
[    2.174240] [drm]   Encoders:
[    2.174305] [drm]     CRT1: INTERNAL_UNIPHY2
[    2.174373] [drm]     CRT1: NUTMEG
[    2.174441] [drm] Connector 2:
[    2.174514] [drm]   DVI-D-1
[    2.174581] [drm]   HPD3
[    2.174654] [drm]   DDC: 0x6550 0x6550 0x6554 0x6554 0x6558 0x6558
0x655c 0x655c
[    2.174758] [drm]   Encoders:
[    2.174823] [drm]     DFP2: INTERNAL_UNIPHY
[    2.182855] tsc: Refined TSC clocksource calibration: 3872.261 MHz
[    2.185361] md: bind<sdc1>
[    2.204454] random: nonblocking pool is initialized
[    2.210917] md: bind<sdb2>
[    2.212303] md: bind<sdd2>
[    2.234783] switching from power state:
[    2.234864] 	ui class: none
[    2.234954] 	internal class: boot
[    2.235073] 	caps:
[    2.235162] 	uvd    vclk: 0 dclk: 0
[    2.235224] 		power level 0    sclk: 20000 vddc: 1274
[    2.235285] 	status: c b
[    2.235434] switching to power state:
[    2.235494] 	ui class: performance
[    2.235585] 	internal class: none
[    2.235703] 	caps:
[    2.235792] 	uvd    vclk: 0 dclk: 0
[    2.235853] 		power level 0    sclk: 80000 vddc: 1199
[    2.235915] 		power level 1    sclk: 80000 vddc: 1199
[    2.235977] 		power level 2    sclk: 80000 vddc: 1199
[    2.236038] 	status: r
[    2.244409] md: bind<sda1>
[    2.249747] md/raid1:md0: active with 4 out of 4 mirrors
[    2.249817] md0: detected capacity change from 0 to 536805376
[    2.250567] md: bind<sdc2>
[    2.251095]  md0: unknown partition table
[    2.251896] md: bind<sda2>
[    2.253558] md/raid10:md1: active with 4 out of 4 devices
[    2.253622] md1: detected capacity change from 0 to 3997621551104
[    2.286423]  md1: unknown partition table
[    2.330685] usb 3-1: new high-speed USB device number 2 using xhci_hcd
[    2.351705] [drm] fb mappable at 0xC047A000
[    2.351749] [drm] vram apper at 0xC0000000
[    2.351798] [drm] size 7299072
[    2.351844] [drm] fb depth is 24
[    2.351886] [drm]    pitch is 6912
[    2.351995] fbcon: radeondrmfb (fb0) is primary device
[    2.424615] Console: switching to colour frame buffer device 210x65
[    2.428001] radeon 0000:00:01.0: fb0: radeondrmfb frame buffer device
[    2.428002] radeon 0000:00:01.0: registered panic notifier
[    2.446585] [drm] Initialized radeon 2.39.0 20080528 for 0000:00:01.0
on minor 0
[    2.446837] ohci-pci 0000:00:12.0: OHCI PCI host controller
[    2.446873] ohci-pci 0000:00:12.0: new USB bus registered, assigned
bus number 7
[    2.447284] ohci-pci 0000:00:12.0: irq 18, io mem 0xfeb50000
[    2.506475] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    2.506504] usb usb7: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    2.506528] usb usb7: Product: OHCI PCI host controller
[    2.506546] usb usb7: Manufacturer: Linux 3.16.2 ohci_hcd
[    2.506563] usb usb7: SerialNumber: 0000:00:12.0
[    2.506798] hub 7-0:1.0: USB hub found
[    2.506823] hub 7-0:1.0: 5 ports detected
[    2.507022] ohci-pci 0000:00:13.0: OHCI PCI host controller
[    2.507045] ohci-pci 0000:00:13.0: new USB bus registered, assigned
bus number 8
[    2.507140] ohci-pci 0000:00:13.0: irq 18, io mem 0xfeb4e000
[    2.566333] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    2.566363] usb usb8: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    2.566387] usb usb8: Product: OHCI PCI host controller
[    2.566404] usb usb8: Manufacturer: Linux 3.16.2 ohci_hcd
[    2.566422] usb usb8: SerialNumber: 0000:00:13.0
[    2.566557] hub 8-0:1.0: USB hub found
[    2.566578] hub 8-0:1.0: 5 ports detected
[    2.566793] ohci-pci 0000:00:14.5: OHCI PCI host controller
[    2.566815] ohci-pci 0000:00:14.5: new USB bus registered, assigned
bus number 9
[    2.566899] ohci-pci 0000:00:14.5: irq 18, io mem 0xfeb4c000
[    2.626271] usb usb9: New USB device found, idVendor=1d6b, idProduct=0001
[    2.626301] usb usb9: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    2.626325] usb usb9: Product: OHCI PCI host controller
[    2.626342] usb usb9: Manufacturer: Linux 3.16.2 ohci_hcd
[    2.626360] usb usb9: SerialNumber: 0000:00:14.5
[    2.626594] hub 9-0:1.0: USB hub found
[    2.626623] hub 9-0:1.0: 2 ports detected
[    2.627024] ehci-pci 0000:00:12.2: EHCI Host Controller
[    2.627060] ehci-pci 0000:00:12.2: new USB bus registered, assigned
bus number 10
[    2.627092] ehci-pci 0000:00:12.2: applying AMD
SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    2.628003] ehci-pci 0000:00:12.2: debug port 1
[    2.628986] ehci-pci 0000:00:12.2: irq 17, io mem 0xfeb4f000
[    2.638172] ehci-pci 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    2.639077] usb usb10: New USB device found, idVendor=1d6b,
idProduct=0002
[    2.639941] usb usb10: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    2.640817] usb usb10: Product: EHCI Host Controller
[    2.641691] usb usb10: Manufacturer: Linux 3.16.2 ehci_hcd
[    2.642596] usb usb10: SerialNumber: 0000:00:12.2
[    2.643585] hub 10-0:1.0: USB hub found
[    2.644467] hub 10-0:1.0: 5 ports detected
[    2.645434] hub 7-0:1.0: USB hub found
[    2.646342] hub 7-0:1.0: 5 ports detected
[    2.647461] ehci-pci 0000:00:13.2: EHCI Host Controller
[    2.648367] ehci-pci 0000:00:13.2: new USB bus registered, assigned
bus number 11
[    2.649262] ehci-pci 0000:00:13.2: applying AMD
SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    2.650156] ehci-pci 0000:00:13.2: debug port 1
[    2.651145] ehci-pci 0000:00:13.2: irq 17, io mem 0xfeb4d000
[    2.656789] usb 3-1: New USB device found, idVendor=046d, idProduct=082c
[    2.657666] usb 3-1: New USB device strings: Mfr=0, Product=2,
SerialNumber=1
[    2.658538] usb 3-1: Product: HD Webcam C615
[    2.659411] usb 3-1: SerialNumber: F6629A60
[    2.662115] ehci-pci 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    2.663069] usb usb11: New USB device found, idVendor=1d6b,
idProduct=0002
[    2.663956] usb usb11: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    2.664844] usb usb11: Product: EHCI Host Controller
[    2.665727] usb usb11: Manufacturer: Linux 3.16.2 ehci_hcd
[    2.666639] usb usb11: SerialNumber: 0000:00:13.2
[    2.667685] hub 11-0:1.0: USB hub found
[    2.668566] hub 11-0:1.0: 5 ports detected
[    2.669533] hub 8-0:1.0: USB hub found
[    2.670443] hub 8-0:1.0: 5 ports detected
[    2.774008] usb 5-1: new full-speed USB device number 2 using xhci_hcd
[    3.075144] usb 5-1: New USB device found, idVendor=0471, idProduct=0311
[    3.075980] usb 5-1: New USB device strings: Mfr=0, Product=0,
SerialNumber=1
[    3.076811] usb 5-1: SerialNumber: 01690000A5000000
[    3.181295] Switched to clocksource tsc
[    3.396893] usb 8-5: new low-speed USB device number 2 using ohci-pci
[    3.563823] usb 8-5: New USB device found, idVendor=046d, idProduct=c018
[    3.564697] usb 8-5: New USB device strings: Mfr=1, Product=2,
SerialNumber=0
[    3.565530] usb 8-5: Product: USB Optical Mouse
[    3.566360] usb 8-5: Manufacturer: Logitech
[    3.572840] usbcore: registered new interface driver usbhid
[    3.573717] usbhid: USB HID core driver
[    3.575045] input: Logitech USB Optical Mouse as
/devices/pci0000:00/0000:00:13.0/usb8/8-5/8-5:1.0/0003:046D:C018.0001/input/input2
[    3.575956] hid-generic 0003:046D:C018.0001: input: USB HID v1.11
Mouse [Logitech USB Optical Mouse] on usb-0000:00:13.0-5/input0
[   11.470597] EXT4-fs (dm-1): INFO: recovery required on readonly
filesystem
[   11.471486] EXT4-fs (dm-1): write access will be enabled during recovery
[   11.717339] EXT4-fs (dm-1): recovery complete
[   11.727304] EXT4-fs (dm-1): mounted filesystem with ordered data
mode. Opts: (null)
[   12.687566] EXT4-fs (dm-2): mounted filesystem with ordered data
mode. Opts: (null)
[   12.756769] systemd-journald[131]: Received SIGTERM
[   14.705787] systemd[1]: Got automount request for
/proc/sys/fs/binfmt_misc, triggered by 849 (systemd-binfmt)
[   14.801526] RPC: Registered named UNIX socket transport module.
[   14.802572] RPC: Registered udp transport module.
[   14.803640] RPC: Registered tcp transport module.
[   14.804469] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   14.961228] systemd-udevd[870]: starting version 208
[   14.965919] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   15.122525] EXT4-fs (dm-1): re-mounted. Opts: (null)
[   15.122665] EXT4-fs (dm-2): re-mounted. Opts: (null)
[   15.539680] input: Power Button as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input3
[   15.540803] ACPI: Power Button [PWRB]
[   15.541998] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
[   15.543039] ACPI: Power Button [PWRF]
[   15.552606] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00,
revision 0
[   15.553607] piix4_smbus 0000:00:14.0: Auxiliary SMBus Host Controller
at 0xb20
[   15.571299] acpi-cpufreq: overriding BIOS provided _PSD data
[   15.764103] systemd-udevd[900]: renamed network interface enp1s0 to eth0
[   15.793901] Linux video capture interface: v2.00
[   15.836022] pwc: Philips PCVC740K (ToUCam Pro)/PCVC840 (ToUCam II)
USB webcam detected.
[   15.845743] microcode: CPU0: patch_level=0x06001119
[   15.879654] uvcvideo: Found UVC 1.00 device HD Webcam C615 (046d:082c)
[   15.896321] input: HD Webcam C615 as
/devices/pci0000:00/0000:00:10.1/usb3/3-1/3-1:1.2/input/input5
[   15.898788] usbcore: registered new interface driver uvcvideo
[   15.901194] USB Video Class driver (1.1.1)
[   15.913947] microcode: CPU1: patch_level=0x06001119
[   15.915212] microcode: CPU2: patch_level=0x06001119
[   15.918145] microcode: CPU3: patch_level=0x06001119
[   15.920782] microcode: Microcode Update Driver: v2.00
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   15.980789] snd_hda_intel 0000:00:01.1: Force to non-snoop mode
[   15.983745] snd_hda_intel 0000:00:01.1: irq 64 for MSI/MSI-X
[   16.003315] sound hdaudioC0D0: autoconfig: line_outs=0
(0x0/0x0/0x0/0x0/0x0) type:line
[   16.004353] sound hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   16.005367] sound hdaudioC0D0:    hp_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   16.006382] sound hdaudioC0D0:    mono: mono_out=0x0
[   16.007395] sound hdaudioC0D0:    dig-out=0x3/0x0
[   16.008434] sound hdaudioC0D0:    inputs:
[   16.044749] sound hdaudioC1D0: autoconfig: line_outs=4
(0x14/0x15/0x16/0x17/0x0) type:line
[   16.047516] sound hdaudioC1D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   16.050266] sound hdaudioC1D0:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[   16.053055] sound hdaudioC1D0:    mono: mono_out=0x0
[   16.055914] sound hdaudioC1D0:    dig-out=0x11/0x1e
[   16.058552] sound hdaudioC1D0:    inputs:
[   16.061141] sound hdaudioC1D0:      Front Mic=0x19
[   16.064000] sound hdaudioC1D0:      Rear Mic=0x18
[   16.066599] sound hdaudioC1D0:      Line=0x1a
[   16.069409] kvm: Nested Virtualization enabled
[   16.072431] kvm: Nested Paging enabled
[   16.081992] pwc: Registered as video1.
[   16.083042] input: PWC snapshot button as
/devices/pci0000:00/0000:00:07.0/0000:02:00.0/usb5/5-1/input/input7
[   16.084136] usbcore: registered new interface driver Philips webcam
[   16.084306] xhci_hcd 0000:02:00.0: ERROR: unexpected command
completion code 0x11.
[   16.084311] usb 5-1: Not enough bandwidth for altsetting 1
[   16.084339] xhci_hcd 0000:02:00.0: ERROR: unexpected command
completion code 0x11.
[   16.084342] usb 5-1: Not enough bandwidth for altsetting 2
[   16.084378] xhci_hcd 0000:02:00.0: ERROR: unexpected command
completion code 0x11.
[   16.084381] usb 5-1: Not enough bandwidth for altsetting 3
[   16.084418] xhci_hcd 0000:02:00.0: ERROR: unexpected command
completion code 0x11.
[   16.084422] usb 5-1: Not enough bandwidth for altsetting 4
[   16.105561] input: HDA Digital PCBeep as
/devices/pci0000:00/0000:00:14.2/sound/card1/hdaudioC1D0/input6
[   16.148024] usbcore: registered new interface driver snd-usb-audio
[   16.350840] ppdev: user-space parallel port driver
[   17.670264] EXT4-fs (dm-6): mounted filesystem with ordered data
mode. Opts: (null)
[   17.800552] EXT4-fs (dm-7): mounted filesystem with ordered data
mode. Opts: (null)
[   19.544289] EXT4-fs (dm-5): mounted filesystem with ordered data
mode. Opts: (null)
[   20.967684] EXT4-fs (dm-3): mounted filesystem with ordered data
mode. Opts: (null)
[   21.131862] EXT4-fs (dm-4): mounted filesystem with ordered data
mode. Opts: (null)
[   21.742831] Adding 1023996k swap on /dev/mapper/swapa.  Priority:-1
extents:1 across:1023996k
[   21.749765] Adding 1023996k swap on /dev/mapper/swapc.  Priority:-2
extents:1 across:1023996k
[   21.808965] Adding 1023996k swap on /dev/mapper/swapb.  Priority:-3
extents:1 across:1023996k
[   42.447028] EXT4-fs (dm-8): mounted filesystem with ordered data
mode. Opts: (null)
[   42.472563] Adding 1023996k swap on /dev/mapper/swapd.  Priority:-4
extents:1 across:1023996k
[   44.940480] systemd-journald[845]: Received request to flush runtime
journal from PID 1
[   45.768112] audit: type=1305 audit(1414249851.644:2): audit_pid=1262
old=0 auid=4294967295 ses=4294967295 res=1
[   45.845612] pps pps0: new PPS source serial2
[   45.847141] pps pps0: source "/dev/ttyS2" added
[   46.001365] it87: Found IT8728F chip at 0x228, revision 1
[   46.002699] it87: Beeping is supported
[   46.077779] ip_tables: (C) 2000-2006 Netfilter Core Team
[   46.098066] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   46.122490] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   47.348842] r8169 0000:01:00.0 eth0: link down
[   47.348917] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   47.348930] r8169 0000:01:00.0 eth0: link down
[   48.251408] EDAC MC: Ver: 3.0.0
[   50.238184] r8169 0000:01:00.0 eth0: link up
[   50.238200] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   52.254756] NFSD: starting 90-second grace period (net ffffffff91717480)
[   57.184714] xhci_hcd 0000:02:00.0: ERROR: unexpected command
completion code 0x11.
[   57.184724] usb 5-1: Not enough bandwidth for altsetting 1
[   57.184729] usb 5-1: 2:1: usb_set_interface failed (-22)
[   57.184780] xhci_hcd 0000:02:00.0: ERROR: unexpected command
completion code 0x11.

(....same stuff repeated)

[   71.326144] usb 5-1: Not enough bandwidth for altsetting 1
[   71.326146] usb 5-1: 2:1: usb_set_interface failed (-22)
[   71.326377] xhci_hcd 0000:02:00.0: ERROR: unexpected command
completion code 0x11.
[   71.326380] usb 5-1: Not enough bandwidth for altsetting 1
[   71.326382] usb 5-1: 2:1: usb_set_interface failed (-22)
[   71.335433] snd_hda_intel 0000:00:01.1: IRQ timing workaround is
activated for card #0. Suggest a bigger bdl_pos_adj.
[   71.720440] Bluetooth: Core ver 2.19
[   71.720480] NET: Registered protocol family 31
[   71.720485] Bluetooth: HCI device and connection manager initialized
[   71.720498] Bluetooth: HCI socket layer initialized
[   71.720505] Bluetooth: L2CAP socket layer initialized
[   71.720522] Bluetooth: SCO socket layer initialized
[   71.747910] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   71.747916] Bluetooth: BNEP filters: protocol multicast
[   71.747929] Bluetooth: BNEP socket layer initialized
[   71.788319] xhci_hcd 0000:02:00.0: ERROR: unexpected command
completion code 0x11.
[   71.788326] usb 5-1: Not enough bandwidth for altsetting 1
[   71.788330] usb 5-1: 2:1: usb_set_interface failed (-22)
[   71.788371] xhci_hcd 0000:02:00.0: ERROR: unexpected command
completion code 0x11.

(....same stuff repeated)

[   71.844378] usb 5-1: Not enough bandwidth for altsetting 1
[   71.844380] usb 5-1: 2:1: usb_set_interface failed (-22)
[   71.844626] xhci_hcd 0000:02:00.0: ERROR: unexpected command
completion code 0x11.
[   71.844629] usb 5-1: Not enough bandwidth for altsetting 1
[   71.844632] usb 5-1: 2:1: usb_set_interface failed (-22)

Kind regards,
Udo
