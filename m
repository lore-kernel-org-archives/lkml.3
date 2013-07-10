Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945Ab3GJSHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 14:07:21 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:54704 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769Ab3GJSHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:07:20 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Daney <david.daney@cavium.com>, Michal Marek <mmarek@suse.cz>
Subject: [PATCH] scripts: remove unused function in sortextable.c
Date: Wed, 10 Jul 2013 23:33:38 +0530
Message-Id: <1373479418-7079-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.3.2.736.g869de25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: David Daney <david.daney@cavium.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 Trivial.  I wonder why make didn't tell us?

 scripts/sortextable.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/scripts/sortextable.c b/scripts/sortextable.c
index f9ce116..7c2310c 100644
--- a/scripts/sortextable.c
+++ b/scripts/sortextable.c
@@ -64,14 +64,6 @@ fail_file(void)
 	longjmp(jmpenv, SJ_FAIL);
 }
 
-static void __attribute__((noreturn))
-succeed_file(void)
-{
-	cleanup();
-	longjmp(jmpenv, SJ_SUCCEED);
-}
-
-
 /*
  * Get the whole file as a programming convenience in order to avoid
  * malloc+lseek+read+free of many pieces.  If successful, then mmap
-- 
1.8.3.2.736.g869de25

