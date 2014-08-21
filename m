Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbaHUSTd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 14:19:33 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45499 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752972AbaHUST3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 14:19:29 -0400
From: Dan Murphy <dmurphy@ti.com>
To: <linux-input@vger.kernel.org>, <dmitry.torokhov@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH 1/2] doc: dt/bindings: input: introduce TI DRV2667 haptic driver description
Date: Thu, 21 Aug 2014 13:19:02 -0500
Message-ID: <1408645143-25690-2-git-send-email-dmurphy@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408645143-25690-1-git-send-email-dmurphy@ti.com>
References: <1408645143-25690-1-git-send-email-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DRV2667 is a haptic/vibrator driver for Linear Resonant Actuators.
Adding dt binding for this part

Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 .../devicetree/bindings/input/ti,drv2667.txt       |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/input/ti,drv2667.txt

diff --git a/Documentation/devicetree/bindings/input/ti,drv2667.txt b/Documentation/devicetree/bindings/input/ti,drv2667.txt
new file mode 100644
index 0000000..525216d
--- /dev/null
+++ b/Documentation/devicetree/bindings/input/ti,drv2667.txt
@@ -0,0 +1,18 @@
+Texas Instruments - drv2667 Haptics driver
+
+The drv2667 uses serial control bus communicates through I2C protocols
+
+Required properties:
+	- compatible - "ti,drv2667" - DRV2667
+	- reg -  I2C slave address
+	- vbat-supply - Required supply regulator
+
+Example:
+
+drv2667: drv2667@59 {
+		compatible = "ti,drv2667";
+		reg = <0x59>;
+};
+
+For more product information please see the link below:
+http://www.ti.com/product/drv2667
-- 
1.7.9.5

