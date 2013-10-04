Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab3JDQQA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 12:16:00 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:54252 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530Ab3JDQP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 12:15:56 -0400
From: Fabio Estevam <festevam@gmail.com>
To: shawn.guo@linaro.org
Cc: linux-kernel@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH 1/3] ARM: dts: imx53-qsb: SDHC3 is connected in 8-bit mode
Date: Fri,  4 Oct 2013 13:15:26 -0300
Message-Id: <1380903328-17598-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

SDHC3 is 8 bit-wide, so pass the bus-width property to reflect that.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 arch/arm/boot/dts/imx53-qsb.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/imx53-qsb.dts b/arch/arm/boot/dts/imx53-qsb.dts
index 94597c3..b646ef1 100644
--- a/arch/arm/boot/dts/imx53-qsb.dts
+++ b/arch/arm/boot/dts/imx53-qsb.dts
@@ -136,6 +136,7 @@
 	pinctrl-0 = <&pinctrl_esdhc3_1>;
 	cd-gpios = <&gpio3 11 0>;
 	wp-gpios = <&gpio3 12 0>;
+	bus-width = <8>;
 	status = "okay";
 };
 
-- 
1.8.1.2

