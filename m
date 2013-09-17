Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab3IQTd3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 15:33:29 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43802 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753703Ab3IQTba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 15:31:30 -0400
From: Suman Anna <s-anna@ti.com>
To: Benoit Cousson <bcousson@baylibre.com>
CC: Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
        Kumar Gala <galak@codeaurora.org>, Paul Walmsley <paul@pwsan.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Suman Anna <s-anna@ti.com>
Subject: [PATCHv2 3/9] ARM: dts: OMAP4: Add hwspinlock node
Date: Tue, 17 Sep 2013 14:31:00 -0500
Message-ID: <4b97ca1203c478af9c00f5530bfefeea2701acdf.1379445653.git.s-anna@ti.com>
X-Mailer: git-send-email 1.8.3.3
In-Reply-To: <cover.1379445653.git.s-anna@ti.com>
References: <cover.1379445653.git.s-anna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the hwspinlock device tree node for OMAP4 family
of SoCs.

Signed-off-by: Suman Anna <s-anna@ti.com>
---
 arch/arm/boot/dts/omap4.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
index 22d9f2b..a8cc274 100644
--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -248,6 +248,12 @@
 			clock-frequency = <48000000>;
 		};
 
+		hwspinlock: spinlock@4a0f6000 {
+			compatible = "ti,omap4-hwspinlock";
+			reg = <0x4a0f6000 0x1000>;
+			ti,hwmods = "spinlock";
+		};
+
 		i2c1: i2c@48070000 {
 			compatible = "ti,omap4-i2c";
 			reg = <0x48070000 0x100>;
-- 
1.8.3.3

