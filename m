Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966176Ab3DQRWQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 13:22:16 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41812 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965546Ab3DQRWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 13:22:13 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <amit.kachhap@linaro.org>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 26/30] thermal: cpu_cooling: remove unused symbols
Date: Wed, 17 Apr 2013 13:12:19 -0400
Message-ID: <1366218743-20841-27-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
References: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The list is needed so far. Thus removing it.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/thermal/cpu_cooling.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index 3709274..825231f 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -38,11 +38,9 @@
  * @cpufreq_val: integer value representing the absolute value of the clipped
  *	frequency.
  * @allowed_cpus: all the cpus involved for this cpufreq_cooling_device.
- * @node: list_head to link all cpufreq_cooling_device together.
  *
  * This structure is required for keeping information of each
- * cpufreq_cooling_device registered as a list whose head is represented by
- * cooling_cpufreq_list. In order to prevent corruption of this list a
+ * cpufreq_cooling_device registered. In order to prevent corruption of this a
  * mutex lock cooling_cpufreq_lock is used.
  */
 struct cpufreq_cooling_device {
@@ -51,9 +49,7 @@ struct cpufreq_cooling_device {
 	unsigned int cpufreq_state;
 	unsigned int cpufreq_val;
 	struct cpumask allowed_cpus;
-	struct list_head node;
 };
-static LIST_HEAD(cooling_cpufreq_list);
 static DEFINE_IDR(cpufreq_idr);
 static DEFINE_MUTEX(cooling_cpufreq_lock);
 
-- 
1.8.2.1.342.gfa7285d

