Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934068AbaCSNaQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:30:16 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:50243 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933933AbaCSNaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:30:13 -0400
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <kernel@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH 5/5] ARM: dts: tx53: Add IPU DI ports and endpoints
Date: Wed, 19 Mar 2014 14:28:41 +0100
Message-Id: <1395235721-13847-5-git-send-email-LW@KARO-electronics.de>
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
 arch/arm/boot/dts/imx53-tx53-x03x.dts |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx53-tx53-x03x.dts b/arch/arm/boot/dts/imx53-tx53-x03x.dts
index 0217dde3..43b4b7b 100644
--- a/arch/arm/boot/dts/imx53-tx53-x03x.dts
+++ b/arch/arm/boot/dts/imx53-tx53-x03x.dts
@@ -25,12 +25,17 @@
 	soc {
 		display: display@di0 {
 			compatible = "fsl,imx-parallel-display";
-			crtcs = <&ipu 0>;
 			interface-pix-fmt = "rgb24";
 			pinctrl-names = "default";
 			pinctrl-0 = <&pinctrl_rgb24_vga1>;
 			status = "okay";
 
+			port {
+				display0_in: endpoint {
+					remote-endpoint = <&ipu_di0_disp0>;
+				};
+			};
+
 			display-timings {
 				VGA {
 					clock-frequency = <25200000>;
-- 
1.7.10.4

