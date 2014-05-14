Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904AbaENTBD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:01:03 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:62412 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbaENTAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:00:49 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-arch@vger.kernel.org, arnd@arndb.de, linux-kernel@vger.kernel.org
Cc: Richard Weinberger <richard@nod.at>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Subject: [PATCH 06/27] avr32: Use common bits from generic tlb.h
Date: Wed, 14 May 2014 20:59:38 +0200
Message-Id: <1400093999-18703-7-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1400093999-18703-1-git-send-email-richard@nod.at>
References: <1400093999-18703-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is no longer needed to define them on our own.

Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/avr32/include/asm/tlb.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/avr32/include/asm/tlb.h b/arch/avr32/include/asm/tlb.h
index 5c55f9c..2e5601d 100644
--- a/arch/avr32/include/asm/tlb.h
+++ b/arch/avr32/include/asm/tlb.h
@@ -14,13 +14,6 @@
 #define tlb_end_vma(tlb, vma) \
 	flush_tlb_range(vma, vma->vm_start, vma->vm_end)
 
-#define __tlb_remove_tlb_entry(tlb, pte, address) do { } while(0)
-
-/*
- * Flush whole TLB for MM
- */
-#define tlb_flush(tlb) flush_tlb_mm((tlb)->mm)
-
 #include <asm-generic/tlb.h>
 
 /*
-- 
1.8.4.2

