Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564Ab3GSN7J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 09:59:09 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:35572 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab3GSN7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 09:59:06 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 01/22] ARM: ux500: Remove '0x's from HREF v60+ DTS file
Date: Fri, 19 Jul 2013 14:58:32 +0100
Message-Id: <1374242333-6852-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/hrefv60plus.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/hrefv60plus.dts b/arch/arm/boot/dts/hrefv60plus.dts
index 3d580d6..46fd8af 100644
--- a/arch/arm/boot/dts/hrefv60plus.dts
+++ b/arch/arm/boot/dts/hrefv60plus.dts
@@ -26,7 +26,7 @@
 
 	soc {
 		i2c@80110000 {
-			bu21013_tp@0x5c {
+			bu21013_tp@5c {
 				reset-gpio = <&gpio4 15 0x4>;
 			};
 		};
-- 
1.8.1.2

