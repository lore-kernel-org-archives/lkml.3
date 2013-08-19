Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751465Ab3HSLaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 07:30:18 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:40868 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab3HSLaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 07:30:15 -0400
From: Oleksandr Kozaruk <oleksandr.kozaruk@ti.com>
To: grant.likely@linaro.org, rob.herring@calxeda.com, rob@landley.net,
        mark.rutland@arm.com
Cc: linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] iio: adc: Add bindigs documentation for twl6030 GPADC
Date: Mon, 19 Aug 2013 14:29:25 +0300
Message-Id: <1376911765-7821-1-git-send-email-oleksandr.kozaruk@ti.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add required documentation for twl6030 GPADC device tree
bindings.

Signed-off-by: Oleksandr Kozaruk <oleksandr.kozaruk@ti.com>
---
 .../devicetree/bindings/iio/adc/twl6030-gpadc.txt  | 45 ++++++++++++++++++++++
 1 file changed, 45 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/iio/adc/twl6030-gpadc.txt

diff --git a/Documentation/devicetree/bindings/iio/adc/twl6030-gpadc.txt b/Documentation/devicetree/bindings/iio/adc/twl6030-gpadc.txt
new file mode 100644
index 0000000..6cd3ef3
--- /dev/null
+++ b/Documentation/devicetree/bindings/iio/adc/twl6030-gpadc.txt
@@ -0,0 +1,45 @@
+Texas Instruments twl6030/twl6032 GPADC device driver
+
+Required properties:
+	- compatible: must be "ti,twl6030-gpadc" for TWL6030 or
+	  "ti,twl6032-gpadc" for TWL6032
+	- interrupts: interrupt number associated with it
+	- #io-channel-cells: must be <1> - multiple IIO outputs are present
+	  iio consumers can use following io-channels:
+		twl6030:
+			0 - battery type
+			1 - battery temperature resistor value
+			2 - audio accessory/general purpose
+			3 - general purpose
+			4 - temperature/general purpose
+			5 - general purpose
+			6 - general purpose
+			7 - main battery
+			8 - backup battery
+			9 - charger input
+			10 - VBUS
+			11 - VBUS charging current
+			14 - USB ID
+		twl6032:
+			0 - battery type
+			1 - battery temperature resistor value
+			2 - audio accessory/general purpose
+			3 - temperature with external diode/general purpose
+			4 - temperature/general purpose
+			5 - general purpose
+			6 - general purpose
+			7 - system supply
+			8 - backup battery
+			9 - charger input
+			10 - VBUS
+			11 - VBUS charging current
+			14 - USB ID
+			17 - battery charging current
+			18 - battery voltage
+
+Example:
+	adc {
+		compatible = "ti,twl6030-gpadc";
+		interrupts = <3>;
+		#io-channel-cells = <1>;
+	};
-- 
1.8.1.2

