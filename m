Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933973AbaCSN35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:29:57 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:50237 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932996AbaCSN3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:29:54 -0400
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <kernel@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH 2/5] ARM: dts: tx53: sort the i2c subnodes by I2C address
Date: Wed, 19 Mar 2014 14:28:38 +0100
Message-Id: <1395235721-13847-2-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1395235721-13847-1-git-send-email-LW@KARO-electronics.de>
References: <1395235721-13847-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 arch/arm/boot/dts/imx53-tx53-x13x.dts |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm/boot/dts/imx53-tx53-x13x.dts b/arch/arm/boot/dts/imx53-tx53-x13x.dts
index c8a3473..cd3476b 100644
--- a/arch/arm/boot/dts/imx53-tx53-x13x.dts
+++ b/arch/arm/boot/dts/imx53-tx53-x13x.dts
@@ -108,14 +108,6 @@
 	pinctrl-0 = <&pinctrl_i2c3>;
 	status = "okay";
 
-	sgtl5000: codec@0a {
-		compatible = "fsl,sgtl5000";
-		reg = <0x0a>;
-		VDDA-supply = <&reg_2v5>;
-		VDDIO-supply = <&reg_3v3>;
-		clocks = <&mclk>;
-	};
-
 	touchscreen1: eeti@04 {
 		compatible = "eeti,egalax_ts";
 		reg = <0x04>;
@@ -126,6 +118,14 @@
 		wakeup-gpios = <&gpio3 22 GPIO_ACTIVE_HIGH>;
 		linux,wakeup;
 	};
+
+	sgtl5000: codec@0a {
+		compatible = "fsl,sgtl5000";
+		reg = <0x0a>;
+		VDDA-supply = <&reg_2v5>;
+		VDDIO-supply = <&reg_3v3>;
+		clocks = <&mclk>;
+	};
 };
 
 &iomuxc {
-- 
1.7.10.4

