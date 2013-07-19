Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759631Ab3GSDoI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 23:44:08 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:62641 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759570Ab3GSDoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 23:44:06 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: vinod.koul@intel.com
Cc: linux-kernel@vger.kernel.org, andriy.shevchenko@linux.intel.com,
        spear-devel@list.st.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] dmaengine/MAINTAINERS: Add Andy as Co-Maintainer of DW DMA Controller
Date: Fri, 19 Jul 2013 09:13:58 +0530
Message-Id: <db631755ca657e2841de51e72304fa6598c98508.1373970214.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy has done enough work on Synopsys Designware DMA Controller and I believe he
should Co-Maintain this driver along with me. So this patch.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5d3facf..a4d57d9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7111,6 +7111,7 @@ F:	drivers/tty/serial
 
 SYNOPSYS DESIGNWARE DMAC DRIVER
 M:	Viresh Kumar <viresh.linux@gmail.com>
+M:	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
 S:	Maintained
 F:	include/linux/dw_dmac.h
 F:	drivers/dma/dw/
-- 
1.7.12.rc2.18.g61b472e

