Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437Ab3EPFK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 01:10:28 -0400
Received: from mail-da0-f44.google.com ([209.85.210.44]:58048 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591Ab3EPFKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 01:10:21 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/3] cpufreq: Add EXPORT_SYMBOL_GPL for have_governor_per_policy
Date: Thu, 16 May 2013 10:39:56 +0530
Message-Id: <1b74a10a4602b689de1e6a04b2490593600e2423.1368679353.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1368679353.git.viresh.kumar@linaro.org>
References: <cover.1368679353.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1368679353.git.viresh.kumar@linaro.org>
References: <cover.1368679353.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds: EXPORT_SYMBOL_GPL(have_governor_per_policy), so that this
routine can be used by modules too.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index b7acfd1..21a7fb0 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -132,6 +132,7 @@ bool have_governor_per_policy(void)
 {
 	return cpufreq_driver->have_governor_per_policy;
 }
+EXPORT_SYMBOL_GPL(have_governor_per_policy);
 
 static struct cpufreq_policy *__cpufreq_cpu_get(unsigned int cpu, bool sysfs)
 {
-- 
1.7.12.rc2.18.g61b472e

