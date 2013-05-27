Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212Ab3E0MSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 08:18:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:32011 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932177Ab3E0MOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 08:14:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,750,1363158000"; 
   d="scan'208";a="343975676"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Li Yang <leoli@freescale.com>, Zhang Wei <zw@zh-kernel.org>,
        linuxppc-dev@lists.ozlabs.org, Stephen Warren <swarren@wwwdotorg.org>,
        linux-tegra@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 00/12] dma: various minor clean ups for slave drivers
Date: Mon, 27 May 2013 15:14:30 +0300
Message-Id: <1369656882-25241-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a set of small independent patches that clean up or fix minor things
across DMA slave drivers.

Andy Shevchenko (12):
  imx-sdma: remove useless variable
  mxs-dma: remove useless variable
  edma: no need to assign residue to 0 explicitly
  ep93xx_dma: remove useless use of lock
  fsldma: remove useless use of lock
  mmp_pdma: remove useless use of lock
  mpc512x_dma: remove useless use of lock
  pch_dma: remove useless use of lock
  tegra20-apb-dma: remove useless use of lock
  ipu_idmac: re-use dma_cookie_status()
  mmp_tdma: set cookies as well when asked for tx status
  txx9dmac: return DMA_SUCCESS immediately from device_tx_status()

 drivers/dma/edma.c            |  2 --
 drivers/dma/ep93xx_dma.c      | 10 +---------
 drivers/dma/fsldma.c          | 10 +---------
 drivers/dma/imx-sdma.c        |  9 +++------
 drivers/dma/ipu/ipu_idmac.c   |  5 +----
 drivers/dma/mmp_pdma.c        | 10 +---------
 drivers/dma/mmp_tdma.c        |  3 ++-
 drivers/dma/mpc512x_dma.c     | 10 +---------
 drivers/dma/mxs-dma.c         |  4 +---
 drivers/dma/pch_dma.c         |  9 +--------
 drivers/dma/tegra20-apb-dma.c |  8 +++-----
 drivers/dma/txx9dmac.c        | 13 ++++++-------
 12 files changed, 21 insertions(+), 72 deletions(-)

-- 
1.8.2.rc0.22.gb3600c3

