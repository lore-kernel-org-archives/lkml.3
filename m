Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759661AbaIOW4r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:56:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50918 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757739AbaIOWQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:16:07 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 156/187] drm/radeon: re-enable dpm by default on cayman
Date: Mon, 15 Sep 2014 15:09:26 -0700
Message-Id: <1410818997-9432-157-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 8f500af4efe347d1a8ac674d115220e8caa84559 upstream.

This patch depends on:
b0880e87c1fd038b84498944f52e52c3e86ebe59
(drm/radeon/dpm: fix vddci setup typo on cayman)

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=69723

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_pm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_pm.c b/drivers/gpu/drm/radeon/radeon_pm.c
index 446e67f..5a5925c 100644
--- a/drivers/gpu/drm/radeon/radeon_pm.c
+++ b/drivers/gpu/drm/radeon/radeon_pm.c
@@ -1274,7 +1274,6 @@ int radeon_pm_init(struct radeon_device *rdev)
 	case CHIP_BARTS:
 	case CHIP_TURKS:
 	case CHIP_CAICOS:
-	case CHIP_CAYMAN:
 	case CHIP_BONAIRE:
 	case CHIP_KABINI:
 	case CHIP_KAVERI:
@@ -1302,6 +1301,7 @@ int radeon_pm_init(struct radeon_device *rdev)
 	case CHIP_PALM:
 	case CHIP_SUMO:
 	case CHIP_SUMO2:
+	case CHIP_CAYMAN:
 	case CHIP_ARUBA:
 	case CHIP_TAHITI:
 	case CHIP_PITCAIRN:
-- 
1.9.1

