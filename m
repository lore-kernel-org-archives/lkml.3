Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235Ab3KOGF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 01:05:29 -0500
Received: from mga02.intel.com ([134.134.136.20]:16089 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998Ab3KOGFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 01:05:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="435638077"
From: Lan Tianyu <tianyu.lan@intel.com>
To: rjw@rjwysocki.net, viresh.kumar@linaro.org
Cc: Lan Tianyu <tianyu.lan@intel.com>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Cpufreq: Remove fossil comment in the cpufreq_governor_dbs()
Date: Fri, 15 Nov 2013 13:54:01 +0800
Message-Id: <1384494841-28581-1-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The related code has been changed and the comment is out of data.
So remove it.

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 drivers/cpufreq/cpufreq_governor.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index 0806c31..e6be635 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -328,10 +328,6 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 					     dbs_data->cdata->gov_dbs_timer);
 		}
 
-		/*
-		 * conservative does not implement micro like ondemand
-		 * governor, thus we are bound to jiffes/HZ
-		 */
 		if (dbs_data->cdata->governor == GOV_CONSERVATIVE) {
 			cs_dbs_info->down_skip = 0;
 			cs_dbs_info->enable = 1;
-- 
1.8.4.rc0.1.g8f6a3e5.dirty

