Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296AbaGADFG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 23:05:06 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:52169 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbaGADFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 23:05:04 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: hskinnemoen@gmail.com
Cc: egtvedt@samfundet.no, linux-kernel@vger.kernel.org
Subject: [PATCH] Remove memory start and memory end
Date: Mon, 30 Jun 2014 23:04:59 -0400
Message-Id: <1404183899-5953-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the uneeded variables memory start and memory
stated in FIXME message before declaring this variables as extern
unsigned longs.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 arch/avr32/include/asm/page.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/avr32/include/asm/page.h b/arch/avr32/include/asm/page.h
index f805d1c..16ac83a 100644
--- a/arch/avr32/include/asm/page.h
+++ b/arch/avr32/include/asm/page.h
@@ -42,9 +42,6 @@ typedef struct page *pgtable_t;
 #define __pgd(x)		((pgd_t) { (x) })
 #define __pgprot(x)		((pgprot_t) { (x) })
 
-/* FIXME: These should be removed soon */
-extern unsigned long memory_start, memory_end;
-
 /* Pure 2^n version of get_order */
 static inline int get_order(unsigned long size)
 {
-- 
1.9.1

