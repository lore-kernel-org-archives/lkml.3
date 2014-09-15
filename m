Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932826AbaIOWQM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:16:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50908 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757717AbaIOWQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:16:01 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 157/187] drm/radeon: re-enable dpm by default on BTC
Date: Mon, 15 Sep 2014 15:09:27 -0700
Message-Id: <1410818997-9432-158-git-send-email-kamal@canonical.com>
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

commit c08abf11900e19b14dd3a0cc3d105bd74519cd18 upstream.

This patch depends on:
e07929810f0a19ddd756558290c7d72827cbfcd9
(drm/radeon/dpm: fix typo in vddci setup for eg/btc)

bugs:
https://bugs.freedesktop.org/show_bug.cgi?id=73053
https://bugzilla.kernel.org/show_bug.cgi?id=68571

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_pm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_pm.c b/drivers/gpu/drm/radeon/radeon_pm.c
index 5a5925c..b19ac0d 100644
--- a/drivers/gpu/drm/radeon/radeon_pm.c
+++ b/drivers/gpu/drm/radeon/radeon_pm.c
@@ -1271,9 +1271,6 @@ int radeon_pm_init(struct radeon_device *rdev)
 	case CHIP_RS780:
 	case CHIP_RS880:
 	case CHIP_RV770:
-	case CHIP_BARTS:
-	case CHIP_TURKS:
-	case CHIP_CAICOS:
 	case CHIP_BONAIRE:
 	case CHIP_KABINI:
 	case CHIP_KAVERI:
@@ -1301,6 +1298,9 @@ int radeon_pm_init(struct radeon_device *rdev)
 	case CHIP_PALM:
 	case CHIP_SUMO:
 	case CHIP_SUMO2:
+	case CHIP_BARTS:
+	case CHIP_TURKS:
+	case CHIP_CAICOS:
 	case CHIP_CAYMAN:
 	case CHIP_ARUBA:
 	case CHIP_TAHITI:
-- 
1.9.1

