Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043AbaLUCeQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 21:34:16 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:65233 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbaLUCeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 21:34:11 -0500
From: Mohammad Jamal <md.jamalmohiuddin@gmail.com>
To: gregkh@linuxfoundation.org
Cc: soren.brinkmann@xilinx.com, laurent.pinchart@ideasonboard.com,
        md.jamalmohiuddin@gmail.com, devendra.aaru@gmail.com,
        athirasnamby@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: clocking-wizard: Added a blank line after declaration
Date: Sun, 21 Dec 2014 08:03:48 +0530
Message-Id: <1419129228-5333-1-git-send-email-md.jamalmohiuddin@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the coding style issue by adding blank line after declaration

Signed-off-by: Mohammad Jamal <md.jamalmohiuddin@gmail.com>
---
 .../clocking-wizard/clk-xlnx-clock-wizard.c        |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c b/drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c
index 471d087..ea8d561 100644
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

