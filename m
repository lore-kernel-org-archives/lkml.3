Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933585Ab3CZJNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 05:13:54 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:51031 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759711Ab3CZJNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 05:13:38 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: kevin@allwinnertech.com, sunny@allwinnertech.com, shuge@allwinnertech.com,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 10/10] ARM: sunxi: dt: Update watchdog compatible string
Date: Tue, 26 Mar 2013 10:13:17 +0100
Message-Id: <1364289198-11589-11-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364289198-11589-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1364289198-11589-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/sun4i-a10.dtsi |    2 +-
 arch/arm/boot/dts/sun5i-a13.dtsi |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/sun4i-a10.dtsi b/arch/arm/boot/dts/sun4i-a10.dtsi
index 805d704..aee190c 100644
--- a/arch/arm/boot/dts/sun4i-a10.dtsi
+++ b/arch/arm/boot/dts/sun4i-a10.dtsi
@@ -165,7 +165,7 @@
 		};
 
 		wdt: watchdog@01c20c90 {
-			compatible = "allwinner,sunxi-wdt";
+			compatible = "allwinner,sun4i-wdt";
 			reg = <0x01c20c90 0x10>;
 		};
 
diff --git a/arch/arm/boot/dts/sun5i-a13.dtsi b/arch/arm/boot/dts/sun5i-a13.dtsi
index 760222c..72c4948 100644
--- a/arch/arm/boot/dts/sun5i-a13.dtsi
+++ b/arch/arm/boot/dts/sun5i-a13.dtsi
@@ -159,7 +159,7 @@
 		};
 
 		wdt: watchdog@01c20c90 {
-			compatible = "allwinner,sunxi-wdt";
+			compatible = "allwinner,sun4i-wdt";
 			reg = <0x01c20c90 0x10>;
 		};
 
-- 
1.7.10.4

