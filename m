Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933824AbaEGNXd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:23:33 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:41139 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932919AbaEGNXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:23:31 -0400
Date: Wed, 7 May 2014 09:23:28 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH cgroup/for-3.16] cgroup: remove unused CGRP_SANE_BEHAVIOR
Message-ID: <20140507132328.GE16702@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2b53f41fa8604845f4f7c538723694a453088b15 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Wed, 7 May 2014 09:21:56 -0400

This cgroup flag has never been used.  Only CGRP_ROOT_SANE_BEHAVIOR is
used.  Remove it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
Applied to cgroup/for-3.16.

Thanks.

 include/linux/cgroup.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 2dfabb3..f482f95 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -140,8 +140,6 @@ enum {
 	 * specified at mount time and thus is implemented here.
 	 */
 	CGRP_CPUSET_CLONE_CHILDREN,
-	/* see the comment above CGRP_ROOT_SANE_BEHAVIOR for details */
-	CGRP_SANE_BEHAVIOR,
 };
 
 struct cgroup {
-- 
1.9.0

