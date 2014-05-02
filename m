Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbaEBNmn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 09:42:43 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:52216 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751643AbaEBNlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 09:41:51 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Jianpeng Ma <majianpeng@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/6] mm/kmemleak.c: Use %u to print ->checksum.
Date: Fri,  2 May 2014 14:41:05 +0100
Message-Id: <1399038070-1540-2-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.12.3
In-Reply-To: <1399038070-1540-1-git-send-email-catalin.marinas@arm.com>
References: <1399038070-1540-1-git-send-email-catalin.marinas@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jianpeng Ma <majianpeng@gmail.com>

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 mm/kmemleak.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 91d67eaee050..3a36e2b16cba 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -387,7 +387,7 @@ static void dump_object_info(struct kmemleak_object *object)
 	pr_notice("  min_count = %d\n", object->min_count);
 	pr_notice("  count = %d\n", object->count);
 	pr_notice("  flags = 0x%lx\n", object->flags);
-	pr_notice("  checksum = %d\n", object->checksum);
+	pr_notice("  checksum = %u\n", object->checksum);
 	pr_notice("  backtrace:\n");
 	print_stack_trace(&trace, 4);
 }
