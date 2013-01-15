Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab3AOM4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 07:56:51 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:53014 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756789Ab3AOM4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 07:56:48 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, sameo@linux.intel.com,
        Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 12/26] mfd: ab8500-debugfs: Use NULL to initialise remaining NULL pointer
Date: Tue, 15 Jan 2013 12:55:52 +0000
Message-Id: <1358254566-12419-13-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
References: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Partly for coding style reasons, but mostly because sparse warns on it.

This patch is a completion of a previous patch my Mark Brown.

Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/ab8500-debugfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index 03eacf1..4f36907 100644
--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -60,7 +60,7 @@ struct ab8500_prcmu_ranges {
 static struct ab8500_prcmu_ranges debug_ranges[AB8500_NUM_BANKS] = {
 	[0x0] = {
 		.num_ranges = 0,
-		.range = 0,
+		.range = NULL,
 	},
 	[AB8500_SYS_CTRL1_BLOCK] = {
 		.num_ranges = 3,
-- 
1.7.9.5

