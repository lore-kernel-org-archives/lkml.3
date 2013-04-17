Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966067Ab3DQRSf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 13:18:35 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42440 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965456Ab3DQRSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 13:18:32 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <amit.kachhap@linaro.org>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 16/30] thermal: cpu_cooling: update documentation for cpufreq_thermal_notifier
Date: Wed, 17 Apr 2013 13:12:09 -0400
Message-ID: <1366218743-20841-17-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
References: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update kernel-doc comment and documentation for cpufreq_thermal_notifier.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/thermal/cpu_cooling.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index 934c0b0..b5de9d4 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -307,6 +307,12 @@ static int cpufreq_apply_cooling(struct cpufreq_cooling_device *cpufreq_device,
  * @nb:	struct notifier_block * with callback info.
  * @event: value showing cpufreq event for which this function invoked.
  * @data: callback-specific data
+ *
+ * Callback to highjack the notification on cpufreq policy transition.
+ * Every time there is a change in policy, we will intercept and
+ * update the cpufreq policy with thermal constraints.
+ *
+ * Return: 0 (success)
  */
 static int cpufreq_thermal_notifier(struct notifier_block *nb,
 					unsigned long event, void *data)
-- 
1.8.2.1.342.gfa7285d

