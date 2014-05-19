Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398AbaESQnM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 12:43:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52622 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751985AbaESQnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 12:43:11 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 3/3] mfd: arizona: Correct error message for addition of main IRQ chip
Date: Mon, 19 May 2014 17:35:29 +0100
Message-Id: <1400517329-1103-3-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1400517329-1103-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1400517329-1103-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-irq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/arizona-irq.c b/drivers/mfd/arizona-irq.c
index 88758ab..17102f5 100644
--- a/drivers/mfd/arizona-irq.c
+++ b/drivers/mfd/arizona-irq.c
@@ -285,7 +285,7 @@ int arizona_irq_init(struct arizona *arizona)
 				  IRQF_ONESHOT, -1, irq,
 				  &arizona->irq_chip);
 	if (ret != 0) {
-		dev_err(arizona->dev, "Failed to add AOD IRQs: %d\n", ret);
+		dev_err(arizona->dev, "Failed to add main IRQs: %d\n", ret);
 		goto err_aod;
 	}
 
-- 
1.7.2.5

