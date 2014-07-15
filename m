Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355AbaGODrN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 23:47:13 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:48615 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757387AbaGODqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 23:46:51 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: rth@twiddle.net
Cc: ink@jurassic.park.msu.ru, mattst88@gmail.com, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] alpha: Fix if statment in bootp.c
Date: Mon, 14 Jul 2014 23:46:39 -0400
Message-Id: <1405396000-4917-4-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405396000-4917-1-git-send-email-xerofoify@gmail.com>
References: <1405396000-4917-1-git-send-email-xerofoify@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the if statement on line 180 to be changed to having
no brackets as defined by kernel coding style for one line if statements.
---
 arch/alpha/boot/bootp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/alpha/boot/bootp.c b/arch/alpha/boot/bootp.c
index 6227e4f..47e33cb 100644
--- a/arch/alpha/boot/bootp.c
+++ b/arch/alpha/boot/bootp.c
@@ -177,9 +177,8 @@ start_kernel(void)
 	move_stack(initrd_start - PAGE_SIZE);
 
 	nbytes = callback_getenv(ENV_BOOTED_OSFLAGS, envval, sizeof(envval));
-	if (nbytes < 0 || nbytes >= sizeof(envval)) {
+	if (nbytes < 0 || nbytes >= sizeof(envval))
 		nbytes = 0;
-	}
 	envval[nbytes] = '\0';
 	srm_printk("Loading the kernel...'%s'\n", envval);
 
-- 
1.9.1

