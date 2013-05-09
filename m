Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638Ab3EIWgo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:36:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46383 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758435Ab3EIWe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:34:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 22/26] drm/radeon: add new richland pci ids
Date: Thu,  9 May 2013 15:34:36 -0700
Message-Id: <20130509223424.771746547@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509223422.368544659@linuxfoundation.org>
References: <20130509223422.368544659@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 62d1f92e06aef9665d71ca7e986b3047ecf0b3c7 upstream.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/ni.c |    6 ++++--
 include/drm/drm_pciids.h    |    2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -668,7 +668,8 @@ static void cayman_gpu_init(struct radeo
 		    (rdev->pdev->device == 0x990F) ||
 		    (rdev->pdev->device == 0x9910) ||
 		    (rdev->pdev->device == 0x9917) ||
-		    (rdev->pdev->device == 0x9999)) {
+		    (rdev->pdev->device == 0x9999) ||
+		    (rdev->pdev->device == 0x999C)) {
 			rdev->config.cayman.max_simds_per_se = 6;
 			rdev->config.cayman.max_backends_per_se = 2;
 		} else if ((rdev->pdev->device == 0x9903) ||
@@ -677,7 +678,8 @@ static void cayman_gpu_init(struct radeo
 			   (rdev->pdev->device == 0x990D) ||
 			   (rdev->pdev->device == 0x990E) ||
 			   (rdev->pdev->device == 0x9913) ||
-			   (rdev->pdev->device == 0x9918)) {
+			   (rdev->pdev->device == 0x9918) ||
+			   (rdev->pdev->device == 0x999D)) {
 			rdev->config.cayman.max_simds_per_se = 4;
 			rdev->config.cayman.max_backends_per_se = 2;
 		} else if ((rdev->pdev->device == 0x9919) ||
--- a/include/drm/drm_pciids.h
+++ b/include/drm/drm_pciids.h
@@ -597,6 +597,8 @@
 	{0x1002, 0x9999, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x999A, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x999B, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x999C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x999D, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x99A0, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x99A2, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x99A4, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \


