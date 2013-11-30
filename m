Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab3K3OMe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 09:12:34 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:60952 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab3K3OMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 09:12:31 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, trivial@kernel.org, rob@landley.net,
        rdunlap@infradead.org, levex@linux.com
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH/V2] [trivial] doc: Fix typo in Documentation/devicetree
Date: Sat, 30 Nov 2013 23:10:29 +0900
Message-Id: <1385820629-27908-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.5.rc1.28.g7061504
In-Reply-To: <1385817454-19505-1-git-send-email-standby24x7@gmail.com>
References: <1385817454-19505-1-git-send-email-standby24x7@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in Documentation/devicetree

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/devicetree/bindings/arm/omap/timer.txt        | 2 +-
 Documentation/devicetree/bindings/bus/mvebu-mbus.txt        | 2 +-
 Documentation/devicetree/bindings/crypto/fsl-sec6.txt       | 2 +-
 Documentation/devicetree/bindings/gpio/mrvl-gpio.txt        | 2 +-
 Documentation/devicetree/bindings/mfd/s2mps11.txt           | 2 +-
 Documentation/devicetree/bindings/mmc/samsung-sdhci.txt     | 2 +-
 Documentation/devicetree/bindings/mmc/synopsys-dw-mshc.txt  | 2 +-
 Documentation/devicetree/bindings/phy/phy-bindings.txt      | 2 +-
 Documentation/devicetree/bindings/spi/spi-bus.txt           | 2 +-
 Documentation/devicetree/bindings/timer/lsi,zevio-timer.txt | 2 +-
 Documentation/devicetree/bindings/video/atmel,lcdc.txt      | 4 ++--
 11 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/omap/timer.txt b/Documentation/devicetree/bindings/arm/omap/timer.txt
index d02e27c..8cda976 100644
--- a/Documentation/devicetree/bindings/arm/omap/timer.txt
+++ b/Documentation/devicetree/bindings/arm/omap/timer.txt
@@ -25,7 +25,7 @@ Required properties:
 			HW spec.
 
 Optional properties:
-- ti,timer-alwon:	Indicates the timer is in an alway-on power domain.
+- ti,timer-alwon:	Indicates the timer is in an always-on power domain.
 - ti,timer-dsp:		Indicates the timer can interrupt the on-chip DSP in
 			addition to the ARM CPU.
 - ti,timer-pwm: 	Indicates the timer can generate a PWM output.
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
diff --git a/Documentation/devicetree/bindings/crypto/fsl-sec6.txt b/Documentation/devicetree/bindings/crypto/fsl-sec6.txt
index c0a20cd..baf8a3c 100644
--- a/Documentation/devicetree/bindings/crypto/fsl-sec6.txt
+++ b/Documentation/devicetree/bindings/crypto/fsl-sec6.txt
@@ -1,5 +1,5 @@
 SEC 6 is as Freescale's Cryptographic Accelerator and Assurance Module (CAAM).
-Currently Freescale powerpc chip C29X is embeded with SEC 6.
+Currently Freescale powerpc chip C29X is embedded with SEC 6.
 SEC 6 device tree binding include:
    -SEC 6 Node
    -Job Ring Node
diff --git a/Documentation/devicetree/bindings/gpio/mrvl-gpio.txt b/Documentation/devicetree/bindings/gpio/mrvl-gpio.txt
index 6641626..99daf57 100644
--- a/Documentation/devicetree/bindings/gpio/mrvl-gpio.txt
+++ b/Documentation/devicetree/bindings/gpio/mrvl-gpio.txt
@@ -12,7 +12,7 @@ Required properties:
   gpio_mux.
 - interrupt-names : Should be the names of irq resources. Each interrupt
   uses its own interrupt name, so there should be as many interrupt names
-  as referenced interrups.
+  as referenced interrupts.
 - interrupt-controller : Identifies the node as an interrupt controller.
 - #interrupt-cells: Specifies the number of cells needed to encode an
   interrupt source.
diff --git a/Documentation/devicetree/bindings/mfd/s2mps11.txt b/Documentation/devicetree/bindings/mfd/s2mps11.txt
index 78a840d..2234c8c 100644
--- a/Documentation/devicetree/bindings/mfd/s2mps11.txt
+++ b/Documentation/devicetree/bindings/mfd/s2mps11.txt
@@ -41,7 +41,7 @@ sub-node should be of the format as listed below.
 
  regulator-ramp-delay for BUCKs = [6250/12500/25000(default)/50000] uV/us
 
- BUCK[2/3/4/6] supports disabling ramp delay on hardware, so explictly
+ BUCK[2/3/4/6] supports disabling ramp delay on hardware, so explicitly
  regulator-ramp-delay = <0> can be used for them to disable ramp delay.
  In the absence of the regulator-ramp-delay property, the default ramp
  delay will be used.
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
diff --git a/Documentation/devicetree/bindings/mmc/synopsys-dw-mshc.txt b/Documentation/devicetree/bindings/mmc/synopsys-dw-mshc.txt
index 8f3f133..35c09e6 100644
--- a/Documentation/devicetree/bindings/mmc/synopsys-dw-mshc.txt
+++ b/Documentation/devicetree/bindings/mmc/synopsys-dw-mshc.txt
@@ -16,7 +16,7 @@ Required Properties:
   each child-node representing a supported slot. There should be atleast one
   child node representing a card slot. The name of the child node representing
   the slot is recommended to be slot@n where n is the unique number of the slot
-  connnected to the controller. The following are optional properties which
+  connected to the controller. The following are optional properties which
   can be included in the slot child node.
 
 	* reg: specifies the physical slot number. The valid values of this
diff --git a/Documentation/devicetree/bindings/phy/phy-bindings.txt b/Documentation/devicetree/bindings/phy/phy-bindings.txt
index 8ae844f..7db7d46 100644
--- a/Documentation/devicetree/bindings/phy/phy-bindings.txt
+++ b/Documentation/devicetree/bindings/phy/phy-bindings.txt
@@ -23,7 +23,7 @@ phys: phy {
 };
 
 That node describes an IP block (PHY provider) that implements 2 different PHYs.
-In order to differentiate between these 2 PHYs, an additonal specifier should be
+In order to differentiate between these 2 PHYs, an additional specifier should be
 given while trying to get a reference to it.
 
 PHY user node
diff --git a/Documentation/devicetree/bindings/spi/spi-bus.txt b/Documentation/devicetree/bindings/spi/spi-bus.txt
index 800dafe..4b9cf5c 100644
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
diff --git a/Documentation/devicetree/bindings/timer/lsi,zevio-timer.txt b/Documentation/devicetree/bindings/timer/lsi,zevio-timer.txt
index b2d07ad..201e0c3 100644
--- a/Documentation/devicetree/bindings/timer/lsi,zevio-timer.txt
+++ b/Documentation/devicetree/bindings/timer/lsi,zevio-timer.txt
@@ -9,7 +9,7 @@ Required properties:
 Optional properties:
 
 - interrupts : The interrupt number of the first timer.
-- reg : The interrupt acknowledgement registers
+- reg : The interrupt acknowledgment registers
 	(always after timer base address)
 
 If any of the optional properties are not given, the timer is added as a
diff --git a/Documentation/devicetree/bindings/video/atmel,lcdc.txt b/Documentation/devicetree/bindings/video/atmel,lcdc.txt
index 1ec175e..47981dd 100644
--- a/Documentation/devicetree/bindings/video/atmel,lcdc.txt
+++ b/Documentation/devicetree/bindings/video/atmel,lcdc.txt
@@ -39,8 +39,8 @@ Atmel LCDC Display
 -----------------------------------------------------
 Required properties (as per of_videomode_helper):
 
- - atmel,dmacon: dma controler configuration
- - atmel,lcdcon2: lcd controler configuration
+ - atmel,dmacon: dma controller configuration
+ - atmel,lcdcon2: lcd controller configuration
  - atmel,guard-time: lcd guard time (Delay in frame periods)
  - bits-per-pixel: lcd panel bit-depth.
 
-- 
1.8.5.rc1.28.g7061504

