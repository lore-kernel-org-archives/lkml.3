Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936078Ab3DJNd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 09:33:57 -0400
Received: from mail-da0-f54.google.com ([209.85.210.54]:50148 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659Ab3DJNdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 09:33:54 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linux-kernel@vger.kernel.org
Cc: james.hogan@imgtec.com, trivial@kernel.org,
        Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial]documentation:devicetree: Fix various typo in devicetree 
Date: Wed, 10 Apr 2013 22:33:46 +0900
Message-Id: <1365600826-19773-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.2.451.gbfd70c5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix spelling typos in Documentation/devicetree/bindings.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/devicetree/bindings/i2c/i2c-s3c2410.txt             | 2 +-
 Documentation/devicetree/bindings/leds/tca6507.txt                | 2 +-
 Documentation/devicetree/bindings/metag/meta-intc.txt             | 2 +-
 Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt  | 2 +-
 Documentation/devicetree/bindings/pinctrl/brcm,bcm2835-gpio.txt   | 2 +-
 Documentation/devicetree/bindings/power_supply/qnap-poweroff.txt  | 2 +-
 Documentation/devicetree/bindings/regulator/max8997-regulator.txt | 2 +-
 Documentation/devicetree/bindings/usb/samsung-usbphy.txt          | 2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/i2c/i2c-s3c2410.txt b/Documentation/devicetree/bindings/i2c/i2c-s3c2410.txt
index f98d4c5..296eb45 100644
--- a/Documentation/devicetree/bindings/i2c/i2c-s3c2410.txt
+++ b/Documentation/devicetree/bindings/i2c/i2c-s3c2410.txt
@@ -26,7 +26,7 @@ Required for all cases except "samsung,s3c2440-hdmiphy-i2c":
     - pinctrl-names: Should contain only one value - "default".
 
 Optional properties:
-  - samsung,i2c-slave-addr: Slave address in multi-master enviroment. If not
+  - samsung,i2c-slave-addr: Slave address in multi-master environment. If not
     specified, default value is 0.
   - samsung,i2c-max-bus-freq: Desired frequency in Hz of the bus. If not
     specified, the default value in Hz is 100000.
diff --git a/Documentation/devicetree/bindings/leds/tca6507.txt b/Documentation/devicetree/bindings/leds/tca6507.txt
index 2b6693b..80ff3df 100644
--- a/Documentation/devicetree/bindings/leds/tca6507.txt
+++ b/Documentation/devicetree/bindings/leds/tca6507.txt
@@ -1,4 +1,4 @@
-LEDs conected to tca6507
+LEDs connected to tca6507
 
 Required properties:
 - compatible : should be : "ti,tca6507".
diff --git a/Documentation/devicetree/bindings/metag/meta-intc.txt b/Documentation/devicetree/bindings/metag/meta-intc.txt
index 8c47dcb..80994ad 100644
--- a/Documentation/devicetree/bindings/metag/meta-intc.txt
+++ b/Documentation/devicetree/bindings/metag/meta-intc.txt
@@ -12,7 +12,7 @@ Required properties:
       handle 32 interrupt sources).
 
     - interrupt-controller: The presence of this property identifies the node
-      as an interupt controller. No property value shall be defined.
+      as an interrupt controller. No property value shall be defined.
 
     - #interrupt-cells: Specifies the number of cells needed to encode an
       interrupt source. The type shall be a <u32> and the value shall be 2.
diff --git a/Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt
index bc50899..648d60e 100644
--- a/Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt
@@ -1,6 +1,6 @@
 * Atmel AT91 Pinmux Controller
 
-The AT91 Pinmux Controler, enables the IC
+The AT91 Pinmux Controller, enables the IC
 to share one PAD to several functional blocks. The sharing is done by
 multiplexing the PAD input/output signals. For each PAD there are up to
 8 muxing options (called periph modes). Since different modules require
diff --git a/Documentation/devicetree/bindings/pinctrl/brcm,bcm2835-gpio.txt b/Documentation/devicetree/bindings/pinctrl/brcm,bcm2835-gpio.txt
index 8edc20e..2569866 100644
--- a/Documentation/devicetree/bindings/pinctrl/brcm,bcm2835-gpio.txt
+++ b/Documentation/devicetree/bindings/pinctrl/brcm,bcm2835-gpio.txt
@@ -5,7 +5,7 @@ controller, and pinmux/control device.
 
 Required properties:
 - compatible: "brcm,bcm2835-gpio"
-- reg: Should contain the physical address of the GPIO module's registes.
+- reg: Should contain the physical address of the GPIO module's registers.
 - gpio-controller: Marks the device node as a GPIO controller.
 - #gpio-cells : Should be two. The first cell is the pin number and the
   second cell is used to specify optional parameters:
diff --git a/Documentation/devicetree/bindings/power_supply/qnap-poweroff.txt b/Documentation/devicetree/bindings/power_supply/qnap-poweroff.txt
index 9a599d2..0347d83 100644
--- a/Documentation/devicetree/bindings/power_supply/qnap-poweroff.txt
+++ b/Documentation/devicetree/bindings/power_supply/qnap-poweroff.txt
@@ -2,7 +2,7 @@
 
 QNAP NAS devices have a microcontroller controlling the main power
 supply. This microcontroller is connected to UART1 of the Kirkwood and
-Orion5x SoCs. Sending the charactor 'A', at 19200 baud, tells the
+Orion5x SoCs. Sending the character 'A', at 19200 baud, tells the
 microcontroller to turn the power off. This driver adds a handler to
 pm_power_off which is called to turn the power off.
 
diff --git a/Documentation/devicetree/bindings/regulator/max8997-regulator.txt b/Documentation/devicetree/bindings/regulator/max8997-regulator.txt
index 9fd69a1..9e5e51d 100644
--- a/Documentation/devicetree/bindings/regulator/max8997-regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/max8997-regulator.txt
@@ -28,7 +28,7 @@ Required properties:
     safe operating voltage).
 
     If either of the 'max8997,pmic-buck[1/2/5]-uses-gpio-dvs' optional
-    property is specified, then all the eigth voltage values for the
+    property is specified, then all the eight voltage values for the
     'max8997,pmic-buck[1/2/5]-dvs-voltage' should be specified.
 
 Optional properties:
diff --git a/Documentation/devicetree/bindings/usb/samsung-usbphy.txt b/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
index 0331949..adddcf4 100644
--- a/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
+++ b/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
@@ -4,7 +4,7 @@ The Samsung's phy transceiver is used for controlling usb phy for
 s3c-hsotg as well as ehci-s5p and ohci-exynos usb controllers
 across Samsung SOCs.
 TODO: Adding the PHY binding with controller(s) according to the under
-developement generic PHY driver.
+development generic PHY driver.
 
 Required properties:
 
-- 
1.8.2.451.gbfd70c5

