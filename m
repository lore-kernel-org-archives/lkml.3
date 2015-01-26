Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287AbbAZXug (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 18:50:36 -0500
Received: from 8bytes.org ([81.169.241.247]:50697 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbbAZXue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 18:50:34 -0500
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>,
        Thierry Reding <treding@nvidia.com>,
        Varun Sethi <Varun.Sethi@freescale.com>, linux-kernel@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>, jroedel@suse.de
Subject: [PATCH 0/4] iommu: Small fixes and cleanups
Date: Tue, 27 Jan 2015 00:50:26 +0100
Message-Id: <1422316230-18893-1-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here are a couple of iommu fixes and cleanups to fix compile
errors and some warnings on ARM and PPC.

Regards,

	Joerg

Joerg Roedel (4):
  iommu: Make more drivers depend on COMPILE_TEST
  iommu/exynos: Make driver depend on REGULATOR
  iommu/omap: Print phys_addr_t using %pa
  iommu/fsl: Use %pa to print phys_addr_t

 drivers/iommu/Kconfig      | 11 +++++++----
 drivers/iommu/fsl_pamu.c   |  4 ++--
 drivers/iommu/omap-iommu.c |  2 +-
 3 files changed, 10 insertions(+), 7 deletions(-)

-- 
1.9.1

