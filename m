Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbaBJKhq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:37:46 -0500
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:51382 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbaBJKgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:36:00 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@googlegroups.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 8/8] ARM: dts: sun7i: Add ethernet alias for GMAC
Date: Mon, 10 Feb 2014 18:35:54 +0800
Message-Id: <1392028554-32545-9-git-send-email-wens@csie.org>
X-Mailer: git-send-email 1.9.rc1
In-Reply-To: <1392028554-32545-1-git-send-email-wens@csie.org>
References: <1392028554-32545-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All Allwinner A20 boards we support can only use either EMAC or GMAC,
as they share the same pins. As we have switched all supported to
GMAC, we should alias GMAC (the active controller) as ethernet0,
so u-boot will insert the MAC address for the correct controller.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 arch/arm/boot/dts/sun7i-a20.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index 68c889c..1b5fb88 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -17,7 +17,7 @@
 	interrupt-parent = <&gic>;
 
 	aliases {
-		ethernet0 = &emac;
+		ethernet0 = &gmac;
 		serial0 = &uart0;
 		serial1 = &uart1;
 		serial2 = &uart2;
-- 
1.9.rc1

