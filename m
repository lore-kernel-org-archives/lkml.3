Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965818Ab3DQRRg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 13:17:36 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41558 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965354Ab3DQRR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 13:17:29 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <amit.kachhap@linaro.org>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 13/30] thermal: cpu_cooling: remove checkpatch.pl warning
Date: Wed, 17 Apr 2013 13:12:06 -0400
Message-ID: <1366218743-20841-14-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
References: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple code style fix.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/thermal/cpu_cooling.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index d046cd5..1ddfb15 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -184,7 +184,7 @@ static int get_property(unsigned int cpu, unsigned long input,
 	}
 
 	if (property == GET_FREQ)
-		level = descend ? input : (max_level - input -1);
+		level = descend ? input : (max_level - input - 1);
 
 	for (i = 0, j = 0; table[i].frequency != CPUFREQ_TABLE_END; i++) {
 		/* ignore invalid entry */
-- 
1.8.2.1.342.gfa7285d

