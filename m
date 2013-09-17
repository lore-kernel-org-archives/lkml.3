Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab3IQTbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 15:31:55 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33361 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753706Ab3IQTbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 15:31:53 -0400
From: Suman Anna <s-anna@ti.com>
To: Benoit Cousson <bcousson@baylibre.com>
CC: Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
        Kumar Gala <galak@codeaurora.org>, Paul Walmsley <paul@pwsan.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Suman Anna <s-anna@ti.com>
Subject: [PATCHv2 8/9] ARM: dts: AM33XX: Add hwspinlock node
Date: Tue, 17 Sep 2013 14:31:22 -0500
Message-ID: <c947403dc42a6966c5dbe82fa5284043b25e9345.1379445653.git.s-anna@ti.com>
X-Mailer: git-send-email 1.8.3.3
In-Reply-To: <cover.1379445653.git.s-anna@ti.com>
References: <cover.1379445653.git.s-anna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the hwspinlock device tree node for AM33xx family
of SoCs.

Signed-off-by: Suman Anna <s-anna@ti.com>
---
 arch/arm/boot/dts/am33xx.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index f9c5da9..4371257 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -228,6 +228,12 @@
 			status = "disabled";
 		};
 
+		hwspinlock: spinlock@480ca000 {
+			compatible = "ti,omap4-hwspinlock";
+			reg = <0x480ca000 0x1000>;
+			ti,hwmods = "spinlock";
+		};
+
 		wdt2: wdt@44e35000 {
 			compatible = "ti,omap3-wdt";
 			ti,hwmods = "wd_timer2";
-- 
1.8.3.3

