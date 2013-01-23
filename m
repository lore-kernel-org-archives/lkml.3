Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420Ab3AWQEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 11:04:09 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44475 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756368Ab3AWQEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 11:04:07 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/5] extcon: arizona: Remove duplicate rate configuration
Date: Thu, 24 Jan 2013 00:03:47 +0800
Message-Id: <1358957029-5421-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358957029-5421-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1358957029-5421-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 5283034..ab8b9c7 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -1003,10 +1003,6 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 		goto err_micdet;
 	}
 
-	regmap_update_bits(arizona->regmap, ARIZONA_MIC_DETECT_1,
-			   ARIZONA_MICD_RATE_MASK,
-			   8 << ARIZONA_MICD_RATE_SHIFT);
-
 	arizona_clk32k_enable(arizona);
 	regmap_update_bits(arizona->regmap, ARIZONA_JACK_DETECT_DEBOUNCE,
 			   ARIZONA_JD1_DB, ARIZONA_JD1_DB);
-- 
1.7.10.4

