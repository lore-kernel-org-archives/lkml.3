Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413AbaAFQNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:13:20 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:52909 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979AbaAFQNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:13:19 -0500
Date: Mon, 6 Jan 2014 21:43:08 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 57/85] drivers: gpu: Include appropriate header file in
 btc_dpm.c
Message-ID: <b44ab3fb4f51ce0126d03605f8ca6738ad0297ad.1389018325.git.rashika.kheria@gmail.com>
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

Include header file drm/radeon/radeon_asic.h in drm/radeon/btc_dpm.c
because it uses function declared in the header file.

This eliminates the following warnings in drm/radeon/btc_dpm.c:
drivers/gpu/drm/radeon/btc_dpm.c:2079:6: warning: no previous prototype for ‘btc_dpm_vblank_too_short’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/btc_dpm.c:2319:5: warning: no previous prototype for ‘btc_dpm_pre_set_power_state’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/btc_dpm.c:2332:5: warning: no previous prototype for ‘btc_dpm_set_power_state’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/btc_dpm.c:2397:6: warning: no previous prototype for ‘btc_dpm_post_set_power_state’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/btc_dpm.c:2405:5: warning: no previous prototype for ‘btc_dpm_enable’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/btc_dpm.c:2537:6: warning: no previous prototype for ‘btc_dpm_disable’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/btc_dpm.c:2576:6: warning: no previous prototype for ‘btc_dpm_setup_asic’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/btc_dpm.c:2592:5: warning: no previous prototype for ‘btc_dpm_init’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/btc_dpm.c:2756:6: warning: no previous prototype for ‘btc_dpm_fini’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/btc_dpm.c:2769:5: warning: no previous prototype for ‘btc_dpm_get_sclk’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/btc_dpm.c:2780:5: warning: no previous prototype for ‘btc_dpm_get_mclk’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/btc_dpm.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/radeon/btc_dpm.c b/drivers/gpu/drm/radeon/btc_dpm.c
index 4261c3f..9b309ab9 100644
--- a/drivers/gpu/drm/radeon/btc_dpm.c
+++ b/drivers/gpu/drm/radeon/btc_dpm.c
@@ -24,6 +24,7 @@
 
 #include "drmP.h"
 #include "radeon.h"
+#include "radeon_asic.h"
 #include "btcd.h"
 #include "r600_dpm.h"
 #include "cypress_dpm.h"
-- 
1.7.9.5

