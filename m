Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbbABNy4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 08:54:56 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:51915 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbbABNyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 08:54:54 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, corbet@lwn.net, rdunlap@infradead.org,
        linux-doc@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] Documentation: devicetree: Fix double words in Doumentation/devicetree
Date: Fri,  2 Jan 2015 22:54:39 +0900
Message-Id: <1420206879-22465-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.2.1.62.g3f15098
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix multiple words such as "the the" and "which which"
in Documentation/devicetree.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/devicetree/bindings/arm/msm/timer.txt            | 2 +-
 Documentation/devicetree/bindings/ata/cavium-compact-flash.txt | 2 +-
 Documentation/devicetree/bindings/c6x/dscr.txt                 | 2 +-
 Documentation/devicetree/bindings/dma/renesas,rcar-dmac.txt    | 2 +-
 Documentation/devicetree/bindings/gpio/gpio-pcf857x.txt        | 2 +-
 Documentation/devicetree/bindings/iio/adc/xilinx-xadc.txt      | 2 +-
 Documentation/devicetree/bindings/mtd/fsmc-nand.txt            | 2 +-
 Documentation/devicetree/bindings/net/broadcom-systemport.txt  | 2 +-
 Documentation/devicetree/bindings/power/rockchip-io-domain.txt | 2 +-
 Documentation/devicetree/overlay-notes.txt                     | 4 ++--
 10 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/msm/timer.txt b/Documentation/devicetree/bindings/arm/msm/timer.txt
index c6ef8f1..74607b6 100644
--- a/Documentation/devicetree/bindings/arm/msm/timer.txt
+++ b/Documentation/devicetree/bindings/arm/msm/timer.txt
@@ -8,7 +8,7 @@ Properties:
                "qcom,kpss-timer" - krait subsystem
                "qcom,scss-timer" - scorpion subsystem
 
-- interrupts : Interrupts for the the debug timer, the first general purpose
+- interrupts : Interrupts for the debug timer, the first general purpose
                timer, and optionally a second general purpose timer in that
                order.
 
diff --git a/Documentation/devicetree/bindings/ata/cavium-compact-flash.txt b/Documentation/devicetree/bindings/ata/cavium-compact-flash.txt
index 93986a5..3bacc8e 100644
--- a/Documentation/devicetree/bindings/ata/cavium-compact-flash.txt
+++ b/Documentation/devicetree/bindings/ata/cavium-compact-flash.txt
@@ -9,7 +9,7 @@ Properties:
 
   Compatibility with many Cavium evaluation boards.
 
-- reg: The base address of the the CF chip select banks.  Depending on
+- reg: The base address of the CF chip select banks.  Depending on
   the device configuration, there may be one or two banks.
 
 - cavium,bus-width: The width of the connection to the CF devices.  Valid
diff --git a/Documentation/devicetree/bindings/c6x/dscr.txt b/Documentation/devicetree/bindings/c6x/dscr.txt
index b0e9714..9267223 100644
--- a/Documentation/devicetree/bindings/c6x/dscr.txt
+++ b/Documentation/devicetree/bindings/c6x/dscr.txt
@@ -12,7 +12,7 @@ configuration register for writes. These configuration register may be used to
 enable (and disable in some cases) SoC pin drivers, select peripheral clock
 sources (internal or pin), etc. In some cases, a configuration register is
 write once or the individual bits are write once. In addition to device config,
-the DSCR block may provide registers which which are used to reset peripherals,
+the DSCR block may provide registers which are used to reset peripherals,
 provide device ID information, provide ethernet MAC addresses, as well as other
 miscellaneous functions.
 
diff --git a/Documentation/devicetree/bindings/dma/renesas,rcar-dmac.txt b/Documentation/devicetree/bindings/dma/renesas,rcar-dmac.txt
index df0f48b..f7e21b1 100644
--- a/Documentation/devicetree/bindings/dma/renesas,rcar-dmac.txt
+++ b/Documentation/devicetree/bindings/dma/renesas,rcar-dmac.txt
@@ -1,6 +1,6 @@
 * Renesas R-Car DMA Controller Device Tree bindings
 
-Renesas R-Car Generation 2 SoCs have have multiple multi-channel DMA
+Renesas R-Car Generation 2 SoCs have multiple multi-channel DMA
 controller instances named DMAC capable of serving multiple clients. Channels
 can be dedicated to specific clients or shared between a large number of
 clients.
diff --git a/Documentation/devicetree/bindings/gpio/gpio-pcf857x.txt b/Documentation/devicetree/bindings/gpio/gpio-pcf857x.txt
index d63194a..ada4e29 100644
--- a/Documentation/devicetree/bindings/gpio/gpio-pcf857x.txt
+++ b/Documentation/devicetree/bindings/gpio/gpio-pcf857x.txt
@@ -39,7 +39,7 @@ Optional Properties:
   - lines-initial-states: Bitmask that specifies the initial state of each
   line. When a bit is set to zero, the corresponding line will be initialized to
   the input (pulled-up) state. When the  bit is set to one, the line will be
-  initialized the the low-level output state. If the property is not specified
+  initialized the low-level output state. If the property is not specified
   all lines will be initialized to the input state.
 
   The I/O expander can detect input state changes, and thus optionally act as
diff --git a/Documentation/devicetree/bindings/iio/adc/xilinx-xadc.txt b/Documentation/devicetree/bindings/iio/adc/xilinx-xadc.txt
index d9ee909..d71258e 100644
--- a/Documentation/devicetree/bindings/iio/adc/xilinx-xadc.txt
+++ b/Documentation/devicetree/bindings/iio/adc/xilinx-xadc.txt
@@ -59,7 +59,7 @@ Optional properties:
 	  Each child node represents one channel and has the following
 	  properties:
 		Required properties:
-			* reg: Pair of pins the the channel is connected to.
+			* reg: Pair of pins the channel is connected to.
 				0: VP/VN
 				1: VAUXP[0]/VAUXN[0]
 				2: VAUXP[1]/VAUXN[1]
diff --git a/Documentation/devicetree/bindings/mtd/fsmc-nand.txt b/Documentation/devicetree/bindings/mtd/fsmc-nand.txt
index ec42935..5235cbc 100644
--- a/Documentation/devicetree/bindings/mtd/fsmc-nand.txt
+++ b/Documentation/devicetree/bindings/mtd/fsmc-nand.txt
@@ -9,7 +9,7 @@ Required properties:
 Optional properties:
 - bank-width : Width (in bytes) of the device.  If not present, the width
   defaults to 1 byte
-- nand-skip-bbtscan: Indicates the the BBT scanning should be skipped
+- nand-skip-bbtscan: Indicates the BBT scanning should be skipped
 - timings: array of 6 bytes for NAND timings. The meanings of these bytes
   are:
   byte 0 TCLR  : CLE to RE delay in number of AHB clock cycles, only 4 bits
diff --git a/Documentation/devicetree/bindings/net/broadcom-systemport.txt b/Documentation/devicetree/bindings/net/broadcom-systemport.txt
index aa7ad62..877da34 100644
--- a/Documentation/devicetree/bindings/net/broadcom-systemport.txt
+++ b/Documentation/devicetree/bindings/net/broadcom-systemport.txt
@@ -3,7 +3,7 @@
 Required properties:
 - compatible: should be one of "brcm,systemport-v1.00" or "brcm,systemport"
 - reg: address and length of the register set for the device.
-- interrupts: interrupts for the device, first cell must be for the the rx
+- interrupts: interrupts for the device, first cell must be for the rx
   interrupts, and the second cell should be for the transmit queues. An
   optional third interrupt cell for Wake-on-LAN can be specified
 - local-mac-address: Ethernet MAC address (48 bits) of this adapter
diff --git a/Documentation/devicetree/bindings/power/rockchip-io-domain.txt b/Documentation/devicetree/bindings/power/rockchip-io-domain.txt
index 6fbf6e7..8b70db1 100644
--- a/Documentation/devicetree/bindings/power/rockchip-io-domain.txt
+++ b/Documentation/devicetree/bindings/power/rockchip-io-domain.txt
@@ -37,7 +37,7 @@ Required properties:
 
 
 You specify supplies using the standard regulator bindings by including
-a phandle the the relevant regulator.  All specified supplies must be able
+a phandle the relevant regulator.  All specified supplies must be able
 to report their voltage.  The IO Voltage Domain for any non-specified
 supplies will be not be touched.
 
diff --git a/Documentation/devicetree/overlay-notes.txt b/Documentation/devicetree/overlay-notes.txt
index 30ae758..d418a6c 100644
--- a/Documentation/devicetree/overlay-notes.txt
+++ b/Documentation/devicetree/overlay-notes.txt
@@ -10,7 +10,7 @@ How overlays work
 -----------------
 
 A Device Tree's overlay purpose is to modify the kernel's live tree, and
-have the modification affecting the state of the the kernel in a way that
+have the modification affecting the state of the kernel in a way that
 is reflecting the changes.
 Since the kernel mainly deals with devices, any new device node that result
 in an active device should have it created while if the device node is either
@@ -80,7 +80,7 @@ result in foo+bar.dts
 	};
 ---- foo+bar.dts -------------------------------------------------------------
 
-As a result of the the overlay, a new device node (bar) has been created
+As a result of the overlay, a new device node (bar) has been created
 so a bar platform device will be registered and if a matching device driver
 is loaded the device will be created as expected.
 
-- 
2.2.1.62.g3f15098

