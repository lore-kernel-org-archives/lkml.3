Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933050AbaFLJll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 05:41:41 -0400
Received: from mail-pa0-f67.google.com ([209.85.220.67]:52974 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932845AbaFLJlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 05:41:39 -0400
From: Jimmy P <jimmyp11f155@gmail.com>
To: Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sachin Kamat <sachin.kamat@linaro.org>
Cc: Jimmy P <jimmyp11f155@gmail.com>, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: iio: fix coding style
Date: Thu, 12 Jun 2014 17:42:43 +0800
Message-Id: <1402566163-9860-1-git-send-email-jimmyp11f155@gmail.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes coding style errors reported by checkpatch.pl for
lines that was over 80 chars long. The macro value shoud be put in () as
well.

Signed-off-by: Jimmy P <jimmyp11f155@gmail.com>
---
 drivers/staging/iio/frequency/ad5930.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/iio/frequency/ad5930.c b/drivers/staging/iio/frequency/ad5930.c
index a4aeee6..95a3550 100644
--- a/drivers/staging/iio/frequency/ad5930.c
+++ b/drivers/staging/iio/frequency/ad5930.c
@@ -21,7 +21,7 @@
 
 #define DRV_NAME "ad5930"
 
-#define value_mask (u16)0xf000
+#define value_mask ((u16)0xf000)
 #define addr_shift 12
 
 /* Register format: 4 bits addr + 12 bits value */
@@ -52,12 +52,15 @@ static ssize_t ad5930_set_parameter(struct device *dev,
 
 	config->control = (config->control & ~value_mask);
 	config->incnum = (config->control & ~value_mask) | (1 << addr_shift);
-	config->frqdelt[0] = (config->control & ~value_mask) | (2 << addr_shift);
+	config->frqdelt[0] = (config->control & ~value_mask) |
+				(2 << addr_shift);
 	config->frqdelt[1] = (config->control & ~value_mask) | 3 << addr_shift;
 	config->incitvl = (config->control & ~value_mask) | 4 << addr_shift;
 	config->buritvl = (config->control & ~value_mask) | 8 << addr_shift;
-	config->strtfrq[0] = (config->control & ~value_mask) | 0xc << addr_shift;
-	config->strtfrq[1] = (config->control & ~value_mask) | 0xd << addr_shift;
+	config->strtfrq[0] = (config->control & ~value_mask) |
+				0xc << addr_shift;
+	config->strtfrq[1] = (config->control & ~value_mask) |
+				0xd << addr_shift;
 
 	xfer.len = len;
 	xfer.tx_buf = config;
-- 
2.0.0

