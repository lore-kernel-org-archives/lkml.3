Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965230Ab3IEMQu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 08:16:50 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:36318 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab3IEMQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 08:16:47 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] m68k: Export flush_icache_user_range() (needed by lustre)
Date: Thu,  5 Sep 2013 14:16:17 +0200
Message-Id: <1378383377-24639-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ERROR: "flush_icache_user_range" [drivers/staging/lustre/lustre/libcfs/libcfs.ko] undefined!

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/mm/cache.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/m68k/mm/cache.c b/arch/m68k/mm/cache.c
index 3d84c1f..a19c888 100644
--- a/arch/m68k/mm/cache.c
+++ b/arch/m68k/mm/cache.c
@@ -133,4 +133,5 @@ void flush_icache_user_range(struct vm_area_struct *vma, struct page *page,
 			      : "di" (FLUSH_I));
 	}
 }
+EXPORT_SYMBOL_GPL(flush_icache_user_range);
 
-- 
1.7.9.5

