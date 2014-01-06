Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbaAFQCg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:02:36 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:42504 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752AbaAFQCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:02:35 -0500
Date: Mon, 6 Jan 2014 21:32:22 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Anthoine Bourgeois <anthoine.bourgeois@gmail.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 50/85] drivers: gpu: Include appropriate header file in
 rs780_dpm.c
Message-ID: <caaa4633085f7fa2cac634b95701a8325fcdf963.1389018325.git.rashika.kheria@gmail.com>
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
drm/radeon/rs780_dpm.c because it uses function declared in the header
file.

This eliminates the following warnings in drm/radeon/rs780_dpm.c:
drivers/gpu/drm/radeon/rs780_dpm.c:596:5: warning: no previous prototype for ‘rs780_dpm_enable’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/rs780_dpm.c:637:6: warning: no previous prototype for ‘rs780_dpm_disable’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/rs780_dpm.c:656:5: warning: no previous prototype for ‘rs780_dpm_set_power_state’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/rs780_dpm.c:687:6: warning: no previous prototype for ‘rs780_dpm_setup_asic’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/rs780_dpm.c:692:6: warning: no previous prototype for ‘rs780_dpm_display_configuration_changed’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/rs780_dpm.c:856:5: warning: no previous prototype for ‘rs780_dpm_init’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/rs780_dpm.c:943:6: warning: no previous prototype for ‘rs780_dpm_print_power_state’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/rs780_dpm.c:958:6: warning: no previous prototype for ‘rs780_dpm_fini’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/rs780_dpm.c:969:5: warning: no previous prototype for ‘rs780_dpm_get_sclk’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/rs780_dpm.c:979:5: warning: no previous prototype for ‘rs780_dpm_get_mclk’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/rs780_dpm.c:986:6: warning: no previous prototype for ‘rs780_dpm_debugfs_print_current_performance_level’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/rs780_dpm.c:1010:5: warning: no previous prototype for ‘rs780_dpm_force_performance_level’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/rs780_dpm.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/radeon/rs780_dpm.c b/drivers/gpu/drm/radeon/rs780_dpm.c
index 6af8505..dd264f5 100644
--- a/drivers/gpu/drm/radeon/rs780_dpm.c
+++ b/drivers/gpu/drm/radeon/rs780_dpm.c
@@ -24,6 +24,7 @@
 
 #include "drmP.h"
 #include "radeon.h"
+#include "radeon_asic.h"
 #include "rs780d.h"
 #include "r600_dpm.h"
 #include "rs780_dpm.h"
-- 
1.7.9.5

