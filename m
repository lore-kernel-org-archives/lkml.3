Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199AbaGBPbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 11:31:13 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:55163 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755527AbaGBP3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 11:29:41 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, linus.walleij@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 09/12] mfd: 88pm860x-i2c: Repair 'space before tab' warning
Date: Wed,  2 Jul 2014 16:28:41 +0100
Message-Id: <1404314924-23564-10-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1404314924-23564-1-git-send-email-lee.jones@linaro.org>
References: <1404314924-23564-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes checkpatch warning:

    WARNING: please, no space before tabs
    #5: FILE: drivers/mfd/88pm860x-i2c.c:5:
    + * ^IHaojian Zhuang <haojian.zhuang@marvell.com>$

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/88pm860x-i2c.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/88pm860x-i2c.c b/drivers/mfd/88pm860x-i2c.c
index ff8f803..a93b4d0 100644
--- a/drivers/mfd/88pm860x-i2c.c
+++ b/drivers/mfd/88pm860x-i2c.c
@@ -2,7 +2,8 @@
  * I2C driver for Marvell 88PM860x
  *
  * Copyright (C) 2009 Marvell International Ltd.
- * 	Haojian Zhuang <haojian.zhuang@marvell.com>
+ *
+ * Author: Haojian Zhuang <haojian.zhuang@marvell.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
-- 
1.8.3.2

