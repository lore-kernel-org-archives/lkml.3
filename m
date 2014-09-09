Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490AbaIIMEI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 08:04:08 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:53642 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbaIIMEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 08:04:06 -0400
X-Originating-IP: 88.159.34.112
From: Maarten ter Huurne <maarten@treewalker.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Apelete Seketeli <apelete@seketeli.net>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org,
        Maarten ter Huurne <maarten@treewalker.org>
Subject: [PATCH] MIPS: Removed declaration of obsolete arch_init_clk_ops()
Date: Tue,  9 Sep 2014 14:04:00 +0200
Message-Id: <1410264240-10869-1-git-send-email-maarten@treewalker.org>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Maarten ter Huurne <maarten@treewalker.org>
---
 arch/mips/include/asm/clock.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/mips/include/asm/clock.h b/arch/mips/include/asm/clock.h
index 778e32d..4809c29 100644
--- a/arch/mips/include/asm/clock.h
+++ b/arch/mips/include/asm/clock.h
@@ -35,9 +35,6 @@ struct clk {
 #define CLK_ALWAYS_ENABLED	(1 << 0)
 #define CLK_RATE_PROPAGATES	(1 << 1)
 
-/* Should be defined by processor-specific code */
-void arch_init_clk_ops(struct clk_ops **, int type);
-
 int clk_init(void);
 
 int __clk_enable(struct clk *);
-- 
1.8.4.5

