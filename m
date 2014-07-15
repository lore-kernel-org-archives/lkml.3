Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933267AbaGOTS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 15:18:27 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:48707 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933213AbaGOTSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 15:18:20 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: rth@twiddle.net
Cc: ink@jurassic.park.msu.ru, mattst88@gmail.com, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] alpha: Fix while statement
Date: Tue, 15 Jul 2014 15:18:10 -0400
Message-Id: <1405451890-6057-5-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405451890-6057-1-git-send-email-xerofoify@gmail.com>
References: <1405451890-6057-1-git-send-email-xerofoify@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the if statement on line 147 of misc.c to have parthesises
around itself removing a checkpatch error on this line.
---
 arch/alpha/boot/misc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/alpha/boot/misc.c b/arch/alpha/boot/misc.c
index 886e469..56c3325 100644
--- a/arch/alpha/boot/misc.c
+++ b/arch/alpha/boot/misc.c
@@ -144,7 +144,7 @@ static void error(char *x)
 	puts(x);
 	puts("\n\n -- System halted");
 
-	while (1);
+	while{ (1); }
 	/* Halt */
 }
 
-- 
1.9.1

