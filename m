Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936277Ab3DQROY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 13:14:24 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42229 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935968Ab3DQROX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 13:14:23 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <amit.kachhap@linaro.org>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 04/30] thermal: cpu_cooling: use EXPORT_SYMBOL_GPL
Date: Wed, 17 Apr 2013 13:11:57 -0400
Message-ID: <1366218743-20841-5-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
References: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Restrict the usage to GPL modules.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/thermal/cpu_cooling.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index 7c0c05b..64dc4dd 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -200,8 +200,7 @@ unsigned long cpufreq_cooling_get_level(unsigned int cpu, unsigned int freq)
 		return THERMAL_CSTATE_INVALID;
 	return (unsigned long)val;
 }
-
-EXPORT_SYMBOL(cpufreq_cooling_get_level);
+EXPORT_SYMBOL_GPL(cpufreq_cooling_get_level);
 
 /**
  * get_cpu_frequency - get the absolute value of frequency from level.
@@ -414,7 +413,7 @@ struct thermal_cooling_device *cpufreq_cooling_register(
 	mutex_unlock(&cooling_cpufreq_lock);
 	return cool_dev;
 }
-EXPORT_SYMBOL(cpufreq_cooling_register);
+EXPORT_SYMBOL_GPL(cpufreq_cooling_register);
 
 /**
  * cpufreq_cooling_unregister - function to remove cpufreq cooling device.
@@ -438,4 +437,4 @@ void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev)
 	release_idr(&cpufreq_idr, cpufreq_dev->id);
 	kfree(cpufreq_dev);
 }
-EXPORT_SYMBOL(cpufreq_cooling_unregister);
+EXPORT_SYMBOL_GPL(cpufreq_cooling_unregister);
-- 
1.8.2.1.342.gfa7285d

