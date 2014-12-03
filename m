Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbaLCWlK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 17:41:10 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:48741 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbaLCWlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 17:41:08 -0500
From: vishnupatekar <vishnupatekar0510@gmail.com>
X-Google-Original-From: vishnupatekar <VishnuPatekar0510@gmail.com>
To: maxime.ripard@free-electrons.com, galak@codeaurora.org,
        ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        vishnupatekar <VishnuPatekar0510@gmail.com>
Subject: [PATCH 1/3] dts-binding: input: sun7ips2: Device tree bindings for Allwinner sun7i A20 PS2 host controller
Date: Thu,  4 Dec 2014 04:10:41 +0530
Message-Id: <1417646441-27649-1-git-send-email-VishnuPatekar0510@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 .../bindings/input/allwinner,sun7i-a20-ps2.txt     |   22 ++++++++++++++++++++
 1 file changed, 22 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/input/allwinner,sun7i-a20-ps2.txt

diff --git a/Documentation/devicetree/bindings/input/allwinner,sun7i-a20-ps2.txt b/Documentation/devicetree/bindings/input/allwinner,sun7i-a20-ps2.txt
new file mode 100644
index 0000000..63b6214
--- /dev/null
+++ b/Documentation/devicetree/bindings/input/allwinner,sun7i-a20-ps2.txt
@@ -0,0 +1,22 @@
+* Device tree bindings for Allwinner A20 PS2 host controller
+
+A20 PS2 is dual role controller(PS2 host and PS2 device). These bindings are for PS2 host controller.
+IBM compliant IBM PS2 and AT-compatible keyboard and mouse can be connected.
+
+Required properties:
+
+ - reg             : Offset and length of the register set for the device.
+ - compatible      : Should one of the following:
+                     - "allwinner,sun7i-a20-ps2"
+ - interrupts      : The interrupt line connected to the P2WI peripheral.
+ - clocks          : The gate clk connected to the P2WI peripheral.
+
+
+Example:
+	ps20: ps2@0x01c2a000 {
+		compatible = "allwinner,sun7i-a20-ps2";
+		reg = <0x01c2a000 0x400>;
+		interrupts = <0 62 4>;
+		clocks = <&apb1_gates 6>;
+		status = "disabled";
+	};
-- 
1.7.9.5

