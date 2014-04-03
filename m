Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbaDCR7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 13:59:50 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:50818 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194AbaDCR7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 13:59:47 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>
Cc: Mike Looijmans <mike.looijmans@topic.nl>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Harini Katakam <harinik@xilinx.com>, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-i2c@vger.kernel.org,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>
Subject: [PATCH v4 1/3] i2c: cadence: Document device tree bindings
Date: Thu,  3 Apr 2014 10:59:25 -0700
Message-Id: <1396547967-19260-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.9.1.1.gbb9f595
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree binding documentation for the Cadence I2C controller.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---

Changes in v4:
 - moved adding DT docs into this dedicated patch

Changes in v3: None
Changes in v2: None

---
 .../devicetree/bindings/i2c/i2c-cadence.txt         | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-cadence.txt

diff --git a/Documentation/devicetree/bindings/i2c/i2c-cadence.txt b/Documentation/devicetree/bindings/i2c/i2c-cadence.txt
new file mode 100644
index 000000000000..685adf513111
--- /dev/null
+++ b/Documentation/devicetree/bindings/i2c/i2c-cadence.txt
@@ -0,0 +1,21 @@
+Binding for the Cadence I2C controller
+
+Required properties:
+  compatible: Compatibility string. Must be 'cdns,i2c-r1p10'.
+  clocks: From common clock bindings. Phandle to input clock.
+
+Optional properties:
+  clock-frequency: Desired operating frequency, in Hz, of the bus (actual may
+		   be lower). Defaults to 400000 if not specified.
+
+Example:
+
+	i2c@e0004000 {
+		compatible = "cdns,i2c-r1p10";
+		clocks = <&clkc 38>;
+		interrupts = <0 25 4>;
+		reg = <0xE0004000 0x1000>;
+		clock-frequency = <400000>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+	};
-- 
1.9.1.1.gbb9f595

