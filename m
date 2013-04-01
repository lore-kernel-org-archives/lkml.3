Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501Ab3DACsU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 22:48:20 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:35676 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211Ab3DACsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 22:48:19 -0400
Message-ID: <1364784493.7725.1.camel@phoenix>
Subject: [PATCH 1/2] pwm: mxs: Remove unused *dev from struct mxs_pwm_chip
From: Axel Lin <axel.lin@ingics.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org
Date: Mon, 01 Apr 2013 10:48:13 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pwm/pwm-mxs.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/pwm/pwm-mxs.c b/drivers/pwm/pwm-mxs.c
index a53d309..23d5180 100644
--- a/drivers/pwm/pwm-mxs.c
+++ b/drivers/pwm/pwm-mxs.c
@@ -38,7 +38,6 @@
 
 struct mxs_pwm_chip {
 	struct pwm_chip chip;
-	struct device *dev;
 	struct clk *clk;
 	void __iomem *base;
 };
@@ -166,7 +165,6 @@ static int mxs_pwm_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	mxs->dev = &pdev->dev;
 	platform_set_drvdata(pdev, mxs);
 
 	stmp_reset_block(mxs->base);
-- 
1.7.10.4



