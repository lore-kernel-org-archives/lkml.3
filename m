Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007Ab3FMMVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 08:21:31 -0400
Received: from multi.imgtec.com ([194.200.65.239]:31976 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756331Ab3FMMV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 08:21:28 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Markos Chandras <markos.chandras@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 09/10] metag/traps: include setup.h for the per_cpu_trap_init declaration
Date: Thu, 13 Jun 2013 13:19:40 +0100
Message-ID: <1371125981-5184-10-git-send-email-james.hogan@imgtec.com>
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
 arch/metag/kernel/traps.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/metag/kernel/traps.c b/arch/metag/kernel/traps.c
index a7051de..c00ade0 100644
--- a/arch/metag/kernel/traps.c
+++ b/arch/metag/kernel/traps.c
@@ -33,6 +33,7 @@
 #include <asm/siginfo.h>
 #include <asm/traps.h>
 #include <asm/hwthread.h>
+#include <asm/setup.h>
 #include <asm/switch.h>
 #include <asm/user_gateway.h>
 #include <asm/syscall.h>
-- 
1.8.1.2


