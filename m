Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268AbaKGNnZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 08:43:25 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:41263 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbaKGNnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 08:43:23 -0500
X-AuditID: cbfee68d-f79296d000004278-1a-545ccc790245
From: Yadwinder Singh Brar <yadi.brar@samsung.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: rui.zhang@intel.com, edubezval@gmail.com, amit.daniel@samsung.com,
        viresh.kumar@linaro.org, linux-samsung-soc@vger.kernel.org,
        yadi.brar01@gmail.com, Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: [PATCH v2] thermal: cpu_cooling: Update always cpufreq policy with
 thermal constraints
Date: Fri, 07 Nov 2014 19:12:29 +0530
Message-id: <1415367749-1747-1-git-send-email-yadi.brar@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsWyRsSkSrfyTEyIwa45AhYNV0Ms5l+5xmpx
	edccNovPvUcYLWac38dk8eRhH5vFxq8eFnN/N7JazJn+jsmB02PnrLvsHov3vGTyuHNtD5tH
	35ZVjB6fN8kFsEZx2aSk5mSWpRbp2yVwZZz4fYmlYIZqxZPFWxgbGKfJdzFyckgImEicWvOT
	FcIWk7hwbz0biC0ksJRR4mBfKkzNpQfX2LsYuYDiixglfp1sZYNw2pgkbl7cx9zFyMHBJmAk
	8eqYHUiDiICVxOn/HcwgNcwCpxgl9s88xghSIyyQKHFgtidIDYuAqsTC2Q3sIDavgIvEvCNd
	TBDLFCRalx0CWyYh0M0uMf3aZDaIBgGJb5MPsYDMkRCQldh0gBmiXlLi4IobLBMYBRcwMqxi
	FE0tSC4oTkovMtQrTswtLs1L10vOz93ECAzi0/+e9e5gvH3A+hCjAAejEg/vDd6YECHWxLLi
	ytxDjKZAGyYyS4km5wNjJa8k3tDYzMjC1MTU2Mjc0kxJnFdR6mewkEB6YklqdmpqQWpRfFFp
	TmrxIUYmDk6pBsaDNTolYROZ/irNM640vryuZmNR1bOlSW89ikKlrOtuLZWJNpyoXsaXIilm
	IdC1W+8Df01q5Wb71KUpa7k/SHo7Tr2422TxiiP5IuJzWqfd2rrw0q2V19/9XHvHmyNdxE7x
	5ZTTe8xcXtzlK2vMOFPn+iRx9r6pn6b5NPg6tX8vyLPq3mz8UleJpTgj0VCLuag4EQCg36S/
	XQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsVy+t9jAd3KMzEhBudb2SwaroZYzL9yjdXi
	8q45bBafe48wWsw4v4/J4snDPjaLjV89LOb+bmS1mDP9HZMDp8fOWXfZPRbvecnkcefaHjaP
	vi2rGD0+b5ILYI1qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy
	8QnQdcvMAbpHSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5hx4vclloIZ
	qhVPFm9hbGCcJt/FyMkhIWAicenBNXYIW0ziwr31bF2MXBxCAosYJX6dbIVy2pgkbl7cx9zF
	yMHBJmAk8eqYHUiDiICVxOn/HcwgNcwCpxgl9s88xghSIyyQKHFgtidIDYuAqsTC2Q1gC3gF
	XCTmHeliglimING67BD7BEbuBYwMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCo+SZ1A7G
	lQ0WhxgFOBiVeHhv8saECLEmlhVX5h5ilOBgVhLhvXEcKMSbklhZlVqUH19UmpNafIjRFGj7
	RGYp0eR8YATnlcQbGpuYmxqbWppYmJhZKonzHmi1DhQSSE8sSc1OTS1ILYLpY+LglGpg3LJr
	Za73w1szvj6T46nLPbi9sNPxBk93tPKaPuN/PsEzxb9tKWQ+EDHR+rFCy5Wpr4J35YlLJHXX
	C2r0XO7Yvu3E6/WvprtWSLrU/z/X++/mlDPGG83SNK/UPNC28twUcGPi3C9R3Iwm3kEN5zek
	L5C5s2BFhFzZhb6+cEnb+7Efly1872M6Q4mlOCPRUIu5qDgRAJwKhzCoAgAA
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
cpufreq_cooling_device and max_feq of cpufreq policy in sync. For instance
while resuming cpufreq updates cpufreq_policy and it restores default
policy->usr_policy values irrespective of cooling device's cpufreq_state since
notification gets missed because (notify_device == NOTIFY_INVALID).
Another problem, is that userspace is able to change max_freq irrespective of
cooling device's state, as notification gets missed.

This patch modifies code to maintain a global cpufreq_dev_list and applies
constraints of all matching cooling devices for policy's cpu when there is any
policy update(ends up applying the lowest max_freq among the matching cpu
cooling devices).

This patch also removes redundant check (max_freq > policy->user_policy.max),
as cpufreq framework takes care of user_policy constraints already where ever
required, otherwise its causing an issue while increasing max_freq in normal
scenerio as it restores max_freq with policy->user_policy.max which is old
(smaller) value.

Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
---

changes since v1:
- Updated commit message as suggested by Eduardo Valentin
- fixed an issue in incresing value of scaling_max_freq from sysfs after
  decreasing it once in normal thermal conditions also.

---
 drivers/thermal/cpu_cooling.c |   37 +++++++++++++++++++++----------------
 1 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index 1ab0018..ad09e51 100644
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
 
@@ -316,21 +312,28 @@ static int cpufreq_thermal_notifier(struct notifier_block *nb,
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
+
+		if (!cpufreq_dev->cpufreq_val)
+			cpufreq_dev->cpufreq_val = get_cpu_frequency(
+					cpumask_any(&cpufreq_dev->allowed_cpus),
+					cpufreq_dev->cpufreq_state);
 
-	/* Never exceed user_policy.max */
-	if (max_freq > policy->user_policy.max)
-		max_freq = policy->user_policy.max;
+		max_freq = cpufreq_dev->cpufreq_val;
 
-	if (policy->max != max_freq)
-		cpufreq_verify_within_limits(policy, 0, max_freq);
+		if (policy->max != max_freq)
+			cpufreq_verify_within_limits(policy, 0, max_freq);
+	}
+	mutex_unlock(&cooling_cpufreq_lock);
 
 	return 0;
 }
@@ -486,6 +489,7 @@ __cpufreq_cooling_register(struct device_node *np,
 		cpufreq_register_notifier(&thermal_cpufreq_notifier_block,
 					  CPUFREQ_POLICY_NOTIFIER);
 	cpufreq_dev_count++;
+	list_add(&cpufreq_dev->node, &cpufreq_dev_list);
 
 	mutex_unlock(&cooling_cpufreq_lock);
 
@@ -549,6 +553,7 @@ void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev)
 
 	cpufreq_dev = cdev->devdata;
 	mutex_lock(&cooling_cpufreq_lock);
+	list_del(&cpufreq_dev->node);
 	cpufreq_dev_count--;
 
 	/* Unregister the notifier for the last cpufreq cooling device */
-- 
1.7.0.4

