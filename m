Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab3ANGPJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 01:15:09 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:33184 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab3ANGPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 01:15:07 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: grant.likely@secretlab.ca, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org, rob@landley.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] documentation: devicetree: Fix typo within Documentation/devicetree
Date: Mon, 14 Jan 2013 15:14:56 +0900
Message-Id: <1358144096-24678-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.1.336.g94702dd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typos within Documentation/devicetree

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/devicetree/bindings/arm/atmel-aic.txt                | 2 +-
 Documentation/devicetree/bindings/arm/exynos/power_domain.txt      | 2 +-
 Documentation/devicetree/bindings/arm/gic.txt                      | 4 ++--
 Documentation/devicetree/bindings/arm/omap/omap.txt                | 6 +++---
 Documentation/devicetree/bindings/i2c/samsung-i2c.txt              | 2 +-
 Documentation/devicetree/bindings/mips/cavium/dma-engine.txt       | 2 +-
 Documentation/devicetree/bindings/mmc/exynos-dw-mshc.txt           | 6 +++---
 Documentation/devicetree/bindings/mmc/samsung-sdhci.txt            | 2 +-
 Documentation/devicetree/bindings/powerpc/fsl/srio.txt             | 4 ++--
 Documentation/devicetree/bindings/regulator/tps62360-regulator.txt | 4 ++--
 Documentation/devicetree/bindings/rtc/s3c-rtc.txt                  | 2 +-
 Documentation/devicetree/bindings/watchdog/samsung-wdt.txt         | 2 +-
 12 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/atmel-aic.txt b/Documentation/devicetree/bindings/arm/atmel-aic.txt
index 19078bf..ad03121 100644
--- a/Documentation/devicetree/bindings/arm/atmel-aic.txt
+++ b/Documentation/devicetree/bindings/arm/atmel-aic.txt
@@ -4,7 +4,7 @@ Required properties:
 - compatible: Should be "atmel,<chip>-aic"
 - interrupt-controller: Identifies the node as an interrupt controller.
 - interrupt-parent: For single AIC system, it is an empty property.
-- #interrupt-cells: The number of cells to define the interrupts. It sould be 3.
+- #interrupt-cells: The number of cells to define the interrupts. It should be 3.
   The first cell is the IRQ number (aka "Peripheral IDentifier" on datasheet).
   The second cell is used to specify flags:
     bits[3:0] trigger type and level flags:
diff --git a/Documentation/devicetree/bindings/arm/exynos/power_domain.txt b/Documentation/devicetree/bindings/arm/exynos/power_domain.txt
index 6528e21..3fb457b 100644
--- a/Documentation/devicetree/bindings/arm/exynos/power_domain.txt
+++ b/Documentation/devicetree/bindings/arm/exynos/power_domain.txt
@@ -4,7 +4,7 @@ Exynos processors include support for multiple power domains which are used
 to gate power to one or more peripherals on the processor.
 
 Required Properties:
-- compatiable: should be one of the following.
+- compatible: should be one of the following.
     * samsung,exynos4210-pd - for exynos4210 type power domain.
 - reg: physical base address of the controller and length of memory mapped
     region.
diff --git a/Documentation/devicetree/bindings/arm/gic.txt b/Documentation/devicetree/bindings/arm/gic.txt
index 62eb8df..3dfb0c0 100644
--- a/Documentation/devicetree/bindings/arm/gic.txt
+++ b/Documentation/devicetree/bindings/arm/gic.txt
@@ -42,7 +42,7 @@ Main node required properties:
 
 Optional
 - interrupts	: Interrupt source of the parent interrupt controller on
-  secondary GICs, or VGIC maintainance interrupt on primary GIC (see
+  secondary GICs, or VGIC maintenance interrupt on primary GIC (see
   below).
 
 - cpu-offset	: per-cpu offset within the distributor and cpu interface
@@ -74,7 +74,7 @@ Required properties:
   virtual interface control register base and size. The 2nd additional
   region is the GIC virtual cpu interface register base and size.
 
-- interrupts : VGIC maintainance interrupt.
+- interrupts : VGIC maintenance interrupt.
 
 Example:
 
diff --git a/Documentation/devicetree/bindings/arm/omap/omap.txt b/Documentation/devicetree/bindings/arm/omap/omap.txt
index d0051a7..f8288ea 100644
--- a/Documentation/devicetree/bindings/arm/omap/omap.txt
+++ b/Documentation/devicetree/bindings/arm/omap/omap.txt
@@ -39,16 +39,16 @@ Boards:
 - OMAP3 Tobi with Overo : Commercial expansion board with daughter board
   compatible = "ti,omap3-tobi", "ti,omap3-overo", "ti,omap3"
 
-- OMAP4 SDP : Software Developement Board
+- OMAP4 SDP : Software Development Board
   compatible = "ti,omap4-sdp", "ti,omap4430"
 
 - OMAP4 PandaBoard : Low cost community board
   compatible = "ti,omap4-panda", "ti,omap4430"
 
-- OMAP3 EVM : Software Developement Board for OMAP35x, AM/DM37x
+- OMAP3 EVM : Software Development Board for OMAP35x, AM/DM37x
   compatible = "ti,omap3-evm", "ti,omap3"
 
-- AM335X EVM : Software Developement Board for AM335x
+- AM335X EVM : Software Development Board for AM335x
   compatible = "ti,am335x-evm", "ti,am33xx", "ti,omap3"
 
 - AM335X Bone : Low cost community board
diff --git a/Documentation/devicetree/bindings/i2c/samsung-i2c.txt b/Documentation/devicetree/bindings/i2c/samsung-i2c.txt
index b6cb5a1..ccdf9c9 100644
--- a/Documentation/devicetree/bindings/i2c/samsung-i2c.txt
+++ b/Documentation/devicetree/bindings/i2c/samsung-i2c.txt
@@ -18,7 +18,7 @@ Optional properties:
     The gpio specifier depends on the gpio controller. Required in all
     cases except for "samsung,s3c2440-hdmiphy-i2c" whose input/output
     lines are permanently wired to the respective client
-  - samsung,i2c-slave-addr: Slave address in multi-master enviroment. If not
+  - samsung,i2c-slave-addr: Slave address in multi-master environment. If not
     specified, default value is 0.
   - samsung,i2c-max-bus-freq: Desired frequency in Hz of the bus. If not
     specified, the default value in Hz is 100000.
diff --git a/Documentation/devicetree/bindings/mips/cavium/dma-engine.txt b/Documentation/devicetree/bindings/mips/cavium/dma-engine.txt
index cb4291e..a5bdff4 100644
--- a/Documentation/devicetree/bindings/mips/cavium/dma-engine.txt
+++ b/Documentation/devicetree/bindings/mips/cavium/dma-engine.txt
@@ -1,7 +1,7 @@
 * DMA Engine.
 
 The Octeon DMA Engine transfers between the Boot Bus and main memory.
-The DMA Engine will be refered to by phandle by any device that is
+The DMA Engine will be referred to by phandle by any device that is
 connected to it.
 
 Properties:
diff --git a/Documentation/devicetree/bindings/mmc/exynos-dw-mshc.txt b/Documentation/devicetree/bindings/mmc/exynos-dw-mshc.txt
index 7927689..898b222 100644
--- a/Documentation/devicetree/bindings/mmc/exynos-dw-mshc.txt
+++ b/Documentation/devicetree/bindings/mmc/exynos-dw-mshc.txt
@@ -11,11 +11,11 @@ Required Properties:
 
 * compatible: should be
 	- "samsung,exynos4210-dw-mshc": for controllers with Samsung Exynos4210
-	  specific extentions.
+	  specific extensions.
 	- "samsung,exynos4412-dw-mshc": for controllers with Samsung Exynos4412
-	  specific extentions.
+	  specific extensions.
 	- "samsung,exynos5250-dw-mshc": for controllers with Samsung Exynos5250
-	  specific extentions.
+	  specific extensions.
 
 * samsung,dw-mshc-ciu-div: Specifies the divider value for the card interface
   unit (ciu) clock. This property is applicable only for Exynos5 SoC's and
diff --git a/Documentation/devicetree/bindings/mmc/samsung-sdhci.txt b/Documentation/devicetree/bindings/mmc/samsung-sdhci.txt
index 630a7d7..43acfdf 100644
--- a/Documentation/devicetree/bindings/mmc/samsung-sdhci.txt
+++ b/Documentation/devicetree/bindings/mmc/samsung-sdhci.txt
@@ -49,5 +49,5 @@ Example:
 	};
 
 	Note: This example shows both SoC specific and board specific properties
-	in a single device node. The properties can be actually be seperated
+	in a single device node. The properties can be actually be separated
 	into SoC specific node and board specific node.
diff --git a/Documentation/devicetree/bindings/powerpc/fsl/srio.txt b/Documentation/devicetree/bindings/powerpc/fsl/srio.txt
index b039bcb..07abf0f 100644
--- a/Documentation/devicetree/bindings/powerpc/fsl/srio.txt
+++ b/Documentation/devicetree/bindings/powerpc/fsl/srio.txt
@@ -8,9 +8,9 @@ Properties:
 	Definition: Must include "fsl,srio" for IP blocks with IP Block
 	Revision Register (SRIO IPBRR1) Major ID equal to 0x01c0.
 
-	Optionally, a compatiable string of "fsl,srio-vX.Y" where X is Major
+	Optionally, a compatible string of "fsl,srio-vX.Y" where X is Major
 	version in IP Block Revision Register and Y is Minor version.  If this
-	compatiable is provided it should be ordered before "fsl,srio".
+	compatible is provided it should be ordered before "fsl,srio".
 
    - reg
 	Usage: required
diff --git a/Documentation/devicetree/bindings/regulator/tps62360-regulator.txt b/Documentation/devicetree/bindings/regulator/tps62360-regulator.txt
index c8ca6b8..1b20c3d 100644
--- a/Documentation/devicetree/bindings/regulator/tps62360-regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/tps62360-regulator.txt
@@ -17,9 +17,9 @@ Optional properties:
 - ti,vsel1-gpio: Gpio for controlling VSEL1 line.
   If this property is missing, then assume that there is no GPIO
   for vsel1 control.
-- ti,vsel0-state-high: Inital state of vsel0 input is high.
+- ti,vsel0-state-high: Initial state of vsel0 input is high.
   If this property is missing, then assume the state as low (0).
-- ti,vsel1-state-high: Inital state of vsel1 input is high.
+- ti,vsel1-state-high: Initial state of vsel1 input is high.
   If this property is missing, then assume the state as low (0).
 
 Any property defined as part of the core regulator binding, defined in
diff --git a/Documentation/devicetree/bindings/rtc/s3c-rtc.txt b/Documentation/devicetree/bindings/rtc/s3c-rtc.txt
index 90ec45f..7ac7259 100644
--- a/Documentation/devicetree/bindings/rtc/s3c-rtc.txt
+++ b/Documentation/devicetree/bindings/rtc/s3c-rtc.txt
@@ -7,7 +7,7 @@ Required properties:
 - reg: physical base address of the controller and length of memory mapped
   region.
 - interrupts: Two interrupt numbers to the cpu should be specified. First
-  interrupt number is the rtc alarm interupt and second interrupt number
+  interrupt number is the rtc alarm interrupt and second interrupt number
   is the rtc tick interrupt. The number of cells representing a interrupt
   depends on the parent interrupt controller.
 
diff --git a/Documentation/devicetree/bindings/watchdog/samsung-wdt.txt b/Documentation/devicetree/bindings/watchdog/samsung-wdt.txt
index 79ead82..ce0d8e7 100644
--- a/Documentation/devicetree/bindings/watchdog/samsung-wdt.txt
+++ b/Documentation/devicetree/bindings/watchdog/samsung-wdt.txt
@@ -2,7 +2,7 @@
 
 The Samsung's Watchdog controller is used for resuming system operation
 after a preset amount of time during which the WDT reset event has not
-occured.
+occurred.
 
 Required properties:
 - compatible : should be "samsung,s3c2410-wdt"
-- 
1.8.1.336.g94702dd

