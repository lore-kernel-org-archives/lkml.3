Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966232Ab3DQRW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 13:22:27 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58288 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965546Ab3DQRWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 13:22:23 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <amit.kachhap@linaro.org>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>, Durgadoss R <durgadoss.r@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 27/30] thermal: cpu_cooling: add needed header for cpu_cooling.h
Date: Wed, 17 Apr 2013 13:12:20 -0400
Message-ID: <1366218743-20841-28-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
References: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update header list for cpu_cooling.h. Missing definition
of cpumask.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Durgadoss R <durgadoss.r@intel.com>
Cc: Amit Daniel Kachhap <amit.kachhap@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 include/linux/cpu_cooling.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/cpu_cooling.h b/include/linux/cpu_cooling.h
index 77c87c9..75ef931 100644
--- a/include/linux/cpu_cooling.h
+++ b/include/linux/cpu_cooling.h
@@ -25,6 +25,7 @@
 #define __CPU_COOLING_H__
 
 #include <linux/thermal.h>
+#include <linux/cpumask.h>
 
 #define CPUFREQ_COOLING_START		0
 #define CPUFREQ_COOLING_STOP		1
-- 
1.8.2.1.342.gfa7285d

