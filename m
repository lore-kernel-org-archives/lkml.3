Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896Ab3FDRNL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:13:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48324 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757495Ab3FDQ7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 12:59:41 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 65/75] drm/radeon: fix typo in cu_per_sh on verde
Date: Tue,  4 Jun 2013 09:55:49 -0700
Message-Id: <1370364959-9475-66-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370364959-9475-1-git-send-email-kamal@canonical.com>
References: <1370364959-9475-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 468ef1a58c9268ac9709350bf95eaf1c22a69f29 upstream.

Should be 5 rather than 2.

Noticed by sroland and glisse on IRC.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/si.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index 2972782..5d4bc96 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -1556,7 +1556,7 @@ static void si_gpu_init(struct radeon_device *rdev)
 	default:
 		rdev->config.si.max_shader_engines = 1;
 		rdev->config.si.max_tile_pipes = 4;
-		rdev->config.si.max_cu_per_sh = 2;
+		rdev->config.si.max_cu_per_sh = 5;
 		rdev->config.si.max_sh_per_se = 2;
 		rdev->config.si.max_backends_per_se = 4;
 		rdev->config.si.max_texture_channel_caches = 4;
-- 
1.8.1.2

