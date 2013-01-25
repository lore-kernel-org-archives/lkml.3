Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab3AYDTF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 22:19:05 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:36125 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756572Ab3AYDS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 22:18:59 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <balbi@ti.com>, <b-cousson@ti.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <s-guiriec@ti.com>, <gg@slimlogic.co.uk>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/6] ARM: dts: omap5: add dwc3 omap dt data
Date: Fri, 25 Jan 2013 08:48:33 +0530
Message-ID: <1359083915-8690-5-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359083915-8690-1-git-send-email-kishon@ti.com>
References: <1359083915-8690-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add dwc3 omap glue data to the omap5 dt data file. The information about
the dt node added here is available @
Documentation/devicetree/bindings/usb/omap-usb.txt

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/boot/dts/omap5.dtsi |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index 5f59bf2..1703a72 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -513,6 +513,17 @@
 			ti,type = <2>;
 		};
 
+		omap_dwc3@4a020000 {
+			compatible = "ti,dwc3";
+			ti,hwmods = "usb_otg_ss";
+			reg = <0x4a020000 0x1ff>;
+			interrupts = <0 93 4>;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			utmi-mode = <2>;
+			ranges;
+		};
+
 		ocp2scp {
 			compatible = "ti,omap-ocp2scp";
 			#address-cells = <1>;
-- 
1.7.9.5

