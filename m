Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760436AbaGPDA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 23:00:29 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:51382 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaGPDAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 23:00:24 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: rth@twiddle.net
Cc: ink@jurassic.park.msu.ru, mattst88@gmail.com, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/6 v2] alpha: Join lines and merge strings for the two lines
Date: Tue, 15 Jul 2014 23:00:18 -0400
Message-Id: <1405479618-3808-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch merges lines 92 and 93. In addition it merges the strings on
both lines by removing the quotes around the seperate strings. This is 
needed to remove the final checkpatch error I get from running it on 
bootpz.c

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 arch/alpha/boot/bootpz.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/alpha/boot/bootpz.c b/arch/alpha/boot/bootpz.c
index d6ad191..51122f7 100644
--- a/arch/alpha/boot/bootpz.c
+++ b/arch/alpha/boot/bootpz.c
@@ -89,8 +89,7 @@ check_range(unsigned long vstart, unsigned long vend,
 		if (kaddr >= kstart && kaddr <= kend)
 		{
 #ifdef DEBUG_CHECK_RANGE
-			srm_printk("OVERLAP: vaddr 0x%lx kaddr 0x%lx"
-				   " [0x%lx:0x%lx]\n",
+			srm_printk("OVERLAP: vaddr 0x%lx kaddr 0x%lx [0x%lx:0x%lx]\n",
 				   vaddr, kaddr, kstart, kend);
 #endif
 			return 1;
-- 
1.9.1

