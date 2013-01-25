Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119Ab3AYLMQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:12:16 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:56017 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755065Ab3AYLMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:12:08 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <kishon@ti.com>, <balbi@ti.com>, <b-cousson@ti.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <s-guiriec@ti.com>, <gg@slimlogic.co.uk>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/6] ARM: dts: omap5: Add omap control usb data
Date: Fri, 25 Jan 2013 16:41:47 +0530
Message-ID: <1359112312-6918-2-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359112312-6918-1-git-send-email-kishon@ti.com>
References: <1359112312-6918-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add omap control usb data in omap5 device tree file. This will have the
register address of registers to power on the USB2 PHY and USB3 PHY. The
information for the node added here is available in
Documentation/devicetree/bindings/usb/omap-usb.txt

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/boot/dts/omap5.dtsi |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index 7a78d1b..edc7464 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -504,5 +504,13 @@
 			hw-caps-ll-interface;
 			hw-caps-temp-alert;
 		};
+
+		omap_control_usb: omap-control-usb@4a002300 {
+			compatible = "ti,omap-control-usb";
+			reg = <0x4a002300 0x4>,
+			      <0x4a002370 0x4>;
+			reg-names = "control_dev_conf", "phy_power_usb";
+			ti,type = <2>;
+		};
 	};
 };
-- 
1.7.9.5

