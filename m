Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbaAJIzd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 03:55:33 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:22777 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaAJIzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 03:55:31 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-4a-52cfb581d68f
From: Cai Liu <cai.liu@samsung.com>
To: bob.liu@oracle.com, linux-kernel@vger.kernel.org
Subject: [PATCH] mm/zswap: correct some comments
Date: Fri, 10 Jan 2014 16:54:48 +0800
Message-id: <001a01cf0de1$b3e02e50$1ba08af0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac8N4WjbHFjx9vwqTFangGZ2/qP2Sg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsVy+t9jAd3GreeDDBp71S26Tk1lsbi8aw6b
	A5PHx6e3WDw+b5ILYIrisklJzcksSy3St0vgyvi6tZu14D1nxen+mWwNjNfYuxg5OSQETCTe
	nzjIDGGLSVy4t54NxBYSWMQoMaFJuYuRC8j+wSjxZXYbK0iCTUBZ4sGD6YwgtghQ8/mzp8Hi
	wgIGEs2fpzGB2CwCqhLNt46wgNi8ApYSm25uYYKwBSV+TL4HFmcW0JJYv/M4E4QtL7F5zVuo
	IxQkdpx9DTVfT2Lq7DaoenGJjUdusUxg5J+FZNQsJKNmIRk1C0nLAkaWVYyiqQXJBcVJ6blG
	esWJucWleel6yfm5mxjBQflMegfjqgaLQ4wCHIxKPLwFs84HCbEmlhVX5h5ilOBgVhLhXbYR
	KMSbklhZlVqUH19UmpNafIhRmoNFSZz3YKt1oJBAemJJanZqakFqEUyWiYNTqoGxdn26G+vR
	/znLN4tP85AIeZk0u24j0yL2o99mT5ff/8bz86mQ/7YsEWfk+T9FvPsyWzbv/SMN1he5jmnf
	7h6x8ue19dq7526LmIZi2ofGbXv/aaQ5Ry3j+8Nz69LTO5yH2mpSP37Y827jsS+GO6uF/ZVC
	tthPEJ+vuKv00+vr5/5mFp/wXDGfTYmlOCPRUIu5qDgRAAAmcRNGAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zswap uses zbud now. So change comments "zsmalloc" to "zbud".

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
@@ -282,7 +282,7 @@ static void zswap_rb_erase(struct rb_root *root, struct zswap_entry *entry)
 }
 
 /*
- * Carries out the common pattern of freeing and entry's zsmalloc allocation,
+ * Carries out the common pattern of freeing and entry's zbud allocation,
  * freeing the entry itself, and decrementing the number of stored pages.
  */
 static void zswap_free_entry(struct zswap_tree *tree,
-- 
1.7.10.4

