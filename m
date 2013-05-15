Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846Ab3EOJ7p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:59:45 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:41055 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932607Ab3EOJwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:52:46 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        balbi@ti.com, linux-usb@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.hengli.com.au,
        vinod.koul@intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 19/39] ARM: ux500: Register Cyrp and Hash platform drivers on Snowball
Date: Wed, 15 May 2013 10:51:42 +0100
Message-Id: <1368611522-9984-20-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
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
index 38e321c..ba26ae3 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -637,6 +637,8 @@ static void __init snowball_init_machine(void)
 
 	mop500_snowball_ethernet_clock_enable();
 
+	u8500_cryp1_hash1_init(parent);
+
 	/* This board has full regulator constraints */
 	regulator_has_full_constraints();
 }
-- 
1.7.10.4

