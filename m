Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406Ab3I2TbO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:31:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59901 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756250Ab3I2TaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:30:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 41/71] drm/radeon: add berlin pci ids
Date: Sun, 29 Sep 2013 12:27:53 -0700
Message-Id: <20130929192646.296917947@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929192643.539596256@linuxfoundation.org>
References: <20130929192643.539596256@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 0431b2742f8e7755f3bbf5924900d12973412e94 upstream.

This adds the pci ids for the berlin GPU core.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/drm/drm_pciids.h |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/include/drm/drm_pciids.h
+++ b/include/drm/drm_pciids.h
@@ -1,4 +1,22 @@
 #define radeon_PCI_IDS \
+	{0x1002, 0x1304, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_KAVERI|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x1305, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_KAVERI|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x1306, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_KAVERI|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x1307, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_KAVERI|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x1309, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_KAVERI|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x130A, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_KAVERI|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x130B, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_KAVERI|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x130C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_KAVERI|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x130D, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_KAVERI|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x130E, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_KAVERI|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x130F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_KAVERI|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x1310, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_KAVERI|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x1311, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_KAVERI|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x1313, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_KAVERI|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x1315, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_KAVERI|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x1316, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_KAVERI|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x131B, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_KAVERI|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x131C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_KAVERI|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x3150, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RV380|RADEON_IS_MOBILITY}, \
 	{0x1002, 0x3151, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RV380|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x3152, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RV380|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \


