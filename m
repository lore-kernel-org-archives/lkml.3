Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932976Ab3CGNiF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 08:38:05 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:46501 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759000Ab3CGNfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 08:35:45 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <b-cousson@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <balbi@ti.com>, <kishon@ti.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v3 1/7] ARM: dts: omap: Add omap control usb data
Date: Thu, 7 Mar 2013 19:05:14 +0530
Message-ID: <1362663320-23799-2-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362663320-23799-1-git-send-email-kishon@ti.com>
References: <1362663320-23799-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add omap control usb data in omap4 device tree file. This will have the
register address of registers to power on the PHY and to write to
mailbox. The information about this data node is available @
Documentation/devicetree/bindings/usb/omap-usb.txt

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/boot/dts/omap4.dtsi |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
index 739bb79..ffc7352 100644
--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -529,5 +529,13 @@
 			ti,hwmods = "timer11";
 			ti,timer-pwm;
 		};
+
+		omap_control_usb: omap-control-usb@4a002300 {
+			compatible = "ti,omap-control-usb";
+			reg = <0x4a002300 0x4>,
+			      <0x4a00233c 0x4>;
+			reg-names = "control_dev_conf", "otghs_control";
+			ti,type = <1>;
+		};
 	};
 };
-- 
1.7.10.4

