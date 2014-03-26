Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbaCZLWD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 07:22:03 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:51884 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879AbaCZLVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 07:21:54 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, linaro-networking@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 01/14] hrtimer: replace 'tab' with 'space' after 'comma'
Date: Wed, 26 Mar 2014 16:51:07 +0530
Message-Id: <73a6cd8d56216963e2932826cfb7f6654ab4c9b9.1395832156.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1395832156.git.viresh.kumar@linaro.org>
References: <cover.1395832156.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1395832156.git.viresh.kumar@linaro.org>
References: <cover.1395832156.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we have a 'tab' here instead of 'space' after 'comma'. Replace it with
'space'.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index d55092c..a1120a0 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -128,7 +128,7 @@ static void hrtimer_get_softirq_time(struct hrtimer_cpu_base *base)
 	base->clock_base[HRTIMER_BASE_MONOTONIC].softirq_time = mono;
 	base->clock_base[HRTIMER_BASE_BOOTTIME].softirq_time = boot;
 	base->clock_base[HRTIMER_BASE_TAI].softirq_time =
-				ktime_add(xtim,	ktime_set(tai_offset, 0));
+				ktime_add(xtim, ktime_set(tai_offset, 0));
 }
 
 /*
-- 
1.7.12.rc2.18.g61b472e

