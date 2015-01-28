Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933094AbbA2KlF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:41:05 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754946AbbA2JAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:00:05 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 121/176] ARM: dts: imx25: Fix the SPI1 clocks
Date: Wed, 28 Jan 2015 15:29:11 +0100
Message-Id: <8a86c3ba27a7f3acf5bb49d7bc99ed79e7545f00.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 7a87e9cbc3a2f0ff0955815335e08c9862359130 upstream.

>From Documentation/devicetree/bindings/clock/imx25-clock.txt:

	cspi1_ipg		78
	cspi2_ipg		79
	cspi3_ipg		80

, so fix the SPI1 clocks accordingly to avoid a kernel hang when trying to
access SPI1.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm/boot/dts/imx25.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx25.dtsi b/arch/arm/boot/dts/imx25.dtsi
index de1611966d8b..6a26e79f0ef4 100644
--- a/arch/arm/boot/dts/imx25.dtsi
+++ b/arch/arm/boot/dts/imx25.dtsi
@@ -158,7 +158,7 @@
 				#size-cells = <0>;
 				compatible = "fsl,imx25-cspi", "fsl,imx35-cspi";
 				reg = <0x43fa4000 0x4000>;
-				clocks = <&clks 62>, <&clks 62>;
+				clocks = <&clks 78>, <&clks 78>;
 				clock-names = "ipg", "per";
 				interrupts = <14>;
 				status = "disabled";
-- 
2.2.2

