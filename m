Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179AbaDDGkq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 02:40:46 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:33841 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbaDDGjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 02:39:54 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, fweisbec@gmail.com,
        linaro-networking@linaro.org, Arvind.Chauhan@arm.com,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 01/36] hrtimer: replace 'tab' with 'space' after 'comma'
Date: Fri,  4 Apr 2014 12:05:44 +0530
Message-Id: <d817f2f5cae317e8ac6898e5964b22ab4a3cfb7f.1396592516.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we have a 'tab' here instead of 'space' after 'comma'. Replace it with
space.

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

