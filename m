Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790AbbAAKkO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 05:40:14 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:37442 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbbAAKkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 05:40:09 -0500
From: Richard Cochran <richardcochran@gmail.com>
To: <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH net-next 2/7] bnx2x: convert to CYCLECOUNTER_MASK macro.
Date: Thu,  1 Jan 2015 11:39:56 +0100
Message-Id: <1abe118084e21fd1e84502ff344cada70d3fdcb1.1420108214.git.richardcochran@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20141231.183347.862533634176009078.davem@davemloft.net>
References: <20141231.183347.862533634176009078.davem@davemloft.net>
In-Reply-To: <cover.1420108214.git.richardcochran@gmail.com>
References: <cover.1420108214.git.richardcochran@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 2c95132..0758c8b 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -14610,7 +14610,7 @@ static void bnx2x_init_cyclecounter(struct bnx2x *bp)
 {
 	memset(&bp->cyclecounter, 0, sizeof(bp->cyclecounter));
 	bp->cyclecounter.read = bnx2x_cyclecounter_read;
-	bp->cyclecounter.mask = CLOCKSOURCE_MASK(64);
+	bp->cyclecounter.mask = CYCLECOUNTER_MASK(64);
 	bp->cyclecounter.shift = 1;
 	bp->cyclecounter.mult = 1;
 }
-- 
1.7.10.4

