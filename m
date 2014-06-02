Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299AbaFBLoh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 07:44:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:30334 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075AbaFBLoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 07:44:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,956,1392192000"; 
   d="scan'208";a="439803208"
From: Chew Chiau Ee <chiau.ee.chew@intel.com>
To: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org,
        devicetree@vger.kernel.org, Chew Chiau Ee <chiau.ee.chew@intel.com>
Subject: [PATCH 2/2] clkdev: Export clk_register_clkdev
Date: Tue,  3 Jun 2014 03:46:19 +0800
Message-Id: <1401738379-4107-3-git-send-email-chiau.ee.chew@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1401738379-4107-1-git-send-email-chiau.ee.chew@intel.com>
References: <1401738379-4107-1-git-send-email-chiau.ee.chew@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Darren Hart <dvhart@linux.intel.com>

Allow spi-pxa2xx-pci with common clock framework support to build as a
module by exporting clk_register_clkdev.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Reviewed-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/clk/clkdev.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
index a360b2e..bb48348 100644
--- a/drivers/clk/clkdev.c
+++ b/drivers/clk/clkdev.c
@@ -310,6 +310,7 @@ int clk_register_clkdev(struct clk *clk, const char *con_id,
 
 	return 0;
 }
+EXPORT_SYMBOL(clk_register_clkdev);
 
 /**
  * clk_register_clkdevs - register a set of clk_lookup for a struct clk
-- 
1.7.4.4

