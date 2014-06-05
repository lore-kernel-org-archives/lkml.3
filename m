Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936AbaFEPuF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:50:05 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58886 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752638AbaFEPsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:48:54 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, Peter.Chen@freescale.com
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/9] Documentation: bindings: add doc for the Berlin ChipIdea USB driver
Date: Thu,  5 Jun 2014 17:48:44 +0200
Message-Id: <1401983326-19205-8-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401983326-19205-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1401983326-19205-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the Marvell Berlin USB driver bindings.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 .../devicetree/bindings/usb/ci-hdrc-berlin.txt         | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/usb/ci-hdrc-berlin.txt

diff --git a/Documentation/devicetree/bindings/usb/ci-hdrc-berlin.txt b/Documentation/devicetree/bindings/usb/ci-hdrc-berlin.txt
new file mode 100644
index 000000000000..a3fc9054b830
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/ci-hdrc-berlin.txt
@@ -0,0 +1,18 @@
+* Marvell Berlin usb controllers
+
+Required properties:
+- compatible: should be "marvell,berlin-usb"
+- reg: base address and length of the registers
+- interrupts: interrupt for the USB controller
+- clocks: reference to the USB clock
+- marvell,usbphy: reference to the USB PHY
+
+Example:
+
+	usb@f7ed0000 {
+		compatible = "marvell,berlin-usb";
+		reg = <0xf7ed0000 0x10000>;
+		interrupts = <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&chip CLKID_USB0>;
+		marvell,usbphy = <&usb_phy0>;
+	};
-- 
1.9.1

