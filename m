Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163Ab3HUOcW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 10:32:22 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47532 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041Ab3HUOcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 10:32:19 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <bcousson@baylibre.com>, <tony@atomide.com>, <balbi@ti.com>
CC: <rob.herring@calxeda.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <swarren@wwwdotorg.org>, <ian.campbell@citrix.com>,
        <linux@arm.linux.org.uk>, <javier.martinez@collabora.co.uk>,
        <devicetree@vger.kernel.org>, <kishon@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: [PATCH v3 2/5] arm: omap5: dts: fix ocp2scp DTS data
Date: Wed, 21 Aug 2013 20:01:31 +0530
Message-ID: <1377095494-15380-3-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1377095494-15380-1-git-send-email-kishon@ti.com>
References: <1377095494-15380-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felipe Balbi <balbi@ti.com>

this patch fixes the DTS data for ocp2scp
node by adding the missing reg property.

Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/boot/dts/omap5.dtsi |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index 5c99f19..4e41409 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -652,10 +652,11 @@
 			};
 		};
 
-		ocp2scp {
+		ocp2scp@4a080000 {
 			compatible = "ti,omap-ocp2scp";
 			#address-cells = <1>;
 			#size-cells = <1>;
+			reg = <0x4a080000 0x20>;
 			ranges;
 			ti,hwmods = "ocp2scp1";
 			usb2_phy: usb2phy@4a084000 {
-- 
1.7.10.4

