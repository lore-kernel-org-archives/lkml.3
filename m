Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751290Ab3B1FiM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 00:38:12 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:61760 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab3B1FiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 00:38:08 -0500
X-AuditID: 9c930197-b7c43ae0000006e1-d4-512eed3bbb89
From: Namhyung Kim <namhyung@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH -next 1/3] cpufreq: Fix a typo in comment
Date: Thu, 28 Feb 2013 14:38:00 +0900
Message-Id: <1362029882-28993-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 drivers/cpufreq/cpufreq_governor.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
index d2ac91150600..46bde01eee62 100644
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -64,7 +64,7 @@ static void *get_cpu_dbs_info_s(int cpu)				\
  * dbs: used as a shortform for demand based switching It helps to keep variable
  *	names smaller, simpler
  * cdbs: common dbs
- * on_*: On-demand governor
+ * od_*: On-demand governor
  * cs_*: Conservative governor
  */
 
-- 
1.7.11.7

