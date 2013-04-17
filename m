Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966005Ab3DQRR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 13:17:58 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58095 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965456Ab3DQRRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 13:17:55 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <amit.kachhap@linaro.org>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 14/30] thermal: cpu_cooling: improve documentation for get_cpu_frequency
Date: Wed, 17 Apr 2013 13:12:07 -0400
Message-ID: <1366218743-20841-15-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
References: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix kernel-doc warning on get_cpu_frequency and improve
documentation comments.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/thermal/cpu_cooling.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index 1ddfb15..593da29 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -239,8 +239,14 @@ EXPORT_SYMBOL_GPL(cpufreq_cooling_get_level);
 /**
  * get_cpu_frequency - get the absolute value of frequency from level.
  * @cpu: cpu for which frequency is fetched.
- * @level: level of frequency, equals cooling state of cpu cooling device
+ * @level: cooling level
+ *
+ * This function matches cooling level with frequency. Based on a cooling level
+ * of frequency, equals cooling state of cpu cooling device, it will return
+ * the corresponding frequency.
  *	e.g level=0 --> 1st MAX FREQ, level=1 ---> 2nd MAX FREQ, .... etc
+ *
+ * Return: 0 on error, the corresponding frequency otherwise.
  */
 static unsigned int get_cpu_frequency(unsigned int cpu, unsigned long level)
 {
-- 
1.8.2.1.342.gfa7285d

