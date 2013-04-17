Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965840Ab3DQRRJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 13:17:09 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42354 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965354Ab3DQRRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 13:17:06 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <amit.kachhap@linaro.org>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 12/30] thermal: cpu_cooling: document cpufreq_get_cooling_level
Date: Wed, 17 Apr 2013 13:12:05 -0400
Message-ID: <1366218743-20841-13-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
References: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add documentation for cpufreq_get_cooling_level. As this
is an exported function, it has to be documented.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/thermal/cpu_cooling.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index 8ba3188..d046cd5 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -214,6 +214,17 @@ static int get_property(unsigned int cpu, unsigned long input,
 	return -EINVAL;
 }
 
+/**
+ * cpufreq_cooling_get_level - for a give cpu, return the cooling level.
+ * @cpu: cpu for which the level is required
+ * @freq: the frequency of interest
+ *
+ * This function will match the cooling level corresponding to the
+ * requested @freq and return it.
+ *
+ * Return: The matched cooling level on success or THERMAL_CSTATE_INVALID
+ * otherwise.
+ */
 unsigned long cpufreq_cooling_get_level(unsigned int cpu, unsigned int freq)
 {
 	unsigned int val;
-- 
1.8.2.1.342.gfa7285d

