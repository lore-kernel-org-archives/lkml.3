Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338Ab3IBIcq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 04:32:46 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:41044 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273Ab3IBIco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:32:44 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, vinod.koul@intel.com,
        linus.walleij@linaro.org
Subject: [PATCH 1/2] dma: ste_dma40: Remove duplicate const
Date: Mon,  2 Sep 2013 13:44:58 +0530
Message-Id: <1378109699-25245-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'const' was added twice.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/dma/ste_dma40.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 7bbcabb..df0a606 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3485,7 +3485,7 @@ static int __init d40_of_probe(struct platform_device *pdev,
 {
 	struct stedma40_platform_data *pdata;
 	int num_phy = 0, num_memcpy = 0, num_disabled = 0;
-	const const __be32 *list;
+	const __be32 *list;
 
 	pdata = devm_kzalloc(&pdev->dev,
 			     sizeof(struct stedma40_platform_data),
-- 
1.7.9.5

