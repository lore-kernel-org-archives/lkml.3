Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbbAPOEw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 09:04:52 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:49656 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbbAPOEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 09:04:50 -0500
From: Vishnu Patekar <vishnupatekar0510@gmail.com>
To: dmitry.torokhov@gmail.com, hdegoede@redhat.com,
        ijc+devicetree@hellion.org.uk, maxime.ripard@free-electrons.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, linux-input@vger.kernel.org,
        devicetree@vger.kernel.org,
        Vishnu Patekar <vishnupatekar0510@gmail.com>
Subject: [PATCH v4 1/5] sunxi:dts-bindings:input: bindings for A10/A20 ps2
Date: Fri, 16 Jan 2015 19:33:37 +0530
Message-Id: <1421417021-3247-2-git-send-email-vishnupatekar0510@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1421417021-3247-1-git-send-email-vishnupatekar0510@gmail.com>
References: <1421417021-3247-1-git-send-email-vishnupatekar0510@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: VishnuPatekar <vishnupatekar0510@gmail.com>
---
 .../bindings/serio/allwinner,sun4i-ps2.txt         |   23 ++++++++++++++++++++
 1 file changed, 23 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/serio/allwinner,sun4i-ps2.txt

diff --git a/Documentation/devicetree/bindings/serio/allwinner,sun4i-ps2.txt b/Documentation/devicetree/bindings/serio/allwinner,sun4i-ps2.txt
new file mode 100644
index 0000000..0c30440
--- /dev/null
+++ b/Documentation/devicetree/bindings/serio/allwinner,sun4i-ps2.txt
@@ -0,0 +1,23 @@
+* Device tree bindings for Allwinner A10, A20 PS2 host controller
+
+A20 PS2 is dual role controller(PS2 host and PS2 device). These bindings are
+for PS2 A10/A20 host controller. IBM compliant IBM PS2 and AT-compatible keyboard
+and mouse can be connected.
+
+Required properties:
+
+ - reg             : Offset and length of the register set for the device.
+ - compatible      : Should be as of the following:
+                     - "allwinner,sun4i-a10-ps2"
+ - interrupts      : The interrupt line connected to the PS2.
+ - clocks          : The gate clk connected to the PS2.
+
+
+Example:
+	ps20: ps2@0x01c2a000 {
+		compatible = "allwinner,sun4i-a10-ps2";
+		reg = <0x01c2a000 0x400>;
+		interrupts = <0 62 4>;
+		clocks = <&apb1_gates 6>;
+		status = "disabled";
+	};
-- 
1.7.9.5

