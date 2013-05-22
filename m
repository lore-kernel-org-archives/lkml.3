Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073Ab3EVNGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 09:06:50 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:54776 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876Ab3EVNGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 09:06:42 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH] ARM: ux500: regulators: Remove misleading comment
Date: Wed, 22 May 2013 14:06:35 +0100
Message-Id: <1369227995-17142-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes a comment which explains that the ab8505 platform
uses the same initialisation settings as the ab8500. Well when this
changed and the ab8505 started using its own set of initialisation
values, someone forgot to remove it.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index 33c353b..b34441b 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -996,7 +996,6 @@ struct ab8500_regulator_platform_data ab8500_regulator_plat_data = {
 	.num_ext_regulator      = ARRAY_SIZE(ab8500_ext_regulators),
 };
 
-/* Use the AB8500 init settings for AB8505 as they are the same right now */
 struct ab8500_regulator_platform_data ab8505_regulator_plat_data = {
 	.reg_init               = ab8505_reg_init,
 	.num_reg_init           = ARRAY_SIZE(ab8505_reg_init),
-- 
1.7.10.4

