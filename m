Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760113Ab3DBM0a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 08:26:30 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41341 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759619Ab3DBM02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 08:26:28 -0400
From: Borislav Petkov <bp@alien8.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: cpufreq@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH] cpufreq: Correct header guards typo
Date: Tue,  2 Apr 2013 14:26:15 +0200
Message-Id: <1364905575-10234-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.2.135.g7b592fa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

It should be "governor".

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 drivers/cpufreq/cpufreq_governor.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
index 513cc8234e5e..65937697cab3 100644
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -14,8 +14,8 @@
  * published by the Free Software Foundation.
  */
 
-#ifndef _CPUFREQ_GOVERNER_H
-#define _CPUFREQ_GOVERNER_H
+#ifndef _CPUFREQ_GOVERNOR_H
+#define _CPUFREQ_GOVERNOR_H
 
 #include <linux/cpufreq.h>
 #include <linux/kobject.h>
@@ -263,4 +263,4 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 		struct common_dbs_data *cdata, unsigned int event);
 void gov_queue_work(struct dbs_data *dbs_data, struct cpufreq_policy *policy,
 		unsigned int delay, bool all_cpus);
-#endif /* _CPUFREQ_GOVERNER_H */
+#endif /* _CPUFREQ_GOVERNOR_H */
-- 
1.8.2.135.g7b592fa

