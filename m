Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab3EVObo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 10:31:44 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:58721 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756212Ab3EVObl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 10:31:41 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4/7] ARM: ux500: Standardise Pinctrl compatible string for DBx5x based platforms
Date: Wed, 22 May 2013 15:22:58 +0100
Message-Id: <1369232581-18923-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1369232581-18923-1-git-send-email-lee.jones@linaro.org>
References: <1369232581-18923-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/cpu-db8500.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index 8305bad..27c9382 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -249,7 +249,7 @@ static struct of_dev_auxdata u8500_auxdata_lookup[] __initdata = {
 	OF_DEV_AUXDATA("stericsson,ux500-cryp", 0xa03cb000, "cryp1", NULL),
 	OF_DEV_AUXDATA("stericsson,ux500-hash", 0xa03c2000, "hash1", NULL),
 	/* Requires device name bindings. */
-	OF_DEV_AUXDATA("stericsson,nmk-pinctrl", U8500_PRCMU_BASE,
+	OF_DEV_AUXDATA("stericsson,db8500-pinctrl", U8500_PRCMU_BASE,
 		"pinctrl-db8500", NULL),
 	/* Requires clock name and DMA bindings. */
 	OF_DEV_AUXDATA("stericsson,ux500-msp-i2s", 0x80123000,
-- 
1.7.10.4

