Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbaGNHTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 03:19:24 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:32957 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbaGNHTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 03:19:08 -0400
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@freescale.com
Cc: kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, mkl@pengutronix.de, stefan@agner.ch
Subject: [PATCH] ARM: dts: vf610: fix length of eshdc1 register property
Date: Mon, 14 Jul 2014 09:18:46 +0200
Message-Id: <1405322326-2183-1-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/boot/dts/vf610.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
index 6cc314e..6a6190c 100644
--- a/arch/arm/boot/dts/vf610.dtsi
+++ b/arch/arm/boot/dts/vf610.dtsi
@@ -362,7 +362,7 @@
 
 			esdhc1: esdhc@400b2000 {
 				compatible = "fsl,imx53-esdhc";
-				reg = <0x400b2000 0x4000>;
+				reg = <0x400b2000 0x1000>;
 				interrupts = <0 28 0x04>;
 				clocks = <&clks VF610_CLK_IPG_BUS>,
 					<&clks VF610_CLK_PLATFORM_BUS>,
-- 
2.0.1

