Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966206Ab3DQRV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 13:21:57 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58276 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965546Ab3DQRVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 13:21:55 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <amit.kachhap@linaro.org>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 25/30] thermal: cpu_cooling: remove not needed curl brackets
Date: Wed, 17 Apr 2013 13:12:18 -0400
Message-ID: <1366218743-20841-26-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
References: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just for style purposes, remove extra curl brackets.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/thermal/cpu_cooling.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index b1f9a4d..3709274 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -505,10 +505,9 @@ void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev)
 	cpufreq_dev_count--;
 
 	/* Unregister the notifier for the last cpufreq cooling device */
-	if (cpufreq_dev_count == 0) {
+	if (cpufreq_dev_count == 0)
 		cpufreq_unregister_notifier(&thermal_cpufreq_notifier_block,
 					    CPUFREQ_POLICY_NOTIFIER);
-	}
 	mutex_unlock(&cooling_cpufreq_lock);
 
 	thermal_cooling_device_unregister(cpufreq_dev->cool_dev);
-- 
1.8.2.1.342.gfa7285d

