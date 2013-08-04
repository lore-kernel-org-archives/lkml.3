Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab3HDOsE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 10:48:04 -0400
Received: from mga14.intel.com ([143.182.124.37]:35268 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845Ab3HDOsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 10:48:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,812,1367996400"; 
   d="scan'208";a="277491042"
Date: Sun, 4 Aug 2013 19:37:44 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Dan Williams <djbw@fb.com>,
        Vinod Koul <vinod.koul@intel.com>
Subject: [GIT PULL] slave-dmaengine fixes
Message-ID: <20130804140744.GO29095@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

Please pull to recieve two fixes for slave dmaengine. First fixes cyclic dma
transfers for pl330 and second one for returning correct error code on probe

The following changes since commit ad81f0545ef01ea651886dddac4bef6cec930092:
  Linus Torvalds (1):
        Linux 3.11-rc1

are available in the git repository at:

  git://git.infradead.org/users/vkoul/slave-dma.git fixes

Lars-Peter Clausen (1):
      dma: pl330: Fix cyclic transfers

Wei Yongjun (1):
      pch_dma: fix error return code in pch_dma_probe()

 drivers/dma/pch_dma.c |    1 +
 drivers/dma/pl330.c   |   93 +++++++++++++++++++++++++++++++++++--------------
 2 files changed, 68 insertions(+), 26 deletions(-)


Thanks
~Vinod
-- 
