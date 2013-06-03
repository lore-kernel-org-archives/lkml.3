Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246Ab3FCNna (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 09:43:30 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:61026 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306Ab3FCNn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 09:43:26 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, ulf.hansson@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 15/21] ARM: ux500: Remove AUXDATA relating to I2C clock-name bindings
Date: Mon,  3 Jun 2013 14:42:39 +0100
Message-Id: <1370266965-7901-16-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370266965-7901-1-git-send-email-lee.jones@linaro.org>
References: <1370266965-7901-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/cpu-db8500.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index ad4250f..d57667c 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -221,11 +221,6 @@ static struct of_dev_auxdata u8500_auxdata_lookup[] __initdata = {
 	/* Requires DMA bindings. */
 	OF_DEV_AUXDATA("arm,pl022", 0x80002000, "ssp0",  &ssp0_plat),
 	/* Requires clock name bindings. */
-	OF_DEV_AUXDATA("st,nomadik-i2c", 0x80004000, "nmk-i2c.0", NULL),
-	OF_DEV_AUXDATA("st,nomadik-i2c", 0x80122000, "nmk-i2c.1", NULL),
-	OF_DEV_AUXDATA("st,nomadik-i2c", 0x80128000, "nmk-i2c.2", NULL),
-	OF_DEV_AUXDATA("st,nomadik-i2c", 0x80110000, "nmk-i2c.3", NULL),
-	OF_DEV_AUXDATA("st,nomadik-i2c", 0x8012a000, "nmk-i2c.4", NULL),
 	OF_DEV_AUXDATA("stericsson,db8500-musb", 0xa03e0000, "musb-ux500.0", NULL),
 	OF_DEV_AUXDATA("stericsson,db8500-prcmu", 0x80157000, "db8500-prcmu",
 			&db8500_prcmu_pdata),
-- 
1.7.10.4

