Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab3LMQv5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 11:51:57 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:59449 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab3LMQvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 11:51:50 -0500
From: Matt Porter <mporter@linaro.org>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Paul Zimmerman <paulz@synopsys.com>
Cc: Tomasz Figa <t.figa@samsung.com>, Kamil Debski <k.debski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dinh Nguyen <dinh.linux@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: [PATCH v6 7/9] phy: add Broadcom Kona USB2 PHY DT binding
Date: Fri, 13 Dec 2013 11:51:21 -0500
Message-Id: <1386953483-21631-8-git-send-email-mporter@linaro.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386953483-21631-1-git-send-email-mporter@linaro.org>
References: <1386953483-21631-1-git-send-email-mporter@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a binding that describes the Broadcom Kona USB2 PHY found
on the BCM281xx family of SoCs.

Signed-off-by: Matt Porter <mporter@linaro.org>
Acked-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 Documentation/devicetree/bindings/phy/bcm-phy.txt | 15 +++++++++++++++
 1 file changed, 15 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/bcm-phy.txt

diff --git a/Documentation/devicetree/bindings/phy/bcm-phy.txt b/Documentation/devicetree/bindings/phy/bcm-phy.txt
new file mode 100644
index 0000000..3dc8b3d
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/bcm-phy.txt
@@ -0,0 +1,15 @@
+BROADCOM KONA USB2 PHY
+
+Required properties:
+ - compatible: brcm,kona-usb2-phy
+ - reg: offset and length of the PHY registers
+ - #phy-cells: must be 0
+Refer to phy/phy-bindings.txt for the generic PHY binding properties
+
+Example:
+
+	usbphy: usb-phy@3f130000 {
+		compatible = "brcm,kona-usb2-phy";
+		reg = <0x3f130000 0x28>;
+		#phy-cells = <0>;
+	};
-- 
1.8.4

