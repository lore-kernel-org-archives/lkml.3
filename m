Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547AbbA0AJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 19:09:19 -0500
Received: from 8bytes.org ([81.169.241.247]:51304 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753462AbbA0AJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 19:09:16 -0500
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: Will Deacon <will.deacon@arm.com>, Kukjin Kim <kgene@kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Heiko Stuebner <heiko@sntech.de>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Robin Murphy <robin.murphy@arm.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joerg Roedel <joro@8bytes.org>, jroedel@suse.de
Subject: [PATCH 1/5] iommu: Add default domain to iommu-groups
Date: Tue, 27 Jan 2015 01:08:55 +0100
Message-Id: <1422317339-22620-2-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422317339-22620-1-git-send-email-joro@8bytes.org>
References: <1422317339-22620-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/iommu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index e66cc08..34636eb 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -51,6 +51,7 @@ struct iommu_group {
 	void (*iommu_data_release)(void *iommu_data);
 	char *name;
 	int id;
+	struct iommu_domain *default_domain;
 };
 
 struct iommu_device {
-- 
1.9.1

