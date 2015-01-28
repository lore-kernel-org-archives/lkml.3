Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761841AbbA1Epm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:45:42 -0500
Received: from mail.kernel.org ([198.145.29.136]:40327 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964938AbbA1EXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:23:24 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 110/177] drm/radeon: remove invalid pci id
Date: Wed, 28 Jan 2015 12:09:28 +0800
Message-Id: <1422418236-12852-201-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 8c3e434769b1707fd2d24de5a2eb25fedc634c4a upstream.

0x4c6e is a secondary device id so should not be used
by the driver.

Noticed-by: Mark Kettenis <mark.kettenis@xs4all.nl>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 include/drm/drm_pciids.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/drm/drm_pciids.h b/include/drm/drm_pciids.h
index 757f980..53baa0d 100644
--- a/include/drm/drm_pciids.h
+++ b/include/drm/drm_pciids.h
@@ -56,7 +56,6 @@
 	{0x1002, 0x4C64, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RV250|RADEON_IS_MOBILITY}, \
 	{0x1002, 0x4C66, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RV250|RADEON_IS_MOBILITY}, \
 	{0x1002, 0x4C67, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RV250|RADEON_IS_MOBILITY}, \
-	{0x1002, 0x4C6E, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RV280|RADEON_IS_MOBILITY}, \
 	{0x1002, 0x4E44, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_R300}, \
 	{0x1002, 0x4E45, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_R300}, \
 	{0x1002, 0x4E46, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_R300}, \
-- 
1.9.1

