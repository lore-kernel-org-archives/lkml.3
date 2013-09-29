Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab3I2T3v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:29:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59788 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756067Ab3I2T3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:29:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 50/71] drm/radeon: add some additional berlin pci ids
Date: Sun, 29 Sep 2013 12:28:02 -0700
Message-Id: <20130929192646.893726197@linuxfoundation.org>
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

commit 9a71677874d200865433647e9282fcf9fa6b05dd upstream.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/drm/drm_pciids.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/drm/drm_pciids.h
+++ b/include/drm/drm_pciids.h
@@ -12,11 +12,14 @@
 	{0x1002, 0x130F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_KAVERI|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x1310, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_KAVERI|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x1311, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_KAVERI|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x1312, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_KAVERI|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x1313, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_KAVERI|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x1315, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_KAVERI|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x1316, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_KAVERI|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x1317, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_KAVERI|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x131B, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_KAVERI|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x131C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_KAVERI|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x131D, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_KAVERI|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x3150, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RV380|RADEON_IS_MOBILITY}, \
 	{0x1002, 0x3151, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RV380|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x3152, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RV380|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \


