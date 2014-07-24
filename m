Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757704AbaGXJmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:42:54 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:49697 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756727AbaGXJmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:42:51 -0400
From: "Raymond L. Rivera" <ray.l.rivera@gmail.com>
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "Raymond L. Rivera" <ray.l.rivera@gmail.com>
Subject: [PATCH 2/2] linux/pagemap.h: Fixed a typo in a code comment.
Date: Thu, 24 Jul 2014 02:39:45 -0700
Message-Id: <1406194785-19596-3-git-send-email-ray.l.rivera@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406194785-19596-1-git-send-email-ray.l.rivera@gmail.com>
References: <1406194785-19596-1-git-send-email-ray.l.rivera@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrected a minor typo in a code comment where 'be' was missing.

Signed-off-by: Raymond L. Rivera <ray.l.rivera@gmail.com>
---
 include/linux/pagemap.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 0a97b58..bcabdbe 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -96,7 +96,7 @@ static inline void mapping_set_gfp_mask(struct address_space *m, gfp_t mask)
 }
 
 /*
- * The page cache can done in larger chunks than
+ * The page cache can be done in larger chunks than
  * one page, because it allows for more efficient
  * throughput (it can then be mapped into user
  * space in smaller chunks for same flexibility).
-- 
1.9.1

