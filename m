Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416AbaI3VsZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:48:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32845 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165AbaI3Vii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:38:38 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 034/103] drm/radeon: add new KV pci id
Date: Tue, 30 Sep 2014 14:30:39 -0700
Message-Id: <1412112708-27356-35-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 6dc14baf4ced769017c7a7045019c7a19f373865 upstream.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=82912

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/cik.c | 1 +
 include/drm/drm_pciids.h     | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index 1523902..4c5828b 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -3231,6 +3231,7 @@ static void cik_gpu_init(struct radeon_device *rdev)
 			   (rdev->pdev->device == 0x130B) ||
 			   (rdev->pdev->device == 0x130E) ||
 			   (rdev->pdev->device == 0x1315) ||
+			   (rdev->pdev->device == 0x1318) ||
 			   (rdev->pdev->device == 0x131B)) {
 			rdev->config.cik.max_cu_per_sh = 4;
 			rdev->config.cik.max_backends_per_se = 1;
diff --git a/include/drm/drm_pciids.h b/include/drm/drm_pciids.h
index 49376ae..c99e0ad9 100644
--- a/include/drm/drm_pciids.h
+++ b/include/drm/drm_pciids.h
@@ -17,6 +17,7 @@
 	{0x1002, 0x1315, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_KAVERI|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x1316, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_KAVERI|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x1317, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_KAVERI|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x1318, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_KAVERI|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x131B, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_KAVERI|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x131C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_KAVERI|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x131D, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_KAVERI|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
-- 
1.9.1

