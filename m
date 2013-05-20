Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab3ETLQ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 07:16:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56081 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610Ab3ETKws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:52:48 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 037/115] drm/radeon: add new richland pci ids
Date: Mon, 20 May 2013 11:50:37 +0100
Message-Id: <1369047116-9378-38-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 62d1f92e06aef9665d71ca7e986b3047ecf0b3c7 upstream.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/ni.c | 6 ++++--
 include/drm/drm_pciids.h    | 2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/ni.c b/drivers/gpu/drm/radeon/ni.c
index 09853ac..137b1f5 100644
--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -471,7 +471,8 @@ static void cayman_gpu_init(struct radeon_device *rdev)
 		    (rdev->pdev->device == 0x990F) ||
 		    (rdev->pdev->device == 0x9910) ||
 		    (rdev->pdev->device == 0x9917) ||
-		    (rdev->pdev->device == 0x9999)) {
+		    (rdev->pdev->device == 0x9999) ||
+		    (rdev->pdev->device == 0x999C)) {
 			rdev->config.cayman.max_simds_per_se = 6;
 			rdev->config.cayman.max_backends_per_se = 2;
 		} else if ((rdev->pdev->device == 0x9903) ||
@@ -480,7 +481,8 @@ static void cayman_gpu_init(struct radeon_device *rdev)
 			   (rdev->pdev->device == 0x990D) ||
 			   (rdev->pdev->device == 0x990E) ||
 			   (rdev->pdev->device == 0x9913) ||
-			   (rdev->pdev->device == 0x9918)) {
+			   (rdev->pdev->device == 0x9918) ||
+			   (rdev->pdev->device == 0x999D)) {
 			rdev->config.cayman.max_simds_per_se = 4;
 			rdev->config.cayman.max_backends_per_se = 2;
 		} else if ((rdev->pdev->device == 0x9919) ||
diff --git a/include/drm/drm_pciids.h b/include/drm/drm_pciids.h
index 481825a..56650b7 100644
--- a/include/drm/drm_pciids.h
+++ b/include/drm/drm_pciids.h
@@ -593,6 +593,8 @@
 	{0x1002, 0x9999, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x999A, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x999B, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x999C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x999D, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x99A0, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x99A2, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x99A4, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
-- 
1.8.1.2

