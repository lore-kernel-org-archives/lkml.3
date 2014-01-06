Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337AbaAFWjL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:39:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47615 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932192AbaAFWjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:39:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.12 080/144] drm/radeon: 0x9649 is SUMO2 not SUMO
Date: Mon,  6 Jan 2014 14:37:21 -0800
Message-Id: <20140106223747.651398341@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit d00adcc8ae9e22eca9d8af5f66c59ad9a74c90ec upstream.

Fixes rendering corruption due to incorrect
gfx configuration.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=63599

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/drm/drm_pciids.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/drm/drm_pciids.h
+++ b/include/drm/drm_pciids.h
@@ -588,7 +588,7 @@
 	{0x1002, 0x9645, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_SUMO2|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x9647, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_SUMO|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP},\
 	{0x1002, 0x9648, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_SUMO|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP},\
-	{0x1002, 0x9649, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_SUMO|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP},\
+	{0x1002, 0x9649, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_SUMO2|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP},\
 	{0x1002, 0x964a, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_SUMO|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x964b, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_SUMO|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x964c, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_SUMO|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \


