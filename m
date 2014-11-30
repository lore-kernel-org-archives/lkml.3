Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbaK3IkF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 03:40:05 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:53935 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbaK3IkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 03:40:04 -0500
From: Athira Sharikkal <athirasnamby@gmail.com>
To: gregkh@linuxfoundation.org
Cc: soren.brinkmann@xilinx.com, laurent.pinchart@ideasonboard.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Athira S <athirasnamby@gmail.com>
Subject: [PATCH] Drivers:staging:clocking-wizard: Added a newline
Date: Sun, 30 Nov 2014 14:09:51 +0530
Message-Id: <1417336791-11437-1-git-send-email-athirasnamby@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Athira S <athirasnamby@gmail.com>

Fixed checkpatch warning:
Missing a newline after declarations

Signed-off-by: Athira S <athirasnamby@gmail.com>
---
 drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c b/drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c
index 7202d8e..bb01cb8 100644
--- a/drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c
+++ b/drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c
@@ -248,6 +248,7 @@ static int clk_wzrd_probe(struct platform_device *pdev)
 				clkout_name, clk_name, 0, 1, reg);
 		if (IS_ERR(clk_wzrd->clkout[i])) {
 			int j;
+
 			for (j = i + 1; j < WZRD_NUM_OUTPUTS; j++)
 				clk_unregister(clk_wzrd->clkout[j]);
 			dev_err(&pdev->dev,
-- 
1.9.1

