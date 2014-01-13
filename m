Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597AbaAMOq5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:46:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51423 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbaAMO0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:26:19 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 54/96] drm/radeon: 0x9649 is SUMO2 not SUMO
Date: Mon, 13 Jan 2014 14:24:17 +0000
Message-Id: <1389623099-18783-55-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
References: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.29 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit d00adcc8ae9e22eca9d8af5f66c59ad9a74c90ec upstream.

Fixes rendering corruption due to incorrect
gfx configuration.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=63599

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/drm/drm_pciids.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/drm/drm_pciids.h b/include/drm/drm_pciids.h
index 56650b7..0522998 100644
--- a/include/drm/drm_pciids.h
+++ b/include/drm/drm_pciids.h
@@ -540,7 +540,7 @@
 	{0x1002, 0x9645, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_SUMO2|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x9647, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_SUMO|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP},\
 	{0x1002, 0x9648, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_SUMO|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP},\
-	{0x1002, 0x9649, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_SUMO|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP},\
+	{0x1002, 0x9649, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_SUMO2|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP},\
 	{0x1002, 0x964a, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_SUMO|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x964b, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_SUMO|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x964c, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_SUMO|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
-- 
1.8.3.2

