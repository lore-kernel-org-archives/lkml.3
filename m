Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751246Ab3HTMfR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 08:35:17 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:35366 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab3HTMfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 08:35:15 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org, rob@landley.net
Cc: rdunlap@infradead.org, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] doc: devicetree: Fit typos in devicegree/bindings
Date: Tue, 20 Aug 2013 21:34:56 +0900
Message-Id: <1377002096-16088-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.4.rc3.2.g2c2b664
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typos in Documentations/devicetree/bindings

Signed-off-by: Masanari Iida <standby24x7@gmail.com>  

---
 Documentation/devicetree/bindings/gpio/mrvl-gpio.txt       | 2 +-
 Documentation/devicetree/bindings/mfd/s2mps11.txt          | 2 +-
 Documentation/devicetree/bindings/mmc/synopsis-dw-mshc.txt | 2 +-
 Documentation/devicetree/bindings/video/atmel,lcdc.txt     | 4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

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
index c9332c6..31f952f 100644
--- a/Documentation/devicetree/bindings/mfd/s2mps11.txt
+++ b/Documentation/devicetree/bindings/mfd/s2mps11.txt
@@ -41,7 +41,7 @@ sub-node should be of the format as listed below.
 
  regulator-ramp-delay for BUCKs = [6250/12500/25000(default)/50000] uV/us
 
- BUCK[2/3/4/6] supports disabling ramp delay on hardware, so explictly
+ BUCK[2/3/4/6] supports disabling ramp delay on hardware, so explicitly
  regulator-ramp-delay = <0> can be used for them to disable ramp delay.
  In absence of regulator-ramp-delay property, default ramp delay will be used.
 
diff --git a/Documentation/devicetree/bindings/mmc/synopsis-dw-mshc.txt b/Documentation/devicetree/bindings/mmc/synopsis-dw-mshc.txt
index cdcebea..5486655 100644
--- a/Documentation/devicetree/bindings/mmc/synopsis-dw-mshc.txt
+++ b/Documentation/devicetree/bindings/mmc/synopsis-dw-mshc.txt
@@ -16,7 +16,7 @@ Required Properties:
   each child-node representing a supported slot. There should be atleast one
   child node representing a card slot. The name of the child node representing
   the slot is recommended to be slot@n where n is the unique number of the slot
-  connnected to the controller. The following are optional properties which
+  connected to the controller. The following are optional properties which
   can be included in the slot child node.
 
 	* reg: specifies the physical slot number. The valid values of this
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
1.8.4.rc3.2.g2c2b664

