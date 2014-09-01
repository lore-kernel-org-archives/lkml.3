Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbaIAMZS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 08:25:18 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:65003 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaIAMZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 08:25:16 -0400
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: rjw@rjwysocki.net, viresh.kumar@linaro.org
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>
Subject: [PATCH] cpufreq: intel_pstate: Remove unneeded variable
Date: Mon,  1 Sep 2014 14:23:45 +0200
Message-Id: <1409574225-5618-1-git-send-email-gabriele.mzt@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It should have been removed with commit d1b6848590af
("cpufreq / intel_pstate: Optimize intel_pstate_set_policy")

Signed-off-by: Gabriele Mazzotta <gabriele.mzt@gmail.com>
---
 drivers/cpufreq/intel_pstate.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index e396ad3..0668b38 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -708,10 +708,6 @@ static unsigned int intel_pstate_get(unsigned int cpu_num)
 
 static int intel_pstate_set_policy(struct cpufreq_policy *policy)
 {
-	struct cpudata *cpu;
-
-	cpu = all_cpu_data[policy->cpu];
-
 	if (!policy->cpuinfo.max_freq)
 		return -ENODEV;
 
-- 
2.1.0

