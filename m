Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbaFXFu3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 01:50:29 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:48238 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbaFXFuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 01:50:24 -0400
Message-ID: <53A9116B.9030004@gmail.com>
Date: Tue, 24 Jun 2014 13:49:31 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Andi Kleen <ak@linux.intel.com>,
        Vladimir Cernov <gg.kaspersky@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mm: update the description for madvise_remove
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Currently, we have more filesystems supporting fallocate, e.g
ext4/btrfs. Remove the outdated comment for madvise_remove.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 mm/madvise.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index a402f8f..0938b30 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -292,9 +292,6 @@ static long madvise_dontneed(struct vm_area_struct *vma,
 /*
  * Application wants to free up the pages and associated backing store.
  * This is effectively punching a hole into the middle of a file.
- *
- * NOTE: Currently, only shmfs/tmpfs is supported for this operation.
- * Other filesystems return -ENOSYS.
  */
 static long madvise_remove(struct vm_area_struct *vma,
                                struct vm_area_struct **prev,
-- 
1.8.3.2

