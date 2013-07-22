Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812Ab3GVPN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 11:13:59 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:47969 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756092Ab3GVPN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 11:13:56 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, trivial@kernel.org, rob@landley.net,
        linux-doc@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] doc: devicetree: bindings: Fix typo in bindings
Date: Tue, 23 Jul 2013 00:13:48 +0900
Message-Id: <1374506028-10564-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.3.3.820.ge3d4493
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in devicetree/bindings.

Singed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/devicetree/bindings/arm/ste-u300.txt    | 2 +-
 Documentation/devicetree/bindings/dma/atmel-dma.txt   | 4 ++--
 Documentation/devicetree/bindings/dma/fsl-imx-dma.txt | 2 +-
 Documentation/devicetree/bindings/dma/ste-dma40.txt   | 4 ++--
 Documentation/devicetree/bindings/mfd/cros-ec.txt     | 2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/ste-u300.txt b/Documentation/devicetree/bindings/arm/ste-u300.txt
index 69b5ab0..d11d800 100644
--- a/Documentation/devicetree/bindings/arm/ste-u300.txt
+++ b/Documentation/devicetree/bindings/arm/ste-u300.txt
@@ -22,7 +22,7 @@ This contains the board-specific information.
 - compatible: must be "stericsson,s365".
 - vana15-supply: the regulator supplying the 1.5V to drive the
   board.
-- syscon: a pointer to the syscon node so we can acccess the
+- syscon: a pointer to the syscon node so we can access the
   syscon registers to set the board as self-powered.
 
 Example:
diff --git a/Documentation/devicetree/bindings/dma/atmel-dma.txt b/Documentation/devicetree/bindings/dma/atmel-dma.txt
index c280a0e..e1f343c 100644
--- a/Documentation/devicetree/bindings/dma/atmel-dma.txt
+++ b/Documentation/devicetree/bindings/dma/atmel-dma.txt
@@ -18,14 +18,14 @@ dma0: dma@ffffec00 {
 
 DMA clients connected to the Atmel DMA controller must use the format
 described in the dma.txt file, using a three-cell specifier for each channel:
-a phandle plus two interger cells.
+a phandle plus two integer cells.
 The three cells in order are:
 
 1. A phandle pointing to the DMA controller.
 2. The memory interface (16 most significant bits), the peripheral interface
 (16 less significant bits).
 3. Parameters for the at91 DMA configuration register which are device
-dependant:
+dependent:
   - bit 7-0: peripheral identifier for the hardware handshaking interface. The
   identifier can be different for tx and rx.
   - bit 11-8: FIFO configuration. 0 for half FIFO, 1 for ALAP, 1 for ASAP.
diff --git a/Documentation/devicetree/bindings/dma/fsl-imx-dma.txt b/Documentation/devicetree/bindings/dma/fsl-imx-dma.txt
index 2717ecb..7bd8847 100644
--- a/Documentation/devicetree/bindings/dma/fsl-imx-dma.txt
+++ b/Documentation/devicetree/bindings/dma/fsl-imx-dma.txt
@@ -34,7 +34,7 @@ Clients have to specify the DMA requests with phandles in a list.
 Required properties:
 - dmas: List of one or more DMA request specifiers. One DMA request specifier
     consists of a phandle to the DMA controller followed by the integer
-    specifiying the request line.
+    specifying the request line.
 - dma-names: List of string identifiers for the DMA requests. For the correct
     names, have a look at the specific client driver.
 
diff --git a/Documentation/devicetree/bindings/dma/ste-dma40.txt b/Documentation/devicetree/bindings/dma/ste-dma40.txt
index bea5b73..a8c21c2 100644
--- a/Documentation/devicetree/bindings/dma/ste-dma40.txt
+++ b/Documentation/devicetree/bindings/dma/ste-dma40.txt
@@ -37,14 +37,14 @@ Each dmas request consists of 4 cells:
   1. A phandle pointing to the DMA controller
   2. Device Type
   3. The DMA request line number (only when 'use fixed channel' is set)
-  4. A 32bit mask specifying; mode, direction and endianess [NB: This list will grow]
+  4. A 32bit mask specifying; mode, direction and endianness [NB: This list will grow]
         0x00000001: Mode:
                 Logical channel when unset
                 Physical channel when set
         0x00000002: Direction:
                 Memory to Device when unset
                 Device to Memory when set
-        0x00000004: Endianess:
+        0x00000004: Endianness:
                 Little endian when unset
                 Big endian when set
         0x00000008: Use fixed channel:
diff --git a/Documentation/devicetree/bindings/mfd/cros-ec.txt b/Documentation/devicetree/bindings/mfd/cros-ec.txt
index e0e59c5..5f229c5 100644
--- a/Documentation/devicetree/bindings/mfd/cros-ec.txt
+++ b/Documentation/devicetree/bindings/mfd/cros-ec.txt
@@ -4,7 +4,7 @@ Google's ChromeOS EC is a Cortex-M device which talks to the AP and
 implements various function such as keyboard and battery charging.
 
 The EC can be connect through various means (I2C, SPI, LPC) and the
-compatible string used depends on the inteface. Each connection method has
+compatible string used depends on the interface. Each connection method has
 its own driver which connects to the top level interface-agnostic EC driver.
 Other Linux driver (such as cros-ec-keyb for the matrix keyboard) connect to
 the top-level driver.
-- 
1.8.3.3.820.ge3d4493

