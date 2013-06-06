Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933410Ab3FFM0K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 08:26:10 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:55736 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932742Ab3FFMRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 08:17:43 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 07/33] ARM: ux500: Supply the Ethernet clock lookup to Snowball's DT
Date: Thu,  6 Jun 2013 13:16:55 +0100
Message-Id: <1370521041-32318-8-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
References: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/snowball.dts |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/snowball.dts b/arch/arm/boot/dts/snowball.dts
index fb9dce5..e20e8ae 100644
--- a/arch/arm/boot/dts/snowball.dts
+++ b/arch/arm/boot/dts/snowball.dts
@@ -110,12 +110,13 @@
 				vdd33a-supply = <&en_3v3_reg>;
 				vddvario-supply = <&db8500_vape_reg>;
 
-
 				reg-shift = <1>;
 				reg-io-width = <2>;
 				smsc,force-internal-phy;
 				smsc,irq-active-high;
 				smsc,irq-push-pull;
+
+				clocks = <&prcc_pclk 3 0>;
 			};
 		};
 
-- 
1.7.10.4

