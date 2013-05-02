Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560Ab3EBKuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 06:50:21 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:58053 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab3EBKuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 06:50:18 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 8/8] ARM: ux500: Register Cyrp and Hash platform drivers on Snowball
Date: Thu,  2 May 2013 11:49:50 +0100
Message-Id: <1367491790-9727-9-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367491790-9727-1-git-send-email-lee.jones@linaro.org>
References: <1367491790-9727-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These drivers are now operational and even use the latest common clk
and DMA APIs. There's no reason why we shouldn't start them up now.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 7f756cc..3866fa8 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -656,6 +656,8 @@ static void __init snowball_init_machine(void)
 
 	mop500_snowball_ethernet_clock_enable();
 
+	u8500_cryp1_hash1_init(parent);
+
 	/* This board has full regulator constraints */
 	regulator_has_full_constraints();
 }
-- 
1.7.10.4

