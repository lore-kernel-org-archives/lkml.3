Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbaKEMQy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 07:16:54 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:45541 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbaKEMQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 07:16:51 -0500
X-AuditID: cbfee691-f79b86d000004a5a-68-545a1531619d
From: Yadwinder Singh Brar <yadi.brar@samsung.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: rui.zhang@intel.com, edubezval@gmail.com, amit.daniel@samsung.com,
        viresh.kumar@linaro.org, linux-samsung-soc@vger.kernel.org,
        yadi.brar01@gmail.com, Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: [PATCH] thermal: cpu_cooling: Update always cpufreq policy with
 thermal constraints
Date: Wed, 05 Nov 2014 17:46:25 +0530
Message-id: <1415189785-18593-1-git-send-email-yadi.brar@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsWyRsSkVtdQNCrEoHExt0XD1RCL+VeusVpc
	3jWHzeJz7xFGixnn9zFZPHnYx2ax8auHxdzfjawWc6a/Y3Lg9Ng56y67x+I9L5k87lzbw+bR
	t2UVo8fnTXIBrFFcNimpOZllqUX6dglcGZffzGQrWC5bMW3+BbYGxsMSXYycHBICJhK9P1qY
	IGwxiQv31rN1MXJxCAksZZR4eegxaxcjB1jRprUxEPHpjBI7elYwQjhtTBKHm+eBFbEJGEm8
	OmYHMkhEwEri9P8OZpAaZoFTjBL7Zx5jBEkIC8RJ/NlyAGwbi4CqxJ1br9lAbF4BV4m9PVvZ
	Ia5QkGhddogdpFlCoJ9dYmnTIxaIBgGJb5MPsUBcJCux6QAzRL2kxMEVN1gmMAouYGRYxSia
	WpBcUJyUXmSqV5yYW1yal66XnJ+7iREYxqf/PZu4g/H+AetDjAIcjEo8vAa5kSFCrIllxZW5
	hxhNgTZMZJYSTc4HRkteSbyhsZmRhamJqbGRuaWZkjivjvTPYCGB9MSS1OzU1ILUovii0pzU
	4kOMTBycUg2MddkdT3XqtrLKLq5Q/W5WEXRrAuu0nM17Dn/K2zXb3nvZWl5mRXczSdam0prA
	BAFt0YfOD96on5lpYbdTsC1S6v9js0997yMnnFs3/6n4t8jGilXvXrmZ8frZCFxrPzu1gj9o
	0aZObbZo4akJqwU6G1aem9MpbRZ2J4P1mdqHH1VJjqdVdnApsRRnJBpqMRcVJwIAKbYYY14C	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsVy+t9jQV1D0agQg6ebGS0aroZYzL9yjdXi
	8q45bBafe48wWsw4v4/J4snDPjaLjV89LOb+bmS1mDP9HZMDp8fOWXfZPRbvecnkcefaHjaP
	vi2rGD0+b5ILYI1qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy
	8QnQdcvMAbpHSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5hx+c1MtoLl
	shXT5l9ga2A8LNHFyMEhIWAisWltTBcjJ5ApJnHh3nq2LkYuDiGB6YwSO3pWMEI4bUwSh5vn
	sYI0sAkYSbw6ZgfSICJgJXH6fwczSA2zwClGif0zjzGCJIQF4iT+bDnABGKzCKhK3Ln1mg3E
	5hVwldjbs5UdYpuCROuyQ+wTGLkXMDKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAiOkmfS
	OxhXNVgcYhTgYFTi4TXIjQwRYk0sK67MPcQowcGsJMLLIBIVIsSbklhZlVqUH19UmpNafIjR
	FGj7RGYp0eR8YATnlcQbGpuYmxqbWppYmJhZKonzHmy1DhQSSE8sSc1OTS1ILYLpY+LglGpg
	TN2n/VBf+e+MC5/DGVaqGlz3S334wr3r4W3jye9OMf3Oykx8qOub8Oslj2lqUWamw6UTJ3Y4
	xDdaz1J2rQt/7M7YwPRJZINWwD979to7i0o+tXyc5W62/IqB6hT3AzzmUnzKcoqty06cuWR9
	7mXW+dXbj3FK96WGm/AuedzctDktREFAi2mqEktxRqKhFnNRcSIAzMhMJqgCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Existing code updates cupfreq policy only while executing
cpufreq_apply_cooling() function (i.e. when notify_device != NOTIFY_INVALID).
It doesn't apply constraints when cpufreq policy update happens from any other
place but it should update the cpufreq policy with thermal constraints every
time when there is a cpufreq policy update, to keep state of
cpufreq_cooling_device and max_feq of cpufreq policy in sync.

This patch modifies code to maintain a global cpufreq_dev_list and get
corresponding cpufreq_cooling_device for policy's cpu from cpufreq_dev_list
when there is any policy update.

Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
---
 drivers/thermal/cpu_cooling.c |   37 ++++++++++++++++++++-----------------
 1 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index 1ab0018..5546278 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -50,15 +50,14 @@ struct cpufreq_cooling_device {
 	unsigned int cpufreq_state;
 	unsigned int cpufreq_val;
 	struct cpumask allowed_cpus;
+	struct list_head node;
 };
 static DEFINE_IDR(cpufreq_idr);
 static DEFINE_MUTEX(cooling_cpufreq_lock);
 
 static unsigned int cpufreq_dev_count;
 
-/* notify_table passes value to the CPUFREQ_ADJUST callback function. */
-#define NOTIFY_INVALID NULL
-static struct cpufreq_cooling_device *notify_device;
+static LIST_HEAD(cpufreq_dev_list);
 
 /**
  * get_idr - function to get a unique id.
@@ -287,15 +286,12 @@ static int cpufreq_apply_cooling(struct cpufreq_cooling_device *cpufreq_device,
 
 	cpufreq_device->cpufreq_state = cooling_state;
 	cpufreq_device->cpufreq_val = clip_freq;
-	notify_device = cpufreq_device;
 
 	for_each_cpu(cpuid, mask) {
 		if (is_cpufreq_valid(cpuid))
 			cpufreq_update_policy(cpuid);
 	}
 
-	notify_device = NOTIFY_INVALID;
-
 	return 0;
 }
 
@@ -316,21 +312,27 @@ static int cpufreq_thermal_notifier(struct notifier_block *nb,
 {
 	struct cpufreq_policy *policy = data;
 	unsigned long max_freq = 0;
+	struct cpufreq_cooling_device *cpufreq_dev;
 
-	if (event != CPUFREQ_ADJUST || notify_device == NOTIFY_INVALID)
+	if (event != CPUFREQ_ADJUST)
 		return 0;
 
-	if (cpumask_test_cpu(policy->cpu, &notify_device->allowed_cpus))
-		max_freq = notify_device->cpufreq_val;
-	else
-		return 0;
+	mutex_lock(&cooling_cpufreq_lock);
+	list_for_each_entry(cpufreq_dev, &cpufreq_dev_list, node) {
+		if (!cpumask_test_cpu(policy->cpu,
+					&cpufreq_dev->allowed_cpus))
+			continue;
 
-	/* Never exceed user_policy.max */
-	if (max_freq > policy->user_policy.max)
-		max_freq = policy->user_policy.max;
+		max_freq = cpufreq_dev->cpufreq_val;
 
-	if (policy->max != max_freq)
-		cpufreq_verify_within_limits(policy, 0, max_freq);
+		/* Never exceed user_policy.max */
+		if (max_freq > policy->user_policy.max)
+			max_freq = policy->user_policy.max;
+
+		if (policy->max != max_freq)
+			cpufreq_verify_within_limits(policy, 0, max_freq);
+	}
+	mutex_unlock(&cooling_cpufreq_lock);
 
 	return 0;
 }
@@ -486,7 +488,7 @@ __cpufreq_cooling_register(struct device_node *np,
 		cpufreq_register_notifier(&thermal_cpufreq_notifier_block,
 					  CPUFREQ_POLICY_NOTIFIER);
 	cpufreq_dev_count++;
-
+	list_add(&cpufreq_dev->node, &cpufreq_dev_list);
 	mutex_unlock(&cooling_cpufreq_lock);
 
 	return cool_dev;
@@ -549,6 +551,7 @@ void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev)
 
 	cpufreq_dev = cdev->devdata;
 	mutex_lock(&cooling_cpufreq_lock);
+	list_del(&cpufreq_dev->node);
 	cpufreq_dev_count--;
 
 	/* Unregister the notifier for the last cpufreq cooling device */
-- 
1.7.0.4

