Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab3BDL5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:57:21 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:58215 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033Ab3BDL5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:57:19 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Michel JAOUEN <michel.jaouen@stericsson.com>,
        Alexandre Torgue <alexandre.torgue@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 47/73] regulator: ab8500: Update AB9540 init masks
Date: Mon,  4 Feb 2013 11:54:02 +0000
Message-Id: <1359978868-28736-48-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michel JAOUEN <michel.jaouen@stericsson.com>

This patch ensures the initialisation masks for AB9540_REGUSYSCLKREQVALID1
and AB9540_REGUSYSCLKREQVALID1 are correctly defined.

Signed-off-by: Alexandre Torgue <alexandre.torgue@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Michel JAOUEN <michel.jaouen@stericsson.com>
Tested-by: Michel JAOUEN <michel.jaouen@stericsson.com>
Tested-by: Philippe LANGLAIS <philippe.langlais@stericsson.com>
---
 drivers/regulator/ab8500.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index ae2d755..0dfb4e5 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -1995,13 +1995,13 @@ static struct ab8500_reg_init ab9540_reg_init[] = {
 	 * ...
 	 * 0x80, SysClkReq8Valid1
 	 */
-	REG_INIT(AB9540_REGUSYSCLKREQVALID1,	0x03, 0x0f, 0xfe),
+	REG_INIT(AB9540_REGUSYSCLKREQVALID1,	0x03, 0x0f, 0xff),
 	/*
 	 * 0x02, SysClkReq2Valid2
 	 * ...
 	 * 0x80, SysClkReq8Valid2
 	 */
-	REG_INIT(AB9540_REGUSYSCLKREQVALID2,	0x03, 0x10, 0xfe),
+	REG_INIT(AB9540_REGUSYSCLKREQVALID2,	0x03, 0x10, 0xff),
 	/*
 	 * 0x01, Vaux4SwHPReqValid
 	 * 0x02, Vaux4HwHPReq2Valid
-- 
1.7.9.5

