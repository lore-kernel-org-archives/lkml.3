Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbaC3AzN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 20:55:13 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:54054 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbaC3AzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 20:55:08 -0400
From: Carlos <carlos@cgarcia.org>
To: rob@landley.net
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org, Carlos <carlos@cgarcia.org>
Subject: [PATCH] Documentation: trivial spelling error changes
Date: Sat, 29 Mar 2014 20:54:19 -0400
Message-Id: <1396140859-17645-1-git-send-email-carlos@cgarcia.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed multiple spelling errors.

Signed-off-by: Carlos E. Garcia <carlos@cgarcia.org>
---
 Documentation/DMA-attributes.txt                             |  2 +-
 Documentation/block/biodoc.txt                               |  8 ++++----
 Documentation/block/cfq-iosched.txt                          |  2 +-
 Documentation/cgroups/net_prio.txt                           |  4 ++--
 Documentation/devicetree/bindings/arm/omap/omap.txt          |  2 +-
 Documentation/devicetree/bindings/bus/mvebu-mbus.txt         |  2 +-
 Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt     |  2 +-
 Documentation/devicetree/bindings/mmc/k3-dw-mshc.txt         |  2 +-
 Documentation/devicetree/bindings/mmc/samsung-sdhci.txt      |  2 +-
 Documentation/devicetree/bindings/mtd/gpmc-nand.txt          |  2 +-
 Documentation/devicetree/bindings/mtd/gpmc-nor.txt           |  2 +-
 Documentation/devicetree/bindings/mtd/gpmc-onenand.txt       |  2 +-
 .../devicetree/bindings/pinctrl/brcm,bcm11351-pinctrl.txt    | 12 ++++++------
 Documentation/devicetree/bindings/powerpc/4xx/reboot.txt     |  2 +-
 Documentation/devicetree/bindings/powerpc/fsl/dcsr.txt       |  2 +-
 Documentation/devicetree/bindings/regulator/regulator.txt    |  2 +-
 Documentation/devicetree/bindings/spi/spi-bus.txt            |  2 +-
 Documentation/dma-buf-sharing.txt                            |  2 +-
 Documentation/dynamic-debug-howto.txt                        |  2 +-
 Documentation/edac.txt                                       |  2 +-
 Documentation/fb/sm501.txt                                   |  2 +-
 Documentation/fb/sstfb.txt                                   |  2 +-
 Documentation/filesystems/path-lookup.txt                    |  2 +-
 Documentation/filesystems/proc.txt                           |  4 ++--
 Documentation/filesystems/sharedsubtree.txt                  |  2 +-
 Documentation/gpio/consumer.txt                              |  2 +-
 Documentation/hid/uhid.txt                                   |  2 +-
 Documentation/input/alps.txt                                 |  2 +-
 Documentation/input/input.txt                                |  2 +-
 Documentation/ioctl/hdio.txt                                 |  4 ++--
 Documentation/mtd/nand/pxa3xx-nand.txt                       |  2 +-
 Documentation/networking/can.txt                             | 10 +++++-----
 Documentation/networking/dccp.txt                            |  2 +-
 Documentation/networking/ip-sysctl.txt                       | 10 +++++-----
 Documentation/powerpc/transactional_memory.txt               |  2 +-
 Documentation/rbtree.txt                                     |  2 +-
 Documentation/rfkill.txt                                     |  2 +-
 Documentation/robust-futexes.txt                             |  2 +-
 Documentation/s390/monreader.txt                             |  2 +-
 Documentation/scsi/53c700.txt                                |  2 +-
 Documentation/scsi/dc395x.txt                                |  2 +-
 Documentation/scsi/ncr53c8xx.txt                             |  8 ++++----
 Documentation/scsi/scsi_mid_low_api.txt                      |  8 ++++----
 Documentation/scsi/sym53c8xx_2.txt                           |  6 +++---
 Documentation/scsi/tmscsim.txt                               | 10 +++++-----
 Documentation/security/Yama.txt                              |  2 +-
 Documentation/serial/tty.txt                                 |  4 ++--
 Documentation/sound/alsa/ALSA-Configuration.txt              |  4 ++--
 Documentation/sysctl/net.txt                                 |  2 +-
 Documentation/trace/events.txt                               |  2 +-
 Documentation/usb/WUSB-Design-overview.txt                   |  2 +-
 Documentation/usb/mass-storage.txt                           |  2 +-
 Documentation/virtual/kvm/api.txt                            |  2 +-
 Documentation/vm/transhuge.txt                               |  4 ++--
 Documentation/workqueue.txt                                  |  2 +-
 Documentation/x86/earlyprintk.txt                            |  2 +-
 Documentation/x86/i386/IO-APIC.txt                           |  2 +-
 57 files changed, 91 insertions(+), 91 deletions(-)

diff --git a/Documentation/DMA-attributes.txt b/Documentation/DMA-attributes.txt
index cc2450d..18dc52c 100644
--- a/Documentation/DMA-attributes.txt
+++ b/Documentation/DMA-attributes.txt
@@ -98,5 +98,5 @@ DMA_ATTR_FORCE_CONTIGUOUS
 By default DMA-mapping subsystem is allowed to assemble the buffer
 allocated by dma_alloc_attrs() function from individual pages if it can
 be mapped as contiguous chunk into device dma address space. By
-specifing this attribute the allocated buffer is forced to be contiguous
+specifying this attribute the allocated buffer is forced to be contiguous
 also in physical memory.
diff --git a/Documentation/block/biodoc.txt b/Documentation/block/biodoc.txt
index 2101e71..104589b 100644
--- a/Documentation/block/biodoc.txt
+++ b/Documentation/block/biodoc.txt
@@ -732,7 +732,7 @@ direct access requests which only specify rq->buffer without a valid rq->bio)
 3.2.5.1 Tag helpers
 
 Block now offers some simple generic functionality to help support command
-queueing (typically known as tagged command queueing), ie manage more than
+queuing (typically known as tagged command queuing), ie manage more than
 one outstanding command on a queue at any given time.
 
 	blk_queue_init_tags(struct request_queue *q, int depth)
@@ -769,7 +769,7 @@ list at the same time. blk_queue_start_tag() will remove the request, but
 the driver must remember to call blk_queue_end_tag() before signalling
 completion of the request to the block layer. This means ending tag
 operations before calling end_that_request_last()! For an example of a user
-of these helpers, see the IDE tagged command queueing support.
+of these helpers, see the IDE tagged command queuing support.
 
 Certain hardware conditions may dictate a need to invalidate the block tag
 queue. For instance, on IDE any tagged request error needs to clear both
@@ -911,7 +911,7 @@ to refer to both parts and I/O scheduler to specific I/O schedulers.
 
 Block layer implements generic dispatch queue in block/*.c.
 The generic dispatch queue is responsible for properly ordering barrier
-requests, requeueing, handling non-fs requests and all other subtleties.
+requests, re-queuing, handling non-fs requests and all other subtleties.
 
 Specific I/O schedulers are responsible for ordering normal filesystem
 requests.  They can also choose to delay certain requests to improve
@@ -978,7 +978,7 @@ elevator_activate_req_fn	Called when device driver first sees a request.
 				determine when actual execution of a request
 				starts.
 elevator_deactivate_req_fn	Called when device driver decides to delay
-				a request by requeueing it.
+				a request by re-queuing it.
 
 elevator_init_fn*
 elevator_exit_fn		Allocate and free any elevator specific storage
diff --git a/Documentation/block/cfq-iosched.txt b/Documentation/block/cfq-iosched.txt
index f3bc729..961cd97 100644
--- a/Documentation/block/cfq-iosched.txt
+++ b/Documentation/block/cfq-iosched.txt
@@ -1,4 +1,4 @@
-CFQ (Complete Fairness Queueing)
+CFQ (Complete Fairness Queuing)
 ===============================
 
 The main aim of CFQ scheduler is to provide a fair allocation of the disk
diff --git a/Documentation/cgroups/net_prio.txt b/Documentation/cgroups/net_prio.txt
index a82cbd2..2029934 100644
--- a/Documentation/cgroups/net_prio.txt
+++ b/Documentation/cgroups/net_prio.txt
@@ -43,8 +43,8 @@ said traffic set to the value 5. The parent accounting group also has a
 writeable 'net_prio.ifpriomap' file that can be used to set a system default
 priority.
 
-Priorities are set immediately prior to queueing a frame to the device
-queueing discipline (qdisc) so priorities will be assigned prior to the hardware
+Priorities are set immediately prior to queuing a frame to the device
+queuing discipline (qdisc) so priorities will be assigned prior to the hardware
 queue selection being made.
 
 One usage for the net_prio cgroup is with mqprio qdisc allowing application
diff --git a/Documentation/devicetree/bindings/arm/omap/omap.txt b/Documentation/devicetree/bindings/arm/omap/omap.txt
index af9b4a0..aa719623 100644
--- a/Documentation/devicetree/bindings/arm/omap/omap.txt
+++ b/Documentation/devicetree/bindings/arm/omap/omap.txt
@@ -114,5 +114,5 @@ Boards:
 - AM43x EPOS EVM
   compatible = "ti,am43x-epos-evm", "ti,am4372", "ti,am43"
 
-- DRA7 EVM:  Software Developement Board for DRA7XX
+- DRA7 EVM:  Software Development Board for DRA7XX
   compatible = "ti,dra7-evm", "ti,dra7"
diff --git a/Documentation/devicetree/bindings/bus/mvebu-mbus.txt b/Documentation/devicetree/bindings/bus/mvebu-mbus.txt
index 7586fb6..5fa44f5 100644
--- a/Documentation/devicetree/bindings/bus/mvebu-mbus.txt
+++ b/Documentation/devicetree/bindings/bus/mvebu-mbus.txt
@@ -197,7 +197,7 @@ to be set by the operating system and that are guaranteed to be free of overlaps
 with one another or with the system memory ranges.
 
 Each entry in the property refers to exactly one window. If the operating system
-choses to use a different set of mbus windows, it must ensure that any address
+chooses to use a different set of mbus windows, it must ensure that any address
 translations performed from downstream devices are adapted accordingly.
 
 The operating system may insert additional mbus windows that do not conflict
diff --git a/Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt b/Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt
index 3ddc7cc..c306a2d0 100644
--- a/Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt
+++ b/Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt
@@ -54,7 +54,7 @@ Optional device specific properties:
         IO 8-15 are bank 2. These chips have two different interrupt outputs:
         One for bank 1 and another for bank 2. If irq-mirror is set, both
         interrupts are generated regardless of the bank that an input change
-        occured on. If it is not set, the interrupt are only generated for the
+        occurred on. If it is not set, the interrupt are only generated for the
         bank they belong to.
         On devices with only one interrupt output this property is useless.
 
diff --git a/Documentation/devicetree/bindings/mmc/k3-dw-mshc.txt b/Documentation/devicetree/bindings/mmc/k3-dw-mshc.txt
index b8653ea..e5bc49f 100644
--- a/Documentation/devicetree/bindings/mmc/k3-dw-mshc.txt
+++ b/Documentation/devicetree/bindings/mmc/k3-dw-mshc.txt
@@ -12,7 +12,7 @@ extensions to the Synopsys Designware Mobile Storage Host Controller.
 Required Properties:
 
 * compatible: should be one of the following.
-  - "hisilicon,hi4511-dw-mshc": for controllers with hi4511 specific extentions.
+  - "hisilicon,hi4511-dw-mshc": for controllers with hi4511 specific extensions.
 
 Example:
 
diff --git a/Documentation/devicetree/bindings/mmc/samsung-sdhci.txt b/Documentation/devicetree/bindings/mmc/samsung-sdhci.txt
index 328e990..42e0a9af 100644
--- a/Documentation/devicetree/bindings/mmc/samsung-sdhci.txt
+++ b/Documentation/devicetree/bindings/mmc/samsung-sdhci.txt
@@ -3,7 +3,7 @@
 Samsung's SDHCI controller is used as a connectivity interface with external
 MMC, SD and eMMC storage mediums. This file documents differences between the
 core mmc properties described by mmc.txt and the properties used by the
-Samsung implmentation of the SDHCI controller.
+Samsung implementation of the SDHCI controller.
 
 Required SoC Specific Properties:
 - compatible: should be one of the following
diff --git a/Documentation/devicetree/bindings/mtd/gpmc-nand.txt b/Documentation/devicetree/bindings/mtd/gpmc-nand.txt
index 5e1f31b..eb05255 100644
--- a/Documentation/devicetree/bindings/mtd/gpmc-nand.txt
+++ b/Documentation/devicetree/bindings/mtd/gpmc-nand.txt
@@ -43,7 +43,7 @@ Optional properties:
 		ELM hardware engines should specify this device node in .dtsi
 		Using ELM for ECC error correction frees some CPU cycles.
 
-For inline partiton table parsing (optional):
+For inline partition table parsing (optional):
 
  - #address-cells: should be set to 1
  - #size-cells: should be set to 1
diff --git a/Documentation/devicetree/bindings/mtd/gpmc-nor.txt b/Documentation/devicetree/bindings/mtd/gpmc-nor.txt
index 420b3ab..4828c17 100644
--- a/Documentation/devicetree/bindings/mtd/gpmc-nor.txt
+++ b/Documentation/devicetree/bindings/mtd/gpmc-nor.txt
@@ -30,7 +30,7 @@ Optional properties:
 - gpmc,XXX		Additional GPMC timings and settings parameters. See
 			Documentation/devicetree/bindings/bus/ti-gpmc.txt
 
-Optional properties for partiton table parsing:
+Optional properties for partition table parsing:
 - #address-cells: should be set to 1
 - #size-cells: should be set to 1
 
diff --git a/Documentation/devicetree/bindings/mtd/gpmc-onenand.txt b/Documentation/devicetree/bindings/mtd/gpmc-onenand.txt
index b752942..5d8fa52 100644
--- a/Documentation/devicetree/bindings/mtd/gpmc-onenand.txt
+++ b/Documentation/devicetree/bindings/mtd/gpmc-onenand.txt
@@ -17,7 +17,7 @@ Optional properties:
 
  - dma-channel:		DMA Channel index
 
-For inline partiton table parsing (optional):
+For inline partition table parsing (optional):
 
  - #address-cells: should be set to 1
  - #size-cells: should be set to 1
diff --git a/Documentation/devicetree/bindings/pinctrl/brcm,bcm11351-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/brcm,bcm11351-pinctrl.txt
index c119deb..54a6e82 100644
--- a/Documentation/devicetree/bindings/pinctrl/brcm,bcm11351-pinctrl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/brcm,bcm11351-pinctrl.txt
@@ -73,9 +73,9 @@ Optional Properties (for standard pins):
 				Otherwise:
 					0: fast slew rate
 					1: normal slew rate
-- input-enable:			No arguements. Enable input (does not affect
+- input-enable:			No arguments. Enable input (does not affect
 				output.)
-- input-disable:		No arguements. Disable input (does not affect
+- input-disable:		No arguments. Disable input (does not affect
 				output.)
 - drive-strength:		Integer. Drive strength in mA.  Valid values are
 				2, 4, 6, 8, 10, 12, 14, 16 mA.
@@ -99,9 +99,9 @@ Optional Properties (for I2C pins):
 				Otherwise:
 					0: fast slew rate
 					1: normal slew rate
-- input-enable:			No arguements. Enable input (does not affect
+- input-enable:			No arguments. Enable input (does not affect
 				output.)
-- input-disable:		No arguements. Disable input (does not affect
+- input-disable:		No arguments. Disable input (does not affect
 				output.)
 
 Optional Properties (for HDMI pins):
@@ -111,9 +111,9 @@ Optional Properties (for HDMI pins):
 - slew-rate:			Integer. Controls slew rate.
 					0: Standard(100kbps)& Fast(400kbps) mode
 					1: Highspeed (3.4Mbps) mode
-- input-enable:			No arguements. Enable input (does not affect
+- input-enable:			No arguments. Enable input (does not affect
 				output.)
-- input-disable:		No arguements. Disable input (does not affect
+- input-disable:		No arguments. Disable input (does not affect
 				output.)
 
 Example:
diff --git a/Documentation/devicetree/bindings/powerpc/4xx/reboot.txt b/Documentation/devicetree/bindings/powerpc/4xx/reboot.txt
index d721726..5bc6355 100644
--- a/Documentation/devicetree/bindings/powerpc/4xx/reboot.txt
+++ b/Documentation/devicetree/bindings/powerpc/4xx/reboot.txt
@@ -1,7 +1,7 @@
 Reboot property to control system reboot on PPC4xx systems:
 
 By setting "reset_type" to one of the following values, the default
-software reset mechanism may be overidden. Here the possible values of
+software reset mechanism may be overridden. Here the possible values of
 "reset_type":
 
       1 - PPC4xx core reset
diff --git a/Documentation/devicetree/bindings/powerpc/fsl/dcsr.txt b/Documentation/devicetree/bindings/powerpc/fsl/dcsr.txt
index 9d54eb5..18a8810 100644
--- a/Documentation/devicetree/bindings/powerpc/fsl/dcsr.txt
+++ b/Documentation/devicetree/bindings/powerpc/fsl/dcsr.txt
@@ -82,7 +82,7 @@ PROPERTIES
 	Which event source asserted the interrupt is captured in an EPU
 	Interrupt Status Register (EPISR0,EPISR1).
 
-	Interrupt numbers are lised in order (perfmon, event0, event1).
+	Interrupt numbers are listed in order (perfmon, event0, event1).
 
 	- interrupt-parent
 	Usage: required
diff --git a/Documentation/devicetree/bindings/regulator/regulator.txt b/Documentation/devicetree/bindings/regulator/regulator.txt
index e2c7f1e..941c0bb 100644
--- a/Documentation/devicetree/bindings/regulator/regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/regulator.txt
@@ -12,7 +12,7 @@ Optional properties:
 - regulator-allow-bypass: allow the regulator to go into bypass mode
 - <name>-supply: phandle to the parent supply/regulator node
 - regulator-ramp-delay: ramp delay for regulator(in uV/uS)
-  For hardwares which support disabling ramp rate, it should be explicitly
+  For hardware which support disabling ramp rate, it should be explicitly
   intialised to zero (regulator-ramp-delay = <0>) for disabling ramp delay.
 - regulator-enable-ramp-delay: The time taken, in microseconds, for the supply
   rail to reach the target voltage, plus/minus whatever tolerance the board
diff --git a/Documentation/devicetree/bindings/spi/spi-bus.txt b/Documentation/devicetree/bindings/spi/spi-bus.txt
index e5a4d1b..0ff87d1 100644
--- a/Documentation/devicetree/bindings/spi/spi-bus.txt
+++ b/Documentation/devicetree/bindings/spi/spi-bus.txt
@@ -61,7 +61,7 @@ contain the following properties.
                       used for MISO. Defaults to 1 if not present.
 
 Some SPI controllers and devices support Dual and Quad SPI transfer mode.
-It allows data in SPI system transfered in 2 wires(DUAL) or 4 wires(QUAD).
+It allows data in SPI system transferred in 2 wires(DUAL) or 4 wires(QUAD).
 Now the value that spi-tx-bus-width and spi-rx-bus-width can receive is
 only 1(SINGLE), 2(DUAL) and 4(QUAD).
 Dual/Quad mode is not allowed when 3-wire mode is used.
diff --git a/Documentation/dma-buf-sharing.txt b/Documentation/dma-buf-sharing.txt
index 505e711..8b6e524 100644
--- a/Documentation/dma-buf-sharing.txt
+++ b/Documentation/dma-buf-sharing.txt
@@ -217,7 +217,7 @@ NOTES:
     and then allow further {map,unmap}_dma_buf operations from any buffer-user
     from the migrated backing-storage.
 
-   If the exporter cannot fulfil the backing-storage constraints of the new
+   If the exporter cannot fulfill the backing-storage constraints of the new
    buffer-user device as requested, dma_buf_attach() would return an error to
    denote non-compatibility of the new buffer-sharing request with the current
    buffer.
diff --git a/Documentation/dynamic-debug-howto.txt b/Documentation/dynamic-debug-howto.txt
index 46325eb..4227712 100644
--- a/Documentation/dynamic-debug-howto.txt
+++ b/Documentation/dynamic-debug-howto.txt
@@ -321,7 +321,7 @@ nullarbor:~ # echo -n 'func svc_process -p' >
 nullarbor:~ # echo -n 'format "nfsd: READ" +p' >
 				<debugfs>/dynamic_debug/control
 
-// enable messages in files of which the pathes include string "usb"
+// enable messages in files of which the path include string "usb"
 nullarbor:~ # echo -n '*usb* +p' > <debugfs>/dynamic_debug/control
 
 // enable all messages
diff --git a/Documentation/edac.txt b/Documentation/edac.txt
index 56c7e93..8bdc07c 100644
--- a/Documentation/edac.txt
+++ b/Documentation/edac.txt
@@ -550,7 +550,7 @@ installs itself as:
 	/sys/devices/systm/edac/test-instance
 
 in this directory are various controls, a symlink and one or more 'instance'
-directorys.
+directories.
 
 The standard default controls are:
 
diff --git a/Documentation/fb/sm501.txt b/Documentation/fb/sm501.txt
index 8d17aeb..187f3b3 100644
--- a/Documentation/fb/sm501.txt
+++ b/Documentation/fb/sm501.txt
@@ -3,7 +3,7 @@ Configuration:
 You can pass the following kernel command line options to sm501 videoframebuffer:
 
 	sm501fb.bpp=	SM501 Display driver:
-			Specifiy bits-per-pixel if not specified by 'mode'
+			Specify bits-per-pixel if not specified by 'mode'
 
 	sm501fb.mode=	SM501 Display driver:
 			Specify resolution as
diff --git a/Documentation/fb/sstfb.txt b/Documentation/fb/sstfb.txt
index 550ca77..13db107 100644
--- a/Documentation/fb/sstfb.txt
+++ b/Documentation/fb/sstfb.txt
@@ -10,7 +10,7 @@ Introduction
 	  The main page is located at <http://sstfb.sourceforge.net>, and if
 	you want the latest version, check out the CVS, as the driver is a work
 	in progress, I feel uncomfortable with releasing tarballs of something
-	not completely working...Don't worry, it's still more than useable
+	not completely working...Don't worry, it's still more than usable
 	(I eat my own dog food)
 
 	  Please read the Bug section, and report any success or failure to me
diff --git a/Documentation/filesystems/path-lookup.txt b/Documentation/filesystems/path-lookup.txt
index 3571667..6afebbd 100644
--- a/Documentation/filesystems/path-lookup.txt
+++ b/Documentation/filesystems/path-lookup.txt
@@ -29,7 +29,7 @@ because of the locks and atomic operations required for every dentry element
 slows things down. It is not scalable because many parallel applications that
 are path-walk intensive tend to do path lookups starting from a common dentry
 (usually, the root "/" or current working directory). So contention on these
-common path elements causes lock and cacheline queueing.
+common path elements causes lock and cacheline queuing.
 
 Since 2.6.38, RCU is used to make a significant part of the entire path walk
 (including dcache look-up) completely "store-free" (so, no locks, atomics, or
diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index f00bee1..d4fa7f5 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -234,7 +234,7 @@ Table 1-2: Contents of the status files (as of 2.6.30-rc7)
  ShdPnd                      bitmap of shared pending signals for the process
  SigBlk                      bitmap of blocked signals
  SigIgn                      bitmap of ignored signals
- SigCgt                      bitmap of catched signals
+ SigCgt                      bitmap of caught signals
  CapInh                      bitmap of inheritable capabilities
  CapPrm                      bitmap of permitted capabilities
  CapEff                      bitmap of effective capabilities
@@ -300,7 +300,7 @@ Table 1-4: Contents of the stat files (as of 2.6.30-rc7)
   pending       bitmap of pending signals
   blocked       bitmap of blocked signals
   sigign        bitmap of ignored signals
-  sigcatch      bitmap of catched signals
+  sigcatch      bitmap of caught signals
   wchan         address where process went to sleep
   0             (place holder)
   0             (place holder)
diff --git a/Documentation/filesystems/sharedsubtree.txt b/Documentation/filesystems/sharedsubtree.txt
index 4ede421..32a173d 100644
--- a/Documentation/filesystems/sharedsubtree.txt
+++ b/Documentation/filesystems/sharedsubtree.txt
@@ -727,7 +727,7 @@ replicas continue to be exactly same.
 			  mkdir -p /tmp/m3
 			  mount --rbind /root /tmp/m3
 
-			  I wont' draw the tree..but it has 24 vfsmounts
+			  I won't draw the tree..but it has 24 vfsmounts
 
 
 		at step i the number of vfsmounts is V[i] = i*V[i-1].
diff --git a/Documentation/gpio/consumer.txt b/Documentation/gpio/consumer.txt
index e42f77d..0ff8eb0 100644
--- a/Documentation/gpio/consumer.txt
+++ b/Documentation/gpio/consumer.txt
@@ -41,7 +41,7 @@ Both functions return either a valid GPIO descriptor, or an error code checkable
 with IS_ERR() (they will never return a NULL pointer). -ENOENT will be returned
 if and only if no GPIO has been assigned to the device/function/index triplet,
 other error codes are used for cases where a GPIO has been assigned but an error
-occured while trying to acquire it. This is useful to discriminate between mere
+occurred while trying to acquire it. This is useful to discriminate between mere
 errors and an absence of GPIO for optional GPIO parameters.
 
 Device-managed variants of these functions are also defined:
diff --git a/Documentation/hid/uhid.txt b/Documentation/hid/uhid.txt
index dc35a2b..31cabfd 100644
--- a/Documentation/hid/uhid.txt
+++ b/Documentation/hid/uhid.txt
@@ -114,7 +114,7 @@ the request was handled successfully.
 
 read()
 ------
-read() will return a queued ouput report. These output reports can be of type
+read() will return a queued output report. These output reports can be of type
 UHID_START, UHID_STOP, UHID_OPEN, UHID_CLOSE, UHID_OUTPUT or UHID_OUTPUT_EV. No
 reaction is required to any of them but you should handle them according to your
 needs. Only UHID_OUTPUT and UHID_OUTPUT_EV have payloads.
diff --git a/Documentation/input/alps.txt b/Documentation/input/alps.txt
index e544c7f..90bca6f 100644
--- a/Documentation/input/alps.txt
+++ b/Documentation/input/alps.txt
@@ -94,7 +94,7 @@ PS/2 packet format
 
 Note that the device never signals overflow condition.
 
-ALPS Absolute Mode - Protocol Verion 1
+ALPS Absolute Mode - Protocol Version 1
 --------------------------------------
 
  byte 0:  1    0    0    0    1   x9   x8   x7
diff --git a/Documentation/input/input.txt b/Documentation/input/input.txt
index 666c06c..0acfddb 100644
--- a/Documentation/input/input.txt
+++ b/Documentation/input/input.txt
@@ -226,7 +226,7 @@ And so on up to js31.
 ~~~~~~~~~~~
   evdev is the generic input event interface. It passes the events
 generated in the kernel straight to the program, with timestamps. The
-API is still evolving, but should be useable now. It's described in
+API is still evolving, but should be usable now. It's described in
 section 5. 
 
   This should be the way for GPM and X to get keyboard and mouse
diff --git a/Documentation/ioctl/hdio.txt b/Documentation/ioctl/hdio.txt
index 18eb98c..d62e76f 100644
--- a/Documentation/ioctl/hdio.txt
+++ b/Documentation/ioctl/hdio.txt
@@ -699,9 +699,9 @@ HDIO_DRIVE_TASKFILE		execute raw taskfile
 	    TASKFILE_MULTI_OUT
 	    TASKFILE_IN_OUT
 	    TASKFILE_IN_DMA
-	    TASKFILE_IN_DMAQ		== IN_DMA (queueing not supported)
+	    TASKFILE_IN_DMAQ		== IN_DMA (queuing not supported)
 	    TASKFILE_OUT_DMA
-	    TASKFILE_OUT_DMAQ		== OUT_DMA (queueing not supported)
+	    TASKFILE_OUT_DMAQ		== OUT_DMA (queuing not supported)
 	    TASKFILE_P_IN		unimplemented
 	    TASKFILE_P_IN_DMA		unimplemented
 	    TASKFILE_P_IN_DMAQ		unimplemented
diff --git a/Documentation/mtd/nand/pxa3xx-nand.txt b/Documentation/mtd/nand/pxa3xx-nand.txt
index 840fd41..1074cbc 100644
--- a/Documentation/mtd/nand/pxa3xx-nand.txt
+++ b/Documentation/mtd/nand/pxa3xx-nand.txt
@@ -48,7 +48,7 @@ configurable between two modes: 1) Hamming, 2) BCH.
 Note that the actual BCH mode: BCH-4 or BCH-8 will depend on the way
 the controller is configured to transfer the data.
 
-In the BCH mode the ECC code will be calculated for each transfered chunk
+In the BCH mode the ECC code will be calculated for each transferred chunk
 and expected to be located (when reading/programming) right after the spare
 bytes as the figure above shows.
 
diff --git a/Documentation/networking/can.txt b/Documentation/networking/can.txt
index 0cbe6ec..4899239 100644
--- a/Documentation/networking/can.txt
+++ b/Documentation/networking/can.txt
@@ -80,7 +80,7 @@ are based on character devices and provide comparatively little
 functionality.  Usually, there is only a hardware-specific device
 driver which provides a character device interface to send and
 receive raw CAN frames, directly to/from the controller hardware.
-Queueing of frames and higher-level transport protocols like ISO-TP
+Queuing of frames and higher-level transport protocols like ISO-TP
 have to be implemented in user space applications.  Also, most
 character-device implementations support only one single process to
 open the device at a time, similar to a serial interface.  Exchanging
@@ -91,7 +91,7 @@ new driver's API.
 SocketCAN was designed to overcome all of these limitations.  A new
 protocol family has been implemented which provides a socket interface
 to user space applications and which builds upon the Linux network
-layer, enabling use all of the provided queueing functionality.  A device
+layer, enabling use all of the provided queuing functionality.  A device
 driver for CAN controller hardware registers itself with the Linux
 network layer as a network device, so that CAN frames from the
 controller can be passed up to the network layer and on to the CAN
@@ -119,7 +119,7 @@ solution for a couple of reasons:
   application would have to do all these operations using ioctl(2)s.
 
 * Code duplication.  A character device cannot make use of the Linux
-  network queueing code, so all that code would have to be duplicated
+  network queuing code, so all that code would have to be duplicated
   for CAN networking.
 
 * Abstraction.  In most existing character-device implementations, the
@@ -141,7 +141,7 @@ solution for a couple of reasons:
   existing drivers.  The right way, however, would be to add such a
   layer with all the functionality like registering for certain CAN
   IDs, supporting several open file descriptors and (de)multiplexing
-  CAN frames between them, (sophisticated) queueing of CAN frames, and
+  CAN frames between them, (sophisticated) queuing of CAN frames, and
   providing an API for device drivers to register with.  However, then
   it would be no more difficult, or may be even easier, to use the
   networking framework provided by the Linux kernel, and this is what
@@ -706,7 +706,7 @@ solution for a couple of reasons:
 
     RX_NO_AUTOTIMER:    Prevent automatically starting the timeout monitor.
 
-    RX_ANNOUNCE_RESUME: If passed at RX_SETUP and a receive timeout occured, a
+    RX_ANNOUNCE_RESUME: If passed at RX_SETUP and a receive timeout occurred, a
       RX_CHANGED message will be generated when the (cyclic) receive restarts.
 
     TX_RESET_MULTI_IDX: Reset the index for the multiple frame transmission.
diff --git a/Documentation/networking/dccp.txt b/Documentation/networking/dccp.txt
index bf5dbe3..55c575f 100644
--- a/Documentation/networking/dccp.txt
+++ b/Documentation/networking/dccp.txt
@@ -86,7 +86,7 @@ built-in CCIDs.
 
 DCCP_SOCKOPT_CCID is write-only and sets both the TX and RX CCIDs at the same
 time, combining the operation of the next two socket options. This option is
-preferrable over the latter two, since often applications will use the same
+preferable over the latter two, since often applications will use the same
 type of CCID for both directions; and mixed use of CCIDs is not currently well
 understood. This socket option takes as argument at least one uint8_t value, or
 an array of uint8_t values, which must match available CCIDS (see above). CCIDs
diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index ab42c95..e8c5971 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -335,7 +335,7 @@ tcp_mem - vector of 3 INTEGERs: min, pressure, max
 	pressure mode, which is exited when memory consumption falls
 	under "min".
 
-	max: number of pages allowed for queueing by all TCP sockets.
+	max: number of pages allowed for queuing by all TCP sockets.
 
 	Defaults are calculated at boot time from amount of available
 	memory.
@@ -631,7 +631,7 @@ tcp_challenge_ack_limit - INTEGER
 UDP variables:
 
 udp_mem - vector of 3 INTEGERs: min, pressure, max
-	Number of pages allowed for queueing by all UDP sockets.
+	Number of pages allowed for queuing by all UDP sockets.
 
 	min: Below this number of pages UDP is not bothered about its
 	memory appetite. When amount of memory allocated by UDP exceeds
@@ -639,7 +639,7 @@ udp_mem - vector of 3 INTEGERs: min, pressure, max
 
 	pressure: This value was introduced to follow format of tcp_mem.
 
-	max: Number of pages allowed for queueing by all UDP sockets.
+	max: Number of pages allowed for queuing by all UDP sockets.
 
 	Default is calculated at boot time from amount of available memory.
 
@@ -1650,7 +1650,7 @@ sndbuf_policy - INTEGER
 	Default: 0
 
 sctp_mem - vector of 3 INTEGERs: min, pressure, max
-	Number of pages allowed for queueing by all SCTP sockets.
+	Number of pages allowed for queuing by all SCTP sockets.
 
 	min: Below this number of pages SCTP is not bothered about its
 	memory appetite. When amount of memory allocated by SCTP exceeds
@@ -1658,7 +1658,7 @@ sctp_mem - vector of 3 INTEGERs: min, pressure, max
 
 	pressure: This value was introduced to follow format of tcp_mem.
 
-	max: Number of pages allowed for queueing by all SCTP sockets.
+	max: Number of pages allowed for queuing by all SCTP sockets.
 
 	Default is calculated at boot time from amount of available memory.
 
diff --git a/Documentation/powerpc/transactional_memory.txt b/Documentation/powerpc/transactional_memory.txt
index dc23e58..9791e98 100644
--- a/Documentation/powerpc/transactional_memory.txt
+++ b/Documentation/powerpc/transactional_memory.txt
@@ -160,7 +160,7 @@ To avoid this, when taking a signal in an active transaction, we need to use
 the stack pointer from the checkpointed state, rather than the speculated
 state.  This ensures that the signal context (written tm suspended) will be
 written below the stack required for the rollback.  The transaction is aborted
-becuase of the treclaim, so any memory written between the tbegin and the
+because of the treclaim, so any memory written between the tbegin and the
 signal will be rolled back anyway.
 
 For signals taken in non-TM or suspended mode, we use the
diff --git a/Documentation/rbtree.txt b/Documentation/rbtree.txt
index 61b6c48..39873ef 100644
--- a/Documentation/rbtree.txt
+++ b/Documentation/rbtree.txt
@@ -255,7 +255,7 @@ However, rbtree can be augmented to store such interval ranges in a structured
 way making it possible to do efficient lookup and exact match.
 
 This "extra information" stored in each node is the maximum hi
-(max_hi) value among all the nodes that are its descendents. This
+(max_hi) value among all the nodes that are its descendants. This
 information can be maintained at each node just be looking at the node
 and its immediate children. And this will be used in O(log n) lookup
 for lowest match (lowest start address among all possible matches)
diff --git a/Documentation/rfkill.txt b/Documentation/rfkill.txt
index f430004..427e897 100644
--- a/Documentation/rfkill.txt
+++ b/Documentation/rfkill.txt
@@ -21,7 +21,7 @@ aircraft.
 The rfkill subsystem has a concept of "hard" and "soft" block, which
 differ little in their meaning (block == transmitters off) but rather in
 whether they can be changed or not:
- - hard block: read-only radio block that cannot be overriden by software
+ - hard block: read-only radio block that cannot be overridden by software
  - soft block: writable radio block (need not be readable) that is set by
                the system software.
 
diff --git a/Documentation/robust-futexes.txt b/Documentation/robust-futexes.txt
index 0a9446a..af6fce2 100644
--- a/Documentation/robust-futexes.txt
+++ b/Documentation/robust-futexes.txt
@@ -210,7 +210,7 @@ i386 and x86_64 syscalls are wired up at the moment, and Ulrich has
 tested the new glibc code (on x86_64 and i386), and it works for his
 robust-mutex testcases.
 
-All other architectures should build just fine too - but they wont have
+All other architectures should build just fine too - but they won't have
 the new syscalls yet.
 
 Architectures need to implement the new futex_atomic_cmpxchg_inatomic()
diff --git a/Documentation/s390/monreader.txt b/Documentation/s390/monreader.txt
index beeaa4b..d372958 100644
--- a/Documentation/s390/monreader.txt
+++ b/Documentation/s390/monreader.txt
@@ -10,7 +10,7 @@ Author: Gerald Schaefer (geraldsc@de.ibm.com)
 Description
 ===========
 This item delivers a new Linux API in the form of a misc char device that is
-useable from user space and allows read access to the z/VM Monitor Records
+usable from user space and allows read access to the z/VM Monitor Records
 collected by the *MONITOR System Service of z/VM.
 
 
diff --git a/Documentation/scsi/53c700.txt b/Documentation/scsi/53c700.txt
index e31aceb..c1f7642 100644
--- a/Documentation/scsi/53c700.txt
+++ b/Documentation/scsi/53c700.txt
@@ -3,7 +3,7 @@ General Description
 
 This driver supports the 53c700 and 53c700-66 chips.  It also supports
 the 53c710 but only in 53c700 emulation mode.  It is full featured and
-does sync (-66 and 710 only), disconnects and tag command queueing.
+does sync (-66 and 710 only), disconnects and tag command queuing.
 
 Since the 53c700 must be interfaced to a bus, you need to wrapper the
 card detector around this driver.  For an example, see the
diff --git a/Documentation/scsi/dc395x.txt b/Documentation/scsi/dc395x.txt
index 88219f9..798e700 100644
--- a/Documentation/scsi/dc395x.txt
+++ b/Documentation/scsi/dc395x.txt
@@ -58,7 +58,7 @@ The following parameters are available:
       *1    0x02       2     Synchronous Negotiation
       *2    0x04       4     Disconnection
       *3    0x08       8     Send Start command on startup. (Not used)
-      *4    0x10      16     Tagged Command Queueing
+      *4    0x10      16     Tagged Command Queuing
       *5    0x20      32     Wide Negotiation
 
  - adapter_mode
diff --git a/Documentation/scsi/ncr53c8xx.txt b/Documentation/scsi/ncr53c8xx.txt
index cda5f8f..e2112af 100644
--- a/Documentation/scsi/ncr53c8xx.txt
+++ b/Documentation/scsi/ncr53c8xx.txt
@@ -13,7 +13,7 @@ Written by Gerard Roudier <groudier@free.fr>
       3.1 Optimized SCSI SCRIPTS
       3.2 New features of the SYM53C896 (64 bit PCI dual LVD SCSI controller)
 4.  Memory mapped I/O versus normal I/O
-5.  Tagged command queueing
+5.  Tagged command queuing
 6.  Parity checking
 7.  Profiling information
 8.  Control commands
@@ -232,7 +232,7 @@ The configuration option CONFIG_SCSI_NCR53C8XX_IOMAPPED forces the
 driver to use normal I/O in all cases.
 
 
-5. Tagged command queueing
+5. Tagged command queuing
 
 Queuing more than 1 command at a time to a device allows it to perform 
 optimizations based on actual head positions and its mechanical 
@@ -269,7 +269,7 @@ more than 64 simultaneous commands. So, using more than 64 queued commands
 is probably just resource wasting.
 
 If your controller does not have NVRAM or if it is managed by the SDMS 
-BIOS/SETUP, you can configure tagged queueing feature and device queue 
+BIOS/SETUP, you can configure tagged queuing feature and device queue
 depths from the boot command-line. For example:
 
   ncr53c8xx=tags:4/t2t3q15-t4q7/t1u0q32
@@ -699,7 +699,7 @@ port address 0x1400.
         tags:#tags (#tags  > 1) tagged command queuing enabled
   #tags will be truncated to the max queued commands configuration parameter.
   This option also allows to specify a command queue depth for each device 
-  that support tagged command queueing.
+  that support tagged command queuing.
   Example:
       ncr53c8xx=tags:10/t2t3q16-t5q24/t1u2q32
                will set devices queue depth as follow:
diff --git a/Documentation/scsi/scsi_mid_low_api.txt b/Documentation/scsi/scsi_mid_low_api.txt
index d6a9bde..e6920bc 100644
--- a/Documentation/scsi/scsi_mid_low_api.txt
+++ b/Documentation/scsi/scsi_mid_low_api.txt
@@ -366,13 +366,13 @@ is initialized. The functions below are listed alphabetically and their
 names all start with "scsi_".
 
 Summary:
-   scsi_activate_tcq - turn on tag command queueing
+   scsi_activate_tcq - turn on tag command queuing
    scsi_add_device - creates new scsi device (lu) instance
    scsi_add_host - perform sysfs registration and set up transport class
    scsi_adjust_queue_depth - change the queue depth on a SCSI device
    scsi_bios_ptable - return copy of block device's partition table
    scsi_block_requests - prevent further commands being queued to given host
-   scsi_deactivate_tcq - turn off tag command queueing
+   scsi_deactivate_tcq - turn off tag command queuing
    scsi_host_alloc - return a new scsi_host instance whose refcount==1
    scsi_host_get - increments Scsi_Host instance's refcount
    scsi_host_put - decrements Scsi_Host instance's refcount (free if 0)
@@ -390,7 +390,7 @@ Summary:
 Details:
 
 /**
- * scsi_activate_tcq - turn on tag command queueing ("ordered" task attribute)
+ * scsi_activate_tcq - turn on tag command queuing ("ordered" task attribute)
  * @sdev:       device to turn on TCQ for
  * @depth:      queue depth
  *
@@ -515,7 +515,7 @@ void scsi_block_requests(struct Scsi_Host * shost)
 
 
 /**
- * scsi_deactivate_tcq - turn off tag command queueing
+ * scsi_deactivate_tcq - turn off tag command queuing
  * @sdev:       device to turn off TCQ for
  * @depth:      queue depth (stored in sdev)
  *
diff --git a/Documentation/scsi/sym53c8xx_2.txt b/Documentation/scsi/sym53c8xx_2.txt
index 6af8f7a..33e177a 100644
--- a/Documentation/scsi/sym53c8xx_2.txt
+++ b/Documentation/scsi/sym53c8xx_2.txt
@@ -15,7 +15,7 @@ Updated by Matthew Wilcox <matthew@wil.cx>
       3.1 Optimized SCSI SCRIPTS
       3.2 New features appeared with the SYM53C896
 4.  Memory mapped I/O versus normal I/O
-5.  Tagged command queueing
+5.  Tagged command queuing
 6.  Parity checking
 7.  Profiling information
 8.  Control commands
@@ -198,7 +198,7 @@ most hardware configurations, but some poorly designed chipsets may break
 this feature. A configuration option is provided for normal I/O to be 
 used but the driver defaults to MMIO.
 
-5. Tagged command queueing
+5. Tagged command queuing
 
 Queuing more than 1 command at a time to a device allows it to perform 
 optimizations based on actual head positions and its mechanical 
@@ -240,7 +240,7 @@ accept more than 64 simultaneous commands. So, using more than 64 queued
 commands is probably just resource wasting.
 
 If your controller does not have NVRAM or if it is managed by the SDMS 
-BIOS/SETUP, you can configure tagged queueing feature and device queue 
+BIOS/SETUP, you can configure tagged queuing feature and device queue
 depths from the boot command-line. For example:
 
   sym53c8xx=tags:4/t2t3q15-t4q7/t1u0q32
diff --git a/Documentation/scsi/tmscsim.txt b/Documentation/scsi/tmscsim.txt
index 3303d21..ca8b61a 100644
--- a/Documentation/scsi/tmscsim.txt
+++ b/Documentation/scsi/tmscsim.txt
@@ -115,7 +115,7 @@ IRQF_SHARED | IRQF_DISABLED.
 3.Features
 ----------
 - SCSI
- * Tagged command queueing
+ * Tagged command queuing
  * Sync speed up to 10 MHz
  * Disconnection
  * Multiple LUNs
@@ -173,7 +173,7 @@ adapter and the connected SCSI devices respectively.
 Idx is the device index (just a consecutive number for the driver), ID and
 LUN are the SCSI ID and LUN, Prty means Parity checking, Sync synchronous
 negotiation, DsCn Disconnection, SndS Send Start command on startup (not
-used by the driver) and TagQ Tagged Command Queueing. NegoPeriod and
+used by the driver) and TagQ Tagged Command Queuing. NegoPeriod and
 SyncSpeed are somehow redundant, because they are reciprocal values 
 (1 / 112 ns = 8.9 MHz). At least in theory. The driver is able to adjust the
 NegoPeriod more accurate (4ns) than the SyncSpeed (1 / 25ns). I don't know
@@ -224,7 +224,7 @@ There are three kinds of changes:
     to require all three to have a syntax similar to the output.
     The following "y y y - y" enables Parity checking, enables Synchronous
     transfers, Disconnection, leaves Send Start (not used) untouched and
-    enables Tagged Command Queueing for the selected device. The "-" skips
+    enables Tagged Command Queuing for the selected device. The "-" skips
     the Negotiation Period setting but the "10" sets the max sync. speed to
     10 MHz. It's useless to specify both NegoPeriod and SyncSpeed as
     discussed above. The values used in this example will result in maximum
@@ -302,7 +302,7 @@ Each of the parameters is a number, containing the described information:
    *1	 0x02	    2	  Synchronous Negotiation
    *2	 0x04	    4	  Disconnection
    *3	 0x08	    8	  Send Start command on startup. (Not used)
-   *4	 0x10	   16	  Tagged Command Queueing
+   *4	 0x10	   16	  Tagged Command Queuing
 
   As usual, the desired value is obtained by adding the wanted values. If
   you want to enable all values, e.g., you would use 31(0x1f). Default is 31.
@@ -357,7 +357,7 @@ to further improve its usability:
 * Use new_eh code (Linux-2.1+)
 * Have the mid-level (ML) code (and not the driver) handle more of the
   various conditions.
-* Command queueing in the driver: Eliminate Query list and use ML instead.
+* Command queuing in the driver: Eliminate Query list and use ML instead.
 * More user friendly boot/module param syntax
 
 Further investigation on these problems:
diff --git a/Documentation/security/Yama.txt b/Documentation/security/Yama.txt
index dd908cf..227a63f 100644
--- a/Documentation/security/Yama.txt
+++ b/Documentation/security/Yama.txt
@@ -37,7 +37,7 @@ still work as root).
 In mode 1, software that has defined application-specific relationships
 between a debugging process and its inferior (crash handlers, etc),
 prctl(PR_SET_PTRACER, pid, ...) can be used. An inferior can declare which
-other process (and its descendents) are allowed to call PTRACE_ATTACH
+other process (and its descendants) are allowed to call PTRACE_ATTACH
 against it. Only one such declared debugging process can exists for
 each inferior at a time. For example, this is used by KDE, Chromium, and
 Firefox's crash handlers, and by Wine for allowing only Wine processes
diff --git a/Documentation/serial/tty.txt b/Documentation/serial/tty.txt
index 540db41..9c74511 100644
--- a/Documentation/serial/tty.txt
+++ b/Documentation/serial/tty.txt
@@ -126,11 +126,11 @@ put_char()		Queues a character for writing to the tty device.
 			ignored.
 
 flush_chars()		(Optional) If defined, must be called after
-			queueing characters with put_char() in order to
+			queuing characters with put_char() in order to
 			start transmission.
 
 write_room()		Returns the numbers of characters the tty driver
-			will accept for queueing to be written.
+			will accept for queuing to be written.
 
 ioctl()			Invoke device specific ioctl.
 			Expects data pointers to refer to userspace.
diff --git a/Documentation/sound/alsa/ALSA-Configuration.txt b/Documentation/sound/alsa/ALSA-Configuration.txt
index b8dd0df..7ccf933 100644
--- a/Documentation/sound/alsa/ALSA-Configuration.txt
+++ b/Documentation/sound/alsa/ALSA-Configuration.txt
@@ -948,7 +948,7 @@ Prior to version 0.9.0rc4 options had a 'snd_' prefix. This was removed.
     avoided as much as possible...
     
     MORE NOTES ON "azx_get_response timeout" PROBLEMS:
-    On some hardwares, you may need to add a proper probe_mask option
+    On some hardware, you may need to add a proper probe_mask option
     to avoid the "azx_get_response timeout" problem above, instead.
     This occurs when the access to non-existing or non-working codec slot
     (likely a modem one) causes a stall of the communication via HD-audio
@@ -1124,7 +1124,7 @@ Prior to version 0.9.0rc4 options had a 'snd_' prefix. This was removed.
     buggy_irq     - Enable workaround for buggy interrupts on some
                     motherboards (default yes on nForce chips,
 		    otherwise off)
-    buggy_semaphore - Enable workaround for hardwares with buggy
+    buggy_semaphore - Enable workaround for hardware with buggy
 		    semaphores (e.g. on some ASUS laptops)
 		    (default off)
     spdif_aclink  - Use S/PDIF over AC-link instead of direct connection
diff --git a/Documentation/sysctl/net.txt b/Documentation/sysctl/net.txt
index 9a0319a..6059101 100644
--- a/Documentation/sysctl/net.txt
+++ b/Documentation/sysctl/net.txt
@@ -146,7 +146,7 @@ the target CPU processes packets. It might give some delay on timestamps, but
 permit to distribute the load on several cpus.
 
 If set to 1 (default), timestamps are sampled as soon as possible, before
-queueing.
+queuing.
 
 optmem_max
 ----------
diff --git a/Documentation/trace/events.txt b/Documentation/trace/events.txt
index c94435d..75d25a1 100644
--- a/Documentation/trace/events.txt
+++ b/Documentation/trace/events.txt
@@ -443,7 +443,7 @@ The following commands are supported:
   The following command creates a snapshot every time a block request
   queue is unplugged with a depth > 1.  If you were tracing a set of
   events or functions at the time, the snapshot trace buffer would
-  capture those events when the trigger event occured:
+  capture those events when the trigger event occurred:
 
   # echo 'snapshot if nr_rq > 1' > \
         /sys/kernel/debug/tracing/events/block/block_unplug/trigger
diff --git a/Documentation/usb/WUSB-Design-overview.txt b/Documentation/usb/WUSB-Design-overview.txt
index 4c5e379..b9b068b 100644
--- a/Documentation/usb/WUSB-Design-overview.txt
+++ b/Documentation/usb/WUSB-Design-overview.txt
@@ -357,7 +357,7 @@ DWAs.
 
 Each HC has a number of rpipes and buffers that can be assigned to them;
 when doing a data transfer (xfer), first the rpipe has to be aimed and
-prepared (buffers assigned), then we can start queueing requests for
+prepared (buffers assigned), then we can start queuing requests for
 data in or out.
 
 Data buffers have to be segmented out before sending--so we send first a
diff --git a/Documentation/usb/mass-storage.txt b/Documentation/usb/mass-storage.txt
index 59063ad..e89803a 100644
--- a/Documentation/usb/mass-storage.txt
+++ b/Documentation/usb/mass-storage.txt
@@ -13,7 +13,7 @@
   operation.
 
   Note that the driver is slightly non-portable in that it assumes
-  a single memory/DMA buffer will be useable for bulk-in and bulk-out
+  a single memory/DMA buffer will be usable for bulk-in and bulk-out
   endpoints.  With most device controllers this is not an issue, but
   there may be some with hardware restrictions that prevent a buffer
   from being used by more than one endpoint.
diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 6cd63a9..a6ab0b8 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -2037,7 +2037,7 @@ the "Server" class MMU emulation supported by KVM.
 This can in turn be used by userspace to generate the appropriate
 device-tree properties for the guest operating system.
 
-The structure contains some global informations, followed by an
+The structure contains some global information, followed by an
 array of supported segment page sizes:
 
       struct kvm_ppc_smmu_info {
diff --git a/Documentation/vm/transhuge.txt b/Documentation/vm/transhuge.txt
index 4a63953..6b31cfb 100644
--- a/Documentation/vm/transhuge.txt
+++ b/Documentation/vm/transhuge.txt
@@ -360,13 +360,13 @@ on any tail page, would mean having to split all hugepages upfront in
 get_user_pages which is unacceptable as too many gup users are
 performance critical and they must work natively on hugepages like
 they work natively on hugetlbfs already (hugetlbfs is simpler because
-hugetlbfs pages cannot be splitted so there wouldn't be requirement of
+hugetlbfs pages cannot be split so there wouldn't be requirement of
 accounting the pins on the tail pages for hugetlbfs). If we wouldn't
 account the gup refcounts on the tail pages during gup, we won't know
 anymore which tail page is pinned by gup and which is not while we run
 split_huge_page. But we still have to add the gup pin to the head page
 too, to know when we can free the compound page in case it's never
-splitted during its lifetime. That requires changing not just
+split during its lifetime. That requires changing not just
 get_page, but put_page as well so that when put_page runs on a tail
 page (and only on a tail page) it will find its respective head page,
 and then it will decrease the head page refcount in addition to the
diff --git a/Documentation/workqueue.txt b/Documentation/workqueue.txt
index f81a65b..bf0e821 100644
--- a/Documentation/workqueue.txt
+++ b/Documentation/workqueue.txt
@@ -375,7 +375,7 @@ The first one can be tracked using tracing:
 	(wait a few secs)
 	^C
 
-If something is busy looping on work queueing, it would be dominating
+If something is busy looping on work queuing, it would be dominating
 the output and the offender can be determined with the work item
 function.
 
diff --git a/Documentation/x86/earlyprintk.txt b/Documentation/x86/earlyprintk.txt
index f19802c..688e3ee 100644
--- a/Documentation/x86/earlyprintk.txt
+++ b/Documentation/x86/earlyprintk.txt
@@ -33,7 +33,7 @@ and two USB cables, connected like this:
  ...
 
 ( If your system does not list a debug port capability then you probably
-  wont be able to use the USB debug key. )
+  won't be able to use the USB debug key. )
 
  b.) You also need a Netchip USB debug cable/key:
 
diff --git a/Documentation/x86/i386/IO-APIC.txt b/Documentation/x86/i386/IO-APIC.txt
index 30b4c71..15f5baf 100644
--- a/Documentation/x86/i386/IO-APIC.txt
+++ b/Documentation/x86/i386/IO-APIC.txt
@@ -87,7 +87,7 @@ your PCI configuration:
 
 	echo -n pirq=; echo `scanpci | grep T_L | cut -c56-` | sed 's/ /,/g'
 
-note that this script wont work if you have skipped a few slots or if your
+note that this script won't work if you have skipped a few slots or if your
 board does not do default daisy-chaining. (or the IO-APIC has the PIRQ pins
 connected in some strange way). E.g. if in the above case you have your SCSI
 card (IRQ11) in Slot3, and have Slot1 empty:
-- 
1.9.1

