Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbaJMNHD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 09:07:03 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:50415 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301AbaJMNG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 09:06:56 -0400
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: will.deacon@arm.com, kvmarm@lists.cs.columbia.edu,
        iommu@lists.linux-foundation.org, jroedel@suse.de
Cc: alex.williamson@redhat.com, tech@virtualopensystems.com,
        christoffer.dall@linaro.org, eric.auger@linaro.org,
        kim.phillips@freescale.com, marc.zyngier@arm.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thierry Reding <treding@nvidia.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        "Upinder Malhi (umalhi)" <umalhi@cisco.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/3] iommu: add capability IOMMU_CAP_NOEXEC
Date: Mon, 13 Oct 2014 15:06:17 +0200
Message-Id: <1413205579-6124-3-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413205579-6124-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1413205579-6124-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some IOMMUs accept an IOMMU_NOEXEC protection flag in addition to
IOMMU_READ and IOMMU_WRITE. Expose this as an IOMMU capability.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
Acked-by: Joerg Roedel <jroedel@suse.de>
---
 include/linux/iommu.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 5f6f71c..ba026f1 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -61,6 +61,7 @@ enum iommu_cap {
 	IOMMU_CAP_CACHE_COHERENCY,	/* IOMMU can enforce cache coherent DMA
 					   transactions */
 	IOMMU_CAP_INTR_REMAP,		/* IOMMU supports interrupt isolation */
+	IOMMU_CAP_NOEXEC,		/* IOMMU_NOEXEC flag */
 };
 
 /*
-- 
2.1.1

