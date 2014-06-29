Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbaF2KVq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 06:21:46 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:38918 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbaF2KVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 06:21:45 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH -trivial 1/4] powerpc/simpleboot: Spelling s/trucate/truncate/
Date: Sun, 29 Jun 2014 12:21:36 +0200
Message-Id: <1404037299-31570-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@lists.ozlabs.org
---
 arch/powerpc/boot/simpleboot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/boot/simpleboot.c b/arch/powerpc/boot/simpleboot.c
index 21cd48074ec8..9f8c678f0d9a 100644
--- a/arch/powerpc/boot/simpleboot.c
+++ b/arch/powerpc/boot/simpleboot.c
@@ -61,7 +61,7 @@ void platform_init(unsigned long r3, unsigned long r4, unsigned long r5,
 		if (*reg++ != 0)
 			fatal("Memory range is not based at address 0\n");
 
-	/* get the memsize and trucate it to under 4G on 32 bit machines */
+	/* get the memsize and truncate it to under 4G on 32 bit machines */
 	memsize64 = 0;
 	for (i = 0; i < *ns; i++)
 		memsize64 = (memsize64 << 32) | *reg++;
-- 
1.9.1

