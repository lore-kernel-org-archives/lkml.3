Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932831AbaGOSTK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 14:19:10 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:47620 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757199AbaGOSSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 14:18:33 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: rth@twiddle.net
Cc: ink@jurassic.park.msu.ru, mattst88@gmail.com, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] alpha: Add line below declartion on line 287
Date: Tue, 15 Jul 2014 14:18:23 -0400
Message-Id: <1405448304-3724-5-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405448304-3724-1-git-send-email-xerofoify@gmail.com>
References: <1405448304-3724-1-git-send-email-xerofoify@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a line before the declartion of asm_sp in order
to fix a checkpatch error I get when running it on this file.
---
 arch/alpha/boot/bootpz.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/alpha/boot/bootpz.c b/arch/alpha/boot/bootpz.c
index 6dd34e4..6fc840d 100644
--- a/arch/alpha/boot/bootpz.c
+++ b/arch/alpha/boot/bootpz.c
@@ -285,6 +285,7 @@ start_kernel(void)
 	 */
 	static long nbytes;
 	static char envval[256] __attribute__((aligned(8)));
+
 	register unsigned long asm_sp asm("30");
 
 	SP_on_entry = asm_sp;
-- 
1.9.1

