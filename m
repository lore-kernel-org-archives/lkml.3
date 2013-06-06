Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933564Ab3FFMSY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 08:18:24 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48920 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933457Ab3FFMSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 08:18:18 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 28/33] ARM: ux500: Remove AUXDATA relating to MSP (Audio) clock-name bindings
Date: Thu,  6 Jun 2013 13:17:16 +0100
Message-Id: <1370521041-32318-29-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
References: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/cpu-db8500.c |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index b138d80..747b91f 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -232,15 +232,6 @@ static struct of_dev_auxdata u8500_auxdata_lookup[] __initdata = {
 	/* Requires device name bindings. */
 	OF_DEV_AUXDATA("stericsson,db8500-pinctrl", U8500_PRCMU_BASE,
 		"pinctrl-db8500", NULL),
-	/* Requires clock name and DMA bindings. */
-	OF_DEV_AUXDATA("stericsson,ux500-msp-i2s", 0x80123000,
-		"ux500-msp-i2s.0", &msp0_platform_data),
-	OF_DEV_AUXDATA("stericsson,ux500-msp-i2s", 0x80124000,
-		"ux500-msp-i2s.1", &msp1_platform_data),
-	OF_DEV_AUXDATA("stericsson,ux500-msp-i2s", 0x80117000,
-		"ux500-msp-i2s.2", &msp2_platform_data),
-	OF_DEV_AUXDATA("stericsson,ux500-msp-i2s", 0x80125000,
-		"ux500-msp-i2s.3", &msp3_platform_data),
 	/* Requires clock name bindings and channel address lookup table. */
 	OF_DEV_AUXDATA("stericsson,db8500-dma40", 0x801C0000, "dma40.0", NULL),
 	{},
-- 
1.7.10.4

