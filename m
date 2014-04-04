Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266AbaDDGky (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 02:40:54 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:64732 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbaDDGkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 02:40:06 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, fweisbec@gmail.com,
        linaro-networking@linaro.org, Arvind.Chauhan@arm.com,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 03/36] hrtimer: fix routine names in comments
Date: Fri,  4 Apr 2014 12:05:46 +0530
Message-Id: <67ac6dc837ef915cfed23e26fcd13c9ff3dff147.1396592516.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As majority of this code came from existing kernel/timer.c, few comments still
had name of routines from timers framework. Fix them.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 3c05140..c87e896 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -142,7 +142,7 @@ static void hrtimer_get_softirq_time(struct hrtimer_cpu_base *base)
  * means that all timers which are tied to this base via timer->base are
  * locked, and the base itself is locked too.
  *
- * So __run_timers/migrate_timers can safely modify all timers which could
+ * So __run_hrtimer/migrate_hrtimers can safely modify all timers which could
  * be found on the lists/queues.
  *
  * When the timer's base is locked, and the timer removed from list, it is
-- 
1.7.12.rc2.18.g61b472e

