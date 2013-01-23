Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298Ab3AWPiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 10:38:18 -0500
Received: from mga03.intel.com ([143.182.124.21]:47809 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756086Ab3AWPiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 10:38:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,523,1355126400"; 
   d="scan'208";a="194342975"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 0/4] dw_dmac: return proper residue value
Date: Wed, 23 Jan 2013 17:37:28 +0200
Message-Id: <1358955452-20960-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch series is targeted for getting proper residue value.

Since v1:
 - everything is rewritten to address Viresh's and Vinod's comments.

Andy Shevchenko (4):
  dw_dmac: remove unnecessary tx_list field in dw_dma_chan
  dw_dmac: introduce total_len field in struct dw_desc
  dw_dmac: fill individual length of descriptor
  dw_dmac: return proper residue value

 drivers/dma/dw_dmac.c      |   86 ++++++++++++++++++++++++++++++++++++--------
 drivers/dma/dw_dmac_regs.h |    3 +-
 2 files changed, 74 insertions(+), 15 deletions(-)

-- 
1.7.10.4

