Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216Ab3EVOgt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 10:36:49 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:35529 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab3EVOgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 10:36:48 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH] ARM: ux500: Apply other compatible name to the u8540 DTS file
Date: Wed, 22 May 2013 15:36:42 +0100
Message-Id: <1369233402-19225-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The common name for the 8540 is the u8540, but the fully qualified
name, or proper name is ccu8540. Ensure both are available to drivers
and platform code that wish to use them.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/ccu8540.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/ccu8540.dts b/arch/arm/boot/dts/ccu8540.dts
index 18daa01..af4487f 100644
--- a/arch/arm/boot/dts/ccu8540.dts
+++ b/arch/arm/boot/dts/ccu8540.dts
@@ -14,7 +14,7 @@
 
 / {
 	model = "ST-Ericsson U8540 platform with Device Tree";
-	compatible = "st-ericsson,u8540";
+	compatible = "st-ericsson,ccu8540", "st-ericsson,u8540";
 
 	memory {
 		reg = <0x00000000 0x20000000>;
-- 
1.7.10.4

