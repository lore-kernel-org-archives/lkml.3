Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933256Ab3GCUwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 16:52:43 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:47395 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933059Ab3GCUwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 16:52:41 -0400
Message-ID: <1372884741.11138.0.camel@lizardlounge>
Subject: [PATCH] jbd: remove unneeded semicolon
From: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
To: akpm@linux-foundation.org, jack@suse.cz
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
Date: Wed, 03 Jul 2013 13:52:21 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes an unnecessary semicolon that was placed after the closing
bracket of an inline JBD wrapper function.

Signed-off-by: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
---
diff --git a/include/linux/jbd.h b/include/linux/jbd.h
index 7e0b622..9d789a9 100644
--- a/include/linux/jbd.h
+++ b/include/linux/jbd.h
@@ -78,7 +78,7 @@ static inline void *jbd_alloc(size_t size, gfp_t flags)
 static inline void jbd_free(void *ptr, size_t size)
 {
 	free_pages((unsigned long)ptr, get_order(size));
-};
+}
 
 #define JFS_MIN_JOURNAL_BLOCKS 1024
 





