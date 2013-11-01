Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab3KATrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 15:47:21 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:52342 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab3KATq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 15:46:26 -0400
From: Matt Porter <matt.porter@linaro.org>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Paul Zimmerman <paulz@synopsys.com>
Cc: Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: [PATCH v2 7/9] phy: add Broadcom Kona USB2 PHY DT binding
Date: Fri,  1 Nov 2013 15:45:56 -0400
Message-Id: <1383335158-19730-8-git-send-email-matt.porter@linaro.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1383335158-19730-1-git-send-email-matt.porter@linaro.org>
References: <1383335158-19730-1-git-send-email-matt.porter@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a binding that describes the Broadcom Kona USB2 PHY found
on the BCM281xx family of SoCs.

Signed-off-by: Matt Porter <matt.porter@linaro.org>
---
 .../devicetree/bindings/phy/bcm-kona-usb2-phy.txt         | 15 +++++++++++++++
 1 file changed, 15 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/bcm-kona-usb2-phy.txt

diff --git a/Documentation/devicetree/bindings/phy/bcm-kona-usb2-phy.txt b/Documentation/devicetree/bindings/phy/bcm-kona-usb2-phy.txt
new file mode 100644
index 0000000..db309e2
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/bcm-kona-usb2-phy.txt
@@ -0,0 +1,15 @@
+BROADCOM KONA USB2 PHY
+
+Required properties:
+ - compatible: brcm,kona-usb2-phy
+ - regs: offset and length of the PHY registers
+ - #phy-cells: must be 0
+Refer to phy/phy-bindings.txt for the generic PHY binding properties
+
+Example:
+
+	usbphy: usbphy@3f130000 {
+		compatible = "brcm,kona-usb2-phy";
+		reg = <0x3f130000 0x28>;
+		#phy-cells = <0>;
+	};
-- 
1.8.4

