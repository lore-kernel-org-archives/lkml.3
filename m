Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526Ab3LJXff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 18:35:35 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:37879 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab3LJXf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 18:35:28 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 4/8] mfd: ssbi: Mark match table const
Date: Tue, 10 Dec 2013 15:35:19 -0800
Message-Id: <1386718523-2587-5-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.1.109.g3d252a9
In-Reply-To: <1386718523-2587-1-git-send-email-sboyd@codeaurora.org>
References: <1386718523-2587-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a read-only data structure.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/mfd/ssbi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/ssbi.c b/drivers/mfd/ssbi.c
index dd1d28f..b78942e 100644
--- a/drivers/mfd/ssbi.c
+++ b/drivers/mfd/ssbi.c
@@ -317,7 +317,7 @@ static int ssbi_probe(struct platform_device *pdev)
 	return of_platform_populate(np, NULL, NULL, &pdev->dev);
 }
 
-static struct of_device_id ssbi_match_table[] = {
+static const struct of_device_id ssbi_match_table[] = {
 	{ .compatible = "qcom,ssbi" },
 	{}
 };
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

