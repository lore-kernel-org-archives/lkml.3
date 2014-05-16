Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535AbaEPMVg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 08:21:36 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53623 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756405AbaEPMSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 08:18:09 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <nsekhar@ti.com>, <joelf@ti.com>, <arnd@arndb.de>
CC: <linux@arm.linux.org.uk>, <vinod.koul@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <tony@atomide.com>,
        <bcousson@baylibre.com>
Subject: [PATCH v3 05/13] ARM/platform_data: edma: Remove queue_tc_mapping data from edma_soc_info
Date: Fri, 16 May 2014 15:17:12 +0300
Message-ID: <1400242640-9902-6-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1400242640-9902-1-git-send-email-peter.ujfalusi@ti.com>
References: <1400242640-9902-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is no longer in use by the driver or board files.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 include/linux/platform_data/edma.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/platform_data/edma.h b/include/linux/platform_data/edma.h
index 12f134b1493c..633e196ebdf2 100644
--- a/include/linux/platform_data/edma.h
+++ b/include/linux/platform_data/edma.h
@@ -175,7 +175,6 @@ struct edma_soc_info {
 	/* Resource reservation for other cores */
 	struct edma_rsv_info	*rsv;
 
-	s8	(*queue_tc_mapping)[2];
 	s8	(*queue_priority_mapping)[2];
 	const s16	(*xbar_chans)[2];
 };
-- 
1.9.3

