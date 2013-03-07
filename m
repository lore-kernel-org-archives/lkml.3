Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759242Ab3CGPDW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 10:03:22 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:37918 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab3CGPDT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 10:03:19 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Porter, Matt" <mporter@ti.com>
CC: Chris Ball <cjb@laptop.org>, Russell King <linux@arm.linux.org.uk>,
        "Krishnamoorthy, Balaji T" <balajitk@ti.com>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 2/2] ARM: dts: add AM33XX MMC support
Thread-Topic: [PATCH 2/2] ARM: dts: add AM33XX MMC support
Thread-Index: AQHOGuqV346jkMSBUUmpAvXZrfaGX5iaRamDgAABDLD//6x8AIAAXPnA//+m5oCAAFyMUA==
Date: Thu, 7 Mar 2013 15:03:05 +0000
Message-ID: <79CD15C6BA57404B839C016229A409A83EC20CEF@DBDE01.ent.ti.com>
References: <1362629799-22485-1-git-send-email-mporter@ti.com>
 <1362629799-22485-3-git-send-email-mporter@ti.com>
 <41fde401c8e646689123d7c6d3a2dffc@DLEE71.ent.ti.com>
 <20130307141235.GQ6209@beef>
 <79CD15C6BA57404B839C016229A409A83EC20C57@DBDE01.ent.ti.com>
 <20130307144656.GR6209@beef>
 <79CD15C6BA57404B839C016229A409A83EC20CB3@DBDE01.ent.ti.com>
 <20130307150047.GT6209@beef>
In-Reply-To: <20130307150047.GT6209@beef>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Matt Porter [mailto:ohiomdp@gmail.com] On Behalf Of Porter, Matt
> Sent: Thursday, March 07, 2013 8:31 PM
> To: Hiremath, Vaibhav
> Cc: Chris Ball; Russell King; Krishnamoorthy, Balaji T; Devicetree
> Discuss; Linux MMC List; Linux Kernel Mailing List; Linux OMAP List;
> Linux ARM Kernel List
> Subject: Re: [PATCH 2/2] ARM: dts: add AM33XX MMC support
> 
> On Thu, Mar 07, 2013 at 02:53:51PM +0000, Vaibhav Hiremath wrote:
> > > -----Original Message-----
> > > From: Matt Porter [mailto:ohiomdp@gmail.com] On Behalf Of Porter,
> Matt
> > > Sent: Thursday, March 07, 2013 8:17 PM
> > > To: Hiremath, Vaibhav
> > > Cc: Linux OMAP List; Russell King; Krishnamoorthy, Balaji T;
> Devicetree
> > > Discuss; Linux MMC List; Linux Kernel Mailing List; Chris Ball;
> Linux
> > > ARM Kernel List
> > > Subject: Re: [PATCH 2/2] ARM: dts: add AM33XX MMC support
> > >
> > > On Thu, Mar 07, 2013 at 02:39:55PM +0000, Vaibhav Hiremath wrote:
> > > >
> > > > > -----Original Message-----
> > > > > From: Matt Porter [mailto:ohiomdp@gmail.com] On Behalf Of
> Porter,
> > > Matt
> > > > > Sent: Thursday, March 07, 2013 7:43 PM
> > > > > To: Hiremath, Vaibhav
> > > > > Cc: Krishnamoorthy, Balaji T; Chris Ball; Cousson, Benoit; Tony
> > > > > Lindgren; Russell King; Devicetree Discuss; Linux ARM Kernel
> List;
> > > > > Linux OMAP List; Linux Kernel Mailing List; Linux MMC List
> > > > > Subject: Re: [PATCH 2/2] ARM: dts: add AM33XX MMC support
> > > > >
> > > > > On Thu, Mar 07, 2013 at 05:29:24AM +0000, Vaibhav Hiremath
> wrote:
> > > > > > > -----Original Message-----
> > > > > > > From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-
> > > > > > > owner@vger.kernel.org] On Behalf Of Porter, Matt
> > > > > > > Sent: Thursday, March 07, 2013 9:47 AM
> > > > > > > To: Krishnamoorthy, Balaji T; Chris Ball; Cousson, Benoit;
> Tony
> > > > > > > Lindgren; Russell King
> > > > > > > Cc: Devicetree Discuss; Linux ARM Kernel List; Linux OMAP
> List;
> > > > > Linux
> > > > > > > Kernel Mailing List; Linux MMC List
> > > > > > > Subject: [PATCH 2/2] ARM: dts: add AM33XX MMC support
> > > > > > >
> > > > > > > Adds AM33XX MMC support for am335x-bone, am335x-evm, and
> > > > > > > am335x-evmsk.
> > > > > > >
<snip>
> 
> What's the full log now? At least that fragment you show me is better,
> you now have the correct dmaengine driver active.
> 

Here we go.....


Boot Log:
==========================


U-Boot# mmc rescan 0
U-Boot# fatload mmc 0 80000000 am335x-evm.dtb
reading am335x-evm.dtb
11419 bytes read in 10 ms (1.1 MiB/s)
U-Boot# fatload mmc 0 81000000 uImage
reading uImage
4029168 bytes read in 441 ms (8.7 MiB/s)
U-Boot# fatload mmc 0 82000000 ramdisk.ext2.gz
reading ramdisk.ext2.gz
3274441 bytes read in 363 ms (8.6 MiB/s)
U-Boot# setenv bootargs mem=256M console=ttyO0,115200n8 root=/dev/ram rw initrd=0x82000000,16MB ramdisk_size=65536 earlyprintk=serial omap_debugss_en
U-Boot# bootm 81000000 - 80000000
## Booting kernel from Legacy Image at 81000000 ...
   Image Name:   Linux-3.9.0-rc1-00124-g68f2d92-d
   Image Type:   ARM Linux Kernel Image (uncompressed)
   Data Size:    4029104 Bytes = 3.8 MiB
   Load Address: 80008000
   Entry Point:  80008000
   Verifying Checksum ... OK
## Flattened Device Tree blob at 80000000
   Booting using the fdt blob at 0x80000000
   Loading Kernel Image ... OK
OK
   Using Device Tree in place at 80000000, end 80005c9a

Starting kernel ...

[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 3.9.0-rc1-00124-g68f2d92-dirty (XXX@psplinux064) (gcc version 4.5.3 20110311 (prerelease) (GCC) ) #5 SMP Thu Mar 7 20:19:23 IST 2013
[    0.000000] CPU: ARMv7 Processor [413fc082] revision 2 (ARMv7), cr=10c53c7d
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
[    0.000000] Machine: Generic AM33XX (Flattened Device Tree), model: TI AM335x EVM
[    0.000000] cma: CMA: reserved 16 MiB at 8e800000
[    0.000000] Memory policy: ECC disabled, Data cache writeback
[    0.000000] CPU: All CPU(s) started in SVC mode.
[    0.000000] AM335X ES2.0 (neon )
[    0.000000] PERCPU: Embedded 9 pages/cpu @c0f75000 s13632 r8192 d15040 u36864
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64768
[    0.000000] Kernel command line: mem=256M console=ttyO0,115200n8 root=/dev/ram rw initrdD hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Memory: 255MB = 255MB total
[    0.000000] Memory: 212236k/212236k available, 49908k reserved, 0K highmem
[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
[    0.000000]     vmalloc : 0xd0800000 - 0xff000000   ( 744 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd0000000   ( 256 MB)
[    0.000000]     pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)
[    0.000000]     modules : 0xbf000000 - 0xbfe00000   (  14 MB)
[    0.000000]       .text : 0xc0008000 - 0xc071fa94   (7263 kB)
[    0.000000]       .init : 0xc0720000 - 0xc0775540   ( 342 kB)
[    0.000000]       .data : 0xc0776000 - 0xc080f120   ( 613 kB)
[    0.000000]        .bss : 0xc080f120 - 0xc0d6a3c8   (5485 kB)
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  RCU restricting CPUs from NR_CPUS=2 to nr_cpu_ids=1.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] IRQ: Found an INTC at 0xfa200000 (revision 5.0) with 128 interrupts
[    0.000000] Total of 128 interrupts on 1 active controller
[    0.000000] OMAP clockevent source: GPTIMER1 at 24000000 Hz
[    0.000000] sched_clock: 32 bits at 24MHz, resolution 41ns, wraps every 178956ms
[    0.000000] OMAP clocksource: GPTIMER2 at 24000000 Hz
[    0.000000] Console: colour dummy device 80x30
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3695 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000973] Calibrating delay loop... 530.84 BogoMIPS (lpj=2654208)
[    0.109762] pid_max: default: 32768 minimum: 301
[    0.110242] Security Framework initialized
[    0.110391] Mount-cache hash table entries: 512
[    0.121881] CPU: Testing write buffer coherency: ok
[    0.123371] CPU0: thread -1, cpu 0, socket -1, mpidr 0
[    0.123454] Setting up static identity map for 0xc0511298 - 0xc0511308
[    0.126104] Brought up 1 CPUs
[    0.126131] SMP: Total of 1 processors activated (530.84 BogoMIPS).
[    0.126142] CPU: All CPU(s) started in SVC mode.
[    0.129122] devtmpfs: initialized
[    0.199318] pinctrl core: initialized pinctrl subsystem
[    0.205542] regulator-dummy: no parameters
[    0.209272] NET: Registered protocol family 16
[    0.217063] DMA: preallocated 256 KiB pool for atomic coherent allocations
[    0.236321] platform 49000000.edma: alias fck already exists
[    0.236360] platform 49000000.edma: alias fck already exists
[    0.236381] platform 49000000.edma: alias fck already exists
[    0.241540] OMAP GPIO hardware version 0.1
[    0.265323] No ATAGs?
[    0.265352] hw-breakpoint: debug architecture 0x4 unsupported.
[    0.271325] Serial: AMBA PL011 UART driver
[    0.329532] bio: create slab <bio-0> at 0
[    0.370705] edma-dma-engine edma-dma-engine.0: TI EDMA DMA engine driver
[    0.445156] omap-dma-engine omap-dma-engine: OMAP DMA engine driver
[    0.447019] vbat: 5000 mV
[    0.448222] lis3_reg: no parameters
[    0.455418] SCSI subsystem initialized
[    0.457564] usbcore: registered new interface driver usbfs
[    0.458063] usbcore: registered new interface driver hub
[    0.458879] usbcore: registered new device driver usb
[    0.461441] omap_i2c 44e0b000.i2c: did not get pins for i2c error: -19
[    0.463319] omap_i2c 44e0b000.i2c: bus 0 rev0.11 at 400 kHz
[    0.465437] tps65910 0-002d: No interrupt support, no core IRQ
[    0.472111] vrtc: 1800 mV
[    0.472547] vrtc: supplied by vbat
[    0.475632] vio: at 1500 mV
[    0.475778] vio: supplied by vbat
[    0.478599] vdd_mpu: 912 <--> 1312 mV at 1262 mV
[    0.478743] vdd_mpu: supplied by vbat
[    0.482082] vdd_core: 912 <--> 1150 mV at 1137 mV
[    0.482230] vdd_core: supplied by vbat
[    0.484760] vdd3: 5000 mV
[    0.487086] vdig1: at 1800 mV
[    0.487221] vdig1: supplied by vbat
[    0.490215] vdig2: at 1800 mV
[    0.490359] vdig2: supplied by vbat
[    0.492955] vpll: at 1800 mV
[    0.493091] vpll: supplied by vbat
[    0.495657] vdac: at 1800 mV
[    0.496005] vdac: supplied by vbat
[    0.498596] vaux1: at 1800 mV
[    0.498729] vaux1: supplied by vbat
[    0.501589] vaux2: at 3300 mV
[    0.501725] vaux2: supplied by vbat
[    0.504228] vaux33: at 3300 mV
[    0.504358] vaux33: supplied by vbat
[    0.506844] vmmc: 1800 <--> 3300 mV at 3300 mV
[    0.506970] vmmc: supplied by vbat
[    0.509180] omap_i2c 4802a000.i2c: did not get pins for i2c error: -19
[    0.510638] omap_i2c 4802a000.i2c: bus 1 rev0.11 at 100 kHz
[    0.521697] Switching to clocksource gp_timer
[    0.646383] NET: Registered protocol family 2
[    0.648329] TCP established hash table entries: 2048 (order: 2, 16384 bytes)
[    0.648530] TCP bind hash table entries: 2048 (order: 4, 73728 bytes)
[    0.649389] TCP: Hash tables configured (established 2048 bind 2048)
[    0.649630] TCP: reno registered
[    0.649665] UDP hash table entries: 256 (order: 2, 20480 bytes)
[    0.649904] UDP-Lite hash table entries: 256 (order: 2, 20480 bytes)
[    0.650752] NET: Registered protocol family 1
[    0.652407] RPC: Registered named UNIX socket transport module.
[    0.652437] RPC: Registered udp transport module.
[    0.652449] RPC: Registered tcp transport module.
[    0.652461] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.653426] Trying to unpack rootfs image as initramfs...
[    0.655395] rootfs image is not initramfs (no cpio magic); looks like an initrd
[    0.766995] Freeing initrd memory: 16384K
[    0.767176] NetWinder Floating Point Emulator V0.97 (double precision)
[    0.767767] CPU PMU: probing PMU on CPU 0
[    0.767810] hw perfevents: enabled with ARMv7 Cortex-A8 PMU driver, 5 counters available
[    0.925141] VFS: Disk quotas dquot_6.5.2
[    0.925367] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.927965] NFS: Registering the id_resolver key type
[    0.928461] Key type id_resolver registered
[    0.928483] Key type id_legacy registered
[    0.928627] jffs2: version 2.2. (NAND) (SUMMARY)  © 2001-2006 Red Hat, Inc.
[    0.929176] msgmni has been set to 478
[    0.932770] io scheduler noop registered
[    0.932796] io scheduler deadline registered
[    0.932874] io scheduler cfq registered (default)
[    0.934374] pinctrl-single 44e10800.pinmux: 142 pins at pa f9e10800 size 568
[    0.938963] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.945966] omap_uart 44e09000.serial: did not get pins for uart0 error: -19
[    0.946590] 44e09000.serial: ttyO0 at MMIO 0x44e09000 (irq = 88) is a OMAP UART0
[    1.721122] console [ttyO0] enabled
[    1.758203] brd: module loaded
[    1.781141] loop: module loaded
[    1.789748] mtdoops: mtd device (mtddev=name/number) must be supplied
[    1.798239] OneNAND driver initializing
[    1.808604] usbcore: registered new interface driver asix
[    1.815144] usbcore: registered new interface driver ax88179_178a
[    1.822040] usbcore: registered new interface driver cdc_ether
[    1.829136] usbcore: registered new interface driver smsc95xx
[    1.835894] usbcore: registered new interface driver net1080
[    1.842462] usbcore: registered new interface driver cdc_subset
[    1.849138] usbcore: registered new interface driver zaurus
[    1.855643] usbcore: registered new interface driver cdc_ncm
[    1.863976] usbcore: registered new interface driver cdc_wdm
[    1.869979] Initializing USB Mass Storage driver...
[    1.875973] usbcore: registered new interface driver usb-storage
[    1.882443] USB Mass Storage support registered.
[    1.887899] usbcore: registered new interface driver usbtest
[    1.896169] mousedev: PS/2 mouse device common for all mice
[    1.907755] omap_rtc 44e3e000.rtc: rtc core: registered 44e3e000.rtc as rtc0
[    1.916762] i2c /dev entries driver
[    1.924135] Driver for 1-wire Dallas network protocol.
[    1.934385] omap_wdt: OMAP Watchdog Timer Rev 0x01: initial timeout 60 sec
[    1.946490] ledtrig-cpu: registered to indicate activity on CPUs
[    1.954496] usbcore: registered new interface driver usbhid
[    1.960405] usbhid: USB HID core driver
[    1.966224] oprofile: using arm/armv7
[    1.970946] TCP: cubic registered
[    1.974660] Initializing XFRM netlink socket
[    1.979378] NET: Registered protocol family 17
[    1.984242] NET: Registered protocol family 15
[    1.989380] Key type dns_resolver registered
[    1.994118] VFP support v0.3: implementor 41 architecture 3 part 30 variant c rev 3
[    2.002377] ThumbEE CPU extension supported.
[    2.072224] davinci_mdio 4a101000.mdio: davinci mdio revision 1.6
[    2.078701] davinci_mdio 4a101000.mdio: detected phy mask fffffffe
[    2.087773] libphy: 4a101000.mdio: probed
[    2.092038] davinci_mdio 4a101000.mdio: phy[0]: device 4a101000.mdio:00, driver unknown
[    2.101063] Random MACID = ba:43:b8:3c:b7:a4
[    2.111959] input: volume_keys.7 as /devices/volume_keys.7/input/input0
[    2.122621] omap_rtc 44e3e000.rtc: setting system clock to 2000-01-01 00:00:00 UTC (946684800)
[    2.135543] RAMDISK: gzip image found at block 0
[    2.567331] EXT2-fs (ram0): warning: maximal mount count reached, running e2fsck is recommended
[    2.577192] VFS: Mounted root (ext2 filesystem) on device 1:0.
[    2.584487] devtmpfs: mounted
[    2.588238] Freeing init memory: 340K
mount: mounting none on /var/shm failed: No such file or directory
  ::
  :: Enabling hot-plug  : [SUCCESS]
  ::
  ::
   : Populating /dev    : [SUCCESS]
[SUCCESS]
  ::
  ::
  :: Setting PATH
  ::
   : syslogd            : [SUCCESS]
   : telnetd            : [SUCCESS]

Please press Enter to activate this console.
  ::
  :: Setting shell environment ...
  ::
   : Path
   : Aliases
   : Touch Screen
  ::
  :: Done
  ::
[root@arago /]#
[root@arago /]#
[root@arago /]# ls -l /dev/m
/dev/mem   /dev/mice
[root@arago /]# ls -l /dev/m
/dev/mem   /dev/mice
[root@arago /]# ls -l /dev/m
[root@arago /]#
[root@arago /]#
[root@arago /]#
[root@arago /]# dmesg | grep -ir mmc
[    0.506844] vmmc: 1800 <--> 3300 mV at 3300 mV
[    0.506970] vmmc: supplied by vbat
[root@arago /]#
[root@arago /]#
[root@arago /]# dmesg | grep -ir dma
[    0.217063] DMA: preallocated 256 KiB pool for atomic coherent allocations
[    0.236321] platform 49000000.edma: alias fck already exists
[    0.236360] platform 49000000.edma: alias fck already exists
[    0.236381] platform 49000000.edma: alias fck already exists
[    0.370705] edma-dma-engine edma-dma-engine.0: TI EDMA DMA engine driver
[    0.445156] omap-dma-engine omap-dma-engine: OMAP DMA engine driver
[root@arago /]#
[root@arago /]#


Thanks,
Vaibhav
