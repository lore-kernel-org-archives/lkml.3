Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab3IEWWs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 18:22:48 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:33634 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699Ab3IEWWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 18:22:44 -0400
From: Zi Shen Lim <zishen.lim@linaro.org>
To: alex.williamson@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc: Zi Shen Lim <zishen.lim@linaro.org>
Subject: [PATCH] vfio: fix documentation
Date: Thu,  5 Sep 2013 15:22:17 -0700
Message-Id: <1378419737-4154-1-git-send-email-zishen.lim@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Zi Shen Lim <zishen.lim@linaro.org>
---
 Documentation/vfio.txt | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/vfio.txt b/Documentation/vfio.txt
index d7993dc..b9ca023 100644
--- a/Documentation/vfio.txt
+++ b/Documentation/vfio.txt
@@ -167,8 +167,8 @@ group and can access them as follows:
 	int container, group, device, i;
 	struct vfio_group_status group_status =
 					{ .argsz = sizeof(group_status) };
-	struct vfio_iommu_x86_info iommu_info = { .argsz = sizeof(iommu_info) };
-	struct vfio_iommu_x86_dma_map dma_map = { .argsz = sizeof(dma_map) };
+	struct vfio_iommu_type1_info iommu_info = { .argsz = sizeof(iommu_info) };
+	struct vfio_iommu_type1_dma_map dma_map = { .argsz = sizeof(dma_map) };
 	struct vfio_device_info device_info = { .argsz = sizeof(device_info) };
 
 	/* Create a new container */
@@ -193,7 +193,7 @@ group and can access them as follows:
 	ioctl(group, VFIO_GROUP_SET_CONTAINER, &container);
 
 	/* Enable the IOMMU model we want */
-	ioctl(container, VFIO_SET_IOMMU, VFIO_TYPE1_IOMMU)
+	ioctl(container, VFIO_SET_IOMMU, VFIO_TYPE1_IOMMU);
 
 	/* Get addition IOMMU info */
 	ioctl(container, VFIO_IOMMU_GET_INFO, &iommu_info);
@@ -229,7 +229,7 @@ group and can access them as follows:
 
 		irq.index = i;
 
-		ioctl(device, VFIO_DEVICE_GET_IRQ_INFO, &reg);
+		ioctl(device, VFIO_DEVICE_GET_IRQ_INFO, &irq);
 
 		/* Setup IRQs... eventfds, VFIO_DEVICE_SET_IRQS */
 	}
-- 
1.8.1.2

