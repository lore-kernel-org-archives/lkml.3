Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965615Ab3DQRP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 13:15:27 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41439 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965273Ab3DQRPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 13:15:24 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <amit.kachhap@linaro.org>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 07/30] thermal: cpu_cooling: fix kernel doc for is_cpufreq_valid
Date: Wed, 17 Apr 2013 13:12:00 -0400
Message-ID: <1366218743-20841-8-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
References: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update documentation for is_cpufreq_valid function so
that kernel-doc does not complain about return value.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/thermal/cpu_cooling.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index 68d5a2d..bc1ec19 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -102,8 +102,14 @@ static void release_idr(struct idr *idr, int id)
 /* Below code defines functions to be used for cpufreq as cooling device */
 
 /**
- * is_cpufreq_valid - function to check if a cpu has frequency transition policy.
+ * is_cpufreq_valid - function to check frequency transitioning capability.
  * @cpu: cpu for which check is needed.
+ *
+ * This function will check the current state of the system if
+ * it is capable of changing the frequency for a given @cpu.
+ *
+ * Return: 0 if the system is not currently capable of changing
+ * the frequency of given cpu. !0 in case the frequency is changeable.
  */
 static int is_cpufreq_valid(int cpu)
 {
-- 
1.8.2.1.342.gfa7285d

