Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995AbaFEPvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:51:36 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58892 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751866AbaFEPsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:48:53 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, balbi@ti.com
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/9] Documentation: bindings: add doc for the Berlin USB PHY
Date: Thu,  5 Jun 2014 17:48:42 +0200
Message-Id: <1401983326-19205-6-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401983326-19205-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1401983326-19205-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the bindings of the Marvell Berlin USB PHY driver.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 .../devicetree/bindings/usb/berlin-usbphy.txt          | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/usb/berlin-usbphy.txt

diff --git a/Documentation/devicetree/bindings/usb/berlin-usbphy.txt b/Documentation/devicetree/bindings/usb/berlin-usbphy.txt
new file mode 100644
index 000000000000..d97eb1f9d53f
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/berlin-usbphy.txt
@@ -0,0 +1,18 @@
+* Marvell Berlin USB PHY
+
+Required properties:
+- compatible: should be "marvell,berlin-usbphy"
+- reg: base address and length of the registers
+- #phys-cells: should be 0
+- reset: reference to the reset controller
+- power-gpio: reference the GPIO pin to power the PHY
+
+Example:
+
+	usbphy@f774000 {
+		compatible = "marvell,berlin-usbphy";
+		reg = <0xf774000 0x128>;
+		#phy-cells = <0>;
+		resets = <&chip 14>;
+		power-gpio = <&portb 8 GPIO_ACTIVE_HIGH>;
+	};
-- 
1.9.1

