Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462Ab3FMMW5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 08:22:57 -0400
Received: from multi.imgtec.com ([194.200.65.239]:31977 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756557Ab3FMMV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 08:21:29 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Markos Chandras <markos.chandras@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 04/10] metag/asm/irq.h: Declare init_IRQ
Date: Thu, 13 Jun 2013 13:19:35 +0100
Message-ID: <1371125981-5184-5-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371125981-5184-1-git-send-email-james.hogan@imgtec.com>
References: <1371125981-5184-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01192__2013_06_13_13_21_25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markos Chandras <markos.chandras@imgtec.com>

Fixes the following sparce warning:

warning: symbol 'init_IRQ' was not declared. Should it be static?

Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/include/asm/irq.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/metag/include/asm/irq.h b/arch/metag/include/asm/irq.h
index be0c8f3..ad6bd0e 100644
--- a/arch/metag/include/asm/irq.h
+++ b/arch/metag/include/asm/irq.h
@@ -17,6 +17,7 @@ struct pt_regs;
 
 int tbisig_map(unsigned int hw);
 extern void do_IRQ(int irq, struct pt_regs *regs);
+extern void init_IRQ(void);
 
 #ifdef CONFIG_METAG_SUSPEND_MEM
 int traps_save_context(void);
-- 
1.8.1.2


