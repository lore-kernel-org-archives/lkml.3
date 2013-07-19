Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759738Ab3GSON7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 10:13:59 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:57158 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759224Ab3GSON4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 10:13:56 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 01/13] ARM: ux500: Remove Toshiba TC35892 I/O Expander's DT entry from Snowball's DTS
Date: Fri, 19 Jul 2013 15:13:37 +0100
Message-Id: <1374243229-8585-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374243229-8585-1-git-send-email-lee.jones@linaro.org>
References: <1374243229-8585-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It doesn't exist on this development board.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/snowball.dts | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/arm/boot/dts/snowball.dts b/arch/arm/boot/dts/snowball.dts
index 49824be..16c2b23 100644
--- a/arch/arm/boot/dts/snowball.dts
+++ b/arch/arm/boot/dts/snowball.dts
@@ -166,12 +166,6 @@
 		};
 
 		i2c@80004000 {
-			tc3589x@42 {
-				//compatible = "tc3589x";
-				reg = <0x42>;
-				gpios = <&gpio6 25 0x4>;
-				interrupt-parent = <&gpio6>;
-			};
 			tps61052@33 {
 				//compatible = "tps61052";
 				reg = <0x33>;
-- 
1.8.1.2

