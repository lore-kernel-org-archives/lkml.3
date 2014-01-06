Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102AbaAFQEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:04:08 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:51926 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462AbaAFQEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:04:07 -0500
Date: Mon, 6 Jan 2014 21:34:00 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 51/85] drivers: gpu: Include appropriate header file in
 rv6xx_dpm.c
Message-ID: <59dfbe3d4a11a9d444a002a869b90e2e004eab1d.1389018325.git.rashika.kheria@gmail.com>
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

Include appropriate header file drm/radeon/radeon_asic.h in
drm/radeon/rv6xx_dpm.c because it uses function declared in the header
file.

This eliminates the following warnings in drm/radeon/rv6xx_dpm.c:
drivers/gpu/drm/radeon/rv6xx_dpm.c:1545:5: warning: no previous prototype for ‘rv6xx_dpm_enable’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/rv6xx_dpm.c:1622:6: warning: no previous prototype for ‘rv6xx_dpm_disable’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/rv6xx_dpm.c:1666:5: warning: no previous prototype for ‘rv6xx_dpm_set_power_state’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/rv6xx_dpm.c:1764:6: warning: no previous prototype for ‘rv6xx_setup_asic’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/rv6xx_dpm.c:1778:6: warning: no previous prototype for ‘rv6xx_dpm_display_configuration_changed’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/rv6xx_dpm.c:1944:5: warning: no previous prototype for ‘rv6xx_dpm_init’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/rv6xx_dpm.c:2015:6: warning: no previous prototype for ‘rv6xx_dpm_print_power_state’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/rv6xx_dpm.c:2036:6: warning: no previous prototype for ‘rv6xx_dpm_debugfs_print_current_performance_level’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/rv6xx_dpm.c:2061:6: warning: no previous prototype for ‘rv6xx_dpm_fini’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/rv6xx_dpm.c:2072:5: warning: no previous prototype for ‘rv6xx_dpm_get_sclk’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/rv6xx_dpm.c:2082:5: warning: no previous prototype for ‘rv6xx_dpm_get_mclk’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/rv6xx_dpm.c:2092:5: warning: no previous prototype for ‘rv6xx_dpm_force_performance_level’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/rv6xx_dpm.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/radeon/rv6xx_dpm.c b/drivers/gpu/drm/radeon/rv6xx_dpm.c
index 26633a0..a4e2a80 100644
--- a/drivers/gpu/drm/radeon/rv6xx_dpm.c
+++ b/drivers/gpu/drm/radeon/rv6xx_dpm.c
@@ -24,6 +24,7 @@
 
 #include "drmP.h"
 #include "radeon.h"
+#include "radeon_asic.h"
 #include "rv6xxd.h"
 #include "r600_dpm.h"
 #include "rv6xx_dpm.h"
-- 
1.7.9.5

