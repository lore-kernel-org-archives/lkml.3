Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758585Ab3IBOXD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 10:23:03 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52464 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778Ab3IBOXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 10:23:00 -0400
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
Subject: [PATCH RFC 6/6] ARM: dts: AM4372: prcm node (for reset)
Date: Mon, 2 Sep 2013 19:52:20 +0530
Message-ID: <3ed48b0a5057a3efee97f4d91bd54214312a5adb.1378129416.git.afzal@ti.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <cover.1378129416.git.afzal@ti.com>
References: <cover.1378129416.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add AM4372 prcm node with reset binding.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 arch/arm/boot/dts/am4372.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/am4372.dtsi b/arch/arm/boot/dts/am4372.dtsi
index 5a68fde..d0d11b3 100644
--- a/arch/arm/boot/dts/am4372.dtsi
+++ b/arch/arm/boot/dts/am4372.dtsi
@@ -411,6 +411,12 @@
 			ti,hwmods = "epwmss5";
 			status = "disabled";
 		};
+
+		prcm: prcm@44df0000 {
+			compatible = "ti,am4372-prcm";
+			reg = <0x44df0000 0xa000>;
+			#reset-cells = <1>;
+		};
 	};
 
 	clocks {
-- 
1.8.3.4

