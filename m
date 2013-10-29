Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931Ab3J2SZA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:25:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59280 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab3J2SFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:05:12 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: wojciech kapuscinski <wojtask9@wp.pl>,
        Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 11/81] drm/radeon: fix hw contexts for SUMO2 asics
Date: Tue, 29 Oct 2013 11:03:32 -0700
Message-Id: <1383069882-11437-12-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: wojciech kapuscinski <wojtask9@wp.pl>

commit 50b8f5aec04ebec7dbdf2adb17220b9148c99e63 upstream.

They have 4 rather than 8.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=63599

Signed-off-by: wojciech kapuscinski <wojtask9@wp.pl>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/evergreen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index c7a0488..a40eb90 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -1989,7 +1989,7 @@ static void evergreen_gpu_init(struct radeon_device *rdev)
 		rdev->config.evergreen.sx_max_export_size = 256;
 		rdev->config.evergreen.sx_max_export_pos_size = 64;
 		rdev->config.evergreen.sx_max_export_smx_size = 192;
-		rdev->config.evergreen.max_hw_contexts = 8;
+		rdev->config.evergreen.max_hw_contexts = 4;
 		rdev->config.evergreen.sq_num_cf_insts = 2;
 
 		rdev->config.evergreen.sc_prim_fifo_size = 0x40;
-- 
1.8.1.2

