Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063Ab3CEDiJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 22:38:09 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:17559 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932133Ab3CEDiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 22:38:07 -0500
Message-ID: <51356894.9060501@huawei.com>
Date: Tue, 5 Mar 2013 11:37:56 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH] cpuset: remove include of cgroup.h from cpuset.h
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to include cgroup.h in cpuset.h.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 include/linux/cpuset.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 8c8a60d..ccd1de8 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -11,7 +11,6 @@
 #include <linux/sched.h>
 #include <linux/cpumask.h>
 #include <linux/nodemask.h>
-#include <linux/cgroup.h>
 #include <linux/mm.h>
 
 #ifdef CONFIG_CPUSETS
-- 
1.8.0.2

