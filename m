Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab3JVI20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 04:28:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:23986 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164Ab3JVI2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 04:28:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,546,1378882800"; 
   d="scan'208";a="415004975"
From: Vinod Koul <vinod.koul@intel.com>
To: dmaengine@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH] MAINTAINERS: add the new dmaengine mailing list
Date: Tue, 22 Oct 2013 13:04:12 +0530
Message-Id: <1382427252-26470-1-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have a new mailing list hosted by vger for dmaengine

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 MAINTAINERS |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8a0cbf3..3ebb49b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2718,6 +2718,7 @@ T:	git git://git.linaro.org/people/sumitsemwal/linux-dma-buf.git
 DMA GENERIC OFFLOAD ENGINE SUBSYSTEM
 M:	Vinod Koul <vinod.koul@intel.com>
 M:	Dan Williams <dan.j.williams@intel.com>
+L:	dmaengine@vger.kernel.org
 S:	Supported
 F:	drivers/dma/
 F:	include/linux/dma*
-- 
1.7.0.4

