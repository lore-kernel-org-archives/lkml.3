Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153AbaHUViQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 17:38:16 -0400
Received: from 8bytes.org ([81.169.241.247]:32982 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103AbaHUViI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 17:38:08 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>, Joerg Roedel <jroedel@suse.de>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 0/2] More IOMMU Fixes
Date: Thu, 21 Aug 2014 23:37:23 +0200
Message-Id: <1408657045-4979-1-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here are two patches that fix valid issues discovered by
Coverity. Please review.

Thanks,

	Joerg

Joerg Roedel (2):
  iommu: Make iommu_group_get_for_dev() more robust
  iommu/vt-d: Check return value of acpi_bus_get_device()

 drivers/iommu/dmar.c  | 3 +--
 drivers/iommu/iommu.c | 8 +++++---
 2 files changed, 6 insertions(+), 5 deletions(-)

-- 
1.9.1

