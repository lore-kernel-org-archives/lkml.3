Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283Ab3HBJZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 05:25:43 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:56806 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab3HBJZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 05:25:42 -0400
Message-ID: <51FB7A94.6010308@huawei.com>
Date: Fri, 2 Aug 2013 17:23:32 +0800
From: Jianguo Wu <wujianguo@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: <sjenning@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: mm/zbud: fix some trivial typos in comments
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.216]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some trivial typos in comments. 

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
---
 mm/zbud.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/zbud.c b/mm/zbud.c
index ad1e781..9451361 100644
--- a/mm/zbud.c
+++ b/mm/zbud.c
@@ -16,7 +16,7 @@
  *
  * zbud works by storing compressed pages, or "zpages", together in pairs in a
  * single memory page called a "zbud page".  The first buddy is "left
- * justifed" at the beginning of the zbud page, and the last buddy is "right
+ * justified" at the beginning of the zbud page, and the last buddy is "right
  * justified" at the end of the zbud page.  The benefit is that if either
  * buddy is freed, the freed buddy space, coalesced with whatever slack space
  * that existed between the buddies, results in the largest possible free region
@@ -243,7 +243,7 @@ void zbud_destroy_pool(struct zbud_pool *pool)
  * gfp should not set __GFP_HIGHMEM as highmem pages cannot be used
  * as zbud pool pages.
  *
- * Return: 0 if success and handle is set, otherwise -EINVAL is the size or
+ * Return: 0 if success and handle is set, otherwise -EINVAL if the size or
  * gfp arguments are invalid or -ENOMEM if the pool was unable to allocate
  * a new page.
  */
-- 
1.7.1




