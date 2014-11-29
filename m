Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669AbaK2M4C (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 07:56:02 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:44082 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbaK2M4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 07:56:00 -0500
From: Anjana Sasindran <anjanasasindran123@gmail.com>
To: gregkh@linuxfoundation.org, soren.brinkmann@xilinx.com,
        laurent.pinchart@ideasonboard.com
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Anjana Sasindran <anjanasasindran123@gmail.com>
Subject: [PATCH]  staging:drivers:staging:clocking-wizard:clk-xlnx-clock-wizard.c: Added a line after declaration
Date: Sat, 29 Nov 2014 18:25:30 +0530
Message-Id: <1417265730-5489-1-git-send-email-anjanasasindran123@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix the checkpatch.pl warning

WARNING:Missing a blank line after declaration

Signed-off-by: Anjana Sasindran <anjanasasindran123@gmail.com>
---
 drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c b/drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c
index 7202d8e..5fa813d 100644
--- a/drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c
+++ b/drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c
@@ -234,6 +234,7 @@ static int clk_wzrd_probe(struct platform_device *pdev)
 	/* register div per output */
 	for (i = WZRD_NUM_OUTPUTS - 1; i >= 0 ; i--) {
 		const char *clkout_name;
+		
 		if (of_property_read_string_index(np, "clock-output-names", i,
 						  &clkout_name)) {
 			dev_err(&pdev->dev,
-- 
1.9.1

