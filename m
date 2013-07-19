Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760711Ab3GSOUO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 10:20:14 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:43579 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759224Ab3GSOOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 10:14:01 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 04/13] ARM: ux500: Remove Snowball DTS entry for ROHM BH1780GLI ambient light sensor
Date: Fri, 19 Jul 2013 15:13:40 +0100
Message-Id: <1374243229-8585-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374243229-8585-1-git-send-email-lee.jones@linaro.org>
References: <1374243229-8585-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It doesn't exist on the Snowball development board.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/snowball.dts | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/arm/boot/dts/snowball.dts b/arch/arm/boot/dts/snowball.dts
index d01ec70..dc5c641 100644
--- a/arch/arm/boot/dts/snowball.dts
+++ b/arch/arm/boot/dts/snowball.dts
@@ -165,13 +165,6 @@
 			status = "okay";
 		};
 
-		i2c@80128000 {
-			bh1780@29 {
-				// compatible = "rohm,bh1780gli";
-				reg = <0x33>;
-			};
-		};
-
 		cpufreq-cooling {
 			status = "okay";
 		};
-- 
1.8.1.2

