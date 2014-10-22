Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbaJVOD2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 10:03:28 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:46646 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbaJVN6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 09:58:08 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, rafael.j.wysocki@intel.com, mingo@kernel.org,
        peterz@infradead.org, preeti@linux.vnet.ibm.com,
        Morten.Rasmussen@arm.com, mturquette@linaro.org,
        tuukka.tikkanen@linaro.org, nicolas.pitre@linaro.org,
        patches@linaro.org
Subject: [RFD PATCH 05/10] cpuidle: Remove unused headers for tick
Date: Wed, 22 Oct 2014 15:57:48 +0200
Message-Id: <1413986273-28522-6-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413986273-28522-1-git-send-email-daniel.lezcano@linaro.org>
References: <1413986273-28522-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving around the different functions dealing with the time made the time
headers no longer necessary in cpuidle.c.

Remove them.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/cpuidle/cpuidle.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 658be9f..1abd5a0 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -8,16 +8,12 @@
  * This code is licenced under the GPL.
  */
 
-#include <linux/clockchips.h>
 #include <linux/kernel.h>
 #include <linux/mutex.h>
-#include <linux/sched.h>
 #include <linux/notifier.h>
 #include <linux/pm_qos.h>
 #include <linux/cpu.h>
 #include <linux/cpuidle.h>
-#include <linux/ktime.h>
-#include <linux/hrtimer.h>
 #include <linux/module.h>
 #include <trace/events/power.h>
 
-- 
1.9.1

