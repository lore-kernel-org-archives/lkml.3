Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794AbaGOSSk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 14:18:40 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:41193 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418AbaGOSSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 14:18:33 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: rth@twiddle.net
Cc: ink@jurassic.park.msu.ru, mattst88@gmail.com, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] alpha: Join lines 90 and 91
Date: Tue, 15 Jul 2014 14:18:24 -0400
Message-Id: <1405448304-3724-6-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405448304-3724-1-git-send-email-xerofoify@gmail.com>
References: <1405448304-3724-1-git-send-email-xerofoify@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the checkpatch error I get in this file relating to a
quoted string needed to be joined to the line above it.
---
 arch/alpha/boot/bootpz.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/alpha/boot/bootpz.c b/arch/alpha/boot/bootpz.c
index 6fc840d..a9e127b 100644
--- a/arch/alpha/boot/bootpz.c
+++ b/arch/alpha/boot/bootpz.c
@@ -87,8 +87,7 @@ check_range(unsigned long vstart, unsigned long vend,
 		kaddr = (find_pa(vaddr) | PAGE_OFFSET);
 		if (kaddr >= kstart && kaddr <= kend) {
 #ifdef DEBUG_CHECK_RANGE
-			srm_printk("OVERLAP: vaddr 0x%lx kaddr 0x%lx"
-				   " [0x%lx:0x%lx]\n",
+			srm_printk("OVERLAP: vaddr 0x%lx kaddr 0x%lx" " [0x%lx:0x%lx]\n",
 				   vaddr, kaddr, kstart, kend);
 #endif
 			return 1;
-- 
1.9.1

