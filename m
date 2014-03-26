Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbaCZABH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 20:01:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34215 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253AbaCZABC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 20:01:02 -0400
Date: Tue, 25 Mar 2014 17:00:42 -0700
From: tip-bot for Viresh Kumar <tipbot@zytor.com>
Message-ID: <tip-cacb3c76c2012ade52124e8c6fdc5cb125625772@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        viresh.kumar@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        viresh.kumar@linaro.org, tglx@linutronix.de
In-Reply-To: <2b29ca4230c163e44179941d7c7a16c1474385c2.1395743878.git.viresh.kumar@linaro.org>
References: <2b29ca4230c163e44179941d7c7a16c1474385c2.1395743878.git.viresh.kumar@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] tick:
  Fix spelling mistake in tick_handle_periodic()
Git-Commit-ID: cacb3c76c2012ade52124e8c6fdc5cb125625772
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

Commit-ID:  cacb3c76c2012ade52124e8c6fdc5cb125625772
Gitweb:     http://git.kernel.org/tip/cacb3c76c2012ade52124e8c6fdc5cb125625772
Author:     Viresh Kumar <viresh.kumar@linaro.org>
AuthorDate: Tue, 25 Mar 2014 16:09:18 +0530
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Mar 2014 00:56:49 +0100

tick: Fix spelling mistake in tick_handle_periodic()

One of the comments in tick_handle_periodic() had 'when' instead of 'which' (My
guess :)). Fix it.

Also fix spelling mistake in 'Possible'.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org
Cc: skarafotis@gmail.com
Link: http://lkml.kernel.org/r/2b29ca4230c163e44179941d7c7a16c1474385c2.1395743878.git.viresh.kumar@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 20b2fe3..0fec634 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -118,7 +118,7 @@ void tick_handle_periodic(struct clock_event_device *dev)
 		 * to be sure we're using a real hardware clocksource.
 		 * Otherwise we could get trapped in an infinite
 		 * loop, as the tick_periodic() increments jiffies,
-		 * when then will increment time, posibly causing
+		 * which then will increment time, possibly causing
 		 * the loop to trigger again and again.
 		 */
 		if (timekeeping_valid_for_hres())
