Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704AbaAFQZZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:25:25 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:34947 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362AbaAFQZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:25:23 -0500
Date: Mon, 6 Jan 2014 21:55:18 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 64/85] drivers: gpu: Remove unused function in ni_dpm.c
Message-ID: <9dbd8ae1b52adafb416244ae4caed9d1032d8cf8.1389018325.git.rashika.kheria@gmail.com>
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

Remove unused function ni_dpm_reset_asic() from drm/radeon/ni_dpm.c.

This eliminates the following warnings in drm/radeon/ni_dpm.c:
drivers/gpu/drm/radeon/ni_dpm.c:3897:6: warning: no previous prototype for ‘ni_dpm_reset_asic’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/ni_dpm.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/gpu/drm/radeon/ni_dpm.c b/drivers/gpu/drm/radeon/ni_dpm.c
index 33a1e21..97aa32f 100644
--- a/drivers/gpu/drm/radeon/ni_dpm.c
+++ b/drivers/gpu/drm/radeon/ni_dpm.c
@@ -3891,12 +3891,6 @@ void ni_dpm_post_set_power_state(struct radeon_device *rdev)
 	ni_update_current_ps(rdev, new_ps);
 }
 
-void ni_dpm_reset_asic(struct radeon_device *rdev)
-{
-	ni_restrict_performance_levels_before_switch(rdev);
-	rv770_set_boot_state(rdev);
-}
-
 union power_info {
 	struct _ATOM_POWERPLAY_INFO info;
 	struct _ATOM_POWERPLAY_INFO_V2 info_2;
-- 
1.7.9.5

