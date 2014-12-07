Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbaLGJFN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 04:05:13 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:34674 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbaLGJFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 04:05:02 -0500
From: Athira Lekshmi <andnlnbn18@gmail.com>
To: gregkh@linuxfoundation.org
Cc: soren.brinkmann@xilinx.com, laurent.pinchart@ideasonboard.com,
        devendra.aaru@gmail.com, athirasnamby@gmail.com,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Athira Lekshmi <andnlnbn18@gmail.com>
Subject: [PATCH] Clocking-wizard: Fixed missing blank line warning
Date: Sun,  7 Dec 2014 14:35:00 +0530
Message-Id: <1417943100-3723-1-git-send-email-andnlnbn18@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a new line after declaration to remove the warning
'Missing a blank line after declarations'

Signed-off-by: Athira Lekshmi <andnlnbn18@gmail.com>
---
 .../clocking-wizard/clk-xlnx-clock-wizard.c        |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c b/drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c
index 471d087..9a7b369 100644
--- a/drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c
+++ b/drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c
@@ -239,6 +239,7 @@ static int clk_wzrd_probe(struct platform_device *pdev)
 	/* register div per output */
 	for (i = WZRD_NUM_OUTPUTS - 1; i >= 0 ; i--) {
 		const char *clkout_name;
+
 		if (of_property_read_string_index(np, "clock-output-names", i,
 						  &clkout_name)) {
 			dev_err(&pdev->dev,
-- 
1.7.9.5

