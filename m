Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540Ab3JJVRX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 17:17:23 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60916 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757403Ab3JJVQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 17:16:47 -0400
From: Suman Anna <s-anna@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>, Mark Rutland <mark.rutland@arm.com>
CC: Tony Lindgren <tony@atomide.com>, Benoit Cousson <bcousson@baylibre.com>,
        Kumar Gala <galak@codeaurora.org>, Paul Walmsley <paul@pwsan.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Suman Anna <s-anna@ti.com>
Subject: [PATCHv3 8/8] ARM: dts: AM33XX: Add hwspinlock node
Date: Thu, 10 Oct 2013 16:15:35 -0500
Message-ID: <1381439735-52888-9-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381439735-52888-1-git-send-email-s-anna@ti.com>
References: <1381439735-52888-1-git-send-email-s-anna@ti.com>
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
index 8692490..49dfb86 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -285,6 +285,12 @@
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
1.8.4

