Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596AbaCVPx7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 11:53:59 -0400
Received: from mailout03.t-online.de ([194.25.134.81]:60713 "EHLO
	mailout03.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbaCVPxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 11:53:53 -0400
Message-ID: <532DB209.1000704@t-online.de>
Date: Sat, 22 Mar 2014 16:53:45 +0100
From: Gerd Grundke <gerdgrundke@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Fwd: kernel bug: Mouse and keyboard dead when resuming from suspend
 on Lenovo W530
References: <532AA900.1010601@t-online.de>
In-Reply-To: <532AA900.1010601@t-online.de>
X-Forwarded-Message-Id: <532AA900.1010601@t-online.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: V8XhBQZGQh1ktHe1hKeDA6CCxn20JUoHpfitzep41VJpHkpnCnxgt+tHwqWAOLvgqF
X-TOI-MSGID: cb9bf346-6722-4e4e-8231-46a4b6c2a812
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

I attached the complete dmesg output and trimmed the system log 
(starting with the sleep request, the resume boot cycle and the new boot 
up after system hung).

The resume starts and Ubuntu presents the login screen, but none of the 
2 keyboards, no mouse, no touchpad is working.

Hope this helps to narrow down the issue.

Regards
Gerd


dmsg.txt
[    4.171490] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    4.171891] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    4.171904] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    4.171939] vesafb: mode is 640x480x32, linelength=2560, pages=0
[    4.171940] vesafb: scrolling: redraw
[    4.171942] vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    4.172024] vesafb: framebuffer at 0xf1000000, mapped to 
0xffffc90005b80000, using 1216k, total 1216k
[    4.186912] Console: switching to colour frame buffer device 80x30
[    4.201739] fb0: VESA VGA frame buffer device
[    4.201754] intel_idle: MWAIT substates: 0x21120
[    4.201755] intel_idle: v0.4 model 0x3A
[    4.201756] intel_idle: lapic_timer_reliable_states 0xffffffff
[    4.202393] ACPI: AC Adapter [AC] (on-line)
[    4.202444] input: Lid Switch as 
/devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    4.202550] ACPI: Lid Switch [LID]
[    4.202584] input: Sleep Button as 
/devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    4.202588] ACPI: Sleep Button [SLPB]
[    4.202629] input: Power Button as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    4.202631] ACPI: Power Button [PWRF]
[    4.203917] thermal LNXTHERM:00: registered as thermal_zone0
[    4.203919] ACPI: Thermal Zone [THM0] (38 C)
[    4.203947] GHES: HEST is not enabled!
[    4.204010] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    4.211476] ACPI: Battery Slot [BAT0] (battery present)
[    4.226066] 0000:00:16.3: ttyS4 at I/O 0x6070 (irq = 19, base_baud = 
115200) is a 16550A
[    4.226291] Linux agpgart interface v0.103
[    4.226839] tpm_tis 00:09: 1.2 TPM (device-id 0x0, rev-id 78)
[    4.295424] tpm_tis 00:09: TPM is disabled/deactivated (0x6)
[    4.297447] brd: module loaded
[    4.298107] loop: module loaded
[    4.298462] libphy: Fixed MDIO Bus: probed
[    4.298539] tun: Universal TUN/TAP device driver, 1.6
[    4.298540] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    4.298574] PPP generic driver version 2.4.2
[    4.298607] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.298610] ehci-pci: EHCI PCI platform driver
[    4.298728] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    4.298733] ehci-pci 0000:00:1a.0: new USB bus registered, assigned 
bus number 1
[    4.298750] ehci-pci 0000:00:1a.0: debug port 2
[    4.302664] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    4.302682] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf533a000
[    4.311304] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    4.311341] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    4.311342] usb usb1: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    4.311344] usb usb1: Product: EHCI Host Controller
[    4.311345] usb usb1: Manufacturer: Linux 3.14.0-031400rc7-generic 
ehci_hcd
[    4.311346] usb usb1: SerialNumber: 0000:00:1a.0
[    4.311446] hub 1-0:1.0: USB hub found
[    4.311453] hub 1-0:1.0: 3 ports detected
[    4.311637] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    4.311643] ehci-pci 0000:00:1d.0: new USB bus registered, assigned 
bus number 2
[    4.311654] ehci-pci 0000:00:1d.0: debug port 2
[    4.315540] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    4.315552] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf5339000
[    4.327298] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    4.327333] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    4.327335] usb usb2: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    4.327336] usb usb2: Product: EHCI Host Controller
[    4.327338] usb usb2: Manufacturer: Linux 3.14.0-031400rc7-generic 
ehci_hcd
[    4.327339] usb usb2: SerialNumber: 0000:00:1d.0
[    4.327458] hub 2-0:1.0: USB hub found
[    4.327464] hub 2-0:1.0: 3 ports detected
[    4.327577] ehci-platform: EHCI generic platform driver
[    4.327584] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    4.327590] ohci-pci: OHCI PCI platform driver
[    4.327598] ohci-platform: OHCI generic platform driver
[    4.327604] uhci_hcd: USB Universal Host Controller Interface driver
[    4.327693] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    4.327697] xhci_hcd 0000:00:14.0: new USB bus registered, assigned 
bus number 3
[    4.327790] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    4.327814] xhci_hcd 0000:00:14.0: irq 41 for MSI/MSI-X
[    4.327880] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    4.327882] usb usb3: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    4.327883] usb usb3: Product: xHCI Host Controller
[    4.327885] usb usb3: Manufacturer: Linux 3.14.0-031400rc7-generic 
xhci_hcd
[    4.327886] usb usb3: SerialNumber: 0000:00:14.0
[    4.328000] hub 3-0:1.0: USB hub found
[    4.328013] hub 3-0:1.0: 4 ports detected
[    4.328342] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    4.328345] xhci_hcd 0000:00:14.0: new USB bus registered, assigned 
bus number 4
[    4.328381] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
[    4.328382] usb usb4: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    4.328384] usb usb4: Product: xHCI Host Controller
[    4.328385] usb usb4: Manufacturer: Linux 3.14.0-031400rc7-generic 
xhci_hcd
[    4.328386] usb usb4: SerialNumber: 0000:00:14.0
[    4.328497] hub 4-0:1.0: USB hub found
[    4.328509] hub 4-0:1.0: 4 ports detected
[    4.328897] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 
0x60,0x64 irq 1,12
[    4.330566] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.330571] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.330723] mousedev: PS/2 mouse device common for all mice
[    4.330977] rtc_cmos 00:06: RTC can wake from S4
[    4.331136] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    4.331167] rtc_cmos 00:06: alarms up to one month, y3k, 114 bytes 
nvram, hpet irqs
[    4.331236] device-mapper: uevent: version 1.0.3
[    4.331316] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) 
initialised: dm-devel@redhat.com
[    4.331322] Intel P-state driver initializing.
[    4.331330] Intel pstate controlling: cpu 0
[    4.331346] Intel pstate controlling: cpu 1
[    4.331374] Intel pstate controlling: cpu 2
[    4.331384] Intel pstate controlling: cpu 3
[    4.331398] Intel pstate controlling: cpu 4
[    4.331408] Intel pstate controlling: cpu 5
[    4.331420] Intel pstate controlling: cpu 6
[    4.331430] Intel pstate controlling: cpu 7
[    4.331459] ledtrig-cpu: registered to indicate activity on CPUs
[    4.331538] TCP: cubic registered
[    4.331603] NET: Registered protocol family 10
[    4.331712] NET: Registered protocol family 17
[    4.331718] Key type dns_resolver registered
[    4.332055] input: AT Translated Set 2 keyboard as 
/devices/platform/i8042/serio0/input/input3
[    4.332190] Loading compiled-in X.509 certificates
[    4.332720] Loaded X.509 cert 'Magrathea: Glacier signing key: 
e66049b677b4dad51f0f529c245acb826c1907cd'
[    4.332729] registered taskstats version 1
[    4.334974] Key type trusted registered
[    4.337126] Key type encrypted registered
[    4.339368] AppArmor: AppArmor sha1 policy hashing enabled
[    4.363401] tpm_tis 00:09: A TPM error (6) occurred attempting to 
read a pcr value
[    4.363847] IMA: No TPM chip found, activating TPM-bypass!
[    4.364349] regulator-dummy: disabling
[    4.364612]   Magic number: 6:699:637
[    4.364760] rtc_cmos 00:06: setting system clock to 2014-03-22 
14:38:04 UTC (1395499084)
[    4.364885] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    4.364887] EDD information not available.
[    4.364952] PM: Hibernation image not present or could not be loaded.
[    4.365727] Freeing unused kernel memory: 1360K (ffffffff81d17000 - 
ffffffff81e6b000)
[    4.365728] Write protecting the kernel read-only data: 12288k
[    4.366747] Freeing unused kernel memory: 540K (ffff880001779000 - 
ffff880001800000)
[    4.367586] Freeing unused kernel memory: 504K (ffff880001b82000 - 
ffff880001c00000)
[    4.379761] systemd-udevd[150]: starting version 204
[    4.390051] ACPI: Video Device [VID1] (multi-head: yes  rom: yes  
post: no)
[    4.391208] acpi device:0b: registered as cooling_device8
[    4.391306] input: Video Bus as 
/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:0a/LNXVIDEO:01/input/input5
[    4.396024] wmi: Mapper loaded
[    4.398868] [drm] Initialized drm 1.1.0 20060810
[    4.400449] pps_core: LinuxPPS API ver. 1 registered
[    4.400451] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 
Rodolfo Giometti <giometti@linux.it>
[    4.401220] PTP clock support registered
[    4.401991] sdhci: Secure Digital Host Controller Interface driver
[    4.401993] sdhci: Copyright(c) Pierre Ossman
[    4.403436] sdhci-pci 0000:02:00.0: SDHCI controller found 
[1180:e823] (rev 5)
[    4.403643] mmc0: no vqmmc regulator found
[    4.403645] mmc0: no vmmc regulator found
[    4.403734] ahci 0000:00:1f.2: version 3.0
[    4.403744] mmc0: SDHCI controller on PCI [0000:02:00.0] using DMA
[    4.403872] ahci 0000:00:1f.2: irq 42 for MSI/MSI-X
[    4.403891] ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
[    4.404541] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    4.404543] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[    4.414405] AVX version of gcm_enc/dec engaged.
[    4.419298] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 
0x13 impl SATA mode
[    4.419305] ahci 0000:00:1f.2: flags: 64bit ncq ilck stag pm led clo 
pio slum part ems sxs apst
[    4.422272] ACPI Warning: \_SB_.PCI0.PEG_.VID_._DSM: Argument #4 type 
mismatch - Found [Buffer], ACPI requires [Package] (20131218/nsarguments-95)
[    4.422626] ACPI Warning: \_SB_.PCI0.PEG_.VID_._DSM: Argument #4 type 
mismatch - Found [Buffer], ACPI requires [Package] (20131218/nsarguments-95)
[    4.422933] pci 0000:01:00.0: optimus capabilities: enabled, status 
dynamic power, hda bios codec supported
[    4.422938] VGA switcheroo: detected Optimus DSM method 
\_SB_.PCI0.PEG_.VID_ handle
[    4.422956] checking generic (f1000000 130000) vs hw (e0000000 10000000)
[    4.422958] checking generic (f1000000 130000) vs hw (f0000000 2000000)
[    4.422959] fb: conflicting fb hw usage nouveaufb vs VESA VGA - 
removing generic driver
[    4.422974] Console: switching to colour dummy device 80x25
[    4.423791] nouveau  [  DEVICE][0000:01:00.0] BOOT0  : 0x0e73c0a2
[    4.423793] nouveau  [  DEVICE][0000:01:00.0] Chipset: GK107 (NVE7)
[    4.423795] nouveau  [  DEVICE][0000:01:00.0] Family : NVE0
[    4.424834] nouveau  [   VBIOS][0000:01:00.0] checking PRAMIN for 
image...
[    4.424848] nouveau  [   VBIOS][0000:01:00.0] ... signature not found
[    4.424849] nouveau  [   VBIOS][0000:01:00.0] checking PROM for image...
[    4.424880] nouveau  [   VBIOS][0000:01:00.0] ... signature not found
[    4.424881] nouveau  [   VBIOS][0000:01:00.0] checking ACPI for image...
[    4.467402] firewire_ohci 0000:02:00.3: added OHCI v1.10 device as 
card 0, 4 IR + 4 IT contexts, quirks 0x11
[    4.613307] nouveau  [   VBIOS][0000:01:00.0] ... appears to be valid
[    4.613311] nouveau  [   VBIOS][0000:01:00.0] using image from ACPI
[    4.613446] nouveau  [   VBIOS][0000:01:00.0] BIT signature found
[    4.613449] nouveau  [   VBIOS][0000:01:00.0] version 80.07.33.00.0f
[    4.614125] nouveau 0000:01:00.0: irq 43 for MSI/MSI-X
[    4.614144] nouveau  [     PMC][0000:01:00.0] MSI interrupts enabled
[    4.614185] scsi0 : ahci
[    4.614201] nouveau  [     PFB][0000:01:00.0] RAM type: DDR3
[    4.614203] nouveau  [     PFB][0000:01:00.0] RAM size: 2048 MiB
[    4.614204] nouveau  [     PFB][0000:01:00.0]    ZCOMP: 0 tags
[    4.614466] scsi1 : ahci
[    4.614722] scsi2 : ahci
[    4.615033] scsi3 : ahci
[    4.615311] scsi4 : ahci
[    4.615494] scsi5 : ahci
[    4.615569] ata1: SATA max UDMA/133 abar m2048@0xf5338000 port 
0xf5338100 irq 42
[    4.615573] ata2: SATA max UDMA/133 abar m2048@0xf5338000 port 
0xf5338180 irq 42
[    4.615575] ata3: DUMMY
[    4.615577] ata4: DUMMY
[    4.615581] ata5: SATA max UDMA/133 abar m2048@0xf5338000 port 
0xf5338300 irq 42
[    4.615583] ata6: DUMMY
[    4.615831] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) 
set to dynamic conservative mode
[    4.615856] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    4.618284] nouveau  [    VOLT][0000:01:00.0] GPU voltage: 875000uv
[    4.623263] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    4.645611] nouveau  [  PTHERM][0000:01:00.0] FAN control: none / 
external
[    4.645617] nouveau  [  PTHERM][0000:01:00.0] fan management: automatic
[    4.645628] nouveau  [  PTHERM][0000:01:00.0] internal sensor: yes
[    4.645660] nouveau  [     CLK][0000:01:00.0] 07: core 270-405 MHz 
memory 810 MHz
[    4.645690] nouveau  [     CLK][0000:01:00.0] 0f: core 270-850 MHz 
memory 1800 MHz
[    4.645834] nouveau  [     CLK][0000:01:00.0] --: core 405 MHz memory 
648 MHz
[    4.676803] [TTM] Zone  kernel: Available graphics memory: 8031988 kiB
[    4.676805] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[    4.676806] [TTM] Initializing pool allocator
[    4.676810] [TTM] Initializing DMA pool allocator
[    4.676822] nouveau  [     DRM] VRAM: 2048 MiB
[    4.676823] nouveau  [     DRM] GART: 1048576 MiB
[    4.676827] nouveau  [     DRM] TMDS table version 2.0
[    4.676828] nouveau  [     DRM] DCB version 4.0
[    4.676830] nouveau  [     DRM] DCB outp 00: 01800f23 00010034
[    4.676832] nouveau  [     DRM] DCB outp 01: 02811f00 00000000
[    4.676833] nouveau  [     DRM] DCB outp 02: 02822fa6 0f420010
[    4.676835] nouveau  [     DRM] DCB outp 03: 02822f62 00020010
[    4.676836] nouveau  [     DRM] DCB outp 04: 04833fb6 0f220010
[    4.676837] nouveau  [     DRM] DCB outp 05: 04833f72 00020010
[    4.676838] nouveau  [     DRM] DCB outp 06: 08844fc6 0f220010
[    4.676840] nouveau  [     DRM] DCB outp 07: 08844f82 00020010
[    4.676841] nouveau  [     DRM] DCB conn 00: 00000040
[    4.676843] nouveau  [     DRM] DCB conn 01: 00000100
[    4.676844] nouveau  [     DRM] DCB conn 02: 00010246
[    4.676845] nouveau  [     DRM] DCB conn 03: 00020346
[    4.676847] nouveau  [     DRM] DCB conn 04: 01000446
[    4.678129] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    4.678130] [drm] Driver supports precise vblank timestamp query.
[    4.678132] nouveau  [     DRM] ACPI backlight interface available, 
not registering our own
[    4.688918] nouveau  [     DRM] MM: using COPY for buffer copies
[    4.755520] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[    4.755522] usb 1-1: New USB device strings: Mfr=0, Product=0, 
SerialNumber=0
[    4.755803] hub 1-1:1.0: USB hub found
[    4.756002] hub 1-1:1.0: 6 ports detected
[    4.821986] e1000e 0000:00:19.0 eth0: registered PHC clock
[    4.821989] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 
3c:97:0e:bc:f2:1d
[    4.821991] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network 
Connection
[    4.822102] e1000e 0000:00:19.0 eth0: MAC: 10, PHY: 11, PBA No: 
1000FF-0FF
[    4.923158] usb 3-2: new full-speed USB device number 2 using xhci_hcd
[    4.935125] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    4.935996] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) 
succeeded
[    4.936002] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE 
LOCK) filtered out
[    4.936841] ata1.00: ATA-8: HGST HTS725050A7E630, GH2ZB550, max UDMA/133
[    4.936845] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 
31/32), AA
[    4.937775] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) 
succeeded
[    4.937779] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE 
LOCK) filtered out
[    4.938609] ata1.00: configured for UDMA/133
[    4.938823] scsi 0:0:0:0: Direct-Access     ATA      HGST HTS725050A7 
GH2Z PQ: 0 ANSI: 5
[    4.938965] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 
GB/465 GiB)
[    4.938968] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    4.938971] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    4.939112] sd 0:0:0:0: [sda] Write Protect is off
[    4.939115] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.939258] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    4.967217] firewire_core 0000:02:00.3: created device fw0: GUID 
3c970effbcf21dff, S400
[    4.978447] nouveau  [     DRM] allocated 1920x1080 fb: 0x80000, bo 
ffff8800c58f8c00
[    4.978633] fbcon: nouveaufb (fb0) is primary device
[    4.982639]  sda: sda1 sda2 < sda5 >
[    4.983485] sd 0:0:0:0: [sda] Attached SCSI disk
[    5.051710] usb 3-2: New USB device found, idVendor=0e8f, idProduct=0016
[    5.051711] usb 3-2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[    5.051713] usb 3-2: Product: USB Hub
[    5.051714] usb 3-2: Manufacturer: GASIA Semi.
[    5.051820] usb 3-2: ep 0x81 - rounding interval to 1024 microframes, 
ep desc says 2040 microframes
[    5.052015] hub 3-2:1.0: USB hub found
[    5.052115] hub 3-2:1.0: 4 ports detected
[    5.163080] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    5.255039] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    5.264367] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[    5.265152] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[    5.265420] ata2.00: ATAPI: PLDS DVD-RW DS8A8SH, KU54, max UDMA/100
[    5.272710] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[    5.273794] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[    5.274068] ata2.00: configured for UDMA/100
[    5.286971] scsi 1:0:0:0: CD-ROM            PLDS     DVD-RW DS8A8SH   
KU54 PQ: 0 ANSI: 5
[    5.295404] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[    5.295406] usb 2-1: New USB device strings: Mfr=0, Product=0, 
SerialNumber=0
[    5.295710] hub 2-1:1.0: USB hub found
[    5.295781] hub 2-1:1.0: 8 ports detected
[    5.301106] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw 
xa/form2 cdda tray
[    5.301107] cdrom: Uniform CD-ROM driver Revision: 3.20
[    5.301234] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    5.301300] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    5.367055] usb 1-1.1: new full-speed USB device number 3 using ehci-pci
[    5.465523] usb 1-1.1: New USB device found, idVendor=17ef, 
idProduct=1003
[    5.465524] usb 1-1.1: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[    5.465526] usb 1-1.1: Product: Integrated Smart Card Reader
[    5.465528] usb 1-1.1: Manufacturer: Lenovo
[    5.535001] usb 1-1.4: new full-speed USB device number 4 using ehci-pci
[    5.618918] ata5: SATA link down (SStatus 0 SControl 300)
[    5.630849] usb 1-1.4: New USB device found, idVendor=0a5c, 
idProduct=21e6
[    5.630851] usb 1-1.4: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[    5.630852] usb 1-1.4: Product: BCM20702A0
[    5.630853] usb 1-1.4: Manufacturer: Broadcom Corp
[    5.630855] usb 1-1.4: SerialNumber: F82FA8E7383F
[    5.703076] usb 1-1.6: new high-speed USB device number 5 using ehci-pci
[    5.806301] Console: switching to colour frame buffer device 240x67
[    5.806665] usb 1-1.6: New USB device found, idVendor=5986, 
idProduct=02d2
[    5.806666] usb 1-1.6: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[    5.806667] usb 1-1.6: Product: Integrated Camera
[    5.806669] usb 1-1.6: Manufacturer: Ricoh Company Ltd.
[    5.808600] nouveau 0000:01:00.0: fb0: nouveaufb frame buffer device
[    5.808602] nouveau 0000:01:00.0: registered panic notifier
[    5.808605] [drm] Initialized nouveau 1.1.1 20120801 for 0000:01:00.0 
on minor 0
[    5.894867] usb 3-2.2: new low-speed USB device number 3 using xhci_hcd
[    6.002739] usb 3-2.2: New USB device found, idVendor=04f3, 
idProduct=0216
[    6.002743] usb 3-2.2: New USB device strings: Mfr=0, Product=2, 
SerialNumber=0
[    6.002745] usb 3-2.2: Product: USB Mouse
[    6.002901] usb 3-2.2: ep 0x81 - rounding interval to 64 microframes, 
ep desc says 80 microframes
[    6.005218] hidraw: raw HID events driver (C) Jiri Kosina
[    6.008897] usbcore: registered new interface driver usbhid
[    6.008898] usbhid: USB HID core driver
[    6.010035] input: USB Mouse as 
/devices/pci0000:00/0000:00:14.0/usb3/3-2/3-2.2/3-2.2:1.0/0003:04F3:0216.0001/input/input6
[    6.010108] hid-generic 0003:04F3:0216.0001: input,hidraw0: USB HID 
v1.11 Mouse [USB Mouse] on usb-0000:00:14.0-2.2/input0
[    6.094822] usb 3-2.3: new low-speed USB device number 4 using xhci_hcd
[    6.209699] usb 3-2.3: New USB device found, idVendor=046a, 
idProduct=0023
[    6.209702] usb 3-2.3: New USB device strings: Mfr=0, Product=0, 
SerialNumber=0
[    6.209845] usb 3-2.3: ep 0x81 - rounding interval to 64 microframes, 
ep desc says 80 microframes
[    6.209851] usb 3-2.3: ep 0x82 - rounding interval to 64 microframes, 
ep desc says 80 microframes
[    6.227203] input: HID 046a:0023 as 
/devices/pci0000:00/0000:00:14.0/usb3/3-2/3-2.3/3-2.3:1.0/0003:046A:0023.0002/input/input7
[    6.227395] cherry 0003:046A:0023.0002: input,hidraw1: USB HID v1.11 
Keyboard [HID 046a:0023] on usb-0000:00:14.0-2.3/input0
[    6.230126] input: HID 046a:0023 as 
/devices/pci0000:00/0000:00:14.0/usb3/3-2/3-2.3/3-2.3:1.1/0003:046A:0023.0003/input/input8
[    6.230278] cherry 0003:046A:0023.0003: input,hidraw2: USB HID v1.11 
Device [HID 046a:0023] on usb-0000:00:14.0-2.3/input1
[    6.294839] usb 2-1.7: new low-speed USB device number 3 using ehci-pci
[    6.389556] usb 2-1.7: New USB device found, idVendor=0765, 
idProduct=5010
[    6.389561] usb 2-1.7: New USB device strings: Mfr=0, Product=0, 
SerialNumber=0
[    6.392715] hid-generic 0003:0765:5010.0004: hiddev0,hidraw3: USB HID 
v1.11 Device [HID 0765:5010] on usb-0000:00:1d.0-1.7/input0
[    9.356123] random: nonblocking pool is initialized
[   12.083821] bio: create slab <bio-1> at 1
[   12.301025] bio: create slab <bio-0> at 0
[   12.693084] EXT4-fs (dm-1): INFO: recovery required on readonly 
filesystem
[   12.693087] EXT4-fs (dm-1): write access will be enabled during recovery
[   13.576173] EXT4-fs (dm-1): orphan cleanup on readonly fs
[   13.675200] EXT4-fs (dm-1): 23 orphan inodes deleted
[   13.675204] EXT4-fs (dm-1): recovery complete
[   13.887844] EXT4-fs (dm-1): mounted filesystem with ordered data 
mode. Opts: (null)
[   31.795095] Adding 16400380k swap on /dev/mapper/ubuntu-swap_1.  
Priority:-1 extents:1 across:16400380k FS
[   32.038165] systemd-udevd[471]: starting version 204
[   32.517259] microcode: CPU0 sig=0x306a9, pf=0x10, revision=0x19
[   32.548900] ACPI Warning: SystemIO range 
0x0000000000000428-0x000000000000042f conflicts with OpRegion 
0x0000000000000400-0x000000000000047f (\_SB_.PCI0.LPC_.PMIO) 
(20131218/utaddress-258)
[   32.548906] ACPI: If an ACPI driver is available for this device, you 
should use it instead of the native driver
[   32.548913] ACPI Warning: SystemIO range 
0x0000000000000530-0x000000000000053f conflicts with OpRegion 
0x0000000000000500-0x000000000000057f (\_SB_.PCI0.LPC_.LPIO) 
(20131218/utaddress-258)
[   32.548916] ACPI: If an ACPI driver is available for this device, you 
should use it instead of the native driver
[   32.548917] ACPI Warning: SystemIO range 
0x0000000000000500-0x000000000000052f conflicts with OpRegion 
0x0000000000000500-0x000000000000057f (\_SB_.PCI0.LPC_.LPIO) 
(20131218/utaddress-258)
[   32.548919] ACPI: If an ACPI driver is available for this device, you 
should use it instead of the native driver
[   32.548920] lpc_ich: Resource conflict(s) found affecting gpio_ich
[   32.585885] microcode: CPU1 sig=0x306a9, pf=0x10, revision=0x19
[   32.585903] microcode: CPU2 sig=0x306a9, pf=0x10, revision=0x19
[   32.585941] microcode: CPU3 sig=0x306a9, pf=0x10, revision=0x19
[   32.585954] microcode: CPU4 sig=0x306a9, pf=0x10, revision=0x19
[   32.585964] microcode: CPU5 sig=0x306a9, pf=0x10, revision=0x19
[   32.585973] microcode: CPU6 sig=0x306a9, pf=0x10, revision=0x19
[   32.585984] microcode: CPU7 sig=0x306a9, pf=0x10, revision=0x19
[   32.586038] microcode: Microcode Update Driver: v2.00 
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   32.590787] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   32.752580] cfg80211: Calling CRDA to update world regulatory domain
[   32.832307] mei_me 0000:00:16.0: irq 45 for MSI/MSI-X
[   33.022293] EXT4-fs (dm-1): re-mounted. Opts: errors=remount-ro
[   33.023162] audit: type=1400 audit(1395499113.165:2): 
apparmor="STATUS" operation="profile_load" name="/sbin/dhclient" pid=567 
comm="apparmor_parser"
[   33.023167] audit: type=1400 audit(1395499113.165:3): 
apparmor="STATUS" operation="profile_load" 
name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=567 
comm="apparmor_parser"
[   33.023179] audit: type=1400 audit(1395499113.165:4): 
apparmor="STATUS" operation="profile_load" 
name="/usr/lib/connman/scripts/dhclient-script" pid=567 
comm="apparmor_parser"
[   33.023490] audit: type=1400 audit(1395499113.165:5): 
apparmor="STATUS" operation="profile_replace" 
name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=567 
comm="apparmor_parser"
[   33.023493] audit: type=1400 audit(1395499113.165:6): 
apparmor="STATUS" operation="profile_replace" 
name="/usr/lib/connman/scripts/dhclient-script" pid=567 
comm="apparmor_parser"
[   33.023613] audit: type=1400 audit(1395499113.165:7): 
apparmor="STATUS" operation="profile_replace" 
name="/usr/lib/connman/scripts/dhclient-script" pid=567 
comm="apparmor_parser"
[   33.062214] Non-volatile memory driver v1.3
[   33.093626] Intel(R) Wireless WiFi driver for Linux, in-tree:
[   33.093629] Copyright(c) 2003- 2014 Intel Corporation
[   33.093814] iwlwifi 0000:03:00.0: can't disable ASPM; OS doesn't have 
ASPM control
[   33.094009] iwlwifi 0000:03:00.0: irq 46 for MSI/MSI-X
[   33.113803] thinkpad_acpi: ThinkPad ACPI Extras v0.25
[   33.113806] thinkpad_acpi: http://ibm-acpi.sf.net/
[   33.113808] thinkpad_acpi: ThinkPad BIOS G5ET96WW (2.56 ), EC unknown
[   33.113810] thinkpad_acpi: Lenovo ThinkPad W530, model 24491D1
[   33.114384] thinkpad_acpi: Unsupported brightness interface, please 
contact ibm-acpi-devel@lists.sourceforge.net
[   33.114505] thinkpad_acpi: radio switch found; radios are enabled
[   33.114518] thinkpad_acpi: This ThinkPad has standard ACPI backlight 
brightness control, supported by the ACPI video driver
[   33.114519] thinkpad_acpi: Disabling thinkpad-acpi brightness events 
by default...
[   33.115809] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio 
is unblocked
[   33.116274] thinkpad_acpi: Console audio control enabled, mode: 
monitor (read only)
[   33.117664] input: ThinkPad Extra Buttons as 
/devices/platform/thinkpad_acpi/input/input10
[   33.141846] iwlwifi 0000:03:00.0: loaded firmware version 18.168.6.1 
op_mode iwldvm
[   33.183919] snd_hda_intel 0000:00:1b.0: irq 47 for MSI/MSI-X
[   33.184008] hda_intel: Disabling MSI
[   33.184013] hda-intel 0000:01:00.1: Handle VGA-switcheroo audio client
[   33.184071] hda-intel 0000:01:00.1: Disabling 64bit DMA
[   33.187238] hda-intel 0000:01:00.1: Enable delay in RIRB handling
[   33.212917] SKU: Nid=0x1d sku_cfg=0x40138205
[   33.212919] SKU: port_connectivity=0x1
[   33.212920] SKU: enable_pcbeep=0x1
[   33.212921] SKU: check_sum=0x00000003
[   33.212922] SKU: customization=0x00000082
[   33.212923] SKU: external_amp=0x0
[   33.212923] SKU: platform_type=0x1
[   33.212924] SKU: swap=0x0
[   33.212925] SKU: override=0x1
[   33.213245] autoconfig: line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:speaker
[   33.213246]    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   33.213247]    hp_outs=2 (0x15/0x1b/0x0/0x0/0x0)
[   33.213248]    mono: mono_out=0x0
[   33.213248]    inputs:
[   33.213250]      Mic=0x18
[   33.213251]      Dock Mic=0x19
[   33.213252]      Internal Mic=0x12
[   33.213253] realtek: No valid SSID, checking pincfg 0x40138205 for 
NID 0x1d
[   33.213254] realtek: Enabling init ASM_ID=0x8205 CODEC_ID=10ec0269
[   33.220719] input: HDA Intel PCH Dock Headphone as 
/devices/pci0000:00/0000:00:1b.0/sound/card0/input14
[   33.220809] input: HDA Intel PCH Headphone as 
/devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[   33.220869] input: HDA Intel PCH Dock Mic as 
/devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[   33.220924] input: HDA Intel PCH Mic as 
/devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[   33.327521] lp: driver loaded but no devices found
[   33.491211] intel_rapl: domain uncore energy ctr 0:0 not working, skip
[   33.504923] psmouse serio1: synaptics: Touchpad model: 1, fw: 7.2, 
id: 0x1c0b1, caps: 0xd047b3/0xb40000/0xa0000, board id: 71, fw id: 920262
[   33.504934] psmouse serio1: synaptics: serio: Synaptics pass-through 
port at isa0060/serio1/input0
[   33.540767] input: SynPS/2 Synaptics TouchPad as 
/devices/platform/i8042/serio1/input/input9
[   33.572372] Bluetooth: Core ver 2.18
[   33.572398] NET: Registered protocol family 31
[   33.572399] Bluetooth: HCI device and connection manager initialized
[   33.572406] Bluetooth: HCI socket layer initialized
[   33.572409] Bluetooth: L2CAP socket layer initialized
[   33.572419] Bluetooth: SCO socket layer initialized
[   33.583266] Linux video capture interface: v2.00
[   33.700084] cfg80211: World regulatory domain updated:
[   33.700087] cfg80211:  DFS Master region: unset
[   33.700088] cfg80211:   (start_freq - end_freq @ bandwidth), 
(max_antenna_gain, max_eirp)
[   33.700090] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[   33.700091] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[   33.700091] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 
mBi, 2000 mBm)
[   33.700092] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[   33.700093] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[   33.730125] input: HDA NVidia HDMI/DP,pcm=8 as 
/devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input18
[   33.730221] input: HDA NVidia HDMI/DP,pcm=7 as 
/devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input17
[   33.730284] input: HDA NVidia HDMI/DP,pcm=3 as 
/devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input16
[   33.837524] usbcore: registered new interface driver btusb
[   33.841530] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG disabled
[   33.841533] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS enabled
[   33.841535] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING enabled
[   33.841536] iwlwifi 0000:03:00.0: Detected Intel(R) Centrino(R) 
Advanced-N 6205 AGN, REV=0xB0
[   33.841717] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[   34.034991] uvcvideo: Found UVC 1.00 device Integrated Camera (5986:02d2)
[   34.037366] input: Integrated Camera as 
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.0/input/input19
[   34.037451] usbcore: registered new interface driver uvcvideo
[   34.037452] USB Video Class driver (1.1.1)
[   34.192779] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[   36.173422] EXT4-fs (sda1): mounting ext2 file system using the ext4 
subsystem
[   36.176208] EXT4-fs (sda1): mounted filesystem without journal. Opts: 
(null)
[   36.281604] init: failsafe main process (1012) killed by TERM signal
[   36.350439] psmouse serio2: alps: Unknown ALPS touchpad: E7=10 00 64, 
EC=10 00 64
[   36.530268] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   36.530271] Bluetooth: BNEP filters: protocol multicast
[   36.530278] Bluetooth: BNEP socket layer initialized
[   36.564031] audit: type=1400 audit(1395499116.705:8): 
apparmor="STATUS" operation="profile_load" 
name="/usr/lib/cups/backend/cups-pdf" pid=1117 comm="apparmor_parser"
[   36.564037] audit: type=1400 audit(1395499116.705:9): 
apparmor="STATUS" operation="profile_load" name="/usr/sbin/cupsd" 
pid=1117 comm="apparmor_parser"
[   36.564463] audit: type=1400 audit(1395499116.705:10): 
apparmor="STATUS" operation="profile_replace" name="/usr/sbin/cupsd" 
pid=1117 comm="apparmor_parser"
[   36.621487] Bluetooth: RFCOMM TTY layer initialized
[   36.621496] Bluetooth: RFCOMM socket layer initialized
[   36.621501] Bluetooth: RFCOMM ver 1.11
[   36.706891] audit: type=1400 audit(1395499116.849:11): 
apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" 
pid=1173 comm="apparmor_parser"
[   36.919145] init: cups main process (1131) killed by HUP signal
[   36.919156] init: cups main process ended, respawning
[   37.611769] psmouse serio2: trackpoint: IBM TrackPoint firmware: 
0x0e, buttons: 3/3
[   37.689808] init: nvidia-prime main process (1255) terminated with 
status 127
[   37.813917] input: TPPS/2 IBM TrackPoint as 
/devices/platform/i8042/serio1/serio2/input/input15
[   37.877743] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[   37.980767] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[   37.981006] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   37.983116] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[   37.990428] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[   38.256965] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[   38.263827] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[   38.347016] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   40.949875] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   41.249700] ip_tables: (C) 2000-2006 Netfilter Core Team
[   41.388224] Ebtables v2.0 registered
[   41.504833] Bridge firewalling registered
[   41.813432] vboxdrv: module verification failed: signature and/or  
required key missing - tainting kernel
[   41.817304] vboxdrv: Found 8 processor cores.
[   41.817750] vboxdrv: fAsync=0 offMin=0x1c8 offMax=0x69fe
[   41.817830] vboxdrv: TSC mode is 'synchronous', kernel timer mode is 
'normal'.
[   41.817833] vboxdrv: Successfully loaded version 4.3.6_Ubuntu 
(interface 0x001a0007).
[   41.880693] wlan0: authenticate with 24:65:11:53:8d:21
[   41.888688] wlan0: send auth to 24:65:11:53:8d:21 (try 1/3)
[   41.908884] wlan0: authenticated
[   41.911431] wlan0: associate with 24:65:11:53:8d:21 (try 1/3)
[   41.926172] wlan0: RX AssocResp from 24:65:11:53:8d:21 (capab=0x431 
status=0 aid=3)
[   41.945673] wlan0: associated
[   41.945711] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   41.945793] cfg80211: Calling CRDA for country: DE
[   41.948026] cfg80211: Regulatory domain changed to country: DE
[   41.948029] cfg80211:  DFS Master region: unset
[   41.948031] cfg80211:   (start_freq - end_freq @ bandwidth), 
(max_antenna_gain, max_eirp)
[   41.948033] cfg80211:   (2400000 KHz - 2483500 KHz @ 40000 KHz), 
(N/A, 2000 mBm)
[   41.948034] cfg80211:   (5150000 KHz - 5250000 KHz @ 40000 KHz), 
(N/A, 2000 mBm)
[   41.948035] cfg80211:   (5250000 KHz - 5350000 KHz @ 40000 KHz), 
(N/A, 2000 mBm)
[   41.948037] cfg80211:   (5470000 KHz - 5725000 KHz @ 40000 KHz), 
(N/A, 2698 mBm)
[   41.948038] cfg80211:   (57240000 KHz - 65880000 KHz @ 2160000 KHz), 
(N/A, 4000 mBm)
[   42.074440] vboxpci: IOMMU not found (not registered)
[   42.815333] FIREWALL: IN=wlan0 OUT= MAC= SRC=192.168.178.31 
DST=224.0.0.251 LEN=297 TOS=0x00 PREC=0x00 TTL=255 ID=61164 DF PROTO=UDP 
SPT=5353 DPT=5353 LEN=277
[   42.838538] FIREWALL: IN=wlan0 OUT= MAC= SRC=192.168.178.31 
DST=224.0.0.251 LEN=194 TOS=0x00 PREC=0x00 TTL=255 ID=61165 DF PROTO=UDP 
SPT=5353 DPT=5353 LEN=174
[   43.066160] FIREWALL: IN=wlan0 OUT= MAC= SRC=192.168.178.31 
DST=224.0.0.251 LEN=297 TOS=0x00 PREC=0x00 TTL=255 ID=61166 DF PROTO=UDP 
SPT=5353 DPT=5353 LEN=277
[   43.316732] FIREWALL: IN=wlan0 OUT= MAC= SRC=192.168.178.31 
DST=224.0.0.251 LEN=297 TOS=0x00 PREC=0x00 TTL=255 ID=61167 DF PROTO=UDP 
SPT=5353 DPT=5353 LEN=277
[   43.517380] FIREWALL: IN=wlan0 OUT= MAC= SRC=192.168.178.31 
DST=224.0.0.251 LEN=273 TOS=0x00 PREC=0x00 TTL=255 ID=61168 DF PROTO=UDP 
SPT=5353 DPT=5353 LEN=253
[   46.602925] init: plymouth-stop pre-start process (3072) terminated 
with status 1
[   66.621895] audit_printk_skb: 168 callbacks suppressed
[   66.621898] audit: type=1400 audit(1395499146.773:68): 
apparmor="STATUS" operation="profile_replace" 
name="/usr/lib/cups/backend/cups-pdf" pid=4199 comm="apparmor_parser"
[   66.621903] audit: type=1400 audit(1395499146.773:69): 
apparmor="STATUS" operation="profile_replace" name="/usr/sbin/cupsd" 
pid=4199 comm="apparmor_parser"
[   66.622218] audit: type=1400 audit(1395499146.773:70): 
apparmor="STATUS" operation="profile_replace" name="/usr/sbin/cupsd" 
pid=4199 comm="apparmor_parser"
[   66.840188] FIREWALL: IN=wlan0 OUT= MAC= SRC=192.168.178.31 
DST=224.0.0.251 LEN=73 TOS=0x00 PREC=0x00 TTL=255 ID=61185 DF PROTO=UDP 
SPT=5353 DPT=5353 LEN=53
[   67.162347] savtray[4001]: segfault at 0 ip 00000000f7496a58 sp 
00000000ff969a3c error 4 in libc-2.19.so[f735c000+1a9000]
[   97.842279] FIREWALL: IN=wlan0 OUT= MAC= SRC=192.168.178.31 
DST=224.0.0.251 LEN=73 TOS=0x00 PREC=0x00 TTL=255 ID=61190 DF PROTO=UDP 
SPT=5353 DPT=5353 LEN=53
[  105.966588] FIREWALL: IN=wlan0 OUT= 
MAC=ff:ff:ff:ff:ff:ff:c4:17:fe:b2:ff:63:08:00 SRC=192.168.178.29 
DST=255.255.255.255 LEN=230 TOS=0x00 PREC=0x00 TTL=128 ID=2890 PROTO=UDP 
SPT=17500 DPT=17500 LEN=210
[  129.838401] FIREWALL: IN=wlan0 OUT= MAC= SRC=192.168.178.31 
DST=224.0.0.251 LEN=73 TOS=0x00 PREC=0x00 TTL=255 ID=61191 DF PROTO=UDP 
SPT=5353 DPT=5353 LEN=53
[  166.057050] FIREWALL: IN=wlan0 OUT= 
MAC=ff:ff:ff:ff:ff:ff:c4:17:fe:b2:ff:63:08:00 SRC=192.168.178.29 
DST=255.255.255.255 LEN=230 TOS=0x00 PREC=0x00 TTL=128 ID=3012 PROTO=UDP 
SPT=17500 DPT=17500 LEN=210
[  166.059683] FIREWALL: IN=wlan0 OUT= 
MAC=ff:ff:ff:ff:ff:ff:c4:17:fe:b2:ff:63:08:00 SRC=192.168.178.29 
DST=255.255.255.255 LEN=230 TOS=0x00 PREC=0x00 TTL=128 ID=3013 PROTO=UDP 
SPT=17500 DPT=17500 LEN=210
[  193.836681] FIREWALL: IN=wlan0 OUT= MAC= SRC=192.168.178.31 
DST=224.0.0.251 LEN=73 TOS=0x00 PREC=0x00 TTL=255 ID=61192 DF PROTO=UDP 
SPT=5353 DPT=5353 LEN=53
[  226.045142] FIREWALL: IN=wlan0 OUT= 
MAC=ff:ff:ff:ff:ff:ff:c4:17:fe:b2:ff:63:08:00 SRC=192.168.178.29 
DST=255.255.255.255 LEN=230 TOS=0x00 PREC=0x00 TTL=128 ID=3082 PROTO=UDP 
SPT=17500 DPT=17500 LEN=210
[  226.047798] FIREWALL: IN=wlan0 OUT= 
MAC=ff:ff:ff:ff:ff:ff:c4:17:fe:b2:ff:63:08:00 SRC=192.168.178.29 
DST=255.255.255.255 LEN=230 TOS=0x00 PREC=0x00 TTL=128 ID=3083 PROTO=UDP 
SPT=17500 DPT=17500 LEN=210
ggrundke@Miraculix:~$





system.log
Mar 22 09:27:07 Miraculix NetworkManager[1149]: <info> sleep requested 
(sleeping: no  enabled: yes)
Mar 22 09:27:07 Miraculix NetworkManager[1149]: <info> sleeping or 
disabling...
Mar 22 09:27:07 Miraculix NetworkManager[1149]: <info> (eth0): device 
state change: unavailable -> unmanaged (reason 'sleeping') [20 10 37]
Mar 22 09:27:07 Miraculix NetworkManager[1149]: <info> (eth0): cleaning 
up...
Mar 22 09:27:07 Miraculix NetworkManager[1149]: <info> (eth0): taking 
down device.
Mar 22 09:27:07 Miraculix NetworkManager[1149]: <info> NetworkManager 
state is now ASLEEP
Mar 22 09:27:07 Miraculix NetworkManager[1149]: <info> (wlan0): device 
state change: activated -> unmanaged (reason 'sleeping') [100 10 37]
Mar 22 09:27:07 Miraculix NetworkManager[1149]: <info> (wlan0): 
deactivating device (reason 'sleeping') [37]
Mar 22 09:27:07 Miraculix whoopsie[1826]: offline
Mar 22 09:27:07 Miraculix NetworkManager[1149]: <info> (wlan0): canceled 
DHCP transaction, DHCP client pid 2876
Mar 22 09:27:07 Miraculix kernel: [  675.195552] wlan0: deauthenticating 
from 24:65:11:53:8d:21 by local choice (reason=3)
Mar 22 09:27:08 Miraculix wpa_supplicant[1418]: wlan0: 
CTRL-EVENT-DISCONNECTED bssid=24:65:11:53:8d:21 reason=3 locally_generated=1
Mar 22 09:27:08 Miraculix acvpnagent[2465]: message repeated 22 times: [ 
Function: tableCallbackHandler File: RouteMgr.cpp Line: 1723 Invoked 
Function: recv Return Code: 11 (0x0000000B) Description: unknown ]
Mar 22 09:27:08 Miraculix acvpnagent[2465]: A network interface has gone 
down.
Mar 22 09:27:08 Miraculix acvpnagent[2465]: Function: logInterfaces 
File: RouteMgr.cpp Line: 2105 Invoked Function: logInterfaces Return 
Code: 0 (0x00000000) Description: IP Address Interface List:
Mar 22 09:27:08 Miraculix NetworkManager[1149]: <warn> DNS: plugin 
dnsmasq update failed
Mar 22 09:27:08 Miraculix NetworkManager[1149]: <info> Removing DNS 
information from /sbin/resolvconf
Mar 22 09:27:08 Miraculix dnsmasq[2966]: setting upstream servers from DBus
Mar 22 09:27:08 Miraculix avahi-daemon[1019]: Withdrawing address record 
for 192.168.178.31 on wlan0.
Mar 22 09:27:08 Miraculix avahi-daemon[1019]: Leaving mDNS multicast 
group on interface wlan0.IPv4 with address 192.168.178.31.
Mar 22 09:27:08 Miraculix avahi-daemon[1019]: Interface wlan0.IPv4 no 
longer relevant for mDNS.
Mar 22 09:27:08 Miraculix kernel: [  675.228109] cfg80211: Calling CRDA 
to update world regulatory domain
Mar 22 09:27:08 Miraculix kernel: [  675.230241] cfg80211: World 
regulatory domain updated:
Mar 22 09:27:08 Miraculix kernel: [  675.230245] cfg80211:  DFS Master 
region: unset
Mar 22 09:27:08 Miraculix kernel: [  675.230246] cfg80211: (start_freq - 
end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Mar 22 09:27:08 Miraculix kernel: [  675.230248] cfg80211: (2402000 KHz 
- 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar 22 09:27:08 Miraculix kernel: [  675.230249] cfg80211: (2457000 KHz 
- 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar 22 09:27:08 Miraculix kernel: [  675.230250] cfg80211: (2474000 KHz 
- 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Mar 22 09:27:08 Miraculix kernel: [  675.230251] cfg80211: (5170000 KHz 
- 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar 22 09:27:08 Miraculix kernel: [  675.230252] cfg80211: (5735000 KHz 
- 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar 22 09:27:08 Miraculix NetworkManager[1149]: <info> (wlan0): cleaning 
up...
Mar 22 09:27:08 Miraculix NetworkManager[1149]: <info> (wlan0): taking 
down device.
Mar 22 09:27:08 Miraculix avahi-daemon[1019]: Interface wlan0.IPv6 no 
longer relevant for mDNS.
Mar 22 09:27:08 Miraculix avahi-daemon[1019]: Leaving mDNS multicast 
group on interface wlan0.IPv6 with address fe80::a64e:31ff:fe3e:c1ec.
Mar 22 09:27:08 Miraculix avahi-daemon[1019]: Withdrawing address record 
for fe80::a64e:31ff:fe3e:c1ec on wlan0.
Mar 22 09:27:08 Miraculix acvpnagent[2465]: Function: 
tableCallbackHandler File: RouteMgr.cpp Line: 1723 Invoked Function: 
recv Return Code: 11 (0x0000000B) Description: unknown
Mar 22 09:27:08 Miraculix dbus[913]: [system] Activating service 
name='org.freedesktop.nm_dispatcher' (using servicehelper)
Mar 22 09:27:08 Miraculix dbus[913]: [system] Activating service 
name='org.freedesktop.systemd1' (using servicehelper)
Mar 22 09:27:08 Miraculix dbus[913]: [system] Successfully activated 
service 'org.freedesktop.nm_dispatcher'
Mar 22 09:27:08 Miraculix dbus[913]: [system] Successfully activated 
service 'org.freedesktop.systemd1'
Mar 22 09:27:09 Miraculix kernel: [  676.176049] PM: Syncing filesystems 
... done.
Mar 22 09:27:09 Miraculix kernel: [  676.411979] PM: Preparing system 
for mem sleep
Mar 22 15:37:09 Miraculix kernel: [  676.817329] Freezing user space 
processes ... (elapsed 0.001 seconds) done.
Mar 22 15:37:09 Miraculix kernel: [  676.819012] Freezing remaining 
freezable tasks ... (elapsed 0.001 seconds) done.
Mar 22 15:37:09 Miraculix kernel: [  676.820133] PM: Entering mem sleep
Mar 22 15:37:09 Miraculix kernel: [  676.820173] Suspending console(s) 
(use no_console_suspend to debug)
Mar 22 15:37:09 Miraculix kernel: [  676.950370] sd 0:0:0:0: [sda] 
Synchronizing SCSI cache
Mar 22 15:37:09 Miraculix kernel: [  676.950547] sd 0:0:0:0: [sda] 
Stopping disk
Mar 22 15:37:09 Miraculix kernel: [  677.184448] nouveau  [ DRM] 
suspending display...
Mar 22 15:37:09 Miraculix kernel: [  677.184599] nouveau  [ DRM] 
unpinning framebuffer(s)...
Mar 22 15:37:09 Miraculix kernel: [  677.184830] nouveau  [ DRM] 
evicting buffers...
Mar 22 15:37:09 Miraculix kernel: [  678.380669] nouveau  [ DRM] waiting 
for kernel channels to go idle...
Mar 22 15:37:09 Miraculix kernel: [  678.380691] nouveau  [ DRM] 
suspending client object trees...
Mar 22 15:37:09 Miraculix kernel: [  678.393687] nouveau  [ DRM] 
suspending kernel object tree...
Mar 22 15:37:09 Miraculix kernel: [  680.767269] PM: suspend of devices 
complete after 3948.208 msecs
Mar 22 15:37:09 Miraculix kernel: [  680.767475] PM: late suspend of 
devices complete after 0.203 msecs
Mar 22 15:37:09 Miraculix kernel: [  680.783170] ehci-pci 0000:00:1d.0: 
System wakeup enabled by ACPI
Mar 22 15:37:09 Miraculix kernel: [  680.799259] ehci-pci 0000:00:1a.0: 
System wakeup enabled by ACPI
Mar 22 15:37:09 Miraculix kernel: [  680.815064] e1000e 0000:00:19.0: 
System wakeup enabled by ACPI
Mar 22 15:37:09 Miraculix kernel: [  680.847053] xhci_hcd 0000:00:14.0: 
System wakeup enabled by ACPI
Mar 22 15:37:09 Miraculix kernel: [  680.863071] PM: noirq suspend of 
devices complete after 95.625 msecs
Mar 22 15:37:09 Miraculix kernel: [  680.863256] ACPI: Preparing to 
enter system sleep state S3
Mar 22 15:37:09 Miraculix kernel: [  680.865555] PM: Saving platform NVS 
memory
Mar 22 15:37:09 Miraculix kernel: [  680.866042] Disabling non-boot CPUs ...
Mar 22 15:37:09 Miraculix kernel: [  680.867359] kvm: disabling 
virtualization on CPU1
Mar 22 15:37:09 Miraculix kernel: [  680.867606] smpboot: CPU 1 is now 
offline
Mar 22 15:37:09 Miraculix kernel: [  680.869114] kvm: disabling 
virtualization on CPU2
Mar 22 15:37:09 Miraculix kernel: [  680.970986] smpboot: CPU 2 is now 
offline
Mar 22 15:37:09 Miraculix kernel: [  680.971480] Broke affinity for irq 41
Mar 22 15:37:09 Miraculix kernel: [  680.971481] Broke affinity for irq 46
Mar 22 15:37:09 Miraculix kernel: [  680.972481] kvm: disabling 
virtualization on CPU3
Mar 22 15:37:09 Miraculix kernel: [  681.074955] smpboot: CPU 3 is now 
offline
Mar 22 15:37:09 Miraculix kernel: [  681.483927] kvm: disabling 
virtualization on CPU4
Mar 22 15:37:09 Miraculix kernel: [  681.586790] smpboot: CPU 4 is now 
offline
Mar 22 15:37:09 Miraculix kernel: [  681.588246] kvm: disabling 
virtualization on CPU5
Mar 22 15:37:09 Miraculix kernel: [  681.690758] smpboot: CPU 5 is now 
offline
Mar 22 15:37:09 Miraculix kernel: [  681.692222] kvm: disabling 
virtualization on CPU6
Mar 22 15:37:09 Miraculix kernel: [  681.794725] smpboot: CPU 6 is now 
offline
Mar 22 15:37:09 Miraculix kernel: [  681.798850] Broke affinity for irq 16
Mar 22 15:37:09 Miraculix kernel: [  681.798867] Broke affinity for irq 42
Mar 22 15:37:09 Miraculix kernel: [  681.799870] kvm: disabling 
virtualization on CPU7
Mar 22 15:37:09 Miraculix kernel: [  681.902690] smpboot: CPU 7 is now 
offline
Mar 22 15:37:09 Miraculix kernel: [  681.903982] ACPI: Low-level resume 
complete
Mar 22 15:37:09 Miraculix kernel: [  681.904020] PM: Restoring platform 
NVS memory
Mar 22 15:37:09 Miraculix kernel: [  681.904523] Enabling non-boot CPUs ...
Mar 22 15:37:09 Miraculix kernel: [  681.904564] x86: Booting SMP 
configuration:
Mar 22 15:37:09 Miraculix kernel: [  681.904565] smpboot: Booting Node 0 
Processor 1 APIC 0x1
Mar 22 15:37:09 Miraculix kernel: [  681.915894] kvm: enabling 
virtualization on CPU1
Mar 22 15:37:09 Miraculix kernel: [  681.918092] Intel pstate 
controlling: cpu 1
Mar 22 15:37:09 Miraculix kernel: [  681.918147] CPU1 is up
Mar 22 15:37:09 Miraculix kernel: [  681.918165] smpboot: Booting Node 0 
Processor 2 APIC 0x2
Mar 22 15:37:09 Miraculix kernel: [  681.929570] kvm: enabling 
virtualization on CPU2
Mar 22 15:37:09 Miraculix kernel: [  681.931740] Intel pstate 
controlling: cpu 2
Mar 22 15:37:09 Miraculix kernel: [  681.931790] CPU2 is up
Mar 22 15:37:09 Miraculix kernel: [  681.931807] smpboot: Booting Node 0 
Processor 3 APIC 0x3
Mar 22 15:37:09 Miraculix kernel: [  681.943211] kvm: enabling 
virtualization on CPU3
Mar 22 15:37:09 Miraculix kernel: [  681.945454] Intel pstate 
controlling: cpu 3
Mar 22 15:37:09 Miraculix kernel: [  681.945518] CPU3 is up
Mar 22 15:37:09 Miraculix kernel: [  681.945539] smpboot: Booting Node 0 
Processor 4 APIC 0x4
Mar 22 15:37:09 Miraculix kernel: [  681.956943] kvm: enabling 
virtualization on CPU4
Mar 22 15:37:09 Miraculix kernel: [  681.959120] Intel pstate 
controlling: cpu 4
Mar 22 15:37:09 Miraculix kernel: [  681.959169] CPU4 is up
Mar 22 15:37:09 Miraculix kernel: [  681.959186] smpboot: Booting Node 0 
Processor 5 APIC 0x5
Mar 22 15:37:09 Miraculix kernel: [  681.970589] kvm: enabling 
virtualization on CPU5
Mar 22 15:37:09 Miraculix kernel: [  681.972785] Intel pstate 
controlling: cpu 5
Mar 22 15:37:09 Miraculix kernel: [  681.972831] CPU5 is up
Mar 22 15:37:09 Miraculix kernel: [  681.972849] smpboot: Booting Node 0 
Processor 6 APIC 0x6
Mar 22 15:37:09 Miraculix kernel: [  681.984258] kvm: enabling 
virtualization on CPU6
Mar 22 15:37:09 Miraculix kernel: [  681.986441] Intel pstate 
controlling: cpu 6
Mar 22 15:37:09 Miraculix kernel: [  681.986489] CPU6 is up
Mar 22 15:37:09 Miraculix kernel: [  681.986507] smpboot: Booting Node 0 
Processor 7 APIC 0x7
Mar 22 15:37:09 Miraculix kernel: [  681.997915] kvm: enabling 
virtualization on CPU7
Mar 22 15:37:09 Miraculix kernel: [  682.000129] Intel pstate 
controlling: cpu 7
Mar 22 15:37:09 Miraculix kernel: [  682.000182] CPU7 is up
Mar 22 15:37:09 Miraculix kernel: [  682.007186] ACPI: Waking up from 
system sleep state S3
Mar 22 15:37:09 Miraculix kernel: [  682.088205] xhci_hcd 0000:00:14.0: 
System wakeup disabled by ACPI
Mar 22 15:37:09 Miraculix kernel: [  682.152176] ehci-pci 0000:00:1a.0: 
System wakeup disabled by ACPI
Mar 22 15:37:09 Miraculix kernel: [  682.184162] ehci-pci 0000:00:1d.0: 
System wakeup disabled by ACPI
Mar 22 15:37:09 Miraculix kernel: [  682.248286] sdhci-pci 0000:02:00.0: 
MMC controller base frequency changed to 50Mhz.
Mar 22 15:37:09 Miraculix kernel: [  682.280706] PM: noirq resume of 
devices complete after 207.080 msecs
Mar 22 15:37:09 Miraculix kernel: [  682.280853] PM: early resume of 
devices complete after 0.115 msecs
Mar 22 15:37:09 Miraculix kernel: [  682.280889] e1000e 0000:00:19.0: 
System wakeup disabled by ACPI
Mar 22 15:37:09 Miraculix kernel: [  682.280915] mei_me 0000:00:16.0: 
irq 43 for MSI/MSI-X
Mar 22 15:37:09 Miraculix kernel: [  682.280939] e1000e 0000:00:19.0: 
irq 45 for MSI/MSI-X
Mar 22 15:37:09 Miraculix kernel: [  682.280943] nouveau  [ DRM] 
re-enabling device...
Mar 22 15:37:09 Miraculix kernel: [  682.280973] nouveau  [ DRM] 
resuming kernel object tree...
Mar 22 15:37:09 Miraculix kernel: [  682.280986] nouveau  [ 
VBIOS][0000:01:00.0] running init tables
Mar 22 15:37:09 Miraculix kernel: [  682.284240] snd_hda_intel 
0000:00:1b.0: irq 47 for MSI/MSI-X
Mar 22 15:37:09 Miraculix kernel: [  682.336119] tpm_tis 00:09: TPM is 
disabled/deactivated (0x6)
Mar 22 15:37:09 Miraculix kernel: [  682.623969] ata2: SATA link up 1.5 
Gbps (SStatus 113 SControl 300)
Mar 22 15:37:09 Miraculix kernel: [  682.625332] ata2.00: ACPI cmd 
e3/00:1f:00:00:00:a0 (IDLE) succeeded
Mar 22 15:37:09 Miraculix kernel: [  682.626218] ata2.00: ACPI cmd 
e3/00:02:00:00:00:a0 (IDLE) succeeded
Mar 22 15:37:09 Miraculix kernel: [  682.628348] ata2.00: ACPI cmd 
e3/00:1f:00:00:00:a0 (IDLE) succeeded
Mar 22 15:37:09 Miraculix kernel: [  682.629004] ata2.00: ACPI cmd 
e3/00:02:00:00:00:a0 (IDLE) succeeded
Mar 22 15:37:09 Miraculix kernel: [  682.629325] ata2.00: configured for 
UDMA/100
Mar 22 15:37:09 Miraculix kernel: [  682.631971] ata5: SATA link down 
(SStatus 0 SControl 300)
Mar 22 15:37:09 Miraculix kernel: [  682.679338] nouveau  [ 
VOLT][0000:01:00.0] GPU voltage: 875000uv
Mar 22 15:37:09 Miraculix kernel: [  682.679341] nouveau  [ 
PTHERM][0000:01:00.0] fan management: automatic
Mar 22 15:37:09 Miraculix kernel: [  682.679623] nouveau  [ 
CLK][0000:01:00.0] --: core 405 MHz memory 648 MHz
Mar 22 15:37:09 Miraculix kernel: [  682.679762] mei_me 0000:00:16.0: 
hbm: properties response: wrong status = 1
Mar 22 15:37:09 Miraculix kernel: [  682.679771] mei_me 0000:00:16.0: 
unexpected reset: dev_state = INIT_CLIENTS
Mar 22 15:37:09 Miraculix kernel: [  682.684077] usb 2-1.7: reset 
low-speed USB device number 3 using ehci-pci
Mar 22 15:37:09 Miraculix kernel: [  682.686389] nouveau  [ DRM] 
resuming client object trees...
Mar 22 15:37:09 Miraculix kernel: [  682.694124] nouveau  [ DRM] 
resuming display...
Mar 22 15:37:09 Miraculix kernel: [  682.835901] firewire_core 
0000:02:00.3: rediscovered device fw0
Mar 22 15:37:09 Miraculix kernel: [  683.036068] usb 1-1.6: reset 
high-speed USB device number 5 using ehci-pci
Mar 22 15:37:09 Miraculix kernel: [  683.203964] usb 1-1.1: reset 
full-speed USB device number 3 using ehci-pci
Mar 22 15:37:09 Miraculix kernel: [  683.368120] usb 1-1.4: reset 
full-speed USB device number 4 using ehci-pci
Mar 22 15:37:09 Miraculix kernel: [  684.471470] ata1: SATA link up 6.0 
Gbps (SStatus 133 SControl 300)
Mar 22 15:37:09 Miraculix kernel: [  684.472581] ata1.00: ACPI cmd 
ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
Mar 22 15:37:09 Miraculix kernel: [  684.472585] ata1.00: ACPI cmd 
f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
Mar 22 15:37:09 Miraculix kernel: [  684.474774] ata1.00: ACPI cmd 
ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
Mar 22 15:37:09 Miraculix kernel: [  684.474779] ata1.00: ACPI cmd 
f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
Mar 22 15:37:09 Miraculix kernel: [  684.475695] ata1.00: configured for 
UDMA/133
Mar 22 15:37:09 Miraculix kernel: [  684.491536] sd 0:0:0:0: [sda] 
Starting disk
Mar 22 15:37:09 Miraculix kernel: [  684.514601] PM: resume of devices 
complete after 2234.446 msecs
Mar 22 15:37:09 Miraculix kernel: [  684.515231] PM: Finishing wakeup.
Mar 22 15:37:09 Miraculix kernel: [  684.515232] Restarting tasks ... done.
Mar 22 15:37:09 Miraculix bluetoothd[962]: Adapter /org/bluez/962/hci0 
has been disabled
Mar 22 15:37:09 Miraculix bluetoothd[962]: Unregister path: 
/org/bluez/962/hci0
Mar 22 15:37:09 Miraculix bluetoothd[962]: Endpoint unregistered: 
sender=:1.71 path=/MediaEndpoint/A2DPSink
Mar 22 15:37:09 Miraculix bluetoothd[962]: Endpoint unregistered: 
sender=:1.71 path=/MediaEndpoint/A2DPSource
Mar 22 15:37:09 Miraculix bluetoothd[962]: Endpoint unregistered: 
sender=:1.71 path=/MediaEndpoint/HFPAG
Mar 22 15:37:09 Miraculix bluetoothd[962]: Endpoint unregistered: 
sender=:1.71 path=/MediaEndpoint/HFPHS
Mar 22 15:37:09 Miraculix kernel: [  684.521377] video LNXVIDEO:01: 
Restoring backlight state
Mar 22 15:37:09 Miraculix bluetoothd[962]: Adapter /org/bluez/962/hci0 
has been enabled
Mar 22 15:37:09 Miraculix bluetoothd[962]: Endpoint registered: 
sender=:1.71 path=/MediaEndpoint/HFPAG
Mar 22 15:37:09 Miraculix bluetoothd[962]: Endpoint registered: 
sender=:1.71 path=/MediaEndpoint/HFPHS
Mar 22 15:37:09 Miraculix bluetoothd[962]: Endpoint registered: 
sender=:1.71 path=/MediaEndpoint/A2DPSource
Mar 22 15:37:09 Miraculix bluetoothd[962]: Endpoint registered: 
sender=:1.71 path=/MediaEndpoint/A2DPSink
Mar 22 15:37:09 Miraculix bluetoothd[962]: Unknown command complete for 
opcode 19
Mar 22 15:37:09 Miraculix anacron[5517]: Anacron 2.3 started on 2014-03-22
Mar 22 15:37:09 Miraculix anacron[5517]: Normal exit (0 jobs run)
Mar 22 15:37:09 Miraculix anacron[5579]: Anacron 2.3 started on 2014-03-22
Mar 22 15:37:09 Miraculix anacron[5579]: Normal exit (0 jobs run)
Mar 22 15:37:10 Miraculix NetworkManager[1149]: <info> wake requested 
(sleeping: yes  enabled: yes)
Mar 22 15:37:10 Miraculix NetworkManager[1149]: <info> waking up and 
re-enabling...
Mar 22 15:37:10 Miraculix NetworkManager[1149]: <info> WWAN now enabled 
by management service
Mar 22 15:37:10 Miraculix NetworkManager[1149]: <info> (eth0): device 
state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
Mar 22 15:37:10 Miraculix NetworkManager[1149]: <info> (eth0): bringing 
up device.
Mar 22 15:37:10 Miraculix kernel: [  685.067789] e1000e 0000:00:19.0: 
irq 45 for MSI/MSI-X
Mar 22 15:37:10 Miraculix NetworkManager[1149]: <info> (eth0): preparing 
device.
Mar 22 15:37:10 Miraculix NetworkManager[1149]: <info> (eth0): 
deactivating device (reason 'managed') [2]
Mar 22 15:37:10 Miraculix NetworkManager[1149]: <info> Unmanaged Device 
found; state CONNECTED forced. (see http://bugs.launchpad.net/bugs/191889)
Mar 22 15:37:10 Miraculix NetworkManager[1149]: <info> Unmanaged Device 
found; state CONNECTED forced. (see http://bugs.launchpad.net/bugs/191889)
Mar 22 15:37:10 Miraculix NetworkManager[1149]: <info> NetworkManager 
state is now CONNECTED_GLOBAL
Mar 22 15:37:10 Miraculix NetworkManager[1149]: <info> Unmanaged Device 
found; state CONNECTED forced. (see http://bugs.launchpad.net/bugs/191889)
Mar 22 15:37:10 Miraculix NetworkManager[1149]: <info> (wlan0): device 
state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
Mar 22 15:37:10 Miraculix NetworkManager[1149]: <info> (wlan0): bringing 
up device.
Mar 22 15:37:10 Miraculix kernel: [  685.171224] e1000e 0000:00:19.0: 
irq 45 for MSI/MSI-X
Mar 22 15:37:10 Miraculix kernel: [  685.171457] IPv6: 
ADDRCONF(NETDEV_UP): eth0: link is not ready
Mar 22 15:37:10 Miraculix kernel: [  685.172240] iwlwifi 0000:03:00.0: 
L1 Enabled; Disabling L0S
Mar 22 15:37:10 Miraculix kernel: [  685.179076] iwlwifi 0000:03:00.0: 
Radio type=0x1-0x2-0x0
Mar 22 15:37:10 Miraculix NetworkManager[1149]: <info> (wlan0): 
preparing device.
Mar 22 15:37:10 Miraculix NetworkManager[1149]: <info> (wlan0): 
deactivating device (reason 'managed') [2]
Mar 22 15:37:10 Miraculix NetworkManager[1149]: <info> NetworkManager 
state is now DISCONNECTED
Mar 22 15:37:10 Miraculix kernel: [  685.263167] IPv6: 
ADDRCONF(NETDEV_UP): wlan0: link is not ready
Mar 22 15:37:10 Miraculix NetworkManager[1149]: <info> (wlan0) supports 
5 scan SSIDs
Mar 22 15:37:10 Miraculix NetworkManager[1149]: <info> (wlan0): 
supplicant interface state: starting -> ready
Mar 22 15:37:10 Miraculix NetworkManager[1149]: <info> (wlan0): device 
state change: unavailable -> disconnected (reason 
'supplicant-available') [20 30 42]
Mar 22 15:37:10 Miraculix NetworkManager[1149]: <warn> Trying to remove 
a non-existant call id.
Mar 22 15:37:10 Miraculix NetworkManager[1149]: <info> (wlan0): 
supplicant interface state: ready -> disconnected
Mar 22 15:37:10 Miraculix NetworkManager[1149]: <info> (wlan0) supports 
5 scan SSIDs
Mar 22 15:37:10 Miraculix wpa_supplicant[1418]: wlan0: Reject scan 
trigger since one is already pending
Mar 22 15:37:10 Miraculix wpa_supplicant[1418]: wlan0: 
CTRL-EVENT-SCAN-STARTED
Mar 22 15:37:10 Miraculix dnsmasq[1866]: no servers found in 
/var/run/dnsmasq/resolv.conf, will retry
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> Auto-activating 
connection 'Scotty Beam Me Up'.
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> Activation 
(wlan0) starting connection 'Scotty Beam Me Up'
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> (wlan0): device 
state change: disconnected -> prepare (reason 'none') [30 40 0]
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> NetworkManager 
state is now CONNECTING
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> Activation 
(wlan0) Stage 1 of 5 (Device Prepare) scheduled...
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> Activation 
(wlan0) Stage 1 of 5 (Device Prepare) started...
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> Activation 
(wlan0) Stage 2 of 5 (Device Configure) scheduled...
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> Activation 
(wlan0) Stage 1 of 5 (Device Prepare) complete.
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> Activation 
(wlan0) Stage 2 of 5 (Device Configure) starting...
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> (wlan0): device 
state change: prepare -> config (reason 'none') [40 50 0]
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> Activation 
(wlan0/wireless): access point 'Scotty Beam Me Up' has security, but 
secrets are required.
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> (wlan0): device 
state change: config -> need-auth (reason 'none') [50 60 0]
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> Activation 
(wlan0) Stage 2 of 5 (Device Configure) complete.
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> (wlan0): 
supplicant interface state: disconnected -> inactive
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> Activation 
(wlan0) Stage 1 of 5 (Device Prepare) scheduled...
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> Activation 
(wlan0) Stage 1 of 5 (Device Prepare) started...
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> (wlan0): device 
state change: need-auth -> prepare (reason 'none') [60 40 0]
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> Activation 
(wlan0) Stage 2 of 5 (Device Configure) scheduled...
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> Activation 
(wlan0) Stage 1 of 5 (Device Prepare) complete.
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> Activation 
(wlan0) Stage 2 of 5 (Device Configure) starting...
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> (wlan0): device 
state change: prepare -> config (reason 'none') [40 50 0]
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> Activation 
(wlan0/wireless): connection 'Scotty Beam Me Up' has security, and 
secrets exist.  No new secrets needed.
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> Config: added 
'ssid' value 'Scotty Beam Me Up'
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> Config: added 
'scan_ssid' value '1'
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> Config: added 
'key_mgmt' value 'WPA-PSK'
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> Config: added 
'auth_alg' value 'OPEN'
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> Config: added 
'psk' value '<omitted>'
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> Activation 
(wlan0) Stage 2 of 5 (Device Configure) complete.
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> Config: set 
interface ap_scan to 1
Mar 22 15:37:13 Miraculix wpa_supplicant[1418]: wlan0: SME: Trying to 
authenticate with 24:65:11:53:8d:21 (SSID='Scotty Beam Me Up' freq=2462 MHz)
Mar 22 15:37:13 Miraculix kernel: [  688.529898] wlan0: authenticate 
with 24:65:11:53:8d:21
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> (wlan0): 
supplicant interface state: inactive -> authenticating
Mar 22 15:37:13 Miraculix kernel: [  688.535345] wlan0: send auth to 
24:65:11:53:8d:21 (try 1/3)
Mar 22 15:37:13 Miraculix wpa_supplicant[1418]: wlan0: Trying to 
associate with 24:65:11:53:8d:21 (SSID='Scotty Beam Me Up' freq=2462 MHz)
Mar 22 15:37:13 Miraculix kernel: [  688.545887] wlan0: authenticated
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> (wlan0): 
supplicant interface state: authenticating -> associating
Mar 22 15:37:13 Miraculix kernel: [  688.550170] wlan0: associate with 
24:65:11:53:8d:21 (try 1/3)
Mar 22 15:37:13 Miraculix kernel: [  688.557302] wlan0: RX AssocResp 
from 24:65:11:53:8d:21 (capab=0x431 status=0 aid=3)
Mar 22 15:37:13 Miraculix wpa_supplicant[1418]: wlan0: Associated with 
24:65:11:53:8d:21
Mar 22 15:37:13 Miraculix kernel: [  688.578155] wlan0: associated
Mar 22 15:37:13 Miraculix kernel: [  688.578188] IPv6: 
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
Mar 22 15:37:13 Miraculix kernel: [  688.578315] cfg80211: Calling CRDA 
for country: DE
Mar 22 15:37:13 Miraculix kernel: [  688.580746] cfg80211: Regulatory 
domain changed to country: DE
Mar 22 15:37:13 Miraculix kernel: [  688.580749] cfg80211:  DFS Master 
region: unset
Mar 22 15:37:13 Miraculix kernel: [  688.580751] cfg80211: (start_freq - 
end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Mar 22 15:37:13 Miraculix kernel: [  688.580752] cfg80211: (2400000 KHz 
- 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
Mar 22 15:37:13 Miraculix kernel: [  688.580753] cfg80211: (5150000 KHz 
- 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Mar 22 15:37:13 Miraculix kernel: [  688.580755] cfg80211: (5250000 KHz 
- 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Mar 22 15:37:13 Miraculix kernel: [  688.580756] cfg80211: (5470000 KHz 
- 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
Mar 22 15:37:13 Miraculix kernel: [  688.580757] cfg80211: (57240000 KHz 
- 65880000 KHz @ 2160000 KHz), (N/A, 4000 mBm)
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> (wlan0): 
supplicant interface state: associating -> 4-way handshake
Mar 22 15:37:13 Miraculix wpa_supplicant[1418]: wlan0: WPA: Key 
negotiation completed with 24:65:11:53:8d:21 [PTK=CCMP GTK=TKIP]
Mar 22 15:37:13 Miraculix wpa_supplicant[1418]: wlan0: 
CTRL-EVENT-CONNECTED - Connection to 24:65:11:53:8d:21 completed [id=0 
id_str=]
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> (wlan0): 
supplicant interface state: 4-way handshake -> completed
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> Activation 
(wlan0/wireless) Stage 2 of 5 (Device Configure) successful.  Connected 
to wireless network 'Scotty Beam Me Up'.
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> Activation 
(wlan0) Stage 3 of 5 (IP Configure Start) scheduled.
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> Activation 
(wlan0) Stage 3 of 5 (IP Configure Start) started...
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> (wlan0): device 
state change: config -> ip-config (reason 'none') [50 70 0]
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> Activation 
(wlan0) Beginning DHCPv4 transaction (timeout in 45 seconds)
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> dhclient started 
with pid 5702
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> Activation 
(wlan0) Beginning IP6 addrconf.
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> Activation 
(wlan0) Stage 3 of 5 (IP Configure Start) complete.
Mar 22 15:37:13 Miraculix acvpnagent[2465]: message repeated 2 times: [ 
Function: tableCallbackHandler File: RouteMgr.cpp Line: 1723 Invoked 
Function: recv Return Code: 11 (0x0000000B) Description: unknown ]
Mar 22 15:37:13 Miraculix acvpnagent[2465]: A new network interface has 
been detected.
Mar 22 15:37:13 Miraculix acvpnagent[2465]: Function: logInterfaces 
File: RouteMgr.cpp Line: 2105 Invoked Function: logInterfaces Return 
Code: 0 (0x00000000) Description: IP Address Interface List: 
FE80:0:0:0:A64E:31FF:FE3E:C1EC
Mar 22 15:37:13 Miraculix acvpnagent[2465]: Function: 
tableCallbackHandler File: RouteMgr.cpp Line: 1723 Invoked Function: 
recv Return Code: 11 (0x0000000B) Description: unknown
Mar 22 15:37:13 Miraculix dhclient: Internet Systems Consortium DHCP 
Client 4.2.4
Mar 22 15:37:13 Miraculix dhclient: Copyright 2004-2012 Internet Systems 
Consortium.
Mar 22 15:37:13 Miraculix dhclient: All rights reserved.
Mar 22 15:37:13 Miraculix dhclient: For info, please visit 
https://www.isc.org/software/dhcp/
Mar 22 15:37:13 Miraculix dhclient:
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> (wlan0): DHCPv4 
state changed nbi -> preinit
Mar 22 15:37:13 Miraculix dhclient: Listening on LPF/wlan0/a4:4e:31:3e:c1:ec
Mar 22 15:37:13 Miraculix dhclient: Sending on LPF/wlan0/a4:4e:31:3e:c1:ec
Mar 22 15:37:13 Miraculix dhclient: Sending on   Socket/fallback
Mar 22 15:37:13 Miraculix dhclient: DHCPREQUEST of 192.168.178.31 on 
wlan0 to 255.255.255.255 port 67 (xid=0x1733fdc3)
Mar 22 15:37:13 Miraculix dhclient: DHCPACK of 192.168.178.31 from 
192.168.178.1
Mar 22 15:37:13 Miraculix dhclient: bound to 192.168.178.31 -- renewal 
in 356035 seconds.
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> (wlan0): DHCPv4 
state changed preinit -> reboot
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> address 
192.168.178.31
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> prefix 24 
(255.255.255.0)
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> gateway 192.168.178.1
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> nameserver 
'192.168.178.1'
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> domain name 
'fritz.box'
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> Activation 
(wlan0) Stage 5 of 5 (IPv4 Configure Commit) scheduled...
Mar 22 15:37:13 Miraculix NetworkManager[1149]: <info> Activation 
(wlan0) Stage 5 of 5 (IPv4 Commit) started...
Mar 22 15:37:13 Miraculix avahi-daemon[1019]: Joining mDNS multicast 
group on interface wlan0.IPv4 with address 192.168.178.31.
Mar 22 15:37:13 Miraculix avahi-daemon[1019]: New relevant interface 
wlan0.IPv4 for mDNS.
Mar 22 15:37:13 Miraculix avahi-daemon[1019]: Registering new address 
record for 192.168.178.31 on wlan0.IPv4.
Mar 22 15:37:13 Miraculix acvpnagent[2465]: Function: 
tableCallbackHandler File: RouteMgr.cpp Line: 1723 Invoked Function: 
recv Return Code: 11 (0x0000000B) Description: unknown
Mar 22 15:37:13 Miraculix acvpnagent[2465]: A new network interface has 
been detected.
Mar 22 15:37:13 Miraculix acvpnagent[2465]: Function: logInterfaces 
File: RouteMgr.cpp Line: 2105 Invoked Function: logInterfaces Return 
Code: 0 (0x00000000) Description: IP Address Interface List: 
192.168.178.31 FE80:0:0:0:A64E:31FF:FE3E:C1EC
Mar 22 15:37:13 Miraculix acvpnagent[2465]: Function: 
tableCallbackHandler File: RouteMgr.cpp Line: 1723 Invoked Function: 
recv Return Code: 11 (0x0000000B) Description: unknown
Mar 22 15:37:14 Miraculix NetworkManager[1149]: <info> (wlan0): device 
state change: ip-config -> secondaries (reason 'none') [70 90 0]
Mar 22 15:37:14 Miraculix NetworkManager[1149]: <info> Activation 
(wlan0) Stage 5 of 5 (IPv4 Commit) complete.
Mar 22 15:37:14 Miraculix NetworkManager[1149]: <info> (wlan0): device 
state change: secondaries -> activated (reason 'none') [90 100 0]
Mar 22 15:37:14 Miraculix NetworkManager[1149]: <info> NetworkManager 
state is now CONNECTED_GLOBAL
Mar 22 15:37:14 Miraculix NetworkManager[1149]: <info> Policy set 
'Scotty Beam Me Up' (wlan0) as default for IPv4 routing and DNS.
Mar 22 15:37:14 Miraculix NetworkManager[1149]: <info> Writing DNS 
information to /sbin/resolvconf
Mar 22 15:37:14 Miraculix dnsmasq[2966]: setting upstream servers from DBus
Mar 22 15:37:14 Miraculix dnsmasq[2966]: using nameserver 192.168.178.1#53
Mar 22 15:37:15 Miraculix dnsmasq[1866]: reading 
/var/run/dnsmasq/resolv.conf
Mar 22 15:37:15 Miraculix dnsmasq[1866]: using nameserver 127.0.1.1#53
Mar 22 15:37:15 Miraculix NetworkManager[1149]: <info> Activation 
(wlan0) successful, device activated.
Mar 22 15:37:15 Miraculix dbus[913]: [system] Activating service 
name='org.freedesktop.nm_dispatcher' (using servicehelper)
Mar 22 15:37:15 Miraculix dbus[913]: [system] Successfully activated 
service 'org.freedesktop.nm_dispatcher'
Mar 22 15:37:15 Miraculix whoopsie[1826]: message repeated 4 times: [ 
offline]
Mar 22 15:37:15 Miraculix whoopsie[1826]: online
Mar 22 15:37:15 Miraculix avahi-daemon[1019]: Joining mDNS multicast 
group on interface wlan0.IPv6 with address fe80::a64e:31ff:fe3e:c1ec.
Mar 22 15:37:15 Miraculix avahi-daemon[1019]: New relevant interface 
wlan0.IPv6 for mDNS.
Mar 22 15:37:15 Miraculix avahi-daemon[1019]: Registering new address 
record for fe80::a64e:31ff:fe3e:c1ec on wlan0.*.
Mar 22 15:37:20 Miraculix ntpdate[5782]: step time server 91.189.94.4 
offset -0.663157 sec
Mar 22 15:37:33 Miraculix NetworkManager[1149]: <info> (wlan0): IP6 
addrconf timed out or failed.
Mar 22 15:37:33 Miraculix NetworkManager[1149]: <info> Activation 
(wlan0) Stage 4 of 5 (IPv6 Configure Timeout) scheduled...
Mar 22 15:37:33 Miraculix NetworkManager[1149]: <info> Activation 
(wlan0) Stage 4 of 5 (IPv6 Configure Timeout) started...
Mar 22 15:37:33 Miraculix NetworkManager[1149]: <info> Activation 
(wlan0) Stage 4 of 5 (IPv6 Configure Timeout) complete.
Mar 22 15:37:33 Miraculix wpa_supplicant[1418]: wlan0: 
CTRL-EVENT-SCAN-STARTED

Mar 22 15:38:36 Miraculix rsyslogd-2307: warning: ~ action is 
deprecated, consider using the 'stop' statement instead [try 
http://www.rsyslog.com/e/2307 ]
Mar 22 15:38:36 Miraculix rsyslogd: rsyslogd's groupid changed to 103
Mar 22 15:38:36 Miraculix rsyslogd: rsyslogd's userid changed to 101
Mar 22 15:38:36 Miraculix kernel: [    0.000000] Initializing cgroup 
subsys cpuset
Mar 22 15:38:36 Miraculix kernel: [    0.000000] Initializing cgroup 
subsys cpu
Mar 22 15:38:36 Miraculix kernel: [    0.000000] Initializing cgroup 
subsys cpuacct
Mar 22 15:38:36 Miraculix kernel: [    0.000000] Linux version 
3.14.0-031400rc7-generic (apw@gomeisa) (gcc version 4.6.3 (Ubuntu/Linaro 
4.6.3-1ubuntu5) ) #201403162235 SMP Mon Mar 17 02:36:19 UTC 2014
Mar 22 15:38:36 Miraculix kernel: [    0.000000] Command line: 
BOOT_IMAGE=/vmlinuz-3.14.0-031400rc7-generic 
root=UUID=16cf338b-a7ee-4688-a7b5-ce4251061783 ro quiet splash vt.handoff=7
Mar 22 15:38:36 Miraculix kernel: [    0.000000] KERNEL supported cpus:
Mar 22 15:38:36 Miraculix kernel: [    0.000000]   Intel GenuineIntel
Mar 22 15:38:36 Miraculix kernel: [    0.000000]   AMD AuthenticAMD
Mar 22 15:38:36 Miraculix kernel: [    0.000000]   Centaur CentaurHauls
Mar 22 15:38:36 Miraculix kernel: [    0.000000] e820: BIOS-provided 
physical RAM map:
Mar 22 15:38:36 Miraculix kernel: [    0.000000] BIOS-e820: [mem 
0x0000000000000000-0x000000000009d7ff] usable
Mar 22 15:38:36 Miraculix kernel: [    0.000000] BIOS-e820: [mem 
0x000000000009d800-0x000000000009ffff] reserved
Mar 22 15:38:36 Miraculix kernel: [    0.000000] BIOS-e820: [mem 
0x00000000000e0000-0x00000000000fffff] reserved
Mar 22 15:38:36 Miraculix kernel: [    0.000000] BIOS-e820: [mem 
0x0000000000100000-0x00000000cb32ffff] usable
Mar 22 15:38:36 Miraculix kernel: [    0.000000] BIOS-e820: [mem 
0x00000000cb330000-0x00000000df69efff] reserved
Mar 22 15:38:36 Miraculix kernel: [    0.000000] BIOS-e820: [mem 
0x00000000df69f000-0x00000000df79efff] ACPI NVS
Mar 22 15:38:36 Miraculix kernel: [    0.000000] BIOS-e820: [mem 
0x00000000df79f000-0x00000000df7fefff] ACPI data
Mar 22 15:38:36 Miraculix kernel: [    0.000000] BIOS-e820: [mem 
0x00000000df7ff000-0x00000000dfffffff] reserved
Mar 22 15:38:36 Miraculix kernel: [    0.000000] BIOS-e820: [mem 
0x00000000f8000000-0x00000000fbffffff] reserved
Mar 22 15:38:36 Miraculix kernel: [    0.000000] BIOS-e820: [mem 
0x00000000fec00000-0x00000000fec00fff] reserved
Mar 22 15:38:36 Miraculix kernel: [    0.000000] BIOS-e820: [mem 
0x00000000fed08000-0x00000000fed08fff] reserved
Mar 22 15:38:36 Miraculix kernel: [    0.000000] BIOS-e820: [mem 
0x00000000fed10000-0x00000000fed19fff] reserved
Mar 22 15:38:36 Miraculix kernel: [    0.000000] BIOS-e820: [mem 
0x00000000fed1c000-0x00000000fed1ffff] reserved
Mar 22 15:38:36 Miraculix kernel: [    0.000000] BIOS-e820: [mem 
0x00000000fee00000-0x00000000fee00fff] reserved
Mar 22 15:38:36 Miraculix kernel: [    0.000000] BIOS-e820: [mem 
0x00000000ffc00000-0x00000000ffffffff] reserved
Mar 22 15:38:36 Miraculix kernel: [    0.000000] BIOS-e820: [mem 
0x0000000100000000-0x000000041dffffff] usable
Mar 22 15:38:36 Miraculix kernel: [    0.000000] NX (Execute Disable) 
protection: active
Mar 22 15:38:36 Miraculix kernel: [    0.000000] SMBIOS 2.7 present.
Mar 22 15:38:36 Miraculix kernel: [    0.000000] DMI: LENOVO 
24491D1/24491D1, BIOS G5ET96WW (2.56 ) 11/27/2013
Mar 22 15:38:36 Miraculix kernel: [    0.000000] e820: update [mem 
0x00000000-0x00000fff] usable ==> reserved
Mar 22 15:38:36 Miraculix kernel: [    0.000000] e820: remove [mem 
0x000a0000-0x000fffff] usable
Mar 22 15:38:36 Miraculix kernel: [    0.000000] No AGP bridge found
Mar 22 15:38:36 Miraculix kernel: [    0.000000] e820: last_pfn = 
0x41e000 max_arch_pfn = 0x400000000
Mar 22 15:38:36 Miraculix kernel: [    0.000000] MTRR default type: 
uncachable
Mar 22 15:38:36 Miraculix kernel: [    0.000000] MTRR fixed ranges enabled:
Mar 22 15:38:36 Miraculix kernel: [    0.000000]   00000-9FFFF write-back
Mar 22 15:38:36 Miraculix kernel: [    0.000000]   A0000-BFFFF uncachable
Mar 22 15:38:36 Miraculix kernel: [    0.000000]   C0000-FFFFF write-protect
Mar 22 15:38:36 Miraculix kernel: [    0.000000] MTRR variable ranges 
enabled:
Mar 22 15:38:36 Miraculix kernel: [    0.000000]   0 base 0FFC00000 mask 
FFFC00000 write-protect
Mar 22 15:38:36 Miraculix kernel: [    0.000000]   1 base 000000000 mask 
F80000000 write-back
Mar 22 15:38:36 Miraculix kernel: [    0.000000]   2 base 080000000 mask 
FC0000000 write-back
Mar 22 15:38:36 Miraculix kernel: [    0.000000]   3 base 0C0000000 mask 
FE0000000 write-back
Mar 22 15:38:36 Miraculix kernel: [    0.000000]   4 base 0DF800000 mask 
FFF800000 uncachable
Mar 22 15:38:36 Miraculix kernel: [    0.000000]   5 base 100000000 mask 
F00000000 write-back
Mar 22 15:38:36 Miraculix kernel: [    0.000000]   6 base 200000000 mask 
E00000000 write-back
Mar 22 15:38:36 Miraculix kernel: [    0.000000]   7 base 400000000 mask 
FE0000000 write-back
Mar 22 15:38:36 Miraculix kernel: [    0.000000]   8 base 41E000000 mask 
FFE000000 uncachable
Mar 22 15:38:36 Miraculix kernel: [    0.000000]   9 disabled
Mar 22 15:38:36 Miraculix kernel: [    0.000000] x86 PAT enabled: cpu 0, 
old 0x7040600070406, new 0x7010600070106
Mar 22 15:38:36 Miraculix kernel: [    0.000000] e820: last_pfn = 
0xcb330 max_arch_pfn = 0x400000000
Mar 22 15:38:36 Miraculix kernel: [    0.000000] found SMP MP-table at 
[mem 0x000f0100-0x000f010f] mapped at [ffff8800000f0100]
Mar 22 15:38:36 Miraculix kernel: [    0.000000] Scanning 1 areas for 
low memory corruption
Mar 22 15:38:36 Miraculix kernel: [    0.000000] Base memory trampoline 
at [ffff880000097000] 97000 size 24576
Mar 22 15:38:36 Miraculix kernel: [    0.000000] init_memory_mapping: 
[mem 0x00000000-0x000fffff]
Mar 22 15:38:36 Miraculix kernel: [    0.000000]  [mem 
0x00000000-0x000fffff] page 4k
Mar 22 15:38:36 Miraculix kernel: [    0.000000] BRK [0x01fda000, 
0x01fdafff] PGTABLE
Mar 22 15:38:36 Miraculix kernel: [    0.000000] BRK [0x01fdb000, 
0x01fdbfff] PGTABLE
Mar 22 15:38:36 Miraculix kernel: [    0.000000] BRK [0x01fdc000, 
0x01fdcfff] PGTABLE
Mar 22 15:38:36 Miraculix kernel: [    0.000000] init_memory_mapping: 
[mem 0x41de00000-0x41dffffff]
Mar 22 15:38:36 Miraculix kernel: [    0.000000]  [mem 
0x41de00000-0x41dffffff] page 2M
Mar 22 15:38:36 Miraculix kernel: [    0.000000] BRK [0x01fdd000, 
0x01fddfff] PGTABLE
Mar 22 15:38:36 Miraculix kernel: [    0.000000] init_memory_mapping: 
[mem 0x41c000000-0x41ddfffff]
Mar 22 15:38:36 Miraculix kernel: [    0.000000]  [mem 
0x41c000000-0x41ddfffff] page 2M
Mar 22 15:38:36 Miraculix kernel: [    0.000000] init_memory_mapping: 
[mem 0x400000000-0x41bffffff]
Mar 22 15:38:36 Miraculix kernel: [    0.000000]  [mem 
0x400000000-0x41bffffff] page 2M
Mar 22 15:38:36 Miraculix kernel: [    0.000000] init_memory_mapping: 
[mem 0x00100000-0xcb32ffff]
Mar 22 15:38:36 Miraculix kernel: [    0.000000]  [mem 
0x00100000-0x001fffff] page 4k
Mar 22 15:38:36 Miraculix kernel: [    0.000000]  [mem 
0x00200000-0xcb1fffff] page 2M
Mar 22 15:38:36 Miraculix kernel: [    0.000000]  [mem 
0xcb200000-0xcb32ffff] page 4k
Mar 22 15:38:36 Miraculix kernel: [    0.000000] init_memory_mapping: 
[mem 0x100000000-0x3ffffffff]
Mar 22 15:38:36 Miraculix kernel: [    0.000000]  [mem 
0x100000000-0x3ffffffff] page 2M
Mar 22 15:38:36 Miraculix kernel: [    0.000000] BRK [0x01fde000, 
0x01fdefff] PGTABLE
Mar 22 15:38:36 Miraculix kernel: [    0.000000] BRK [0x01fdf000, 
0x01fdffff] PGTABLE
Mar 22 15:38:36 Miraculix kernel: [    0.000000] RAMDISK: [mem 
0x33c46000-0x35e1afff]
Mar 22 15:38:36 Miraculix kernel: [    0.000000] ACPI: RSDP 
00000000000f0120 000024 (v02 LENOVO)
Mar 22 15:38:36 Miraculix kernel: [    0.000000] ACPI: XSDT 
00000000df7fe170 0000BC (v01 LENOVO TP-G5    00002560 PTL 00000002)
Mar 22 15:38:36 Miraculix kernel: [    0.000000] ACPI: FACP 
00000000df7e6000 00010C (v05 LENOVO TP-G5    00002560 PTL 00000002)
Mar 22 15:38:36 Miraculix kernel: [    0.000000] ACPI: DSDT 
00000000df7e8000 010A7D (v01 LENOVO TP-G5    00002560 INTL 20061109)
Mar 22 15:38:36 Miraculix kernel: [    0.000000] ACPI: FACS 
00000000df754000 000040
Mar 22 15:38:36 Miraculix kernel: [    0.000000] ACPI: SLIC 
00000000df7fd000 000176 (v01 LENOVO TP-G5    00002560 PTL 00000001)
Mar 22 15:38:36 Miraculix kernel: [    0.000000] ACPI: TCPA 
00000000df7fc000 000032 (v02    PTL   LENOVO 06040000 LNVO 00000001)
Mar 22 15:38:36 Miraculix kernel: [    0.000000] ACPI: SSDT 
00000000df7fb000 000408 (v01 LENOVO TP-SSDT2 00000200 INTL 20061109)
Mar 22 15:38:36 Miraculix kernel: [    0.000000] ACPI: SSDT 
00000000df7fa000 000033 (v01 LENOVO TP-SSDT1 00000100 INTL 20061109)
Mar 22 15:38:36 Miraculix kernel: [    0.000000] ACPI: SSDT 
00000000df7f9000 000797 (v01 LENOVO SataAhci 00001000 INTL 20061109)
Mar 22 15:38:36 Miraculix kernel: [    0.000000] ACPI: HPET 
00000000df7e4000 000038 (v01 LENOVO TP-G5    00002560 PTL 00000002)
Mar 22 15:38:36 Miraculix kernel: [    0.000000] ACPI: APIC 
00000000df7e3000 000098 (v01 LENOVO TP-G5    00002560 PTL 00000002)
Mar 22 15:38:36 Miraculix kernel: [    0.000000] ACPI: MCFG 
00000000df7e2000 00003C (v01 LENOVO TP-G5    00002560 PTL 00000002)
Mar 22 15:38:36 Miraculix kernel: [    0.000000] ACPI: ECDT 
00000000df7e1000 000052 (v01 LENOVO TP-G5    00002560 PTL 00000002)
Mar 22 15:38:36 Miraculix kernel: [    0.000000] ACPI: FPDT 
00000000df7e0000 000064 (v01 LENOVO TP-G5    00002560 PTL 00000002)
Mar 22 15:38:36 Miraculix kernel: [    0.000000] ACPI: ASF! 
00000000df7e7000 0000A5 (v32 LENOVO TP-G5    00002560 PTL 00000002)
Mar 22 15:38:36 Miraculix kernel: [    0.000000] ACPI: UEFI 
00000000df7df000 00003E (v01 LENOVO TP-G5    00002560 PTL 00000002)
Mar 22 15:38:36 Miraculix kernel: [    0.000000] ACPI: UEFI 
00000000df7de000 000042 (v01 PTL      COMBUF 00000001 PTL 00000001)
Mar 22 15:38:36 Miraculix kernel: [    0.000000] ACPI: MSDM 
00000000df7dd000 000055 (v03 LENOVO TP-G5    00002560 PTL 00000002)
Mar 22 15:38:36 Miraculix kernel: [    0.000000] ACPI: SSDT 
00000000df7dc000 000D23 (v01  PmRef  Cpu0Ist 00003000 INTL 20061109)
Mar 22 15:38:36 Miraculix kernel: [    0.000000] ACPI: SSDT 
00000000df7db000 000A83 (v01  PmRef    CpuPm 00003000 INTL 20061109)
Mar 22 15:38:36 Miraculix kernel: [    0.000000] ACPI: UEFI 
00000000df7da000 0002A6 (v01 LENOVO TP-G5    00002560 PTL 00000002)
Mar 22 15:38:36 Miraculix kernel: [    0.000000] ACPI: DBG2 
00000000df7d9000 0000E9 (v00 LENOVO TP-G5    00002560 PTL 00000002)
Mar 22 15:38:36 Miraculix kernel: [    0.000000] ACPI: Local APIC 
address 0xfee00000
Mar 22 15:38:36 Miraculix kernel: [    0.000000] No NUMA configuration found
Mar 22 15:38:36 Miraculix kernel: [    0.000000] Faking a node at [mem 
0x0000000000000000-0x000000041dffffff]
Mar 22 15:38:36 Miraculix kernel: [    0.000000] Initmem setup node 0 
[mem 0x00000000-0x41dffffff]
Mar 22 15:38:36 Miraculix kernel: [    0.000000]   NODE_DATA [mem 
0x41dfed000-0x41dff1fff]
Mar 22 15:38:36 Miraculix kernel: [    0.000000] 
[ffffea0000000000-ffffea00107fffff] PMD -> 
[ffff88040da00000-ffff88041d5fffff] on node 0
Mar 22 15:38:36 Miraculix kernel: [    0.000000] Zone ranges:
Mar 22 15:38:36 Miraculix kernel: [    0.000000]   DMA      [mem 
0x00001000-0x00ffffff]
Mar 22 15:38:36 Miraculix kernel: [    0.000000]   DMA32    [mem 
0x01000000-0xffffffff]
Mar 22 15:38:36 Miraculix kernel: [    0.000000]   Normal   [mem 
0x100000000-0x41dffffff]
Mar 22 15:38:36 Miraculix kernel: [    0.000000] Movable zone start for 
each node
Mar 22 15:38:36 Miraculix kernel: [    0.000000] Early memory node ranges
Mar 22 15:38:36 Miraculix kernel: [    0.000000]   node   0: [mem 
0x00001000-0x0009cfff]
Mar 22 15:38:36 Miraculix kernel: [    0.000000]   node   0: [mem 
0x00100000-0xcb32ffff]
Mar 22 15:38:36 Miraculix kernel: [    0.000000]   node   0: [mem 
0x100000000-0x41dffffff]
Mar 22 15:38:36 Miraculix kernel: [    0.000000] On node 0 totalpages: 
4100812
Mar 22 15:38:36 Miraculix kernel: [    0.000000]   DMA zone: 64 pages 
used for memmap
Mar 22 15:38:36 Miraculix kernel: [    0.000000]   DMA zone: 21 pages 
reserved
Mar 22 15:38:36 Miraculix kernel: [    0.000000]   DMA zone: 3996 pages, 
LIFO batch:0
Mar 22 15:38:36 Miraculix kernel: [    0.000000]   DMA32 zone: 12941 
pages used for memmap
Mar 22 15:38:36 Miraculix kernel: [    0.000000]   DMA32 zone: 828208 
pages, LIFO batch:31
Mar 22 15:38:36 Miraculix kernel: [    0.000000]   Normal zone: 51072 
pages used for memmap
Mar 22 15:38:36 Miraculix kernel: [    0.000000]   Normal zone: 3268608 
pages, LIFO batch:31
Mar 22 15:38:36 Miraculix kernel: [    0.000000] ACPI: PM-Timer IO Port: 
0x408
Mar 22 15:38:36 Miraculix kernel: [    0.000000] ACPI: Local APIC 
address 0xfee00000
Mar 22 15:38:36 Miraculix kernel: [    0.000000] ACPI: LAPIC 
(acpi_id[0x01] lapic_id[0x00] enabled)
Mar 22 15:38:36 Miraculix kernel: [    0.000000] ACPI: LAPIC 
(acpi_id[0x02] lapic_id[0x01] enabled)
Mar 22 15:38:36 Miraculix kernel: [    0.000000] ACPI: LAPIC 
(acpi_id[0x03] lapic_id[0x02] enabled)
Mar 22 15:38:36 Miraculix kernel: [    0.000000] ACPI: LAPIC 
(acpi_id[0x04] lapic_id[0x03] enabled)
Mar 22 15:38:36 Miraculix kernel: [    0.000000] ACPI: LAPIC 
(acpi_id[0x05] lapic_id[0x04] enabled)
Mar 22 15:38:36 Miraculix kernel: [    0.000000] ACPI: LAPIC 
(acpi_id[0x06] lapic_id[0x05] enabled)
Mar 22 15:38:36 Miraculix kernel: [    0.000000] ACPI: LAPIC 
(acpi_id[0x07] lapic_id[0x06] enabled)
Mar 22 15:38:36 Miraculix kernel: [    0.000000] ACPI: LAPIC 
(acpi_id[0x08] lapic_id[0x07] enabled)
Mar 22 15:38:36 Miraculix kernel: [    0.000000] ACPI: LAPIC_NMI 
(acpi_id[0x00] high edge lint[0x1])
Mar 22 15:38:36 Miraculix kernel: [    0.000000] ACPI: LAPIC_NMI 
(acpi_id[0x01] high edge lint[0x1])
Mar 22 15:38:36 Miraculix kernel: [    0.000000] ACPI: IOAPIC (id[0x02] 
address[0xfec00000] gsi_base[0])
Mar 22 15:38:36 Miraculix kernel: [    0.000000] IOAPIC[0]: apic_id 2, 
version 32, address 0xfec00000, GSI 0-23
Mar 22 15:38:36 Miraculix kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 
0 bus_irq 0 global_irq 2 dfl dfl)
Mar 22 15:38:36 Miraculix kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 
0 bus_irq 9 global_irq 9 high level)
Mar 22 15:38:36 Miraculix kernel: [    0.000000] ACPI: IRQ0 used by 
override.
Mar 22 15:38:36 Miraculix kernel: [    0.000000] ACPI: IRQ2 used by 
override.
Mar 22 15:38:36 Miraculix kernel: [    0.000000] ACPI: IRQ9 used by 
override.
Mar 22 15:38:36 Miraculix kernel: [    0.000000] Using ACPI (MADT) for 
SMP configuration information
Mar 22 15:38:36 Miraculix kernel: [    0.000000] ACPI: HPET id: 
0x8086a301 base: 0xfed00000
Mar 22 15:38:36 Miraculix kernel: [    0.000000] smpboot: Allowing 8 
CPUs, 0 hotplug CPUs
Mar 22 15:38:36 Miraculix kernel: [    0.000000] nr_irqs_gsi: 40
Mar 22 15:38:36 Miraculix kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0x0009d000-0x0009dfff]
Mar 22 15:38:36 Miraculix kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0x0009e000-0x0009ffff]
Mar 22 15:38:36 Miraculix kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0x000a0000-0x000dffff]
Mar 22 15:38:36 Miraculix kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0x000e0000-0x000fffff]
Mar 22 15:38:36 Miraculix kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0xcb330000-0xdf69efff]
Mar 22 15:38:36 Miraculix kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0xdf69f000-0xdf79efff]
Mar 22 15:38:36 Miraculix kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0xdf79f000-0xdf7fefff]
Mar 22 15:38:36 Miraculix kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0xdf7ff000-0xdfffffff]
Mar 22 15:38:36 Miraculix kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0xe0000000-0xf7ffffff]
Mar 22 15:38:36 Miraculix kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0xf8000000-0xfbffffff]
Mar 22 15:38:36 Miraculix kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0xfc000000-0xfebfffff]
Mar 22 15:38:36 Miraculix kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0xfec00000-0xfec00fff]
Mar 22 15:38:36 Miraculix kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0xfec01000-0xfed07fff]
Mar 22 15:38:36 Miraculix kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0xfed08000-0xfed08fff]
Mar 22 15:38:36 Miraculix kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0xfed09000-0xfed0ffff]
Mar 22 15:38:36 Miraculix kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0xfed10000-0xfed19fff]
Mar 22 15:38:36 Miraculix kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0xfed1a000-0xfed1bfff]
Mar 22 15:38:36 Miraculix kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0xfed1c000-0xfed1ffff]
Mar 22 15:38:36 Miraculix kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0xfed20000-0xfedfffff]
Mar 22 15:38:36 Miraculix kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0xfee00000-0xfee00fff]
Mar 22 15:38:36 Miraculix kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0xfee01000-0xffbfffff]
Mar 22 15:38:36 Miraculix kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0xffc00000-0xffffffff]
Mar 22 15:38:36 Miraculix kernel: [    0.000000] e820: [mem 
0xe0000000-0xf7ffffff] available for PCI devices
Mar 22 15:38:36 Miraculix kernel: [    0.000000] Booting paravirtualized 
kernel on bare hardware
Mar 22 15:38:36 Miraculix kernel: [    0.000000] setup_percpu: 
NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:8 nr_node_ids:1
Mar 22 15:38:36 Miraculix kernel: [    0.000000] PERCPU: Embedded 29 
pages/cpu @ffff88041dc00000 s86528 r8192 d24064 u262144
Mar 22 15:38:36 Miraculix kernel: [    0.000000] pcpu-alloc: s86528 
r8192 d24064 u262144 alloc=1*2097152
Mar 22 15:38:36 Miraculix kernel: [    0.000000] pcpu-alloc: [0] 0 1 2 3 
4 5 6 7
Mar 22 15:38:36 Miraculix kernel: [    0.000000] Built 1 zonelists in 
Zone order, mobility grouping on.  Total pages: 4036714
Mar 22 15:38:36 Miraculix kernel: [    0.000000] Policy zone: Normal
Mar 22 15:38:36 Miraculix kernel: [    0.000000] Kernel command line: 
BOOT_IMAGE=/vmlinuz-3.14.0-031400rc7-generic 
root=UUID=16cf338b-a7ee-4688-a7b5-ce4251061783 ro quiet splash vt.handoff=7
Mar 22 15:38:36 Miraculix kernel: [    0.000000] PID hash table entries: 
4096 (order: 3, 32768 bytes)
Mar 22 15:38:36 Miraculix kernel: [    0.000000] xsave: enabled 
xstate_bv 0x7, cntxt size 0x340
Mar 22 15:38:36 Miraculix kernel: [    0.000000] Checking aperture...
Mar 22 15:38:36 Miraculix kernel: [    0.000000] No AGP bridge found
Mar 22 15:38:36 Miraculix kernel: [    0.000000] Calgary: detecting 
Calgary via BIOS EBDA area
Mar 22 15:38:36 Miraculix kernel: [    0.000000] Calgary: Unable to 
locate Rio Grande table in EBDA - bailing!
Mar 22 15:38:36 Miraculix kernel: [    0.000000] Memory: 
16026900K/16403248K available (7639K kernel code, 1109K rwdata, 3592K 
rodata, 1360K init, 1432K bss, 376348K reserved)
Mar 22 15:38:36 Miraculix kernel: [    0.000000] SLUB: HWalign=64, 
Order=0-3, MinObjects=0, CPUs=8, Nodes=1
Mar 22 15:38:36 Miraculix kernel: [    0.000000] Hierarchical RCU 
implementation.
Mar 22 15:38:36 Miraculix kernel: [    0.000000]     RCU dyntick-idle 
grace-period acceleration is enabled.
Mar 22 15:38:36 Miraculix kernel: [    0.000000]     RCU restricting 
CPUs from NR_CPUS=256 to nr_cpu_ids=8.
Mar 22 15:38:36 Miraculix kernel: [    0.000000]     Offload RCU 
callbacks from all CPUs
Mar 22 15:38:36 Miraculix kernel: [    0.000000]     Offload RCU 
callbacks from CPUs: 0-7.
Mar 22 15:38:36 Miraculix kernel: [    0.000000] RCU: Adjusting geometry 
for rcu_fanout_leaf=16, nr_cpu_ids=8
Mar 22 15:38:36 Miraculix kernel: [    0.000000] NR_IRQS:16640 
nr_irqs:744 16
Mar 22 15:38:36 Miraculix kernel: [    0.000000] Console: colour dummy 
device 80x25
Mar 22 15:38:36 Miraculix kernel: [    0.000000] console [tty0] enabled
Mar 22 15:38:36 Miraculix kernel: [    0.000000] allocated 66060288 
bytes of page_cgroup
Mar 22 15:38:36 Miraculix kernel: [    0.000000] please try 
'cgroup_disable=memory' option if you don't want memory cgroups
Mar 22 15:38:36 Miraculix kernel: [    0.000000] hpet clockevent registered
Mar 22 15:38:36 Miraculix kernel: [    0.000000] tsc: Fast TSC 
calibration using PIT
Mar 22 15:38:36 Miraculix kernel: [    0.000000] tsc: Detected 2693.742 
MHz processor
Mar 22 15:38:36 Miraculix kernel: [    0.000031] Calibrating delay loop 
(skipped), value calculated using timer frequency.. 5387.48 BogoMIPS 
(lpj=10774968)
Mar 22 15:38:36 Miraculix kernel: [    0.000033] pid_max: default: 32768 
minimum: 301
Mar 22 15:38:36 Miraculix kernel: [    0.000039] ACPI: Core revision 
20131218
Mar 22 15:38:36 Miraculix kernel: [    0.005962] ACPI: All ACPI Tables 
successfully acquired
Mar 22 15:38:36 Miraculix kernel: [    0.007270] Security Framework 
initialized
Mar 22 15:38:36 Miraculix kernel: [    0.007281] AppArmor: AppArmor 
initialized
Mar 22 15:38:36 Miraculix kernel: [    0.007281] Yama: becoming mindful.
Mar 22 15:38:36 Miraculix kernel: [    0.008259] Dentry cache hash table 
entries: 2097152 (order: 12, 16777216 bytes)
Mar 22 15:38:36 Miraculix kernel: [    0.011899] Inode-cache hash table 
entries: 1048576 (order: 11, 8388608 bytes)
Mar 22 15:38:36 Miraculix kernel: [    0.013496] Mount-cache hash table 
entries: 256
Mar 22 15:38:36 Miraculix kernel: [    0.013643] Initializing cgroup 
subsys memory
Mar 22 15:38:36 Miraculix kernel: [    0.013648] Initializing cgroup 
subsys devices
Mar 22 15:38:36 Miraculix kernel: [    0.013649] Initializing cgroup 
subsys freezer
Mar 22 15:38:36 Miraculix kernel: [    0.013651] Initializing cgroup 
subsys net_cls
Mar 22 15:38:36 Miraculix kernel: [    0.013652] Initializing cgroup 
subsys blkio
Mar 22 15:38:36 Miraculix kernel: [    0.013653] Initializing cgroup 
subsys perf_event
Mar 22 15:38:36 Miraculix kernel: [    0.013655] Initializing cgroup 
subsys hugetlb
Mar 22 15:38:36 Miraculix kernel: [    0.013677] CPU: Physical Processor 
ID: 0
Mar 22 15:38:36 Miraculix kernel: [    0.013678] CPU: Processor Core ID: 0
Mar 22 15:38:36 Miraculix kernel: [    0.013682] ENERGY_PERF_BIAS: Set 
to 'normal', was 'performance'
Mar 22 15:38:36 Miraculix kernel: [    0.013682] ENERGY_PERF_BIAS: View 
and update with x86_energy_perf_policy(8)
Mar 22 15:38:36 Miraculix kernel: [    0.014011] mce: CPU supports 9 MCE 
banks
Mar 22 15:38:36 Miraculix kernel: [    0.014023] CPU0: Thermal 
monitoring enabled (TM1)
Mar 22 15:38:36 Miraculix kernel: [    0.014034] Last level iTLB 
entries: 4KB 512, 2MB 8, 4MB 8
Mar 22 15:38:36 Miraculix kernel: [    0.014034] Last level dTLB 
entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
Mar 22 15:38:36 Miraculix kernel: [    0.014034] tlb_flushall_shift: 2
Mar 22 15:38:36 Miraculix kernel: [    0.014139] Freeing SMP 
alternatives memory: 28K (ffffffff81e6b000 - ffffffff81e72000)
Mar 22 15:38:36 Miraculix kernel: [    0.015210] ftrace: allocating 
31501 entries in 124 pages
Mar 22 15:38:36 Miraculix kernel: [    0.028916] ..TIMER: vector=0x30 
apic1=0 pin1=2 apic2=-1 pin2=-1
Mar 22 15:38:36 Miraculix kernel: [    0.068585] smpboot: CPU0: Intel(R) 
Core(TM) i7-3740QM CPU @ 2.70GHz (fam: 06, model: 3a, stepping: 09)
Mar 22 15:38:36 Miraculix kernel: [    0.068595] TSC deadline timer enabled
Mar 22 15:38:36 Miraculix kernel: [    0.070641] Performance Events: 
PEBS fmt1+, 16-deep LBR, IvyBridge events, full-width counters, Intel 
PMU driver.
Mar 22 15:38:36 Miraculix kernel: [    0.070648] ... 
version:                3
Mar 22 15:38:36 Miraculix kernel: [    0.070649] ... bit 
width:              48
Mar 22 15:38:36 Miraculix kernel: [    0.070650] ... generic 
registers:      4
Mar 22 15:38:36 Miraculix kernel: [    0.070651] ... value 
mask:             0000ffffffffffff
Mar 22 15:38:36 Miraculix kernel: [    0.070652] ... max 
period:             0000ffffffffffff
Mar 22 15:38:36 Miraculix kernel: [    0.070652] ... fixed-purpose 
events:   3
Mar 22 15:38:36 Miraculix kernel: [    0.070653] ... event 
mask:             000000070000000f
Mar 22 15:38:36 Miraculix kernel: [    0.072026] x86: Booting SMP 
configuration:
Mar 22 15:38:36 Miraculix kernel: [    0.072027] .... node  #0, 
CPUs:      #1
Mar 22 15:38:36 Miraculix kernel: [    0.085471] NMI watchdog: enabled 
on all CPUs, permanently consumes one hw-PMU counter.
Mar 22 15:38:36 Miraculix kernel: [    0.085553]  #2 #3 #4 #5 #6 #7
Mar 22 15:38:36 Miraculix kernel: [    0.166616] x86: Booted up 1 node, 
8 CPUs
Mar 22 15:38:36 Miraculix kernel: [    0.166620] smpboot: Total of 8 
processors activated (43099.87 BogoMIPS)
Mar 22 15:38:36 Miraculix kernel: [    0.173661] devtmpfs: initialized
Mar 22 15:38:36 Miraculix kernel: [    0.178448] EVM: security.selinux
Mar 22 15:38:36 Miraculix kernel: [    0.178450] EVM: security.SMACK64
Mar 22 15:38:36 Miraculix kernel: [    0.178450] EVM: security.ima
Mar 22 15:38:36 Miraculix kernel: [    0.178451] EVM: security.capability
Mar 22 15:38:36 Miraculix kernel: [    0.178493] PM: Registering ACPI 
NVS region [mem 0xdf69f000-0xdf79efff] (1048576 bytes)
Mar 22 15:38:36 Miraculix kernel: [    0.179214] pinctrl core: 
initialized pinctrl subsystem
Mar 22 15:38:36 Miraculix kernel: [    0.179271] regulator-dummy: no 
parameters
Mar 22 15:38:36 Miraculix kernel: [    0.179305] RTC time: 14:37:59, 
date: 03/22/14
Mar 22 15:38:36 Miraculix kernel: [    0.179333] NET: Registered 
protocol family 16
Mar 22 15:38:36 Miraculix kernel: [    0.179438] cpuidle: using governor 
ladder
Mar 22 15:38:36 Miraculix kernel: [    0.179439] cpuidle: using governor 
menu
Mar 22 15:38:36 Miraculix kernel: [    0.179471] ACPI FADT declares the 
system doesn't support PCIe ASPM, so disable it
Mar 22 15:38:36 Miraculix kernel: [    0.179473] ACPI: bus type PCI 
registered
Mar 22 15:38:36 Miraculix kernel: [    0.179474] acpiphp: ACPI Hot Plug 
PCI Controller Driver version: 0.5
Mar 22 15:38:36 Miraculix kernel: [    0.179670] PCI: MMCONFIG for 
domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
Mar 22 15:38:36 Miraculix kernel: [    0.179672] PCI: MMCONFIG at [mem 
0xf8000000-0xfbffffff] reserved in E820
Mar 22 15:38:36 Miraculix kernel: [    0.183271] PCI: Using 
configuration type 1 for base access
Mar 22 15:38:36 Miraculix kernel: [    0.183633] mtrr: your CPUs had 
inconsistent variable MTRR settings
Mar 22 15:38:36 Miraculix kernel: [    0.183634] mtrr: probably your 
BIOS does not setup all CPUs.
Mar 22 15:38:36 Miraculix kernel: [    0.183635] mtrr: corrected 
configuration.
Mar 22 15:38:36 Miraculix kernel: [    0.184470] bio: create slab 
<bio-0> at 0
Mar 22 15:38:36 Miraculix kernel: [    0.184602] ACPI: Added _OSI(Module 
Device)
Mar 22 15:38:36 Miraculix kernel: [    0.184603] ACPI: Added 
_OSI(Processor Device)
Mar 22 15:38:36 Miraculix kernel: [    0.184604] ACPI: Added _OSI(3.0 
_SCP Extensions)
Mar 22 15:38:36 Miraculix kernel: [    0.184605] ACPI: Added 
_OSI(Processor Aggregator Device)
Mar 22 15:38:36 Miraculix kernel: [    0.186201] ACPI : EC: EC 
description table is found, configuring boot EC
Mar 22 15:38:36 Miraculix kernel: [    0.190310] [Firmware Bug]: ACPI: 
BIOS _OSI(Linux) query ignored
Mar 22 15:38:36 Miraculix kernel: [    0.201990] ACPI: SSDT 
00000000df63a018 000A01 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
Mar 22 15:38:36 Miraculix kernel: [    0.202391] ACPI: Dynamic OEM Table 
Load:
Mar 22 15:38:36 Miraculix kernel: [    0.202393] ACPI: SSDT           
(null) 000A01 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
Mar 22 15:38:36 Miraculix kernel: [    0.205669] ACPI: SSDT 
00000000df63ba98 000303 (v01  PmRef    ApIst 00003000 INTL 20061109)
Mar 22 15:38:36 Miraculix kernel: [    0.206097] ACPI: Dynamic OEM Table 
Load:
Mar 22 15:38:36 Miraculix kernel: [    0.206099] ACPI: SSDT           
(null) 000303 (v01  PmRef    ApIst 00003000 INTL 20061109)
Mar 22 15:38:36 Miraculix kernel: [    0.209549] ACPI: SSDT 
00000000df639d98 000119 (v01  PmRef    ApCst 00003000 INTL 20061109)
Mar 22 15:38:36 Miraculix kernel: [    0.209945] ACPI: Dynamic OEM Table 
Load:
Mar 22 15:38:36 Miraculix kernel: [    0.209946] ACPI: SSDT           
(null) 000119 (v01  PmRef    ApCst 00003000 INTL 20061109)
Mar 22 15:38:36 Miraculix kernel: [    0.214486] ACPI: Interpreter enabled
Mar 22 15:38:36 Miraculix kernel: [    0.214491] ACPI Exception: 
AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20131218/hwxface-580)
Mar 22 15:38:36 Miraculix kernel: [    0.214495] ACPI Exception: 
AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20131218/hwxface-580)
Mar 22 15:38:36 Miraculix kernel: [    0.214506] ACPI: (supports S0 S3 
S4 S5)
Mar 22 15:38:36 Miraculix kernel: [    0.214507] ACPI: Using IOAPIC for 
interrupt routing
Mar 22 15:38:36 Miraculix kernel: [    0.214528] PCI: Using host bridge 
windows from ACPI; if necessary, use "pci=nocrs" and report a bug
Mar 22 15:38:36 Miraculix kernel: [    0.215171] ACPI: ACPI Dock Station 
Driver: 2 docks/bays found
Mar 22 15:38:36 Miraculix kernel: [    0.221916] ACPI: Power Resource 
[PUBS] (on)
Mar 22 15:38:36 Miraculix kernel: [    0.226221] ACPI: PCI Interrupt 
Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
Mar 22 15:38:36 Miraculix kernel: [    0.226294] ACPI: PCI Interrupt 
Link [LNKB] (IRQs 3 4 5 6 *7 9 10 11)
Mar 22 15:38:36 Miraculix kernel: [    0.226362] ACPI: PCI Interrupt 
Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
Mar 22 15:38:36 Miraculix kernel: [    0.226431] ACPI: PCI Interrupt 
Link [LNKD] (IRQs 3 4 5 6 7 9 *10 11)
Mar 22 15:38:36 Miraculix kernel: [    0.226500] ACPI: PCI Interrupt 
Link [LNKE] (IRQs 3 4 5 6 *7 9 10 11)
Mar 22 15:38:36 Miraculix kernel: [    0.226557] ACPI: PCI Interrupt 
Link [LNKF] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
Mar 22 15:38:36 Miraculix kernel: [    0.226628] ACPI: PCI Interrupt 
Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
Mar 22 15:38:36 Miraculix kernel: [    0.226695] ACPI: PCI Interrupt 
Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11)
Mar 22 15:38:36 Miraculix kernel: [    0.226723] ACPI: PCI Root Bridge 
[PCI0] (domain 0000 [bus 00-3f])
Mar 22 15:38:36 Miraculix kernel: [    0.226727] acpi PNP0A08:00: _OSC: 
OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
Mar 22 15:38:36 Miraculix kernel: [    0.226818] acpi PNP0A08:00: _OSC: 
platform does not support [PCIeCapability]
Mar 22 15:38:36 Miraculix kernel: [    0.226857] acpi PNP0A08:00: _OSC: 
not requesting control; platform does not support [PCIeCapability]
Mar 22 15:38:36 Miraculix kernel: [    0.226859] acpi PNP0A08:00: _OSC: 
OS requested [PCIeHotplug PME AER PCIeCapability]
Mar 22 15:38:36 Miraculix kernel: [    0.226861] acpi PNP0A08:00: _OSC: 
platform willing to grant [PCIeHotplug PME AER]
Mar 22 15:38:36 Miraculix kernel: [    0.226863] acpi PNP0A08:00: _OSC 
failed (AE_SUPPORT); disabling ASPM
Mar 22 15:38:36 Miraculix kernel: [    0.227008] PCI host bridge to bus 
0000:00
Mar 22 15:38:36 Miraculix kernel: [    0.227011] pci_bus 0000:00: root 
bus resource [bus 00-3f]
Mar 22 15:38:36 Miraculix kernel: [    0.227013] pci_bus 0000:00: root 
bus resource [io  0x0000-0x0cf7]
Mar 22 15:38:36 Miraculix kernel: [    0.227014] pci_bus 0000:00: root 
bus resource [io  0x0d00-0xffff]
Mar 22 15:38:36 Miraculix kernel: [    0.227016] pci_bus 0000:00: root 
bus resource [mem 0x000a0000-0x000bffff]
Mar 22 15:38:36 Miraculix kernel: [    0.227017] pci_bus 0000:00: root 
bus resource [mem 0xe0000000-0xfebfffff]
Mar 22 15:38:36 Miraculix kernel: [    0.227019] pci_bus 0000:00: root 
bus resource [mem 0xfed40000-0xfed4bfff]
Mar 22 15:38:36 Miraculix kernel: [    0.227025] pci 0000:00:00.0: 
[8086:0154] type 00 class 0x060000
Mar 22 15:38:36 Miraculix kernel: [    0.227095] pci 0000:00:01.0: 
[8086:0151] type 01 class 0x060400
Mar 22 15:38:36 Miraculix kernel: [    0.227126] pci 0000:00:01.0: PME# 
supported from D0 D3hot D3cold
Mar 22 15:38:36 Miraculix kernel: [    0.227207] pci 0000:00:14.0: 
[8086:1e31] type 00 class 0x0c0330
Mar 22 15:38:36 Miraculix kernel: [    0.227231] pci 0000:00:14.0: reg 
0x10: [mem 0xf5320000-0xf532ffff 64bit]
Mar 22 15:38:36 Miraculix kernel: [    0.227303] pci 0000:00:14.0: PME# 
supported from D3hot D3cold
Mar 22 15:38:36 Miraculix kernel: [    0.227329] pci 0000:00:14.0: 
System wakeup disabled by ACPI
Mar 22 15:38:36 Miraculix kernel: [    0.227367] pci 0000:00:16.0: 
[8086:1e3a] type 00 class 0x078000
Mar 22 15:38:36 Miraculix kernel: [    0.227388] pci 0000:00:16.0: reg 
0x10: [mem 0xf5335000-0xf533500f 64bit]
Mar 22 15:38:36 Miraculix kernel: [    0.227452] pci 0000:00:16.0: PME# 
supported from D0 D3hot D3cold
Mar 22 15:38:36 Miraculix kernel: [    0.227508] pci 0000:00:16.3: 
[8086:1e3d] type 00 class 0x070002
Mar 22 15:38:36 Miraculix kernel: [    0.227524] pci 0000:00:16.3: reg 
0x10: [io  0x6070-0x6077]
Mar 22 15:38:36 Miraculix kernel: [    0.227533] pci 0000:00:16.3: reg 
0x14: [mem 0xf533c000-0xf533cfff]
Mar 22 15:38:36 Miraculix kernel: [    0.227652] pci 0000:00:19.0: 
[8086:1502] type 00 class 0x020000
Mar 22 15:38:36 Miraculix kernel: [    0.227670] pci 0000:00:19.0: reg 
0x10: [mem 0xf5300000-0xf531ffff]
Mar 22 15:38:36 Miraculix kernel: [    0.227678] pci 0000:00:19.0: reg 
0x14: [mem 0xf533b000-0xf533bfff]
Mar 22 15:38:36 Miraculix kernel: [    0.227686] pci 0000:00:19.0: reg 
0x18: [io  0x6040-0x605f]
Mar 22 15:38:36 Miraculix kernel: [    0.227748] pci 0000:00:19.0: PME# 
supported from D0 D3hot D3cold
Mar 22 15:38:36 Miraculix kernel: [    0.227775] pci 0000:00:19.0: 
System wakeup disabled by ACPI
Mar 22 15:38:36 Miraculix kernel: [    0.227816] pci 0000:00:1a.0: 
[8086:1e2d] type 00 class 0x0c0320
Mar 22 15:38:36 Miraculix kernel: [    0.227837] pci 0000:00:1a.0: reg 
0x10: [mem 0xf533a000-0xf533a3ff]
Mar 22 15:38:36 Miraculix kernel: [    0.227926] pci 0000:00:1a.0: PME# 
supported from D0 D3hot D3cold
Mar 22 15:38:36 Miraculix kernel: [    0.227954] pci 0000:00:1a.0: 
System wakeup disabled by ACPI
Mar 22 15:38:36 Miraculix kernel: [    0.227994] pci 0000:00:1b.0: 
[8086:1e20] type 00 class 0x040300
Mar 22 15:38:36 Miraculix kernel: [    0.228008] pci 0000:00:1b.0: reg 
0x10: [mem 0xf5330000-0xf5333fff 64bit]
Mar 22 15:38:36 Miraculix kernel: [    0.228083] pci 0000:00:1b.0: PME# 
supported from D0 D3hot D3cold
Mar 22 15:38:36 Miraculix kernel: [    0.228115] pci 0000:00:1b.0: 
System wakeup disabled by ACPI
Mar 22 15:38:36 Miraculix kernel: [    0.228157] pci 0000:00:1c.0: 
[8086:1e10] type 01 class 0x060400
Mar 22 15:38:36 Miraculix kernel: [    0.228292] pci 0000:00:1c.0: PME# 
supported from D0 D3hot D3cold
Mar 22 15:38:36 Miraculix kernel: [    0.228371] pci 0000:00:1c.1: 
[8086:1e12] type 01 class 0x060400
Mar 22 15:38:36 Miraculix kernel: [    0.228504] pci 0000:00:1c.1: PME# 
supported from D0 D3hot D3cold
Mar 22 15:38:36 Miraculix kernel: [    0.228581] pci 0000:00:1c.2: 
[8086:1e14] type 01 class 0x060400
Mar 22 15:38:36 Miraculix kernel: [    0.228715] pci 0000:00:1c.2: PME# 
supported from D0 D3hot D3cold
Mar 22 15:38:36 Miraculix kernel: [    0.228755] pci 0000:00:1c.2: 
System wakeup disabled by ACPI
Mar 22 15:38:36 Miraculix kernel: [    0.228799] pci 0000:00:1d.0: 
[8086:1e26] type 00 class 0x0c0320
Mar 22 15:38:36 Miraculix kernel: [    0.228820] pci 0000:00:1d.0: reg 
0x10: [mem 0xf5339000-0xf53393ff]
Mar 22 15:38:36 Miraculix kernel: [    0.228911] pci 0000:00:1d.0: PME# 
supported from D0 D3hot D3cold
Mar 22 15:38:36 Miraculix kernel: [    0.228939] pci 0000:00:1d.0: 
System wakeup disabled by ACPI
Mar 22 15:38:36 Miraculix kernel: [    0.228976] pci 0000:00:1f.0: 
[8086:1e55] type 00 class 0x060100
Mar 22 15:38:36 Miraculix kernel: [    0.229135] pci 0000:00:1f.2: 
[8086:1e03] type 00 class 0x010601
Mar 22 15:38:36 Miraculix kernel: [    0.229154] pci 0000:00:1f.2: reg 
0x10: [io  0x6068-0x606f]
Mar 22 15:38:36 Miraculix kernel: [    0.229162] pci 0000:00:1f.2: reg 
0x14: [io  0x607c-0x607f]
Mar 22 15:38:36 Miraculix kernel: [    0.229170] pci 0000:00:1f.2: reg 
0x18: [io  0x6060-0x6067]
Mar 22 15:38:36 Miraculix kernel: [    0.229178] pci 0000:00:1f.2: reg 
0x1c: [io  0x6078-0x607b]
Mar 22 15:38:36 Miraculix kernel: [    0.229186] pci 0000:00:1f.2: reg 
0x20: [io  0x6020-0x603f]
Mar 22 15:38:36 Miraculix kernel: [    0.229194] pci 0000:00:1f.2: reg 
0x24: [mem 0xf5338000-0xf53387ff]
Mar 22 15:38:36 Miraculix kernel: [    0.229240] pci 0000:00:1f.2: PME# 
supported from D3hot
Mar 22 15:38:36 Miraculix kernel: [    0.229297] pci 0000:00:1f.3: 
[8086:1e22] type 00 class 0x0c0500
Mar 22 15:38:36 Miraculix kernel: [    0.229313] pci 0000:00:1f.3: reg 
0x10: [mem 0xf5334000-0xf53340ff 64bit]
Mar 22 15:38:36 Miraculix kernel: [    0.229334] pci 0000:00:1f.3: reg 
0x20: [io  0xefa0-0xefbf]
Mar 22 15:38:36 Miraculix kernel: [    0.229447] pci 0000:01:00.0: 
[10de:0ffc] type 00 class 0x030000
Mar 22 15:38:36 Miraculix kernel: [    0.229463] pci 0000:01:00.0: reg 
0x10: [mem 0xf2000000-0xf2ffffff]
Mar 22 15:38:36 Miraculix kernel: [    0.229473] pci 0000:01:00.0: reg 
0x14: [mem 0xe0000000-0xefffffff 64bit pref]
Mar 22 15:38:36 Miraculix kernel: [    0.229483] pci 0000:01:00.0: reg 
0x1c: [mem 0xf0000000-0xf1ffffff 64bit pref]
Mar 22 15:38:36 Miraculix kernel: [    0.229491] pci 0000:01:00.0: reg 
0x24: [io  0x5000-0x507f]
Mar 22 15:38:36 Miraculix kernel: [    0.229498] pci 0000:01:00.0: reg 
0x30: [mem 0xfff80000-0xffffffff pref]
Mar 22 15:38:36 Miraculix kernel: [    0.229590] pci 0000:01:00.1: 
[10de:0e1b] type 00 class 0x040300
Mar 22 15:38:36 Miraculix kernel: [    0.229600] pci 0000:01:00.1: reg 
0x10: [mem 0xf3000000-0xf3003fff]
Mar 22 15:38:36 Miraculix kernel: [    1.237705] pci 0000:00:01.0: ASPM: 
Could not configure common clock
Mar 22 15:38:36 Miraculix kernel: [    1.237735] pci 0000:00:01.0: PCI 
bridge to [bus 01]
Mar 22 15:38:36 Miraculix kernel: [    1.237741] pci 0000:00:01.0:   
bridge window [io  0x5000-0x5fff]
Mar 22 15:38:36 Miraculix kernel: [    1.237755] pci 0000:00:01.0:   
bridge window [mem 0xf2000000-0xf30fffff]
Mar 22 15:38:36 Miraculix kernel: [    1.237758] pci 0000:00:01.0:   
bridge window [mem 0xe0000000-0xf1ffffff 64bit pref]
Mar 22 15:38:36 Miraculix kernel: [    1.237923] pci 0000:02:00.0: 
[1180:e823] type 00 class 0x088001
Mar 22 15:38:36 Miraculix kernel: [    1.237943] pci 0000:02:00.0: MMC 
controller base frequency changed to 50Mhz.
Mar 22 15:38:36 Miraculix kernel: [    1.237970] pci 0000:02:00.0: reg 
0x10: [mem 0xf4a01000-0xf4a010ff]
Mar 22 15:38:36 Miraculix kernel: [    1.238196] pci 0000:02:00.0: 
supports D1 D2
Mar 22 15:38:36 Miraculix kernel: [    1.238197] pci 0000:02:00.0: PME# 
supported from D0 D1 D2 D3hot D3cold
Mar 22 15:38:36 Miraculix kernel: [    1.238338] pci 0000:02:00.3: 
[1180:e832] type 00 class 0x0c0010
Mar 22 15:38:36 Miraculix kernel: [    1.238365] pci 0000:02:00.3: reg 
0x10: [mem 0xf4a00000-0xf4a007ff]
Mar 22 15:38:36 Miraculix kernel: [    1.238578] pci 0000:02:00.3: 
supports D1 D2
Mar 22 15:38:36 Miraculix kernel: [    1.238580] pci 0000:02:00.3: PME# 
supported from D0 D1 D2 D3hot D3cold
Mar 22 15:38:36 Miraculix kernel: [    1.245826] pci 0000:00:1c.0: PCI 
bridge to [bus 02]
Mar 22 15:38:36 Miraculix kernel: [    1.245831] pci 0000:00:1c.0:   
bridge window [io  0x4000-0x4fff]
Mar 22 15:38:36 Miraculix kernel: [    1.245835] pci 0000:00:1c.0:   
bridge window [mem 0xf4a00000-0xf52fffff]
Mar 22 15:38:36 Miraculix kernel: [    1.245843] pci 0000:00:1c.0:   
bridge window [mem 0xf3100000-0xf38fffff 64bit pref]
Mar 22 15:38:36 Miraculix kernel: [    1.246091] pci 0000:03:00.0: 
[8086:0085] type 00 class 0x028000
Mar 22 15:38:36 Miraculix kernel: [    1.246241] pci 0000:03:00.0: reg 
0x10: [mem 0xf4900000-0xf4901fff 64bit]
Mar 22 15:38:36 Miraculix kernel: [    1.247017] pci 0000:03:00.0: PME# 
supported from D0 D3hot D3cold
Mar 22 15:38:36 Miraculix kernel: [    1.253831] pci 0000:00:1c.1: PCI 
bridge to [bus 03]
Mar 22 15:38:36 Miraculix kernel: [    1.253840] pci 0000:00:1c.1:   
bridge window [mem 0xf4900000-0xf49fffff]
Mar 22 15:38:36 Miraculix kernel: [    1.253951] acpiphp: Slot [1] 
registered
Mar 22 15:38:36 Miraculix kernel: [    1.253961] pci 0000:00:1c.2: PCI 
bridge to [bus 04-0b]
Mar 22 15:38:36 Miraculix kernel: [    1.253966] pci 0000:00:1c.2:   
bridge window [io  0x3000-0x3fff]
Mar 22 15:38:36 Miraculix kernel: [    1.253971] pci 0000:00:1c.2:   
bridge window [mem 0xf4100000-0xf48fffff]
Mar 22 15:38:36 Miraculix kernel: [    1.253979] pci 0000:00:1c.2:   
bridge window [mem 0xf3900000-0xf40fffff 64bit pref]
Mar 22 15:38:36 Miraculix kernel: [    1.254638] ACPI: Enabled 4 GPEs in 
block 00 to 3F
Mar 22 15:38:36 Miraculix kernel: [    1.254694] ACPI : EC: GPE = 0x11, 
I/O: command/status = 0x66, data = 0x62
Mar 22 15:38:36 Miraculix kernel: [    1.254788] vgaarb: device added: 
PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
Mar 22 15:38:36 Miraculix kernel: [    1.254790] vgaarb: loaded
Mar 22 15:38:36 Miraculix kernel: [    1.254791] vgaarb: bridge control 
possible 0000:01:00.0
Mar 22 15:38:36 Miraculix kernel: [    1.254940] SCSI subsystem initialized
Mar 22 15:38:36 Miraculix kernel: [    1.254988] libata version 3.00 loaded.
Mar 22 15:38:36 Miraculix kernel: [    1.255007] ACPI: bus type USB 
registered
Mar 22 15:38:36 Miraculix kernel: [    1.255021] usbcore: registered new 
interface driver usbfs
Mar 22 15:38:36 Miraculix kernel: [    1.255028] usbcore: registered new 
interface driver hub
Mar 22 15:38:36 Miraculix kernel: [    1.255045] usbcore: registered new 
device driver usb
Mar 22 15:38:36 Miraculix kernel: [    1.255144] PCI: Using ACPI for IRQ 
routing
Mar 22 15:38:36 Miraculix kernel: [    1.256866] PCI: 
pci_cache_line_size set to 64 bytes
Mar 22 15:38:36 Miraculix kernel: [    1.257076] e820: reserve RAM 
buffer [mem 0x0009d800-0x0009ffff]
Mar 22 15:38:36 Miraculix kernel: [    1.257078] e820: reserve RAM 
buffer [mem 0xcb330000-0xcbffffff]
Mar 22 15:38:36 Miraculix kernel: [    1.257079] e820: reserve RAM 
buffer [mem 0x41e000000-0x41fffffff]
Mar 22 15:38:36 Miraculix kernel: [    1.257153] NetLabel: Initializing
Mar 22 15:38:36 Miraculix kernel: [    1.257154] NetLabel:  domain hash 
size = 128
Mar 22 15:38:36 Miraculix kernel: [    1.257155] NetLabel: protocols = 
UNLABELED CIPSOv4
Mar 22 15:38:36 Miraculix kernel: [    1.257166] NetLabel: unlabeled 
traffic allowed by default
Mar 22 15:38:36 Miraculix kernel: [    1.257216] hpet0: at MMIO 
0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
Mar 22 15:38:36 Miraculix kernel: [    1.257221] hpet0: 8 comparators, 
64-bit 14.318180 MHz counter
Mar 22 15:38:36 Miraculix kernel: [    1.260265] Switched to clocksource 
hpet
Mar 22 15:38:36 Miraculix kernel: [    1.264875] AppArmor: AppArmor 
Filesystem Enabled
Mar 22 15:38:36 Miraculix kernel: [    1.264898] pnp: PnP ACPI init
Mar 22 15:38:36 Miraculix kernel: [    1.264910] ACPI: bus type PNP 
registered
Mar 22 15:38:36 Miraculix kernel: [    1.265249] system 00:00: [mem 
0x00000000-0x0009ffff] could not be reserved
Mar 22 15:38:36 Miraculix kernel: [    1.265251] system 00:00: [mem 
0x000c0000-0x000c3fff] could not be reserved
Mar 22 15:38:36 Miraculix kernel: [    1.265253] system 00:00: [mem 
0x000c4000-0x000c7fff] could not be reserved
Mar 22 15:38:36 Miraculix kernel: [    1.265255] system 00:00: [mem 
0x000c8000-0x000cbfff] could not be reserved
Mar 22 15:38:36 Miraculix kernel: [    1.265256] system 00:00: [mem 
0x000cc000-0x000cffff] could not be reserved
Mar 22 15:38:36 Miraculix kernel: [    1.265258] system 00:00: [mem 
0x000d0000-0x000d3fff] has been reserved
Mar 22 15:38:36 Miraculix kernel: [    1.265259] system 00:00: [mem 
0x000d4000-0x000d7fff] has been reserved
Mar 22 15:38:36 Miraculix kernel: [    1.265261] system 00:00: [mem 
0x000d8000-0x000dbfff] has been reserved
Mar 22 15:38:36 Miraculix kernel: [    1.265262] system 00:00: [mem 
0x000dc000-0x000dffff] has been reserved
Mar 22 15:38:36 Miraculix kernel: [    1.265264] system 00:00: [mem 
0x000e0000-0x000e3fff] could not be reserved
Mar 22 15:38:36 Miraculix kernel: [    1.265266] system 00:00: [mem 
0x000e4000-0x000e7fff] could not be reserved
Mar 22 15:38:36 Miraculix kernel: [    1.265267] system 00:00: [mem 
0x000e8000-0x000ebfff] could not be reserved
Mar 22 15:38:36 Miraculix kernel: [    1.265269] system 00:00: [mem 
0x000ec000-0x000effff] could not be reserved
Mar 22 15:38:36 Miraculix kernel: [    1.265270] system 00:00: [mem 
0x000f0000-0x000fffff] could not be reserved
Mar 22 15:38:36 Miraculix kernel: [    1.265272] system 00:00: [mem 
0x00100000-0xdfffffff] could not be reserved
Mar 22 15:38:36 Miraculix kernel: [    1.265274] system 00:00: [mem 
0xfec00000-0xfed3ffff] could not be reserved
Mar 22 15:38:36 Miraculix kernel: [    1.265275] system 00:00: [mem 
0xfed4c000-0xffffffff] could not be reserved
Mar 22 15:38:36 Miraculix kernel: [    1.265278] system 00:00: Plug and 
Play ACPI device, IDs PNP0c01 (active)
Mar 22 15:38:36 Miraculix kernel: [    1.265350] pnp 00:01: disabling 
[mem 0xfffff000-0xffffffff] because it overlaps 0000:01:00.0 BAR 6 [mem 
0xfff80000-0xffffffff pref]
Mar 22 15:38:36 Miraculix kernel: [    1.265374] system 00:01: [io  
0x0400-0x047f] could not be reserved
Mar 22 15:38:36 Miraculix kernel: [    1.265375] system 00:01: [io  
0x0500-0x057f] has been reserved
Mar 22 15:38:36 Miraculix kernel: [    1.265377] system 00:01: [io  
0x0800-0x080f] has been reserved
Mar 22 15:38:36 Miraculix kernel: [    1.265379] system 00:01: [io  
0x15e0-0x15ef] has been reserved
Mar 22 15:38:36 Miraculix kernel: [    1.265382] system 00:01: [io  
0x1600-0x167f] has been reserved
Mar 22 15:38:36 Miraculix kernel: [    1.265384] system 00:01: [mem 
0xf8000000-0xfbffffff] has been reserved
Mar 22 15:38:36 Miraculix kernel: [    1.265386] system 00:01: [mem 
0xfed1c000-0xfed1ffff] has been reserved
Mar 22 15:38:36 Miraculix kernel: [    1.265387] system 00:01: [mem 
0xfed10000-0xfed13fff] has been reserved
Mar 22 15:38:36 Miraculix kernel: [    1.265389] system 00:01: [mem 
0xfed18000-0xfed18fff] has been reserved
Mar 22 15:38:36 Miraculix kernel: [    1.265391] system 00:01: [mem 
0xfed19000-0xfed19fff] has been reserved
Mar 22 15:38:36 Miraculix kernel: [    1.265392] system 00:01: [mem 
0xfed45000-0xfed4bfff] has been reserved
Mar 22 15:38:36 Miraculix kernel: [    1.265395] system 00:01: Plug and 
Play ACPI device, IDs PNP0c02 (active)
Mar 22 15:38:36 Miraculix kernel: [    1.265442] pnp 00:02: Plug and 
Play ACPI device, IDs PNP0103 (active)
Mar 22 15:38:36 Miraculix kernel: [    1.265449] pnp 00:03: [dma 4]
Mar 22 15:38:36 Miraculix kernel: [    1.265468] pnp 00:03: Plug and 
Play ACPI device, IDs PNP0200 (active)
Mar 22 15:38:36 Miraculix kernel: [    1.265487] pnp 00:04: Plug and 
Play ACPI device, IDs PNP0800 (active)
Mar 22 15:38:36 Miraculix kernel: [    1.265518] pnp 00:05: Plug and 
Play ACPI device, IDs PNP0c04 (active)
Mar 22 15:38:36 Miraculix kernel: [    1.265542] pnp 00:06: Plug and 
Play ACPI device, IDs PNP0b00 (active)
Mar 22 15:38:36 Miraculix kernel: [    1.265569] pnp 00:07: Plug and 
Play ACPI device, IDs LEN0071 PNP0303 (active)
Mar 22 15:38:36 Miraculix kernel: [    1.265595] pnp 00:08: Plug and 
Play ACPI device, IDs LEN0015 PNP0f13 (active)
Mar 22 15:38:36 Miraculix kernel: [    1.265635] pnp 00:09: Plug and 
Play ACPI device, IDs SMO1200 PNP0c31 (active)
Mar 22 15:38:36 Miraculix kernel: [    1.266131] pnp: PnP ACPI: found 10 
devices
Mar 22 15:38:36 Miraculix kernel: [    1.266133] ACPI: bus type PNP 
unregistered
Mar 22 15:38:36 Miraculix kernel: [    1.272905] pci 0000:01:00.0: no 
compatible bridge window for [mem 0xfff80000-0xffffffff pref]
Mar 22 15:38:36 Miraculix kernel: [    1.272954] pci 0000:01:00.0: BAR 
6: assigned [mem 0xf3080000-0xf30fffff pref]
Mar 22 15:38:36 Miraculix kernel: [    1.272956] pci 0000:00:01.0: PCI 
bridge to [bus 01]
Mar 22 15:38:36 Miraculix kernel: [    1.272958] pci 0000:00:01.0:   
bridge window [io  0x5000-0x5fff]
Mar 22 15:38:36 Miraculix kernel: [    1.272961] pci 0000:00:01.0:   
bridge window [mem 0xf2000000-0xf30fffff]
Mar 22 15:38:36 Miraculix kernel: [    1.272963] pci 0000:00:01.0:   
bridge window [mem 0xe0000000-0xf1ffffff 64bit pref]
Mar 22 15:38:36 Miraculix kernel: [    1.272967] pci 0000:00:1c.0: PCI 
bridge to [bus 02]
Mar 22 15:38:36 Miraculix kernel: [    1.272973] pci 0000:00:1c.0:   
bridge window [io  0x4000-0x4fff]
Mar 22 15:38:36 Miraculix kernel: [    1.272979] pci 0000:00:1c.0:   
bridge window [mem 0xf4a00000-0xf52fffff]
Mar 22 15:38:36 Miraculix kernel: [    1.272984] pci 0000:00:1c.0:   
bridge window [mem 0xf3100000-0xf38fffff 64bit pref]
Mar 22 15:38:36 Miraculix kernel: [    1.272992] pci 0000:00:1c.1: PCI 
bridge to [bus 03]
Mar 22 15:38:36 Miraculix kernel: [    1.272999] pci 0000:00:1c.1:   
bridge window [mem 0xf4900000-0xf49fffff]
Mar 22 15:38:36 Miraculix kernel: [    1.273011] pci 0000:00:1c.2: PCI 
bridge to [bus 04-0b]
Mar 22 15:38:36 Miraculix kernel: [    1.273014] pci 0000:00:1c.2:   
bridge window [io  0x3000-0x3fff]
Mar 22 15:38:36 Miraculix kernel: [    1.273021] pci 0000:00:1c.2:   
bridge window [mem 0xf4100000-0xf48fffff]
Mar 22 15:38:36 Miraculix kernel: [    1.273026] pci 0000:00:1c.2:   
bridge window [mem 0xf3900000-0xf40fffff 64bit pref]
Mar 22 15:38:36 Miraculix kernel: [    1.273035] pci_bus 0000:00: 
resource 4 [io  0x0000-0x0cf7]
Mar 22 15:38:36 Miraculix kernel: [    1.273037] pci_bus 0000:00: 
resource 5 [io  0x0d00-0xffff]
Mar 22 15:38:36 Miraculix kernel: [    1.273038] pci_bus 0000:00: 
resource 6 [mem 0x000a0000-0x000bffff]
Mar 22 15:38:36 Miraculix kernel: [    1.273040] pci_bus 0000:00: 
resource 7 [mem 0xe0000000-0xfebfffff]
Mar 22 15:38:36 Miraculix kernel: [    1.273041] pci_bus 0000:00: 
resource 8 [mem 0xfed40000-0xfed4bfff]
Mar 22 15:38:36 Miraculix kernel: [    1.273043] pci_bus 0000:01: 
resource 0 [io  0x5000-0x5fff]
Mar 22 15:38:36 Miraculix kernel: [    1.273045] pci_bus 0000:01: 
resource 1 [mem 0xf2000000-0xf30fffff]
Mar 22 15:38:36 Miraculix kernel: [    1.273046] pci_bus 0000:01: 
resource 2 [mem 0xe0000000-0xf1ffffff 64bit pref]
Mar 22 15:38:36 Miraculix kernel: [    1.273048] pci_bus 0000:02: 
resource 0 [io  0x4000-0x4fff]
Mar 22 15:38:36 Miraculix kernel: [    1.273049] pci_bus 0000:02: 
resource 1 [mem 0xf4a00000-0xf52fffff]
Mar 22 15:38:36 Miraculix kernel: [    1.273051] pci_bus 0000:02: 
resource 2 [mem 0xf3100000-0xf38fffff 64bit pref]
Mar 22 15:38:36 Miraculix kernel: [    1.273052] pci_bus 0000:03: 
resource 1 [mem 0xf4900000-0xf49fffff]
Mar 22 15:38:36 Miraculix kernel: [    1.273054] pci_bus 0000:04: 
resource 0 [io  0x3000-0x3fff]
Mar 22 15:38:36 Miraculix kernel: [    1.273055] pci_bus 0000:04: 
resource 1 [mem 0xf4100000-0xf48fffff]
Mar 22 15:38:36 Miraculix kernel: [    1.273057] pci_bus 0000:04: 
resource 2 [mem 0xf3900000-0xf40fffff 64bit pref]
Mar 22 15:38:36 Miraculix kernel: [    1.273081] NET: Registered 
protocol family 2
Mar 22 15:38:36 Miraculix kernel: [    1.273246] TCP established hash 
table entries: 131072 (order: 8, 1048576 bytes)
Mar 22 15:38:36 Miraculix kernel: [    1.273453] TCP bind hash table 
entries: 65536 (order: 8, 1048576 bytes)
Mar 22 15:38:36 Miraculix kernel: [    1.273570] TCP: Hash tables 
configured (established 131072 bind 65536)
Mar 22 15:38:36 Miraculix kernel: [    1.273583] TCP: reno registered
Mar 22 15:38:36 Miraculix kernel: [    1.273600] UDP hash table entries: 
8192 (order: 6, 262144 bytes)
Mar 22 15:38:36 Miraculix kernel: [    1.273648] UDP-Lite hash table 
entries: 8192 (order: 6, 262144 bytes)
Mar 22 15:38:36 Miraculix kernel: [    1.273721] NET: Registered 
protocol family 1
Mar 22 15:38:36 Miraculix kernel: [    1.274109] pci 0000:01:00.0: Boot 
video device
Mar 22 15:38:36 Miraculix kernel: [    1.274194] PCI: CLS 64 bytes, 
default 64
Mar 22 15:38:36 Miraculix kernel: [    1.274244] Trying to unpack rootfs 
image as initramfs...
Mar 22 15:38:36 Miraculix kernel: [    1.699375] Freeing initrd memory: 
34644K (ffff880033c46000 - ffff880035e1b000)
Mar 22 15:38:36 Miraculix kernel: [    1.699380] PCI-DMA: Using software 
bounce buffering for IO (SWIOTLB)
Mar 22 15:38:36 Miraculix kernel: [    1.699382] software IO TLB [mem 
0xc7330000-0xcb330000] (64MB) mapped at [ffff8800c7330000-ffff8800cb32ffff]
Mar 22 15:38:36 Miraculix kernel: [    1.699719] RAPL PMU detected, hw 
unit 2^-16 Joules, API unit is 2^-32 Joules, 3 fixed counters 163840 ms 
ovfl timer
Mar 22 15:38:36 Miraculix kernel: [    1.699763] Scanning for low memory 
corruption every 60 seconds
Mar 22 15:38:36 Miraculix kernel: [    1.700084] futex hash table 
entries: 2048 (order: 5, 131072 bytes)
Mar 22 15:38:36 Miraculix kernel: [    1.700102] Initialise system 
trusted keyring
Mar 22 15:38:36 Miraculix kernel: [    1.700159] audit: initializing 
netlink subsys (disabled)
Mar 22 15:38:36 Miraculix kernel: [    1.700172] audit: type=2000 
audit(1395499080.688:1): initialized
Mar 22 15:38:36 Miraculix kernel: [    1.726037] HugeTLB registered 2 MB 
page size, pre-allocated 0 pages
Mar 22 15:38:36 Miraculix kernel: [    1.727205] zbud: loaded
Mar 22 15:38:36 Miraculix kernel: [    1.727325] VFS: Disk quotas 
dquot_6.5.2
Mar 22 15:38:36 Miraculix kernel: [    1.727361] Dquot-cache hash table 
entries: 512 (order 0, 4096 bytes)
Mar 22 15:38:36 Miraculix kernel: [    1.727762] fuse init (API version 
7.22)
Mar 22 15:38:36 Miraculix kernel: [    1.727836] msgmni has been set to 
31370
Mar 22 15:38:36 Miraculix kernel: [    1.727882] Key type big_key registered
Mar 22 15:38:36 Miraculix kernel: [    2.695838] tsc: Refined TSC 
clocksource calibration: 2693.886 MHz
Mar 22 15:38:36 Miraculix kernel: [    4.171227] Key type asymmetric 
registered
Mar 22 15:38:36 Miraculix kernel: [    4.171227] Switched to clocksource tsc
Mar 22 15:38:36 Miraculix kernel: [    4.171231] Asymmetric key parser 
'x509' registered
Mar 22 15:38:36 Miraculix kernel: [    4.171281] Block layer SCSI 
generic (bsg) driver version 0.4 loaded (major 252)
Mar 22 15:38:36 Miraculix kernel: [    4.171308] io scheduler noop 
registered
Mar 22 15:38:36 Miraculix kernel: [    4.171310] io scheduler deadline 
registered (default)
Mar 22 15:38:36 Miraculix kernel: [    4.171337] io scheduler cfq registered
Mar 22 15:38:36 Miraculix kernel: [    4.171490] pcieport 0000:00:01.0: 
irq 40 for MSI/MSI-X
Mar 22 15:38:36 Miraculix kernel: [    4.171891] pci_hotplug: PCI Hot 
Plug PCI Core version: 0.5
Mar 22 15:38:36 Miraculix kernel: [    4.171904] pciehp: PCI Express Hot 
Plug Controller Driver version: 0.4
Mar 22 15:38:36 Miraculix kernel: [    4.171939] vesafb: mode is 
640x480x32, linelength=2560, pages=0
Mar 22 15:38:36 Miraculix kernel: [    4.171940] vesafb: scrolling: redraw
Mar 22 15:38:36 Miraculix kernel: [    4.171942] vesafb: Truecolor: 
size=8:8:8:8, shift=24:16:8:0
Mar 22 15:38:36 Miraculix kernel: [    4.172024] vesafb: framebuffer at 
0xf1000000, mapped to 0xffffc90005b80000, using 1216k, total 1216k
Mar 22 15:38:36 Miraculix kernel: [    4.186912] Console: switching to 
colour frame buffer device 80x30
Mar 22 15:38:36 Miraculix kernel: [    4.201739] fb0: VESA VGA frame 
buffer device
Mar 22 15:38:36 Miraculix kernel: [    4.201754] intel_idle: MWAIT 
substates: 0x21120
Mar 22 15:38:36 Miraculix kernel: [    4.201755] intel_idle: v0.4 model 0x3A
Mar 22 15:38:36 Miraculix kernel: [    4.201756] intel_idle: 
lapic_timer_reliable_states 0xffffffff
Mar 22 15:38:36 Miraculix kernel: [    4.202393] ACPI: AC Adapter [AC] 
(on-line)
Mar 22 15:38:36 Miraculix kernel: [    4.202444] input: Lid Switch as 
/devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
Mar 22 15:38:36 Miraculix kernel: [    4.202550] ACPI: Lid Switch [LID]
Mar 22 15:38:36 Miraculix kernel: [    4.202584] input: Sleep Button as 
/devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
Mar 22 15:38:36 Miraculix kernel: [    4.202588] ACPI: Sleep Button [SLPB]
Mar 22 15:38:36 Miraculix kernel: [    4.202629] input: Power Button as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
Mar 22 15:38:36 Miraculix kernel: [    4.202631] ACPI: Power Button [PWRF]
Mar 22 15:38:36 Miraculix kernel: [    4.203917] thermal LNXTHERM:00: 
registered as thermal_zone0
Mar 22 15:38:36 Miraculix kernel: [    4.203919] ACPI: Thermal Zone 
[THM0] (38 C)
Mar 22 15:38:36 Miraculix kernel: [    4.203947] GHES: HEST is not enabled!
Mar 22 15:38:36 Miraculix kernel: [    4.204010] Serial: 8250/16550 
driver, 32 ports, IRQ sharing enabled
Mar 22 15:38:36 Miraculix kernel: [    4.211476] ACPI: Battery Slot 
[BAT0] (battery present)
Mar 22 15:38:36 Miraculix kernel: [    4.226066] 0000:00:16.3: ttyS4 at 
I/O 0x6070 (irq = 19, base_baud = 115200) is a 16550A
Mar 22 15:38:36 Miraculix kernel: [    4.226291] Linux agpgart interface 
v0.103
Mar 22 15:38:36 Miraculix kernel: [    4.226839] tpm_tis 00:09: 1.2 TPM 
(device-id 0x0, rev-id 78)
Mar 22 15:38:36 Miraculix kernel: [    4.295424] tpm_tis 00:09: TPM is 
disabled/deactivated (0x6)
Mar 22 15:38:36 Miraculix kernel: [    4.297447] brd: module loaded
Mar 22 15:38:36 Miraculix kernel: [    4.298107] loop: module loaded
Mar 22 15:38:36 Miraculix kernel: [    4.298462] libphy: Fixed MDIO Bus: 
probed
Mar 22 15:38:36 Miraculix kernel: [    4.298539] tun: Universal TUN/TAP 
device driver, 1.6
Mar 22 15:38:36 Miraculix kernel: [    4.298540] tun: (C) 1999-2004 Max 
Krasnyansky <maxk@qualcomm.com>
Mar 22 15:38:36 Miraculix kernel: [    4.298574] PPP generic driver 
version 2.4.2
Mar 22 15:38:36 Miraculix kernel: [    4.298607] ehci_hcd: USB 2.0 
'Enhanced' Host Controller (EHCI) Driver
Mar 22 15:38:36 Miraculix kernel: [    4.298610] ehci-pci: EHCI PCI 
platform driver
Mar 22 15:38:36 Miraculix kernel: [    4.298728] ehci-pci 0000:00:1a.0: 
EHCI Host Controller
Mar 22 15:38:36 Miraculix kernel: [    4.298733] ehci-pci 0000:00:1a.0: 
new USB bus registered, assigned bus number 1
Mar 22 15:38:36 Miraculix kernel: [    4.298750] ehci-pci 0000:00:1a.0: 
debug port 2
Mar 22 15:38:36 Miraculix kernel: [    4.302664] ehci-pci 0000:00:1a.0: 
cache line size of 64 is not supported
Mar 22 15:38:36 Miraculix kernel: [    4.302682] ehci-pci 0000:00:1a.0: 
irq 16, io mem 0xf533a000
Mar 22 15:38:36 Miraculix kernel: [    4.311304] ehci-pci 0000:00:1a.0: 
USB 2.0 started, EHCI 1.00
Mar 22 15:38:36 Miraculix kernel: [    4.311341] usb usb1: New USB 
device found, idVendor=1d6b, idProduct=0002
Mar 22 15:38:36 Miraculix kernel: [    4.311342] usb usb1: New USB 
device strings: Mfr=3, Product=2, SerialNumber=1
Mar 22 15:38:36 Miraculix kernel: [    4.311344] usb usb1: Product: EHCI 
Host Controller
Mar 22 15:38:36 Miraculix kernel: [    4.311345] usb usb1: Manufacturer: 
Linux 3.14.0-031400rc7-generic ehci_hcd
Mar 22 15:38:36 Miraculix kernel: [    4.311346] usb usb1: SerialNumber: 
0000:00:1a.0
Mar 22 15:38:36 Miraculix kernel: [    4.311446] hub 1-0:1.0: USB hub found
Mar 22 15:38:36 Miraculix kernel: [    4.311453] hub 1-0:1.0: 3 ports 
detected
Mar 22 15:38:36 Miraculix kernel: [    4.311637] ehci-pci 0000:00:1d.0: 
EHCI Host Controller
Mar 22 15:38:36 Miraculix kernel: [    4.311643] ehci-pci 0000:00:1d.0: 
new USB bus registered, assigned bus number 2
Mar 22 15:38:36 Miraculix kernel: [    4.311654] ehci-pci 0000:00:1d.0: 
debug port 2
Mar 22 15:38:36 Miraculix kernel: [    4.315540] ehci-pci 0000:00:1d.0: 
cache line size of 64 is not supported
Mar 22 15:38:36 Miraculix kernel: [    4.315552] ehci-pci 0000:00:1d.0: 
irq 23, io mem 0xf5339000
Mar 22 15:38:36 Miraculix kernel: [    4.327298] ehci-pci 0000:00:1d.0: 
USB 2.0 started, EHCI 1.00
Mar 22 15:38:36 Miraculix kernel: [    4.327333] usb usb2: New USB 
device found, idVendor=1d6b, idProduct=0002
Mar 22 15:38:36 Miraculix kernel: [    4.327335] usb usb2: New USB 
device strings: Mfr=3, Product=2, SerialNumber=1
Mar 22 15:38:36 Miraculix kernel: [    4.327336] usb usb2: Product: EHCI 
Host Controller
Mar 22 15:38:36 Miraculix kernel: [    4.327338] usb usb2: Manufacturer: 
Linux 3.14.0-031400rc7-generic ehci_hcd
Mar 22 15:38:36 Miraculix kernel: [    4.327339] usb usb2: SerialNumber: 
0000:00:1d.0
Mar 22 15:38:36 Miraculix kernel: [    4.327458] hub 2-0:1.0: USB hub found
Mar 22 15:38:36 Miraculix kernel: [    4.327464] hub 2-0:1.0: 3 ports 
detected
Mar 22 15:38:36 Miraculix kernel: [    4.327577] ehci-platform: EHCI 
generic platform driver
Mar 22 15:38:36 Miraculix kernel: [    4.327584] ohci_hcd: USB 1.1 
'Open' Host Controller (OHCI) Driver
Mar 22 15:38:36 Miraculix kernel: [    4.327590] ohci-pci: OHCI PCI 
platform driver
Mar 22 15:38:36 Miraculix kernel: [    4.327598] ohci-platform: OHCI 
generic platform driver
Mar 22 15:38:36 Miraculix kernel: [    4.327604] uhci_hcd: USB Universal 
Host Controller Interface driver
Mar 22 15:38:36 Miraculix kernel: [    4.327693] xhci_hcd 0000:00:14.0: 
xHCI Host Controller
Mar 22 15:38:36 Miraculix kernel: [    4.327697] xhci_hcd 0000:00:14.0: 
new USB bus registered, assigned bus number 3
Mar 22 15:38:36 Miraculix kernel: [    4.327790] xhci_hcd 0000:00:14.0: 
cache line size of 64 is not supported
Mar 22 15:38:36 Miraculix kernel: [    4.327814] xhci_hcd 0000:00:14.0: 
irq 41 for MSI/MSI-X
Mar 22 15:38:36 Miraculix kernel: [    4.327880] usb usb3: New USB 
device found, idVendor=1d6b, idProduct=0002
Mar 22 15:38:36 Miraculix kernel: [    4.327882] usb usb3: New USB 
device strings: Mfr=3, Product=2, SerialNumber=1
Mar 22 15:38:36 Miraculix kernel: [    4.327883] usb usb3: Product: xHCI 
Host Controller
Mar 22 15:38:36 Miraculix kernel: [    4.327885] usb usb3: Manufacturer: 
Linux 3.14.0-031400rc7-generic xhci_hcd
Mar 22 15:38:36 Miraculix kernel: [    4.327886] usb usb3: SerialNumber: 
0000:00:14.0
Mar 22 15:38:36 Miraculix kernel: [    4.328000] hub 3-0:1.0: USB hub found
Mar 22 15:38:36 Miraculix kernel: [    4.328013] hub 3-0:1.0: 4 ports 
detected
Mar 22 15:38:36 Miraculix kernel: [    4.328342] xhci_hcd 0000:00:14.0: 
xHCI Host Controller
Mar 22 15:38:36 Miraculix kernel: [    4.328345] xhci_hcd 0000:00:14.0: 
new USB bus registered, assigned bus number 4
Mar 22 15:38:36 Miraculix kernel: [    4.328381] usb usb4: New USB 
device found, idVendor=1d6b, idProduct=0003
Mar 22 15:38:36 Miraculix kernel: [    4.328382] usb usb4: New USB 
device strings: Mfr=3, Product=2, SerialNumber=1
Mar 22 15:38:36 Miraculix kernel: [    4.328384] usb usb4: Product: xHCI 
Host Controller
Mar 22 15:38:36 Miraculix kernel: [    4.328385] usb usb4: Manufacturer: 
Linux 3.14.0-031400rc7-generic xhci_hcd
Mar 22 15:38:36 Miraculix kernel: [    4.328386] usb usb4: SerialNumber: 
0000:00:14.0
Mar 22 15:38:36 Miraculix kernel: [    4.328497] hub 4-0:1.0: USB hub found
Mar 22 15:38:36 Miraculix kernel: [    4.328509] hub 4-0:1.0: 4 ports 
detected
Mar 22 15:38:36 Miraculix kernel: [    4.328897] i8042: PNP: PS/2 
Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
Mar 22 15:38:36 Miraculix kernel: [    4.330566] serio: i8042 KBD port 
at 0x60,0x64 irq 1
Mar 22 15:38:36 Miraculix kernel: [    4.330571] serio: i8042 AUX port 
at 0x60,0x64 irq 12
Mar 22 15:38:36 Miraculix kernel: [    4.330723] mousedev: PS/2 mouse 
device common for all mice
Mar 22 15:38:36 Miraculix kernel: [    4.330977] rtc_cmos 00:06: RTC can 
wake from S4
Mar 22 15:38:36 Miraculix kernel: [    4.331136] rtc_cmos 00:06: rtc 
core: registered rtc_cmos as rtc0
Mar 22 15:38:36 Miraculix kernel: [    4.331167] rtc_cmos 00:06: alarms 
up to one month, y3k, 114 bytes nvram, hpet irqs
Mar 22 15:38:36 Miraculix kernel: [    4.331236] device-mapper: uevent: 
version 1.0.3
Mar 22 15:38:36 Miraculix kernel: [    4.331316] device-mapper: ioctl: 
4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
Mar 22 15:38:36 Miraculix kernel: [    4.331322] Intel P-state driver 
initializing.
Mar 22 15:38:36 Miraculix kernel: [    4.331330] Intel pstate 
controlling: cpu 0
Mar 22 15:38:36 Miraculix kernel: [    4.331346] Intel pstate 
controlling: cpu 1
Mar 22 15:38:36 Miraculix kernel: [    4.331374] Intel pstate 
controlling: cpu 2
Mar 22 15:38:36 Miraculix kernel: [    4.331384] Intel pstate 
controlling: cpu 3
Mar 22 15:38:36 Miraculix kernel: [    4.331398] Intel pstate 
controlling: cpu 4
Mar 22 15:38:36 Miraculix kernel: [    4.331408] Intel pstate 
controlling: cpu 5
Mar 22 15:38:36 Miraculix kernel: [    4.331420] Intel pstate 
controlling: cpu 6
Mar 22 15:38:36 Miraculix kernel: [    4.331430] Intel pstate 
controlling: cpu 7
Mar 22 15:38:36 Miraculix kernel: [    4.331459] ledtrig-cpu: registered 
to indicate activity on CPUs
Mar 22 15:38:36 Miraculix kernel: [    4.331538] TCP: cubic registered
Mar 22 15:38:36 Miraculix kernel: [    4.331603] NET: Registered 
protocol family 10
Mar 22 15:38:36 Miraculix kernel: [    4.331712] NET: Registered 
protocol family 17
Mar 22 15:38:36 Miraculix kernel: [    4.331718] Key type dns_resolver 
registered
Mar 22 15:38:36 Miraculix kernel: [    4.332055] input: AT Translated 
Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
Mar 22 15:38:36 Miraculix kernel: [    4.332190] Loading compiled-in 
X.509 certificates
Mar 22 15:38:36 Miraculix kernel: [    4.332720] Loaded X.509 cert 
'Magrathea: Glacier signing key: e66049b677b4dad51f0f529c245acb826c1907cd'
Mar 22 15:38:36 Miraculix kernel: [    4.332729] registered taskstats 
version 1
Mar 22 15:38:36 Miraculix kernel: [    4.334974] Key type trusted registered
Mar 22 15:38:36 Miraculix kernel: [    4.337126] Key type encrypted 
registered
Mar 22 15:38:36 Miraculix kernel: [    4.339368] AppArmor: AppArmor sha1 
policy hashing enabled
Mar 22 15:38:36 Miraculix kernel: [    4.363401] tpm_tis 00:09: A TPM 
error (6) occurred attempting to read a pcr value
Mar 22 15:38:36 Miraculix kernel: [    4.363847] IMA: No TPM chip found, 
activating TPM-bypass!
Mar 22 15:38:36 Miraculix kernel: [    4.364349] regulator-dummy: disabling
Mar 22 15:38:36 Miraculix kernel: [    4.364612]   Magic number: 6:699:637
Mar 22 15:38:36 Miraculix kernel: [    4.364760] rtc_cmos 00:06: setting 
system clock to 2014-03-22 14:38:04 UTC (1395499084)
Mar 22 15:38:36 Miraculix kernel: [    4.364885] BIOS EDD facility v0.16 
2004-Jun-25, 0 devices found
Mar 22 15:38:36 Miraculix kernel: [    4.364887] EDD information not 
available.
Mar 22 15:38:36 Miraculix kernel: [    4.364952] PM: Hibernation image 
not present or could not be loaded.
Mar 22 15:38:36 Miraculix kernel: [    4.365727] Freeing unused kernel 
memory: 1360K (ffffffff81d17000 - ffffffff81e6b000)
Mar 22 15:38:36 Miraculix kernel: [    4.365728] Write protecting the 
kernel read-only data: 12288k
Mar 22 15:38:36 Miraculix kernel: [    4.366747] Freeing unused kernel 
memory: 540K (ffff880001779000 - ffff880001800000)
Mar 22 15:38:36 Miraculix kernel: [    4.367586] Freeing unused kernel 
memory: 504K (ffff880001b82000 - ffff880001c00000)
Mar 22 15:38:36 Miraculix kernel: [    4.390051] ACPI: Video Device 
[VID1] (multi-head: yes  rom: yes  post: no)
Mar 22 15:38:36 Miraculix kernel: [    4.391208] acpi device:0b: 
registered as cooling_device8
Mar 22 15:38:36 Miraculix kernel: [    4.391306] input: Video Bus as 
/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:0a/LNXVIDEO:01/input/input5
Mar 22 15:38:36 Miraculix kernel: [    4.396024] wmi: Mapper loaded
Mar 22 15:38:36 Miraculix kernel: [    4.398868] [drm] Initialized drm 
1.1.0 20060810
Mar 22 15:38:36 Miraculix kernel: [    4.400449] pps_core: LinuxPPS API 
ver. 1 registered
Mar 22 15:38:36 Miraculix kernel: [    4.400451] pps_core: Software ver. 
5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
Mar 22 15:38:36 Miraculix kernel: [    4.401220] PTP clock support 
registered
Mar 22 15:38:36 Miraculix kernel: [    4.401991] sdhci: Secure Digital 
Host Controller Interface driver
Mar 22 15:38:36 Miraculix kernel: [    4.401993] sdhci: Copyright(c) 
Pierre Ossman
Mar 22 15:38:36 Miraculix kernel: [    4.403436] sdhci-pci 0000:02:00.0: 
SDHCI controller found [1180:e823] (rev 5)
Mar 22 15:38:36 Miraculix kernel: [    4.403643] mmc0: no vqmmc 
regulator found
Mar 22 15:38:36 Miraculix kernel: [    4.403645] mmc0: no vmmc regulator 
found
Mar 22 15:38:36 Miraculix kernel: [    4.403734] ahci 0000:00:1f.2: 
version 3.0
Mar 22 15:38:36 Miraculix kernel: [    4.403744] mmc0: SDHCI controller 
on PCI [0000:02:00.0] using DMA
Mar 22 15:38:36 Miraculix kernel: [    4.403872] ahci 0000:00:1f.2: irq 
42 for MSI/MSI-X
Mar 22 15:38:36 Miraculix kernel: [    4.403891] ahci 0000:00:1f.2: SSS 
flag set, parallel bus scan disabled
Mar 22 15:38:36 Miraculix kernel: [    4.404541] e1000e: Intel(R) 
PRO/1000 Network Driver - 2.3.2-k
Mar 22 15:38:36 Miraculix kernel: [    4.404543] e1000e: Copyright(c) 
1999 - 2013 Intel Corporation.
Mar 22 15:38:36 Miraculix kernel: [    4.414405] AVX version of 
gcm_enc/dec engaged.
Mar 22 15:38:36 Miraculix kernel: [    4.419298] ahci 0000:00:1f.2: AHCI 
0001.0300 32 slots 6 ports 6 Gbps 0x13 impl SATA mode
Mar 22 15:38:36 Miraculix kernel: [    4.419305] ahci 0000:00:1f.2: 
flags: 64bit ncq ilck stag pm led clo pio slum part ems sxs apst
Mar 22 15:38:36 Miraculix kernel: [    4.422272] ACPI Warning: 
\_SB_.PCI0.PEG_.VID_._DSM: Argument #4 type mismatch - Found [Buffer], 
ACPI requires [Package] (20131218/nsarguments-95)
Mar 22 15:38:36 Miraculix kernel: [    4.422626] ACPI Warning: 
\_SB_.PCI0.PEG_.VID_._DSM: Argument #4 type mismatch - Found [Buffer], 
ACPI requires [Package] (20131218/nsarguments-95)
Mar 22 15:38:36 Miraculix kernel: [    4.422933] pci 0000:01:00.0: 
optimus capabilities: enabled, status dynamic power, hda bios codec 
supported
Mar 22 15:38:36 Miraculix kernel: [    4.422938] VGA switcheroo: 
detected Optimus DSM method \_SB_.PCI0.PEG_.VID_ handle
Mar 22 15:38:36 Miraculix kernel: [    4.422956] checking generic 
(f1000000 130000) vs hw (e0000000 10000000)
Mar 22 15:38:36 Miraculix kernel: [    4.422958] checking generic 
(f1000000 130000) vs hw (f0000000 2000000)
Mar 22 15:38:36 Miraculix kernel: [    4.422959] fb: conflicting fb hw 
usage nouveaufb vs VESA VGA - removing generic driver
Mar 22 15:38:36 Miraculix kernel: [    4.422974] Console: switching to 
colour dummy device 80x25
Mar 22 15:38:36 Miraculix kernel: [    4.423791] nouveau  [ 
DEVICE][0000:01:00.0] BOOT0  : 0x0e73c0a2
Mar 22 15:38:36 Miraculix kernel: [    4.423793] nouveau  [ 
DEVICE][0000:01:00.0] Chipset: GK107 (NVE7)
Mar 22 15:38:36 Miraculix kernel: [    4.423795] nouveau  [ 
DEVICE][0000:01:00.0] Family : NVE0
Mar 22 15:38:36 Miraculix kernel: [    4.424834] nouveau  [ 
VBIOS][0000:01:00.0] checking PRAMIN for image...
Mar 22 15:38:36 Miraculix kernel: [    4.424848] nouveau  [ 
VBIOS][0000:01:00.0] ... signature not found
Mar 22 15:38:36 Miraculix kernel: [    4.424849] nouveau  [ 
VBIOS][0000:01:00.0] checking PROM for image...
Mar 22 15:38:36 Miraculix kernel: [    4.424880] nouveau  [ 
VBIOS][0000:01:00.0] ... signature not found
Mar 22 15:38:36 Miraculix kernel: [    4.424881] nouveau  [ 
VBIOS][0000:01:00.0] checking ACPI for image...
Mar 22 15:38:36 Miraculix kernel: [    4.467402] firewire_ohci 
0000:02:00.3: added OHCI v1.10 device as card 0, 4 IR + 4 IT contexts, 
quirks 0x11
Mar 22 15:38:36 Miraculix kernel: [    4.613307] nouveau  [ 
VBIOS][0000:01:00.0] ... appears to be valid
Mar 22 15:38:36 Miraculix kernel: [    4.613311] nouveau  [ 
VBIOS][0000:01:00.0] using image from ACPI
Mar 22 15:38:36 Miraculix kernel: [    4.613446] nouveau  [ 
VBIOS][0000:01:00.0] BIT signature found
Mar 22 15:38:36 Miraculix kernel: [    4.613449] nouveau  [ 
VBIOS][0000:01:00.0] version 80.07.33.00.0f
Mar 22 15:38:36 Miraculix kernel: [    4.614125] nouveau 0000:01:00.0: 
irq 43 for MSI/MSI-X
Mar 22 15:38:36 Miraculix kernel: [    4.614144] nouveau  [ 
PMC][0000:01:00.0] MSI interrupts enabled
Mar 22 15:38:36 Miraculix kernel: [    4.614185] scsi0 : ahci
Mar 22 15:38:36 Miraculix kernel: [    4.614201] nouveau  [ 
PFB][0000:01:00.0] RAM type: DDR3
Mar 22 15:38:36 Miraculix kernel: [    4.614203] nouveau  [ 
PFB][0000:01:00.0] RAM size: 2048 MiB
Mar 22 15:38:36 Miraculix kernel: [    4.614204] nouveau  [ 
PFB][0000:01:00.0]    ZCOMP: 0 tags
Mar 22 15:38:36 Miraculix kernel: [    4.614466] scsi1 : ahci
Mar 22 15:38:36 Miraculix kernel: [    4.614722] scsi2 : ahci
Mar 22 15:38:36 Miraculix kernel: [    4.615033] scsi3 : ahci
Mar 22 15:38:36 Miraculix kernel: [    4.615311] scsi4 : ahci
Mar 22 15:38:36 Miraculix kernel: [    4.615494] scsi5 : ahci
Mar 22 15:38:36 Miraculix kernel: [    4.615569] ata1: SATA max UDMA/133 
abar m2048@0xf5338000 port 0xf5338100 irq 42
Mar 22 15:38:36 Miraculix kernel: [    4.615573] ata2: SATA max UDMA/133 
abar m2048@0xf5338000 port 0xf5338180 irq 42
Mar 22 15:38:36 Miraculix kernel: [    4.615575] ata3: DUMMY
Mar 22 15:38:36 Miraculix kernel: [    4.615577] ata4: DUMMY
Mar 22 15:38:36 Miraculix kernel: [    4.615581] ata5: SATA max UDMA/133 
abar m2048@0xf5338000 port 0xf5338300 irq 42
Mar 22 15:38:36 Miraculix kernel: [    4.615583] ata6: DUMMY
Mar 22 15:38:36 Miraculix kernel: [    4.615831] e1000e 0000:00:19.0: 
Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
Mar 22 15:38:36 Miraculix kernel: [    4.615856] e1000e 0000:00:19.0: 
irq 44 for MSI/MSI-X
Mar 22 15:38:36 Miraculix kernel: [    4.618284] nouveau  [ 
VOLT][0000:01:00.0] GPU voltage: 875000uv
Mar 22 15:38:36 Miraculix kernel: [    4.623263] usb 1-1: new high-speed 
USB device number 2 using ehci-pci
Mar 22 15:38:36 Miraculix kernel: [    4.645611] nouveau  [ 
PTHERM][0000:01:00.0] FAN control: none / external
Mar 22 15:38:36 Miraculix kernel: [    4.645617] nouveau  [ 
PTHERM][0000:01:00.0] fan management: automatic
Mar 22 15:38:36 Miraculix kernel: [    4.645628] nouveau  [ 
PTHERM][0000:01:00.0] internal sensor: yes
Mar 22 15:38:36 Miraculix kernel: [    4.645660] nouveau  [ 
CLK][0000:01:00.0] 07: core 270-405 MHz memory 810 MHz
Mar 22 15:38:36 Miraculix kernel: [    4.645690] nouveau  [ 
CLK][0000:01:00.0] 0f: core 270-850 MHz memory 1800 MHz
Mar 22 15:38:36 Miraculix kernel: [    4.645834] nouveau  [ 
CLK][0000:01:00.0] --: core 405 MHz memory 648 MHz
Mar 22 15:38:36 Miraculix kernel: [    4.676803] [TTM] Zone kernel: 
Available graphics memory: 8031988 kiB
Mar 22 15:38:36 Miraculix kernel: [    4.676805] [TTM] Zone dma32: 
Available graphics memory: 2097152 kiB
Mar 22 15:38:36 Miraculix kernel: [    4.676806] [TTM] Initializing pool 
allocator
Mar 22 15:38:36 Miraculix kernel: [    4.676810] [TTM] Initializing DMA 
pool allocator
Mar 22 15:38:36 Miraculix kernel: [    4.676822] nouveau  [ DRM] VRAM: 
2048 MiB
Mar 22 15:38:36 Miraculix kernel: [    4.676823] nouveau  [ DRM] GART: 
1048576 MiB
Mar 22 15:38:36 Miraculix kernel: [    4.676827] nouveau  [ DRM] TMDS 
table version 2.0
Mar 22 15:38:36 Miraculix kernel: [    4.676828] nouveau  [ DRM] DCB 
version 4.0
Mar 22 15:38:36 Miraculix kernel: [    4.676830] nouveau  [ DRM] DCB 
outp 00: 01800f23 00010034
Mar 22 15:38:36 Miraculix kernel: [    4.676832] nouveau  [ DRM] DCB 
outp 01: 02811f00 00000000
Mar 22 15:38:36 Miraculix kernel: [    4.676833] nouveau  [ DRM] DCB 
outp 02: 02822fa6 0f420010
Mar 22 15:38:36 Miraculix kernel: [    4.676835] nouveau  [ DRM] DCB 
outp 03: 02822f62 00020010
Mar 22 15:38:36 Miraculix kernel: [    4.676836] nouveau  [ DRM] DCB 
outp 04: 04833fb6 0f220010
Mar 22 15:38:36 Miraculix kernel: [    4.676837] nouveau  [ DRM] DCB 
outp 05: 04833f72 00020010
Mar 22 15:38:36 Miraculix kernel: [    4.676838] nouveau  [ DRM] DCB 
outp 06: 08844fc6 0f220010
Mar 22 15:38:36 Miraculix kernel: [    4.676840] nouveau  [ DRM] DCB 
outp 07: 08844f82 00020010
Mar 22 15:38:36 Miraculix kernel: [    4.676841] nouveau  [ DRM] DCB 
conn 00: 00000040
Mar 22 15:38:36 Miraculix kernel: [    4.676843] nouveau  [ DRM] DCB 
conn 01: 00000100
Mar 22 15:38:36 Miraculix kernel: [    4.676844] nouveau  [ DRM] DCB 
conn 02: 00010246
Mar 22 15:38:36 Miraculix kernel: [    4.676845] nouveau  [ DRM] DCB 
conn 03: 00020346
Mar 22 15:38:36 Miraculix kernel: [    4.676847] nouveau  [ DRM] DCB 
conn 04: 01000446
Mar 22 15:38:36 Miraculix kernel: [    4.678129] [drm] Supports vblank 
timestamp caching Rev 2 (21.10.2013).
Mar 22 15:38:36 Miraculix kernel: [    4.678130] [drm] Driver supports 
precise vblank timestamp query.
Mar 22 15:38:36 Miraculix kernel: [    4.678132] nouveau  [ DRM] ACPI 
backlight interface available, not registering our own
Mar 22 15:38:36 Miraculix kernel: [    4.688918] nouveau  [ DRM] MM: 
using COPY for buffer copies
Mar 22 15:38:36 Miraculix kernel: [    4.755520] usb 1-1: New USB device 
found, idVendor=8087, idProduct=0024
Mar 22 15:38:36 Miraculix kernel: [    4.755522] usb 1-1: New USB device 
strings: Mfr=0, Product=0, SerialNumber=0
Mar 22 15:38:36 Miraculix kernel: [    4.755803] hub 1-1:1.0: USB hub found
Mar 22 15:38:36 Miraculix kernel: [    4.756002] hub 1-1:1.0: 6 ports 
detected
Mar 22 15:38:36 Miraculix kernel: [    4.821986] e1000e 0000:00:19.0 
eth0: registered PHC clock
Mar 22 15:38:36 Miraculix kernel: [    4.821989] e1000e 0000:00:19.0 
eth0: (PCI Express:2.5GT/s:Width x1) 3c:97:0e:bc:f2:1d
Mar 22 15:38:36 Miraculix kernel: [    4.821991] e1000e 0000:00:19.0 
eth0: Intel(R) PRO/1000 Network Connection
Mar 22 15:38:36 Miraculix kernel: [    4.822102] e1000e 0000:00:19.0 
eth0: MAC: 10, PHY: 11, PBA No: 1000FF-0FF
Mar 22 15:38:36 Miraculix kernel: [    4.923158] usb 3-2: new full-speed 
USB device number 2 using xhci_hcd
Mar 22 15:38:36 Miraculix kernel: [    4.935125] ata1: SATA link up 6.0 
Gbps (SStatus 133 SControl 300)
Mar 22 15:38:36 Miraculix kernel: [    4.935996] ata1.00: ACPI cmd 
ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
Mar 22 15:38:36 Miraculix kernel: [    4.936002] ata1.00: ACPI cmd 
f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
Mar 22 15:38:36 Miraculix kernel: [    4.936841] ata1.00: ATA-8: HGST 
HTS725050A7E630, GH2ZB550, max UDMA/133
Mar 22 15:38:36 Miraculix kernel: [    4.936845] ata1.00: 976773168 
sectors, multi 16: LBA48 NCQ (depth 31/32), AA
Mar 22 15:38:36 Miraculix kernel: [    4.937775] ata1.00: ACPI cmd 
ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
Mar 22 15:38:36 Miraculix kernel: [    4.937779] ata1.00: ACPI cmd 
f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
Mar 22 15:38:36 Miraculix kernel: [    4.938609] ata1.00: configured for 
UDMA/133
Mar 22 15:38:36 Miraculix kernel: [    4.938823] scsi 0:0:0:0: 
Direct-Access     ATA      HGST HTS725050A7 GH2Z PQ: 0 ANSI: 5
Mar 22 15:38:36 Miraculix kernel: [    4.938965] sd 0:0:0:0: [sda] 
976773168 512-byte logical blocks: (500 GB/465 GiB)
Mar 22 15:38:36 Miraculix kernel: [    4.938968] sd 0:0:0:0: [sda] 
4096-byte physical blocks
Mar 22 15:38:36 Miraculix kernel: [    4.938971] sd 0:0:0:0: Attached 
scsi generic sg0 type 0
Mar 22 15:38:36 Miraculix kernel: [    4.939112] sd 0:0:0:0: [sda] Write 
Protect is off
Mar 22 15:38:36 Miraculix kernel: [    4.939115] sd 0:0:0:0: [sda] Mode 
Sense: 00 3a 00 00
Mar 22 15:38:36 Miraculix kernel: [    4.939258] sd 0:0:0:0: [sda] Write 
cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar 22 15:38:36 Miraculix kernel: [    4.967217] firewire_core 
0000:02:00.3: created device fw0: GUID 3c970effbcf21dff, S400
Mar 22 15:38:36 Miraculix kernel: [    4.978447] nouveau  [ DRM] 
allocated 1920x1080 fb: 0x80000, bo ffff8800c58f8c00
Mar 22 15:38:36 Miraculix kernel: [    4.978633] fbcon: nouveaufb (fb0) 
is primary device
Mar 22 15:38:36 Miraculix kernel: [    4.982639]  sda: sda1 sda2 < sda5 >
Mar 22 15:38:36 Miraculix kernel: [    4.983485] sd 0:0:0:0: [sda] 
Attached SCSI disk
Mar 22 15:38:36 Miraculix kernel: [    5.051710] usb 3-2: New USB device 
found, idVendor=0e8f, idProduct=0016
Mar 22 15:38:36 Miraculix kernel: [    5.051711] usb 3-2: New USB device 
strings: Mfr=1, Product=2, SerialNumber=0
Mar 22 15:38:36 Miraculix kernel: [    5.051713] usb 3-2: Product: USB Hub
Mar 22 15:38:36 Miraculix kernel: [    5.051714] usb 3-2: Manufacturer: 
GASIA Semi.
Mar 22 15:38:36 Miraculix kernel: [    5.051820] usb 3-2: ep 0x81 - 
rounding interval to 1024 microframes, ep desc says 2040 microframes
Mar 22 15:38:36 Miraculix kernel: [    5.052015] hub 3-2:1.0: USB hub found
Mar 22 15:38:36 Miraculix kernel: [    5.052115] hub 3-2:1.0: 4 ports 
detected
Mar 22 15:38:36 Miraculix kernel: [    5.163080] usb 2-1: new high-speed 
USB device number 2 using ehci-pci
Mar 22 15:38:36 Miraculix kernel: [    5.255039] ata2: SATA link up 1.5 
Gbps (SStatus 113 SControl 300)
Mar 22 15:38:36 Miraculix kernel: [    5.264367] ata2.00: ACPI cmd 
e3/00:1f:00:00:00:a0 (IDLE) succeeded
Mar 22 15:38:36 Miraculix kernel: [    5.265152] ata2.00: ACPI cmd 
e3/00:02:00:00:00:a0 (IDLE) succeeded
Mar 22 15:38:36 Miraculix kernel: [    5.265420] ata2.00: ATAPI: PLDS 
DVD-RW DS8A8SH, KU54, max UDMA/100
Mar 22 15:38:36 Miraculix kernel: [    5.272710] ata2.00: ACPI cmd 
e3/00:1f:00:00:00:a0 (IDLE) succeeded
Mar 22 15:38:36 Miraculix kernel: [    5.273794] ata2.00: ACPI cmd 
e3/00:02:00:00:00:a0 (IDLE) succeeded
Mar 22 15:38:36 Miraculix kernel: [    5.274068] ata2.00: configured for 
UDMA/100
Mar 22 15:38:36 Miraculix kernel: [    5.286971] scsi 1:0:0:0: 
CD-ROM            PLDS     DVD-RW DS8A8SH   KU54 PQ: 0 ANSI: 5
Mar 22 15:38:36 Miraculix kernel: [    5.295404] usb 2-1: New USB device 
found, idVendor=8087, idProduct=0024
Mar 22 15:38:36 Miraculix kernel: [    5.295406] usb 2-1: New USB device 
strings: Mfr=0, Product=0, SerialNumber=0
Mar 22 15:38:36 Miraculix kernel: [    5.295710] hub 2-1:1.0: USB hub found
Mar 22 15:38:36 Miraculix kernel: [    5.295781] hub 2-1:1.0: 8 ports 
detected
Mar 22 15:38:36 Miraculix kernel: [    5.301106] sr0: scsi3-mmc drive: 
24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Mar 22 15:38:36 Miraculix kernel: [    5.301107] cdrom: Uniform CD-ROM 
driver Revision: 3.20
Mar 22 15:38:36 Miraculix kernel: [    5.301234] sr 1:0:0:0: Attached 
scsi CD-ROM sr0
Mar 22 15:38:36 Miraculix kernel: [    5.301300] sr 1:0:0:0: Attached 
scsi generic sg1 type 5
Mar 22 15:38:36 Miraculix kernel: [    5.367055] usb 1-1.1: new 
full-speed USB device number 3 using ehci-pci
Mar 22 15:38:36 Miraculix kernel: [    5.465523] usb 1-1.1: New USB 
device found, idVendor=17ef, idProduct=1003
Mar 22 15:38:36 Miraculix kernel: [    5.465524] usb 1-1.1: New USB 
device strings: Mfr=1, Product=2, SerialNumber=0
Mar 22 15:38:36 Miraculix kernel: [    5.465526] usb 1-1.1: Product: 
Integrated Smart Card Reader
Mar 22 15:38:36 Miraculix kernel: [    5.465528] usb 1-1.1: 
Manufacturer: Lenovo
Mar 22 15:38:36 Miraculix kernel: [    5.535001] usb 1-1.4: new 
full-speed USB device number 4 using ehci-pci
Mar 22 15:38:36 Miraculix kernel: [    5.618918] ata5: SATA link down 
(SStatus 0 SControl 300)
Mar 22 15:38:36 Miraculix kernel: [    5.630849] usb 1-1.4: New USB 
device found, idVendor=0a5c, idProduct=21e6
Mar 22 15:38:36 Miraculix kernel: [    5.630851] usb 1-1.4: New USB 
device strings: Mfr=1, Product=2, SerialNumber=3
Mar 22 15:38:36 Miraculix kernel: [    5.630852] usb 1-1.4: Product: 
BCM20702A0
Mar 22 15:38:36 Miraculix kernel: [    5.630853] usb 1-1.4: 
Manufacturer: Broadcom Corp
Mar 22 15:38:36 Miraculix kernel: [    5.630855] usb 1-1.4: 
SerialNumber: F82FA8E7383F
Mar 22 15:38:36 Miraculix kernel: [    5.703076] usb 1-1.6: new 
high-speed USB device number 5 using ehci-pci
Mar 22 15:38:36 Miraculix kernel: [    5.806301] Console: switching to 
colour frame buffer device 240x67
Mar 22 15:38:36 Miraculix kernel: [    5.806665] usb 1-1.6: New USB 
device found, idVendor=5986, idProduct=02d2
Mar 22 15:38:36 Miraculix kernel: [    5.806666] usb 1-1.6: New USB 
device strings: Mfr=1, Product=2, SerialNumber=0
Mar 22 15:38:36 Miraculix kernel: [    5.806667] usb 1-1.6: Product: 
Integrated Camera
Mar 22 15:38:36 Miraculix kernel: [    5.806669] usb 1-1.6: 
Manufacturer: Ricoh Company Ltd.
Mar 22 15:38:36 Miraculix kernel: [    5.808600] nouveau 0000:01:00.0: 
fb0: nouveaufb frame buffer device
Mar 22 15:38:36 Miraculix kernel: [    5.808602] nouveau 0000:01:00.0: 
registered panic notifier
Mar 22 15:38:36 Miraculix kernel: [    5.808605] [drm] Initialized 
nouveau 1.1.1 20120801 for 0000:01:00.0 on minor 0
Mar 22 15:38:36 Miraculix kernel: [    5.894867] usb 3-2.2: new 
low-speed USB device number 3 using xhci_hcd
Mar 22 15:38:36 Miraculix kernel: [    6.002739] usb 3-2.2: New USB 
device found, idVendor=04f3, idProduct=0216
Mar 22 15:38:36 Miraculix kernel: [    6.002743] usb 3-2.2: New USB 
device strings: Mfr=0, Product=2, SerialNumber=0
Mar 22 15:38:36 Miraculix kernel: [    6.002745] usb 3-2.2: Product: USB 
Mouse
Mar 22 15:38:36 Miraculix kernel: [    6.002901] usb 3-2.2: ep 0x81 - 
rounding interval to 64 microframes, ep desc says 80 microframes
Mar 22 15:38:36 Miraculix kernel: [    6.005218] hidraw: raw HID events 
driver (C) Jiri Kosina
Mar 22 15:38:36 Miraculix kernel: [    6.008897] usbcore: registered new 
interface driver usbhid
Mar 22 15:38:36 Miraculix kernel: [    6.008898] usbhid: USB HID core driver
Mar 22 15:38:36 Miraculix kernel: [    6.010035] input: USB Mouse as 
/devices/pci0000:00/0000:00:14.0/usb3/3-2/3-2.2/3-2.2:1.0/0003:04F3:0216.0001/input/input6
Mar 22 15:38:36 Miraculix kernel: [    6.010108] hid-generic 
0003:04F3:0216.0001: input,hidraw0: USB HID v1.11 Mouse [USB Mouse] on 
usb-0000:00:14.0-2.2/input0
Mar 22 15:38:36 Miraculix kernel: [    6.094822] usb 3-2.3: new 
low-speed USB device number 4 using xhci_hcd
Mar 22 15:38:36 Miraculix kernel: [    6.209699] usb 3-2.3: New USB 
device found, idVendor=046a, idProduct=0023
Mar 22 15:38:36 Miraculix kernel: [    6.209702] usb 3-2.3: New USB 
device strings: Mfr=0, Product=0, SerialNumber=0
Mar 22 15:38:36 Miraculix kernel: [    6.209845] usb 3-2.3: ep 0x81 - 
rounding interval to 64 microframes, ep desc says 80 microframes
Mar 22 15:38:36 Miraculix kernel: [    6.209851] usb 3-2.3: ep 0x82 - 
rounding interval to 64 microframes, ep desc says 80 microframes
Mar 22 15:38:36 Miraculix kernel: [    6.227203] input: HID 046a:0023 as 
/devices/pci0000:00/0000:00:14.0/usb3/3-2/3-2.3/3-2.3:1.0/0003:046A:0023.0002/input/input7
Mar 22 15:38:36 Miraculix kernel: [    6.227395] cherry 
0003:046A:0023.0002: input,hidraw1: USB HID v1.11 Keyboard [HID 
046a:0023] on usb-0000:00:14.0-2.3/input0
Mar 22 15:38:36 Miraculix kernel: [    6.230126] input: HID 046a:0023 as 
/devices/pci0000:00/0000:00:14.0/usb3/3-2/3-2.3/3-2.3:1.1/0003:046A:0023.0003/input/input8
Mar 22 15:38:36 Miraculix kernel: [    6.230278] cherry 
0003:046A:0023.0003: input,hidraw2: USB HID v1.11 Device [HID 046a:0023] 
on usb-0000:00:14.0-2.3/input1
Mar 22 15:38:36 Miraculix kernel: [    6.294839] usb 2-1.7: new 
low-speed USB device number 3 using ehci-pci
Mar 22 15:38:36 Miraculix kernel: [    6.389556] usb 2-1.7: New USB 
device found, idVendor=0765, idProduct=5010
Mar 22 15:38:36 Miraculix kernel: [    6.389561] usb 2-1.7: New USB 
device strings: Mfr=0, Product=0, SerialNumber=0
Mar 22 15:38:36 Miraculix kernel: [    6.392715] hid-generic 
0003:0765:5010.0004: hiddev0,hidraw3: USB HID v1.11 Device [HID 
0765:5010] on usb-0000:00:1d.0-1.7/input0
Mar 22 15:38:36 Miraculix kernel: [    9.356123] random: nonblocking 
pool is initialized
Mar 22 15:38:36 Miraculix kernel: [   12.083821] bio: create slab 
<bio-1> at 1
Mar 22 15:38:36 Miraculix kernel: [   12.301025] bio: create slab 
<bio-0> at 0
Mar 22 15:38:36 Miraculix kernel: [   12.693084] EXT4-fs (dm-1): INFO: 
recovery required on readonly filesystem
Mar 22 15:38:36 Miraculix kernel: [   12.693087] EXT4-fs (dm-1): write 
access will be enabled during recovery
Mar 22 15:38:36 Miraculix kernel: [   13.576173] EXT4-fs (dm-1): orphan 
cleanup on readonly fs
Mar 22 15:38:36 Miraculix kernel: [   13.675200] EXT4-fs (dm-1): 23 
orphan inodes deleted
Mar 22 15:38:36 Miraculix kernel: [   13.675204] EXT4-fs (dm-1): 
recovery complete
Mar 22 15:38:36 Miraculix kernel: [   13.887844] EXT4-fs (dm-1): mounted 
filesystem with ordered data mode. Opts: (null)
Mar 22 15:38:36 Miraculix kernel: [   31.795095] Adding 16400380k swap 
on /dev/mapper/ubuntu-swap_1.  Priority:-1 extents:1 across:16400380k FS
Mar 22 15:38:36 Miraculix kernel: [   32.517259] microcode: CPU0 
sig=0x306a9, pf=0x10, revision=0x19
Mar 22 15:38:36 Miraculix kernel: [   32.548900] ACPI Warning: SystemIO 
range 0x0000000000000428-0x000000000000042f conflicts with OpRegion 
0x0000000000000400-0x000000000000047f (\_SB_.PCI0.LPC_.PMIO) 
(20131218/utaddress-258)
Mar 22 15:38:36 Miraculix kernel: [   32.548906] ACPI: If an ACPI driver 
is available for this device, you should use it instead of the native driver
Mar 22 15:38:36 Miraculix kernel: [   32.548913] ACPI Warning: SystemIO 
range 0x0000000000000530-0x000000000000053f conflicts with OpRegion 
0x0000000000000500-0x000000000000057f (\_SB_.PCI0.LPC_.LPIO) 
(20131218/utaddress-258)
Mar 22 15:38:36 Miraculix kernel: [   32.548916] ACPI: If an ACPI driver 
is available for this device, you should use it instead of the native driver
Mar 22 15:38:36 Miraculix kernel: [   32.548917] ACPI Warning: SystemIO 
range 0x0000000000000500-0x000000000000052f conflicts with OpRegion 
0x0000000000000500-0x000000000000057f (\_SB_.PCI0.LPC_.LPIO) 
(20131218/utaddress-258)
Mar 22 15:38:36 Miraculix kernel: [   32.548919] ACPI: If an ACPI driver 
is available for this device, you should use it instead of the native driver
Mar 22 15:38:36 Miraculix kernel: [   32.548920] lpc_ich: Resource 
conflict(s) found affecting gpio_ich
Mar 22 15:38:36 Miraculix kernel: [   32.585885] microcode: CPU1 
sig=0x306a9, pf=0x10, revision=0x19
Mar 22 15:38:36 Miraculix kernel: [   32.585903] microcode: CPU2 
sig=0x306a9, pf=0x10, revision=0x19
Mar 22 15:38:36 Miraculix kernel: [   32.585941] microcode: CPU3 
sig=0x306a9, pf=0x10, revision=0x19
Mar 22 15:38:36 Miraculix kernel: [   32.585954] microcode: CPU4 
sig=0x306a9, pf=0x10, revision=0x19
Mar 22 15:38:36 Miraculix kernel: [   32.585964] microcode: CPU5 
sig=0x306a9, pf=0x10, revision=0x19
Mar 22 15:38:36 Miraculix kernel: [   32.585973] microcode: CPU6 
sig=0x306a9, pf=0x10, revision=0x19
Mar 22 15:38:36 Miraculix kernel: [   32.585984] microcode: CPU7 
sig=0x306a9, pf=0x10, revision=0x19
Mar 22 15:38:36 Miraculix kernel: [   32.586038] microcode: Microcode 
Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
Mar 22 15:38:36 Miraculix kernel: [   32.590787] nf_conntrack version 
0.5.0 (16384 buckets, 65536 max)
Mar 22 15:38:36 Miraculix kernel: [   32.752580] cfg80211: Calling CRDA 
to update world regulatory domain
Mar 22 15:38:36 Miraculix kernel: [   32.832307] mei_me 0000:00:16.0: 
irq 45 for MSI/MSI-X
Mar 22 15:38:36 Miraculix kernel: [   33.022293] EXT4-fs (dm-1): 
re-mounted. Opts: errors=remount-ro
Mar 22 15:38:36 Miraculix kernel: [   33.023162] audit: type=1400 
audit(1395499113.165:2): apparmor="STATUS" operation="profile_load" 
name="/sbin/dhclient" pid=567 comm="apparmor_parser"
Mar 22 15:38:36 Miraculix kernel: [   33.023167] audit: type=1400 
audit(1395499113.165:3): apparmor="STATUS" operation="profile_load" 
name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=567 
comm="apparmor_parser"
Mar 22 15:38:36 Miraculix kernel: [   33.023179] audit: type=1400 
audit(1395499113.165:4): apparmor="STATUS" operation="profile_load" 
name="/usr/lib/connman/scripts/dhclient-script" pid=567 
comm="apparmor_parser"
Mar 22 15:38:36 Miraculix kernel: [   33.023490] audit: type=1400 
audit(1395499113.165:5): apparmor="STATUS" operation="profile_replace" 
name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=567 
comm="apparmor_parser"
Mar 22 15:38:36 Miraculix kernel: [   33.023493] audit: type=1400 
audit(1395499113.165:6): apparmor="STATUS" operation="profile_replace" 
name="/usr/lib/connman/scripts/dhclient-script" pid=567 
comm="apparmor_parser"
Mar 22 15:38:36 Miraculix kernel: [   33.023613] audit: type=1400 
audit(1395499113.165:7): apparmor="STATUS" operation="profile_replace" 
name="/usr/lib/connman/scripts/dhclient-script" pid=567 
comm="apparmor_parser"
Mar 22 15:38:36 Miraculix kernel: [   33.062214] Non-volatile memory 
driver v1.3
Mar 22 15:38:36 Miraculix kernel: [   33.093626] Intel(R) Wireless WiFi 
driver for Linux, in-tree:
Mar 22 15:38:36 Miraculix kernel: [   33.093629] Copyright(c) 2003- 2014 
Intel Corporation
Mar 22 15:38:36 Miraculix kernel: [   33.093814] iwlwifi 0000:03:00.0: 
can't disable ASPM; OS doesn't have ASPM control
Mar 22 15:38:36 Miraculix kernel: [   33.094009] iwlwifi 0000:03:00.0: 
irq 46 for MSI/MSI-X
Mar 22 15:38:36 Miraculix kernel: [   33.113803] thinkpad_acpi: ThinkPad 
ACPI Extras v0.25
Mar 22 15:38:36 Miraculix kernel: [   33.113806] thinkpad_acpi: 
http://ibm-acpi.sf.net/
Mar 22 15:38:36 Miraculix kernel: [   33.113808] thinkpad_acpi: ThinkPad 
BIOS G5ET96WW (2.56 ), EC unknown
Mar 22 15:38:36 Miraculix kernel: [   33.113810] thinkpad_acpi: Lenovo 
ThinkPad W530, model 24491D1
Mar 22 15:38:36 Miraculix kernel: [   33.114384] thinkpad_acpi: 
Unsupported brightness interface, please contact 
ibm-acpi-devel@lists.sourceforge.net
Mar 22 15:38:36 Miraculix kernel: [   33.114505] thinkpad_acpi: radio 
switch found; radios are enabled
Mar 22 15:38:36 Miraculix kernel: [   33.114518] thinkpad_acpi: This 
ThinkPad has standard ACPI backlight brightness control, supported by 
the ACPI video driver
Mar 22 15:38:36 Miraculix kernel: [   33.114519] thinkpad_acpi: 
Disabling thinkpad-acpi brightness events by default...
Mar 22 15:38:36 Miraculix kernel: [   33.115809] thinkpad_acpi: rfkill 
switch tpacpi_bluetooth_sw: radio is unblocked
Mar 22 15:38:36 Miraculix kernel: [   33.116274] thinkpad_acpi: Console 
audio control enabled, mode: monitor (read only)
Mar 22 15:38:36 Miraculix kernel: [   33.117664] input: ThinkPad Extra 
Buttons as /devices/platform/thinkpad_acpi/input/input10
Mar 22 15:38:36 Miraculix kernel: [   33.141846] iwlwifi 0000:03:00.0: 
loaded firmware version 18.168.6.1 op_mode iwldvm
Mar 22 15:38:36 Miraculix kernel: [   33.183919] snd_hda_intel 
0000:00:1b.0: irq 47 for MSI/MSI-X
Mar 22 15:38:36 Miraculix kernel: [   33.184008] hda_intel: Disabling MSI
Mar 22 15:38:36 Miraculix kernel: [   33.184013] hda-intel 0000:01:00.1: 
Handle VGA-switcheroo audio client
Mar 22 15:38:36 Miraculix kernel: [   33.184071] hda-intel 0000:01:00.1: 
Disabling 64bit DMA
Mar 22 15:38:36 Miraculix kernel: [   33.187238] hda-intel 0000:01:00.1: 
Enable delay in RIRB handling
Mar 22 15:38:36 Miraculix kernel: [   33.212917] SKU: Nid=0x1d 
sku_cfg=0x40138205
Mar 22 15:38:36 Miraculix kernel: [   33.212919] SKU: port_connectivity=0x1
Mar 22 15:38:36 Miraculix kernel: [   33.212920] SKU: enable_pcbeep=0x1
Mar 22 15:38:36 Miraculix kernel: [   33.212921] SKU: check_sum=0x00000003
Mar 22 15:38:36 Miraculix kernel: [   33.212922] SKU: 
customization=0x00000082
Mar 22 15:38:36 Miraculix kernel: [   33.212923] SKU: external_amp=0x0
Mar 22 15:38:36 Miraculix kernel: [   33.212923] SKU: platform_type=0x1
Mar 22 15:38:36 Miraculix kernel: [   33.212924] SKU: swap=0x0
Mar 22 15:38:36 Miraculix kernel: [   33.212925] SKU: override=0x1
Mar 22 15:38:36 Miraculix kernel: [   33.213245] autoconfig: line_outs=1 
(0x14/0x0/0x0/0x0/0x0) type:speaker
Mar 22 15:38:36 Miraculix kernel: [   33.213246]    speaker_outs=0 
(0x0/0x0/0x0/0x0/0x0)
Mar 22 15:38:36 Miraculix kernel: [   33.213247]    hp_outs=2 
(0x15/0x1b/0x0/0x0/0x0)
Mar 22 15:38:36 Miraculix kernel: [   33.213248]    mono: mono_out=0x0
Mar 22 15:38:36 Miraculix kernel: [   33.213248]    inputs:
Mar 22 15:38:36 Miraculix kernel: [   33.213250]      Mic=0x18
Mar 22 15:38:36 Miraculix kernel: [   33.213251]      Dock Mic=0x19
Mar 22 15:38:36 Miraculix kernel: [   33.213252]      Internal Mic=0x12
Mar 22 15:38:36 Miraculix kernel: [   33.213253] realtek: No valid SSID, 
checking pincfg 0x40138205 for NID 0x1d
Mar 22 15:38:36 Miraculix kernel: [   33.213254] realtek: Enabling init 
ASM_ID=0x8205 CODEC_ID=10ec0269
Mar 22 15:38:36 Miraculix kernel: [   33.220719] input: HDA Intel PCH 
Dock Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input14
Mar 22 15:38:36 Miraculix kernel: [   33.220809] input: HDA Intel PCH 
Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
Mar 22 15:38:36 Miraculix kernel: [   33.220869] input: HDA Intel PCH 
Dock Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
Mar 22 15:38:36 Miraculix kernel: [   33.220924] input: HDA Intel PCH 
Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
Mar 22 15:38:36 Miraculix kernel: [   33.327521] lp: driver loaded but 
no devices found
Mar 22 15:38:36 Miraculix kernel: [   33.491211] intel_rapl: domain 
uncore energy ctr 0:0 not working, skip
Mar 22 15:38:36 Miraculix kernel: [   33.504923] psmouse serio1: 
synaptics: Touchpad model: 1, fw: 7.2, id: 0x1c0b1, caps: 
0xd047b3/0xb40000/0xa0000, board id: 71, fw id: 920262
Mar 22 15:38:36 Miraculix kernel: [   33.504934] psmouse serio1: 
synaptics: serio: Synaptics pass-through port at isa0060/serio1/input0
Mar 22 15:38:36 Miraculix kernel: [   33.540767] input: SynPS/2 
Synaptics TouchPad as /devices/platform/i8042/serio1/input/input9
Mar 22 15:38:36 Miraculix kernel: [   33.572372] Bluetooth: Core ver 2.18
Mar 22 15:38:36 Miraculix kernel: [   33.572398] NET: Registered 
protocol family 31
Mar 22 15:38:36 Miraculix kernel: [   33.572399] Bluetooth: HCI device 
and connection manager initialized
Mar 22 15:38:36 Miraculix kernel: [   33.572406] Bluetooth: HCI socket 
layer initialized
Mar 22 15:38:36 Miraculix kernel: [   33.572409] Bluetooth: L2CAP socket 
layer initialized
Mar 22 15:38:36 Miraculix kernel: [   33.572419] Bluetooth: SCO socket 
layer initialized
Mar 22 15:38:36 Miraculix kernel: [   33.583266] Linux video capture 
interface: v2.00
Mar 22 15:38:36 Miraculix kernel: [   33.700084] cfg80211: World 
regulatory domain updated:
Mar 22 15:38:36 Miraculix kernel: [   33.700087] cfg80211:  DFS Master 
region: unset
Mar 22 15:38:36 Miraculix kernel: [   33.700088] cfg80211: (start_freq - 
end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Mar 22 15:38:36 Miraculix kernel: [   33.700090] cfg80211: (2402000 KHz 
- 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar 22 15:38:36 Miraculix kernel: [   33.700091] cfg80211: (2457000 KHz 
- 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar 22 15:38:36 Miraculix kernel: [   33.700091] cfg80211: (2474000 KHz 
- 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Mar 22 15:38:36 Miraculix kernel: [   33.700092] cfg80211: (5170000 KHz 
- 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar 22 15:38:36 Miraculix kernel: [   33.700093] cfg80211: (5735000 KHz 
- 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar 22 15:38:36 Miraculix kernel: [   33.730125] input: HDA NVidia 
HDMI/DP,pcm=8 as 
/devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input18
Mar 22 15:38:36 Miraculix kernel: [   33.730221] input: HDA NVidia 
HDMI/DP,pcm=7 as 
/devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input17
Mar 22 15:38:36 Miraculix kernel: [   33.730284] input: HDA NVidia 
HDMI/DP,pcm=3 as 
/devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input16
Mar 22 15:38:36 Miraculix kernel: [   33.837524] usbcore: registered new 
interface driver btusb
Mar 22 15:38:36 Miraculix kernel: [   33.841530] iwlwifi 0000:03:00.0: 
CONFIG_IWLWIFI_DEBUG disabled
Mar 22 15:38:36 Miraculix kernel: [   33.841533] iwlwifi 0000:03:00.0: 
CONFIG_IWLWIFI_DEBUGFS enabled
Mar 22 15:38:36 Miraculix kernel: [   33.841535] iwlwifi 0000:03:00.0: 
CONFIG_IWLWIFI_DEVICE_TRACING enabled
Mar 22 15:38:36 Miraculix kernel: [   33.841536] iwlwifi 0000:03:00.0: 
Detected Intel(R) Centrino(R) Advanced-N 6205 AGN, REV=0xB0
Mar 22 15:38:36 Miraculix kernel: [   33.841717] iwlwifi 0000:03:00.0: 
L1 Enabled; Disabling L0S
Mar 22 15:38:36 Miraculix kernel: [   34.034991] uvcvideo: Found UVC 
1.00 device Integrated Camera (5986:02d2)
Mar 22 15:38:36 Miraculix kernel: [   34.037366] input: Integrated 
Camera as 
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.0/input/input19
Mar 22 15:38:36 Miraculix kernel: [   34.037451] usbcore: registered new 
interface driver uvcvideo
Mar 22 15:38:36 Miraculix kernel: [   34.037452] USB Video Class driver 
(1.1.1)
Mar 22 15:38:36 Miraculix kernel: [   34.192779] ieee80211 phy0: 
Selected rate control algorithm 'iwl-agn-rs'
Mar 22 15:38:36 Miraculix kernel: [   36.173422] EXT4-fs (sda1): 
mounting ext2 file system using the ext4 subsystem
Mar 22 15:38:36 Miraculix kernel: [   36.176208] EXT4-fs (sda1): mounted 
filesystem without journal. Opts: (null)
Mar 22 15:38:36 Miraculix kernel: [   36.350439] psmouse serio2: alps: 
Unknown ALPS touchpad: E7=10 00 64, EC=10 00 64
Mar 22 15:38:36 Miraculix bluetoothd[1105]: Failed to init gatt_example 
plugin
Mar 22 15:38:36 Miraculix bluetoothd[1105]: Bluetooth Management 
interface initialized
Mar 22 15:38:36 Miraculix kernel: [   36.530268] Bluetooth: BNEP 
(Ethernet Emulation) ver 1.3
Mar 22 15:38:36 Miraculix kernel: [   36.530271] Bluetooth: BNEP 
filters: protocol multicast
Mar 22 15:38:36 Miraculix kernel: [   36.530278] Bluetooth: BNEP socket 
layer initialized
Mar 22 15:38:36 Miraculix kernel: [   36.564031] audit: type=1400 
audit(1395499116.705:8): apparmor="STATUS" operation="profile_load" 
name="/usr/lib/cups/backend/cups-pdf" pid=1117 comm="apparmor_parser"
Mar 22 15:38:36 Miraculix kernel: [   36.564037] audit: type=1400 
audit(1395499116.705:9): apparmor="STATUS" operation="profile_load" 
name="/usr/sbin/cupsd" pid=1117 comm="apparmor_parser"
Mar 22 15:38:36 Miraculix kernel: [   36.564463] audit: type=1400 
audit(1395499116.705:10): apparmor="STATUS" operation="profile_replace" 
name="/usr/sbin/cupsd" pid=1117 comm="apparmor_parser"
Mar 22 15:38:36 Miraculix kernel: [   36.621487] Bluetooth: RFCOMM TTY 
layer initialized
Mar 22 15:38:36 Miraculix kernel: [   36.621496] Bluetooth: RFCOMM 
socket layer initialized
Mar 22 15:38:36 Miraculix kernel: [   36.621501] Bluetooth: RFCOMM ver 1.11
Mar 22 15:38:36 Miraculix kernel: [   36.706891] audit: type=1400 
audit(1395499116.849:11): apparmor="STATUS" operation="profile_replace" 
name="/sbin/dhclient" pid=1173 comm="apparmor_parser"
Mar 22 15:38:36 Miraculix bluetoothd[1105]: Unknown command complete for 
opcode 19
Mar 22 15:38:36 Miraculix rsyslogd-2039: Could no open output pipe 
'/dev/xconsole': No such file or directory [try 
http://www.rsyslog.com/e/2039 ]
Mar 22 15:38:37 Miraculix avahi-daemon[1183]: Found user 'avahi' (UID 
111) and group 'avahi' (GID 120).
Mar 22 15:38:37 Miraculix avahi-daemon[1183]: Successfully dropped root 
privileges.
Mar 22 15:38:37 Miraculix avahi-daemon[1183]: avahi-daemon 0.6.31 
starting up.
Mar 22 15:38:37 Miraculix avahi-daemon[1183]: Successfully called chroot().
Mar 22 15:38:37 Miraculix avahi-daemon[1183]: Successfully dropped 
remaining capabilities.
Mar 22 15:38:37 Miraculix bluetoothd[1105]: Adapter /org/bluez/1105/hci0 
has been enabled
Mar 22 15:38:37 Miraculix avahi-daemon[1183]: Loading service file 
/services/udisks.service.
Mar 22 15:38:37 Miraculix avahi-daemon[1183]: Network interface 
enumeration completed.
Mar 22 15:38:37 Miraculix avahi-daemon[1183]: Registering HINFO record 
with values 'X86_64'/'LINUX'.
Mar 22 15:38:37 Miraculix avahi-daemon[1183]: Server startup complete. 
Host name is Miraculix.local. Local service cookie is 2680065302.
Mar 22 15:38:37 Miraculix avahi-daemon[1183]: Service "Miraculix" 
(/services/udisks.service) successfully established.
Mar 22 15:38:37 Miraculix ModemManager[1089]: <info> ModemManager 
(version 1.0.0) starting...
Mar 22 15:38:37 Miraculix anacron[1296]: Anacron 2.3 started on 2014-03-22
Mar 22 15:38:37 Miraculix NetworkManager[1283]: <info> NetworkManager 
(version 0.9.8.8) is starting...
Mar 22 15:38:37 Miraculix NetworkManager[1283]: <info> Read config file 
/etc/NetworkManager/NetworkManager.conf
Mar 22 15:38:37 Miraculix NetworkManager[1283]: <info> WEXT support is 
enabled
Mar 22 15:38:37 Miraculix NetworkManager[1283]: <info> VPN: loaded 
org.freedesktop.NetworkManager.pptp
Mar 22 15:38:37 Miraculix NetworkManager[1283]: <info> DNS: loaded 
plugin dnsmasq
Mar 22 15:38:37 Miraculix dbus[1060]: [system] Activating service 
name='org.freedesktop.PolicyKit1' (using servicehelper)
Mar 22 15:38:37 Miraculix cron[1246]: (CRON) INFO (pidfile fd = 3)
Mar 22 15:38:37 Miraculix acpid: starting up with netlink and the input 
layer
Mar 22 15:38:37 Miraculix cron[1333]: (CRON) STARTUP (fork ok)
Mar 22 15:38:37 Miraculix cron[1333]: (CRON) INFO (Running @reboot jobs)
Mar 22 15:38:37 Miraculix anacron[1296]: Normal exit (0 jobs run)
Mar 22 15:38:37 Miraculix kernel: [   37.611769] psmouse serio2: 
trackpoint: IBM TrackPoint firmware: 0x0e, buttons: 3/3
Mar 22 15:38:37 Miraculix polkitd[1307]: started daemon version 0.105 
using authority implementation `local' version `0.105'
Mar 22 15:38:37 Miraculix dbus[1060]: [system] Successfully activated 
service 'org.freedesktop.PolicyKit1'
Mar 22 15:38:37 Miraculix NetworkManager[1283]: SCPlugin-Ifupdown: init!
Mar 22 15:38:37 Miraculix NetworkManager[1283]: SCPlugin-Ifupdown: 
update_system_hostname
Mar 22 15:38:37 Miraculix NetworkManager[1283]: interface-parser: 
parsing file /etc/network/interfaces
Mar 22 15:38:37 Miraculix NetworkManager[1283]: interface-parser: 
finished parsing file /etc/network/interfaces
Mar 22 15:38:37 Miraculix NetworkManager[1283]: SCPluginIfupdown: 
management mode: unmanaged
Mar 22 15:38:37 Miraculix NetworkManager[1283]: SCPlugin-Ifupdown: 
devices added (path: /sys/devices/pci0000:00/0000:00:19.0/net/eth0, 
iface: eth0)
Mar 22 15:38:37 Miraculix NetworkManager[1283]: SCPlugin-Ifupdown: 
device added (path: /sys/devices/pci0000:00/0000:00:19.0/net/eth0, 
iface: eth0): no ifupdown configuration found.
Mar 22 15:38:37 Miraculix NetworkManager[1283]: SCPlugin-Ifupdown: 
devices added (path: 
/sys/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/net/wlan0, iface: wlan0)
Mar 22 15:38:37 Miraculix NetworkManager[1283]: SCPlugin-Ifupdown: 
device added (path: 
/sys/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/net/wlan0, iface: 
wlan0): no ifupdown configuration found.
Mar 22 15:38:37 Miraculix NetworkManager[1283]: SCPlugin-Ifupdown: 
devices added (path: /sys/devices/virtual/net/lo, iface: lo)
Mar 22 15:38:37 Miraculix NetworkManager[1283]: SCPlugin-Ifupdown: 
device added (path: /sys/devices/virtual/net/lo, iface: lo): no ifupdown 
configuration found.
Mar 22 15:38:37 Miraculix NetworkManager[1283]: SCPlugin-Ifupdown: end 
_init.
Mar 22 15:38:37 Miraculix NetworkManager[1283]: <info> Loaded plugin 
ifupdown: (C) 2008 Canonical Ltd.  To report bugs please use the 
NetworkManager mailing list.
Mar 22 15:38:37 Miraculix NetworkManager[1283]: <info> Loaded plugin 
keyfile: (c) 2007 - 2010 Red Hat, Inc.  To report bugs please use the 
NetworkManager mailing list.
Mar 22 15:38:37 Miraculix NetworkManager[1283]:    SCPlugin-Ofono: 
Acquired D-Bus service com.canonical.NMOfono
Mar 22 15:38:37 Miraculix NetworkManager[1283]:    SCPlugin-Ofono: init!
Mar 22 15:38:37 Miraculix NetworkManager[1283]:    SCPlugin-Ofono: end 
_init.
Mar 22 15:38:37 Miraculix NetworkManager[1283]: <info> Loaded plugin 
(null): (null)
Mar 22 15:38:37 Miraculix NetworkManager[1283]:    Ifupdown: get 
unmanaged devices count: 0
Mar 22 15:38:37 Miraculix NetworkManager[1283]: SCPlugin-Ifupdown: 
(39727648) ... get_connections.
Mar 22 15:38:37 Miraculix NetworkManager[1283]: SCPlugin-Ifupdown: 
(39727648) ... get_connections (managed=false): return empty list.
Mar 22 15:38:37 Miraculix NetworkManager[1283]:    keyfile: parsing 
Scotty Beam Me Up ...
Mar 22 15:38:37 Miraculix NetworkManager[1283]:    keyfile: read 
connection 'Scotty Beam Me Up'
Mar 22 15:38:37 Miraculix NetworkManager[1283]:    keyfile: parsing IBM ...
Mar 22 15:38:37 Miraculix NetworkManager[1283]:    keyfile: read 
connection 'IBM'
Mar 22 15:38:37 Miraculix NetworkManager[1283]:    SCPlugin-Ofono: 
(-2147468000) ... get_connections.
Mar 22 15:38:37 Miraculix NetworkManager[1283]:    SCPlugin-Ofono: 
(-2147468000) connections count: 0
Mar 22 15:38:37 Miraculix NetworkManager[1283]:    Ifupdown: get 
unmanaged devices count: 0
Mar 22 15:38:37 Miraculix NetworkManager[1283]: <info> monitoring kernel 
firmware directory '/lib/firmware'.
Mar 22 15:38:37 Miraculix NetworkManager[1283]: <info> rfkill2: found 
WiFi radio killswitch (at 
/sys/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/ieee80211/phy0/rfkill2) (driver 
iwlwifi)
Mar 22 15:38:37 Miraculix NetworkManager[1283]: <info> WiFi enabled by 
radio killswitch; enabled by state file
Mar 22 15:38:37 Miraculix NetworkManager[1283]: <info> WWAN enabled by 
radio killswitch; enabled by state file
Mar 22 15:38:37 Miraculix NetworkManager[1283]: <info> WiMAX enabled by 
radio killswitch; enabled by state file
Mar 22 15:38:37 Miraculix NetworkManager[1283]: <info> Networking is 
enabled by state file
Mar 22 15:38:37 Miraculix NetworkManager[1283]: <warn> failed to 
allocate link cache: (-12) Object not found
Mar 22 15:38:37 Miraculix NetworkManager[1283]: <info> (eth0): carrier 
is OFF
Mar 22 15:38:37 Miraculix NetworkManager[1283]: <info> (eth0): new 
Ethernet device (driver: 'e1000e' ifindex: 2)
Mar 22 15:38:37 Miraculix NetworkManager[1283]: <info> (eth0): exported 
as /org/freedesktop/NetworkManager/Devices/0
Mar 22 15:38:37 Miraculix NetworkManager[1283]: <info> (eth0): device 
state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
Mar 22 15:38:37 Miraculix NetworkManager[1283]: <info> (eth0): bringing 
up device.
Mar 22 15:38:37 Miraculix kernel: [   37.813917] input: TPPS/2 IBM 
TrackPoint as /devices/platform/i8042/serio1/serio2/input/input15
Mar 22 15:38:37 Miraculix dbus[1060]: [system] Activating service 
name='org.freedesktop.Accounts' (using servicehelper)
Mar 22 15:38:38 Miraculix kernel: [   37.877743] e1000e 0000:00:19.0: 
irq 44 for MSI/MSI-X
Mar 22 15:38:38 Miraculix NetworkManager[1283]: <info> (eth0): preparing 
device.
Mar 22 15:38:38 Miraculix NetworkManager[1283]: <info> (eth0): 
deactivating device (reason 'managed') [2]
Mar 22 15:38:38 Miraculix NetworkManager[1283]: <info> Added default 
wired connection 'Wired connection 1' for 
/sys/devices/pci0000:00/0000:00:19.0/net/eth0
Mar 22 15:38:38 Miraculix NetworkManager[1283]: <info> (wlan0): using 
nl80211 for WiFi device control
Mar 22 15:38:38 Miraculix NetworkManager[1283]: <info> (wlan0): driver 
supports Access Point (AP) mode
Mar 22 15:38:38 Miraculix NetworkManager[1283]: <info> (wlan0): new 
802.11 WiFi device (driver: 'iwlwifi' ifindex: 3)
Mar 22 15:38:38 Miraculix NetworkManager[1283]: <info> (wlan0): exported 
as /org/freedesktop/NetworkManager/Devices/1
Mar 22 15:38:38 Miraculix NetworkManager[1283]: <info> (wlan0): device 
state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
Mar 22 15:38:38 Miraculix NetworkManager[1283]: <info> (wlan0): bringing 
up device.
Mar 22 15:38:38 Miraculix kernel: [   37.980767] e1000e 0000:00:19.0: 
irq 44 for MSI/MSI-X
Mar 22 15:38:38 Miraculix kernel: [   37.981006] IPv6: 
ADDRCONF(NETDEV_UP): eth0: link is not ready
Mar 22 15:38:38 Miraculix kernel: [   37.983116] iwlwifi 0000:03:00.0: 
L1 Enabled; Disabling L0S
Mar 22 15:38:38 Miraculix kernel: [   37.990428] iwlwifi 0000:03:00.0: 
Radio type=0x1-0x2-0x0
Mar 22 15:38:38 Miraculix accounts-daemon[1427]: started daemon version 
0.6.35
Mar 22 15:38:38 Miraculix dbus[1060]: [system] Successfully activated 
service 'org.freedesktop.Accounts'
Mar 22 15:38:38 Miraculix kernel: [   38.256965] iwlwifi 0000:03:00.0: 
L1 Enabled; Disabling L0S
Mar 22 15:38:38 Miraculix kernel: [   38.263827] iwlwifi 0000:03:00.0: 
Radio type=0x1-0x2-0x0
Mar 22 15:38:38 Miraculix NetworkManager[1283]: <info> (wlan0): 
preparing device.
Mar 22 15:38:38 Miraculix NetworkManager[1283]: <info> (wlan0): 
deactivating device (reason 'managed') [2]
Mar 22 15:38:38 Miraculix dbus[1060]: [system] Activating service 
name='fi.w1.wpa_supplicant1' (using servicehelper)
Mar 22 15:38:38 Miraculix NetworkManager[1283]: <warn> 
/sys/devices/virtual/net/lo: couldn't determine device driver; ignoring...
Mar 22 15:38:38 Miraculix kernel: [   38.347016] IPv6: 
ADDRCONF(NETDEV_UP): wlan0: link is not ready
Mar 22 15:38:38 Miraculix NetworkManager[1283]: <warn> 
/sys/devices/virtual/net/lo: couldn't determine device driver; ignoring...
Mar 22 15:38:38 Miraculix NetworkManager[1283]: <info> urfkill 
disappeared from the bus
Mar 22 15:38:38 Miraculix acpid: 9 rules loaded
Mar 22 15:38:38 Miraculix acpid: waiting for events: event logging is off
Mar 22 15:38:38 Miraculix dbus[1060]: [system] Successfully activated 
service 'fi.w1.wpa_supplicant1'
Mar 22 15:38:38 Miraculix wpa_supplicant[1494]: Successfully initialized 
wpa_supplicant
Mar 22 15:38:38 Miraculix NetworkManager[1283]: <info> wpa_supplicant 
started
Mar 22 15:38:38 Miraculix NetworkManager[1283]: <info> (wlan0) supports 
5 scan SSIDs
Mar 22 15:38:38 Miraculix NetworkManager[1283]: <warn> Trying to remove 
a non-existant call id.
Mar 22 15:38:38 Miraculix NetworkManager[1283]: <info> (wlan0): 
supplicant interface state: starting -> ready
Mar 22 15:38:38 Miraculix NetworkManager[1283]: <info> (wlan0): device 
state change: unavailable -> disconnected (reason 
'supplicant-available') [20 30 42]
Mar 22 15:38:38 Miraculix NetworkManager[1283]: <info> (wlan0): 
supplicant interface state: ready -> disconnected
Mar 22 15:38:38 Miraculix NetworkManager[1283]: <info> (wlan0) supports 
5 scan SSIDs
Mar 22 15:38:38 Miraculix NetworkManager[1283]: <info> ModemManager 
available in the bus
Mar 22 15:38:38 Miraculix wpa_supplicant[1555]: wlan0: Reject scan 
trigger since one is already pending
Mar 22 15:38:38 Miraculix wpa_supplicant[1555]: wlan0: 
CTRL-EVENT-SCAN-STARTED
Mar 22 15:38:39 Miraculix whoopsie[1281]: whoopsie 0.2.24.4 starting up.
Mar 22 15:38:39 Miraculix whoopsie[1281]: Using lock path: 
/var/lock/whoopsie/lock
Mar 22 15:38:39 Miraculix whoopsie[1809]: offline
Mar 22 15:38:39 Miraculix dnsmasq[1843]: started, version 2.68 cachesize 150
Mar 22 15:38:39 Miraculix dnsmasq[1843]: compile time options: IPv6 
GNU-getopt DBus i18n IDN DHCP DHCPv6 no-Lua TFTP conntrack ipset auth
Mar 22 15:38:39 Miraculix dnsmasq[1843]: no servers found in 
/var/run/dnsmasq/resolv.conf, will retry
Mar 22 15:38:39 Miraculix dnsmasq[1843]: read /etc/hosts - 7 addresses
Mar 22 15:38:40 Miraculix ModemManager[1089]: <warn> Couldn't find 
support for device at '/sys/devices/pci0000:00/0000:00:19.0': not 
supported by any plugin
Mar 22 15:38:40 Miraculix ModemManager[1089]: <warn> Couldn't find 
support for device at 
'/sys/devices/pci0000:00/0000:00:1c.1/0000:03:00.0': not supported by 
any plugin
Mar 22 15:38:40 Miraculix symev: unable to load kernel support module 
(UNSUPPORTED-OS--UNK-UNK-3.14.0-031400rc7-generic-)
Mar 22 15:38:40 Miraculix ciscod[2031]: [ciscod][all][init] hello
Mar 22 15:38:40 Miraculix ciscod[2031]: [ciscod][all][init] ciscod 
version 3.0.4235
Mar 22 15:38:41 Miraculix kernel: [   40.949875] ip6_tables: (C) 
2000-2006 Netfilter Core Team
Mar 22 15:38:41 Miraculix firewalld: 2014-03-22 15:38:41 ERROR: ipv4 
table 'filter' does not exist (or not enough permission to check).
Mar 22 15:38:41 Miraculix kernel: [   41.249700] ip_tables: (C) 
2000-2006 Netfilter Core Team
Mar 22 15:38:41 Miraculix kernel: [   41.388224] Ebtables v2.0 registered
Mar 22 15:38:41 Miraculix kernel: [   41.504833] Bridge firewalling 
registered
Mar 22 15:38:41 Miraculix NetworkManager[1283]: 
nm_connection_get_setting_connection: assertion 'connection != NULL' failed
Mar 22 15:38:41 Miraculix kernel: [   41.813432] vboxdrv: module 
verification failed: signature and/or  required key missing - tainting 
kernel
Mar 22 15:38:41 Miraculix kernel: [   41.817304] vboxdrv: Found 8 
processor cores.
Mar 22 15:38:41 Miraculix kernel: [   41.817750] vboxdrv: fAsync=0 
offMin=0x1c8 offMax=0x69fe
Mar 22 15:38:41 Miraculix kernel: [   41.817830] vboxdrv: TSC mode is 
'synchronous', kernel timer mode is 'normal'.
Mar 22 15:38:41 Miraculix kernel: [   41.817833] vboxdrv: Successfully 
loaded version 4.3.6_Ubuntu (interface 0x001a0007).
Mar 22 15:38:41 Miraculix NetworkManager[1283]: 
nm_connection_get_setting_connection: assertion 'connection != NULL' failed
Mar 22 15:38:42 Miraculix NetworkManager[1283]: <info> Auto-activating 
connection 'Scotty Beam Me Up'.
Mar 22 15:38:42 Miraculix NetworkManager[1283]: <info> Activation 
(wlan0) starting connection 'Scotty Beam Me Up'
Mar 22 15:38:42 Miraculix NetworkManager[1283]: <info> (wlan0): device 
state change: disconnected -> prepare (reason 'none') [30 40 0]
Mar 22 15:38:42 Miraculix NetworkManager[1283]: <info> NetworkManager 
state is now CONNECTING
Mar 22 15:38:42 Miraculix NetworkManager[1283]: <info> Activation 
(wlan0) Stage 1 of 5 (Device Prepare) scheduled...
Mar 22 15:38:42 Miraculix NetworkManager[1283]: <info> Activation 
(wlan0) Stage 1 of 5 (Device Prepare) started...
Mar 22 15:38:42 Miraculix NetworkManager[1283]: <info> Activation 
(wlan0) Stage 2 of 5 (Device Configure) scheduled...
Mar 22 15:38:42 Miraculix NetworkManager[1283]: <info> Activation 
(wlan0) Stage 1 of 5 (Device Prepare) complete.
Mar 22 15:38:42 Miraculix NetworkManager[1283]: <info> Activation 
(wlan0) Stage 2 of 5 (Device Configure) starting...
Mar 22 15:38:42 Miraculix NetworkManager[1283]: <info> (wlan0): device 
state change: prepare -> config (reason 'none') [40 50 0]
Mar 22 15:38:42 Miraculix NetworkManager[1283]: <info> Activation 
(wlan0/wireless): connection 'Scotty Beam Me Up' has security, and 
secrets exist.  No new secrets needed.
Mar 22 15:38:42 Miraculix NetworkManager[1283]: <info> Config: added 
'ssid' value 'Scotty Beam Me Up'
Mar 22 15:38:42 Miraculix NetworkManager[1283]: <info> Config: added 
'scan_ssid' value '1'
Mar 22 15:38:42 Miraculix NetworkManager[1283]: <info> Config: added 
'key_mgmt' value 'WPA-PSK'
Mar 22 15:38:42 Miraculix NetworkManager[1283]: <info> Config: added 
'auth_alg' value 'OPEN'
Mar 22 15:38:42 Miraculix NetworkManager[1283]: <info> Config: added 
'psk' value '<omitted>'
Mar 22 15:38:42 Miraculix NetworkManager[1283]: <info> Activation 
(wlan0) Stage 2 of 5 (Device Configure) complete.
Mar 22 15:38:42 Miraculix NetworkManager[1283]: <info> Config: set 
interface ap_scan to 1
Mar 22 15:38:42 Miraculix NetworkManager[1283]: <info> (wlan0): 
supplicant interface state: disconnected -> inactive
Mar 22 15:38:42 Miraculix wpa_supplicant[1555]: wlan0: SME: Trying to 
authenticate with 24:65:11:53:8d:21 (SSID='Scotty Beam Me Up' freq=2462 MHz)
Mar 22 15:38:42 Miraculix kernel: [   41.880693] wlan0: authenticate 
with 24:65:11:53:8d:21
Mar 22 15:38:42 Miraculix NetworkManager[1283]: <info> (wlan0): 
supplicant interface state: inactive -> authenticating
Mar 22 15:38:42 Miraculix kernel: [   41.888688] wlan0: send auth to 
24:65:11:53:8d:21 (try 1/3)
Mar 22 15:38:42 Miraculix wpa_supplicant[1555]: wlan0: Trying to 
associate with 24:65:11:53:8d:21 (SSID='Scotty Beam Me Up' freq=2462 MHz)
Mar 22 15:38:42 Miraculix kernel: [   41.908884] wlan0: authenticated
Mar 22 15:38:42 Miraculix kernel: [   41.911431] wlan0: associate with 
24:65:11:53:8d:21 (try 1/3)
Mar 22 15:38:42 Miraculix NetworkManager[1283]: <info> (wlan0): 
supplicant interface state: authenticating -> associating
Mar 22 15:38:42 Miraculix kernel: [   41.926172] wlan0: RX AssocResp 
from 24:65:11:53:8d:21 (capab=0x431 status=0 aid=3)
Mar 22 15:38:42 Miraculix wpa_supplicant[1555]: wlan0: Associated with 
24:65:11:53:8d:21
Mar 22 15:38:42 Miraculix kernel: [   41.945673] wlan0: associated
Mar 22 15:38:42 Miraculix kernel: [   41.945711] IPv6: 
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
Mar 22 15:38:42 Miraculix kernel: [   41.945793] cfg80211: Calling CRDA 
for country: DE
Mar 22 15:38:42 Miraculix NetworkManager[1283]: <info> (wlan0): 
supplicant interface state: associating -> associated
Mar 22 15:38:42 Miraculix kernel: [   41.948026] cfg80211: Regulatory 
domain changed to country: DE
Mar 22 15:38:42 Miraculix kernel: [   41.948029] cfg80211:  DFS Master 
region: unset
Mar 22 15:38:42 Miraculix kernel: [   41.948031] cfg80211: (start_freq - 
end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Mar 22 15:38:42 Miraculix kernel: [   41.948033] cfg80211: (2400000 KHz 
- 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
Mar 22 15:38:42 Miraculix kernel: [   41.948034] cfg80211: (5150000 KHz 
- 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Mar 22 15:38:42 Miraculix kernel: [   41.948035] cfg80211: (5250000 KHz 
- 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Mar 22 15:38:42 Miraculix kernel: [   41.948037] cfg80211: (5470000 KHz 
- 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
Mar 22 15:38:42 Miraculix kernel: [   41.948038] cfg80211: (57240000 KHz 
- 65880000 KHz @ 2160000 KHz), (N/A, 4000 mBm)
Mar 22 15:38:42 Miraculix NetworkManager[1283]: <info> (wlan0): 
supplicant interface state: associated -> 4-way handshake
Mar 22 15:38:42 Miraculix kernel: [   42.074440] vboxpci: IOMMU not 
found (not registered)
Mar 22 15:38:42 Miraculix wpa_supplicant[1555]: wlan0: WPA: Key 
negotiation completed with 24:65:11:53:8d:21 [PTK=CCMP GTK=TKIP]
Mar 22 15:38:42 Miraculix wpa_supplicant[1555]: wlan0: 
CTRL-EVENT-CONNECTED - Connection to 24:65:11:53:8d:21 completed [id=0 
id_str=]
Mar 22 15:38:42 Miraculix NetworkManager[1283]: <info> (wlan0): 
supplicant interface state: 4-way handshake -> completed
Mar 22 15:38:42 Miraculix NetworkManager[1283]: <info> Activation 
(wlan0/wireless) Stage 2 of 5 (Device Configure) successful.  Connected 
to wireless network 'Scotty Beam Me Up'.
Mar 22 15:38:42 Miraculix acvpnagent[2473]: Cisco AnyConnect Secure 
Mobility Client Agent started, version 3.0.4235
Mar 22 15:38:42 Miraculix acvpnagent[2473]: Function: Open File: 
Utility/Directory.cpp Line: 101 opendir
Mar 22 15:38:42 Miraculix acvpnagent[2473]: Function: Directory File: 
Utility/Directory.cpp Line: 31 Invoked Function: Directory::open Return 
Code: -27787253 (0xFE58000B) Description: 
DIRECTORY_ERROR_DIRECTORY_NOT_FOUND
Mar 22 15:38:42 Miraculix acvpnagent[2473]: Function: 
FindAvailablePlugins File: Utility/PluginLoader.cpp Line: 176 Plugin 
directory /opt/cisco/anyconnect/bin/plugins/ failed to load, skipping 
load of plugins
Mar 22 15:38:42 Miraculix acvpnagent[2473]: Function: AddNewWatch File: 
Utility/FileSystemWatcher.cpp Line: 538 Invoked Function: 
inotify_add_watch Return Code: 2 (0x00000002) Description: unknown
Mar 22 15:38:42 Miraculix acvpnagent[2473]: Function: StartMonitor File: 
Utility/FileSystemWatcher.cpp Line: 212 Invoked Function: 
CFileSystemWatcher::AddNewWatch Return Code: -29163501 (0xFE430013) 
Description: FILESYSTEMWATCHER_ERROR_ADD_WATCH_FAILED
Mar 22 15:38:42 Miraculix acvpnagent[2473]: Function: CFileSystemWatcher 
File: Utility/FileSystemWatcher.cpp Line: 69 Invoked Function: 
CFileSystemWatcher::StartMonitor Return Code: -29163501 (0xFE430013) 
Description: FILESYSTEMWATCHER_ERROR_ADD_WATCH_FAILED
Mar 22 15:38:42 Miraculix acvpnagent[2473]: Function: 
SetupDirChangeEvent File: Utility/PluginLoader.cpp Line: 1360 Invoked 
Function: CCEvent Return Code: -29163501 (0xFE430013) Description: 
FILESYSTEMWATCHER_ERROR_ADD_WATCH_FAILED CFileSystemWatcher
Mar 22 15:38:42 Miraculix NetworkManager[1283]: <info> Activation 
(wlan0) Stage 3 of 5 (IP Configure Start) scheduled.
Mar 22 15:38:42 Miraculix NetworkManager[1283]: <info> Activation 
(wlan0) Stage 3 of 5 (IP Configure Start) started...
Mar 22 15:38:42 Miraculix NetworkManager[1283]: <info> (wlan0): device 
state change: config -> ip-config (reason 'none') [50 70 0]
Mar 22 15:38:42 Miraculix acvpnagent[2473]: Function: loadProfiles File: 
ProfileMgr.cpp Line: 110 No profile is available.
Mar 22 15:38:42 Miraculix acvpnagent[2473]: Current Preference Settings: 
ServiceDisable: false CertificateStoreOverride: false CertificateStore: 
All ShowPreConnectMessage: false AutoConnectOnStart: false 
MinimizeOnConnect: true LocalLanAccess: false AutoReconnect: true 
AutoUpdate: true ProxySettings: Native AllowLocalProxyConnections: true 
PPPExclusion: Disable PPPExclusionServerIP:  EnableScripting: false 
TerminateScriptOnNextEvent: false AuthenticationTimeout: 12
Mar 22 15:38:42 Miraculix acvpnagent[2473]: Function: logInterfaces 
File: RouteMgr.cpp Line: 2105 Invoked Function: logInterfaces Return 
Code: 0 (0x00000000) Description: IP Address Interface List: 
FE80:0:0:0:A64E:31FF:FE3E:C1EC
Mar 22 15:38:42 Miraculix acvpnagent[2473]: Function: 
readConfigParamFromFile File: vpnconfig.cpp Line: 4556 The specified 
configuration file for MUS service does not exist
Mar 22 15:38:42 Miraculix acvpnagent[2473]: Function: Open File: 
Utility/Directory.cpp Line: 101 opendir
Mar 22 15:38:42 Miraculix acvpnagent[2473]: Function: Directory File: 
Utility/Directory.cpp Line: 31 Invoked Function: Directory::open Return 
Code: -27787253 (0xFE58000B) Description: 
DIRECTORY_ERROR_DIRECTORY_NOT_FOUND
Mar 22 15:38:42 Miraculix acvpnagent[2473]: Function: 
FindAvailablePlugins File: Utility/PluginLoader.cpp Line: 176 Plugin 
directory /opt/cisco/anyconnect/bin/plugins/ failed to load, skipping 
load of plugins
Mar 22 15:38:42 Miraculix NetworkManager[1283]: <info> Activation 
(wlan0) Beginning DHCPv4 transaction (timeout in 45 seconds)
Mar 22 15:38:42 Miraculix symcfgd: --- symcfgd started (pid 2604) ---
Mar 22 15:38:42 Miraculix symcfgd: symcfgd running as daemon
Mar 22 15:38:42 Miraculix symcfgd: listening on local socket (abstract): 
sym_config_ipc
Mar 22 15:38:42 Miraculix NetworkManager[1283]: <info> dhclient started 
with pid 2608
Mar 22 15:38:42 Miraculix NetworkManager[1283]: <info> Activation 
(wlan0) Beginning IP6 addrconf.
Mar 22 15:38:42 Miraculix acvpnagent[2473]: Function: 
tableCallbackHandler File: RouteMgr.cpp Line: 1723 Invoked Function: 
recv Return Code: 11 (0x0000000B) Description: unknown
Mar 22 15:38:42 Miraculix NetworkManager[1283]: <info> Activation 
(wlan0) Stage 3 of 5 (IP Configure Start) complete.
Mar 22 15:38:42 Miraculix dhclient: Internet Systems Consortium DHCP 
Client 4.2.4
Mar 22 15:38:42 Miraculix dhclient: Copyright 2004-2012 Internet Systems 
Consortium.
Mar 22 15:38:42 Miraculix dhclient: All rights reserved.
Mar 22 15:38:42 Miraculix dhclient: For info, please visit 
https://www.isc.org/software/dhcp/
Mar 22 15:38:42 Miraculix dhclient:
Mar 22 15:38:42 Miraculix NetworkManager[1283]: <info> (wlan0): DHCPv4 
state changed nbi -> preinit
Mar 22 15:38:42 Miraculix dhclient: Listening on LPF/wlan0/a4:4e:31:3e:c1:ec
Mar 22 15:38:42 Miraculix dhclient: Sending on LPF/wlan0/a4:4e:31:3e:c1:ec
Mar 22 15:38:42 Miraculix dhclient: Sending on   Socket/fallback
Mar 22 15:38:42 Miraculix dhclient: DHCPREQUEST of 192.168.178.31 on 
wlan0 to 255.255.255.255 port 67 (xid=0x5fd3ccc5)
Mar 22 15:38:42 Miraculix dhclient: DHCPACK of 192.168.178.31 from 
192.168.178.1
Mar 22 15:38:42 Miraculix dhclient: bound to 192.168.178.31 -- renewal 
in 355585 seconds.
Mar 22 15:38:42 Miraculix NetworkManager[1283]: <info> (wlan0): DHCPv4 
state changed preinit -> reboot
Mar 22 15:38:42 Miraculix NetworkManager[1283]: <info> address 
192.168.178.31
Mar 22 15:38:42 Miraculix NetworkManager[1283]: <info> prefix 24 
(255.255.255.0)
Mar 22 15:38:42 Miraculix NetworkManager[1283]: <info> gateway 192.168.178.1
Mar 22 15:38:42 Miraculix NetworkManager[1283]: <info> nameserver 
'192.168.178.1'
Mar 22 15:38:42 Miraculix NetworkManager[1283]: <info> domain name 
'fritz.box'
Mar 22 15:38:42 Miraculix NetworkManager[1283]: <info> Activation 
(wlan0) Stage 5 of 5 (IPv4 Configure Commit) scheduled...
Mar 22 15:38:42 Miraculix NetworkManager[1283]: <info> Activation 
(wlan0) Stage 5 of 5 (IPv4 Commit) started...
Mar 22 15:38:42 Miraculix avahi-daemon[1183]: Joining mDNS multicast 
group on interface wlan0.IPv4 with address 192.168.178.31.
Mar 22 15:38:42 Miraculix avahi-daemon[1183]: New relevant interface 
wlan0.IPv4 for mDNS.
Mar 22 15:38:42 Miraculix avahi-daemon[1183]: Registering new address 
record for 192.168.178.31 on wlan0.IPv4.
Mar 22 15:38:42 Miraculix acvpnagent[2473]: message repeated 2 times: [ 
Function: tableCallbackHandler File: RouteMgr.cpp Line: 1723 Invoked 
Function: recv Return Code: 11 (0x0000000B) Description: unknown ]
Mar 22 15:38:42 Miraculix acvpnagent[2473]: A new network interface has 
been detected.
Mar 22 15:38:42 Miraculix acvpnagent[2473]: Function: logInterfaces 
File: RouteMgr.cpp Line: 2105 Invoked Function: logInterfaces Return 
Code: 0 (0x00000000) Description: IP Address Interface List: 
192.168.178.31 FE80:0:0:0:A64E:31FF:FE3E:C1EC
Mar 22 15:38:42 Miraculix acvpnagent[2473]: Function: 
tableCallbackHandler File: RouteMgr.cpp Line: 1723 Invoked Function: 
recv Return Code: 11 (0x0000000B) Description: unknown
Mar 22 15:38:43 Miraculix NetworkManager[1283]: <info> (wlan0): device 
state change: ip-config -> secondaries (reason 'none') [70 90 0]
Mar 22 15:38:43 Miraculix NetworkManager[1283]: <info> Activation 
(wlan0) Stage 5 of 5 (IPv4 Commit) complete.
Mar 22 15:38:43 Miraculix NetworkManager[1283]: <info> (wlan0): device 
state change: secondaries -> activated (reason 'none') [90 100 0]
Mar 22 15:38:44 Miraculix NetworkManager[1283]: <info> NetworkManager 
state is now CONNECTED_GLOBAL
Mar 22 15:38:44 Miraculix NetworkManager[1283]: <info> Policy set 
'Scotty Beam Me Up' (wlan0) as default for IPv4 routing and DNS.
Mar 22 15:38:44 Miraculix NetworkManager[1283]: <info> DNS: starting 
dnsmasq...
Mar 22 15:38:44 Miraculix NetworkManager[1283]: <warn> dnsmasq not 
available on the bus, can't update servers.
Mar 22 15:38:44 Miraculix NetworkManager[1283]: <error> 
[1395499124.71103] [nm-dns-dnsmasq.c:400] update(): dnsmasq owner not 
found on bus: Could not get owner of name 
'org.freedesktop.NetworkManager.dnsmasq': no such name
Mar 22 15:38:44 Miraculix NetworkManager[1283]: <warn> DNS: plugin 
dnsmasq update failed
Mar 22 15:38:44 Miraculix NetworkManager[1283]: <info> Writing DNS 
information to /sbin/resolvconf
Mar 22 15:38:44 Miraculix dnsmasq[2631]: started, version 2.68 cache 
disabled
Mar 22 15:38:44 Miraculix dnsmasq[2631]: compile time options: IPv6 
GNU-getopt DBus i18n IDN DHCP DHCPv6 no-Lua TFTP conntrack ipset auth
Mar 22 15:38:44 Miraculix dnsmasq[2631]: DBus support enabled: connected 
to system bus
Mar 22 15:38:44 Miraculix dnsmasq[2631]: warning: no upstream servers 
configured
Mar 22 15:38:44 Miraculix NetworkManager[1283]: <info> Activation 
(wlan0) successful, device activated.
Mar 22 15:38:44 Miraculix dbus[1060]: [system] Activating service 
name='org.freedesktop.nm_dispatcher' (using servicehelper)
Mar 22 15:38:44 Miraculix NetworkManager[1283]: <warn> dnsmasq appeared 
on DBus: :1.19
Mar 22 15:38:44 Miraculix NetworkManager[1283]: <info> Writing DNS 
information to /sbin/resolvconf
Mar 22 15:38:44 Miraculix dnsmasq[2631]: setting upstream servers from DBus
Mar 22 15:38:44 Miraculix dnsmasq[2631]: using nameserver 192.168.178.1#53
Mar 22 15:38:44 Miraculix dbus[1060]: [system] Successfully activated 
service 'org.freedesktop.nm_dispatcher'
Mar 22 15:38:44 Miraculix ntpdate[2732]: Can't find host ntp.ubuntu.com: 
Name or service not known (-2)
Mar 22 15:38:44 Miraculix ntpdate[2732]: no servers can be used, exiting
Mar 22 15:38:44 Miraculix avahi-daemon[1183]: Joining mDNS multicast 
group on interface wlan0.IPv6 with address fe80::a64e:31ff:fe3e:c1ec.
Mar 22 15:38:44 Miraculix avahi-daemon[1183]: New relevant interface 
wlan0.IPv6 for mDNS.
Mar 22 15:38:44 Miraculix avahi-daemon[1183]: Registering new address 
record for fe80::a64e:31ff:fe3e:c1ec on wlan0.*.
Mar 22 15:38:45 Miraculix dbus[1060]: [system] Activating service 
name='org.freedesktop.UPower' (using servicehelper)
Mar 22 15:38:45 Miraculix saned[2798]: saned (AF-indep+IPv6) from 
sane-backends 1.0.23 starting up
Mar 22 15:38:45 Miraculix saned[2798]: do_bindings: [0] bind failed: 
Address already in use
Mar 22 15:38:45 Miraculix saned[2799]: Now daemonized
Mar 22 15:38:45 Miraculix saned[2799]: Dropped privileges to uid 114 gid 123
Mar 22 15:38:45 Miraculix dbus[1060]: [system] Successfully activated 
service 'org.freedesktop.UPower'
Mar 22 15:38:46 Miraculix dnsmasq[1843]: reading 
/var/run/dnsmasq/resolv.conf
Mar 22 15:38:46 Miraculix dnsmasq[1843]: using nameserver 127.0.1.1#53
Mar 22 15:38:45 Miraculix whoopsie[1809]: message repeated 3 times: [ 
offline]
Mar 22 15:38:46 Miraculix whoopsie[1809]: online
Mar 22 15:38:46 Miraculix dbus[1060]: [system] Activating service 
name='org.freedesktop.systemd1' (using servicehelper)
Mar 22 15:38:46 Miraculix dbus[1060]: [system] Successfully activated 
service 'org.freedesktop.systemd1'
Mar 22 15:38:46 Miraculix rtvscand: --- rtvscand started (pid 2971) ---
Mar 22 15:38:46 Miraculix rtvscand: rtvscand running as daemon
Mar 22 15:38:46 Miraculix anacron[3018]: Anacron 2.3 started on 2014-03-22
Mar 22 15:38:46 Miraculix anacron[3018]: Normal exit (0 jobs run)
Mar 22 15:38:47 Miraculix dbus[1060]: [system] Activating service 
name='org.freedesktop.ColorManager' (using servicehelper)
Mar 22 15:38:47 Miraculix colord: Using config file /etc/colord.conf
Mar 22 15:38:47 Miraculix colord: Using mapping database file 
/var/lib/colord/mapping.db
Mar 22 15:38:47 Miraculix NetworkManager[1283]: SCPlugin-Ifupdown: 
devices added (path: /sys/devices/virtual/net/cscotun0, iface: cscotun0)
Mar 22 15:38:47 Miraculix NetworkManager[1283]: SCPlugin-Ifupdown: 
device added (path: /sys/devices/virtual/net/cscotun0, iface: cscotun0): 
no ifupdown configuration found.
Mar 22 15:38:47 Miraculix avahi-daemon[1183]: Withdrawing workstation 
service for cscotun0.
Mar 22 15:38:47 Miraculix NetworkManager[1283]: <warn> 
/sys/devices/virtual/net/cscotun0: couldn't determine device driver; 
ignoring...
Mar 22 15:38:47 Miraculix NetworkManager[1283]: SCPlugin-Ifupdown: 
devices removed (path: /sys/devices/virtual/net/cscotun0, iface: cscotun0)
Mar 22 15:38:47 Miraculix colord: Using device database file 
/var/lib/colord/storage.db
Mar 22 15:38:47 Miraculix colord: loaded plugin libcd_plugin_scanner.so
Mar 22 15:38:47 Miraculix colord: plugin 
/usr/lib/x86_64-linux-gnu/colord-plugins/libcd_plugin_sane.so not 
loaded: plugin refused to load
Mar 22 15:38:47 Miraculix colord: loaded plugin libcd_plugin_camera.so
Mar 22 15:38:47 Miraculix colord: Daemon ready for requests
Mar 22 15:38:47 Miraculix dbus[1060]: [system] Successfully activated 
service 'org.freedesktop.ColorManager'
Mar 22 15:38:47 Miraculix colord: Profile added: 
icc-526fbc9bdf0d7156c553998d47a3b5fc
Mar 22 15:38:47 Miraculix colord: Profile added: 
icc-c3e6382fa9b2d31b01b736f6f97aac3a
Mar 22 15:38:47 Miraculix colord: Profile added: 
icc-0383c34650771ce95ef93fe916867725
Mar 22 15:38:47 Miraculix colord: Profile added: 
icc-2f1f11ecd613fe5551420fcaf5b11ff8
Mar 22 15:38:47 Miraculix colord: Profile added: 
icc-d6490883a866e4059370e1de1d840283
Mar 22 15:38:47 Miraculix colord: Profile added: 
icc-ea421e3a65cfa796e2732ce36086e327
Mar 22 15:38:47 Miraculix colord: Profile added: 
icc-6ad6d63767ce0393245528ada92f1cb2
Mar 22 15:38:47 Miraculix colord: Profile added: 
icc-0720e7cdbc792b77c0740c39f325ef9e
Mar 22 15:38:47 Miraculix colord: Profile added: 
icc-a1d13bd5309e0f06ceda6f0d75367823
Mar 22 15:38:47 Miraculix colord: Profile added: 
icc-57f0d896250f6f98f77ca1b0d19019c0
Mar 22 15:38:47 Miraculix colord: Profile added: 
icc-fb0ac62618f016ed9b92ce239258efa8
Mar 22 15:38:47 Miraculix colord: Profile added: 
icc-b0701c2ccf059287d0b067464df8bda9
Mar 22 15:38:47 Miraculix colord: Profile added: 
icc-3a34aa6c3d1fb1ef63ff41e04ee00979
Mar 22 15:38:47 Miraculix colord: Profile added: 
icc-654b99c87e67edb1c1cfb0dcb7fa9d04
Mar 22 15:38:47 Miraculix colord: Profile added: 
icc-523e494bc2f53c53d51d0758b07f4879
Mar 22 15:38:47 Miraculix colord: Profile added: 
icc-3bd2261b1125a0fd9ebf827a2d1bed84
Mar 22 15:38:47 Miraculix colord: Profile added: 
icc-353a6bcabda00f04b6988f89126ce6f5
Mar 22 15:38:47 Miraculix colord: Profile added: 
icc-f64a1f19ce07290b35a752b00217b684
Mar 22 15:38:47 Miraculix colord: Profile added: 
icc-df7c0067b1eb9bcc9fc9b33bc3a797eb
Mar 22 15:38:47 Miraculix colord: Profile added: 
icc-d4a7a2bd8ddaacf10e275e3db31d72b8
Mar 22 15:38:47 Miraculix colord: Profile added: 
icc-72f5b1cba915b68ea75cc843e270df5a
Mar 22 15:38:47 Miraculix colord: Profile added: 
icc-a10be98be58460669fcdc6946939b7cf
Mar 22 15:38:47 Miraculix colord: Profile added: 
icc-c227f46f246694ba9971f270cb61a0c1
Mar 22 15:38:47 Miraculix colord: Profile added: 
icc-6a245ab2d8892e2e56232af93cd48b81
Mar 22 15:38:48 Miraculix colord: Sensor added: huey-00
Mar 22 15:38:48 Miraculix NetworkManager[1283]: <info> WiFi hardware 
radio set enabled
Mar 22 15:38:48 Miraculix colord: Device added: xrandr-AU Optronics
Mar 22 15:38:48 Miraculix colord: Device added: xrandr-Samsung Electric 
Company-SyncMaster-H9XS402827
Mar 22 15:38:48 Miraculix colord: Profile added: 
icc-4a094879e7e77ea14af1f3ae42950c7e
Mar 22 15:38:48 Miraculix colord: Automatic metadata add 
icc-c6317dd6f0e519463b2fb31b774c8b9e to xrandr-Samsung Electric 
Company-SyncMaster-H9XS402827
Mar 22 15:38:48 Miraculix colord: Profile added: 
icc-c6317dd6f0e519463b2fb31b774c8b9e
Mar 22 15:38:48 Miraculix colord: Automatic metadata add 
icc-38ea73469d2df4ed8967411ac5cfe86f to xrandr-AU Optronics
Mar 22 15:38:48 Miraculix colord: Profile added: 
icc-38ea73469d2df4ed8967411ac5cfe86f
Mar 22 15:38:49 Miraculix pulseaudio[3231]: [pulseaudio] authkey.c: 
Failed to open cookie file '/var/lib/lightdm/.config/pulse/cookie': No 
such file or directory
Mar 22 15:38:49 Miraculix pulseaudio[3231]: [pulseaudio] authkey.c: 
Failed to load authorization key 
'/var/lib/lightdm/.config/pulse/cookie': No such file or directory
Mar 22 15:38:49 Miraculix dbus[1060]: [system] Activating service 
name='org.freedesktop.RealtimeKit1' (using servicehelper)
Mar 22 15:38:49 Miraculix dbus[1060]: [system] Successfully activated 
service 'org.freedesktop.RealtimeKit1'
Mar 22 15:38:49 Miraculix rtkit-daemon[3263]: Successfully called chroot.
Mar 22 15:38:49 Miraculix rtkit-daemon[3263]: Successfully dropped 
privileges.
Mar 22 15:38:49 Miraculix rtkit-daemon[3263]: Successfully limited 
resources.
Mar 22 15:38:49 Miraculix rtkit-daemon[3263]: Running.
Mar 22 15:38:49 Miraculix rtkit-daemon[3263]: Watchdog thread running.
Mar 22 15:38:49 Miraculix rtkit-daemon[3263]: Canary thread running.
Mar 22 15:38:49 Miraculix rtkit-daemon[3263]: Successfully made thread 
3261 of process 3261 (n/a) owned by '110' high priority at nice level -11.
Mar 22 15:38:49 Miraculix rtkit-daemon[3263]: Supervising 1 threads of 1 
processes of 1 users.
Mar 22 15:38:49 Miraculix pulseaudio[3264]: [pulseaudio] authkey.c: 
Failed to open cookie file '/var/lib/lightdm/.config/pulse/cookie': No 
such file or directory
Mar 22 15:38:49 Miraculix pulseaudio[3264]: [pulseaudio] authkey.c: 
Failed to load authorization key 
'/var/lib/lightdm/.config/pulse/cookie': No such file or directory
Mar 22 15:38:49 Miraculix rtkit-daemon[3263]: Successfully made thread 
3273 of process 3261 (n/a) owned by '110' RT at priority 5.
Mar 22 15:38:49 Miraculix rtkit-daemon[3263]: Supervising 2 threads of 1 
processes of 1 users.
Mar 22 15:38:49 Miraculix rtkit-daemon[3263]: Successfully made thread 
3274 of process 3261 (n/a) owned by '110' RT at priority 5.
Mar 22 15:38:49 Miraculix rtkit-daemon[3263]: Supervising 3 threads of 1 
processes of 1 users.
Mar 22 15:38:49 Miraculix rtkit-daemon[3263]: Successfully made thread 
3275 of process 3261 (n/a) owned by '110' RT at priority 5.
Mar 22 15:38:49 Miraculix rtkit-daemon[3263]: Supervising 4 threads of 1 
processes of 1 users.
Mar 22 15:38:49 Miraculix pulseaudio[3261]: [pulseaudio] authkey.c: 
Failed to open cookie file '/var/lib/lightdm/.config/pulse/cookie': No 
such file or directory
Mar 22 15:38:49 Miraculix pulseaudio[3261]: [pulseaudio] authkey.c: 
Failed to load authorization key 
'/var/lib/lightdm/.config/pulse/cookie': No such file or directory
Mar 22 15:38:49 Miraculix bluetoothd[1105]: Endpoint registered: 
sender=:1.48 path=/MediaEndpoint/HFPAG
Mar 22 15:38:49 Miraculix bluetoothd[1105]: Endpoint registered: 
sender=:1.48 path=/MediaEndpoint/HFPHS
Mar 22 15:38:49 Miraculix bluetoothd[1105]: Endpoint registered: 
sender=:1.48 path=/MediaEndpoint/A2DPSource
Mar 22 15:38:49 Miraculix bluetoothd[1105]: Endpoint registered: 
sender=:1.48 path=/MediaEndpoint/A2DPSink
Mar 22 15:38:49 Miraculix rtkit-daemon[3263]: Successfully made thread 
3278 of process 3278 (n/a) owned by '110' high priority at nice level -11.
Mar 22 15:38:49 Miraculix rtkit-daemon[3263]: Supervising 5 threads of 2 
processes of 1 users.
Mar 22 15:38:49 Miraculix pulseaudio[3278]: [pulseaudio] pid.c: Daemon 
already running.
Mar 22 15:38:53 Miraculix ModemManager[1089]: <info> Creating modem with 
plugin 'Generic' and '1' ports
Mar 22 15:38:53 Miraculix ModemManager[1089]: <warn>  Could not grab 
port (tty/ttyS4): 'Cannot add port 'tty/ttyS4', unhandled serial type'
Mar 22 15:38:53 Miraculix ModemManager[1089]: <warn> Couldn't create 
modem for device at '/sys/devices/pci0000:00/0000:00:16.3': Failed to 
find primary AT port
Mar 22 15:38:54 Miraculix colord: device removed: xrandr-AU Optronics
Mar 22 15:38:54 Miraculix colord: device removed: xrandr-Samsung 
Electric Company-SyncMaster-H9XS402827
Mar 22 15:38:54 Miraculix colord: Profile removed: 
icc-4a094879e7e77ea14af1f3ae42950c7e
Mar 22 15:38:54 Miraculix colord: Profile removed: 
icc-c6317dd6f0e519463b2fb31b774c8b9e
Mar 22 15:38:54 Miraculix colord: Profile removed: 
icc-38ea73469d2df4ed8967411ac5cfe86f
Mar 22 15:38:56 Miraculix rtvscand: New virus definition file loaded. 
Version: 160320a.
Mar 22 15:38:57 Miraculix dbus[1060]: [system] Activating service 
name='org.freedesktop.systemd1' (using servicehelper)
Mar 22 15:38:57 Miraculix dbus[1060]: [system] Successfully activated 
service 'org.freedesktop.systemd1'
Mar 22 15:38:57 Miraculix rtkit-daemon[3263]: Successfully made thread 
3825 of process 3825 (n/a) owned by '1000' high priority at nice level -11.
Mar 22 15:38:57 Miraculix rtkit-daemon[3263]: Supervising 5 threads of 2 
processes of 2 users.
Mar 22 15:38:57 Miraculix gnome-session[3686]: WARNING: Could not parse 
desktop file gwibber.desktop or it references a not found TryExec binary
Mar 22 15:38:57 Miraculix rtkit-daemon[3263]: Successfully made thread 
3918 of process 3825 (n/a) owned by '1000' RT at priority 5.
Mar 22 15:38:57 Miraculix rtkit-daemon[3263]: Supervising 6 threads of 2 
processes of 2 users.
Mar 22 15:38:57 Miraculix rtkit-daemon[3263]: Successfully made thread 
3919 of process 3825 (n/a) owned by '1000' RT at priority 5.
Mar 22 15:38:57 Miraculix rtkit-daemon[3263]: Supervising 7 threads of 2 
processes of 2 users.
Mar 22 15:38:57 Miraculix rtkit-daemon[3263]: Successfully made thread 
3920 of process 3825 (n/a) owned by '1000' RT at priority 5.
Mar 22 15:38:57 Miraculix rtkit-daemon[3263]: Supervising 8 threads of 2 
processes of 2 users.
Mar 22 15:38:57 Miraculix bluetoothd[1105]: Endpoint registered: 
sender=:1.95 path=/MediaEndpoint/HFPAG
Mar 22 15:38:57 Miraculix bluetoothd[1105]: Endpoint registered: 
sender=:1.95 path=/MediaEndpoint/HFPHS
Mar 22 15:38:57 Miraculix bluetoothd[1105]: Endpoint registered: 
sender=:1.95 path=/MediaEndpoint/A2DPSource
Mar 22 15:38:57 Miraculix bluetoothd[1105]: Endpoint registered: 
sender=:1.95 path=/MediaEndpoint/A2DPSink
Mar 22 15:38:57 Miraculix rtkit-daemon[3263]: Successfully made thread 
3928 of process 3928 (n/a) owned by '1000' high priority at nice level -11.
Mar 22 15:38:57 Miraculix rtkit-daemon[3263]: Supervising 9 threads of 3 
processes of 2 users.
Mar 22 15:38:57 Miraculix pulseaudio[3928]: [pulseaudio] pid.c: Daemon 
already running.
Mar 22 15:38:57 Miraculix rtkit-daemon[3263]: Successfully made thread 
3930 of process 3930 (n/a) owned by '1000' high priority at nice level -11.
Mar 22 15:38:57 Miraculix rtkit-daemon[3263]: Supervising 9 threads of 3 
processes of 2 users.
Mar 22 15:38:57 Miraculix pulseaudio[3930]: [pulseaudio] pid.c: Daemon 
already running.
Mar 22 15:38:58 Miraculix rtvscand: Symantec AntiVirus services startup 
was successful.
Mar 22 15:38:58 Miraculix dbus[1060]: [system] Activating service 
name='org.freedesktop.locale1' (using servicehelper)
Mar 22 15:38:58 Miraculix dbus[1060]: [system] Successfully activated 
service 'org.freedesktop.locale1'
Mar 22 15:38:58 Miraculix colord: Device added: xrandr-AU Optronics
Mar 22 15:38:58 Miraculix colord: Device added: xrandr-Samsung Electric 
Company-SyncMaster-H9XS402827
Mar 22 15:38:59 Miraculix colord: Automatic metadata add 
icc-685c23de886b15ddd6070bafa091bebf to xrandr-Samsung Electric 
Company-SyncMaster-H9XS402827
Mar 22 15:38:59 Miraculix colord: Profile added: 
icc-685c23de886b15ddd6070bafa091bebf
Mar 22 15:38:59 Miraculix colord: Profile added: 
icc-7f2d4a0b6300467d941ce0ea43c97d94
Mar 22 15:38:59 Miraculix colord: Profile added: 
icc-7772fe49b9dfc5d6c3ce02317a4d1062
Mar 22 15:38:59 Miraculix colord: Profile added: 
icc-62a8280b1c9913309065a69942da745c
Mar 22 15:38:59 Miraculix colord: Automatic metadata add 
icc-b06e8b1738e4edbcb90676b27d8005ae to xrandr-AU Optronics
Mar 22 15:38:59 Miraculix colord: Profile added: 
icc-b06e8b1738e4edbcb90676b27d8005ae
Mar 22 15:38:59 Miraculix colord: Profile added: 
icc-fc77ebdffdbdaf40870be44e6743df06
Mar 22 15:38:59 Miraculix colord: Profile added: 
icc-f84c090431049f227029ac1a3afa03db
Mar 22 15:38:59 Miraculix colord: Profile added: 
icc-07de6f5e2c50a559dbd24075ddc58d5c
Mar 22 15:38:59 Miraculix gnome-session[3686]: GLib-CRITICAL: 
g_environ_setenv: assertion 'value != NULL' failed
Mar 22 15:38:59 Miraculix goa[3937]: goa-daemon version 3.10.2 starting 
[main.c:117, main()]
Mar 22 15:38:59 Miraculix dbus[1060]: [system] Activating service 
name='org.freedesktop.UDisks2' (using servicehelper)
Mar 22 15:38:59 Miraculix udisksd[4073]: udisks daemon version 2.1.3 
starting
Mar 22 15:39:00 Miraculix dbus[1060]: [system] Successfully activated 
service 'org.freedesktop.UDisks2'
Mar 22 15:39:00 Miraculix udisksd[4073]: Acquired the name 
org.freedesktop.UDisks2 on the system message bus
Mar 22 15:39:02 Miraculix wpa_supplicant[1555]: wlan0: 
CTRL-EVENT-SCAN-STARTED
Mar 22 15:39:03 Miraculix NetworkManager[1283]: <info> (wlan0): IP6 
addrconf timed out or failed.
Mar 22 15:39:03 Miraculix NetworkManager[1283]: <info> Activation 
(wlan0) Stage 4 of 5 (IPv6 Configure Timeout) scheduled...
Mar 22 15:39:03 Miraculix NetworkManager[1283]: <info> Activation 
(wlan0) Stage 4 of 5 (IPv6 Configure Timeout) started...
Mar 22 15:39:03 Miraculix NetworkManager[1283]: <info> Activation 
(wlan0) Stage 4 of 5 (IPv6 Configure Timeout) complete.
Mar 22 15:39:06 Miraculix kernel: [   66.621895] audit_printk_skb: 168 
callbacks suppressed
Mar 22 15:39:06 Miraculix kernel: [   66.621898] audit: type=1400 
audit(1395499146.773:68): apparmor="STATUS" operation="profile_replace" 
name="/usr/lib/cups/backend/cups-pdf" pid=4199 comm="apparmor_parser"
Mar 22 15:39:06 Miraculix kernel: [   66.621903] audit: type=1400 
audit(1395499146.773:69): apparmor="STATUS" operation="profile_replace" 
name="/usr/sbin/cupsd" pid=4199 comm="apparmor_parser"
Mar 22 15:39:06 Miraculix kernel: [   66.622218] audit: type=1400 
audit(1395499146.773:70): apparmor="STATUS" operation="profile_replace" 
name="/usr/sbin/cupsd" pid=4199 comm="apparmor_parser"
Mar 22 15:39:06 Miraculix colord: Profile added: CLX-3170-Series-Gray..
Mar 22 15:39:06 Miraculix colord: Device added: cups-CLX-3170-Series
Mar 22 15:39:06 Miraculix colord: Profile added: demazl3v-Gray..
Mar 22 15:39:06 Miraculix colord: Profile added: demazl3v-CMYK..
Mar 22 15:39:06 Miraculix colord: Device added: cups-demazl3v
Mar 22 15:39:06 Miraculix colord: Profile added: 
demazl3v.confidential-Gray..
Mar 22 15:39:06 Miraculix colord: Profile added: 
demazl3v.confidential-CMYK..
Mar 22 15:39:06 Miraculix colord: Device added: cups-demazl3v.confidential
Mar 22 15:39:06 Miraculix colord: Profile added: PostScript-Gray..
Mar 22 15:39:06 Miraculix colord: Profile added: PostScript-RGB..
Mar 22 15:39:06 Miraculix colord: Device added: cups-PostScript
Mar 22 15:39:06 Miraculix colord: Profile added: 
Samsung-CLX-3170-Series-Gray..
Mar 22 15:39:06 Miraculix colord: Device added: cups-Samsung-CLX-3170-Series
Mar 22 15:39:07 Miraculix wpa_supplicant[1555]: nl80211: 
send_and_recv->nl_recvmsgs failed: -33
Mar 22 15:39:07 Miraculix kernel: [   67.162347] savtray[4001]: segfault 
at 0 ip 00000000f7496a58 sp 00000000ff969a3c error 4 in 
libc-2.19.so[f735c000+1a9000]
Mar 22 15:39:45 Miraculix wpa_supplicant[1555]: wlan0: 
CTRL-EVENT-SCAN-STARTED
Mar 22 15:39:50 Miraculix wpa_supplicant[1555]: nl80211: 
send_and_recv->nl_recvmsgs failed: -33
Mar 22 15:40:48 Miraculix wpa_supplicant[1555]: wlan0: 
CTRL-EVENT-SCAN-STARTED
Mar 22 15:40:52 Miraculix wpa_supplicant[1555]: nl80211: 
send_and_recv->nl_recvmsgs failed: -33
Mar 22 15:42:11 Miraculix wpa_supplicant[1555]: wlan0: 
CTRL-EVENT-SCAN-STARTED
Mar 22 15:42:15 Miraculix wpa_supplicant[1555]: nl80211: 
send_and_recv->nl_recvmsgs failed: -33
Mar 22 15:42:37 Miraculix wpa_supplicant[1555]: wlan0: WPA: Group 
rekeying completed with 24:65:11:53:8d:21 [GTK=TKIP]
Mar 22 15:43:54 Miraculix wpa_supplicant[1555]: wlan0: 
CTRL-EVENT-SCAN-STARTED
Mar 22 15:43:59 Miraculix wpa_supplicant[1555]: nl80211: 
send_and_recv->nl_recvmsgs failed: -33
Mar 22 15:45:54 Miraculix wpa_supplicant[1555]: wlan0: 
CTRL-EVENT-SCAN-STARTED
Mar 22 15:45:58 Miraculix wpa_supplicant[1555]: nl80211: 
send_and_recv->nl_recvmsgs failed: -33
Mar 22 15:46:08 Miraculix dbus[1060]: [system] Activating service 
name='org.freedesktop.hostname1' (using servicehelper)
Mar 22 15:46:08 Miraculix dbus[1060]: [system] Successfully activated 
service 'org.freedesktop.hostname1'
Mar 22 15:47:54 Miraculix wpa_supplicant[1555]: wlan0: 
CTRL-EVENT-SCAN-STARTED
Mar 22 15:47:59 Miraculix wpa_supplicant[1555]: nl80211: 
send_and_recv->nl_recvmsgs failed: -33
Mar 22 15:49:54 Miraculix wpa_supplicant[1555]: wlan0: 
CTRL-EVENT-SCAN-STARTED
Mar 22 15:49:58 Miraculix wpa_supplicant[1555]: nl80211: 
send_and_recv->nl_recvmsgs failed: -33
Mar 22 15:51:21 Miraculix kernel: [  801.458125] nf_conntrack: automatic 
helper assignment is deprecated and it will be removed soon. Use the 
iptables CT target to attach helpers instead.
Mar 22 15:51:54 Miraculix wpa_supplicant[1555]: wlan0: 
CTRL-EVENT-SCAN-STARTED


-------- Original Message --------
Subject:     kernel bug: Mouse and keyboard dead when resuming from 
suspend on Lenovo W530
Date:     Thu, 20 Mar 2014 09:38:24 +0100
From:     Gerd Grundke <gerdgrundke@t-online.de>
To:     linux-kernel@vger.kernel.org


Dear all,

after resuming from suspend, both mouse and keyboard are dead, there is
no reaction whatsoever on any action, including the NUM-Lock leds and so on.

Following the instruction on
https://wiki.ubuntu.com/Bugs/Upstream/kernel I'm sending the bug to the
mailing list for further advise.


ggrundke@Miraculix:~$ cat /proc/version
Linux version 3.14.0-031400rc7-generic (apw@gomeisa) (gcc version 4.6.3
(Ubuntu/Linaro 4.6.3-1ubuntu5) ) #201403162235 SMP Mon Mar 17 02:36:19
UTC 2014

ggrundke@Miraculix:~$ lsb_release -rd
Description:    Ubuntu Trusty Tahr (development branch)
Release:    14.04

ggrundke@Miraculix:/usr/src/linux-headers-3.14.0-031400rc7/scripts$ sh
ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux Miraculix 3.14.0-031400rc7-generic #201403162235 SMP Mon Mar 17
02:36:19 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux

Gnu C                  4.8
Gnu make               3.81
binutils               2.24
util-linux             2.20.1
mount                  support
module-init-tools      15
e2fsprogs              1.42.9
pcmciautils            018
PPP                    2.4.5
Linux C Library        2.19
Dynamic linker (ldd)   2.19
Procps                 3.3.9
Net-tools              1.60
Kbd                    1.15.5
Sh-utils               8.21
wireless-tools         30
Modules Loaded         ctr ccm pci_stub nf_conntrack_netbios_ns
nf_conntrack_broadcast vboxpci vboxnetadp vboxnetflt vboxdrv ebtable_nat
ipt_REJECT iptable_filter ebtable_broute bridge xt_LOG stp xt_limit
ip6t_REJECT llc xt_tcpudp ip6t_ah ebtable_filter ebtables xt_conntrack
ip6table_nat nf_conntrack_ipv6 iptable_nat nf_conntrack_ipv4
nf_defrag_ipv6 nf_defrag_ipv4 nf_nat_ipv4 nf_nat_ipv6 nf_nat
iptable_mangle ip6table_mangle iptable_security ip6table_security
iptable_raw ip6table_raw ip_tables ip6table_filter ip6_tables x_tables
bnep rfcomm intel_rapl arc4 x86_pkg_temp_thermal iwldvm uvcvideo
thinkpad_acpi intel_powerclamp snd_hda_codec_hdmi coretemp btusb nvram
snd_hda_codec_realtek snd_hda_codec_generic kvm_intel mac80211
snd_hda_intel kvm snd_hda_codec snd_hwdep snd_pcm bluetooth snd_seq_midi
snd_seq_midi_event snd_rawmidi videobuf2_vmalloc snd_seq
videobuf2_memops snd_seq_device snd_timer videobuf2_core 6lowpan_iphc lp
snd iwlwifi psmouse videodev parport joydev serio_raw soundcore mei_me
microcode lpc_ich nf_conntrack_ftp cfg80211 mei nf_conntrack mac_hid
hid_cherry dm_crypt hid_generic usbhid hid crct10dif_pclmul crc32_pclmul
nouveau ghash_clmulni_intel aesni_intel aes_x86_64 lrw mxm_wmi gf128mul
i2c_algo_bit glue_helper ablk_helper ttm cryptd drm_kms_helper e1000e
firewire_ohci drm ahci sdhci_pci firewire_core ptp libahci sdhci
crc_itu_t pps_core wmi video

ggrundke@Miraculix:/usr/src/linux-headers-3.14.0-031400rc7/scripts$ cat
/proc/cpuinfo
processor    : 0
vendor_id    : GenuineIntel
cpu family    : 6
model        : 58
model name    : Intel(R) Core(TM) i7-3740QM CPU @ 2.70GHz
stepping    : 9
microcode    : 0x19
cpu MHz        : 1883.250
cache size    : 6144 KB
physical id    : 0
siblings    : 8
core id        : 0
cpu cores    : 4
apicid        : 0
initial apicid    : 0
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall
nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx
smx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb
xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase
smep erms
bogomips    : 5387.59
clflush size    : 64
cache_alignment    : 64
address sizes    : 36 bits physical, 48 bits virtual
power management:

processor    : 1
vendor_id    : GenuineIntel
cpu family    : 6
model        : 58
model name    : Intel(R) Core(TM) i7-3740QM CPU @ 2.70GHz
stepping    : 9
microcode    : 0x19
cpu MHz        : 2684.812
cache size    : 6144 KB
physical id    : 0
siblings    : 8
core id        : 0
cpu cores    : 4
apicid        : 1
initial apicid    : 1
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall
nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx
smx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb
xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase
smep erms
bogomips    : 5387.59
clflush size    : 64
cache_alignment    : 64
address sizes    : 36 bits physical, 48 bits virtual
power management:

processor    : 2
vendor_id    : GenuineIntel
cpu family    : 6
model        : 58
model name    : Intel(R) Core(TM) i7-3740QM CPU @ 2.70GHz
stepping    : 9
microcode    : 0x19
cpu MHz        : 2431.687
cache size    : 6144 KB
physical id    : 0
siblings    : 8
core id        : 1
cpu cores    : 4
apicid        : 2
initial apicid    : 2
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall
nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx
smx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb
xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase
smep erms
bogomips    : 5387.59
clflush size    : 64
cache_alignment    : 64
address sizes    : 36 bits physical, 48 bits virtual
power management:

processor    : 3
vendor_id    : GenuineIntel
cpu family    : 6
model        : 58
model name    : Intel(R) Core(TM) i7-3740QM CPU @ 2.70GHz
stepping    : 9
microcode    : 0x19
cpu MHz        : 2727.000
cache size    : 6144 KB
physical id    : 0
siblings    : 8
core id        : 1
cpu cores    : 4
apicid        : 3
initial apicid    : 3
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall
nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx
smx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb
xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase
smep erms
bogomips    : 5387.59
clflush size    : 64
cache_alignment    : 64
address sizes    : 36 bits physical, 48 bits virtual
power management:

processor    : 4
vendor_id    : GenuineIntel
cpu family    : 6
model        : 58
model name    : Intel(R) Core(TM) i7-3740QM CPU @ 2.70GHz
stepping    : 9
microcode    : 0x19
cpu MHz        : 1967.625
cache size    : 6144 KB
physical id    : 0
siblings    : 8
core id        : 2
cpu cores    : 4
apicid        : 4
initial apicid    : 4
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall
nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx
smx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb
xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase
smep erms
bogomips    : 5387.59
clflush size    : 64
cache_alignment    : 64
address sizes    : 36 bits physical, 48 bits virtual
power management:

processor    : 5
vendor_id    : GenuineIntel
cpu family    : 6
model        : 58
model name    : Intel(R) Core(TM) i7-3740QM CPU @ 2.70GHz
stepping    : 9
microcode    : 0x19
cpu MHz        : 2853.562
cache size    : 6144 KB
physical id    : 0
siblings    : 8
core id        : 2
cpu cores    : 4
apicid        : 5
initial apicid    : 5
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall
nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx
smx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb
xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase
smep erms
bogomips    : 5387.59
clflush size    : 64
cache_alignment    : 64
address sizes    : 36 bits physical, 48 bits virtual
power management:

processor    : 6
vendor_id    : GenuineIntel
cpu family    : 6
model        : 58
model name    : Intel(R) Core(TM) i7-3740QM CPU @ 2.70GHz
stepping    : 9
microcode    : 0x19
cpu MHz        : 2642.625
cache size    : 6144 KB
physical id    : 0
siblings    : 8
core id        : 3
cpu cores    : 4
apicid        : 6
initial apicid    : 6
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall
nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx
smx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb
xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase
smep erms
bogomips    : 5387.59
clflush size    : 64
cache_alignment    : 64
address sizes    : 36 bits physical, 48 bits virtual
power management:

processor    : 7
vendor_id    : GenuineIntel
cpu family    : 6
model        : 58
model name    : Intel(R) Core(TM) i7-3740QM CPU @ 2.70GHz
stepping    : 9
microcode    : 0x19
cpu MHz        : 1503.562
cache size    : 6144 KB
physical id    : 0
siblings    : 8
core id        : 3
cpu cores    : 4
apicid        : 7
initial apicid    : 7
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall
nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx
smx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb
xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase
smep erms
bogomips    : 5387.59
clflush size    : 64
cache_alignment    : 64
address sizes    : 36 bits physical, 48 bits virtual
power management:


grundke@Miraculix:/usr/src/linux-headers-3.14.0-031400rc7/scripts$ cat
/proc/modules
ctr 13193 2 - Live 0x0000000000000000
ccm 17856 2 - Live 0x0000000000000000
pci_stub 12622 1 - Live 0x0000000000000000
nf_conntrack_netbios_ns 12665 0 - Live 0x0000000000000000
nf_conntrack_broadcast 12589 1 nf_conntrack_netbios_ns, Live
0x0000000000000000
vboxpci 23194 0 - Live 0x0000000000000000 (OF)
vboxnetadp 25670 0 - Live 0x0000000000000000 (OF)
vboxnetflt 27613 0 - Live 0x0000000000000000 (OF)
vboxdrv 335365 3 vboxpci,vboxnetadp,vboxnetflt, Live 0x0000000000000000 (OF)
ebtable_nat 12807 0 - Live 0x0000000000000000
ipt_REJECT 12579 1 - Live 0x0000000000000000
iptable_filter 12810 1 - Live 0x0000000000000000
ebtable_broute 12731 0 - Live 0x0000000000000000
bridge 116296 1 ebtable_broute, Live 0x0000000000000000
xt_LOG 17830 2 - Live 0x0000000000000000
stp 12976 1 bridge, Live 0x0000000000000000
xt_limit 12711 2 - Live 0x0000000000000000
ip6t_REJECT 12978 2 - Live 0x0000000000000000
llc 14441 2 bridge,stp, Live 0x0000000000000000
xt_tcpudp 12924 53 - Live 0x0000000000000000
ip6t_ah 13015 0 - Live 0x0000000000000000
ebtable_filter 12827 0 - Live 0x0000000000000000
ebtables 31209 3 ebtable_nat,ebtable_broute,ebtable_filter, Live
0x0000000000000000
xt_conntrack 12760 23 - Live 0x0000000000000000
ip6table_nat 13155 1 - Live 0x0000000000000000
nf_conntrack_ipv6 18946 22 - Live 0x0000000000000000
iptable_nat 13151 0 - Live 0x0000000000000000
nf_conntrack_ipv4 14857 3 - Live 0x0000000000000000
nf_defrag_ipv6 34934 1 nf_conntrack_ipv6, Live 0x0000000000000000
nf_defrag_ipv4 12758 1 nf_conntrack_ipv4, Live 0x0000000000000000
nf_nat_ipv4 13316 1 iptable_nat, Live 0x0000000000000000
nf_nat_ipv6 13332 1 ip6table_nat, Live 0x0000000000000000
nf_nat 26147 4 ip6table_nat,iptable_nat,nf_nat_ipv4,nf_nat_ipv6, Live
0x0000000000000000
iptable_mangle 12734 0 - Live 0x0000000000000000
ip6table_mangle 12740 1 - Live 0x0000000000000000
iptable_security 12705 0 - Live 0x0000000000000000
ip6table_security 12710 1 - Live 0x0000000000000000
iptable_raw 12678 0 - Live 0x0000000000000000
ip6table_raw 12683 1 - Live 0x0000000000000000
ip_tables 27717 5
iptable_filter,iptable_nat,iptable_mangle,iptable_security,iptable_raw,
Live 0x0000000000000000
ip6table_filter 12815 1 - Live 0x0000000000000000
ip6_tables 27503 5
ip6table_nat,ip6table_mangle,ip6table_security,ip6table_raw,ip6table_filter,
Live 0x0000000000000000
x_tables 34194 18
ipt_REJECT,iptable_filter,xt_LOG,xt_limit,ip6t_REJECT,xt_tcpudp,ip6t_ah,ebtables,xt_conntrack,iptable_mangle,ip6table_mangle,iptable_security,ip6table_security,iptable_raw,ip6table_raw,ip_tables,ip6table_filter,ip6_tables,
Live 0x0000000000000000
bnep 19884 2 - Live 0x0000000000000000
rfcomm 74734 12 - Live 0x0000000000000000
intel_rapl 19228 0 - Live 0x0000000000000000
arc4 12573 2 - Live 0x0000000000000000
x86_pkg_temp_thermal 14312 0 - Live 0x0000000000000000
iwldvm 243378 0 - Live 0x0000000000000000
uvcvideo 82247 0 - Live 0x0000000000000000
thinkpad_acpi 81925 1 - Live 0x0000000000000000
intel_powerclamp 19077 0 - Live 0x0000000000000000
snd_hda_codec_hdmi 47124 1 - Live 0x0000000000000000
coretemp 17768 0 - Live 0x0000000000000000
btusb 32542 0 - Live 0x0000000000000000
nvram 14462 1 thinkpad_acpi, Live 0x0000000000000000
snd_hda_codec_realtek 66644 1 - Live 0x0000000000000000
snd_hda_codec_generic 69424 1 snd_hda_codec_realtek, Live 0x0000000000000000
kvm_intel 148674 0 - Live 0x0000000000000000
mac80211 676864 1 iwldvm, Live 0x0000000000000000
snd_hda_intel 57222 5 - Live 0x0000000000000000
kvm 471679 1 kvm_intel, Live 0x0000000000000000
snd_hda_codec 142651 4
snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_intel,
Live 0x0000000000000000
snd_hwdep 13613 1 snd_hda_codec, Live 0x0000000000000000
snd_pcm 108860 3 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec, Live
0x0000000000000000
bluetooth 426845 22 bnep,rfcomm,btusb, Live 0x0000000000000000
snd_seq_midi 13324 0 - Live 0x0000000000000000
snd_seq_midi_event 14899 1 snd_seq_midi, Live 0x0000000000000000
snd_rawmidi 30465 1 snd_seq_midi, Live 0x0000000000000000
videobuf2_vmalloc 13216 1 uvcvideo, Live 0x0000000000000000
snd_seq 66061 2 snd_seq_midi,snd_seq_midi_event, Live 0x0000000000000000
videobuf2_memops 13362 1 videobuf2_vmalloc, Live 0x0000000000000000
snd_seq_device 14497 3 snd_seq_midi,snd_rawmidi,snd_seq, Live
0x0000000000000000
snd_timer 30038 2 snd_pcm,snd_seq, Live 0x0000000000000000
videobuf2_core 45465 1 uvcvideo, Live 0x0000000000000000
6lowpan_iphc 18968 1 bluetooth, Live 0x0000000000000000
lp 17799 0 - Live 0x0000000000000000
snd 73979 23
thinkpad_acpi,snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_seq_midi,snd_rawmidi,snd_seq,snd_seq_device,snd_timer,
Live 0x0000000000000000
iwlwifi 183624 1 iwldvm, Live 0x0000000000000000
psmouse 108621 0 - Live 0x0000000000000000
videodev 149340 2 uvcvideo,videobuf2_core, Live 0x0000000000000000
parport 42481 1 lp, Live 0x0000000000000000
joydev 17575 0 - Live 0x0000000000000000
serio_raw 13462 0 - Live 0x0000000000000000
soundcore 12680 1 snd, Live 0x0000000000000000
mei_me 18496 0 - Live 0x0000000000000000
microcode 24391 0 - Live 0x0000000000000000
lpc_ich 21163 0 - Live 0x0000000000000000
nf_conntrack_ftp 18715 0 - Live 0x0000000000000000
cfg80211 531467 3 iwldvm,mac80211,iwlwifi, Live 0x0000000000000000
mei 87125 1 mei_me, Live 0x0000000000000000
nf_conntrack 97139 11
nf_conntrack_netbios_ns,nf_conntrack_broadcast,xt_conntrack,ip6table_nat,nf_conntrack_ipv6,iptable_nat,nf_conntrack_ipv4,nf_nat_ipv4,nf_nat_ipv6,nf_nat,nf_conntrack_ftp,
Live 0x0000000000000000
mac_hid 13253 0 - Live 0x0000000000000000
hid_cherry 12626 0 - Live 0x0000000000000000
dm_crypt 23456 1 - Live 0x0000000000000000
hid_generic 12548 0 - Live 0x0000000000000000
usbhid 53067 0 - Live 0x0000000000000000
hid 106254 3 hid_cherry,hid_generic,usbhid, Live 0x0000000000000000
crct10dif_pclmul 14250 0 - Live 0x0000000000000000
crc32_pclmul 13160 0 - Live 0x0000000000000000
nouveau 1160480 3 - Live 0x0000000000000000
ghash_clmulni_intel 13259 0 - Live 0x0000000000000000
aesni_intel 152634 6 - Live 0x0000000000000000
aes_x86_64 17131 1 aesni_intel, Live 0x0000000000000000
lrw 13323 1 aesni_intel, Live 0x0000000000000000
mxm_wmi 13021 1 nouveau, Live 0x0000000000000000
gf128mul 14951 1 lrw, Live 0x0000000000000000
i2c_algo_bit 13564 1 nouveau, Live 0x0000000000000000
glue_helper 14095 1 aesni_intel, Live 0x0000000000000000
ablk_helper 13597 1 aesni_intel, Live 0x0000000000000000
ttm 90127 1 nouveau, Live 0x0000000000000000
cryptd 20531 4 ghash_clmulni_intel,aesni_intel,ablk_helper, Live
0x0000000000000000
drm_kms_helper 53224 1 nouveau, Live 0x0000000000000000
e1000e 257783 0 - Live 0x0000000000000000
firewire_ohci 45289 0 - Live 0x0000000000000000
drm 308197 5 nouveau,ttm,drm_kms_helper, Live 0x0000000000000000
ahci 30066 2 - Live 0x0000000000000000
sdhci_pci 23263 0 - Live 0x0000000000000000
firewire_core 69403 1 firewire_ohci, Live 0x0000000000000000
ptp 18980 1 e1000e, Live 0x0000000000000000
libahci 32191 1 ahci, Live 0x0000000000000000
sdhci 43409 1 sdhci_pci, Live 0x0000000000000000
crc_itu_t 12707 1 firewire_core, Live 0x0000000000000000
pps_core 19381 1 ptp, Live 0x0000000000000000
wmi 19363 2 nouveau,mxm_wmi, Live 0x0000000000000000
video 19914 1 nouveau, Live 0x0000000000000000


ggrundke@Miraculix:/usr/src/linux-headers-3.14.0-031400rc7/scripts$ cat
/proc/ioports
0000-0cf7 : PCI Bus 0000:00
   0000-001f : dma1
   0020-0021 : pic1
   0040-0043 : timer0
   0050-0053 : timer1
   0060-0060 : keyboard
   0062-0062 : EC data
   0064-0064 : keyboard
   0066-0066 : EC cmd
   0070-0071 : rtc0
   0080-008f : dma page reg
   00a0-00a1 : pic2
   00c0-00df : dma2
   00f0-00ff : fpu
   03c0-03df : vesafb
   0400-0403 : ACPI PM1a_EVT_BLK
   0404-0405 : ACPI PM1a_CNT_BLK
   0408-040b : ACPI PM_TMR
   0410-0415 : ACPI CPU throttle
   0420-042f : ACPI GPE0_BLK
   0430-0433 : iTCO_wdt
   0450-0450 : ACPI PM2_CNT_BLK
   0460-047f : iTCO_wdt
   0500-057f : pnp 00:01
   0800-080f : pnp 00:01
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
   15e0-15ef : pnp 00:01
   1600-167f : pnp 00:01
   3000-3fff : PCI Bus 0000:04
   4000-4fff : PCI Bus 0000:02
   5000-5fff : PCI Bus 0000:01
     5000-507f : 0000:01:00.0
   6020-603f : 0000:00:1f.2
     6020-603f : ahci
   6040-605f : 0000:00:19.0
   6060-6067 : 0000:00:1f.2
     6060-6067 : ahci
   6068-606f : 0000:00:1f.2
     6068-606f : ahci
   6070-6077 : 0000:00:16.3
     6070-6077 : serial
   6078-607b : 0000:00:1f.2
     6078-607b : ahci
   607c-607f : 0000:00:1f.2
     607c-607f : ahci
   efa0-efbf : 0000:00:1f.3

ggrundke@Miraculix:/usr/src/linux-headers-3.14.0-031400rc7/scripts$ cat
/proc/iomem
00000000-00000fff : reserved
00001000-0009d7ff : System RAM
0009d800-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000cebff : Video ROM
000d0000-000d3fff : pnp 00:00
000d4000-000d7fff : pnp 00:00
000d8000-000dbfff : pnp 00:00
000dc000-000dffff : pnp 00:00
000e0000-000fffff : reserved
   000f0000-000fffff : System ROM
00100000-cb32ffff : System RAM
   01000000-01776085 : Kernel code
   01776086-01d157bf : Kernel data
   01e73000-01fd8fff : Kernel bss
cb330000-df69efff : reserved
df69f000-df79efff : ACPI Non-volatile Storage
df79f000-df7fefff : ACPI Tables
df7ff000-dfffffff : reserved
e0000000-febfffff : PCI Bus 0000:00
   e0000000-f1ffffff : PCI Bus 0000:01
     e0000000-efffffff : 0000:01:00.0
     f0000000-f1ffffff : 0000:01:00.0
   f2000000-f30fffff : PCI Bus 0000:01
     f2000000-f2ffffff : 0000:01:00.0
     f3000000-f3003fff : 0000:01:00.1
       f3000000-f3003fff : ICH HD audio
     f3080000-f30fffff : 0000:01:00.0
   f3100000-f38fffff : PCI Bus 0000:02
   f3900000-f40fffff : PCI Bus 0000:04
   f4100000-f48fffff : PCI Bus 0000:04
   f4900000-f49fffff : PCI Bus 0000:03
     f4900000-f4901fff : 0000:03:00.0
       f4900000-f4901fff : iwlwifi
   f4a00000-f52fffff : PCI Bus 0000:02
     f4a00000-f4a007ff : 0000:02:00.3
       f4a00000-f4a007ff : firewire_ohci
     f4a01000-f4a010ff : 0000:02:00.0
       f4a01000-f4a010ff : mmc0
   f5300000-f531ffff : 0000:00:19.0
     f5300000-f531ffff : e1000e
   f5320000-f532ffff : 0000:00:14.0
     f5320000-f532ffff : xhci_hcd
   f5330000-f5333fff : 0000:00:1b.0
     f5330000-f5333fff : ICH HD audio
   f5334000-f53340ff : 0000:00:1f.3
   f5335000-f533500f : 0000:00:16.0
     f5335000-f533500f : mei_me
   f5338000-f53387ff : 0000:00:1f.2
     f5338000-f53387ff : ahci
   f5339000-f53393ff : 0000:00:1d.0
     f5339000-f53393ff : ehci_hcd
   f533a000-f533a3ff : 0000:00:1a.0
     f533a000-f533a3ff : ehci_hcd
   f533b000-f533bfff : 0000:00:19.0
     f533b000-f533bfff : e1000e
   f533c000-f533cfff : 0000:00:16.3
   f8000000-fbffffff : PCI MMCONFIG 0000 [bus 00-3f]
     f8000000-fbffffff : reserved
       f8000000-fbffffff : pnp 00:01
fec00000-fec00fff : reserved
   fec00000-fec003ff : IOAPIC 0
fed00000-fed003ff : HPET 0
fed08000-fed08fff : reserved
fed10000-fed19fff : reserved
   fed10000-fed13fff : pnp 00:01
   fed18000-fed18fff : pnp 00:01
   fed19000-fed19fff : pnp 00:01
fed1c000-fed1ffff : reserved
   fed1c000-fed1ffff : pnp 00:01
     fed1f410-fed1f414 : iTCO_wdt
fed40000-fed4bfff : PCI Bus 0000:00
   fed45000-fed4bfff : pnp 00:01
fee00000-fee00fff : Local APIC
   fee00000-fee00fff : reserved
ffc00000-ffffffff : reserved
100000000-41dffffff : System RAM
41e000000-41fffffff : RAM buffer

ggrundke@Miraculix:/usr/src/linux-headers-3.14.0-031400rc7/scripts$ sudo
lspci -vvv |more
00:00.0 Host bridge: Intel Corporation 3rd Gen Core processor DRAM
Controller (rev 09)
     Subsystem: Lenovo Device 21f6
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
     Latency: 0
     Capabilities: [e0] Vendor Specific Information: Len=0c <?>

00:01.0 PCI bridge: Intel Corporation Xeon E3-1200 v2/3rd Gen Core
processor PCI Express Root Port (rev 09) (prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
     I/O behind bridge: 00005000-00005fff
     Memory behind bridge: f2000000-f30fffff
     Prefetchable memory behind bridge: 00000000e0000000-00000000f1ffffff
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
     BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [88] Subsystem: Lenovo Device 21f6
     Capabilities: [80] Power Management version 3
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
         Address: feeff00c  Data: 4161
     Capabilities: [a0] Express (v2) Root Port (Slot+), MSI 00
         DevCap:    MaxPayload 256 bytes, PhantFunc 0
             ExtTag- RBE+
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 256 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
TransPend-
         LnkCap:    Port #2, Speed 5GT/s, Width x16, ASPM L0s L1, Exit
Latency L0s <256ns, L1 <8us
             ClockPM- Surprise- LLActRep- BwNot+
         LnkCtl:    ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x16, TrErr- Train+ SlotClk+
DLActive- BWMgmt+ ABWMgmt-
         SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug-
Surprise-
             Slot #1, PowerLimit 75.000W; Interlock- NoCompl+
         SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
HPIrq- LinkChg-
             Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
         SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+
Interlock-
             Changed: MRL- PresDet+ LinkState-
         RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
CRSVisible-
         RootCap: CRSVisible-
         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
         DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-,
OBFF Not Supported ARIFwd-
         DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-,
OBFF Disabled ARIFwd-
         LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
              Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
              Compliance De-emphasis: -6dB
         LnkSta2: Current De-emphasis Level: -6dB,
EqualizationComplete-, EqualizationPhase1-
              EqualizationPhase2-, EqualizationPhase3-,
LinkEqualizationRequest-
     Capabilities: [100 v1] Virtual Channel
         Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
         Arb:    Fixed- WRR32- WRR64- WRR128-
         Ctrl:    ArbSelect=Fixed
         Status:    InProgress-
VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
             Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
             Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
             Status:    NegoPending- InProgress-
     Capabilities: [140 v1] Root Complex Link
         Desc:    PortNumber=02 ComponentID=01 EltType=Config
         Link0:    Desc:    TargetPort=00 TargetComponent=01 AssocRCRB-
LinkType=MemMapped LinkValid+
             Addr:    00000000fed19000
     Capabilities: [d94 v1] #19
     Kernel driver in use: pcieport

00:14.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset
Family USB xHCI Host Controller (rev 04) (prog-if 30 [XHCI])
     Subsystem: Lenovo Device 21f6
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin A routed to IRQ 41
     Region 0: Memory at f5320000 (64-bit, non-prefetchable) [size=64K]
     Capabilities: [70] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0-,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [80] MSI: Enable+ Count=1/8 Maskable- 64bit+
         Address: 00000000feeff00c  Data: 41a1
     Kernel driver in use: xhci_hcd

00:16.0 Communication controller: Intel Corporation 7 Series/C210 Series
Chipset Family MEI Controller #1 (rev 04)
     Subsystem: Lenovo Device 21f6
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin A routed to IRQ 45
     Region 0: Memory at f5335000 (64-bit, non-prefetchable) [size=16]
     Capabilities: [50] Power Management version 3
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [8c] MSI: Enable+ Count=1/1 Maskable- 64bit+
         Address: 00000000feeff00c  Data: 4122
     Kernel driver in use: mei_me

00:16.3 Serial controller: Intel Corporation 7 Series/C210 Series
Chipset Family KT Controller (rev 04) (prog-if 02 [16550])
     Subsystem: Lenovo Device 21f6
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin B routed to IRQ 19
     Region 0: I/O ports at 6070 [size=8]
     Region 1: Memory at f533c000 (32-bit, non-prefetchable) [size=4K]
     Capabilities: [c8] Power Management version 3
         Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
         Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [d0] MSI: Enable- Count=1/1 Maskable- 64bit+
         Address: 0000000000000000  Data: 0000
     Kernel driver in use: serial

00:19.0 Ethernet controller: Intel Corporation 82579LM Gigabit Network
Connection (rev 04)
     Subsystem: Lenovo Device 21f3
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
     Interrupt: pin A routed to IRQ 44
     Region 0: Memory at f5300000 (32-bit, non-prefetchable) [size=128K]
     Region 1: Memory at f533b000 (32-bit, non-prefetchable) [size=4K]
     Region 2: I/O ports at 6040 [size=32]
     Capabilities: [c8] Power Management version 2
         Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
     Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
         Address: 00000000fee2000c  Data: 4182
     Capabilities: [e0] PCI Advanced Features
         AFCap: TP+ FLR+
         AFCtrl: FLR-
         AFStatus: TP-
     Kernel driver in use: e1000e

00:1a.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset
Family USB Enhanced Host Controller #2 (rev 04) (prog-if 20 [EHCI])
     Subsystem: Lenovo Device 21f6
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin A routed to IRQ 16
     Region 0: Memory at f533a000 (32-bit, non-prefetchable) [size=1K]
     Capabilities: [50] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [58] Debug port: BAR=1 offset=00a0
     Capabilities: [98] PCI Advanced Features
         AFCap: TP+ FLR+
         AFCtrl: FLR-
         AFStatus: TP-
     Kernel driver in use: ehci-pci

00:1b.0 Audio device: Intel Corporation 7 Series/C210 Series Chipset
Family High Definition Audio Controller (rev 04)
     Subsystem: Lenovo Device 21f6
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Interrupt: pin A routed to IRQ 47
     Region 0: Memory at f5330000 (64-bit, non-prefetchable) [size=16K]
     Capabilities: [50] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
         Address: 00000000feeff00c  Data: 4162
     Capabilities: [70] Express (v1) Root Complex Integrated Endpoint,
MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0
             ExtTag- RBE-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
TransPend-
     Capabilities: [100 v1] Virtual Channel
         Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
         Arb:    Fixed- WRR32- WRR64- WRR128-
         Ctrl:    ArbSelect=Fixed
         Status:    InProgress-
VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
             Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
             Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=01
             Status:    NegoPending- InProgress-
         VC1:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
             Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
             Ctrl:    Enable+ ID=1 ArbSelect=Fixed TC/VC=22
             Status:    NegoPending- InProgress-
     Capabilities: [130 v1] Root Complex Link
         Desc:    PortNumber=0f ComponentID=00 EltType=Config
         Link0:    Desc:    TargetPort=00 TargetComponent=00 AssocRCRB-
LinkType=MemMapped LinkValid+
             Addr:    00000000fed1c000
     Kernel driver in use: snd_hda_intel

00:1c.0 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset
Family PCI Express Root Port 1 (rev c4) (prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
     I/O behind bridge: 00004000-00004fff
     Memory behind bridge: f4a00000-f52fffff
     Prefetchable memory behind bridge: 00000000f3100000-00000000f38fffff
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
     BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0
             ExtTag- RBE+
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
TransPend-
         LnkCap:    Port #1, Speed 5GT/s, Width x1, ASPM L0s L1, Exit
Latency L0s <512ns, L1 <16us
             ClockPM- Surprise- LLActRep+ BwNot-
         LnkCtl:    ASPM L1 Enabled; RCB 64 bytes Disabled- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive+ BWMgmt+ ABWMgmt-
         SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+
Surprise+
             Slot #0, PowerLimit 10.000W; Interlock- NoCompl+
         SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt-
HPIrq- LinkChg-
             Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
         SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+
Interlock-
             Changed: MRL- PresDet- LinkState-
         RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
CRSVisible-
         RootCap: CRSVisible-
         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
         DevCap2: Completion Timeout: Range BC, TimeoutDis+, LTR-, OBFF
Not Supported ARIFwd-
         DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-,
OBFF Disabled ARIFwd-
         LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
              Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
              Compliance De-emphasis: -6dB
         LnkSta2: Current De-emphasis Level: -3.5dB,
EqualizationComplete-, EqualizationPhase1-
              EqualizationPhase2-, EqualizationPhase3-,
LinkEqualizationRequest-
     Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
         Address: 00000000  Data: 0000
     Capabilities: [90] Subsystem: Lenovo Device 21f6
     Capabilities: [a0] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Kernel driver in use: pcieport

00:1c.1 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset
Family PCI Express Root Port 2 (rev c4) (prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
     I/O behind bridge: 0000f000-00000fff
     Memory behind bridge: f4900000-f49fffff
     Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
     BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0
             ExtTag- RBE+
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
TransPend-
         LnkCap:    Port #2, Speed 5GT/s, Width x1, ASPM L0s L1, Exit
Latency L0s <512ns, L1 <16us
             ClockPM- Surprise- LLActRep+ BwNot-
         LnkCtl:    ASPM L1 Enabled; RCB 64 bytes Disabled- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive+ BWMgmt+ ABWMgmt-
         SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug-
Surprise-
             Slot #1, PowerLimit 10.000W; Interlock- NoCompl+
         SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
HPIrq- LinkChg-
             Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
         SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+
Interlock-
             Changed: MRL- PresDet- LinkState+
         RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
CRSVisible-
         RootCap: CRSVisible-
         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
         DevCap2: Completion Timeout: Range BC, TimeoutDis+, LTR-, OBFF
Not Supported ARIFwd-
         DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-,
OBFF Disabled ARIFwd-
         LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
              Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
              Compliance De-emphasis: -6dB
         LnkSta2: Current De-emphasis Level: -3.5dB,
EqualizationComplete-, EqualizationPhase1-
              EqualizationPhase2-, EqualizationPhase3-,
LinkEqualizationRequest-
     Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
         Address: 00000000  Data: 0000
     Capabilities: [90] Subsystem: Lenovo Device 21f6
     Capabilities: [a0] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Kernel driver in use: pcieport

00:1c.2 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset
Family PCI Express Root Port 3 (rev c4) (prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Bus: primary=00, secondary=04, subordinate=0b, sec-latency=0
     I/O behind bridge: 00003000-00003fff
Memory behind bridge: f4100000-f48fffff
     Prefetchable memory behind bridge: 00000000f3900000-00000000f40fffff
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
     BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0
             ExtTag- RBE+
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
TransPend-
         LnkCap:    Port #3, Speed 5GT/s, Width x1, ASPM L0s L1, Exit
Latency L0s <1us, L1 <16us
             ClockPM- Surprise- LLActRep+ BwNot-
         LnkCtl:    ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk-
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
         SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+
Surprise+
             Slot #2, PowerLimit 10.000W; Interlock- NoCompl+
         SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt-
HPIrq- LinkChg-
             Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
         SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet-
Interlock-
             Changed: MRL- PresDet- LinkState-
         RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
CRSVisible-
         RootCap: CRSVisible-
         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
         DevCap2: Completion Timeout: Range BC, TimeoutDis+, LTR-, OBFF
Not Supported ARIFwd-
         DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-,
OBFF Disabled ARIFwd-
         LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
              Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
              Compliance De-emphasis: -6dB
         LnkSta2: Current De-emphasis Level: -3.5dB,
EqualizationComplete-, EqualizationPhase1-
              EqualizationPhase2-, EqualizationPhase3-,
LinkEqualizationRequest-
     Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
         Address: 00000000  Data: 0000
     Capabilities: [90] Subsystem: Lenovo Device 21f6
     Capabilities: [a0] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Kernel driver in use: pcieport

00:1d.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset
Family USB Enhanced Host Controller #1 (rev 04) (prog-if 20 [EHCI])
     Subsystem: Lenovo Device 21f6
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin A routed to IRQ 23
     Region 0: Memory at f5339000 (32-bit, non-prefetchable) [size=1K]
     Capabilities: [50] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [58] Debug port: BAR=1 offset=00a0
     Capabilities: [98] PCI Advanced Features
         AFCap: TP+ FLR+
         AFCtrl: FLR-
         AFStatus: TP-
     Kernel driver in use: ehci-pci
00:1f.0 ISA bridge: Intel Corporation QM77 Express Chipset LPC
Controller (rev 04)
     Subsystem: Lenovo Device 21f6
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Capabilities: [e0] Vendor Specific Information: Len=0c <?>
     Kernel driver in use: lpc_ich

00:1f.2 SATA controller: Intel Corporation 7 Series Chipset Family
6-port SATA Controller [AHCI mode] (rev 04) (prog-if 01 [AHCI 1.0])
     Subsystem: Lenovo Device 21f6
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
     Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin B routed to IRQ 42
     Region 0: I/O ports at 6068 [size=8]
     Region 1: I/O ports at 607c [size=4]
     Region 2: I/O ports at 6060 [size=8]
     Region 3: I/O ports at 6078 [size=4]
     Region 4: I/O ports at 6020 [size=32]
     Region 5: Memory at f5338000 (32-bit, non-prefetchable) [size=2K]
     Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
         Address: fee0c00c  Data: 41b1
     Capabilities: [70] Power Management version 3
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot+,D3cold-)
         Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
     Capabilities: [b0] PCI Advanced Features
         AFCap: TP+ FLR+
         AFCtrl: FLR-
         AFStatus: TP-
     Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 7 Series/C210 Series Chipset Family
SMBus Controller (rev 04)
     Subsystem: Lenovo Device 21f6
     Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Interrupt: pin C routed to IRQ 11
     Region 0: Memory at f5334000 (64-bit, non-prefetchable) [size=256]
     Region 4: I/O ports at efa0 [size=32]

01:00.0 VGA compatible controller: NVIDIA Corporation GK107GLM [Quadro
K1000M] (rev a1) (prog-if 00 [VGA controller])
     Subsystem: Lenovo Device 21f6
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Interrupt: pin A routed to IRQ 43
     Region 0: Memory at f2000000 (32-bit, non-prefetchable) [size=16M]
     Region 1: Memory at e0000000 (64-bit, prefetchable) [size=256M]
     Region 3: Memory at f0000000 (64-bit, prefetchable) [size=32M]
     Region 5: I/O ports at 5000 [size=128]
     Expansion ROM at f3080000 [disabled] [size=512K]
     Capabilities: [60] Power Management version 3
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
         Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [68] MSI: Enable+ Count=1/1 Maskable- 64bit+
         Address: 00000000feeff00c  Data: 41c1
Capabilities: [78] Express (v2) Endpoint, MSI 00
         DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s
unlimited, L1 <64us
             ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
             RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
             MaxPayload 256 bytes, MaxReadReq 512 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
TransPend-
         LnkCap:    Port #0, Speed 8GT/s, Width x16, ASPM L0s L1, Exit
Latency L0s <512ns, L1 <4us
             ClockPM+ Surprise- LLActRep- BwNot-
         LnkCtl:    ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
         DevCap2: Completion Timeout: Range AB, TimeoutDis+, LTR-, OBFF
Not Supported
         DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-,
OBFF Disabled
         LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- SpeedDis-
              Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
              Compliance De-emphasis: -6dB
         LnkSta2: Current De-emphasis Level: -3.5dB,
EqualizationComplete-, EqualizationPhase1-
              EqualizationPhase2-, EqualizationPhase3-,
LinkEqualizationRequest-
     Capabilities: [b4] Vendor Specific Information: Len=14 <?>
     Capabilities: [100 v1] Virtual Channel
         Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
         Arb:    Fixed- WRR32- WRR64- WRR128-
         Ctrl:    ArbSelect=Fixed
         Status:    InProgress-
         VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
             Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
             Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
             Status:    NegoPending- InProgress-
     Capabilities: [128 v1] Power Budgeting <?>
     Capabilities: [600 v1] Vendor Specific Information: ID=0001 Rev=1
Len=024 <?>
     Capabilities: [900 v1] #19
     Kernel driver in use: nouveau

01:00.1 Audio device: NVIDIA Corporation GK107 HDMI Audio Controller
(rev a1)
     Subsystem: Lenovo Device 21f6
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Interrupt: pin B routed to IRQ 17
     Region 0: Memory at f3000000 (32-bit, non-prefetchable) [size=16K]
     Capabilities: [60] Power Management version 3
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
         Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [68] MSI: Enable- Count=1/1 Maskable- 64bit+
         Address: 0000000000000000  Data: 0000
     Capabilities: [78] Express (v2) Endpoint, MSI 00
         DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s
unlimited, L1 <64us
             ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
             RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
             MaxPayload 256 bytes, MaxReadReq 512 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
TransPend-
         LnkCap:    Port #0, Speed 8GT/s, Width x16, ASPM L0s L1, Exit
Latency L0s <512ns, L1 <4us
             ClockPM+ Surprise- LLActRep- BwNot-
         LnkCtl:    ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta:    Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
         DevCap2: Completion Timeout: Range AB, TimeoutDis+, LTR-, OBFF
Not Supported
         DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-,
OBFF Disabled
         LnkSta2: Current De-emphasis Level: -3.5dB,
EqualizationComplete-, EqualizationPhase1-
              EqualizationPhase2-, EqualizationPhase3-,
LinkEqualizationRequest-
     Kernel driver in use: snd_hda_intel

02:00.0 System peripheral: Ricoh Co Ltd PCIe SDXC/MMC Host Controller
(rev 08) (prog-if 01)
     Subsystem: Lenovo Device 21f6
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Interrupt: pin A routed to IRQ 16
     Region 0: Memory at f4a01000 (32-bit, non-prefetchable) [size=256]
     Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
         Address: 0000000000000000  Data: 0000
     Capabilities: [78] Power Management version 3
         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME-
     Capabilities: [80] Express (v1) Endpoint, MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s
unlimited, L1 unlimited
             ExtTag- AttnBtn+ AttnInd+ PwrInd+ RBE+ FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
             RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
             MaxPayload 128 bytes, MaxReadReq 512 bytes
         DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr-
TransPend-
         LnkCap:    Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit
Latency L0s <4us, L1 <64us
             ClockPM+ Surprise- LLActRep- BwNot-
         LnkCtl:    ASPM L1 Enabled; RCB 64 bytes Disabled- CommClk+
             ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
     Capabilities: [100 v1] Virtual Channel
         Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
         Arb:    Fixed- WRR32- WRR64- WRR128-
         Ctrl:    ArbSelect=Fixed
         Status:    InProgress-
         VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
             Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
             Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
             Status:    NegoPending- InProgress-
     Capabilities: [800 v1] Advanced Error Reporting
         UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UESvrt:    DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
         CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
         CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
         AERCap:    First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
     Kernel driver in use: sdhci-pci

02:00.3 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 PCIe IEEE 1394
Controller (rev 04) (prog-if 10 [OHCI])
     Subsystem: Lenovo Device 21f6
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Interrupt: pin D routed to IRQ 19
     Region 0: Memory at f4a00000 (32-bit, non-prefetchable) [size=2K]
     Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+

     Address: 0000000000000000  Data: 0000
     Capabilities: [78] Power Management version 3
         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME+
     Capabilities: [80] Express (v1) Endpoint, MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s
unlimited, L1 unlimited
             ExtTag- AttnBtn+ AttnInd+ PwrInd+ RBE+ FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
             RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
             MaxPayload 128 bytes, MaxReadReq 512 bytes
         DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr-
TransPend-
         LnkCap:    Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit
Latency L0s <4us, L1 <64us
             ClockPM+ Surprise- LLActRep- BwNot-
         LnkCtl:    ASPM L1 Enabled; RCB 64 bytes Disabled- CommClk+
             ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
     Capabilities: [100 v1] Advanced Error Reporting
         UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UESvrt:    DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
         CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
         CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
         AERCap:    First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
     Kernel driver in use: firewire_ohci

03:00.0 Network controller: Intel Corporation Centrino Advanced-N 6205
[Taylor Peak] (rev 34)
     Subsystem: Intel Corporation Centrino Advanced-N 6205 AGN
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Interrupt: pin A routed to IRQ 46
     Region 0: Memory at f4900000 (64-bit, non-prefetchable) [size=8K]
     Capabilities: [c8] Power Management version 3
         Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
         Address: 00000000fee1000c  Data: 4142
     Capabilities: [e0] Express (v1) Endpoint, MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<512ns, L1 unlimited
             ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
             RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+
TransPend-
         LnkCap:    Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit
Latency L0s <4us, L1 <32us
             ClockPM+ Surprise- LLActRep- BwNot-
         LnkCtl:    ASPM L1 Enabled; RCB 64 bytes Disabled- CommClk+
             ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
     Capabilities: [100 v1] Advanced Error Reporting
         UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UESvrt:    DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
         CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
         CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
         AERCap:    First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
     Capabilities: [140 v1] Device Serial Number a4-4e-31-ff-ff-3e-c1-ec
Kernel driver in use: iwlwifi


ggrundke@Miraculix:~$ cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: HGST HTS725050A7 Rev: GH2Z
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
   Vendor: PLDS     Model: DVD-RW DS8A8SH   Rev: KU54
   Type:   CD-ROM                           ANSI  SCSI revision: 05

ggrundke@Miraculix:~$ ls /proc
1     1198  1336  1695  20    211   2456  2863  3091  3179  334 34
3467  3560  3647  3855  4031  45    52   65   733  84 cmdline
iomem          meminfo       softirqs       zoneinfo
10    12    1340  17    201   212   2457  29    31    3180  3345 3408
3471  3574  3651  3876  4059  4571  53   66   74   844 consoles
ioports        misc          stat
102   122   1342  1744  202   213   25    2915  3109  3181  335 3412
3474  3594  3656  3890  4074  46    54   67   75   848 cpuinfo
irq            modules       swaps
103   123   1345  1763  203   217   2506  293   311   3197  3350 3415
3478  36    366   3895  4075  466   55   68   777  85 crypto
kallsyms       mounts        sys
1076  1249  1346  179   204   22    2526  2939  313   3199  3354 3416
3482  3604  367   39    41    4668  56   69   778  9 devices
kcore          mtrr          sysrq-trigger
11    1253  1360  18    205   220   2540  294   3168  32    3359 3426
3485  3607  368   3902  4121  4690  57   7    781  98 diskstats
key-users      net           sysvipc
1104  1261  1376  180   206   2212  2555  295   3172  3289  3367 3442
3496  3608  3683  3927  42    47    58   70   784  982 dma
kmsg           pagetypeinfo  timer_list
1115  1262  1379  1823  207   23    2591  296   3173  3293  3378 3444
35    3612  37    3948  4202  472   59   71   785  984 driver
kpagecount     partitions    timer_stats
1129  1265  14    1890  208   2354  26    297   3174  33    3382 3449
3518  3615  3704  3957  4210  48    606  718  79   acpi execdomains
kpageflags     sched_debug   tty
1136  1293  15    19    209   24    2642  3     3175  3301  3388 3454
3525  3616  3758  3959  43    49    61   72   8    asound fb
latency_stats  schedstat     uptime
1168  1295  16    1917  2095  2404  27    30    3176  3304  3389 3456
3527  3621  38    3992  4313  5     62   722  81   buddyinfo
filesystems  loadavg        scsi          version
1190  13    1678  1936  21    2414  28    308   3177  3318  3391 3464
3533  3631  3826  4     4335  50    63   73   82   bus fs
locks          self          vmallocinfo
1193  1314  169   2     210   2437  2857  309   3178  333   3397 3466
3537  3641  3838  4015  44    51    64   732  83   cgroups interrupts
mdstat         slabinfo      vmstat













