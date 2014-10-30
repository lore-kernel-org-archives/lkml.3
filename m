Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933557AbaJ3NIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 09:08:17 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:49133 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933133AbaJ3NIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 09:08:12 -0400
From: Isamu Mogi <isamu@leafytree.jp>
To: ralf@linux-mips.org
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        isamu@leafytree.jp
Subject: [PATCH v2 3/3] MIPS: R3000: Remove redundant parentheses
Date: Thu, 30 Oct 2014 22:07:38 +0900
Message-Id: <1414674458-7583-4-git-send-email-isamu@leafytree.jp>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414674458-7583-1-git-send-email-isamu@leafytree.jp>
References: <1410278429-8541-1-git-send-email-isamu@leafytree.jp>
 <1414674458-7583-1-git-send-email-isamu@leafytree.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Isamu Mogi <isamu@leafytree.jp>
---
 arch/mips/lib/r3k_dump_tlb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/lib/r3k_dump_tlb.c b/arch/mips/lib/r3k_dump_tlb.c
index c97bb70..975a138 100644
--- a/arch/mips/lib/r3k_dump_tlb.c
+++ b/arch/mips/lib/r3k_dump_tlb.c
@@ -44,7 +44,7 @@ static void dump_tlb(int first, int last)
 
 			printk("va=%08lx asid=%08lx"
 			       "  [pa=%06lx n=%d d=%d v=%d g=%d]",
-			       (entryhi & PAGE_MASK),
+			       entryhi & PAGE_MASK,
 			       entryhi & ASID_MASK,
 			       entrylo0 & PAGE_MASK,
 			       (entrylo0 & (1 << 11)) ? 1 : 0,
-- 
1.9.1

