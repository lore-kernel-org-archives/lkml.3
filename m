Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667Ab3KSTQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 14:16:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51687 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234Ab3KSTQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 14:16:16 -0500
Date: Tue, 19 Nov 2013 11:15:43 -0800
From: tip-bot for Alex Shi <tipbot@zytor.com>
Message-ID: <tip-b972fc308c2763096b61b62169f2167ee0ca5a19@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, alex.shi@linaro.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, alex.shi@linaro.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1384852912-24791-1-git-send-email-alex.shi@linaro.org>
References: <1384852912-24791-1-git-send-email-alex.shi@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Remove unused variable in '
 struct sched_domain'
Git-Commit-ID: b972fc308c2763096b61b62169f2167ee0ca5a19
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 19 Nov 2013 11:15:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b972fc308c2763096b61b62169f2167ee0ca5a19
Gitweb:     http://git.kernel.org/tip/b972fc308c2763096b61b62169f2167ee0ca5a19
Author:     Alex Shi <alex.shi@linaro.org>
AuthorDate: Tue, 19 Nov 2013 17:21:52 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 19 Nov 2013 17:01:17 +0100

sched: Remove unused variable in 'struct sched_domain'

The 'u64 last_update' variable isn't used now, remove it to save a bit of space.

Signed-off-by: Alex Shi <alex.shi@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Morten.Rasmussen@arm.com
Cc: linaro-kernel@lists.linaro.org
Link: http://lkml.kernel.org/r/1384852912-24791-1-git-send-email-alex.shi@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index f7efc86..b122395 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -823,8 +823,6 @@ struct sched_domain {
 	unsigned int balance_interval;	/* initialise to 1. units in ms. */
 	unsigned int nr_balance_failed; /* initialise to 0 */
 
-	u64 last_update;
-
 	/* idle_balance() stats */
 	u64 max_newidle_lb_cost;
 	unsigned long next_decay_max_lb_cost;
