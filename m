Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612AbaCaV5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 17:57:21 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:40603 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaCaV5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 17:57:17 -0400
From: Carlos Garcia <carlos@cgarcia.org>
To: rdunlap@infradead.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org, Carlos Garcia <carlos@cgarcia.org>
Subject: [PATCH] Documentation: spelling error changes
Date: Mon, 31 Mar 2014 17:56:32 -0400
Message-Id: <1396302992-13582-1-git-send-email-carlos@cgarcia.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed multiple spelling errors.

Signed-off-by: Carlos E. Garcia <carlos@cgarcia.org>
---
 Documentation/DMA-attributes.txt                             |  2 +-
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
 Documentation/filesystems/proc.txt                           |  4 ++--
 Documentation/filesystems/sharedsubtree.txt                  |  2 +-
 Documentation/gpio/consumer.txt                              |  2 +-
 Documentation/hid/uhid.txt                                   |  2 +-
 Documentation/input/alps.txt                                 |  2 +-
 Documentation/input/input.txt                                |  2 +-
 Documentation/mtd/nand/pxa3xx-nand.txt                       |  2 +-
 Documentation/networking/can.txt                             |  2 +-
 Documentation/networking/dccp.txt                            |  2 +-
 Documentation/powerpc/transactional_memory.txt               |  2 +-
 Documentation/rbtree.txt                                     |  2 +-
 Documentation/rfkill.txt                                     |  2 +-
 Documentation/robust-futexes.txt                             |  2 +-
 Documentation/s390/monreader.txt                             |  2 +-
 Documentation/security/Yama.txt                              |  2 +-
 Documentation/sound/alsa/ALSA-Configuration.txt              |  4 ++--
 Documentation/trace/events.txt                               |  2 +-
 Documentation/usb/mass-storage.txt                           |  2 +-
 Documentation/virtual/kvm/api.txt                            |  2 +-
 Documentation/vm/transhuge.txt                               |  4 ++--
 Documentation/x86/earlyprintk.txt                            |  2 +-
 Documentation/x86/i386/IO-APIC.txt                           |  2 +-
 41 files changed, 49 insertions(+), 49 deletions(-)

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
index e2c7f1e..8607433 100644
--- a/Documentation/devicetree/bindings/regulator/regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/regulator.txt
@@ -12,7 +12,7 @@ Optional properties:
 - regulator-allow-bypass: allow the regulator to go into bypass mode
 - <name>-supply: phandle to the parent supply/regulator node
 - regulator-ramp-delay: ramp delay for regulator(in uV/uS)
-  For hardwares which support disabling ramp rate, it should be explicitly
+  For hardware which supports disabling ramp rate, it should be explicitly
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
index 46325eb..9417871 100644
--- a/Documentation/dynamic-debug-howto.txt
+++ b/Documentation/dynamic-debug-howto.txt
@@ -321,7 +321,7 @@ nullarbor:~ # echo -n 'func svc_process -p' >
 nullarbor:~ # echo -n 'format "nfsd: READ" +p' >
 				<debugfs>/dynamic_debug/control
 
-// enable messages in files of which the pathes include string "usb"
+// enable messages in files of which the paths include string "usb"
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
index 0cbe6ec..988be27 100644
--- a/Documentation/networking/can.txt
+++ b/Documentation/networking/can.txt
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
index 4a63953..aeea1b14 100644
--- a/Documentation/vm/transhuge.txt
+++ b/Documentation/vm/transhuge.txt
@@ -360,13 +360,13 @@ on any tail page, would mean having to split all hugepages upfront in
 get_user_pages which is unacceptable as too many gup users are
 performance critical and they must work natively on hugepages like
 they work natively on hugetlbfs already (hugetlbfs is simpler because
-hugetlbfs pages cannot be splitted so there wouldn't be requirement of
+hugetlbfs pages cannot be splitt so there wouldn't be requirement of
 accounting the pins on the tail pages for hugetlbfs). If we wouldn't
 account the gup refcounts on the tail pages during gup, we won't know
 anymore which tail page is pinned by gup and which is not while we run
 split_huge_page. But we still have to add the gup pin to the head page
 too, to know when we can free the compound page in case it's never
-splitted during its lifetime. That requires changing not just
+splitt during its lifetime. That requires changing not just
 get_page, but put_page as well so that when put_page runs on a tail
 page (and only on a tail page) it will find its respective head page,
 and then it will decrease the head page refcount in addition to the
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

