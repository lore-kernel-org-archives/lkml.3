Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759840Ab3GSOOE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 10:14:04 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:65114 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759740Ab3GSOOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 10:14:00 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 03/13] ARM: ux500: Remove Snowball DTS entry for TPS61052 chip
Date: Fri, 19 Jul 2013 15:13:39 +0100
Message-Id: <1374243229-8585-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374243229-8585-1-git-send-email-lee.jones@linaro.org>
References: <1374243229-8585-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TPS61052 is a; boost converter, LED driver, LED flash driver and
simple GPIO pin chip. It has no use here however, as it is not
found on the Snowball development board.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/snowball.dts | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/arm/boot/dts/snowball.dts b/arch/arm/boot/dts/snowball.dts
index a5d6317..d01ec70 100644
--- a/arch/arm/boot/dts/snowball.dts
+++ b/arch/arm/boot/dts/snowball.dts
@@ -165,13 +165,6 @@
 			status = "okay";
 		};
 
-		i2c@80004000 {
-			tps61052@33 {
-				//compatible = "tps61052";
-				reg = <0x33>;
-			};
-		};
-
 		i2c@80128000 {
 			bh1780@29 {
 				// compatible = "rohm,bh1780gli";
-- 
1.8.1.2

