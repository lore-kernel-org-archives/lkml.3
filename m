Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932736Ab3GPMvc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 08:51:32 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:41290 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932191Ab3GPMva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 08:51:30 -0400
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH v2 2/5] arm: omap5: dts: fix ocp2scp DTS data
Date: Tue, 16 Jul 2013 15:50:34 +0300
Message-ID: <1373979037-27587-3-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.8.3.3.754.g9c3c367
In-Reply-To: <1373979037-27587-1-git-send-email-balbi@ti.com>
References: <1373979037-27587-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch fixes the DTS data for ocp2scp
node by adding the missing reg property.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 arch/arm/boot/dts/omap5.dtsi | 3 ++-
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
1.8.3.3.754.g9c3c367

