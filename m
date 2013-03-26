Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964806Ab3CZOyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 10:54:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:4498 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933632Ab3CZOyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 10:54:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,911,1355126400"; 
   d="scan'208";a="219034912"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 0/4] dw_dmac: cleanup for DT usage
Date: Tue, 26 Mar 2013 16:53:53 +0200
Message-Id: <1364309637-25860-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It includes few cleanups when used with DT. Patch 4/4 is a modified version of
the [1].

[1] http://www.spinics.net/lists/arm-kernel/msg225366.html

Since v1:
 - address Arnd's comments
 - apply Acks I got from Viresh

Andy Shevchenko (3):
  dw_dmac: fix style of the comments
  dw_dmac: rename DT related methods to reflect their belonging
  dw_dmac: make wrapper on of_dma_controller_register()

Arnd Bergmann (1):
  dmaengine: dw_dmac: simplify master selection

 drivers/dma/dw_dmac.c      | 145 +++++++++++++++++++++------------------------
 drivers/dma/dw_dmac_regs.h |   5 +-
 2 files changed, 71 insertions(+), 79 deletions(-)

-- 
1.8.2.rc0.22.gb3600c3

