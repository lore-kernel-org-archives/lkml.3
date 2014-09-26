Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbaIZRtP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 13:49:15 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:52308 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755080AbaIZRtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 13:49:14 -0400
Message-ID: <1411753752.7866.68.camel@x220>
Subject: [PATCH] [TRIVIAL] powerpc: Fix comment typo 'CONIFG_8xx'
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 26 Sep 2014 19:49:12 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Sep 2014 17:49:12.0673 (UTC) FILETIME=[2EA0CD10:01CFD9B2]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Still untested!

 arch/powerpc/mm/mmu_decl.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/mmu_decl.h b/arch/powerpc/mm/mmu_decl.h
index 9615d82919b8..78c45f392f5b 100644
--- a/arch/powerpc/mm/mmu_decl.h
+++ b/arch/powerpc/mm/mmu_decl.h
@@ -67,7 +67,7 @@ static inline void _tlbil_va(unsigned long address, unsigned int pid,
 {
 	__tlbil_va(address, pid);
 }
-#endif /* CONIFG_8xx */
+#endif /* CONFIG_8xx */
 
 #if defined(CONFIG_PPC_BOOK3E) || defined(CONFIG_PPC_47x)
 extern void _tlbivax_bcast(unsigned long address, unsigned int pid,
-- 
1.9.3

