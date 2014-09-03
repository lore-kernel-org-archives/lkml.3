Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbaICJze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:55:34 -0400
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:57292 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751573AbaICJzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:55:33 -0400
X-Greylist: delayed 1717 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Sep 2014 05:55:33 EDT
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 48/56] drm/radeon: add new KV pci id
Date: Wed,  3 Sep 2014 11:27:07 +0200
Message-Id: <ac2b1bd9835c088f1a591ec05ac93b6f28fb9b88.1409735865.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
References: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
In-Reply-To: <cover.1409735865.git.jslaby@suse.cz>
References: <cover.1409735865.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 6dc14baf4ced769017c7a7045019c7a19f373865 upstream.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=82912

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/radeon/cik.c | 1 +
 include/drm/drm_pciids.h     | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index 14836dfd04e7..85ef9ff42aa6 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -2745,6 +2745,7 @@ static void cik_gpu_init(struct radeon_device *rdev)
 			   (rdev->pdev->device == 0x130B) ||
 			   (rdev->pdev->device == 0x130E) ||
 			   (rdev->pdev->device == 0x1315) ||
+			   (rdev->pdev->device == 0x1318) ||
 			   (rdev->pdev->device == 0x131B)) {
 			rdev->config.cik.max_cu_per_sh = 4;
 			rdev->config.cik.max_backends_per_se = 1;
diff --git a/include/drm/drm_pciids.h b/include/drm/drm_pciids.h
index 0bd7a2ec8a45..8d32672681af 100644
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
2.1.0

