Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbaHRWuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 18:50:04 -0400
Received: from 8bytes.org ([81.169.241.247]:40672 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234AbaHRWuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 18:50:02 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: joro@8bytes.org
Subject: [PATCH 0/3] IOMMU Fixes
Date: Tue, 19 Aug 2014 00:49:56 +0200
Message-Id: <1408402199-15178-1-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here are a few fixes for the x86 iommu drivers and a small
one for the iommu core-code I plan to send for -rc2.


	Joerg

Joerg Roedel (3):
  iommu/vt-d: Defer domain removal if device is assigned to a driver
  iommu/amd: Fix cleanup_domain for mass device removal
  iommu/core: Check for the right function pointer in iommu_map()

 drivers/iommu/amd_iommu.c   | 10 ++++++----
 drivers/iommu/intel-iommu.c |  8 ++++++++
 drivers/iommu/iommu.c       |  2 +-
 3 files changed, 15 insertions(+), 5 deletions(-)

-- 
1.9.1

