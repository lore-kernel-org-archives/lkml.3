Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575AbaK2MdQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 07:33:16 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:41511 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbaK2MdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 07:33:14 -0500
From: Athira S <athirasnamby@gmail.com>
To: gregkh@linuxfoundation.org
Cc: soren.brinkmann@xilinx.com, laurent.pinchart@ideasonboard.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Athira S <athirasnamby@gmail.com>
Subject: [PATCH] Drivers:staging:clocking-wizard: Added a newline
Date: Sat, 29 Nov 2014 18:03:06 +0530
Message-Id: <1417264386-18257-1-git-send-email-athirasnamby@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

