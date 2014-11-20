Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063AbaKTHbv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 02:31:51 -0500
Received: from mga14.intel.com ([192.55.52.115]:48689 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbaKTHbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 02:31:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="419114070"
Date: Thu, 20 Nov 2014 13:02:56 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dma <dmaengine@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] dmaengine fixes
Message-ID: <20141120073256.GD2074@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

We have couple of fixes for dmaengine queued up, please consider pull to
receive:
- dma mempcy fix for dma configuration of sun6i by Maxime
- pl330 got rest. First the fixing allocation for data buffers by Liviu and
  then Jon's fixed for fifo width and usage


The following changes since commit 0df1f2487d2f0d04703f142813d53615d62a1da4:
  Linus Torvalds (1):
        Linux 3.18-rc3

are available in the git repository at:

  git://git.infradead.org/users/vkoul/slave-dma.git fixes

Jon Medhurst (2):
      dmaengine: pl330: Align DMA memcpy operations to MFIFO width
      dmaengine: pl330: Limit MFIFO usage for memcpy to avoid exhausting entries

Liviu Dudau (1):
      dmaengine: Fix allocation size for PL330 data buffer depth.

Maxime Ripard (1):
      dmaengine: sun6i: Fix memcpy operation

 drivers/dma/pl330.c     |   23 ++++++++++++-----
 drivers/dma/sun6i-dma.c |   61 +++++++++++++++++++++++------------------------
 2 files changed, 46 insertions(+), 38 deletions(-)

Thanks
-- 
~Vinod
