Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840AbaAJIW0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 03:22:26 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:15171 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbaAJIWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 03:22:24 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-fb-52cfadbe5d9a
From: Cai Liu <cai.liu@samsung.com>
To: bob.liu@oracle.com, linux-kernel@vger.kernel.org
Subject: [PATCH] mm/zbud: correct some comments
Date: Fri, 10 Jan 2014 16:21:46 +0800
Message-id: <001801cf0ddd$16210530$42630f90$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac8N3IKkS2oYN7W9Q4KH5t0RnkppOw==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t9jAd19a88HGXzZamTRdWoqi8XlXXPY
	HJg8Pj69xeLxeZNcAFMUl01Kak5mWWqRvl0CV8aGjY+YC55wVjQ9/sLawHiKvYuRk0NCwERi
	6rG5LBC2mMSFe+vZuhi5OIQEFjFKXO3+yQTh/GCU+PmsmRWkik1AWeLBg+mMILYIUPf5s6fB
	4sIC+hK3J+xgArFZBFQlLh2ZCmbzClhKLDz9mA3CFpT4Mfke2DZmAS2J9TuPM0HY8hKb17xl
	hrhCQWLH2ddQ8/UkmvZsZ4WoEZfYeOQWywRG/llIRs1CMmoWklGzkLQsYGRZxSiaWpBcUJyU
	nmuoV5yYW1yal66XnJ+7iREcls+kdjCubLA4xCjAwajEw1sw63yQEGtiWXFl7iFGCQ5mJRHe
	5lagEG9KYmVValF+fFFpTmrxIUZpDhYlcd4DrdaBQgLpiSWp2ampBalFMFkmDk6pBsZZlqHn
	O7ecWzF/9VVHvnJ+jXPlW410+BqqYv7Z52be31NgG/vmuQ2DluQ3jfZFJfdbVzP3bvDZ8Pr9
	v7ijM499+OmbI/GMNTxnvpB/m0tJp6iknqfG2hvCPXdvt6ZKPxBaKLK7ITLmsNQqOUmVRaGu
	L+dP+MMU6F7Eo71VgDs7e7pbe5yxuRJLcUaioRZzUXEiAPXz6rlHAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zswap uses zbud now. So change zsmalloc to zbud.

Signed-off-by: Cai Liu <cai.liu@samsung.com>
---
 mm/zswap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 5a63f78..d93afa6 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -165,7 +165,7 @@ static void zswap_comp_exit(void)
  *            be held while changing the refcount.  Since the lock must
  *            be held, there is no reason to also make refcount atomic.
  * offset - the swap offset for the entry.  Index into the red-black tree.
- * handle - zsmalloc allocation handle that stores the compressed page data
+ * handle - zbud allocation handle that stores the compressed page data
  * length - the length in bytes of the compressed page data.  Needed during
  *           decompression
  */
@@ -282,7 +282,7 @@ static void zswap_rb_erase(struct rb_root *root, struct
zswap_entry *entry)
 }
 
 /*
- * Carries out the common pattern of freeing and entry's zsmalloc
allocation,
+ * Carries out the common pattern of freeing and entry's zbud allocation,
  * freeing the entry itself, and decrementing the number of stored pages.
  */
 static void zswap_free_entry(struct zswap_tree *tree,
-- 
1.7.10.4

