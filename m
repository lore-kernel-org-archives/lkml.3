Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935563Ab3BTOwb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 09:52:31 -0500
Received: from multi.imgtec.com ([194.200.65.239]:49913 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935188Ab3BTOwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 09:52:16 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Vineet Gupta <vgupta@synopsys.com>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 2/2] metag: prom.h: remove declaration of metag_dt_memblock_reserve()
Date: Wed, 20 Feb 2013 14:52:09 +0000
Message-ID: <1361371929-28148-3-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361371929-28148-1-git-send-email-james.hogan@imgtec.com>
References: <1361371929-28148-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_02_20_14_52_15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Metag doesn't have a metag_dt_memblock_reserve() function so remove the
declaration from asm/prom.h.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/include/asm/prom.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/metag/include/asm/prom.h b/arch/metag/include/asm/prom.h
index ccac97e..d2aa35d 100644
--- a/arch/metag/include/asm/prom.h
+++ b/arch/metag/include/asm/prom.h
@@ -19,6 +19,5 @@
 
 extern struct machine_desc *setup_machine_fdt(void *dt);
 extern void copy_fdt(void);
-extern void metag_dt_memblock_reserve(void);
 
 #endif /* __ASM_METAG_PROM_H */
-- 
1.8.1.2


