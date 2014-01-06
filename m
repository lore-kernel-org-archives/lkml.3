Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbaAFQGL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:06:11 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:53254 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254AbaAFQGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:06:09 -0500
Date: Mon, 6 Jan 2014 21:36:02 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 52/85] drivers: gpu: Include appropriate header file in
 rv770_dpm.c
Message-ID: <db4524480e90ff7a561e73cc60be4c746695b07f.1389018325.git.rashika.kheria@gmail.com>
References: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include header file gpu/drm/radeon/radeon_asic.h in
drm/radeon/rv770_dpm.c because it uses functions declared in the header
file.

This eliminates the following warning in drm/radeon/rv770_dpm.c:
drivers/gpu/drm/radeon/rv770_dpm.c:47:18: warning: no previous prototype for ‘rv770_get_ps’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/rv770_dpm.c:54:26: warning: no previous prototype for ‘rv770_get_pi’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/rv770_dpm.c:61:30: warning: no previous prototype for ‘evergreen_get_pi’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/rv770_dpm.c:1891:5: warning: no previous prototype for ‘rv770_dpm_enable’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/rv770_dpm.c:1989:6: warning: no previous prototype for ‘rv770_dpm_disable’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/rv770_dpm.c:2027:5: warning: no previous prototype for ‘rv770_dpm_set_power_state’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/rv770_dpm.c:2083:6: warning: no previous prototype for ‘rv770_dpm_setup_asic’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/rv770_dpm.c:2106:6: warning: no previous prototype for ‘rv770_dpm_display_configuration_changed’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/rv770_dpm.c:2337:5: warning: no previous prototype for ‘rv770_dpm_init’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/rv770_dpm.c:2422:6: warning: no previous prototype for ‘rv770_dpm_print_power_state’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/rv770_dpm.c:2455:6: warning: no previous prototype for ‘rv770_dpm_debugfs_print_current_performance_level’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/rv770_dpm.c:2485:6: warning: no previous prototype for ‘rv770_dpm_fini’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/rv770_dpm.c:2496:5: warning: no previous prototype for ‘rv770_dpm_get_sclk’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/rv770_dpm.c:2506:5: warning: no previous prototype for ‘rv770_dpm_get_mclk’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/rv770_dpm.c:2516:6: warning: no previous prototype for ‘rv770_dpm_vblank_too_short’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/rv770_dpm.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/radeon/rv770_dpm.c b/drivers/gpu/drm/radeon/rv770_dpm.c
index 913b025..cd22549 100644
--- a/drivers/gpu/drm/radeon/rv770_dpm.c
+++ b/drivers/gpu/drm/radeon/rv770_dpm.c
@@ -24,6 +24,7 @@
 
 #include "drmP.h"
 #include "radeon.h"
+#include "radeon_asic.h"
 #include "rv770d.h"
 #include "r600_dpm.h"
 #include "rv770_dpm.h"
-- 
1.7.9.5

