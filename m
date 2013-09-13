Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380Ab3IMNDO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:03:14 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:39681 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755876Ab3IMNDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:03:09 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 001/228] cpufreq: Remove extra blank line
Date: Fri, 13 Sep 2013 18:29:07 +0530
Message-Id: <527549804685f2fe723d0b6b7d60324ac6790771.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need a blank line just at start of a block, lets remove it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 005eb73..3d5e6d6 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1240,7 +1240,6 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
 		if (!frozen)
 			sysfs_remove_link(&dev->kobj, "cpufreq");
 	} else if (cpus > 1) {
-
 		new_cpu = cpufreq_nominate_new_policy_cpu(policy, cpu, frozen);
 		if (new_cpu >= 0) {
 			WARN_ON(lock_policy_rwsem_write(cpu));
-- 
1.7.12.rc2.18.g61b472e

