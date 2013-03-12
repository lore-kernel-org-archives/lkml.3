Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331Ab3CLGu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 02:50:27 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:55876 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab3CLGuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 02:50:21 -0400
Message-ID: <513ED029.4090104@huawei.com>
Date: Tue, 12 Mar 2013 14:50:17 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 2/8] cgroup: remove unused variables in cgroup_destroy_locked()
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
 kernel/cgroup.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 02b02ca..71bc33d 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4347,10 +4347,8 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 {
 	struct dentry *d = cgrp->dentry;
 	struct cgroup *parent = cgrp->parent;
-	DEFINE_WAIT(wait);
 	struct cgroup_event *event, *tmp;
 	struct cgroup_subsys *ss;
-	LIST_HEAD(tmp_list);
 
 	lockdep_assert_held(&d->d_inode->i_mutex);
 	lockdep_assert_held(&cgroup_mutex);
-- 
1.8.0.2
