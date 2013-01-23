Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160Ab3AWNpn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 08:45:43 -0500
Received: from mga14.intel.com ([143.182.124.37]:39394 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754374Ab3AWNpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 08:45:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,523,1355126400"; 
   d="scan'208";a="247459619"
Date: Wed, 23 Jan 2013 05:20:52 -0800
From: Vinod Koul <vinod.koul@intel.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, djbw@fb.com
Subject: [GIT PULL] slave-dmaengine fixes
Message-ID: <20130123132052.GE26562@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus

Please consider pull to receive few fixes on slave dmanengine.
There are trivial fixes in imx-dma, tegra-dma & ioat driver

The following changes since commit d1c3ed669a2d452cacfb48c2d171a1f364dae2ed:
  Linus Torvalds (1):
        Linux 3.8-rc2

are available in the git repository at:

  git://git.infradead.org/users/vkoul/slave-dma.git fixes

Javier Martin (1):
      dmaengine: imx-dma: Disable use of hw_chain to fix sg_dma transfers.

Laxman Dewangan (1):
      dma: tegra: implement flags parameters for cyclic transfer

Shuah Khan (1):
      ioat: Fix DMA memory sync direction correct flag

 drivers/dma/imx-dma.c         |    5 ++---
 drivers/dma/ioat/dma_v3.c     |    2 +-
 drivers/dma/tegra20-apb-dma.c |    8 ++++++--
 3 files changed, 9 insertions(+), 6 deletions(-)


The following changes since commit d1c3ed669a2d452cacfb48c2d171a1f364dae2ed:
  Linus Torvalds (1):
        Linux 3.8-rc2

are available in the git repository at:

  git://git.infradead.org/users/vkoul/slave-dma.git fixes

Javier Martin (1):
      dmaengine: imx-dma: Disable use of hw_chain to fix sg_dma transfers.

Laxman Dewangan (1):
      dma: tegra: implement flags parameters for cyclic transfer

Shuah Khan (1):
      ioat: Fix DMA memory sync direction correct flag

 drivers/dma/imx-dma.c         |    5 ++---
 drivers/dma/ioat/dma_v3.c     |    2 +-
 drivers/dma/tegra20-apb-dma.c |    8 ++++++--
 3 files changed, 9 insertions(+), 6 deletions(-)

--
~Vinod
