Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbaK0Gay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 01:30:54 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:57520 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753717AbaK0G0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 01:26:39 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 13/25] Documentation: bindings: add doc for the Berlin USB PHY
Date: Thu, 27 Nov 2014 11:56:05 +0530
Message-ID: <1417069577-1169-14-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1417069577-1169-1-git-send-email-kishon@ti.com>
References: <1417069577-1169-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Antoine Tenart <antoine.tenart@free-electrons.com>

Document the bindings of the Marvell Berlin USB PHY driver.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 .../devicetree/bindings/phy/berlin-usb-phy.txt     |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/berlin-usb-phy.txt

diff --git a/Documentation/devicetree/bindings/phy/berlin-usb-phy.txt b/Documentation/devicetree/bindings/phy/berlin-usb-phy.txt
new file mode 100644
index 0000000..be33780
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/berlin-usb-phy.txt
@@ -0,0 +1,16 @@
+* Marvell Berlin USB PHY
+
+Required properties:
+- compatible: "marvell,berlin2-usb-phy" or "marvell,berlin2cd-usb-phy"
+- reg: base address and length of the registers
+- #phys-cells: should be 0
+- resets: reference to the reset controller
+
+Example:
+
+	usb-phy@f774000 {
+		compatible = "marvell,berlin2-usb-phy";
+		reg = <0xf774000 0x128>;
+		#phy-cells = <0>;
+		resets = <&chip 0x104 14>;
+	};
-- 
1.7.9.5

