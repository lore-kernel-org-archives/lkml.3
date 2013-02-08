Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946819Ab3BHRYg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 12:24:36 -0500
Received: from sema.semaphore.gr ([78.46.194.137]:37296 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946792Ab3BHRY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 12:24:27 -0500
Message-ID: <511534C8.1080502@semaphore.gr>
Date: Fri, 08 Feb 2013 19:24:24 +0200
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] cpufreq: conservative: Fix typos in comments
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a couple of typos in comments.

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 drivers/cpufreq/cpufreq_conservative.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index e8bb915..4fd0006 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -25,7 +25,7 @@
 
 #include "cpufreq_governor.h"
 
-/* Conservative governor macors */
+/* Conservative governor macros */
 #define DEF_FREQUENCY_UP_THRESHOLD		(80)
 #define DEF_FREQUENCY_DOWN_THRESHOLD		(20)
 #define DEF_SAMPLING_DOWN_FACTOR		(1)
@@ -144,7 +144,7 @@ static int dbs_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
 
 	/*
 	 * we only care if our internally tracked freq moves outside the 'valid'
-	 * ranges of freqency available to us otherwise we do not change it
+	 * ranges of frequency available to us otherwise we do not change it
 	*/
 	if (dbs_info->requested_freq > policy->max
 			|| dbs_info->requested_freq < policy->min)
-- 
1.8.1.2

