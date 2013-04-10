Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936648Ab3DJM1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 08:27:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58718 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab3DJM1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 08:27:21 -0400
Date: Wed, 10 Apr 2013 05:27:02 -0700
From: tip-bot for Libin <tipbot@zytor.com>
Message-ID: <tip-b9b0853a4b377f84a5e6ed091816a9a2d6b10918@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        huawei.libin@huawei.com, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        huawei.libin@huawei.com, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1364814841-49156-1-git-send-email-huawei.libin@huawei.com>
References: <1364814841-49156-1-git-send-email-huawei.libin@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix comment in rebalance_domains()
Git-Commit-ID: b9b0853a4b377f84a5e6ed091816a9a2d6b10918
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 10 Apr 2013 05:27:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b9b0853a4b377f84a5e6ed091816a9a2d6b10918
Gitweb:     http://git.kernel.org/tip/b9b0853a4b377f84a5e6ed091816a9a2d6b10918
Author:     Libin <huawei.libin@huawei.com>
AuthorDate: Mon, 1 Apr 2013 19:14:01 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 10 Apr 2013 13:39:57 +0200

sched: Fix comment in rebalance_domains()

A comment in function rebalance_domains() mentions
arch_init_sched_domains(), but that function does not exist
anymore. The proper function is init_sched_domains().

Signed-off-by: Libin <huawei.libin@huawei.com>
Cc: <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1364814841-49156-1-git-send-email-huawei.libin@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index bf8ab4f..155783b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5466,7 +5466,7 @@ void update_max_interval(void)
  * It checks each scheduling domain to see if it is due to be balanced,
  * and initiates a balancing operation if so.
  *
- * Balancing parameters are set up in arch_init_sched_domains.
+ * Balancing parameters are set up in init_sched_domains.
  */
 static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 {
