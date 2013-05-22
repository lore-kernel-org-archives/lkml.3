Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353Ab3EVOdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 10:33:12 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:55065 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193Ab3EVObk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 10:31:40 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3/7] ARM: ux500: Standardise Pinctrl compatible string for Nomadik based platforms
Date: Wed, 22 May 2013 15:22:57 +0100
Message-Id: <1369232581-18923-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1369232581-18923-1-git-send-email-lee.jones@linaro.org>
References: <1369232581-18923-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-nomadik/cpu-8815.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-nomadik/cpu-8815.c b/arch/arm/mach-nomadik/cpu-8815.c
index 59f6ff5..316fe82 100644
--- a/arch/arm/mach-nomadik/cpu-8815.c
+++ b/arch/arm/mach-nomadik/cpu-8815.c
@@ -288,7 +288,7 @@ static struct of_dev_auxdata cpu8815_auxdata_lookup[] __initdata = {
 		"gpio.2", NULL),
 	OF_DEV_AUXDATA("st,nomadik-gpio", NOMADIK_GPIO3_BASE,
 		"gpio.3", NULL),
-	OF_DEV_AUXDATA("stericsson,nmk-pinctrl-stn8815", 0,
+	OF_DEV_AUXDATA("stericsson,stn8815-pinctrl", 0,
 		"pinctrl-stn8815", NULL),
 	OF_DEV_AUXDATA("arm,primecell", NOMADIK_UART0_BASE,
 		"uart0", NULL),
-- 
1.7.10.4

