Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775Ab3FBGCo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 02:02:44 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35293 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab3FBGCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 02:02:38 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        David Brown <davidb@codeaurora.org>
Subject: [PATCH 1/2] mfd: ssbi: Add MODULE_DEVICE_TABLE
Date: Sat,  1 Jun 2013 23:02:34 -0700
Message-Id: <1370152955-14841-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.rc3.8.g5e49f30.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows the ssbi module to be autoloaded on boot.

Cc: David Brown <davidb@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/mfd/ssbi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/ssbi.c b/drivers/mfd/ssbi.c
index f32da02..e561d3b 100644
--- a/drivers/mfd/ssbi.c
+++ b/drivers/mfd/ssbi.c
@@ -350,6 +350,7 @@ static struct of_device_id ssbi_match_table[] = {
 	{ .compatible = "qcom,ssbi" },
 	{}
 };
+MODULE_DEVICE_TABLE(of, ssbi_match_table);
 
 static struct platform_driver ssbi_driver = {
 	.probe		= ssbi_probe,
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

