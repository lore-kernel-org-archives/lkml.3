Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965775Ab3DQRQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 13:16:32 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53483 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965598Ab3DQRQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 13:16:30 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <amit.kachhap@linaro.org>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 09/30] thermal: cpu_cooling: standardize comment style
Date: Wed, 17 Apr 2013 13:12:02 -0400
Message-ID: <1366218743-20841-10-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
References: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are at least three patterns for oneline comments in this
file. This patch changes them to one single pattern

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/thermal/cpu_cooling.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index 0fa14b7..224048c 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -297,7 +297,7 @@ static int cpufreq_thermal_notifier(struct notifier_block *nb,
 	if (cpumask_test_cpu(policy->cpu, &notify_device->allowed_cpus))
 		max_freq = notify_device->cpufreq_val;
 
-	/* Never exceed user_policy.max*/
+	/* Never exceed user_policy.max */
 	if (max_freq > policy->user_policy.max)
 		max_freq = policy->user_policy.max;
 
@@ -307,9 +307,7 @@ static int cpufreq_thermal_notifier(struct notifier_block *nb,
 	return 0;
 }
 
-/*
- * cpufreq cooling device callback functions are defined below
- */
+/* cpufreq cooling device callback functions are defined below */
 
 /**
  * cpufreq_get_max_state - callback function to get the max cooling state.
@@ -389,9 +387,9 @@ struct thermal_cooling_device *cpufreq_cooling_register(
 	int ret = 0, i;
 	struct cpufreq_policy policy;
 
-	/*Verify that all the clip cpus have same freq_min, freq_max limit*/
+	/* Verify that all the clip cpus have same freq_min, freq_max limit */
 	for_each_cpu(i, clip_cpus) {
-		/*continue if cpufreq policy not found and not return error*/
+		/* continue if cpufreq policy not found and not return error */
 		if (!cpufreq_get_policy(&policy, i))
 			continue;
 		if (min == 0 && max == 0) {
-- 
1.8.2.1.342.gfa7285d

