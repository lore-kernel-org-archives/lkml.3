Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137Ab3BZLEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 06:04:39 -0500
Received: from multi.imgtec.com ([194.200.65.239]:58365 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756964Ab3BZLEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 06:04:14 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3/5] metag: remove select CONFIG_HAVE_IRQ_WORK
Date: Tue, 26 Feb 2013 11:04:00 +0000
Message-ID: <1361876642-10247-4-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361876642-10247-1-git-send-email-james.hogan@imgtec.com>
References: <1361876642-10247-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_02_26_11_04_10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit "irq_work: Remove CONFIG_HAVE_IRQ_WORK" the Kconfig symbol
HAVE_IRQ_WORK has gone. Remove the select from METAG too.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 arch/metag/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/metag/Kconfig b/arch/metag/Kconfig
index 46d0fa7..bc3de76 100644
--- a/arch/metag/Kconfig
+++ b/arch/metag/Kconfig
@@ -18,7 +18,6 @@ config METAG
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_GENERIC_HARDIRQS
-	select HAVE_IRQ_WORK
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_LZO
-- 
1.8.1.2


