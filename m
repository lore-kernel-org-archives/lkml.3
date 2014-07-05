Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbaGEEOs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 00:14:48 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:49672 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbaGEEOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 00:14:46 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: jejb@parisc-linux.org
Cc: deller@gmx.de, joe@perches.com, dave.anglin@bell.net, jkosina@suse.cz,
        tiwai@suse.de, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] parisc: Remove FIXME line in signal.c
Date: Sat,  5 Jul 2014 00:14:42 -0400
Message-Id: <1404533682-6747-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This frame removes a fix me line in signal.c that is no longer
needed as function call is correct.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 arch/parisc/kernel/signal.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/parisc/kernel/signal.c b/arch/parisc/kernel/signal.c
index 1cba8f2..1d550b5 100644
--- a/arch/parisc/kernel/signal.c
+++ b/arch/parisc/kernel/signal.c
@@ -240,7 +240,6 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 #endif
 	
 	usp = (regs->gr[30] & ~(0x01UL));
-	/*FIXME: frame_size parameter is unused, remove it. */
 	frame = get_sigframe(ka, usp, sizeof(*frame));
 
 	DBG(1,"SETUP_RT_FRAME: START\n");
-- 
1.9.1

