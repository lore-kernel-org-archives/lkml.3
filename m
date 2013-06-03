Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150Ab3FCNnY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 09:43:24 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:37940 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306Ab3FCNnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 09:43:21 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, ulf.hansson@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 12/21] ARM: ux500: Remove AUXDATA relating to GPIO clock-name bindings
Date: Mon,  3 Jun 2013 14:42:36 +0100
Message-Id: <1370266965-7901-13-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370266965-7901-1-git-send-email-lee.jones@linaro.org>
References: <1370266965-7901-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/cpu-db8500.c |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index 3b77e36..53187fc 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -228,15 +228,6 @@ static struct of_dev_auxdata u8500_auxdata_lookup[] __initdata = {
 	OF_DEV_AUXDATA("arm,pl18x", 0x80118000, "sdi1",  NULL),
 	OF_DEV_AUXDATA("arm,pl18x", 0x80005000, "sdi2",  NULL),
 	OF_DEV_AUXDATA("arm,pl18x", 0x80114000, "sdi4",  NULL),
-	OF_DEV_AUXDATA("st,nomadik-gpio", 0x8012e000, "gpio.0", NULL),
-	OF_DEV_AUXDATA("st,nomadik-gpio", 0x8012e080, "gpio.1", NULL),
-	OF_DEV_AUXDATA("st,nomadik-gpio", 0x8000e000, "gpio.2", NULL),
-	OF_DEV_AUXDATA("st,nomadik-gpio", 0x8000e080, "gpio.3", NULL),
-	OF_DEV_AUXDATA("st,nomadik-gpio", 0x8000e100, "gpio.4", NULL),
-	OF_DEV_AUXDATA("st,nomadik-gpio", 0x8000e180, "gpio.5", NULL),
-	OF_DEV_AUXDATA("st,nomadik-gpio", 0x8011e000, "gpio.6", NULL),
-	OF_DEV_AUXDATA("st,nomadik-gpio", 0x8011e080, "gpio.7", NULL),
-	OF_DEV_AUXDATA("st,nomadik-gpio", 0xa03fe000, "gpio.8", NULL),
 	OF_DEV_AUXDATA("st,nomadik-i2c", 0x80004000, "nmk-i2c.0", NULL),
 	OF_DEV_AUXDATA("st,nomadik-i2c", 0x80122000, "nmk-i2c.1", NULL),
 	OF_DEV_AUXDATA("st,nomadik-i2c", 0x80128000, "nmk-i2c.2", NULL),
-- 
1.7.10.4

