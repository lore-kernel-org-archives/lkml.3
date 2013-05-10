Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946Ab3EJRML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 13:12:11 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:56413 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495Ab3EJRMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 13:12:09 -0400
From: Olof Johansson <olof@lixom.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: [PATCH] mfd: max77687: add registration of max77686-clk
Date: Fri, 10 May 2013 10:11:59 -0700
Message-Id: <1368205919-32538-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.1.192.gc4361b8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MAX77686 clock driver has been in-tree for over 6 months, but never
actually enabled through the MFD registration before.

Add it to the table so the device will probe and configure properly.

Signed-off-by: Olof Johansson <olof@lixom.net>
---
 drivers/mfd/max77686.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
index 1cbb176..5bd2467 100644
--- a/drivers/mfd/max77686.c
+++ b/drivers/mfd/max77686.c
@@ -37,6 +37,7 @@
 static struct mfd_cell max77686_devs[] = {
 	{ .name = "max77686-pmic", },
 	{ .name = "max77686-rtc", },
+	{ .name = "max77686-clk", },
 };
 
 static struct regmap_config max77686_regmap_config = {
-- 
1.8.2.1

