Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759640AbaGPIdL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 04:33:11 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60615 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758669AbaGPI0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 04:26:14 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, Peter.Chen@freescale.com, balbi@ti.com,
        p.zabel@pengutronix.de
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 06/12] Documentation: bindings: add doc for the Berlin USB PHY
Date: Wed, 16 Jul 2014 10:26:00 +0200
Message-Id: <1405499166-6726-7-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405499166-6726-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1405499166-6726-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the bindings of the Marvell Berlin USB PHY driver.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 Documentation/devicetree/bindings/phy/berlin-usb-phy.txt | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/berlin-usb-phy.txt

diff --git a/Documentation/devicetree/bindings/phy/berlin-usb-phy.txt b/Documentation/devicetree/bindings/phy/berlin-usb-phy.txt
new file mode 100644
index 000000000000..be33780f668e
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
1.9.1

