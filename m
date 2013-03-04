Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932900Ab3CDXJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 18:09:31 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11274 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932547Ab3CDXIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 18:08:31 -0500
X-IronPort-AV: E=Sophos;i="4.84,783,1355126400"; 
   d="scan'208";a="27434820"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH/RESEND 2/4] mmc: msm_sdcc: Remove unnecessary include
Date: Mon,  4 Mar 2013 15:08:26 -0800
Message-Id: <1362438508-26614-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.9.7.1.ge545
In-Reply-To: <1362438508-26614-1-git-send-email-sboyd@codeaurora.org>
References: <1362438508-26614-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver has no reason to include msm_iomap.h. Remove it so
that we can remove msm_iomap.h from include/mach in the near future.

Acked-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/mmc/host/msm_sdcc.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mmc/host/msm_sdcc.c b/drivers/mmc/host/msm_sdcc.c
index 7c0af0e..0ee4a57 100644
--- a/drivers/mmc/host/msm_sdcc.c
+++ b/drivers/mmc/host/msm_sdcc.c
@@ -43,7 +43,6 @@
 #include <asm/sizes.h>
 
 #include <linux/platform_data/mmc-msm_sdcc.h>
-#include <mach/msm_iomap.h>
 #include <mach/dma.h>
 #include <mach/clk.h>
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

