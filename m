Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712Ab3BNJAj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 04:00:39 -0500
Received: from mga11.intel.com ([192.55.52.93]:7422 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756585Ab3BNJAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 04:00:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,662,1355126400"; 
   d="scan'208";a="290991600"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 0/6] dma: various fixes in different DMAC drivers
Date: Thu, 14 Feb 2013 11:00:14 +0200
Message-Id: <1360832420-6349-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patcset of independent fixes of the DMAC drivers. They are simple and
being understandable in their context.

Since v1:
 - address all comments
 - add ACKs
 - rebase on top of recent Vinod's next branch

Andy Shevchenko (6):
  dma: of-dma: protect list write operation by spin_lock
  dmaengine.h: remove redundant else keyword
  dma: coh901318: avoid unbalanced locking
  dma: coh901318: set residue only if dma is in progress
  edma: do not waste memory for dma_mask
  dma: tegra20-apb-dma: remove unnecessary assignment

 drivers/dma/coh901318.c       |    4 +++-
 drivers/dma/coh901318_lli.c   |    2 +-
 drivers/dma/edma.c            |    6 ++++--
 drivers/dma/of-dma.c          |    2 ++
 drivers/dma/tegra20-apb-dma.c |    1 -
 include/linux/dmaengine.h     |    4 ++--
 6 files changed, 12 insertions(+), 7 deletions(-)

-- 
1.7.10.4

