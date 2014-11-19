Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbaKSL2X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 06:28:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34952 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbaKSL2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 06:28:22 -0500
From: Gerd Hoffmann <kraxel@redhat.com>
To: dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, Gerd Hoffmann <kraxel@redhat.com>,
        David Airlie <airlied@linux.ie>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/4] bochs: little cleanup
Date: Wed, 19 Nov 2014 12:28:09 +0100
Message-Id: <1416396492-23214-2-git-send-email-kraxel@redhat.com>
In-Reply-To: <1416396492-23214-1-git-send-email-kraxel@redhat.com>
References: <1416396492-23214-1-git-send-email-kraxel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop some leftover, commented code.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/gpu/drm/bochs/bochs_hw.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bochs/bochs_hw.c b/drivers/gpu/drm/bochs/bochs_hw.c
index dbe619e..e8b1dac 100644
--- a/drivers/gpu/drm/bochs/bochs_hw.c
+++ b/drivers/gpu/drm/bochs/bochs_hw.c
@@ -54,8 +54,7 @@ int bochs_hw_init(struct drm_device *dev, uint32_t flags)
 	unsigned long addr, size, mem, ioaddr, iosize;
 	u16 id;
 
-	if (/* (ent->driver_data == BOCHS_QEMU_STDVGA) && */
-	    (pdev->resource[2].flags & IORESOURCE_MEM)) {
+	if (pdev->resource[2].flags & IORESOURCE_MEM) {
 		/* mmio bar with vga and bochs registers present */
 		if (pci_request_region(pdev, 2, "bochs-drm") != 0) {
 			DRM_ERROR("Cannot request mmio region\n");
-- 
1.8.3.1

