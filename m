Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965409Ab3DQRNk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 13:13:40 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53336 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936120Ab3DQRNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 13:13:38 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <amit.kachhap@linaro.org>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 02/30] thermal: cpu_cooling: remove trailing white spaces
Date: Wed, 17 Apr 2013 13:11:55 -0400
Message-ID: <1366218743-20841-3-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
References: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary white spaces.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/thermal/cpu_cooling.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index 778c43d..d0d6a0c 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -131,14 +131,13 @@ static int get_property(unsigned int cpu, unsigned long input,
 	int descend = -1;
 	struct cpufreq_frequency_table *table =
 					cpufreq_frequency_get_table(cpu);
-	
+
 	if (!output)
 		return -EINVAL;
 
 	if (!table)
 		return -EINVAL;
 
-	
 	for (i = 0; table[i].frequency != CPUFREQ_TABLE_END; i++) {
 		/* ignore invalid entries */
 		if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
-- 
1.8.2.1.342.gfa7285d

