Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296Ab3ENLtn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 07:49:43 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:60574 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757074Ab3ENLtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 07:49:41 -0400
Message-ID: <519224CE.6030303@gmail.com>
Date: Tue, 14 May 2013 19:49:34 +0800
From: majianpeng <majianpeng@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: catalin.marinas@arm.com
CC: linux-mm <linux-mm@kvack.org>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] mm/kmemleak.c: Use %u to print ->checksum.
Content-Type: multipart/mixed;
 boundary="------------080509040303010101050606"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080509040303010101050606
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 mm/kmemleak.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index c8d7f31..b1525db 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -386,7 +386,7 @@ static void dump_object_info(struct kmemleak_object *object)
     pr_notice("  min_count = %d\n", object->min_count);
     pr_notice("  count = %d\n", object->count);
     pr_notice("  flags = 0x%lx\n", object->flags);
-    pr_notice("  checksum = %d\n", object->checksum);
+    pr_notice("  checksum = %u\n", object->checksum);
     pr_notice("  backtrace:\n");
     print_stack_trace(&trace, 4);
 }
-- 
1.8.3.rc1.44.gb387c77



--------------080509040303010101050606
Content-Type: text/x-patch;
 name="0001-mm-kmemleak.c-Use-u-to-print-checksum.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-mm-kmemleak.c-Use-u-to-print-checksum.patch"

>From d87e9dee5f5c58e71fcc7f8e4e29513a7bfbbad4 Mon Sep 17 00:00:00 2001
From: Jianpeng Ma <majianpeng@gmail.com>
Date: Mon, 13 May 2013 18:33:21 +0800
Subject: [PATCH 1/3] mm/kmemleak.c: Use %u to print ->checksum.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 mm/kmemleak.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index c8d7f31..b1525db 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -386,7 +386,7 @@ static void dump_object_info(struct kmemleak_object *object)
 	pr_notice("  min_count = %d\n", object->min_count);
 	pr_notice("  count = %d\n", object->count);
 	pr_notice("  flags = 0x%lx\n", object->flags);
-	pr_notice("  checksum = %d\n", object->checksum);
+	pr_notice("  checksum = %u\n", object->checksum);
 	pr_notice("  backtrace:\n");
 	print_stack_trace(&trace, 4);
 }
-- 
1.8.3.rc1.44.gb387c77


--------------080509040303010101050606--
