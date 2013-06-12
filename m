Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154Ab3FLUsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 16:48:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41476 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086Ab3FLUsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 16:48:30 -0400
Date: Wed, 12 Jun 2013 13:47:05 -0700
From: tip-bot for Michael Wang <tipbot@zytor.com>
Message-ID: <tip-e8747f10ba3f7638b1c1fcab9c66a01733213d45@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        alex.shi@intel.com, fenghua.yu@intel.com, wangyun@linux.vnet.ibm.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        alex.shi@intel.com, fenghua.yu@intel.com, wangyun@linux.vnet.ibm.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <51AD8902.60603@linux.vnet.ibm.com>
References: <51AD8902.60603@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86, cleanups:
  Remove extra tab in __flush_tlb_one()
Git-Commit-ID: e8747f10ba3f7638b1c1fcab9c66a01733213d45
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 12 Jun 2013 13:47:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e8747f10ba3f7638b1c1fcab9c66a01733213d45
Gitweb:     http://git.kernel.org/tip/e8747f10ba3f7638b1c1fcab9c66a01733213d45
Author:     Michael Wang <wangyun@linux.vnet.ibm.com>
AuthorDate: Tue, 4 Jun 2013 14:28:18 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 4 Jun 2013 11:51:26 -0700

x86, cleanups: Remove extra tab in __flush_tlb_one()

Remove the extra tab in __flush_tlb_one().

CC: Alex Shi <alex.shi@intel.com>
CC: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/51AD8902.60603@linux.vnet.ibm.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/tlbflush.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 50a7fc0..cf51200 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -62,7 +62,7 @@ static inline void __flush_tlb_all(void)
 
 static inline void __flush_tlb_one(unsigned long addr)
 {
-		__flush_tlb_single(addr);
+	__flush_tlb_single(addr);
 }
 
 #define TLB_FLUSH_ALL	-1UL
