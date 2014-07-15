Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445AbaGODrQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 23:47:16 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:63049 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757444AbaGODqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 23:46:51 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: rth@twiddle.net
Cc: ink@jurassic.park.msu.ru, mattst88@gmail.com, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] alpha: Cleanpatch Remove Errors
Date: Mon, 14 Jul 2014 23:46:40 -0400
Message-Id: <1405396000-4917-5-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405396000-4917-1-git-send-email-xerofoify@gmail.com>
References: <1405396000-4917-1-git-send-email-xerofoify@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes errors on lines 205,206 to fit kernel coding
style.
---
 arch/alpha/boot/bootp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/alpha/boot/bootp.c b/arch/alpha/boot/bootp.c
index 47e33cb..ac0351d 100644
--- a/arch/alpha/boot/bootp.c
+++ b/arch/alpha/boot/bootp.c
@@ -202,8 +202,8 @@ start_kernel(void)
 	load(START_ADDR+(4*KERNEL_SIZE), KERNEL_ORIGIN, KERNEL_SIZE);
 	load(START_ADDR, START_ADDR+(4*KERNEL_SIZE), KERNEL_SIZE);
 
-	memset((char*)ZERO_PGE, 0, PAGE_SIZE);
-	strcpy((char*)ZERO_PGE, envval);
+	memset((char *)ZERO_PGE, 0, PAGE_SIZE);
+	strcpy((char *)ZERO_PGE, envval);
 #ifdef INITRD_IMAGE_SIZE
 	((long *)(ZERO_PGE+256))[0] = initrd_start;
 	((long *)(ZERO_PGE+256))[1] = INITRD_IMAGE_SIZE;
-- 
1.9.1

