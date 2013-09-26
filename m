Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab3IZOu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 10:50:29 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:45194 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab3IZOu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 10:50:27 -0400
From: LABBE Corentin <clabbe.montjoie@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH] Correct some typos for word frequency
Date: Thu, 26 Sep 2013 16:50:21 +0200
Message-Id: <1380207021-27687-1-git-send-email-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/cpufreq/exynos-cpufreq.c | 2 +-
 include/linux/devfreq.h          | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
index 0fac344..b4afd07 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -77,7 +77,7 @@ static int exynos_cpufreq_scale(unsigned int target_freq)
 	/*
 	 * The policy max have been changed so that we cannot get proper
 	 * old_index with cpufreq_frequency_table_target(). Thus, ignore
-	 * policy and get the index from the raw freqeuncy table.
+	 * policy and get the index from the raw frequency table.
 	 */
 	old_index = exynos_cpufreq_get_index(freqs.old);
 	if (old_index < 0) {
diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
index 5f1ab92..32acc00 100644
--- a/include/linux/devfreq.h
+++ b/include/linux/devfreq.h
@@ -168,7 +168,7 @@ struct devfreq {
 	unsigned long max_freq;
 	bool stop_polling;
 
-	/* information for device freqeuncy transition */
+	/* information for device frequency transition */
 	unsigned int total_trans;
 	unsigned int *trans_table;
 	unsigned long *time_in_state;
-- 
1.8.1.5

