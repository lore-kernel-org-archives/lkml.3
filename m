Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbaGGERu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 00:17:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:17623 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935AbaGGERp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 00:17:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,616,1400050800"; 
   d="scan'208";a="565980829"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH v2 6/7] ACPI: Cleanup useless ACPI inclusion.
Date: Mon,  7 Jul 2014 12:17:40 +0800
Message-Id: <cf869ff5e75e0973b065c3d3fe2fa453abcd5c97.1404706299.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1404706298.git.lv.zheng@intel.com>
References: <cover.1387336613.git.lv.zheng@intel.com> <cover.1404706298.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sst-haswell-dsp.c is an ACPI independent file, this patch removes
ACPI header files for it.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: alsa-devel@alsa-project.org
---
 sound/soc/intel/sst-haswell-dsp.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/sound/soc/intel/sst-haswell-dsp.c b/sound/soc/intel/sst-haswell-dsp.c
index 535f517..ecc5057 100644
--- a/sound/soc/intel/sst-haswell-dsp.c
+++ b/sound/soc/intel/sst-haswell-dsp.c
@@ -28,9 +28,6 @@
 #include <linux/firmware.h>
 #include <linux/pm_runtime.h>
 
-#include <linux/acpi.h>
-#include <acpi/acpi_bus.h>
-
 #include "sst-dsp.h"
 #include "sst-dsp-priv.h"
 #include "sst-haswell-ipc.h"
-- 
1.7.10

