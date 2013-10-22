Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab3JVRHk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 13:07:40 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:35172 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab3JVRHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 13:07:36 -0400
From: Rostislav Lisovy <lisovy@gmail.com>
To: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>
Cc: pisa@cmp.felk.cvut.cz, Rostislav Lisovy <lisovy@gmail.com>
Subject: [PATCH 2/4] ARM: dts: i.MX53: Internal keyboard controller
Date: Tue, 22 Oct 2013 19:07:21 +0200
Message-Id: <1382461643-16790-3-git-send-email-lisovy@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1382461643-16790-1-git-send-email-lisovy@gmail.com>
References: <1382461643-16790-1-git-send-email-lisovy@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rostislav Lisovy <lisovy@gmail.com>

diff --git a/arch/arm/boot/dts/imx53.dtsi b/arch/arm/boot/dts/imx53.dtsi
index 55e83d1..362eca0 100644
--- a/arch/arm/boot/dts/imx53.dtsi
+++ b/arch/arm/boot/dts/imx53.dtsi
@@ -281,6 +281,14 @@
 				#interrupt-cells = <2>;
 			};
 
+			kpp: kpp@53f94000 {
+				compatible = "fsl,imx53-kpp", "fsl,imx21-kpp";
+				reg = <0x53f94000 0x4000>;
+				interrupts = <60>;
+				clocks = <&clks 0>;
+				status = "disabled";
+			};
+
 			wdog1: wdog@53f98000 {
 				compatible = "fsl,imx53-wdt", "fsl,imx21-wdt";
 				reg = <0x53f98000 0x4000>;
-- 
1.7.10.4

