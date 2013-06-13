Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201Ab3FMMW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 08:22:28 -0400
Received: from multi.imgtec.com ([194.200.65.239]:31976 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756562Ab3FMMV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 08:21:29 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Markos Chandras <markos.chandras@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 07/10] metag/processor.h: Add missing cpuinfo_op declaration.
Date: Thu, 13 Jun 2013 13:19:38 +0100
Message-ID: <1371125981-5184-8-git-send-email-james.hogan@imgtec.com>
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

Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/include/asm/processor.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/metag/include/asm/processor.h b/arch/metag/include/asm/processor.h
index 9b029a7..f16477d 100644
--- a/arch/metag/include/asm/processor.h
+++ b/arch/metag/include/asm/processor.h
@@ -199,4 +199,6 @@ extern void (*soc_halt)(void);
 extern void show_trace(struct task_struct *tsk, unsigned long *sp,
 		       struct pt_regs *regs);
 
+extern const struct seq_operations cpuinfo_op;
+
 #endif
-- 
1.8.1.2


