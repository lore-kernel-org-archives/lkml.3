Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194Ab3HGQ3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 12:29:53 -0400
Received: from 15.mo1.mail-out.ovh.net ([188.165.38.232]:39131 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756951Ab3HGQ3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 12:29:52 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>,
        Douglas Gilbert <dgilbert@interlog.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: [PATCH] ARM: at91: add missing uart clocks DT entries
Date: Wed,  7 Aug 2013 18:29:44 +0200
Message-Id: <1375892984-2835-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 8559091093439412300
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrtdegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrtdegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add clocks to clock lookup table for uart DT entries.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/mach-at91/at91sam9x5.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-at91/at91sam9x5.c b/arch/arm/mach-at91/at91sam9x5.c
index 2abee66..916e5a1 100644
--- a/arch/arm/mach-at91/at91sam9x5.c
+++ b/arch/arm/mach-at91/at91sam9x5.c
@@ -227,6 +227,8 @@ static struct clk_lookup periph_clocks_lookups[] = {
 	CLKDEV_CON_DEV_ID("usart", "f8020000.serial", &usart1_clk),
 	CLKDEV_CON_DEV_ID("usart", "f8024000.serial", &usart2_clk),
 	CLKDEV_CON_DEV_ID("usart", "f8028000.serial", &usart3_clk),
+	CLKDEV_CON_DEV_ID("usart", "f8040000.serial", &uart0_clk),
+	CLKDEV_CON_DEV_ID("usart", "f8044000.serial", &uart1_clk),
 	CLKDEV_CON_DEV_ID("t0_clk", "f8008000.timer", &tcb0_clk),
 	CLKDEV_CON_DEV_ID("t0_clk", "f800c000.timer", &tcb0_clk),
 	CLKDEV_CON_DEV_ID("mci_clk", "f0008000.mmc", &mmc0_clk),
-- 
1.7.9.5

