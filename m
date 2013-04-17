Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966040Ab3DQRUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 13:20:45 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58242 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965315Ab3DQRUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 13:20:43 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <amit.kachhap@linaro.org>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 22/30] thermal: cpu_cooling: update kernel-doc for cpufreq_cooling_register
Date: Wed, 17 Apr 2013 13:12:15 -0400
Message-ID: <1366218743-20841-23-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
References: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add proper documentation for exported function cpufreq_cooling_register.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/thermal/cpu_cooling.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index 708cff6..560692b 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -420,6 +420,13 @@ static struct notifier_block thermal_cpufreq_notifier_block = {
 /**
  * cpufreq_cooling_register - function to create cpufreq cooling device.
  * @clip_cpus: cpumask of cpus where the frequency constraints will happen.
+ *
+ * This interface function registers the cpufreq cooling device with the name
+ * "thermal-cpufreq-%x". This api can support multiple instances of cpufreq
+ * cooling devices.
+ *
+ * Return: a valid struct thermal_cooling_device pointer on success,
+ * on failure, it returns a corresponding ERR_PTR().
  */
 struct thermal_cooling_device *
 cpufreq_cooling_register(const struct cpumask *clip_cpus)
-- 
1.8.2.1.342.gfa7285d

