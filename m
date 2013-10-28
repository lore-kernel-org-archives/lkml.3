Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131Ab3J1Osz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 10:48:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51045 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756945Ab3J1Osr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:48:47 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: wojciech kapuscinski <wojtask9@wp.pl>,
        Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 09/64] drm/radeon: fix hw contexts for SUMO2 asics
Date: Mon, 28 Oct 2013 14:47:28 +0000
Message-Id: <1382971703-17393-10-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
References: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: wojciech kapuscinski <wojtask9@wp.pl>

commit 50b8f5aec04ebec7dbdf2adb17220b9148c99e63 upstream.

They have 4 rather than 8.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=63599

Signed-off-by: wojciech kapuscinski <wojtask9@wp.pl>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/evergreen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index 650e2d7..9c2ae4e 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -1766,7 +1766,7 @@ static void evergreen_gpu_init(struct radeon_device *rdev)
 		rdev->config.evergreen.sx_max_export_size = 256;
 		rdev->config.evergreen.sx_max_export_pos_size = 64;
 		rdev->config.evergreen.sx_max_export_smx_size = 192;
-		rdev->config.evergreen.max_hw_contexts = 8;
+		rdev->config.evergreen.max_hw_contexts = 4;
 		rdev->config.evergreen.sq_num_cf_insts = 2;
 
 		rdev->config.evergreen.sc_prim_fifo_size = 0x40;
-- 
1.8.3.2

