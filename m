Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbaEESel (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 14:34:41 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:52245 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaEESek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 14:34:40 -0400
Date: Mon, 5 May 2014 14:34:36 -0400
From: Tejun Heo <tj@kernel.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH] kernel/cgroup.c: fix 2 kernel-doc warnings
Message-ID: <20140505183436.GP11231@htj.dyndns.org>
References: <20140505200813.666c716451ae68f156649753@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140505200813.666c716451ae68f156649753@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied to cgroup/for-3.16 with the actual argument description
updated.

Thanks.
------ 8< ------
>From 60106946ca7f63396680130b25511ccf6b7d5bff Mon Sep 17 00:00:00 2001
From: Fabian Frederick <fabf@skynet.be>
Date: Mon, 5 May 2014 20:08:13 +0200

Fix typo and variable name.

tj: Updated @cgrp argument description in cgroup_destroy_css_killed()

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a1a20e8..07815ef 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1888,7 +1888,7 @@ struct task_struct *cgroup_taskset_next(struct cgroup_taskset *tset)
 
 /**
  * cgroup_task_migrate - move a task from one cgroup to another.
- * @old_cgrp; the cgroup @tsk is being migrated from
+ * @old_cgrp: the cgroup @tsk is being migrated from
  * @tsk: the task being migrated
  * @new_cset: the new css_set @tsk is being attached to
  *
@@ -4586,7 +4586,7 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 
 /**
  * cgroup_destroy_css_killed - the second step of cgroup destruction
- * @work: cgroup->destroy_free_work
+ * @cgrp: the cgroup whose csses have just finished offlining
  *
  * This function is invoked from a work item for a cgroup which is being
  * destroyed after all css's are offlined and performs the rest of
-- 
1.9.0

