Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758484AbaGPJC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 05:02:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:51052 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755511AbaGPJCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 05:02:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,670,1400050800"; 
   d="scan'208";a="573938682"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH v3 7/7] ACPI: Cleanup useless ACPI inclusion.
Date: Wed, 16 Jul 2014 16:59:02 +0800
Message-Id: <7ac00c9c5a32f7a3ec98f061080ba1573ae57d0d.1405500886.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1405500886.git.lv.zheng@intel.com>
References: <cover.1387336613.git.lv.zheng@intel.com> <cover.1405500886.git.lv.zheng@intel.com>
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

