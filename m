Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759164Ab3CGNfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 08:35:47 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:33282 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295Ab3CGNfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 08:35:42 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <b-cousson@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <balbi@ti.com>, <kishon@ti.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v3 4/7] ARM: dts: omap5: Add omap control usb data
Date: Thu, 7 Mar 2013 19:05:17 +0530
Message-ID: <1362663320-23799-5-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362663320-23799-1-git-send-email-kishon@ti.com>
References: <1362663320-23799-1-git-send-email-kishon@ti.com>
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
index 790bb2a..c937500 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -496,5 +496,13 @@
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
1.7.10.4

