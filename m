Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933119Ab3BLK7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 05:59:17 -0500
Received: from mga01.intel.com ([192.55.52.88]:25915 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932785Ab3BLK7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 05:59:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,648,1355126400"; 
   d="scan'208";a="290016856"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 0/6] dma: various fixes in different DMAC drivers
Date: Tue, 12 Feb 2013 12:58:33 +0200
Message-Id: <1360666720-19006-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patcset of independent fixes of the DMAC drivers. They are simple and
being understandable in their context. 

Andy Shevchenko (6):
  of: dma: protect list write operation by spin_lock
  dmaengine.h: remove redundant else keyword
  dma: coh901318_lli: avoid unbalanced locking
  dma: coh901318_lli: set residue only if dma is in progress
  edma: do not waste memory for dma_mask
  dma: tegra20-apb-dma: remove unnecessary assignment

 drivers/dma/coh901318.c       |    4 +++-
 drivers/dma/coh901318_lli.c   |    2 +-
 drivers/dma/edma.c            |    6 ++++--
 drivers/dma/tegra20-apb-dma.c |    1 -
 drivers/of/dma.c              |    2 ++
 include/linux/dmaengine.h     |    3 +--
 6 files changed, 11 insertions(+), 7 deletions(-)

-- 
1.7.10.4

