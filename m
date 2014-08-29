Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbaH2NwD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 09:52:03 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48979 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752574AbaH2NwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 09:52:00 -0400
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, thomas.petazzoni@free-electrons.com
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] Documentation: bindings: net: add the Marvell Berlin Ethernet controller
Date: Fri, 29 Aug 2014 15:51:00 +0200
Message-Id: <1409320263-10295-3-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409320263-10295-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1409320263-10295-1-git-send-email-antoine.tenart@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the binding documentation for the Marvell Berlin Ethernet
controller.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 .../devicetree/bindings/net/marvell-berlin.txt     | 23 ++++++++++++++++++++++
 1 file changed, 23 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/marvell-berlin.txt

diff --git a/Documentation/devicetree/bindings/net/marvell-berlin.txt b/Documentation/devicetree/bindings/net/marvell-berlin.txt
new file mode 100644
index 000000000000..0ae468aef13f
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/marvell-berlin.txt
@@ -0,0 +1,23 @@
+* Marvell Berlin Ethernet Controller
+
+Required properties:
+- compatible: should be "marvell,berlin-eth".
+- reg: address and length of the register set for the device.
+- interrupts: interrupt for the device.
+- phy-handle: pointer to the Ethernet PHY.
+- clocks: pointer to the clock for the device.
+
+Optional properties:
+- local-mac-address: see ethernet.txt file in the same directory.
+
+
+Example:
+
+	eth0: ethernet@f7b90000 {
+		compatible = "marvell,berlin-eth";
+        	reg = <0xf7b90000 0x10000>;
+		clocks = <&chip CLKID_GETH0>;
+		interrupts = <GIC_SPI 24 IRQ_TYPE_LEVEL_HIGH>;
+		phy-handle = <&ethphy0>;
+		local-mac-address = [00 00 00 00 00 00];
+	};
-- 
1.9.1

