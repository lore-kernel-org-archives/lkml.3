Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556AbaK2KOa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 05:14:30 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:48617 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbaK2KO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 05:14:29 -0500
From: Ren Kimura <rkx1209@gmail.com>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, RKX1209 <rkx1209@gmail.com>
Subject: [PATCH] Fixed type id
Date: Sat, 29 Nov 2014 19:13:18 +0900
Message-Id: <1417255998-8373-1-git-send-email-rkx1209@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: RKX1209 <rkx1209@gmail.com>

Signed-off-by: RKX1209 <rkx1209@gmail.com>
---
 arch/x86/mm/init_32.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index c8140e1..957f7f0 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -304,14 +304,14 @@ repeat:
 #endif
 		for (; pmd_idx < PTRS_PER_PMD && pfn < end_pfn;
 		     pmd++, pmd_idx++) {
-			unsigned int addr = pfn * PAGE_SIZE + PAGE_OFFSET;
+			unsigned long addr = pfn * PAGE_SIZE + PAGE_OFFSET;
 
 			/*
 			 * Map with big pages if possible, otherwise
 			 * create normal page tables:
 			 */
 			if (use_pse) {
-				unsigned int addr2;
+				unsigned long addr2;
 				pgprot_t prot = PAGE_KERNEL_LARGE;
 				/*
 				 * first pass will use the same initial
-- 
1.9.1

