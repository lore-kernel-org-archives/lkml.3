Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915AbaEESIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 14:08:17 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:42418 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751013AbaEESIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 14:08:15 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoEJABLTZ1NbsEtU/2dsb2JhbABZgwarUQcBAgUBmgyBFxd0glMTHCMYgQIkE4hFAcwdhVaIfIRGAQOPGooZAZJ0gzY7
Date: Mon, 5 May 2014 20:08:13 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Tejun Heo <tj@kernel.org>, akpm <akpm@linux-foundation.org>
Subject: [PATCH V2] kernel/cgroup.c: fix 2 kernel-doc warnings
Message-Id: <20140505200813.666c716451ae68f156649753@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix typo and variable name.

Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/cgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 9fcdaa7..4c2f2f2 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1737,7 +1737,7 @@ struct task_struct *cgroup_taskset_next(struct cgroup_taskset *tset)
 
 /**
  * cgroup_task_migrate - move a task from one cgroup to another.
- * @old_cgrp; the cgroup @tsk is being migrated from
+ * @old_cgrp: the cgroup @tsk is being migrated from
  * @tsk: the task being migrated
  * @new_cset: the new css_set @tsk is being attached to
  *
@@ -4053,7 +4053,7 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 
 /**
  * cgroup_destroy_css_killed - the second step of cgroup destruction
- * @work: cgroup->destroy_free_work
+ * @cgrp: cgroup->destroy_free_work
  *
  * This function is invoked from a work item for a cgroup which is being
  * destroyed after all css's are offlined and performs the rest of
-- 
1.9.1
