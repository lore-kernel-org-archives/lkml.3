Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760704Ab3GSOVw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 10:21:52 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:58353 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759426Ab3GSON6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 10:13:58 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 02/13] ARM: ux500: Remove Snowball DTS entry for National Semiconductor LP5521 LED chip
Date: Fri, 19 Jul 2013 15:13:38 +0100
Message-Id: <1374243229-8585-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374243229-8585-1-git-send-email-lee.jones@linaro.org>
References: <1374243229-8585-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It doesn't exist on the Snowball development board.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/snowball.dts | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/arm/boot/dts/snowball.dts b/arch/arm/boot/dts/snowball.dts
index 16c2b23..a5d6317 100644
--- a/arch/arm/boot/dts/snowball.dts
+++ b/arch/arm/boot/dts/snowball.dts
@@ -173,14 +173,6 @@
 		};
 
 		i2c@80128000 {
-			lp5521@33 {
-				// compatible = "lp5521";
-				reg = <0x33>;
-			};
-			lp5521@34 {
-				// compatible = "lp5521";
-				reg = <0x34>;
-			};
 			bh1780@29 {
 				// compatible = "rohm,bh1780gli";
 				reg = <0x33>;
-- 
1.8.1.2

