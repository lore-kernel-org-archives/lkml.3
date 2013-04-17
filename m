Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965461Ab3DQROC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 13:14:02 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41345 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965258Ab3DQRN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 13:13:59 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <amit.kachhap@linaro.org>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/30] thermal: cpu_cooling: fix kernel_doc for cpufreq_cooling_device
Date: Wed, 17 Apr 2013 13:11:56 -0400
Message-ID: <1366218743-20841-4-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
References: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple fixes for making kernel_doc happy about
struct cpufreq_cooling_device. Includes also a minor
spelling fix.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/thermal/cpu_cooling.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index d0d6a0c..7c0c05b 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -28,11 +28,11 @@
 #include <linux/cpu_cooling.h>
 
 /**
- * struct cpufreq_cooling_device
+ * struct cpufreq_cooling_device - data for cooling device with cpufreq
  * @id: unique integer value corresponding to each cpufreq_cooling_device
  *	registered.
- * @cool_dev: thermal_cooling_device pointer to keep track of the the
- *	egistered cooling device.
+ * @cool_dev: thermal_cooling_device pointer to keep track of the
+ *	registered cooling device.
  * @cpufreq_state: integer value representing the current state of cpufreq
  *	cooling	devices.
  * @cpufreq_val: integer value representing the absolute value of the clipped
-- 
1.8.2.1.342.gfa7285d

