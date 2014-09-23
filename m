Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbaIWMPn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 08:15:43 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57118 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753971AbaIWMPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 08:15:42 -0400
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 3/9] Documentation: bindings: net: add the Marvell PXA168 Ethernet controller
Date: Tue, 23 Sep 2014 14:15:30 +0200
Message-Id: <1411474536-22626-4-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411474536-22626-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1411474536-22626-1-git-send-email-antoine.tenart@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the binding documentation for the Marvell PXA168 Ethernet
controller, following its DT support.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 .../devicetree/bindings/net/marvell-pxa168.txt      | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/marvell-pxa168.txt

diff --git a/Documentation/devicetree/bindings/net/marvell-pxa168.txt b/Documentation/devicetree/bindings/net/marvell-pxa168.txt
new file mode 100644
index 000000000000..4177abf3dac3
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/marvell-pxa168.txt
@@ -0,0 +1,21 @@
+* Marvell PXA168 Ethernet Controller
+
+Required properties:
+- compatible: should be "marvell,pxa168-eth".
+- reg: address and length of the register set for the device.
+- interrupts: interrupt for the device.
+- clocks: pointer to the clock for the device.
+
+Optional properties:
+- port-id: should be '0','1' or '2'.
+- phy-addr: MDIO address of the PHY.
+- local-mac-address: see ethernet.txt file in the same directory.
+
+Example:
+
+	eth0: ethernet@f7b90000 {
+		compatible = "marvell,pxa168-eth";
+		reg = <0xf7b90000 0x10000>;
+		clocks = <&chip CLKID_GETH0>;
+		interrupts = <GIC_SPI 24 IRQ_TYPE_LEVEL_HIGH>;
+	};
-- 
1.9.1

