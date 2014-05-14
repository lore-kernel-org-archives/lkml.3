Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbaENTCF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:02:05 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:62425 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbaENTCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:02:03 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-arch@vger.kernel.org, arnd@arndb.de, linux-kernel@vger.kernel.org
Cc: Richard Weinberger <richard@nod.at>, Peter Zijlstra <peterz@infradead.org>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        linux-sh@vger.kernel.org
Subject: [PATCH 22/27] sh: Use common bits from generic tlb.h
Date: Wed, 14 May 2014 20:59:54 +0200
Message-Id: <1400093999-18703-23-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1400093999-18703-1-git-send-email-richard@nod.at>
References: <1400093999-18703-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is no longer needed to define them on our own.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: linux-sh@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/sh/include/asm/tlb.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/sh/include/asm/tlb.h b/arch/sh/include/asm/tlb.h
index 62f80d2..7d3f816 100644
--- a/arch/sh/include/asm/tlb.h
+++ b/arch/sh/include/asm/tlb.h
@@ -133,11 +133,6 @@ static inline void tlb_unwire_entry(void)
 
 #else /* CONFIG_MMU */
 
-#define tlb_start_vma(tlb, vma)				do { } while (0)
-#define tlb_end_vma(tlb, vma)				do { } while (0)
-#define __tlb_remove_tlb_entry(tlb, pte, address)	do { } while (0)
-#define tlb_flush(tlb)					do { } while (0)
-
 #include <asm-generic/tlb.h>
 
 #endif /* CONFIG_MMU */
-- 
1.8.4.2

