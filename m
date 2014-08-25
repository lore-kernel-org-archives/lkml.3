Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932960AbaHYP1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 11:27:21 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60644 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755906AbaHYP1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 11:27:19 -0400
From: Dan Murphy <dmurphy@ti.com>
To: <devicetree@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <dmitry.torokhov@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <sergei.shtylyov@cogentembedded.com>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH v2 1/2] doc: dt/bindings: input: introduce TI DRV2667 haptic driver description
Date: Mon, 25 Aug 2014 10:26:51 -0500
Message-ID: <1408980413-8763-1-git-send-email-dmurphy@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DRV2667 is a haptic/vibrator driver for Linear Resonant Actuators.
Adding dt binding for this part

Signed-off-by: Dan Murphy <dmurphy@ti.com>
---

v2 - Removed extra tabs, changed node to function not device
added vbat-supply, and removed confusing description - https://patchwork.kernel.org/patch/4759381/

 .../devicetree/bindings/input/ti,drv2667.txt       |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/input/ti,drv2667.txt

diff --git a/Documentation/devicetree/bindings/input/ti,drv2667.txt b/Documentation/devicetree/bindings/input/ti,drv2667.txt
new file mode 100644
index 0000000..996382c
--- /dev/null
+++ b/Documentation/devicetree/bindings/input/ti,drv2667.txt
@@ -0,0 +1,17 @@
+* Texas Instruments - drv2667 Haptics driver
+
+Required properties:
+	- compatible - "ti,drv2667" - DRV2667
+	- reg -  I2C slave address
+	- vbat-supply - Required supply regulator
+
+Example:
+
+haptics: haptics@59 {
+	compatible = "ti,drv2667";
+	reg = <0x59>;
+	vbat-supply = <&vbat>;
+};
+
+For more product information please see the link below:
+http://www.ti.com/product/drv2667
-- 
1.7.9.5

