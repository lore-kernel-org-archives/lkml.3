Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329Ab3CLGxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 02:53:46 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:44655 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755113Ab3CLGxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 02:53:44 -0400
Message-ID: <513ED0E2.20302@huawei.com>
Date: Tue, 12 Mar 2013 14:53:22 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 6/8] cgroup: remove unneeded includes from cgroup.h
References: <513ED010.5060906@huawei.com>
In-Reply-To: <513ED010.5060906@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 include/linux/cgroup.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 7e818a3..1f75a59 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -9,11 +9,8 @@
  */
 
 #include <linux/sched.h>
-#include <linux/cpumask.h>
-#include <linux/nodemask.h>
 #include <linux/rcupdate.h>
 #include <linux/rculist.h>
-#include <linux/cgroupstats.h>
 #include <linux/prio_heap.h>
 #include <linux/rwsem.h>
 #include <linux/idr.h>
@@ -22,6 +19,7 @@
 
 #ifdef CONFIG_CGROUPS
 
+struct cgroupstats;
 struct cgroupfs_root;
 struct cgroup_subsys;
 struct inode;
-- 1.8.0.2 
