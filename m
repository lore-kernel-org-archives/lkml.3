Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708Ab3IBOXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 10:23:21 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44157 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756337Ab3IBOXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 10:23:18 -0400
From: Afzal Mohammed <afzal@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
CC: Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>,
        Benoit Cousson <bcousson@baylibre.com>,
        Russell King <linux@arm.linux.org.uk>,
        Ian Campbell <ian.campbell@citrix.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH RFC 5/6] ARM: dts: AM335x: prcm node (for reset)
Date: Mon, 2 Sep 2013 19:52:04 +0530
Message-ID: <00675d65eef61eb4222e6a461ef479ebbd1d4787.1378129416.git.afzal@ti.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <cover.1378129416.git.afzal@ti.com>
References: <cover.1378129416.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add AM335x prcm node with reset binding.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 arch/arm/boot/dts/am33xx.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index 4701e3c..c2ccf94 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -530,6 +530,12 @@
 			#size-cells = <1>;
 			status = "disabled";
 		};
+
+		prcm: prcm@44e00000 {
+			compatible = "ti,am3352-prcm";
+			reg = <0x44e00000 0x1300>;
+			#reset-cells = <1>;
+		};
 	};
 
 	clocks {
-- 
1.8.3.4

