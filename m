Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965704Ab3DQRQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 13:16:23 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41498 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965286Ab3DQRQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 13:16:21 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <amit.kachhap@linaro.org>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/30] thermal: cpu_cooling: align on open parenthesis
Date: Wed, 17 Apr 2013 13:12:03 -0400
Message-ID: <1366218743-20841-11-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
References: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve code readiness by remove checkpatch.pl warnings
on get_property function.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/thermal/cpu_cooling.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index 224048c..3d985ff 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -144,7 +144,8 @@ enum cpufreq_cooling_property {
  * Return: 0 on success, -EINVAL when invalid parameters are passed.
  */
 static int get_property(unsigned int cpu, unsigned long input,
-	unsigned int* output, enum cpufreq_cooling_property property)
+			unsigned int *output,
+			enum cpufreq_cooling_property property)
 {
 	int i, j;
 	unsigned long max_level = 0, level = 0;
-- 
1.8.2.1.342.gfa7285d

