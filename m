Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345AbaESNLu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:11:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59489 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653AbaESNLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 09:11:46 -0400
Date: Mon, 19 May 2014 06:10:36 -0700
From: "tip-bot for xiaofeng.yan" <tipbot@zytor.com>
Message-ID: <tip-c07a16f784dfb8083c3b0157fbef18cb1292b9fc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, xiaofeng.yan@huawei.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, xiaofeng.yan@huawei.com
In-Reply-To: <1399605687-18094-1-git-send-email-xiaofeng.yan@huawei.com>
References: <1399605687-18094-1-git-send-email-xiaofeng.yan@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/rt:
  Fix a comment in struct sched_dl_entity
Git-Commit-ID: c07a16f784dfb8083c3b0157fbef18cb1292b9fc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c07a16f784dfb8083c3b0157fbef18cb1292b9fc
Gitweb:     http://git.kernel.org/tip/c07a16f784dfb8083c3b0157fbef18cb1292b9fc
Author:     xiaofeng.yan <xiaofeng.yan@huawei.com>
AuthorDate: Fri, 9 May 2014 03:21:27 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 19 May 2014 22:02:42 +0900

sched/rt: Fix a comment in struct sched_dl_entity

Change sched_setscheduler2() to sched_setattr() in the comments.
There isn't function sched_setscheduler2() in the main line.
The previous EDF version defines this function
before being merged into the main line.
User should use sched_setattr() instead of
sched_setscheduler2() now.

Cc: mingo@redhat.com
Signed-off-by: xiaofeng.yan <xiaofeng.yan@huawei.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1399605687-18094-1-git-send-email-xiaofeng.yan@huawei.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/sched.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 725eef1..0f91d00 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1175,8 +1175,8 @@ struct sched_dl_entity {
 
 	/*
 	 * Original scheduling parameters. Copied here from sched_attr
-	 * during sched_setscheduler2(), they will remain the same until
-	 * the next sched_setscheduler2().
+	 * during sched_setattr(), they will remain the same until
+	 * the next sched_setattr().
 	 */
 	u64 dl_runtime;		/* maximum runtime for each instance	*/
 	u64 dl_deadline;	/* relative deadline of each instance	*/
