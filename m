Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935333AbaICXHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:07:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46069 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933755AbaICWSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:18:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.16 064/125] drm/radeon: add new KV pci id
Date: Wed,  3 Sep 2014 15:07:01 -0700
Message-Id: <20140903220625.607079574@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220623.649748296@linuxfoundation.org>
References: <20140903220623.649748296@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 6dc14baf4ced769017c7a7045019c7a19f373865 upstream.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=82912

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/cik.c |    1 +
 include/drm/drm_pciids.h     |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -3320,6 +3320,7 @@ static void cik_gpu_init(struct radeon_d
 			   (rdev->pdev->device == 0x130B) ||
 			   (rdev->pdev->device == 0x130E) ||
 			   (rdev->pdev->device == 0x1315) ||
+			   (rdev->pdev->device == 0x1318) ||
 			   (rdev->pdev->device == 0x131B)) {
 			rdev->config.cik.max_cu_per_sh = 4;
 			rdev->config.cik.max_backends_per_se = 1;
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


