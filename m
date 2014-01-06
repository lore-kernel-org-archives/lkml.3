Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532AbaAFQLt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:11:49 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:56093 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979AbaAFQLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:11:47 -0500
Date: Mon, 6 Jan 2014 21:41:40 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 56/85] drivers: gpu: Remove unused function in cypress_dpm.c
Message-ID: <20312e9b2a2f276ace3ec07930afc2fd30fba862.1389018325.git.rashika.kheria@gmail.com>
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

Remove unused function cypress_dpm_reset_asic() from
drm/radeon/cypress_dpm.c.

This eliminates the following warnings in drm/radeon/cypress_dpm.c:
drivers/gpu/drm/radeon/cypress_dpm.c:2022:6: warning: no previous prototype for ‘cypress_dpm_reset_asic’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/cypress_dpm.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/gpu/drm/radeon/cypress_dpm.c b/drivers/gpu/drm/radeon/cypress_dpm.c
index 8b9e033..7db6e87 100644
--- a/drivers/gpu/drm/radeon/cypress_dpm.c
+++ b/drivers/gpu/drm/radeon/cypress_dpm.c
@@ -2016,12 +2016,6 @@ int cypress_dpm_set_power_state(struct radeon_device *rdev)
 	return 0;
 }
 
-void cypress_dpm_reset_asic(struct radeon_device *rdev)
-{
-	rv770_restrict_performance_levels_before_switch(rdev);
-	rv770_set_boot_state(rdev);
-}
-
 void cypress_dpm_display_configuration_changed(struct radeon_device *rdev)
 {
 	cypress_program_display_gap(rdev);
-- 
1.7.9.5

