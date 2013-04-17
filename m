Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965328Ab3DQRNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 13:13:23 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57866 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935546Ab3DQRNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 13:13:21 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <amit.kachhap@linaro.org>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/30] thermal: cpu_cooling: remove unused headers
Date: Wed, 17 Apr 2013 13:11:54 -0400
Message-ID: <1366218743-20841-2-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
References: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As this code is not a module nor a platform device driver,
this patch removes some unused header files.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/thermal/cpu_cooling.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index 5f5c780..778c43d 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -20,10 +20,7 @@
  *
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  */
-#include <linux/kernel.h>
-#include <linux/module.h>
 #include <linux/thermal.h>
-#include <linux/platform_device.h>
 #include <linux/cpufreq.h>
 #include <linux/err.h>
 #include <linux/slab.h>
-- 
1.8.2.1.342.gfa7285d

