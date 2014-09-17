Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbaIQKST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 06:18:19 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:20781 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025AbaIQKSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 06:18:17 -0400
Message-ID: <54195FE1.9030607@huawei.com>
Date: Wed, 17 Sep 2014 18:18:09 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] cgroup: remove some useless forward declarations
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020202.54195FE7.003F,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: d4fda0626812f4f4a2c1ff67d7b96b6f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 include/linux/cgroup.h | 1 -
 kernel/cgroup.c        | 2 --
 2 files changed, 3 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index b5223c5..f7898e0 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -27,7 +27,6 @@
 
 struct cgroup_root;
 struct cgroup_subsys;
-struct inode;
 struct cgroup;
 
 extern int cgroup_init_early(void);
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 940aced..0ce9d9e 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -185,7 +185,6 @@ static int need_forkexit_callback __read_mostly;
 static struct cftype cgroup_dfl_base_files[];
 static struct cftype cgroup_legacy_base_files[];
 
-static void cgroup_put(struct cgroup *cgrp);
 static int rebind_subsystems(struct cgroup_root *dst_root,
 			     unsigned int ss_mask);
 static int cgroup_destroy_locked(struct cgroup *cgrp);
@@ -195,7 +194,6 @@ static void css_release(struct percpu_ref *ref);
 static void kill_css(struct cgroup_subsys_state *css);
 static int cgroup_addrm_files(struct cgroup *cgrp, struct cftype cfts[],
 			      bool is_add);
-static void cgroup_pidlist_destroy_all(struct cgroup *cgrp);
 
 /* IDR wrappers which synchronize using cgroup_idr_lock */
 static int cgroup_idr_alloc(struct idr *idr, void *ptr, int start, int end,
-- 
1.8.0.2

