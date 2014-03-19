Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934206AbaCSNcR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:32:17 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:50233 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933873AbaCSN3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:29:53 -0400
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <kernel@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH 1/5] ARM: dts: tx53: remove redundant regulator-boot-on
Date: Wed, 19 Mar 2014 14:28:37 +0100
Message-Id: <1395235721-13847-1-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 arch/arm/boot/dts/imx53-tx53-x13x.dts |    2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/boot/dts/imx53-tx53-x13x.dts b/arch/arm/boot/dts/imx53-tx53-x13x.dts
index 6480471..c8a3473 100644
--- a/arch/arm/boot/dts/imx53-tx53-x13x.dts
+++ b/arch/arm/boot/dts/imx53-tx53-x13x.dts
@@ -72,7 +72,6 @@
 			regulator-max-microvolt = <3300000>;
 			gpio = <&gpio3 29 GPIO_ACTIVE_HIGH>;
 			enable-active-high;
-			regulator-boot-on;
 		};
 
 		reg_lcd_pwr1: regulator@6 {
@@ -83,7 +82,6 @@
 			regulator-max-microvolt = <3300000>;
 			gpio = <&gpio2 31 GPIO_ACTIVE_HIGH>;
 			enable-active-high;
-			regulator-boot-on;
 		};
 	};
 };
-- 
1.7.10.4

