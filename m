Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932977Ab3CEDiG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 22:38:06 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:17520 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932133Ab3CEDiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 22:38:04 -0500
Message-ID: <5135688E.5080604@huawei.com>
Date: Tue, 5 Mar 2013 11:37:50 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH] res_counter: remove include of cgroup.h from res_counter.h
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not needed at all.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 include/linux/res_counter.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
index 5ae8456..a83a849 100644
--- a/include/linux/res_counter.h
+++ b/include/linux/res_counter.h
@@ -13,7 +13,7 @@
  * info about what this counter is.
  */
 
-#include <linux/cgroup.h>
+#include <linux/spinlock.h>
 
 /*
  * The core object. the cgroup that wishes to account for some
-- 
1.8.0.2

