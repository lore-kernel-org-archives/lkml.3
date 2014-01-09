Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbaAIMKG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 07:10:06 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:34702 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950AbaAIMJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 07:09:41 -0500
From: Roger Quadros <rogerq@ti.com>
To: <bcousson@baylibre.com>, <tony@atomide.com>
CC: <balbi@ti.com>, <arnd@arndb.de>, <sre@debian.org>, <mark.rutland@arm.com>,
        <m.paolino@virtualopensystems.com>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH v5 7/9] ARM: dts: omap4-panda: Provide USB PHY clock
Date: Thu, 9 Jan 2014 17:38:21 +0530
Message-ID: <1389269303-30465-8-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389269303-30465-1-git-send-email-rogerq@ti.com>
References: <1389269303-30465-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The USB PHY gets its clock from AUXCLK3. Provide this
information.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/omap4-panda-common.dtsi | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/omap4-panda-common.dtsi b/arch/arm/boot/dts/omap4-panda-common.dtsi
index 88c6a05..50b72966 100644
--- a/arch/arm/boot/dts/omap4-panda-common.dtsi
+++ b/arch/arm/boot/dts/omap4-panda-common.dtsi
@@ -83,12 +83,8 @@
 		compatible = "usb-nop-xceiv";
 		reset-gpios = <&gpio2 30 GPIO_ACTIVE_LOW>;   /* gpio_62 */
 		vcc-supply = <&hsusb1_power>;
-	/**
-	 * FIXME:
-	 * put the right clock phandle here when available
-	 *	clocks = <&auxclk3>;
-	 *	clock-names = "main_clk";
-	 */
+		clocks = <&auxclk3_ck>;
+		clock-names = "main_clk";
 		clock-frequency = <19200000>;
 	};
 
-- 
1.8.3.2

