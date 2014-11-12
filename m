Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933015AbaKLBgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:36:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59805 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933846AbaKLBgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:36:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.17 288/319] drm/radeon: remove invalid pci id
Date: Wed, 12 Nov 2014 10:17:06 +0900
Message-Id: <20141112011040.536914278@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 8c3e434769b1707fd2d24de5a2eb25fedc634c4a upstream.

0x4c6e is a secondary device id so should not be used
by the driver.

Noticed-by: Mark Kettenis <mark.kettenis@xs4all.nl>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/drm/drm_pciids.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/drm/drm_pciids.h
+++ b/include/drm/drm_pciids.h
@@ -74,7 +74,6 @@
 	{0x1002, 0x4C64, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RV250|RADEON_IS_MOBILITY}, \
 	{0x1002, 0x4C66, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RV250|RADEON_IS_MOBILITY}, \
 	{0x1002, 0x4C67, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RV250|RADEON_IS_MOBILITY}, \
-	{0x1002, 0x4C6E, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RV280|RADEON_IS_MOBILITY}, \
 	{0x1002, 0x4E44, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_R300}, \
 	{0x1002, 0x4E45, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_R300}, \
 	{0x1002, 0x4E46, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_R300}, \


